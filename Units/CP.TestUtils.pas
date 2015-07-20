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
unit CP.TestUtils;

interface

uses
    Windows, Classes, SysUtils,
    CP.Def;

const
    StartPath = '.\'; // adjust this to your configuration

function LoadAudioFile(filename: string): TSmallIntArray;
procedure CheckFingerprints(List: TStrings; actual, expected: TUINT32Array; expected_size: integer); inline;

implementation

function LoadAudioFile(filename: string): TSmallIntArray;
var
    lPath: string;
    data: TSmallIntArray;
    lLength: integer;
    fs: integer;
    lError, i, n: integer;
    lBuffer: PByte;
begin
    lPath := StartPath + filename;

    fs := FileOpen(lPath, fmOpenRead);
    lLength := SysUtils.FileSeek(fs, 0, 2);
    FileSeek(fs, 0, 0);
    lBuffer := System.AllocMem(lLength + 1);
    lError := FileRead(fs, lBuffer^, lLength);
    if lError = -1 then
        OutputDebugString('shit');
    FileClose(fs);

    n := lLength div 2;
    SetLength(data, n);
    for i := 0 to n - 1 do
    begin
        data[i] := lBuffer[i * 2] + lBuffer[i * 2 + 1] * 256;
    end;

    FreeMem(lBuffer);

    result := data;
end;

procedure CheckFingerprints(List: TStrings; actual, expected: TUINT32Array; expected_size: integer); inline;
var
    i: integer;
    error: boolean;
begin
    if expected_size = Length(actual) then
    begin
        List.Add('Length: OK');

        error := FALSE;
        for i := 0 to expected_size - 1 do
        begin
            if expected[i] <> expected[i] then
            begin
                List.Add('Different at index :' + IntToStr(i));
                error := TRUE;
            end;
        end;
        if not error then
        begin
            List.Add('All Values ok');
        end;
    end
    else
    begin
        List.Add('Length: NOT OK');
    end;
end;

end.
