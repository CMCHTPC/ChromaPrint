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
unit CP.Classifier;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.IntegralImage,
    CP.Filter, CP.Quantizer;

type
    { TClassifier }

    TClassifier = class(TObject)
    private
        FFilter: TFilter;
        FQuantizer: TQuantizer;
    public
        property Filter: TFilter read FFilter;
        property Quantizer: TQuantizer read FQuantizer;
    public
        constructor Create(Filter: TFilter = nil; Quantizer: TQuantizer = nil);
        destructor Destroy; override;
        function Classify(image: TIntegralImage; offset: integer): integer;
    end;

    TClassifierArray = array of TClassifier;

implementation

{ TClassifier }

constructor TClassifier.Create(Filter: TFilter; Quantizer: TQuantizer);
begin
    if Filter <> nil then
        FFilter := Filter
    else
        FFilter := TFilter.Create;
    if Quantizer <> nil then
        FQuantizer := Quantizer
    else
        FQuantizer := TQuantizer.Create;
end;

destructor TClassifier.Destroy;
begin
    FFilter.Free;
    FQuantizer.Free;
    inherited;
end;

function TClassifier.Classify(image: TIntegralImage; offset: integer): integer;
var
    Value: double;
begin
    Value := FFilter.Apply(image, offset);
    Result := FQuantizer.Quantize(Value);
end;

end.
