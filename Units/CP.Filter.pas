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

unit CP.Filter;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.IntegralImage;

type

    TComparator = function(a, b: double): double;
    { TFilter }

    TFilter = class(TObject)
    private
        FType: integer;
        FY: integer;
        FHeight: integer;
        FWidth: integer;
    public
        property _Type: integer read FType write FType;
        property Y: integer read FY write FY;
        property Height: integer read FHeight write FHeight;
        property Width: integer read FWidth write FWidth;

    public
        constructor Create(_Type: integer = 0; Y: integer = 0; Height: integer = 0; Width: integer = 0);
        function Apply(image: TIntegralImage; offset: integer): double;
    end;

implementation

uses
{$IFDEF FPC}
    DaMath;
{$ELSE}
Math;
{$ENDIF}
{ TFilter }

function Subtract(a, b: double): double; inline;
begin
    Result := a - b;
end;

function SubtractLog(a, b: double): double; inline;
var
    r: double;
begin
    r := ln(1.0 + a) - ln(1.0 + b);
    // assert(!IsNaN(r));
    Result := r;
end;

// oooooooooooooooo
// oooooooooooooooo
// oooooooooooooooo
// oooooooooooooooo
function Filter0(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
begin
    a := image.Area(x, Y, x + w - 1, Y + h - 1);
    b := 0;
    Result := cmp(a, b);
end;

// ................
// ................
// oooooooooooooooo
// oooooooooooooooo
function Filter1(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
    h_2: integer;
begin
    h_2 := h div 2;

    a := image.Area(x, Y + h_2, x + w - 1, Y + h - 1);
    b := image.Area(x, Y, x + w - 1, Y + h_2 - 1);

    Result := cmp(a, b);
end;

// .......ooooooooo
// .......ooooooooo
// .......ooooooooo
// .......ooooooooo
function Filter2(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
    w_2: integer;
begin
    w_2 := w div 2;

    a := image.Area(x + w_2, Y, x + w - 1, Y + h - 1);
    b := image.Area(x, Y, x + w_2 - 1, Y + h - 1);

    Result := cmp(a, b);
end;

// .......ooooooooo
// .......ooooooooo
// ooooooo.........
// ooooooo.........
function Filter3(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
    w_2, h_2: integer;
begin
    w_2 := w div 2;
    h_2 := h div 2;

    a := image.Area(x, Y + h_2, x + w_2 - 1, Y + h - 1) + image.Area(x + w_2, Y, x + w - 1, Y + h_2 - 1);
    b := image.Area(x, Y, x + w_2 - 1, Y + h_2 - 1) + image.Area(x + w_2, Y + h_2, x + w - 1, Y + h - 1);

    Result := cmp(a, b);
end;

// ................
// oooooooooooooooo
// ................
function Filter4(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
    h_3: integer;
begin
    h_3 := h div 3;

    a := image.Area(x, Y + h_3, x + w - 1, Y + 2 * h_3 - 1);
    b := image.Area(x, Y, x + w - 1, Y + h_3 - 1) + image.Area(x, Y + 2 * h_3, x + w - 1, Y + h - 1);

    Result := cmp(a, b);
end;

// .....oooooo.....
// .....oooooo.....
// .....oooooo.....
// .....oooooo.....
function Filter5(image: TIntegralImage; x, Y, w, h: integer; cmp: TComparator): double;
var
    a, b: double;
    w_3: integer;
begin
    w_3 := w div 3;

    a := image.Area(x + w_3, Y, x + 2 * w_3 - 1, Y + h - 1);
    b := image.Area(x, Y, x + w_3 - 1, Y + h - 1) + image.Area(x + 2 * w_3, Y, x + w - 1, Y + h - 1);

    Result := cmp(a, b);
end;

constructor TFilter.Create(_Type: integer; Y: integer; Height: integer; Width: integer);
begin
    FType := _Type;
    FY := Y;
    FHeight := Height;
    FWidth := Width;
end;

function TFilter.Apply(image: TIntegralImage; offset: integer): double;
begin
    case (FType) of
        0:
            Result := Filter0(image, offset, FY, FWidth, FHeight, SubtractLog);
        1:
            Result := Filter1(image, offset, FY, FWidth, FHeight, SubtractLog);
        2:
            Result := Filter2(image, offset, FY, FWidth, FHeight, SubtractLog);
        3:
            Result := Filter3(image, offset, FY, FWidth, FHeight, SubtractLog);
        4:
            Result := Filter4(image, offset, FY, FWidth, FHeight, SubtractLog);
        5:
            Result := Filter5(image, offset, FY, FWidth, FHeight, SubtractLog);
    else
        Result := 0.0;

    end;
end;

end.
