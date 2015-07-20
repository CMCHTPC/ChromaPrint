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
unit CP.Quantizer;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils;

type

    { TQuantizer }

    TQuantizer = class(TObject)
    private
        FT0, FT1, FT2: double;
    public
        property t0: double read FT0 write FT0;
        property t1: double read FT1 write FT1;
        property t2: double read FT2 write FT2;
    public
        constructor Create(t0: double = 0.0; t1: double = 0.0; t2: double = 0.0);
        function Quantize(Value: double): integer;
    end;

implementation

{ TQuantizer }

constructor TQuantizer.Create(t0: double; t1: double; t2: double);
begin
    FT0 := t0;
    FT1 := t1;
    FT2 := t2;
end;

function TQuantizer.Quantize(Value: double): integer;
begin
    if (Value < FT1) then
    begin
        if (Value < FT0) then
            Result := 0
        else
            Result := 1;
    end
    else
    begin
        if (Value < FT2) then
            Result := 2
        else
            Result := 3;
    end;
end;

end.
