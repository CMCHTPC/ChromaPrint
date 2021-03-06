{$REGION 'Copyright (C) CMC Development Team'}
{ **************************************************************************
  Copyright (C) 2015 CMC Development Team

  CMC is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
  (at your option) any later version.

  CMC is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with CMC. If not, see <http://www.gnu.org/licenses/>.
  ************************************************************************** }

{ **************************************************************************
  Additional Copyright (C) for this modul:

  Chromaprint: Audio fingerprinting toolkit
  Copyright (C) 2010-2012  Lukas Lalinsky <lalinsky@gmail.com>


  Lomont FFT: Fast Fourier Transformation
  Original code by Chris Lomont, 2010-2012, http://www.lomont.org/Software/


  ************************************************************************** }
{$ENDREGION}
{$REGION 'Notes'}
{ **************************************************************************

  See CP.Chromaprint.pas for more information

  ************************************************************************** }

unit CP.AudioProcessor;
{$IFDEF FPC}
{$MODE delphi}
{$ELSE}
{$DEFINE AVResample}
{$DEFINE FF_API_AVCODEC_RESAMPLE}
{$ENDIF}

interface

uses
    Classes, SysUtils,
{$IFDEF AVResample}
    libavcodec,
{$ELSE}
    CP.Resampler,
{$ENDIF}
    CP.AudioConsumer, CP.Def;

type
    { TAudioProcessor }

    TAudioProcessor = class(TAudioConsumer)
    private
        FBufferOffset: integer;
        FBufferSize: integer;
        FTargetSampleRate: integer;
        FNumChannels: integer;

        FResampleCTX: PAVResampleContext;
        FConsumer: TAudioConsumer;

        FBuffer: TSmallintArray;
        FResampleBuffer: TSmallintArray;
    private
        procedure Resample;
        function Load(input: TSmallintArray; offset: integer; ALength: integer): integer;
        procedure LoadMono(input: TSmallintArray; offset: integer; ALength: integer);
        procedure LoadStereo(input: TSmallintArray; offset: integer; ALength: integer);
        procedure LoadMultiChannel(input: TSmallintArray; offset: integer; ALength: integer);
    public
        property TargetSampleRate: integer read FTargetSampleRate write FTargetSampleRate;
        property consumer: TAudioConsumer read FConsumer write FConsumer;
    public
        constructor Create(SampleRate: integer; consumer: TAudioConsumer);
        destructor Destroy; override;
        function Reset(SampleRate, NumChannels: integer): boolean;
        procedure Flush;
        procedure Consume(input: TSmallintArray; AOffset: integer; ALength: integer); override;
    end;

implementation

uses
    CP.FFT, CP.SilenceRemover,
    Math
{$IFDEF FPC}
    , DaMath
{$ENDIF};

{ TAudioProcessor }

procedure TAudioProcessor.Resample;
var
    consumed, lLength: integer;
    remaining: integer;
begin
    // coding C++ is a pain
    if (FResampleCTX = nil) then
    begin
        FConsumer.Consume(FBuffer, 0, FBufferOffset);
        FBufferOffset := 0;
        Exit;
    end;
    consumed := 0;
{$IFDEF AVResample}
    lLength := av_resample(FResampleCTX, @FResampleBuffer[0], @FBuffer[0], @consumed, FBufferOffset, kMaxBufferSize, 1);
{$ELSE}
    lLength := FResampleCTX.Resample(FResampleBuffer, FBuffer, consumed, FBufferOffset, kMaxBufferSize, 1);
{$ENDIF}
    if (lLength > kMaxBufferSize) then
    begin
        // DEBUG("Chromaprint::AudioProcessor::Resample() -- Resampling overwrote output buffer.");
        lLength := kMaxBufferSize;
    end;
    FConsumer.Consume(FResampleBuffer, 0, lLength); // do the FFT now
    remaining := FBufferOffset - consumed;
    if (remaining > 0) then
    begin
        Move(FBuffer[consumed], FBuffer[0], remaining * SizeOf(smallint));
    end
    else if (remaining < 0) then
    begin
        // DEBUG("Chromaprint::AudioProcessor::Resample() -- Resampling overread input buffer.");
        remaining := 0;
    end;
    FBufferOffset := remaining;
end;

function TAudioProcessor.Load(input: TSmallintArray; offset: integer; ALength: integer): integer;
var
    lLength: integer;
begin
    lLength := Math.Min(ALength, FBufferSize - FBufferOffset);

    case (FNumChannels) of
        1:
            LoadMono(input, offset, lLength);
        2:
            LoadStereo(input, offset, lLength);
    else
        LoadMultiChannel(input, offset, lLength);

    end;
    FBufferOffset := FBufferOffset + lLength;
    Result := lLength;
end;

procedure TAudioProcessor.LoadMono(input: TSmallintArray; offset: integer; ALength: integer);
var
    i: integer;
begin
    i := FBufferOffset;
    while ALength > 0 do
    begin
        FBuffer[i] := input[offset];
        Inc(offset);
        Inc(i);
        Dec(ALength);
    end;

end;

procedure TAudioProcessor.LoadStereo(input: TSmallintArray; offset: integer; ALength: integer);
var
    i: integer;
begin
    i := FBufferOffset;
    while (ALength > 0) do
    begin
        FBuffer[i] := (input[offset] + input[offset + 1]) div 2;
        Inc(i);
        Inc(offset, 2);
        Dec(ALength);
    end;

end;

procedure TAudioProcessor.LoadMultiChannel(input: TSmallintArray; offset: integer; ALength: integer);
var
    sum: longint;
    i, j: integer;
begin
    i := FBufferOffset;
    while ALength > 0 do
    begin
        sum := 0;
        for j := 0 to FNumChannels - 1 do
        begin
            sum := sum + input[offset];
            Inc(offset);
        end;
        FBuffer[i] := sum div FNumChannels;
        Inc(i);
        Dec(ALength);
    end;
end;

constructor TAudioProcessor.Create(SampleRate: integer; consumer: TAudioConsumer);
begin
    FBufferSize := kMaxBufferSize;
    FTargetSampleRate := SampleRate;
    FConsumer := consumer;
    FResampleCTX := nil;
    SetLength(FBuffer, kMaxBufferSize);
    FBufferOffset := 0;
    SetLength(FResampleBuffer, kMaxBufferSize);
end;

destructor TAudioProcessor.Destroy;
begin
{$IFDEF AVResample}
    av_resample_close(FResampleCTX);
    FResampleCTX := nil;
{$ELSE}
    if FResampleCTX <> nil then
        Dispose(FResampleCTX);
{$ENDIF}
    SetLength(FBuffer, 0);
    SetLength(FResampleBuffer, 0);
    inherited Destroy;
end;

function TAudioProcessor.Reset(SampleRate, NumChannels: integer): boolean;
begin
    if (NumChannels <= 0) then
    begin
        // Debug.WriteLine("Chromaprint::AudioProcessor::Reset() -- No audio channels.");
        Result := False;
        Exit;
    end;

    if (SampleRate <= kMinSampleRate) then
    begin
        { Debug.WriteLine("Chromaprint::AudioProcessor::Reset() -- Sample rate less than 0 1,      kMinSampleRate, sample_rate); }
        Result := False;
        Exit;
    end;

    FBufferOffset := 0;

    if (FResampleCTX <> nil) then
    begin
{$IFDEF AVResample}
        av_resample_close(FResampleCTX);
        FResampleCTX := nil;
{$ELSE}
        Dispose(FResampleCTX);
        FResampleCTX := nil;
{$ENDIF}
    end;

    if (SampleRate <> FTargetSampleRate) then
    begin
{$IFDEF AVResample}
        FResampleCTX := av_resample_init(FTargetSampleRate, SampleRate, kResampleFilterLength, kResamplePhaseCount, kResampleLinear, kResampleCutoff);
{$ELSE}
        FResampleCTX := New(PAVResampleContext);
        FResampleCTX.Clear;
        FResampleCTX.Init(FTargetSampleRate, SampleRate, kResampleFilterLength, kResamplePhaseCount, kResampleLinear, kResampleCutoff);
{$ENDIF}
    end;

    FNumChannels := NumChannels;
    Result := True;
end;

procedure TAudioProcessor.Flush;
begin
    if (FBufferOffset <> 0) then
        Resample();
end;

procedure TAudioProcessor.Consume(input: TSmallintArray; AOffset: integer; ALength: integer);
var
    offset, consumed: integer;
    lLength: integer;
begin
    lLength := ALength div FNumChannels;
    offset := 0;
    while (lLength > 0) do
    begin
        consumed := Load(input, offset, lLength);
        offset := offset + consumed * FNumChannels;
        lLength := lLength - consumed;
        if (FBufferSize = FBufferOffset) then
        begin
            Resample();
            if (FBufferSize = FBufferOffset) then
            begin
                // DEBUG("Chromaprint::AudioProcessor::Consume() -- Resampling failed?");
                Exit;
            end;
        end;
    end;
end;

end.
