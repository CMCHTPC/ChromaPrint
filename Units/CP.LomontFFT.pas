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

unit CP.LomontFFT;

// FFT implementation by Chris Lomont (http://www.lomont.org/Software/).
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    CP.Def, CP.FFT;

type

    { TFFTLomont }

    TFFTLomont = class(TFFTLib)
    private
        FInput: TDoubleArray;
        ForwardCos: TDoubleArray;
        ForwardSin: TDoubleArray;
        procedure ComputeTable(size: integer);
        procedure FFT(var Data: TDoubleArray);
        procedure RealFFT(var Data: TDoubleArray);
    public
        constructor Create(frame_size: integer; window: TDoubleArray);
        destructor Destroy; override;
        procedure ComputeFrame(input: TSmallintArray; var frame: TFFTFrame); override;
    end;

implementation

uses
    CP.Utils;

{ TFFTLomont }

// Call this with the size before using the FFT
// Fills in tables for speed
procedure TFFTLomont.ComputeTable(size: integer);
var
    i, n, mmax, istep, m: integer;
    theta, wr, wpr, wpi, wi, t: double;
begin
    SetLength(ForwardCos, size);
    SetLength(ForwardSin, size);

    // forward pass
    i := 0;
    n := size;
    mmax := 1;
    while (n > mmax) do
    begin
        istep := 2 * mmax;
        theta := Math_Pi / mmax;
        wr := 1;
        wi := 0;
        wpr := Cos(theta);
        wpi := Sin(theta);
        m := 0;
        while m < istep do
        begin
            ForwardCos[i] := wr;
            ForwardSin[i] := wi;
            Inc(i);

            t := wr;
            wr := wr * wpr - wi * wpi;
            wi := wi * wpr + t * wpi;
            m := m + 2;
        end;
        mmax := istep;
    end;
end;

constructor TFFTLomont.Create(frame_size: integer; window: TDoubleArray);
begin
    FFrameSize := frame_size;
    FFrameSizeH := frame_size div 2;
    FWindow := window;
    SetLength(FInput, frame_size);
    ComputeTable(frame_size);
end;

destructor TFFTLomont.Destroy;

begin
    SetLength(FInput, 0);
    SetLength(FWindow, 0);
    SetLength(ForwardCos, 0);
    SetLength(ForwardSin, 0);
    inherited Destroy;
end;



// Compute the forward or inverse FFT of data, which is
// complex valued items, stored in alternating real and
// imaginary real numbers. The length must be a power of 2.

procedure TFFTLomont.FFT(var Data: TDoubleArray);
var
    n, j, top, k, h: integer;
    t: double;
    mmax, tptr, istep, m: integer;
    theta, wr, wi, tempr, tempi: double;
begin
    n := Length(Data);
    // check all are valid
    // checks n is a power of 2 in 2's complement format
    if ((n and (n - 1)) <> 0) then
    begin
        // throw new Exception("data length " + n + " in FFT is not a power of 2");
        Exit;
    end;
    n := n div 2;

    // bit reverse the indices. This is exercise 5 in section 7.2.1.1 of Knuth's TAOCP
    // the idea is a binary counter in k and one with bits reversed in j
    // see also Alan H. Karp, "Bit Reversals on Uniprocessors", SIAM Review, vol. 38, #1, 1--26, March (1996)
    // nn = number of samples, 2* this is length of data?
    j := 0;
    k := 0; // Knuth R1: initialize
    top := n div 2; // this is Knuth's 2^(n-1)
    while (True) do
    begin
        // Knuth R2: swap
        // swap j+1 and k+2^(n-1) - both have two entries
        t := Data[j + 2];
        Data[j + 2] := Data[k + n];
        Data[k + n] := t;
        t := Data[j + 3];
        Data[j + 3] := Data[k + n + 1];
        Data[k + n + 1] := t;
        if (j > k) then
        begin // swap two more
            // j and k
            t := Data[j];
            Data[j] := Data[k];
            Data[k] := t;
            t := Data[j + 1];
            Data[j + 1] := Data[k + 1];
            Data[k + 1] := t;
            // j + top + 1 and k+top + 1
            t := Data[j + n + 2];
            Data[j + n + 2] := Data[k + n + 2];
            Data[k + n + 2] := t;
            t := Data[j + n + 3];
            Data[j + n + 3] := Data[k + n + 3];
            Data[k + n + 3] := t;
        end;
        // Knuth R3: advance k
        k := k + 4;
        if (k >= n) then
            break;
        // Knuth R4: advance j
        h := top;
        while (j >= h) do
        begin
            j := j - h;
            h := h div 2;
        end;
        j := j + h;
    end; // bit reverse loop

    // do transform by doing single point transforms, then doubles, fours, etc.
    mmax := 1;
    tptr := 0;
    while (n > mmax) do
    begin
        istep := 2 * mmax;
        theta := Math_Pi / mmax;
        m := 0;
        while m < istep do
        // for m := 0 to  istep-1 do m += 2)
        begin
            wr := ForwardCos[tptr];
            wi := ForwardSin[tptr];
            Inc(tptr);
            k := m;
            // for (k = m; k < 2 * n; k += 2 * istep)
            while (k < 2 * n) do
            begin
                j := k + istep;
                tempr := wr * Data[j] - wi * Data[j + 1];
                tempi := wi * Data[j] + wr * Data[j + 1];
                Data[j] := Data[k] - tempr;
                Data[j + 1] := Data[k + 1] - tempi;
                Data[k] := Data[k] + tempr;
                Data[k + 1] := Data[k + 1] + tempi;

                k := k + 2 * istep;
            end;
            Inc(m, 2);
        end;
        mmax := istep;
    end;
end;

// Computes the real FFT.

procedure TFFTLomont.RealFFT(var Data: TDoubleArray);
var
    n, j, k: integer;
    temp, theta, wpr, wpi, wjr, wji: double;
    tnr, tni, tjr, tji: double;
    a, b, c, d, e, f: double;
begin
    FFT(Data); // do packed FFT

    n := Length(Data); // number of real input points, which is 1/2 the complex length

    theta := 2 * Math_Pi / n;
    wpr := Cos(theta);
    wpi := Sin(theta);
    wjr := wpr;
    wji := wpi;
    for j := 1 to (n div 4) do
    begin

        k := n div 2 - j;
        tnr := Data[2 * k];
        tni := Data[2 * k + 1];
        tjr := Data[2 * j];
        tji := Data[2 * j + 1];

        e := (tjr + tnr);
        f := (tji - tni);
        a := (tjr - tnr) * wji;
        d := (tji + tni) * wji;
        b := (tji + tni) * wjr;
        c := (tjr - tnr) * wjr;

        // compute entry y[j]
        Data[2 * j] := 0.5 * (e + (a + b));
        Data[2 * j + 1] := 0.5 * (f - (c - d));

        // compute entry y[k]
        Data[2 * k] := 0.5 * (e - (a + b));
        Data[2 * k + 1] := 0.5 * ((-c + d) - f);

        temp := wjr;
        wjr := wjr * wpr - wji * wpi;
        wji := temp * wpi + wji * wpr;
    end;

    // compute final y0 and y_{N/2} ones, place into data[0] and data[1]
    temp := Data[0];
    Data[0] := Data[0] + Data[1];
    Data[1] := temp - Data[1];
end;

procedure TFFTLomont.ComputeFrame(input: TSmallintArray; var frame: TFFTFrame);
var
    i: integer;
begin
    for i := 0 to FFrameSize - 1 do
    begin
        FInput[i] := input[i] * FWindow[i] * 1.0;
    end;

    RealFFT(FInput);

    // FInput will now contain the FFT values
    // r0, r(n/2), r1, i1, r2, i2 ...

    // Compute energy
    frame.Data[0] := FInput[0] * FInput[0];
    frame.Data[FFrameSizeH] := FInput[1] * FInput[1];

    for i := 1 to FFrameSizeH - 1 do
    begin
        frame.Data[i] := FInput[2 * i] * FInput[2 * i] + FInput[2 * i + 1] * FInput[2 * i + 1];
    end;

end;

end.
