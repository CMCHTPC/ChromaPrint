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
unit CP.Imagebuilder;

interface

uses
    Classes,
    CP.Def, CP.FeatureVectorConsumer, CP.Image;

type
    { TImageBuilder }

    TImageBuilder = class(TFeatureVectorConsumer)
    private
        FImage: TImage;
    public
        property Image: TImage read FImage write FImage;
    public
        constructor Create(Image: TImage = nil);
        destructor Destroy; override;
        procedure Reset(Image: TImage);
        procedure Consume(var features: tDoubleArray); override;
    end;

implementation

{ TImageBuilder }

constructor TImageBuilder.Create(Image: TImage);
begin
    FImage := Image;
end;

destructor TImageBuilder.Destroy;
begin
    FImage := nil;
    inherited Destroy;
end;

procedure TImageBuilder.Reset(Image: TImage);
begin
    FImage := Image;
end;

procedure TImageBuilder.Consume(var features: tDoubleArray);
begin
    FImage.AddRow(features);
end;

end.
