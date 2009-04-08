unit AProc;

interface

uses SysUtils, Controls, Windows, Forms, StrUtils, Classes, Math, DBGrids,
  ComCtrls, Messages, ShellApi, IniFiles, AppUtils, IdFTP, DateUtils, ToughDBGrid,
	DbGridEh, IdHTTP, SyncObjs, FileUtil, Contnrs, IdSSLOpenSSL;

const
  WM_AFTERRETRIEVEMAIL=WM_USER+100; //сообщение о получении сообщений. с сервера
  SSectionParams='Params';
  SConnectRAS='RAS'; SConnectPROXY='PROXY'; SConnectNONE='NONE';
  SDirDocs='Docs';
  SDirIn='In';
  SDirData = 'Data';
  SDirDataBackup = 'DataBackup';
  SDirExe='Exe';
  SDirWaybills = 'Waybills';
  SDirRejects = 'Rejects';
  SDirReclame='Reclame';
  SBackDir = 'UpdateBackup';
  SHTTPPrefix='http://';
  CRLF=#13#10;

type
  TFileUpdateInfo = class
   public
    FileName, Version, MD5 : String;
    constructor Create(AFileName, AVersion, AMD5 : String);
  end;

var
  ExePath, ExeName, DatabaseName, TempPath: string;
  IniFile: TIniFile;
  WordDelimitersA: set of Char;
  ExportFormat: TFormatSettings;
  TimeZoneBias: Integer;
  SZCS : TCriticalSection;


procedure FocusNextControl(Sender: TWinControl);
function FocusFirstControl(Sender: TWinControl): Boolean;
function MessageBox(MesStr: string; Icon: Cardinal=MB_ICONINFORMATION): Integer;
function MessageBoxEx(MesStr, Caption: string; Icon: Cardinal=MB_ICONINFORMATION): Integer;
function SilentMode : Boolean;
function GetNextWord(var S: string; Delimiter: Char): string;
function RoundFloat(Value: Extended; Decimal: Integer): Extended;
function Iif(X: Boolean; Y,Z: Variant): Variant;
function ColumnByName(Grid: TCustomDBGrid; FieldName: string): TColumn;
function ColumnByNameT(Grid: TToughDBGrid; FieldName: string): TColumnEh;
function EmptyStr(St: string): Boolean;
function MinNotNull(X,Y: Integer): Integer;
function GetParentForm(Control: TControl): TForm;
function FileExecute(const FileName: string; Params: string='';
  StartDir: string=''; ShowFlag: Integer=SW_SHOWNORMAL; Wait: Boolean=False): Integer;
procedure RaiseLastOSErrorA;
procedure Win32CheckA(RetVal: BOOL);
function FindChildControlByClass(ParentControl: TWinControl; ClassRef: TControlClass): TControl;
procedure StringToStrings(Str: string; Strings: TStrings; Delimiter: Char=';');
function StringsToString(Strings: TStrings; Delimiter: Char=';'): string;
procedure OSMoveFile(Source, Destination: string);
procedure OSCopyFile(Source, Destination: string);
procedure OSDeleteFile(FileName: string; RaiseException: Boolean=True);
function NumberToChars(Val: Integer; Len: Integer=0): string;
function CharsToNumber(St: string): Integer;
function StrToProxyType(St: string): TIdFtpProxyType;
function ProxyTypeToStr(ProxyType: TIdFtpProxyType): string;
function GetTempDir: string;
procedure DeleteFilesByMask(FileName: string; RaiseException: Boolean=True);
function GetTimeZoneBias: Integer;
function UTCToLocalTime(UTC: TDateTime): TDateTime;
function LocalTimeToUTC(DateTime: TDateTime): TDateTime;
procedure MailTo(EMail,Subject: string);
procedure UrlLink(Address: string);
function ExtractURL(const URL: string): string;
function SimpleHash( AStr: string): string;
procedure LogCriticalError(Error : String);
procedure LogExitError(Error : String; ExitCode : Integer; ShowErrorMessage : Boolean = True);
//Добавляет параметр RangeStart к запросу в случае, если необходима докачка
function AddRangeStartToURL(AURL : String; Position : Int64) : String;
procedure InternalDoSendLetter(
  SendIdHTTP : TIdHTTP;    //Компонент для отправки письма
  SendURL : String;        //URL, по которому происходит доступ
  TempSendDir : String;    //Временная папка для создания аттачмента
  Attachs : TStringList;   //Список приложений
  Subject, Body : String); //Тема письма и тело письма
function  GetLibraryVersionFromAppPath : TObjectList;
//устанавливаем параметры для SSL-соединения
procedure InternalSetSSLParams(SSL : TIdSSLIOHandlerSocketOpenSSL);
//Получить для файла Hash MD5
function GetFileHash(AFileName: String): String;
function StringToCodes( AStr: string): string;
function GetXMLDateTime( ADateTime: TDateTime): string;
function WordCount(const S: string; const WordDelims: TSysCharSet): Integer;

//Сформировать SQL для загрузки данных их файла с помощью load data
function GetLoadDataSQL(TableName : String; InputFileName : String; Replace : Boolean = False) : String;

procedure CopyDirectories(const fromDir, toDir: String);
procedure MoveDirectories(const fromDir, toDir: String);
procedure DeleteDirectory(const Dir : String);



implementation

uses
  IdCoderMIME, SevenZip, U_SXConversions, RxVerInf, IdHashMessageDigest,
  U_ExchangeLog, IdHash;

var
  FSilentMode : Boolean;

//процедура передает фокус следующему элементу окна в порядке TabOrder
procedure FocusNextControl(Sender: TWinControl);
var
  I, J: Integer;
begin
  I:=Sender.TabOrder; J:=I;
  if Sender.Parent<>nil then with Sender.Parent do begin
    repeat
      Inc(I);
      if I=J then Break;
      if I>ControlCount-1 then I:=0;
    until (Controls[I] is TWinControl)and(TWinControl(Controls[I]).CanFocus);
    if I<>J then TWinControl(Controls[I]).SetFocus;
  end;
end;

//устанавливает фокус на первом элементе из принадлежащих данному
function FocusFirstControl(Sender: TWinControl): Boolean;
var
  I,J: Integer;
begin
  Result:=False;
  with Sender do
    for I:=0 to ControlCount-1 do begin
      if Controls[I] is TWinControl then
        //если элемент простой - передаем ему фокус
        if TWinControl(Controls[I]).ControlCount=0 then begin
          if TWinControl(Controls[I]).CanFocus then begin
            TWinControl(Controls[I]).SetFocus;
            Result:=True;
          end;
        end
        else
          //если элемент сложный - просматривем все дочерние
          for J:=0 to TWinControl(Controls[I]).ControlCount-1 do
            if TWinControl(Controls[I]).Controls[J] is TWinControl then
              if FocusFirstControl(TWinControl(TWinControl(Controls[I]).Controls[J])) then begin
                Result:=True;
                Break;
              end;
      if Result then Break;
    end;
end;

//стандартный Windows-диалог с кнопками
function MessageBox(MesStr: string; Icon: Cardinal=MB_ICONINFORMATION): Integer;
var
  CapStr: string;
begin
  if (Icon and MB_ICONINFORMATION)=MB_ICONINFORMATION then
    CapStr:='Информация'
  else if (Icon and MB_ICONWARNING)=MB_ICONWARNING then
    CapStr:='Внимание'
  else if (Icon and MB_ICONQUESTION)=MB_ICONQUESTION then
    CapStr:='Запрос'
  else if (Icon and MB_ICONSTOP)=MB_ICONSTOP then
    CapStr:='Ошибка';
  Result := MessageBoxEx(MesStr, CapStr,Icon);
end;

//Позволяет задавать заголовок сообщения
function MessageBoxEx(MesStr, Caption: string; Icon: Cardinal=MB_ICONINFORMATION): Integer;
var
  H: HWND;
begin
  if SilentMode then begin
    WriteExchangeLog(Caption, MesStr);
    if ((Icon and MB_YESNO) > 0) or ((Icon and MB_YESNOCANCEL) > 0) then
      Result := ID_YES
    else
      Result := ID_OK;
  end
  else begin
    if Screen.ActiveForm=nil then H:=0 else H:=Screen.ActiveForm.Handle;
    Result := Windows.MessageBox(H, PChar(MesStr), PChar(Caption), Icon);
  end;
end;

//Режим с "молчанием", т.е. гасим все сообщения
function SilentMode : Boolean;
begin
  Result := FSilentMode;
end;

//возвращает следующее слово из строки, усекает строку на это слово
function GetNextWord(var S: string; Delimiter: Char): string;
var
  I: Integer;
begin
  S:=Trim(S);
  I:=Pos(Delimiter,S);
  if I=0 then begin
    Result:=Trim(S);
    S:='';
  end
  else begin
    Result:=Trim(Copy(S,1,I-1));
    Delete(S,1,I);
  end;
end;

//округляет действительное число до указанного знака после запятой
function RoundFloat(Value: Extended; Decimal: Integer): Extended;
begin
  Decimal:=Trunc(IntPower(10,Decimal));
  Result:=Round(Value*Decimal)/Decimal;
end;

//если X=True возвращает Y, иначе - Z
function Iif(X: Boolean; Y,Z: Variant): Variant;
begin
	if X then Result:=Y
	else Result:=Z;
end;

//возвращает колонку из TDBGrid по имени поля
function ColumnByName(Grid: TCustomDBGrid; FieldName: string): TColumn;
var
  I: Integer;
begin
  Result:=nil;
  FieldName:=AnsiUpperCase(Trim(FieldName));
  with TDBGrid(Grid).Columns do
    for I:=0 to Count-1 do
      if AnsiUpperCase(Items[I].FieldName)=FieldName then begin
        Result:=Items[I];
        Break;
      end;
end;

function ColumnByNameT(Grid: TToughDBGrid; FieldName: string): TColumnEh;
var
  I: Integer;
begin
  Result:=nil;
  FieldName:=AnsiUpperCase(Trim(FieldName));
  with TToughDBGrid(Grid).Columns do
    for I:=0 to Count-1 do
      if AnsiUpperCase(Items[I].FieldName)=FieldName then begin
        Result:=Items[I];
        Break;
      end;
end;

//проверяет пустоту строку (т.е. или вообще пустая или только с пробелами)
function EmptyStr(St: string): Boolean;
begin
  Result:=Trim(St)='';
end;

//возвращает минимальное ненулевое целое из двух
function MinNotNull(X,Y: Integer): Integer;
begin
  if ((X<Y)and(X<>0))or(Y=0) then Result:=X else Result:=Y;
end;

//возвращает форму, которой принадлежит данный элемент
function GetParentForm(Control: TControl): TForm;
begin
  with Control do
    if Parent=nil then
      Result:=nil
    else
      if Parent is TForm then
        Result:=TForm(Parent)
      else
        Result:=GetParentForm(Parent);
end;

function FileExecute(const FileName: string; Params: string='';
  StartDir: string=''; ShowFlag: Integer=SW_SHOWNORMAL; Wait: Boolean=False): Integer;
var
  Info: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  FillChar(Info, SizeOf(Info), 0);
  Info.cbSize := SizeOf(TShellExecuteInfo);
  with Info do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(FileName);
    lpParameters := PChar(Params);
    lpDirectory := PChar(StartDir);
    nShow := ShowFlag; //SW_SHOWNORMAL, SW_MINIMIZE, SW_SHOWMAXIMIZED, SW_HIDE
  end;
  Win32CheckA(ShellExecuteEx(@Info));
  if Wait then begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(Info.hProcess, ExitCode);
    until (ExitCode<>STILL_ACTIVE) or Application.Terminated;
    Result:=ExitCode;
  end
  else
    Result:=0;
end;

procedure RaiseLastOSErrorA;
var
  I: Integer;
begin
  I:=Windows.GetLastError;
  if I<>0 then raise EOSError.Create(SysErrorMessage(I));
end;

procedure Win32CheckA(RetVal: BOOL);
begin
  if not RetVal then RaiseLastOSErrorA;
end;

function FindChildControlByClass(ParentControl: TWinControl; ClassRef: TControlClass): TControl;
var
  I: Integer;
begin
  Result:=nil;
  with ParentControl do
    for I:=0 to ControlCount-1 do
      if Controls[I] is ClassRef then begin
        Result:=Controls[I];
        Break;
      end;
end;

procedure StringToStrings(Str: string; Strings: TStrings; Delimiter: Char=';');
var
  I: Integer;
  St: string;
begin
  Strings.Clear;
  while Str<>'' do begin
    I:=Pos(Delimiter,Str);
    if I=0 then begin
      St:=Str;
      Str:='';
    end
    else begin
      St:=Copy(Str,1,I-1);
      Str:=Copy(Str,I+1,Length(Str));
    end;
    Strings.Add(Trim(St));
  end;
end;

function StringsToString(Strings: TStrings; Delimiter: Char=';'): string;
var
  I: Integer;
begin
  for I:=0 to Strings.Count-1 do
    Result:=Result+Strings[I]+Delimiter;
end;

procedure OSCopyFile(Source, Destination: string);
var
  CopyLastError : Cardinal;
  Ex : EOSError;
begin
  if FileExists(Destination) then begin
    SetFileAttributes(PChar(Destination), FILE_ATTRIBUTE_NORMAL);
    OSDeleteFile(Destination, False);
  end;
  if not Windows.CopyFile(PChar(Source), PChar(Destination), False) then
  begin
    CopyLastError := Windows.GetLastError();
    if CopyLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при копировании файла %s в %s: %s',
        [Source, Destination, SysErrorMessage(CopyLastError)]);
      Ex.ErrorCode := CopyLastError;
      raise Ex;
    end;
  end;
end;

procedure OSMoveFile(Source, Destination: string);
var
  MoveLastError : Cardinal;
  Ex : EOSError;
begin
  if FileExists(Destination) then begin
    SetFileAttributes(PChar(Destination), FILE_ATTRIBUTE_NORMAL);
    OSDeleteFile(Destination, False);
  end;
  if not Windows.CopyFile(PChar(Source), PChar(Destination), False) then
  begin
    MoveLastError := Windows.GetLastError();
    if MoveLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при перемещении файла %s в %s: %s',
        [Source, Destination, SysErrorMessage(MoveLastError)]);
      Ex.ErrorCode := MoveLastError;
      raise Ex;
    end;
  end;
  SetFileAttributes(PChar(Source), FILE_ATTRIBUTE_NORMAL);
  OSDeleteFile(Source, True);
end;

procedure OSDeleteFile(FileName: string; RaiseException: Boolean=True);
var
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if not Windows.DeleteFile(PChar(FileName)) and RaiseException then
  begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при удалении файла %s: %s',
        [FileName, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

//преобразует число в более компактную символьную запись с использованием сиволов 0..9, a..z
//0=0, 1=1, 25=p, 35=z, 36=10
function NumberToChars(Val: Integer; Len: Integer=0): string;
var
  B: Byte;
begin
  repeat
    //0..9(48..57), a..z(97..122) - всего 36 символов
    B:=48+Val mod 36;
    if B>57 then Inc(B,39); //если не попали в цифру - попадаем в букву
    Result:=Char(B)+Result;
    Val:=Val div 36;
  until Val=0;
  if Len>0 then
    if Length(Result)>Len then
      raise Exception.Create('Слишком большое число для преобразования')
    else
      Result:=StringOfChar('0',Len-Length(Result))+Result;
end;

function CharsToNumber(St: string): Integer;
var
  I: Integer;
begin
  Result:=0;
  St:=LowerCase(Trim(St));
  for I:=1 to Length(St) do begin
    Result:=Result*36;
    case St[I] of
      '0'..'9': Result:=Result+Ord(St[I])-48;
      'a'..'z': Result:=Result+Ord(St[I])-97+10;
    end;
  end;
end;

function StrToProxyType(St: string): TIdFtpProxyType;
begin
  St:=UpperCase(Trim(St));
  if St='USERSITE' then Result:=fpcmUserSite
  else if St='SITE' then Result:=fpcmSite
  else if St='OPEN' then Result:=fpcmOpen
  else if St='USERPASS' then Result:=fpcmUserPass
  else if St='TRANSPARENT' then Result:=fpcmTransparent
  else if St='HTTPPROXYWITHFTP' then Result:=fpcmHttpProxyWithFtp
  else Result:=fpcmNone;
end;

function ProxyTypeToStr(ProxyType: TIdFtpProxyType): string;
begin
  case ProxyType of
    fpcmNone: Result:='None';
    fpcmUserSite: Result:='UserSite';
    fpcmSite: Result:='Site';
    fpcmOpen: Result:='Open';
    fpcmUserPass: Result:='UserPass';
    fpcmTransparent: Result:='Transparent';
    fpcmHttpProxyWithFtp: Result:='HttpProxyWithFtp';
  end;
end;

function GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  Win32CheckA(LongBool(GetTempPath(SizeOf(Buffer), Buffer)));
  Result:=IncludeTrailingBackslash(Buffer);
end;

procedure DeleteFilesByMask(FileName: string; RaiseException: Boolean=True);
var
  SR: TSearchrec;
  Path: string;
begin
  Path:=ExtractFilePath(FileName);
  if SysUtils.FindFirst(FileName,faAnyFile-faDirectory,SR)=0 then
    try
      repeat
        OSDeleteFile(Path+SR.Name,RaiseException);
      until FindNext(SR)<>0;
    finally
      SysUtils.FindClose(SR);
    end;
end;

function GetTimeZoneBias: Integer;
var
  TimeZoneInfo: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TimeZoneInfo) of
  TIME_ZONE_ID_STANDARD: Result := TimeZoneInfo.Bias + TimeZoneInfo.StandardBias;
  TIME_ZONE_ID_DAYLIGHT: Result := TimeZoneInfo.Bias + TimeZoneInfo.DaylightBias;
  else
    Result := 0;
  end;
end;

function UTCToLocalTime(UTC: TDateTime): TDateTime;
begin
  Result:=IncMinute(UTC,-TimeZoneBias);
end;

function LocalTimeToUTC(DateTime: TDateTime): TDateTime;
begin
  Result:=IncMinute(DateTime,TimeZoneBias);
end;

procedure MailTo(EMail,Subject: string);
begin
  ShellExecute(0, nil,PChar('mailto:'+EMail+'?Subject='+Subject),nil,nil,SW_SHOWDEFAULT);
end;

procedure UrlLink(Address: string);
begin
  ShellExecute(0, nil,PChar(Address),nil,nil,SW_SHOWDEFAULT);
end;

function ExtractURL(const URL: string): string;
var
  I: Integer;
begin
  Result:=Trim(URL);
  I:=Pos('//',URL);
  if I>0 then Delete(Result,1,I+1);
  I:=Pos('/',Result);
  if I>0 then Delete(Result,I,Length(Result));
  Result:=Trim(Result);
end;

function SimpleHash( AStr: string): string;
var
	i: integer;
	h: integer;
begin
	h := 0;
	for i := 1 to Length( AStr) do
	begin
		h := h xor Ord( AStr[ i]);
		h := h shl 1;
	end;
	result := IntToHex( h, 8);
end;

procedure LogCriticalError(Error: String);
begin
  WriteExchangeLog('CriticalError', Error);
end;

procedure LogExitError(Error : String; ExitCode : Integer; ShowErrorMessage : Boolean = True);
begin
  LogCriticalError(Error);
  if ShowErrorMessage then
    MessageBox(Error, MB_ICONERROR or MB_OK);
  ExitProcess( ExitCode );
end;

function AddRangeStartToURL(AURL : String; Position : Int64) : String;
begin
  Result := AURL;
  //Выполняем это все, если необходима докачка и URL не пустой
  if (Position > 0) and (Length(AURL) > 0) then
    if AnsiContainsText(AURL, '?') then
      if (AURL[Length(AURL)] in ['&', '?']) then
        Result := AURL + 'RangeStart=' + IntToStr(Position)
      else
        Result := AURL + '&RangeStart=' + IntToStr(Position)
    else
      Result := AURL + '?RangeStart=' + IntToStr(Position);
end;

procedure InternalDoSendLetter(
  SendIdHTTP : TIdHTTP;    //Компонент для отправки письма
  SendURL : String;        //URL, по которому происходит доступ
  TempSendDir : String;    //Временная папка для создания аттачмента
  Attachs : TStringList;   //Список приложений
  Subject, Body : String); //Тема письма и тело письма
var
  slLetter : TStringList;
  start,
  stop : Integer;
  SevenZipRes : Integer;
  FS : TFileStream;
  S,
  bs : String;
  LE : TIdEncoderMIME;
  ss : TStringStream;
  OldAccept,
  OldConnection,
  OldContentType : String;

  procedure CopyingFiles;
  var
    I : Integer;
  begin
    for I := 0 to Attachs.Count-1 do
      if FileExists(Attachs[i]) then
        if not Windows.CopyFile(PChar(Attachs[i]), PChar(GetTempDir + TempSendDir + '\' +ExtractFileName(Attachs[i])), false) then
          raise Exception.Create('Не удалось скопировать файл: ' + Attachs[i] + #13#10'Причина: ' + SysErrorMessage(GetLastError));
  end;

  procedure ArchiveAttach;
  begin
    SZCS.Enter;
    try
      SevenZipRes := SevenZipCreateArchive(
        0,
        GetTempDir + TempSendDir + '\Attach.7z',
        GetTempDir + TempSendDir,
        '*.*',
        9,
        false,
        false,
        '',
        false,
        nil);
      if SevenZipRes <> 0 then
        raise Exception.CreateFmt('Не удалось заархивировать отправляемые файлы. Код ошибки %d', [SevenZipRes]);
    finally
      SZCS.Leave;
    end;
  end;

  procedure EncodeToBase64;
  begin
    LE := TIdEncoderMIME.Create(nil);
    try
      FS := TFileStream.Create(GetTempDir + TempSendDir + '\Attach.7z', fmOpenReadWrite);
      try
        bs := le.Encode(FS, ((FS.Size div 3) + 1) * 3);
      finally
        FS.Free;
      end;
    finally
      LE.Free;
    end;
  end;

  procedure FormatSoapMessage;
  begin
    slLetter.Add('<?xml version="1.0" encoding="windows-1251"?>');
    slLetter.Add('<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">');
    slLetter.Add('  <soap:Body>');
    slLetter.Add('    <SendLetter xmlns="IOS.Service">');
    slLetter.Add('      <subject>' + SXReplaceXML(Subject) + '</subject>');
    slLetter.Add('      <body>' + SXReplaceXML(Body) + '</body>');
    slLetter.Add(Concat('      <attachment>', bs, '</attachment>'));
    slLetter.Add('    </SendLetter>');
    slLetter.Add('  </soap:Body>');
    slLetter.Add('</soap:Envelope>');
    slLetter.Add('');
    slLetter.Add('');
  end;

begin
  if DirectoryExists(GetTempDir + TempSendDir) then
    if not ClearDir(GetTempDir + TempSendDir, True) then
      raise Exception.Create('Не получилось удалить временную директорию: ' + GetTempDir + TempSendDir);

  if not CreateDir(GetTempDir + TempSendDir) then
    raise Exception.Create('Не получилось создать временную директорию: ' + GetTempDir + TempSendDir);

  slLetter := TStringList.Create;
  try

    //Формируем список файлов
    CopyingFiles;

    ArchiveAttach;

    EncodeToBase64;

    FormatSoapMessage;

    ss := TStringStream.Create(slLetter.Text);
    try
      ss.Position := 0;
      OldAccept := SendIdHTTP.Request.Accept;
      OldConnection := SendIdHTTP.Request.Connection;
      OldContentType := SendIdHTTP.Request.ContentType;
      SendIdHTTP.Request.Accept := '';
      SendIdHTTP.Request.Connection := '';
      SendIdHTTP.Request.ContentType := 'application/soap+xml; charset=windows-1251; action="IOS.Service/SendLetter"';

      S := SendIdHTTP.Post(SendURL, ss);
     	start := PosEx( '>', S, Pos( 'SendLetterResult', S)) + 1;
    	stop := PosEx( '</', S, start);
	    S := Copy( S, start, stop - start);
      if AnsiStartsText('Error=', S) then
        raise Exception.Create(Utf8ToAnsi( Copy(S, 7, Length(S)) ));

    finally
      SendIdHTTP.Request.Accept := OldAccept;
      SendIdHTTP.Request.Connection := OldConnection;
      SendIdHTTP.Request.ContentType := OldContentType;
      ss.Free;
    end;

  finally
    slLetter.Free;
  end;

  ClearDir(GetTempDir + TempSendDir, True);
end;

function GetLibraryVersionFromAppPath : TObjectList;
var
  DirPath : String;

  function IsExeFile(Name : String) : Boolean;
  begin
    Result := AnsiEndsText('.exe', Name) or AnsiEndsText('.bpl', Name) or AnsiEndsText('.dll', Name); 
  end;

  function GetLibraryVersionFromPath(AName: String): String;
  var
    RxVer : TVersionInfo;
  begin
    if FileExists(AName) then begin
      try
        RxVer := TVersionInfo.Create(AName);
        try
          Result := LongVersionToString(RxVer.FileLongVersion);
        finally
          RxVer.Free;
        end;
      except
        Result := '';
      end;
    end
    else
      Result := '';
  end;

  procedure FindVersionsEx(StartDir : String; Res : TObjectList; RelativePath : String);
  var
    sr : TSearchRec;
    FName, FVersion, FHash : String;
  begin
    if SysUtils.FindFirst(StartDir + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then begin
          if sr.Attr and faDirectory > 0 then begin
            FindVersionsEx(StartDir + sr.Name + '\', Res, RelativePath + sr.Name + '\');
          end
          else
            if IsExeFile(sr.Name) then begin
              FName := sr.Name;
              FVersion := GetLibraryVersionFromPath(StartDir + sr.Name);
              FHash := GetFileHash(StartDir + sr.Name);
              Res.Add(TFileUpdateInfo.Create(RelativePath + FName, FVersion, FHash));
            end;
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
  end;

begin
  Result := TObjectList.Create(True);
  try
    DirPath := ExtractFilePath(ParamStr(0));
    FindVersionsEx(DirPath, Result, '');
  except
    Result.Free;
    raise;
  end;
end;

procedure InternalSetSSLParams(SSL : TIdSSLIOHandlerSocketOpenSSL);
begin
  SSL.SSLOptions.Method := sslvSSLv3;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyDepth := 0;
  SSL.SSLOptions.VerifyMode := [];
end;

function GetFileHash(AFileName: String): String;
var
  md5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  try
    md5 := TIdHashMessageDigest5.Create;
    try

      fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
      try
        Result := md5.HashStreamAsHex( fs );
      finally
        fs.Free;
      end;

    finally
      md5.Free;
    end;
  except
    Result := '';
  end;
end;

function StringToCodes( AStr: string): string;
var
	i: integer;
begin
	Result := '';
	for i := 1 to Length( Astr) do
    Result := Result + Format('%.3d', [Ord( AStr[i] )]);
end;

function GetXMLDateTime( ADateTime: TDateTime): string;
begin
	result := IntToStr( YearOf( ADateTime)) + '-' +
		IntToStr( MonthOf( ADateTime)) + '-' +
		IntToStr( DayOf( ADateTime)) + ' ' +
		IntToStr( HourOf( ADateTime)) + ':' +
		IntToStr( MinuteOf( ADateTime)) + ':' +
		IntToStr( SecondOf( ADateTime));
end;

function WordCount(const S: string; const WordDelims: TSysCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

function GetLoadDataSQL(TableName : String; InputFileName : String; Replace : Boolean = False) : String;
begin
  InputFileName := StringReplace(InputFileName, '\', '/', [rfReplaceAll]);
  Result :=
    'LOAD DATA INFILE ''' + InputFileName + ''' '
    + IfThen(Replace, ' replace ') +
    ' INTO TABLE AnalitF.' + TableName + ' FIELDS TERMINATED BY ''' + Chr(159) + '''' +
    ' OPTIONALLY ENCLOSED BY '''' ESCAPED BY '''' LINES TERMINATED BY ''' + Chr(161) + ''';';
end;

procedure CopyDirectories(const fromDir, toDir: String);
var
  SR : TSearchRec;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);

  if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          CopyDirectories(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
        else
          OSCopyFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;

procedure MoveDirectories(const fromDir, toDir: String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if not DirectoryExists(toDir) then
    ForceDirectories(toDir);
    
  if FindFirst(fromDir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          MoveDirectories(fromDir + '\' + sr.Name, toDir + '\' + sr.Name)
        else
          OSMoveFile(fromDir + '\' + sr.Name, toDir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

  if not Windows.RemoveDirectory(PChar(fromDir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при перемещении директории %s: %s',
        [fromDir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

procedure DeleteDirectory(const Dir : String);
var
  SR : TSearchRec;
  DeleteLastError : Cardinal;
  Ex : EOSError;
begin
  if FindFirst(Dir + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then

        //Если мы встретили директорию
        if (sr.Attr and faDirectory > 0) then
          DeleteDirectory(Dir + '\' + sr.Name)
        else
          OSDeleteFile(Dir + '\' + sr.Name);

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
  
  if not Windows.RemoveDirectory(PChar(Dir)) then begin
    DeleteLastError := Windows.GetLastError();
    if DeleteLastError <> Windows.ERROR_SUCCESS then
    begin
      Ex := EOSError.CreateFmt('Ошибка при удалении директории %s: %s',
        [Dir, SysErrorMessage(DeleteLastError)]);
      Ex.ErrorCode := DeleteLastError;
      raise Ex;
    end;
  end;
end;

{ TFileUpdateInfo }

constructor TFileUpdateInfo.Create(AFileName, AVersion, AMD5: String);
begin
  FileName := AFileName;
  Version := AVersion;
  MD5 := AMD5;
end;

initialization
  SZCS := TCriticalSection.Create;
  //Если запускаем программу для обмена (е) или импортирования (se)
  FSilentMode := FindCmdLineSwitch('e') or FindCmdLineSwitch('si');
  //инициализация глобальных переменных
  ExePath:=IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))); //путь к программе
  ExeName:=ExtractFileName(ParamStr(0)); //наименование EXE-шника (без пути)
  DatabaseName:=ChangeFileExt(ExeName,'.fdb');
  TempPath:=GetTempDir;
  IniFile:=TIniFile.Create(GetDefaultIniName);
  //локальные установки для экспорта
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT,ExportFormat);
  with ExportFormat do begin
    CurrencyFormat:=1;
    NegCurrFormat:=5;
    ThousandSeparator:=#0;
    DecimalSeparator:='.';
    CurrencyDecimals:=2;
    DateSeparator:='.';
    TimeSeparator:=':';
    ListSeparator:=';';
    CurrencyString:='р.';
    ShortDateFormat:='dd.mm.yyyy';
    TimeAMString:='';
    TimePMString:='';
    ShortTimeFormat:='h:mm';
    LongTimeFormat:='h:mm:ss';
    TwoDigitYearCenturyWindow:=0;
  end;
  TimeZoneBias:=GetTimeZoneBias;
finalization
  SZCS.Free;;
  IniFile.Free;
end.

