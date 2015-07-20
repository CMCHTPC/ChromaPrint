unit Test;

{$mode delphi}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    CP.AudioBuffer, CP.Def, CP.AudioProcessor, CP.Image, CP.Filter,
    CP.IntegralImage;

type

    { TAPITestForm }

    TAPITestForm = class(TForm)
        btnChromaTest: TButton;
        btnFingerPrintCompressor: TButton;
        btnMovingAverage: TButton;
        btnMovingAverageTest: TButton;
        btnTestAPI: TButton;
        btnTestAPISilenceFP: TButton;
        btnTestAudioProcessor: TButton;
        btnTestBase64: TButton;
        btnTestBitStringWriter: TButton;
        btnTestChromaFilter: TButton;
        btnTestChromaprint: TButton;
        btnTestChromaResampler: TButton;
        btnTestCombinedBuffer: TButton;
        btnTestFilter: TButton;
        btnTestFingerprintCalculator: TButton;
        btnTestFingerprintDecompressor: TButton;
        btnTestIntegralImage: TButton;
        btnTestQuantize: TButton;
        btnTestSilenceRemover: TButton;
        btnTestStringReader: TButton;
        Memo: TMemo;
        procedure btnTestAudioProcessorClick(Sender: TObject);
        procedure btnTestFilterClick(Sender: TObject);
        procedure btnTestIntegralImageClick(Sender: TObject);
        procedure btnTestSilenceRemoverClick(Sender: TObject);
        procedure btnTestChromaprintClick(Sender: TObject);
        procedure btnTestCombinedBufferClick(Sender: TObject);
        procedure btnTestChromaResamplerClick(Sender: TObject);
        procedure btnTestChromaFilterClick(Sender: TObject);
        procedure btnChromaTestClick(Sender: TObject);
        procedure btnTestBase64Click(Sender: TObject);
        procedure btnTestQuantizeClick(Sender: TObject);
        procedure btnTestFingerprintCalculatorClick(Sender: TObject);
        procedure btnFingerPrintCompressorClick(Sender: TObject);
        procedure btnTestStringReaderClick(Sender: TObject);
        procedure btnTestBitStringWriterClick(Sender: TObject);
        procedure btnTestFingerprintDecompressorClick(Sender: TObject);
        procedure btnTestAPIClick(Sender: TObject);
        procedure btnMovingAverageClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    private
        { private declarations }
    public
        { public declarations }
    end;

var
    APITestForm: TAPITestForm;

implementation

uses
    CP.TestUtils, CP.SilenceRemover, CP.ImageBuilder, CP.FeatureVectorConsumer,
    CP.Base64, CP.Quantizer, CP.Classifier, CP.FingerPrintCalculator, CP.Utils,
    CP.FingerprintCompressor, CP.BitString,
    CP.Chromaprint,
    CP.Chroma, CP.FFT, CP.CombinedBuffer;

{$R *.lfm}

type
    TFeatureVectorBuffer = class(TFeatureVectorConsumer)
    private
        m_features: TDoubleArray;
    public
        procedure Consume(var features: TDoubleArray); override;
    end;



procedure TAPITestForm.btnChromaTestClick(Sender: TObject);
var
    buffer: TFeatureVectorBuffer;
    Chroma: TChroma;
    frame: TFFTFrame;
    expected_features: TDoubleArray;
    i: integer;
begin
    Memo.Clear;

    SetLength(expected_features, 12);
    expected_features[0] := 1.0;
    expected_features[1] := 0.0;
    expected_features[2] := 0.0;
    expected_features[3] := 0.0;
    expected_features[4] := 0.0;
    expected_features[5] := 0.0;
    expected_features[6] := 0.0;
    expected_features[7] := 0.0;
    expected_features[8] := 0.0;
    expected_features[9] := 0.0;
    expected_features[10] := 0.0;
    expected_features[11] := 0.0;

    Memo.Lines.Add('Test Chroma, NormalA');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);

    frame := TFFTFrame.Create(128);
    TDoubleArray(frame.Data)[113] := 1.0;
    Chroma.Consume(frame);

    if (Length(buffer.m_features) = 12) then
    begin
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    frame.Free;
    Chroma.Free;

    Memo.Lines.Add('Test Chroma, NormalGSharp');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);

    frame := TFFTFrame.Create(128);
    // frame.Data[112] := 1.0;
    TDoubleArray(frame.Data)[112] := 1.0;
    Chroma.Consume(frame);

    expected_features[11] := 1.0;
    expected_features[0] := 0.0;

    if (Length(buffer.m_features) = 12) then
    begin
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    Chroma.Free;
    frame.Free;

    Memo.Lines.Add('Test Chroma, NormalB');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);

    frame := TFFTFrame.Create(128);
    // frame.Data[64] := 1.0; // 250 Hz
    TDoubleArray(frame.Data)[64] := 1.0; // 250 Hz
    Chroma.Consume(frame);

    expected_features[2] := 1.0;
    expected_features[11] := 0.0;

    if (Length(buffer.m_features) = 12) then
    begin
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    Chroma.Free;
    frame.Free;

    Memo.Lines.Add('Test Chroma, InterpolatedB');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);
    Chroma.Interpolate := True;

    frame := TFFTFrame.Create(128);
    // frame.Data[64] := 1.0;
    TDoubleArray(frame.Data)[64] := 1.0;
    Chroma.Consume(frame);

    expected_features[0] := 0.0;
    expected_features[1] := 0.286905;
    expected_features[2] := 0.713095;
    expected_features[3] := 0.0;
    expected_features[4] := 0.0;
    expected_features[5] := 0.0;
    expected_features[6] := 0.0;
    expected_features[7] := 0.0;
    expected_features[8] := 0.0;
    expected_features[9] := 0.0;
    expected_features[10] := 0.0;
    expected_features[11] := 0.0;

    if (Length(buffer.m_features) = 12) then
    begin
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    Chroma.Free;
    frame.Free;

    Memo.Lines.Add('Test Chroma, InterpolatedA');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);
    Chroma.Interpolate := True;

    frame := TFFTFrame.Create(128);
    // frame.Data[113] := 1.0;
    TDoubleArray(frame.Data)[113] := 1.0;
    Chroma.Consume(frame);

    expected_features[0] := 0.555242;
    expected_features[1] := 0.0;
    expected_features[2] := 0.0;
    expected_features[3] := 0.0;
    expected_features[4] := 0.0;
    expected_features[5] := 0.0;
    expected_features[6] := 0.0;
    expected_features[7] := 0.0;
    expected_features[8] := 0.0;
    expected_features[9] := 0.0;
    expected_features[10] := 0.0;
    expected_features[11] := 0.44475;

    if (Length(buffer.m_features) = 12) then
    begin
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    Chroma.Free;
    frame.Free;

    Memo.Lines.Add('Test Chroma, InterpolatedGSharp');
    Memo.Lines.Add('=======================');

    buffer := TFeatureVectorBuffer.Create;
    Chroma := TChroma.Create(10, 510, 256, 1000, buffer);
    Chroma.Interpolate := True;

    frame := TFFTFrame.Create(128);
    // frame.Data[112] := 1.0;
    TDoubleArray(frame.Data)[112] := 1.0;
    Chroma.Consume(frame);

    expected_features[0] := 0.401354;
    expected_features[1] := 0.0;
    expected_features[2] := 0.0;
    expected_features[3] := 0.0;
    expected_features[4] := 0.0;
    expected_features[5] := 0.0;
    expected_features[6] := 0.0;
    expected_features[7] := 0.0;
    expected_features[8] := 0.0;
    expected_features[9] := 0.0;
    expected_features[10] := 0.0;
    expected_features[11] := 0.598646;

    if (Length(buffer.m_features) = 12) then
    begin
        Memo.Lines.Add('Features same size: OK');
        for i := 0 to 11 do
        begin
            if (abs(expected_features[i] - buffer.m_features[i]) > 0.0001) then
            begin
                Memo.Lines.Add('Different value at index: ' + IntToStr(i));
            end;
        end;
    end
    else
    begin
        Memo.Lines.Add('Features same size: NOT OK');
    end;

    buffer.Free;
    Chroma.Free;
    frame.Free;

    SetLength(expected_features, 0);
end;



procedure TAPITestForm.btnFingerPrintCompressorClick(Sender: TObject);
var
    lCompressor: TFingerprintCompressor;
    fingerprint: TUINT32Array;
    Value: string;
    expected: string;
begin
    Memo.Clear;
    Memo.Lines.Add('Test FingerprintCompressor, OneItemOneBit');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 1);
    fingerprint[0] := 1;
    expected := chr(0) + chr(0) + chr(0) + chr(1) + chr(1);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBit : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBit : NOT OK');
    lCompressor.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test FingerprintCompressor, OneItemThreeBits');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 1);
    fingerprint[0] := 7;
    expected := chr(0) + chr(0) + chr(0) + chr(1) + chr(73) + chr(0);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, OneItemThreeBits : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, OneItemThreeBits : NOT OK');
    lCompressor.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test FingerprintCompressor, OneItemOneBitExcept');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 1);
    fingerprint[0] := 1 shl 6;
    expected := chr(0) + chr(0) + chr(0) + chr(1) + chr(7) + chr(0);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBitExcept : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBitExcept : NOT OK');
    lCompressor.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test FingerprintCompressor, OneItemOneBitExcept2');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 1);
    fingerprint[0] := 1 shl 8;
    expected := chr(0) + chr(0) + chr(0) + chr(1) + chr(7) + chr(2);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBitExcept2 : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, OneItemOneBitExcept2 : NOT OK');
    lCompressor.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test FingerprintCompressor, TwoItems');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 2);
    fingerprint[0] := 1;
    fingerprint[1] := 0;
    expected := chr(0) + chr(0) + chr(0) + chr(2) + chr(65) + chr(0);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, TwoItems : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, TwoItems : NOT OK');
    lCompressor.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test FingerprintCompressor, TwoItemsNoChange');
    Memo.Lines.Add('=======================');

    SetLength(fingerprint, 2);
    fingerprint[0] := 1;
    fingerprint[1] := 1;
    expected := chr(0) + chr(0) + chr(0) + chr(2) + chr(1) + chr(0);
    lCompressor := TFingerprintCompressor.Create;

    Value := lCompressor.Compress(fingerprint);
    if Value = expected then
        Memo.Lines.Add('FingerprintCompressor, TwoItemsNoChange : OK')
    else
        Memo.Lines.Add('FingerprintCompressor, TwoItemsNoChange : NOT OK');
    lCompressor.Free;

end;



procedure TAPITestForm.btnMovingAverageClick(Sender: TObject);
var
    avg: TMovingAverage;
begin
    avg := TMovingAverage.Create(2);
    Memo.Clear;
    Memo.Lines.Add('Value: ' + IntToStr(avg.GetAverage)); // 0
    avg.AddValue(100);
    Memo.Lines.Add('Value: ' + IntToStr(avg.GetAverage)); // 100
    avg.AddValue(50);
    Memo.Lines.Add('Value: ' + IntToStr(avg.GetAverage)); // 75
    avg.AddValue(0);
    Memo.Lines.Add('Value: ' + IntToStr(avg.GetAverage)); // 25
    avg.AddValue(1000);
    Memo.Lines.Add('Value: ' + IntToStr(avg.GetAverage)); // 500
    avg.Free;
end;



procedure TAPITestForm.btnTestAPIClick(Sender: TObject);
var
    zeroes: TSmallintArray;
    i, n: integer;
    c: TChromaprint;
    fp: string;
    fpi: TUINT32Array;
    expected: array of byte;
    expectedString: string;
    encoded: string;
    encodedsize: integer;
    lError: boolean;
    algo: integer;
begin
    Memo.Clear;
    Memo.Lines.Add('Test API, Test2SilenceFp');
    Memo.Lines.Add('=======================');

    SetLength(zeroes, 1024);
    for i := 0 to 1024 - 1 do
        zeroes[i] := 0;

    c := TChromaprint.Create;
    c.New(Ord(CHROMAPRINT_ALGORITHM_TEST2));
    c.Start(44100, 1);
    for i := 0 to 130 - 1 do
    begin
        c.Feed(zeroes, 1024);
    end;

    c.Finish;

    c.GetRawFingerprint(fpi, n);
    if n = 3 then
    begin
        Memo.Lines.Add('RAW Length: OK');
        if (fpi[0] = 627964279) then
            Memo.Lines.Add('RAW Value 0: OK');
        if (fpi[1] = 627964279) then
            Memo.Lines.Add('RAW Value 1: OK');
        if (fpi[2] = 627964279) then
            Memo.Lines.Add('RAW Value 2: OK');

    end
    else
    begin
        Memo.Lines.Add('RAW Length: NOT OK');
    end;

    c.GetFingerprint(fp);

    i := Length(fp);
    if i = 18 then
    begin
        Memo.Lines.Add('Length: OK');
        if fp = 'AQAAA0mUaEkSRZEGAA' then
            Memo.Lines.Add('String: OK')
        else
            Memo.Lines.Add('String: NOT OK');

    end
    else
    begin
        Memo.Lines.Add('Length: NOT OK');
    end;

    c.Free;

    SetLength(zeroes, 0);
    SetLength(fpi, 0);

    Memo.Lines.Add('');
    Memo.Lines.Add('Test API, TestEncodeFingerprint');
    Memo.Lines.Add('=======================');
    SetLength(fpi, 2);
    fpi[0] := 1;
    fpi[1] := 0;
    SetLength(expected, 6);
    expected[0] := 55;
    expected[1] := 0;
    expected[2] := 0;
    expected[3] := 2;
    expected[4] := 65;
    expected[5] := 0;

    c := TChromaprint.Create;
    c.New(Ord(CHROMAPRINT_ALGORITHM_TEST2));
    c.EnocdeFingerprint(fpi, 55, encoded, encodedsize, False);

    if encodedsize = 6 then
    begin
        Memo.Lines.Add('Length: OK');
        lError := False;
        for i := 1 to encodedsize do
        begin
            if encoded[i] <> chr(expected[i - 1]) then
            begin
                Memo.Lines.Add('Differenz at Position: ' + IntToStr(i));
                lError := True;
            end;
        end;
        if not lError then
            Memo.Lines.Add('String: OK');
    end
    else
    begin
        Memo.Lines.Add('Length: NOT OK');
    end;

    c.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test API, TestEncodeFingerprintBase64');
    Memo.Lines.Add('=======================');
    expectedString := 'NwAAAkEA';

    c := TChromaprint.Create;
    c.New(Ord(CHROMAPRINT_ALGORITHM_TEST2));
    c.EnocdeFingerprint(fpi, 55, encoded, encodedsize, True);

    if encodedsize = 8 then
    begin
        Memo.Lines.Add('Length: OK');
        if encoded = expectedString then
            Memo.Lines.Add('String: OK')
        else
            Memo.Lines.Add('String: NOT OK');
    end
    else
    begin
        Memo.Lines.Add('Length: NOT OK');
    end;

    c.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test API, TestDecodeFingerprint');
    Memo.Lines.Add('=======================');
    expectedString := 'NwAAAkEA';

    c := TChromaprint.Create;
    c.New(Ord(CHROMAPRINT_ALGORITHM_TEST2));

    encoded := chr(55) + chr(0) + chr(0) + chr(2) + chr(65) + chr(0);

    algo := 2;
    c.DecodeFingerprint(encoded, fpi, algo, False);

    if Length(fpi) = 2 then
    begin
        Memo.Lines.Add('Length: OK');

        if algo = 55 then
            Memo.Lines.Add('Algo: OK')
        else
            Memo.Lines.Add('Algo: NOT OK');

        if fpi[0] = 1 then
            Memo.Lines.Add('FP[0]: OK')
        else
            Memo.Lines.Add('FP[0]: NOT OK');

        if fpi[1] = 0 then
            Memo.Lines.Add('FP[1]: OK')
        else
            Memo.Lines.Add('FP[1]: NOT OK');
    end
    else
    begin
        Memo.Lines.Add('Length: NOT OK');
    end;

    c.Free;

end;



procedure TAPITestForm.btnTestAudioProcessorClick(Sender: TObject);
var
    buffer, Buffer2: TAudioBuffer;
    Processor: TAudioProcessor;
    DataMono, DataStereo, DataMono11025, DataMono8000: TSmallintArray;
    i: integer;
    lError: boolean;
    lErrCount: integer;
begin
    Memo.Clear;
    DataMono := LoadAudioFile('data\test_mono_44100.raw');
    DataStereo := LoadAudioFile('data\test_stereo_44100.raw');
    DataMono11025 := LoadAudioFile('data\test_mono_11025.raw');
    DataMono8000 := LoadAudioFile('data\test_mono_8000.raw');

    buffer := TAudioBuffer.Create;
    Buffer2 := TAudioBuffer.Create;
    Processor := TAudioProcessor.Create(44100, buffer);
{$DEFINE TestMono}
{$DEFINE TestStereoToMono}
{$DEFINE ResampleMono}
{$DEFINE ResampleMono8000}
{$DEFINE StereoToMonoAndResample}
{$IFDEF TestMono}
    Memo.Lines.Add('Test Mono');
    Memo.Lines.Add('=======================');
    if Processor.TargetSampleRate = 44100 then
        Memo.Lines.Add('Target Sample Rate: OK');
    if Processor.consumer = buffer then
        Memo.Lines.Add('Processor Consumer: OK');

    Processor.TargetSampleRate := 11025;
    if Processor.TargetSampleRate = 11025 then
        Memo.Lines.Add('Target Sample Rate: OK');

    Processor.consumer := Buffer2;
    if Processor.consumer = Buffer2 then
        Memo.Lines.Add('Processor Consumer: OK');

    Processor.consumer := buffer;
    Processor.TargetSampleRate := 44100;
    Processor.Reset(44100, 1);
    Processor.Consume(DataMono, 0, Length(DataMono));
    Processor.Flush();

    if Length(DataMono) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(DataMono) - 1 do
        begin

            if DataMono[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(DataMono[i]) + ' - ' + IntToStr(buffer.Data[i]));
                lError := True;
            end;
        end;
        if not lError then
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
{$ENDIF}
{$IFDEF TestStereoToMono}
    { Test Stereo To Mono }
    Memo.Lines.Add('');
    Memo.Lines.Add('Test Stereo To Mono');
    Memo.Lines.Add('=======================');
    buffer.Reset;
    Processor.TargetSampleRate := 44100;
    Processor.Reset(44100, 2);
    Processor.Consume(DataStereo, 0, Length(DataStereo));
    Processor.Flush();

    if Length(DataMono) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(DataMono) - 1 do
        begin
            if DataMono[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(DataMono[i]) + ' - ' + IntToStr(buffer.Data[i]));
                lError := True;
            end;
        end;
        if not lError then
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
{$ENDIF}
{$IFDEF ResampleMono}
    Memo.Lines.Add('');
    Memo.Lines.Add('Test Resample Mono');
    Memo.Lines.Add('=======================');
    buffer.Reset;
    Processor.TargetSampleRate := 11025;
    Processor.Reset(44100, 1);
    Processor.Consume(DataMono, 0, Length(DataMono));
    Processor.Flush();

    lErrCount := 0;
    if Length(DataMono11025) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(DataMono11025) - 1 do
        begin
            if DataMono11025[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(DataMono11025[i]) + ' || ' + IntToStr(buffer.Data[i]));
                Inc(lErrCount);
                lError := True;
            end;
        end;
        if lError then
        begin
            Memo.Lines.Add('Buffer Data and Readed Data equal: NOT OK');
            Memo.Lines.Add('Error Count: ' + IntToStr(lErrCount) + ' / ' + IntToStr(Length(DataMono11025)));
        end
        else
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
{$ENDIF}
{$IFDEF ResampleMono8000}
    Memo.Lines.Add('');
    Memo.Lines.Add('Test Resample Mono 8000');
    Memo.Lines.Add('=======================');
    buffer.Reset;
    Processor.TargetSampleRate := 8000;
    Processor.Reset(44100, 1);
    Processor.Consume(DataMono, 0, Length(DataMono));
    Processor.Flush();

    lErrCount := 0;
    if Length(DataMono8000) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(DataMono8000) - 1 do
        begin
            if DataMono8000[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(DataMono8000[i]) + ' || ' + IntToStr(buffer.Data[i]));
                Inc(lErrCount);
                lError := True;
            end;
        end;
        if lError then
        begin
            Memo.Lines.Add('Buffer Data and Readed Data equal: NOT OK');
            Memo.Lines.Add('Error Count: ' + IntToStr(lErrCount) + ' / ' + IntToStr(Length(DataMono11025)));
        end
        else
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
{$ENDIF}
{$IFDEF StereoToMonoAndResample}
    Memo.Lines.Add('');
    Memo.Lines.Add('Test Stereo To Mono And Resample');
    Memo.Lines.Add('=======================');
    buffer.Reset;
    Processor.TargetSampleRate := 11025;
    Processor.Reset(44100, 2);
    Processor.Consume(DataStereo, 0, Length(DataStereo));
    Processor.Flush();

    lErrCount := 0;
    if Length(DataMono11025) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(DataMono11025) - 1 do
        begin
            if DataMono11025[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(DataMono11025[i]) + ' || ' + IntToStr(buffer.Data[i]));
                Inc(lErrCount);
                lError := True;
            end;
        end;
        if lError then
        begin
            Memo.Lines.Add('Buffer Data and Readed Data equal: NOT OK');
            Memo.Lines.Add('Error Count: ' + IntToStr(lErrCount) + ' / ' + IntToStr(Length(DataMono11025)));
        end
        else
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
{$ENDIF}
    buffer.Free;
    Buffer2.Free;
    Processor.Free;
end;



procedure TAPITestForm.btnTestBase64Click(Sender: TObject);
begin
    Memo.Lines.Clear;
    Memo.Lines.Add('Test Base64, Base64Encode');
    Memo.Lines.Add('=======================');

    if Base64Encode('x') = 'eA' then
        Memo.Lines.Add('Base64Encode 1: OK')
    else
        Memo.Lines.Add('Base64Encode 1: NOT OK');

    if Base64Encode('xx') = 'eHg' then
        Memo.Lines.Add('Base64Encode 2: OK')
    else
        Memo.Lines.Add('Base64Encode 2: NOT OK');

    if Base64Encode('xxx') = 'eHh4' then
        Memo.Lines.Add('Base64Encode 3: OK')
    else
        Memo.Lines.Add('Base64Encode 3: NOT OK');

    if Base64Encode('xxxx') = 'eHh4eA' then
        Memo.Lines.Add('Base64Encode 4: OK')
    else
        Memo.Lines.Add('Base64Encode 4: NOT OK');

    if Base64Encode('xxxxx') = 'eHh4eHg' then
        Memo.Lines.Add('Base64Encode 5: OK')
    else
        Memo.Lines.Add('Base64Encode 5: NOT OK');

    if Base64Encode('xxxxxx') = 'eHh4eHh4' then
        Memo.Lines.Add('Base64Encode 6: OK')
    else
        Memo.Lines.Add('Base64Encode 6: NOT OK');

    if Base64Encode(chr($FF) + chr($EE)) = '_-4' then
        Memo.Lines.Add('Base64Encode 7: OK')
    else
        Memo.Lines.Add('Base64Encode 7: NOT OK');

    Memo.Lines.Add('');

    if Base64Decode('eA') = 'x' then
        Memo.Lines.Add('Base64Decode 1: OK')
    else
        Memo.Lines.Add('Base64Decode 1: NOT OK');

    if Base64Decode('eHg') = 'xx' then
        Memo.Lines.Add('Base64Decode 2: OK')
    else
        Memo.Lines.Add('Base64Decode 2: NOT OK');

    if Base64Decode('eHh4') = 'xxx' then
        Memo.Lines.Add('Base64Decode 3: OK')
    else
        Memo.Lines.Add('Base64Decode 3: NOT OK');

    if Base64Decode('eHh4eA') = 'xxxx' then
        Memo.Lines.Add('Base64Decode 4: OK')
    else
        Memo.Lines.Add('Base64Decode 4: NOT OK');

    if Base64Decode('eHh4eHg') = 'xxxxx' then
        Memo.Lines.Add('Base64Decode 5: OK')
    else
        Memo.Lines.Add('Base64Decode 5: NOT OK');

    if Base64Decode('eHh4eHh4') = 'xxxxxx' then
        Memo.Lines.Add('Base64Decode 6: OK')
    else
        Memo.Lines.Add('Base64Decode 6: NOT OK');

    if Base64Decode('_-4') = chr($FF) + chr($EE) then
        Memo.Lines.Add('Base64Decode 7: OK')
    else
        Memo.Lines.Add('Base64Decode 7: NOT OK');

end;



procedure TAPITestForm.btnTestBitStringWriterClick(Sender: TObject);
var
    writer: TBitStringWriter;
    expected: string;
begin
    Memo.Lines.Clear;

    writer := TBitStringWriter.Create;
    writer.Write(0, 2);
    writer.Write(1, 2);
    writer.Write(2, 2);
    writer.Write(3, 2);
    writer.Flush();

    Memo.Lines.Clear;
    Memo.Lines.Add('Test BitStringWriter, OneByte');
    Memo.Lines.Add('=======================');

    expected := chr(byte(-28));

    if writer.Value = expected then
        Memo.Lines.Add('BitStringWriter, OneByte: OK')
    else
        Memo.Lines.Add('BitStringWriter, OneByte: NOT OK');

    writer.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test BitStringWriter, TwoBytesIncomplete');
    Memo.Lines.Add('=======================');

    writer := TBitStringWriter.Create;
    writer.Write(0, 2);
    writer.Write(1, 2);
    writer.Write(2, 2);
    writer.Write(3, 2);
    writer.Write(1, 2);
    writer.Flush();

    expected := chr(byte(-28)) + chr(byte(1));

    if writer.Value = expected then
        Memo.Lines.Add('BitStringWriter, TwoBytesIncomplete: OK')
    else
        Memo.Lines.Add('BitStringWriter, TwoBytesIncomplete: NOT OK');

    writer.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test BitStringWriter, TwoBytesSplit');
    Memo.Lines.Add('=======================');

    writer := TBitStringWriter.Create;
    writer.Write(0, 3);
    writer.Write(1, 3);
    writer.Write(2, 3);
    writer.Write(3, 3);
    writer.Flush();

    expected := chr(byte(-120)) + chr(byte(6));

    if writer.Value = expected then
        Memo.Lines.Add('BitStringWriter, TwoBytesSplit: OK')
    else
        Memo.Lines.Add('BitStringWriter, TwoBytesSplit: NOT OK');

    writer.Free;

end;



procedure TAPITestForm.btnTestChromaFilterClick(Sender: TObject);
var
    lImage: TImage;
    lImageBuilder: TImageBuilder;
    lFilter: TChromaFilter;
    d1: TDoubleArray;
    d2, d3, d4: TDoubleArray;
    lRes: double;
    lCoefficients: array of double;
begin
    Memo.Lines.Clear;
    SetLength(lCoefficients, 2);
    lCoefficients[0] := 0.5;
    lCoefficients[1] := 0.5;

    SetLength(d1, 12);

    d1[0] := 0.0;
    d1[1] := 5.0;
    d1[2] := 0.0;
    d1[3] := 0.0;
    d1[4] := 0.0;
    d1[5] := 0.0;
    d1[6] := 0.0;
    d1[7] := 0.0;
    d1[8] := 0.0;
    d1[9] := 0.0;
    d1[10] := 0.0;
    d1[11] := 0.0;

    SetLength(d2, 12);

    d2[0] := 1.0;
    d2[1] := 6.0;
    d2[2] := 0.0;
    d2[3] := 0.0;
    d2[4] := 0.0;
    d2[5] := 0.0;
    d2[6] := 0.0;
    d2[7] := 0.0;
    d2[8] := 0.0;
    d2[9] := 0.0;
    d2[10] := 0.0;
    d2[11] := 0.0;

    SetLength(d3, 12);
    d3[0] := 2.0;
    d3[1] := 7.0;
    d3[2] := 0.0;
    d3[3] := 0.0;
    d3[4] := 0.0;
    d3[5] := 0.0;
    d3[6] := 0.0;
    d3[7] := 0.0;
    d3[8] := 0.0;
    d3[9] := 0.0;
    d3[10] := 0.0;
    d3[11] := 0.0;

    SetLength(d4, 12);
    d4[0] := 3.0;
    d4[1] := 8.0;
    d4[2] := 0.0;
    d4[3] := 0.0;
    d4[4] := 0.0;
    d4[5] := 0.0;
    d4[6] := 0.0;
    d4[7] := 0.0;
    d4[8] := 0.0;
    d4[9] := 0.0;
    d4[10] := 0.0;
    d4[11] := 0.0;

    Memo.Lines.Add('Test ChromaFilter, Blur2');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);

    lFilter := TChromaFilter.Create(@lCoefficients[0], 2, lImageBuilder);

    lFilter.Consume(d1);
    lFilter.Consume(d2);
    lFilter.Consume(d3);

    if lImage.NumRows = 2 then
    begin
        Memo.Lines.Add('Numbers of rows match:  OK');
        lRes := lImage.GetData(0, 0);
        if lRes = 0.5 then
            Memo.Lines.Add('Value on 0/0 match:  OK');
        lRes := lImage.GetData(1, 0);
        if lRes = 1.5 then
            Memo.Lines.Add('Value on 1/0 match:  OK');
        lRes := lImage.GetData(0, 1);
        if lRes = 5.5 then
            Memo.Lines.Add('Value on 0/1 match:  OK');
        lRes := lImage.GetData(1, 1);
        if lRes = 6.5 then
            Memo.Lines.Add('Value on 1/1 match:  OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lImage.Free;
    lImageBuilder.Free;
    lFilter.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test ChromaResampler, Blur3');
    Memo.Lines.Add('=======================');

    SetLength(lCoefficients, 3);
    lCoefficients[0] := 0.5;
    lCoefficients[1] := 0.7;
    lCoefficients[2] := 0.5;

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);

    lFilter := TChromaFilter.Create(@lCoefficients[0], 3, lImageBuilder);

    lFilter.Consume(d1);
    lFilter.Consume(d2);
    lFilter.Consume(d3);
    lFilter.Consume(d4);

    if lImage.NumRows = 2 then
    begin
        Memo.Lines.Add('Numbers of rows match:  OK');
        lRes := lImage.GetData(0, 0);
        if (lRes <= 1.7001) and (lRes >= 1.699) then
            Memo.Lines.Add('Value on 0/0 match:  OK');
        lRes := lImage.GetData(1, 0);
        if (lRes <= 3.4001) and (lRes >= 3.399) then
            Memo.Lines.Add('Value on 1/0 match:  OK');

        lRes := lImage.GetData(0, 1);
        if (lRes <= 10.2001) and (lRes >= 10.199) then
            Memo.Lines.Add('Value on 0/1 match:  OK');

        lRes := lImage.GetData(1, 1);
        if (lRes <= 11.9001) and (lRes >= 11.899) then
            Memo.Lines.Add('Value on 1/1 match:  OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lImage.Free;
    lImageBuilder.Free;
    lFilter.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test ChromaResampler, Diff');
    Memo.Lines.Add('=======================');

    SetLength(lCoefficients, 2);
    lCoefficients[0] := 1.0;
    lCoefficients[1] := -1.0;

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);

    lFilter := TChromaFilter.Create(@lCoefficients[0], 2, lImageBuilder);

    lFilter.Consume(d1);
    lFilter.Consume(d2);
    lFilter.Consume(d3);

    if lImage.NumRows = 2 then
    begin
        Memo.Lines.Add('Numbers of rows match:  OK');
        lRes := lImage.GetData(0, 0);
        if lRes = -1.0 then
            Memo.Lines.Add('Value on 0/0 match:  OK');
        lRes := lImage.GetData(1, 0);
        if lRes = -1.0 then
            Memo.Lines.Add('Value on 1/0 match:  OK');

        lRes := lImage.GetData(0, 1);
        if lRes = -1.0 then
            Memo.Lines.Add('Value on 0/1 match:  OK');

        lRes := lImage.GetData(1, 1);
        if lRes = -1.0 then
            Memo.Lines.Add('Value on 1/1 match:  OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lImage.Free;
    lImageBuilder.Free;
    lFilter.Free;
end;



procedure TAPITestForm.btnTestChromaprintClick(Sender: TObject);
const
    chromagram: array [0 .. 13, 0 .. 11] of double =
        ((0.155444, 0.268618, 0.474445, 0.159887, 0.1761, 0.423511, 0.178933, 0.34433, 0.360958, 0.30421,
        0.200217, 0.17072), (0.159809, 0.238675, 0.286526, 0.166119, 0.225144, 0.449236, 0.162444, 0.371875,
        0.259626, 0.483961, 0.24491, 0.17034),
        (0.156518, 0.271503, 0.256073, 0.152689, 0.174664, 0.52585, 0.141517, 0.253695, 0.293199, 0.332114, 0.442906, 0.170459),
        (0.154183, 0.38592, 0.497451, 0.203884, 0.362608, 0.355691, 0.125349, 0.146766, 0.315143, 0.318133, 0.172547, 0.112769),
        (0.201289, 0.42033, 0.509467, 0.259247, 0.322772, 0.325837, 0.140072, 0.177756, 0.320356, 0.228176, 0.148994, 0.132588),
        (0.187921, 0.302804, 0.46976, 0.302809, 0.183035, 0.228691, 0.206216, 0.35174, 0.308208, 0.233234, 0.316017, 0.243563),
        (0.213539, 0.240346, 0.308664, 0.250704, 0.204879, 0.365022, 0.241966, 0.312579, 0.361886, 0.277293, 0.338944, 0.290351),
        (0.227784, 0.252841, 0.295752, 0.265796, 0.227973, 0.451155, 0.219418, 0.272508, 0.376082, 0.312717, 0.285395, 0.165745),
        (0.168662, 0.180795, 0.264397, 0.225101, 0.562332, 0.33243, 0.236684, 0.199847, 0.409727, 0.247569, 0.21153, 0.147286),
        (0.0491864, 0.0503369, 0.130942, 0.0505802, 0.0694409, 0.0303877, 0.0389852, 0.674067, 0.712933, 0.05762, 0.0245158, 0.0389336),
        (0.0814379, 0.0312366, 0.240546, 0.134609, 0.063374, 0.0466124, 0.0752175, 0.657041, 0.680085, 0.0720311, 0.0249404, 0.0673359),
        (0.139331, 0.0173442, 0.49035, 0.287237, 0.0453947, 0.0873279, 0.15423, 0.447475, 0.621502, 0.127166, 0.0355933, 0.141163),
        (0.115417, 0.0132515, 0.356601, 0.245902, 0.0283943, 0.0588233, 0.117077, 0.499376, 0.715366, 0.100398, 0.0281382, 0.0943482),
        (0.047297, 0.0065354, 0.181074, 0.121455, 0.0135504, 0.030693, 0.0613105, 0.631705, 0.73548, 0.0550565, 0.0128093, 0.0460393));
var
    buffer, Buffer2: TAudioBuffer;
    Processor: TAudioProcessor;
    DataMono, DataStereo, DataMono11025, DataMono8000: TSmallintArray;
    i: integer;
    lError: boolean;
    lErrCount: integer;

    lImage: TImage;
    lImageBuilder: TImageBuilder;
    lChromaNormalizer: TChromaNormalizer;
    lChroma: TChroma;
    lFFT: TFFT;
    lProcessor: TAudioProcessor;
    y, x: integer;
    l1, l2: double;
begin
    Memo.Lines.Clear;
    DataStereo := LoadAudioFile('data\test_stereo_44100.raw');

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);
    lChromaNormalizer := TChromaNormalizer.Create(lImageBuilder);
    lChroma := TChroma.Create(28, 3520, 4096, 11025, lChromaNormalizer);
    // lChroma.Interpolate:=TRUE;
    lFFT := TFFT.Create(4096, cFRAME_SIZE - cFRAME_SIZE div 3, lChroma);
    lProcessor := TAudioProcessor.Create(11025, lFFT);

    lProcessor.Reset(44100, 2);
    lProcessor.Consume(DataStereo, 0, Length(DataStereo));
    lProcessor.Flush();

    if lImage.NumRows = 14 then
    begin
        Memo.Lines.Add('Numbers of rows match: OK');
        lError := False;

        for y := 0 to 13 do
        begin
            for x := 0 to 11 do
            begin
                l1 := chromagram[y, x];
                l2 := lImage.GetData(y, x);
                if (abs(l1 - l2) > 0.0005) then
                begin
                    Memo.Lines.Add(' Image not equal at (' + IntToStr(x) + ',' + IntToStr(y) + '): ' + FloatToStrF(l1 - l2, ffNumber, 8, 3));
                    lError := True;
                end;
            end;
        end;
        if not lError then
            Memo.Lines.Add('Image equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lProcessor.Free;
    lFFT.Free;
    lChromaNormalizer.Free;
    lChroma.Free;
    lImageBuilder.Free;
    lImage.Free;

    SetLength(DataStereo, 0);
end;



procedure TAPITestForm.btnTestChromaResamplerClick(Sender: TObject);
var
    lImage: TImage;
    lImageBuilder: TImageBuilder;
    lResampler: TChromaResampler;
    d1: TDoubleArray;
    d2, d3, d4: TDoubleArray;
    lRes: double;
begin
    Memo.Lines.Clear;
    SetLength(d1, 12);

    d1[0] := 0.0;
    d1[1] := 5.0;
    d1[2] := 0.0;
    d1[3] := 0.0;
    d1[4] := 0.0;
    d1[5] := 0.0;
    d1[6] := 0.0;
    d1[7] := 0.0;
    d1[8] := 0.0;
    d1[9] := 0.0;
    d1[10] := 0.0;
    d1[11] := 0.0;

    SetLength(d2, 12);

    d2[0] := 1.0;
    d2[1] := 6.0;
    d2[2] := 0.0;
    d2[3] := 0.0;
    d2[4] := 0.0;
    d2[5] := 0.0;
    d2[6] := 0.0;
    d2[7] := 0.0;
    d2[8] := 0.0;
    d2[9] := 0.0;
    d2[10] := 0.0;
    d2[11] := 0.0;

    SetLength(d3, 12);
    d3[0] := 2.0;
    d3[1] := 7.0;
    d3[2] := 0.0;
    d3[3] := 0.0;
    d3[4] := 0.0;
    d3[5] := 0.0;
    d3[6] := 0.0;
    d3[7] := 0.0;
    d3[8] := 0.0;
    d3[9] := 0.0;
    d3[10] := 0.0;
    d3[11] := 0.0;

    SetLength(d4, 12);
    d4[0] := 3.0;
    d4[1] := 8.0;
    d4[2] := 0.0;
    d4[3] := 0.0;
    d4[4] := 0.0;
    d4[5] := 0.0;
    d4[6] := 0.0;
    d4[7] := 0.0;
    d4[8] := 0.0;
    d4[9] := 0.0;
    d4[10] := 0.0;
    d4[11] := 0.0;

    Memo.Lines.Add('Test ChromaResampler, Test 1');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);

    lResampler := TChromaResampler.Create(2, lImageBuilder);

    lResampler.Consume(d1);
    lResampler.Consume(d2);
    lResampler.Consume(d3);

    if lImage.NumRows = 1 then
    begin
        Memo.Lines.Add('Numbers of rows match:  OK');
        lRes := lImage.GetData(0, 0);
        if lRes = 0.5 then
            Memo.Lines.Add('Value on 0/0 match:  OK');
        lRes := lImage.GetData(0, 1);
        if lRes = 5.5 then
            Memo.Lines.Add('Value on 0/1 match:  OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lImage.Free;
    lImageBuilder.Free;
    lResampler.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test ChromaResampler, Test 2');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(12);
    lImageBuilder := TImageBuilder.Create(lImage);

    lResampler := TChromaResampler.Create(2, lImageBuilder);

    lResampler.Consume(d1);
    lResampler.Consume(d2);
    lResampler.Consume(d3);
    lResampler.Consume(d4);

    if lImage.NumRows = 2 then
    begin
        Memo.Lines.Add('Numbers of rows match:  OK');
        lRes := lImage.GetData(0, 0);
        if lRes = 0.5 then
            Memo.Lines.Add('Value on 0/0 match:  OK');
        lRes := lImage.GetData(0, 1);
        if lRes = 5.5 then
            Memo.Lines.Add('Value on 0/1 match:  OK');

        lRes := lImage.GetData(1, 0);
        if lRes = 2.5 then
            Memo.Lines.Add('Value on 1/0 match:  OK');

        lRes := lImage.GetData(1, 1);
        if lRes = 7.5 then
            Memo.Lines.Add('Value on 1/1 match:  OK');
    end
    else
    begin
        Memo.Lines.Add('Numbers of rows match: NOT OK');
    end;

    lImage.Free;
    lImageBuilder.Free;
    lResampler.Free;

end;



procedure TAPITestForm.btnTestCombinedBufferClick(Sender: TObject);
var
    Buffer1, Buffer2: TSmallintArray;
    lCombinedBuffer: TCombinedBuffer;
    i: integer;
begin
    Memo.Lines.Clear;
    SetLength(Buffer1, 5);
    Buffer1[0] := 1;
    Buffer1[1] := 2;
    Buffer1[2] := 3;
    Buffer1[3] := 4;
    Buffer1[4] := 5;

    SetLength(Buffer2, 3);
    Buffer2[0] := 6;
    Buffer2[1] := 7;
    Buffer2[2] := 8;

    Memo.Lines.Add('Test CombinedBuffer, Size');
    Memo.Lines.Add('=======================');

    lCombinedBuffer := TCombinedBuffer.Create(Buffer1, 5, Buffer2, 3);
    if lCombinedBuffer.Size = 8 then
        Memo.Lines.Add('CombinedBuffer Size: OK');
    lCombinedBuffer.Shift(1);
    if lCombinedBuffer.Size = 7 then
        Memo.Lines.Add('CombinedBuffer Size after shift: OK');
    lCombinedBuffer.Shift(-1);
    for i := 0 to 7 do
    begin
        if (i + 1) = lCombinedBuffer.GetValue(i) then
            Memo.Lines.Add('CombinedBuffer read pos[' + IntToStr(i) + ']: OK')
        else
            Memo.Lines.Add('CombinedBuffer read pos[' + IntToStr(i) + ']: NOT OK');
    end;
    lCombinedBuffer.Shift(1);
    for i := 0 to 6 do
    begin
        if (i + 2) = lCombinedBuffer.GetValue(i) then
            Memo.Lines.Add('CombinedBuffer read after shift pos[' + IntToStr(i) + ']: OK')
        else
            Memo.Lines.Add('CombinedBuffer read after shift  pos[' + IntToStr(i) + ']: NOT OK');
    end;

    lCombinedBuffer.Shift(5);
    for i := 0 to 1 do
    begin
        if (i + 7) = lCombinedBuffer.GetValue(i) then
            Memo.Lines.Add('CombinedBuffer read after 2.shift pos[' + IntToStr(i) + ']: OK')
        else
            Memo.Lines.Add('CombinedBuffer read after 2.shift  pos[' + IntToStr(i) + ']: NOT OK');
    end;

    SetLength(Buffer1, 0);
    SetLength(Buffer2, 0);

    lCombinedBuffer.Free;
end;



procedure TAPITestForm.btnTestFilterClick(Sender: TObject);
var
    lImage: TImage;
    lFilter: TFilter;
    lIntegralImage: TIntegralImage;
    lRes: double;
begin
    Memo.Lines.Clear;

    lImage := TImage.Create(2, 2);
    lImage.SetData(0, 0, 0.0);
    lImage.SetData(0, 1, 1.0);
    lImage.SetData(1, 0, 2.0);
    lImage.SetData(1, 1, 3.0);

    lFilter := TFilter.Create(0, 0, 1, 1);
    lIntegralImage := TIntegralImage.Create(lImage);
    lRes := lFilter.Apply(lIntegralImage, 0);
    if lRes = 0.0 then
        Memo.Lines.Add('Apply Filter 0: OK');
    lRes := lFilter.Apply(lIntegralImage, 1);
    if (lRes <= 1.0986124) and (lRes >= 1.0986122) then
        Memo.Lines.Add('Apply Filter 1: OK');

    lImage.Free;
    lFilter.Free;
    lIntegralImage.Free;
end;



procedure TAPITestForm.btnTestFingerprintCalculatorClick(Sender: TObject);
var
    lImage: TImage;
    lClassifier: TClassifierArray;
    lCalculator: TFingerprintCalculator;

    integral_image: TIntegralImage;
    fp: TUINT32Array;
begin
    Memo.Lines.Clear;

    lImage := TImage.Create(2, 2);
    lImage.SetData(0, 0, 0.0);
    lImage.SetData(0, 1, 1.0);
    lImage.SetData(1, 0, 2.0);
    lImage.SetData(1, 1, 3.0);

    SetLength(lClassifier, 1);
    lClassifier[0] := TClassifier.Create(TFilter.Create(0, 0, 1, 1), TQuantizer.Create(0.01, 1.01, 1.5));
    lCalculator := TFingerprintCalculator.Create(lClassifier);
    integral_image := TIntegralImage.Create(lImage);

    if lCalculator.CalculateSubfingerprint(integral_image, 0) = GrayCode(0) then
        Memo.Lines.Add('CalculateSubfingerprint 0: OK')
    else
        Memo.Lines.Add('CalculateSubfingerprint 0: NOT OK');

    if lCalculator.CalculateSubfingerprint(integral_image, 1) = GrayCode(2) then
        Memo.Lines.Add('CalculateSubfingerprint 1: OK')
    else
        Memo.Lines.Add('CalculateSubfingerprint 1: NOT OK');

    lImage.Free;
    lCalculator.Free;
    integral_image.Free;
    lClassifier[0].Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintCalculator, Calculate');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(2, 3);
    lImage.SetData(0, 0, 0.0);
    lImage.SetData(0, 1, 1.0);
    lImage.SetData(1, 0, 2.0);
    lImage.SetData(1, 1, 3.0);
    lImage.SetData(2, 0, 4.0);
    lImage.SetData(2, 1, 5.0);

    SetLength(lClassifier, 1);
    lClassifier[0] := TClassifier.Create(TFilter.Create(0, 0, 1, 1), TQuantizer.Create(0.01, 1.01, 1.5));
    lCalculator := TFingerprintCalculator.Create(lClassifier);

    fp := lCalculator.Calculate(lImage);

    if Length(fp) = 3 then
    begin
        Memo.Lines.Add('FingerprintCalculator Length: OK');
        if fp[0] = GrayCode(0) then
            Memo.Lines.Add('FingerprintCalculator 0: OK')
        else
            Memo.Lines.Add('FingerprintCalculator 0: NOT OK');

        if fp[1] = GrayCode(2) then
            Memo.Lines.Add('FingerprintCalculator 1: OK')
        else
            Memo.Lines.Add('FingerprintCalculator 1: NOT OK');

        if fp[2] = GrayCode(3) then
            Memo.Lines.Add('FingerprintCalculator 2: OK')
        else
            Memo.Lines.Add('FingerprintCalculator 2: NOT OK');

    end
    else
    begin
        Memo.Lines.Add('FingerprintCalculator Length: NOT OK');
    end;

    lImage.Free;
    lCalculator.Free;
    lClassifier[0].Free;

end;



procedure TAPITestForm.btnTestFingerprintDecompressorClick(Sender: TObject);
var
    expected: TUINT32Array;
    Data: string;
    algorithm: integer;
    Value: TUINT32Array;
begin
    Memo.Lines.Clear;

    Memo.Lines.Add('FingerprintDecompressor, OneItemOneBi');
    Memo.Lines.Add('=======================');

    SetLength(expected, 1);
    expected[0] := 1;
    Data := chr(0) + chr(0) + chr(0) + chr(1) + chr(1);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, OneItemThreeBits');
    Memo.Lines.Add('=======================');

    SetLength(expected, 1);
    expected[0] := 7;
    Data := chr(0) + chr(0) + chr(0) + chr(1) + chr(73) + chr(0);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, OneItemOneBitExcept');
    Memo.Lines.Add('=======================');

    SetLength(expected, 1);
    expected[0] := 1 shl 6;
    Data := chr(0) + chr(0) + chr(0) + chr(1) + chr(7) + chr(0);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, OneItemOneBitExcept2');
    Memo.Lines.Add('=======================');

    SetLength(expected, 1);
    expected[0] := 1 shl 8;
    Data := chr(0) + chr(0) + chr(0) + chr(1) + chr(7) + chr(2);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, TwoItems');
    Memo.Lines.Add('=======================');

    SetLength(expected, 2);
    expected[0] := 1;
    expected[1] := 0;

    Data := chr(0) + chr(0) + chr(0) + chr(2) + chr(65) + chr(0);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, TwoItemsNoChange');
    Memo.Lines.Add('=======================');

    SetLength(expected, 2);
    expected[0] := 1;
    expected[1] := 1;

    Data := chr(0) + chr(0) + chr(0) + chr(2) + chr(1) + chr(0);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

    Memo.Lines.Add('');
    Memo.Lines.Add('FingerprintDecompressor, Invalid1');
    Memo.Lines.Add('=======================');

    SetLength(expected, 1);
    expected[0] := 0;

    Data := chr(0) + chr(255) + chr(255) + chr(255);
    algorithm := 1;
    Value := DecompressFingerprint(Data, algorithm);
    CheckFingerprints(Memo.Lines, Value, expected, Length(expected));
    if algorithm = 0 then
        Memo.Lines.Add('Algorithm: OK')
    else
        Memo.Lines.Add('Algorithm: NOT OK');

end;



procedure TAPITestForm.btnTestIntegralImageClick(Sender: TObject);
var
    lImage: TImage;
    lIntegralImage: TIntegralImage;
    lRes: double;
begin
    Memo.Lines.Clear;
    Memo.Lines.Add('IntegralImage, Basic2D');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(2, 2);

    lImage.SetData(0, 0, 1.0);
    lImage.SetData(0, 1, 2.0);
    lImage.SetData(1, 0, 3.0);
    lImage.SetData(1, 1, 4.0);

    lIntegralImage := TIntegralImage.Create(lImage);
    if lIntegralImage.GetData(0, 0) = 1.0 then
        Memo.Lines.Add('Integeral Image 0: OK');
    if lIntegralImage.GetData(0, 1) = 3.0 then
        Memo.Lines.Add('Integeral Image 1: OK');
    if lIntegralImage.GetData(1, 0) = 4.0 then
        Memo.Lines.Add('Integeral Image 2: OK');
    if lIntegralImage.GetData(1, 1) = 10.0 then
        Memo.Lines.Add('Integeral Image 3: OK');

    lIntegralImage.Free;
    lImage.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('IntegralImage, Vertical1D');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(1, 3);
    lImage.SetData(0, 0, 1.0);
    lImage.SetData(1, 0, 2.0);
    lImage.SetData(2, 0, 3.0);

    lIntegralImage := TIntegralImage.Create(lImage);
    if lIntegralImage.GetData(0, 0) = 1.0 then
        Memo.Lines.Add('Integeral Image 0: OK');
    if lIntegralImage.GetData(1, 0) = 3.0 then
        Memo.Lines.Add('Integeral Image 1: OK');
    if lIntegralImage.GetData(2, 0) = 6.0 then
        Memo.Lines.Add('Integeral Image 2: OK');

    lIntegralImage.Free;
    lImage.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('IntegralImage, Horizontal1D');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(3, 1);
    lImage.SetData(0, 0, 1.0);
    lImage.SetData(0, 1, 2.0);
    lImage.SetData(0, 2, 3.0);

    lIntegralImage := TIntegralImage.Create(lImage);
    if lIntegralImage.GetData(0, 0) = 1.0 then
        Memo.Lines.Add('Integeral Image 0: OK');
    if lIntegralImage.GetData(0, 1) = 3.0 then
        Memo.Lines.Add('Integeral Image 1: OK');
    if lIntegralImage.GetData(0, 2) = 6.0 then
        Memo.Lines.Add('Integeral Image 2: OK');

    lIntegralImage.Free;
    lImage.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('IntegralImage, Area');
    Memo.Lines.Add('=======================');

    lImage := TImage.Create(3, 3);
    lImage.SetData(0, 0, 1.0);
    lImage.SetData(0, 1, 2.0);
    lImage.SetData(0, 2, 3.0);

    lImage.SetData(1, 0, 4.0);
    lImage.SetData(1, 1, 5.0);
    lImage.SetData(1, 2, 6.0);

    lImage.SetData(2, 0, 7.0);
    lImage.SetData(2, 1, 8.0);
    lImage.SetData(2, 2, 9.0);

    lIntegralImage := TIntegralImage.Create(lImage);
    if lIntegralImage.Area(0, 0, 0, 0) = (1.0) then
        Memo.Lines.Add('Integeral Image Area 0: OK');
    if lIntegralImage.Area(0, 0, 1, 0) = (1.0 + 4) then
        Memo.Lines.Add('Integeral Image Area 1: OK');
    if lIntegralImage.Area(0, 0, 2, 0) = (1.0 + 4 + 7) then
        Memo.Lines.Add('Integeral Image Area 2: OK');

    if lIntegralImage.Area(0, 0, 0, 1) = (1.0 + 2) then
        Memo.Lines.Add('Integeral Image Area 3: OK');
    if lIntegralImage.Area(0, 0, 1, 1) = (1.0 + 4 + 2 + 5) then
        Memo.Lines.Add('Integeral Image Area 4: OK');
    if lIntegralImage.Area(0, 0, 2, 1) = (1.0 + 4 + 7 + 2 + 5 + 8) then
        Memo.Lines.Add('Integeral Image Area 5: OK');

    if lIntegralImage.Area(0, 1, 0, 1) = (2.0) then
        Memo.Lines.Add('Integeral Image Area 6: OK');
    if lIntegralImage.Area(0, 1, 1, 1) = (2.0 + 5) then
        Memo.Lines.Add('Integeral Image Area 7: OK');
    if lIntegralImage.Area(0, 1, 2, 1) = (2.0 + 5 + 8) then
        Memo.Lines.Add('Integeral Image Area 8: OK');

    lIntegralImage.Free;
    lImage.Free;
end;



procedure TAPITestForm.btnTestQuantizeClick(Sender: TObject);
var
    q: TQuantizer;
begin
    Memo.Lines.Clear;
    Memo.Lines.Add('Test Quantizer, Quantize');
    Memo.Lines.Add('=======================');

    q := TQuantizer.Create(0.0, 0.1, 0.3);

    if q.Quantize(-0.1) = 0 then
        Memo.Lines.Add('Quantize 1: OK')
    else
        Memo.Lines.Add('Quantize 1: NOT OK');

    if q.Quantize(0.0) = 1 then
        Memo.Lines.Add('Quantize 2: OK')
    else
        Memo.Lines.Add('Quantize 2: NOT OK');

    if q.Quantize(0.03) = 1 then
        Memo.Lines.Add('Quantize 3: OK')
    else
        Memo.Lines.Add('Quantize 3: NOT OK');

    if q.Quantize(0.1) = 2 then
        Memo.Lines.Add('Quantize 4: OK')
    else
        Memo.Lines.Add('Quantize 4: NOT OK');

    if q.Quantize(0.13) = 2 then
        Memo.Lines.Add('Quantize 5: OK')
    else
        Memo.Lines.Add('Quantize 5: NOT OK');

    if q.Quantize(0.3) = 3 then
        Memo.Lines.Add('Quantize 6: OK')
    else
        Memo.Lines.Add('Quantize 6: NOT OK');

    if q.Quantize(0.33) = 3 then
        Memo.Lines.Add('Quantize 7: OK')
    else
        Memo.Lines.Add('Quantize 7: NOT OK');

    if q.Quantize(1000.0) = 3 then
        Memo.Lines.Add('Quantize 8: OK')
    else
        Memo.Lines.Add('Quantize 8: NOT OK');

    q.Free;
end;



procedure TAPITestForm.btnTestSilenceRemoverClick(Sender: TObject);
var
    samples, Samples1, Samples2: TSmallintArray;
    buffer: TAudioBuffer;
    Processor: TSilenceRemover;
    lError: boolean;
    i: integer;
begin
    Memo.Lines.Clear;

    {
      SetLength(samples, 6);
      samples[0] := 1000;
      samples[1] := 2000;
      samples[2] := 3000;
      samples[3] := 4000;
      samples[4] := 5000;
      samples[5] := 6000;

      Buffer := TAudioBuffer.Create;
      Processor := TSilenceRemover.Create(Buffer);
      Processor.Reset(44100, 1);
      Processor.Consume(samples, Length(samples));
      Processor.Flush();

      Memo.Lines.Add('Test SilenceRemover, PassThrough ');
      Memo.Lines.Add('=======================');
      if Length(samples) = Length(Buffer.data) then
      begin
      Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
      lError := FALSE;

      for i := 0 to Length(samples) - 1 do
      begin
      if samples[i] <> Buffer.data[i] then
      begin
      Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(samples[i]) + ' || ' + IntToStr(Buffer.data[i]));
      lError := TRUE;
      end;
      end;
      if lError then
      begin
      Memo.Lines.Add('Buffer Data and Readed Data equal: NOT OK');
      end
      else
      Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
      end
      else
      begin
      Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
      end;
      Buffer.Free;
      Processor.Free;
      }

    Memo.Lines.Add('');
    Memo.Lines.Add('Test SilenceRemover, RemoveLeadingSilence ');
    Memo.Lines.Add('=======================');

    SetLength(Samples1, 9);
    Samples1[0] := 0;
    Samples1[1] := 60;
    Samples1[2] := 0;
    Samples1[3] := 1000;
    Samples1[4] := 2000;
    Samples1[5] := 0;
    Samples1[6] := 4000;
    Samples1[7] := 5000;
    Samples1[8] := 0;

    SetLength(Samples2, 6);
    Samples2[0] := 1000;
    Samples2[1] := 2000;
    Samples2[2] := 0;
    Samples2[3] := 4000;
    Samples2[4] := 5000;
    Samples2[5] := 0;

    buffer := TAudioBuffer.Create;
    Processor := TSilenceRemover.Create(buffer, 100);
    Processor.Reset(44100, 1);
    Processor.Consume(Samples1, 0, Length(Samples1));
    Processor.Flush();

    if Length(Samples2) = Length(buffer.Data) then
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: OK');
        lError := False;

        for i := 0 to Length(Samples2) - 1 do
        begin
            if Samples2[i] <> buffer.Data[i] then
            begin
                Memo.Lines.Add('Signals differ at index: ' + IntToStr(i) + ', ' + IntToStr(Samples2[i]) + ' || ' + IntToStr(buffer.Data[i]));
                lError := True;
            end;
        end;
        if lError then
        begin
            Memo.Lines.Add('Buffer Data and Readed Data equal: NOT OK');
        end
        else
            Memo.Lines.Add('Buffer Data and Readed Data equal: OK');
    end
    else
    begin
        Memo.Lines.Add('Buffer Data Size and Readed Data Size: NOT OK');
    end;
    buffer.Free;
    Processor.Free;
end;



procedure TAPITestForm.btnTestStringReaderClick(Sender: TObject);
var
    Data: string;
    reader: TBitStringReader;
begin
    Memo.Clear;

    Memo.Lines.Add('Test BitStringReader, OneByte');
    Memo.Lines.Add('=======================');
    Data := chr(byte(-28));
    reader := TBitStringReader.Create(Data);

    if (reader.Read(2) = 0) then
        Memo.Lines.Add('BitStringReader 0:  OK')
    else
        Memo.Lines.Add('BitStringReader 0:  NOT OK');

    if (reader.Read(2) = 1) then
        Memo.Lines.Add('BitStringReader 1:  OK')
    else
        Memo.Lines.Add('BitStringReader 1:  NOT OK');

    if (reader.Read(2) = 2) then
        Memo.Lines.Add('BitStringReader 2:  OK')
    else
        Memo.Lines.Add('BitStringReader 2:  NOT OK');

    if (reader.Read(2) = 3) then
        Memo.Lines.Add('BitStringReader 3:  OK')
    else
        Memo.Lines.Add('BitStringReader 3:  NOT OK');

    reader.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test BitStringReader, TwoBytesIncomplete');
    Memo.Lines.Add('=======================');
    Data := chr(byte(-28)) + chr(byte(1));
    reader := TBitStringReader.Create(Data);

    if (reader.Read(2) = 0) then
        Memo.Lines.Add('BitStringReader 0:  OK')
    else
        Memo.Lines.Add('BitStringReader 0:  NOT OK');

    if (reader.Read(2) = 1) then
        Memo.Lines.Add('BitStringReader 1:  OK')
    else
        Memo.Lines.Add('BitStringReader 1:  NOT OK');

    if (reader.Read(2) = 2) then
        Memo.Lines.Add('BitStringReader 2:  OK')
    else
        Memo.Lines.Add('BitStringReader 2:  NOT OK');

    if (reader.Read(2) = 3) then
        Memo.Lines.Add('BitStringReader 3:  OK')
    else
        Memo.Lines.Add('BitStringReader 3:  NOT OK');

    if (reader.Read(2) = 1) then
        Memo.Lines.Add('BitStringReader 4:  OK')
    else
        Memo.Lines.Add('BitStringReader 4:  NOT OK');

    reader.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test BitStringReader, TwoBytesSplit');
    Memo.Lines.Add('=======================');
    Data := chr(byte(-120)) + chr(byte(6));
    reader := TBitStringReader.Create(Data);

    if (reader.Read(3) = 0) then
        Memo.Lines.Add('BitStringReader 0:  OK')
    else
        Memo.Lines.Add('BitStringReader 0:  NOT OK');

    if (reader.Read(3) = 1) then
        Memo.Lines.Add('BitStringReader 1:  OK')
    else
        Memo.Lines.Add('BitStringReader 1:  NOT OK');

    if (reader.Read(3) = 2) then
        Memo.Lines.Add('BitStringReader 2:  OK')
    else
        Memo.Lines.Add('BitStringReader 2:  NOT OK');

    if (reader.Read(3) = 3) then
        Memo.Lines.Add('BitStringReader 3:  OK')
    else
        Memo.Lines.Add('BitStringReader 3:  NOT OK');

    reader.Free;

    Memo.Lines.Add('');
    Memo.Lines.Add('Test BitStringReader, AvailableBitsAndEOF');
    Memo.Lines.Add('=======================');
    Data := chr(byte(-120)) + chr(byte(6));
    reader := TBitStringReader.Create(Data);

    if reader.AvailableBits = 16 then
    begin
        Memo.Lines.Add('AvailableBits 16:  OK');
        Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));

        reader.Read(3);
        if reader.AvailableBits = 13 then
        begin
            Memo.Lines.Add('AvailableBits 13:  OK');
            Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));
            reader.Read(3);
            if reader.AvailableBits = 10 then
            begin
                Memo.Lines.Add('AvailableBits 10:  OK');
                Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));

                reader.Read(3);
                if reader.AvailableBits = 7 then
                begin
                    Memo.Lines.Add('AvailableBits 7:  OK');
                    Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));

                    reader.Read(7);
                    if reader.AvailableBits = 0 then
                    begin
                        Memo.Lines.Add('AvailableBits 0:  OK');
                        Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));

                        if reader.Read(3) = 0 then
                        begin
                            Memo.Lines.Add('Read ZERO:  OK');
                            if reader.AvailableBits = 0 then
                            begin
                                Memo.Lines.Add('AvailableBits 0:  OK');
                                Memo.Lines.Add('EOF:  ' + BoolToStr(reader.EOF, True));

                            end;

                        end;

                    end;

                end;

            end;

        end;
    end
    else
    begin
        Memo.Lines.Add('AvailableBits 16:  NOT OK');
    end;

    reader.Free;
end;



procedure TAPITestForm.FormCreate(Sender: TObject);
begin
    Memo.Clear;
end;

{ TFeatureVectorBuffer }

procedure TFeatureVectorBuffer.Consume(var features: TDoubleArray);
begin
    m_features := features;
end;

end.
