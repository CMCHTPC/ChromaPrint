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
unit CP.Image;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def;

type
    { TImage }

    TImage = class
    private
        FColumns: integer;
        FRows: integer;
        FData: array of array of double; // a very big array of doubles :)
    public
        property NumRows: integer read FRows;
        property NumColumns: integer read FColumns;
    public
        constructor Create(columns: integer; rows: integer = 0);
        destructor Destroy; override;
        procedure AddRow(Row: TDoubleArray);
        function GetData(Row, Column: integer): double;
        procedure SetData(Row, Column: integer; Value: double);
    end;

implementation

{ TImage }

constructor TImage.Create(columns: integer; rows: integer = 0);
var
    i: integer;
begin
    FColumns := columns; // 12 columns 0...x rows (variabel);
    FRows := rows;
    // dim the array correctly
    SetLength(FData, FRows);
    if FRows > 0 then
    begin
        for i := 0 to FRows - 1 do
        begin
            SetLength(FData[i], FColumns);
        end;
    end;
end;

destructor TImage.Destroy;
var
    i: integer;
begin
    for i := 0 to FRows - 1 do
    begin
        SetLength(FData[i], 0);
    end;
    SetLength(FData, 0);
    inherited;
end;

procedure TImage.AddRow(Row: TDoubleArray);
var
    i: integer;
begin
    // add a row and copy the values
    Inc(FRows);
    SetLength(FData, FRows);
    SetLength(FData[FRows - 1], FColumns);

    for i := 0 to FColumns - 1 do
    begin
        FData[FRows - 1, i] := Row[i];
    end;
end;

function TImage.GetData(Row, Column: integer): double;
begin
    Result := FData[Row][Column];
end;

procedure TImage.SetData(Row, Column: integer; Value: double);
begin
    FData[Row][Column] := Value;
end;

end.
