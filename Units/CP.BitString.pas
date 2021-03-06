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
unit CP.BitString;

interface

uses
    Classes, SysUtils;

type
    TBitStringWriter = class(TObject)
    private
        FValue: string;
        FBuffer: uint32;
        FBufferSize: integer;
    public
        property Value: string read FValue;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Flush;
        procedure Write(x: uint32; bits: integer);
    end;

    TBitStringReader = class(TObject)
    private
        FValue: string;
        FValueIter: integer;
        FBuffer: uint32;
        FBufferSize: integer;
        FEOF: boolean;
        function GetAvailableBits: integer;
    public
        property EOF: boolean read FEOF;
        property AvailableBits: integer read GetAvailableBits;
    public
        constructor Create(input: string);
        destructor Destroy; override;
        procedure Reset;
        function Read(bits: integer): uint32;
    end;

implementation

{ TBitStringWriter }

constructor TBitStringWriter.Create;
begin
    FBuffer := 0;
    FBufferSize := 0;
    FValue := '';
end;

destructor TBitStringWriter.Destroy;
begin

    inherited;
end;

procedure TBitStringWriter.Flush;
begin
    // C++ is pain
    while (FBufferSize > 0) do
    begin
        FValue := FValue + chr(FBuffer and 255);
        FBuffer := FBuffer shr 8;
        FBufferSize := FBufferSize - 8;
    end;
    FBufferSize := 0;
end;

procedure TBitStringWriter.Write(x: uint32; bits: integer);
begin
    FBuffer := FBuffer or (x shl FBufferSize);
    FBufferSize := FBufferSize + bits;
    while (FBufferSize >= 8) do
    begin
        FValue := FValue + chr(FBuffer and 255);
        FBuffer := FBuffer shr 8;
        FBufferSize := FBufferSize - 8;
    end;
end;

{ TBitStringReader }

constructor TBitStringReader.Create(input: string);
begin
    FValue := input;
    FBuffer := 0;
    FBufferSize := 0;
    FEOF := False;
    FValueIter := 1;
end;

destructor TBitStringReader.Destroy;
begin
    inherited;
end;

function TBitStringReader.GetAvailableBits: integer;
begin
    if FEOF then
        Result := 0
    else
    begin
        Result := FBufferSize + 8 * (Length(FValue) - FValueIter + 1);
    end;
end;

function TBitStringReader.Read(bits: integer): uint32;
var
    lValueByte: byte;
begin
    if (FBufferSize < bits) then
    begin
        if (FValueIter <= Length(FValue)) then
        begin
            lValueByte := Ord(FValue[FValueIter]);
            FBuffer := FBuffer or (lValueByte shl FBufferSize); // C++ is pain
            Inc(FValueIter);
            FBufferSize := FBufferSize + 8;
        end
        else
        begin
            FEOF := True;
        end;
    end;

    Result := FBuffer and ((1 shl bits) - 1);
    FBuffer := FBuffer shr bits;
    FBufferSize := FBufferSize - bits;

    if (FBufferSize <= 0) and (FValueIter > Length(FValue)) then
    begin
        FEOF := True;
    end;
end;

procedure TBitStringReader.Reset;
begin
    FBuffer := 0;
    FBufferSize := 0;
end;

end.
