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
unit CP.Base64;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils;

const
    kBase64Chars: array [0 .. 65] of char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
    kBase64CharsReversed: array [0 .. 127] of byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 63, 0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
        48, 49, 50, 51, 0, 0, 0, 0, 0);

function Base64Encode(orig: string): string;
function Base64Decode(encoded: string): string;

implementation

function Base64Encode(orig: string): string;
var
    size: integer;
    encoded: string;
    src: integer;
    pos: integer;
begin
    size := length(orig);
    src := 1;
    encoded := '';
    while (size > 0) do
    begin
        pos := Ord(orig[src]);
        pos := (pos shr 2);
        encoded := encoded + kBase64Chars[pos];

        if size > 0 then
            encoded := encoded + kBase64Chars[((Ord(orig[src]) shl 4) or (Ord(orig[src + 1]) shr 4)) and 63]
        else
            encoded := encoded + kBase64Chars[((Ord(orig[src]) shl 4)) and 63];
        Dec(size);

        if (size > 0) then
        begin
            if size > 0 then
                encoded := encoded + kBase64Chars[((Ord(orig[src + 1]) shl 2) or (Ord(orig[src + 2]) shr 6)) and 63]
            else
                encoded := encoded + kBase64Chars[(Ord(orig[src + 1]) shl 2) and 63];
            Dec(size);
            if (size > 0) then
            begin
                encoded := encoded + kBase64Chars[Ord(orig[src + 2]) and 63];
                Dec(size);
            end;
        end;
        src := src + 3;
    end;
    Result := encoded;

end;

function Base64Decode(encoded: string): string;
var
    size, src: integer;
    b0, b1, r, b2, b3: integer;
begin
    size := length(encoded);
    src := 1;
    Result := '';

    while (size > 0) do
    begin

        b0 := kBase64CharsReversed[Ord(encoded[src])];
        inc(src);
        Dec(size);
        if (size > 0) then
        begin

            b1 := kBase64CharsReversed[Ord(encoded[src])];
            inc(src);
            r := (b0 shl 2) or (b1 shr 4);

            // assert(dest != str.end());
            Result := Result + chr(r);
            Dec(size);
            if (size > 0) then
            begin
                b2 := kBase64CharsReversed[Ord(encoded[src])];
                inc(src);

                r := ((b1 shl 4) and 255) or (b2 shr 2);
                // assert(dest != str.end());
                Result := Result + chr(r);
                Dec(size);
                if (size > 0) then
                begin
                    b3 := kBase64CharsReversed[Ord(encoded[src])];
                    inc(src);
                    r := ((b2 shl 6) and 255) or b3;
                    // assert(dest != str.end());
                    Result := Result + chr(r);
                    Dec(size);
                end;
            end;

        end;
    end;
end;

end.
