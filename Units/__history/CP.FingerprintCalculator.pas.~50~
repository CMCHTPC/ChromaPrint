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
unit CP.FingerprintCalculator;

interface

uses
    Classes,
    CP.Def,
    CP.Classifier, CP.Image, CP.IntegralImage;

type

    { TFingerprintCalculator }

    TFingerprintCalculator = class
    private
        FMaxFilterWidth: integer;
        FClassifiers: TClassifierArray;
    public
        constructor Create(classifiers: TClassifierArray);
        destructor Destroy; override;
        function Calculate(Image: TImage): TUINT32Array;
        function CalculateSubfingerprint(Image: TIntegralImage; offset: integer): UInt32;
    end;

implementation

uses
    CP.Utils, Math
{$IFDEF FPC}
    , DaMath
{$ENDIF};

{ TFingerprintCalculator }

constructor TFingerprintCalculator.Create(classifiers: TClassifierArray);
var
    i: integer;
    n: integer;
begin
    FClassifiers := classifiers;
    n := Length(FClassifiers);
    FMaxFilterWidth := 0;
    for i := 0 to n - 1 do
    begin
        FMaxFilterWidth := Math.Max(FMaxFilterWidth, FClassifiers[i].filter.Width);
    end;
end;

destructor TFingerprintCalculator.Destroy;
begin

    inherited;
end;

function TFingerprintCalculator.Calculate(Image: TImage): TUINT32Array;
var
    lLength: integer;
    i: integer;
    lIntegralImage: TIntegralImage;
begin
    lLength := Image.NumRows - FMaxFilterWidth + 1;
    if (lLength <= 0) then
    begin
        { DEBUG("Chromaprint::FingerprintCalculator::Calculate() -- Not "
          << "enough data. Image has " << image->NumRows() << " rows, "
          << "needs at least " << m_max_filter_width << " rows."); }
        Result := nil; // vector<int32_t>();
        Exit;
    end;
    lIntegralImage := TIntegralImage.Create(Image);
    SetLength(Result, lLength);
    for i := 0 to lLength - 1 do
    begin
        Result[i] := CalculateSubfingerprint(lIntegralImage, i);
    end;
    lIntegralImage.Free;
end;

function TFingerprintCalculator.CalculateSubfingerprint(Image: TIntegralImage; offset: integer): UInt32;
var
    bits: UInt32;
    i: integer;
    n: integer;
begin
    bits := 0;
    n := Length(FClassifiers);
    for i := 0 to n - 1 do
    begin
        bits := (bits shl 2) or GrayCode(TClassifierArray(FClassifiers)[i].Classify(Image, offset));
    end;
    Result := bits;
end;

end.
