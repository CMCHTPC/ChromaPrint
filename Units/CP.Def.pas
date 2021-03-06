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
unit CP.Def;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils;

const
    CHROMAPRINT_VERSION_MAJOR = 1;
    CHROMAPRINT_VERSION_MINOR = 2;
    CHROMAPRINT_VERSION_PATCH = 0;

    kMinSampleRate = integer(1000);
    kMaxBufferSize = integer(1024 * 16);

    // Resampler configuration
    kResampleFilterLength = integer(16);
    kResamplePhaseCount = integer(10);
    kResampleLinear = integer(0);
    kResampleCutoff = 0.8;

    NUM_BANDS = 12;

    cSAMPLE_RATE = 11025;
    cFRAME_SIZE = 4096;
    cOVERLAP = cFRAME_SIZE - cFRAME_SIZE div 3;
    cMIN_FREQ = 28;
    cMAX_FREQ = 3520;

    Math_Pi: double = 3.1415926535897931;
    TwoMath_Pi: double = 6.2831853071795862;

type
    TUINT32Array = array of UINT32;
    PUINT32Array = ^TUINT32Array;
    TSmallintArray = array of smallint;
    TDoubleArray = array of double;
    PDoubleArray = ^TDoubleArray;

    TSingleArray = array of single;
    PSingleArray = ^TSingleArray;

    PINT32 = array of INT32;

    TChromaprintAlgorithm = (CHROMAPRINT_ALGORITHM_TEST1 = 0, CHROMAPRINT_ALGORITHM_TEST2, CHROMAPRINT_ALGORITHM_TEST3, CHROMAPRINT_ALGORITHM_TEST4,
        CHROMAPRINT_ALGORITHM_DEFAULT = CHROMAPRINT_ALGORITHM_TEST2);

implementation

end.
