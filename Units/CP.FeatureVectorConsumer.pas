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
unit CP.FeatureVectorConsumer;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def;

type
    { TFeatureVectorConsumer }

    TFeatureVectorConsumer = class(TObject)
    public
        constructor Create;
        destructor Destroy; override;
        procedure Consume(var features: TDoubleArray); virtual; abstract;
    end;

    { TChromaFilter }

    TChromaFilter = class(TFeatureVectorConsumer)
    private
        FBufferOffset: integer;
        FBufferSize: integer;
        FConsumer: TFeatureVectorConsumer;
        FCoefficients: TDoubleArray;
        FLength: integer;
        FBuffer: array of TDoubleArray;
        FResult: TDoubleArray;
    public
        property Consumer: TFeatureVectorConsumer read FConsumer write FConsumer;
    public
        constructor Create(coefficients: TDoubleArray; ALength: integer; Consumer: TFeatureVectorConsumer);
        destructor Destroy; override;
        procedure Reset;
        procedure Consume(var features: TDoubleArray); override;
    end;

    { TChromaNormalizer }

    TChromaNormalizer = class(TFeatureVectorConsumer)
    private
        FConsumer: TFeatureVectorConsumer;
    public
        constructor Create(Consumer: TFeatureVectorConsumer);
        destructor Destroy; override;
        procedure Reset;
        procedure Consume(var features: TDoubleArray); override;
    end;

    TChromaResampler = class(TFeatureVectorConsumer)
    private
        FResult: TDoubleArray;
        FConsumer: TFeatureVectorConsumer;
        FIteration: integer;
        FFactor: integer;
    public
        property Consumer: TFeatureVectorConsumer read FConsumer write FConsumer;
    public
        constructor Create(factor: integer; Consumer: TFeatureVectorConsumer);
        destructor Destroy; override;
        procedure Reset;
        procedure Consume(var features: TDoubleArray); override;

    end;

implementation

uses
    CP.Utils;

{ TChromaFilter }

constructor TChromaFilter.Create(coefficients: TDoubleArray; ALength: integer; Consumer: TFeatureVectorConsumer);
begin
    SetLength(FResult, 12);
    FCoefficients := coefficients;
    FLength := ALength;
    SetLength(FBuffer, 8);

    FBufferOffset := 0;
    FBufferSize := 1;
    FConsumer := Consumer;
end;

destructor TChromaFilter.Destroy;
begin
    SetLength(FResult, 0);
    FConsumer := nil;
    SetLength(FCoefficients, 0);
    inherited Destroy;
end;

procedure TChromaFilter.Reset;
begin
    FBufferSize := 1;
    FBufferOffset := 0;
end;

procedure TChromaFilter.Consume(var features: TDoubleArray);
var
    offset: integer;
    i, j: integer;
begin
    SetLength(FBuffer[FBufferOffset], length(features));
    for i := 0 to length(features) - 1 do
    begin
        FBuffer[FBufferOffset, i] := features[i];
    end;
    FBufferOffset := (FBufferOffset + 1) mod 8;
    if (FBufferSize >= FLength) then
    begin
        offset := (FBufferOffset + 8 - FLength) mod 8;
        for i := 0 to length(FResult) - 1 do
        begin
            FResult[i] := 0.0;
        end;
        for i := 0 to 11 do
        begin
            for j := 0 to FLength - 1 do
            begin

                FResult[i] := FResult[i] + FBuffer[(offset + j) mod 8, i] * FCoefficients[j];
            end;
        end;
        FConsumer.Consume(FResult);
    end
    else
    begin
        Inc(FBufferSize);
    end;
end;

{ TFeatureVectorConsumer }

constructor TFeatureVectorConsumer.Create;
begin

end;

destructor TFeatureVectorConsumer.Destroy;
begin
    inherited Destroy;
end;

{ TChromaNormalizer }

constructor TChromaNormalizer.Create(Consumer: TFeatureVectorConsumer);
begin
    FConsumer := Consumer;
end;

destructor TChromaNormalizer.Destroy;
begin
    FConsumer := nil;
    inherited Destroy;
end;

procedure TChromaNormalizer.Reset;
begin
    { nothing to do }
end;

procedure TChromaNormalizer.Consume(var features: TDoubleArray);
var
    norm: double;
begin
    norm := EuclideanNorm(features);
    NormalizeVector(features, norm, 0.01);
    FConsumer.Consume(features);
end;

constructor TChromaResampler.Create(factor: integer; Consumer: TFeatureVectorConsumer);
begin
    SetLength(FResult, 12);
    Reset;
    FFactor := factor;
    FConsumer := Consumer;
end;

destructor TChromaResampler.Destroy;
begin
    SetLength(FResult, 0);
    inherited Destroy;
end;

procedure TChromaResampler.Reset;
var
    i: integer;
begin
    FIteration := 0;
    for i := 0 to length(FResult) - 1 do
    begin
        FResult[i] := 0.0;
    end;
end;

procedure TChromaResampler.Consume(var features: TDoubleArray);
var
    i: integer;
begin
    for i := 0 to 11 do
    begin
        FResult[i] := FResult[i] + features[i];
    end;
    Inc(FIteration);
    if (FIteration = FFactor) then
    begin
        for i := 0 to 11 do
        begin
            FResult[i] := FResult[i] / FFactor;
        end;
        FConsumer.Consume(FResult);
        Reset();
    end;
end;

end.
