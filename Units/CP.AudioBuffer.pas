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
{$ENDREGION}
unit CP.AudioBuffer;

interface

uses
    Classes,
    CP.Def, CP.AudioConsumer;

type

    TAudioBuffer = class(TAudioConsumer)
    private
        FData: TSmallintArray;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Consume(Input: TSmallintArray; AOffset: integer; ALength: integer); override; // eigentlich abstract
        function Data: TSmallintArray;
        procedure Reset;
    end;

implementation

{ TAudioBuffer }

procedure TAudioBuffer.Consume(Input: TSmallintArray; AOffset: integer; ALength: integer);
var
    i, n: integer;
begin
    n := Length(FData);
    SetLength(FData, n + ALength - AOffset);
    for i := AOffset to ALength - 1 do
    begin
        FData[n + i - AOffset] := Input[i];
    end;
end;



constructor TAudioBuffer.Create;
begin
    SetLength(FData, 0);
end;



function TAudioBuffer.Data: TSmallintArray;
begin
    Result := FData;
end;



destructor TAudioBuffer.Destroy;
begin
    SetLength(FData, 0);
    inherited;
end;



procedure TAudioBuffer.Reset;
begin
    SetLength(FData, 0);
end;

end.
