unit U_RecvThread;

interface

uses
  Classes, SysUtils, Windows, StrUtils, DModule, IdHTTP, IdSSLOpenSSL, AProc,
  SOAPThroughHTTP, Contnrs;

type
  TReceiveThread = class(TThread)
   private
    FURL,
    FHTTPName,
    FHTTPPass : String;
    FUseNTLM  : Boolean;
   FSOAP : TSOAP;
    ReceiveHTTP : TIdHTTP;
    ReceiveSSL : TIdSSLIOHandlerSocket;
    procedure Log(SybSystem, MessageText : String);
    procedure OnConnectError(AMessage : String);
    procedure FillFileList(ASoapResult : String; AFileList : TStringList);
   protected
    procedure Execute; override;
   public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure DisconnectThread;
    procedure SetParams(
      AURL,
      AHTTPName,
      AHTTPPass : String;
      AUseNTLM  : Boolean);
  end;

implementation

uses
  Exchange;
  
{ TReceiveThread }

constructor TReceiveThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  ReceiveHTTP := TIdHTTP.Create(nil);
  ReceiveHTTP.Name := 'httpReceive';
  ReceiveSSL := TIdSSLIOHandlerSocket.Create(nil);
  ReceiveSSL.Name := 'sslReceive';
  DM.InternalSetHTTPParams(ReceiveHTTP);
  AProc.InternalSetSSLParams(ReceiveSSL);
  ReceiveHTTP.IOHandler := ReceiveSSL;
end;

destructor TReceiveThread.Destroy;
begin
  ReceiveHTTP.IOHandler := nil;
  try ReceiveSSL.Free; except end;
  try ReceiveHTTP.Free; except end;
  inherited;
end;

procedure TReceiveThread.Execute;
var
  I,
  SleepCount : Integer;
	LibVersions: TObjectList;
  ParamNames, ParamValues : array of String;
  fi : TFileUpdateInfo;
  SoapResult : String;
  FileList : TStringList;
begin
  try
    //���� ��������� ����� ���� ��������� ������� ��������� ������ (15 ���)
    SleepCount := 0;
    while not Terminated and (SleepCount < 30) do begin
      Sleep(500);
      Inc(SleepCount);
    end;
    if Terminated then exit;
    FSOAP := TSOAP.Create(FURL, FHTTPName, FHTTPPass, OnConnectError, ReceiveHTTP);
    try
      LibVersions := AProc.GetLibraryVersionFromAppPath;
      try
        SetLength(ParamNames, LibVersions.Count*3);
        SetLength(ParamValues, LibVersions.Count*3);
        for I := 0 to LibVersions.Count-1 do begin
          fi := TFileUpdateInfo(LibVersions[i]);
          ParamNames[i*3] := 'LibraryName';
          ParamValues[i*3] := fi.FileName;
          ParamNames[i*3+1] := 'LibraryVersion';
          ParamValues[i*3+1] := fi.Version;
          ParamNames[i*3+2] := 'LibraryHash';
          ParamValues[i*3+2] := fi.MD5;
        end;
      finally
        LibVersions.Free;
      end;

		  SoapResult := FSOAP.SimpleInvoke('GetInfo', ParamNames, ParamValues);

      if (Length(SoapResult) > 0) and not Terminated then begin
        FileList := TStringList.Create;
        try
          FillFileList(SoapResult, FileList);

          AProc.InternalDoSendLetter(ReceiveHTTP, FURL, 'AFRec', FileList, '����� �� �������', '������ ��������');

          for I := 0 to FileList.Count-1 do
            if Integer(FileList.Objects[i]) = 1 then
              DeleteFileA(FileList[i], False);
        finally
          FileList.Free;
        end;
      end;

    finally
      FSOAP.Free;
    end;
  except
    on E : Exception do begin
      Log('Receive', '������ : ' + E.Message);
    end;
  end;
end;

procedure TReceiveThread.DisconnectThread;
begin
  try ReceiveHTTP.Disconnect; except end;
end;

procedure TReceiveThread.Log(SybSystem, MessageText: String);
var
  Res : Boolean;
begin
  Res := False;
  repeat
    try
       WriteLn(ExchangeForm.LogFile, DateTimeToStr(Now) + '  ' + SybSystem + '  ' + MessageText);
       Res := True;
    except
      Sleep(700);
    end;
  until Res;
end;

procedure TReceiveThread.SetParams(AURL, AHTTPName, AHTTPPass: String;
  AUseNTLM: Boolean);
begin
  FURL := AURL;
  FHTTPName := AHTTPName;
  FHTTPPass := AHTTPPass;
  FUseNTLM := AUseNTLM;
end;

procedure TReceiveThread.OnConnectError(AMessage: String);
begin
  if Terminated then Abort;
end;

procedure TReceiveThread.FillFileList(ASoapResult: String;
  AFileList: TStringList);
var
  FileName : String;
  DeletedMark : String;
begin
  while (Length(ASoapResult) > 0) do begin
    FileName := GetNextWord(ASoapResult, '|');
    DeletedMark := GetNextWord(ASoapResult, '|');
    //���� ���� ���-��
    if (Length(FileName) > 0) and ((DeletedMark = '0') or (DeletedMark = '1'))
    then begin
      //��������� ���������� ��� �����
      FileName := ExtractFilePath(ParamStr(0)) + FileName;
      if FileExists(FileName) then
        AFileList.AddObject(FileName, TObject(StrToInt(DeletedMark)));
    end;
  end;
end;

end.
