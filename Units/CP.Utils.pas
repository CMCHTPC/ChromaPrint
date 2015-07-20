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
unit CP.Utils;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def;

const
    CODES: array [0 .. 3] of byte = (0, 1, 3, 2);

function GrayCode(i: integer): UINT32; inline;

function EuclideanNorm(vector: TDoubleArray): double;
procedure NormalizeVector(var vector: TDoubleArray; norm: double; threshold: double = 0.01);

function FreqToIndex(freq: double; frame_size, sample_rate: integer): integer; // inline;
function IndexToFreq(i, frame_size, sample_rate: integer): double; // inline;
function FreqToOctave(freq: double; base: double = 440.0 / 16.0): double; // inline;

procedure PrepareHammingWindow(var Data: TDoubleArray);
procedure ApplyWindow(var Data: TDoubleArray; window: TDoubleArray; size: integer; scale: double);

implementation

uses
{$IFDEF FPC}
    DaMath;
{$ELSE}
Math;
{$ENDIF}

function FreqToOctave(freq: double; base: double = 440.0 / 16.0): double; // inline;
begin
    Result := log10(freq / base) / log10(2.0); // logarithmus dualis
end;

function IndexToFreq(i, frame_size, sample_rate: integer): double; // inline;
begin
    Result := i * sample_rate / frame_size;
end;

function FreqToIndex(freq: double; frame_size, sample_rate: integer): integer; // inline;
begin
    Result := round(frame_size * freq / sample_rate);
end;

function GrayCode(i: integer): UINT32; inline;
begin
    Result := CODES[i];
end;

procedure NormalizeVector(var vector: TDoubleArray; norm: double; threshold: double = 0.01);
var
    i: integer;
begin
    if (norm < threshold) then
    begin
        for i := 0 to Length(vector) - 1 do
        begin
            vector[i] := 0.0;
        end;
    end
    else
    begin
        for i := 0 to Length(vector) - 1 do
        begin
            vector[i] := vector[i] / norm;
        end;
    end;
end;

function EuclideanNorm(vector: TDoubleArray): double;
var
    squares, Value: double;
    i: integer;
begin
    squares := 0;
    for i := 0 to Length(vector) - 1 do
    begin
        Value := vector[i];
        squares := squares + Value * Value;
    end;
    if squares > 0 then
        Result := Sqrt(squares)
    else
        Result := 0;
end;

procedure PrepareHammingWindow(var Data: TDoubleArray);
var
    i, n: integer;
    scale: double;
begin
    n := Length(Data);
    scale := TwoMath_Pi / (n - 1);
    for i := 0 to n - 1 do
    begin
        Data[i] := 0.54 - 0.46 * cos(scale * i);
    end;
end;

procedure ApplyWindow(var Data: TDoubleArray; window: TDoubleArray; size: integer; scale: double);
var
    i: integer;
begin
    i := 0;
    while (i < size) do
    begin
        Data[i] := Data[i] * window[i] * scale;
        Inc(i);
    end;
end;

end.
