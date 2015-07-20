unit MainUnit;

{$mode delphi}{$H+}

interface

uses
    Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    CP.ChromaPrint, XMLRead, XMLWrite, DOM,
    BASS;

type

    { TfrmFingerprintTest }

    TfrmFingerprintTest = class(TForm)
        btnInitBASS: TButton;
        btnDeInitBASS: TButton;
        btnSelectAudioFile: TButton;
        btnCalcFingerprint: TButton;
        btnMBInfo: TButton;
        EdDuration: TEdit;
        EdFilename: TEdit;
        EdSampleRate: TEdit;
        EdChannels: TEdit;
        GroupBox1: TGroupBox;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        MemoMB: TMemo;
        MemoFP: TMemo;
        OpenDialog1: TOpenDialog;
        procedure btnCalcFingerprintClick(Sender: TObject);
        procedure btnInitBASSClick(Sender: TObject);
        procedure btnDeInitBASSClick(Sender: TObject);
        procedure btnSelectAudioFileClick(Sender: TObject);
        procedure btnMBInfoClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure GroupBox1Click(Sender: TObject);
    private
        { private declarations }
        FAudioEnabled: boolean;
        FAudioStream: HSTREAM;
        FFileName: WideString;
        FSampleRate: integer;
        FChannels: integer;
        FDuration: integer;
        FCP: TChromaPrint;
    public
        { public declarations }
    end;

var
    frmFingerprintTest: TfrmFingerprintTest;

implementation

uses
    httpsend,
    CP.Def;

{$R *.lfm}


procedure ReadXMLDocRecordingContent(AXMLDocument: TXMLDocument; out Artist: WideString; out Title: WideString);
var
    i, m: uint;
    ts: WideString;
    lSubNode, lRecordingNode, lArtistNode: TDOMNode;
begin
    m := AXMLDocument.DocumentElement.ChildNodes.Count;
    with AXMLDocument.DocumentElement.ChildNodes do
    begin
        lRecordingNode := Item[0];
        m := lRecordingNode.ChildNodes.Count;
        for i := 0 to (m - 1) do
        begin
            lSubNode := lRecordingNode.ChildNodes.Item[i];
            ts := lSubNode.NodeName;
            if ts = 'title' then
            begin
                Title :={UTF8Decode}(lSubNode.TextContent);
            end;
            if ts = 'artist-credit' then
            begin
                lArtistNode := lSubNode.ChildNodes.Item[0].ChildNodes.Item[0].ChildNodes.Item[0];
                ts := lArtistNode.NodeName;
                Artist := UTF8Decode(lArtistNode.TextContent);
            end;
        end;

    end;
end;



procedure GetRecordingDetails(ARecordingID: WideString; out Artist: WideString; out Title: WideString);
var
    HTTP: THTTPSend;
    FURLXML: string;
    XMLDocument: TXMLDocument;
begin
    FURLXML := 'http://musicbrainz.org/ws/2/recording/' + ARecordingID + '?inc=artists';
    HTTP := THTTPSend.Create;
    try
        if HTTP.HTTPMethod('GET', FURLXML) then
        begin
            ReadXMLFile(XMLDocument, HTTP.Document);
            ReadXMLDocRecordingContent(XMLDocument, Artist, Title);
        end;
    finally
        HTTP.Free;
    end;
end;

{ TfrmFingerprintTest }

procedure TfrmFingerprintTest.btnInitBASSClick(Sender: TObject);
var
    lVersion: word;
begin
    // check the correct BASS was loaded
    lVersion := HIWORD(BASS_GetVersion);
    if (lVersion <> BASSVERSION) then
    begin
        FAudioEnabled := False;
    end
    else
    begin
        // Initialize audio - default device, 44100hz, stereo, 16 bits
        FAudioEnabled := BASS_Init(-1, 44100, 0, Handle, nil);
        BASS_SetConfig(BASS_CONFIG_UPDATETHREADS, 2);
    end;
    FCP := TChromaPrint.Create;
end;



procedure TfrmFingerprintTest.btnCalcFingerprintClick(Sender: TObject);
var
    fp: string;

    lBufferLength: integer;
    lRemaining: integer;
    lBytesRead: integer;
    lBuffer: TSmallintArray;
begin
    if FAudioStream = 0 then
        Exit;
    FCP.New(Ord(CHROMAPRINT_ALGORITHM_TEST2));
    FCP.Start(FSampleRate, FChannels);

    lBufferLength := FSampleRate * FChannels;
    lRemaining := 120 * lBufferLength;
    SetLength(lBuffer, lBufferLength);


    while lRemaining > 0 do
    begin
        BASS_SetDevice(0);
        lBytesRead := BASS_ChannelGetData(FAudioStream, @lBuffer[0], lBufferLength * 2);
        if lBytesRead > 0 then
            FCP.Feed(lBuffer, lBytesRead div 2);
        lRemaining := lRemaining - lBytesRead div 2;
    end;

    FCP.Finish;
    FCP.GetFingerprint(fp);
    MemoFP.Lines.Add(fp);
    SetLength(lBuffer, 0);
    btnMBInfo.Enabled := True;
end;



procedure TfrmFingerprintTest.btnDeInitBASSClick(Sender: TObject);
begin
    if FAudioEnabled then
        BASS_Free;
end;



procedure TfrmFingerprintTest.btnSelectAudioFileClick(Sender: TObject);
var
    FFileName: WideString;
    lChannelInfo: BASS_CHANNELINFO;
    fp: string;
    lDurationByte: QWord;
begin
    if OpenDialog1.Execute then
    begin
        FFileName := OpenDialog1.Filename;
        if FAudioStream <> 0 then
            BASS_StreamFree(FAudioStream);

        BASS_SetDevice(0);
        FAudioStream := BASS_StreamCreateFile(False, PWideChar(FFileName), 0, 0, BASS_UNICODE or BASS_STREAM_DECODE);
        if FAudioStream <> 0 then
        begin
            BASS_ChannelGetInfo(FAudioStream, lChannelInfo);
            lDurationByte := BASS_ChannelGetLength(FAudioStream, BASS_POS_BYTE);
            FDuration := Trunc(BASS_ChannelBytes2Seconds(FAudioStream, lDurationByte));
            FSampleRate := lChannelInfo.freq;
            FChannels := lChannelInfo.chans;

            EdFilename.Text := FFileName;
            EdDuration.Text := IntToStr(FDuration);
            EdChannels.Text := IntToStr(FChannels);
            EdSampleRate.Text := IntToStr(FSampleRate);

            btnCalcFingerprint.Enabled := True;
            btnMBInfo.Enabled := False;
        end;
    end;
end;



procedure TfrmFingerprintTest.btnMBInfoClick(Sender: TObject);
var
    i, n, j: integer;
    lAcoustIDInfo: TAcoustIDResult;
    lArtist, lTitle: WideString;
begin
    FCP.SearchAcoustID(ansistring(MemoFP.Lines.Text), FDuration);
    MemoMB.Clear;
    n := FCP.GetSearchCount;
    MemoMB.Lines.Add('Search Result Count: ' + IntToStr(n));
    for i := 0 to n - 1 do
    begin
        FCP.GetMusicBrainzInfo(i, lAcoustIDInfo);
        MemoMB.Lines.Add('Score:  ' + FloatToStrF(lAcoustIDInfo.Score, ffNumber, 8, 6));
        for j := 0 to Length(lAcoustIDInfo.MusicBrainzRecordingID) - 1 do
        begin
            GetRecordingDetails(lAcoustIDInfo.MusicBrainzRecordingID[j], lArtist, lTitle);
            MemoMB.Lines.Add('ID: ' + lAcoustIDInfo.MusicBrainzRecordingID[j] + '; Artist & Title: ' + lArtist + ' - ' + lTitle);
        end;
    end;
end;



procedure TfrmFingerprintTest.FormCreate(Sender: TObject);
begin
    FAudioEnabled := False;
    btnCalcFingerprint.Enabled := False;
    btnMBInfo.Enabled := False;
end;



procedure TfrmFingerprintTest.GroupBox1Click(Sender: TObject);
begin

end;

end.
