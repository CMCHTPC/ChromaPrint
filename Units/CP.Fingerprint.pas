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
unit CP.Fingerprint;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def,
    CP.AudioConsumer, CP.SilenceRemover, CP.Image, CP.Chroma, CP.Filter,
    CP.Imagebuilder, CP.FeatureVectorConsumer, CP.FFT, CP.AudioProcessor,
    CP.FingerprintCalculator, CP.FingerprinterConfiguration;

type
    { TFingerprinter }

    TFingerprinter = class(TAudioConsumer)
    private
        FSilenceRemover: TSilenceRemover;
        FImage: TImage;
        FImageBuilder: TImageBuilder;
        FChroma: TChroma;
        FChromaNormalizer: TChromaNormalizer;
        FChromaFilter: TChromaFilter;
        FFFT: TFFT;
        FAudioProcessor: TAudioProcessor;
        FFingerprintCalculator: TFingerprintCalculator;
        FConfig: TFingerprinterConfiguration;
    public
        constructor Create(config: TFingerprinterConfiguration = nil);
        destructor Destroy; override;
        function SetOption(const Name: PWideChar; Value: integer): boolean;
        function Start(Sample_Rate, NumChannels: integer): boolean;
        function Finish: TUINT32Array;
        procedure Consume(Input: TSmallintArray; AOffset: integer; Length: integer); override;
    end;

implementation

{ TFingerprinter }

constructor TFingerprinter.Create(config: TFingerprinterConfiguration);
begin
    FImage := TImage.Create(12, 0);
    if (config = nil) then
        config := TFingerprinterConfigurationTest1.Create;

    FImageBuilder := TImageBuilder.Create(FImage);
    FChromaNormalizer := TChromaNormalizer.Create(FImageBuilder);
    FChromaFilter := TChromaFilter.Create(config.FilterCoefficients, config.NumFilterCoefficients, FChromaNormalizer);
    FChroma := TChroma.Create(cMIN_FREQ, cMAX_FREQ, cFRAME_SIZE, cSAMPLE_RATE, FChromaFilter);
    FFFT := TFFT.Create(cFRAME_SIZE, cOVERLAP, FChroma);
    if (config.RemoveSilence) then
    begin
        FSilenceRemover := TSilenceRemover.Create(FFFT);
        FSilenceRemover.threshold := config.SilenceThreshold;
        FAudioProcessor := TAudioProcessor.Create(cSAMPLE_RATE, FSilenceRemover);
    end
    else
    begin
        FSilenceRemover := nil;
        FAudioProcessor := TAudioProcessor.Create(cSAMPLE_RATE, FFFT);
    end;
    FFingerprintCalculator := TFingerprintCalculator.Create(config.classifiers);
    FConfig := config;
end;

destructor TFingerprinter.Destroy;
begin
    FConfig.Free;
    FFingerprintCalculator.Free;
    FAudioProcessor.Free;
    if (FSilenceRemover <> nil) then
        FSilenceRemover.Free;
    FFFT.Free;
    FChroma.Free;
    FChromaFilter.Free;
    FChromaNormalizer.Free;
    FImageBuilder.Free;
    FImage.Free;    inherited Destroy;
end;

function TFingerprinter.SetOption(const Name: PWideChar; Value: integer): boolean;
begin
    Result := False;
    if Name = 'silence_threshold' then
    begin
        if (FSilenceRemover <> nil) then
        begin
            FSilenceRemover.threshold := Value;
            Result := True;
        end;
    end;
end;

function TFingerprinter.Start(Sample_Rate, NumChannels: integer): boolean;
begin
    if (not FAudioProcessor.Reset(Sample_Rate, NumChannels)) then
    begin
        // FIXME save error message somewhere
        Result := False;
        Exit;
    end;
    FFFT.Reset();
    FChroma.Reset();
    FChromaFilter.Reset();
    FChromaNormalizer.Reset();
    if FImage <> nil then
        FImage.Free;
    FImage := TImage.Create(12); // XXX
    FImageBuilder.Reset(FImage);
    Result := True;
end;

function TFingerprinter.Finish: TUINT32Array;
begin
    FAudioProcessor.Flush();
    Result := FFingerprintCalculator.Calculate(FImage);
end;

procedure TFingerprinter.Consume(Input: TSmallintArray; AOffset: integer; Length: integer);
begin
    FAudioProcessor.Consume(Input, AOffset, Length);
end;

end.
