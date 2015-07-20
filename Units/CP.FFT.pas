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
unit CP.FFT;
{$IFDEF FPC}
{$MODE delphi}
{$DEFINE USE_FFT_LOMONT} // ffmpeg not ready in FPC now :(
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def, CP.AudioConsumer;

type

    { TFFTFrame }

    TFFTFrame = class(TObject)
    private
        FSize: integer;
    public
        property Size: integer read FSize;
    public
        Data: TDoubleArray;
        constructor Create(Size: integer);
        destructor Destroy; override;
        function Magnitude(i: integer): double;
        function Energy(i: integer): double;
    end;

    TFFTFrameConsumer = class(TObject)
    public
        procedure Consume(frame: TFFTFrame); virtual; abstract;
    end;

    TFFTLib = class(TObject)
    protected
        FWindow: TDoubleArray;
        FFrameSize: integer;
        FFrameSizeH: integer;
    public
        constructor Create(frame_size: integer; window: TDoubleArray);
        destructor Destroy; override;
        procedure ComputeFrame(input: TSmallintArray; var frame: TFFTFrame); virtual; abstract;
    end;

    { TFFT }

    TFFT = class(TAudioConsumer)
    private
        FBufferOffset: integer;
        FWindow: TDoubleArray;
        FFFTBuffer: TSmallintArray;
        FFrame: TFFTFrame;
        FFrameSize: integer;
        FIncrement: integer;
        FLib: TFFTLib;
        FConsumer: TFFTFrameConsumer;
    public
        property FrameSize: integer read FFrameSize;
    public
        constructor Create(frame_size: integer; overlap: integer; consumer: TFFTFrameConsumer);
        destructor Destroy; override;
        procedure Reset;
        procedure Consume(input: TSmallintArray; AOffset: integer; lLength: integer); override;
        function overlap: integer;
    end;

implementation

uses
    Windows, CP.Utils, CP.CombinedBuffer,
{$IFNDEF FPC}
    CP.AVFFT,
{$ENDIF}
    CP.LomontFFT;

{ TFFTFrame }

constructor TFFTFrame.Create(Size: integer);
begin
    FSize := Size;
    SetLength(Data, FSize);
end;

destructor TFFTFrame.Destroy;
begin
    SetLength(Data, 0);
    inherited Destroy;
end;

function TFFTFrame.Magnitude(i: integer): double;
begin
    Result := sqrt(Data[i]);
end;

function TFFTFrame.Energy(i: integer): double;
begin
    Result := Data[i];
end;

{ TFFT }

constructor TFFT.Create(frame_size: integer; overlap: integer; consumer: TFFTFrameConsumer);
var
    i: integer;
    j: integer;
begin
    SetLength(FWindow, frame_size);
    FBufferOffset := 0;
    SetLength(FFFTBuffer, frame_size);

    FFrame := TFFTFrame.Create(frame_size);
    FFrameSize := frame_size;
    FIncrement := frame_size - overlap;
    FConsumer := consumer;

    PrepareHammingWindow(FWindow);
    for i := 0 to frame_size - 1 do
    begin
        FWindow[i] := FWindow[i] / $7FFF;
    end;
{$IFDEF USE_FFT_LOMONT}
    FLib := TFFTLomont.Create(frame_size, FWindow);
{$ELSE}
    FLib := TFFTAV.Create(frame_size, FWindow);
{$ENDIF}
end;

destructor TFFT.Destroy;
begin
    FFrame.Free;
    FLib.Free;
    SetLength(FFFTBuffer, 0);
    SetLength(FWindow, 0);
    inherited;
end;

function TFFT.overlap: integer;
begin
    Result := FFrameSize - FIncrement;
end;

procedure TFFT.Reset;
begin
    FBufferOffset := 0;
end;

procedure TFFT.Consume(input: TSmallintArray; AOffset: integer; lLength: integer);
var
    lCombinedBuffer: TCombinedBuffer;
    lBuffer: TSmallintArray;
begin
    // Special case, just pre-filling the buffer
    if (FBufferOffset + lLength < FFrameSize) then
    begin
        Move(input[0], FFFTBuffer[FBufferOffset], lLength * SizeOf(smallint));
        FBufferOffset := FBufferOffset + lLength;
        Exit;
    end;
    // Apply FFT on the available data
    lCombinedBuffer := TCombinedBuffer.Create(FFFTBuffer, FBufferOffset, input, lLength);

    while (lCombinedBuffer.Size >= FFrameSize) do
    begin
        SetLength(lBuffer, FFrameSize);
        lCombinedBuffer.Read(lBuffer, 0, FFrameSize);

        FLib.ComputeFrame(lBuffer, FFrame);
        FConsumer.Consume(FFrame);
        lCombinedBuffer.Shift(FIncrement);
        SetLength(lBuffer, 0);
    end;
    // Copy the remaining input data to the internal buffer
    lCombinedBuffer.Flush(FFFTBuffer);
    FBufferOffset := lCombinedBuffer.Size();
    lCombinedBuffer.Free;
end;

{ TFFTLib }

constructor TFFTLib.Create;
begin

end;

destructor TFFTLib.Destroy;
begin

    inherited;
end;

end.
