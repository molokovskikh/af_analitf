unit AProc;

interface

uses SysUtils, Controls, Windows, Forms, StrUtils, Classes, Math, DBGrids,
  ComCtrls, Messages, ShellApi, IniFiles, AppUtils, IdFTP, DateUtils, ToughDBGrid,
	DbGridEh;

const
  WM_AFTERRETRIEVEMAIL=WM_USER+100; //сообщение о получении сообщений. с сервера
  SSectionParams='Params';
  SConnectRAS='RAS'; SConnectPROXY='PROXY'; SConnectNONE='NONE';
  SDirDocs='Docs';
  SDirIn='In';
  SDirReclame='Reclame';
  SHTTPPrefix='http://';
  CRLF=#13#10;

var
  ExePath, ExeName, DatabaseName, TempPath: string;
  IniFile: TIniFile;
  WordDelimitersA: set of Char;
  ExportFormat: TFormatSettings;
  TimeZoneBias: Integer;


procedure FocusNextControl(Sender: TWinControl);
function FocusFirstControl(Sender: TWinControl): Boolean;
function MessageBox(MesStr: string; Icon: Cardinal=MB_ICONINFORMATION): Integer;
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
procedure CopyFileA(Source, Destination: string; Overwrite: Boolean=True; RaiseException: Boolean=True);
procedure MoveFileA(Source, Destination: string; Overwrite: Boolean=True; RaiseException: Boolean=True);
procedure DeleteFileA(FileName: string; RaiseException: Boolean=True);
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
procedure MoveFile_( ASource, ADest: string);
function SimpleHash( AStr: string): string;

implementation

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
  H: HWND;
begin
  if (Icon and MB_ICONINFORMATION)=MB_ICONINFORMATION then
    CapStr:='Информация'
  else if (Icon and MB_ICONWARNING)=MB_ICONWARNING then
    CapStr:='Внимание'
  else if (Icon and MB_ICONQUESTION)=MB_ICONQUESTION then
    CapStr:='Запрос'
  else if (Icon and MB_ICONSTOP)=MB_ICONSTOP then
    CapStr:='Ошибка';
  if Screen.ActiveForm=nil then H:=0 else H:=Screen.ActiveForm.Handle;
	Result:=Windows.MessageBox(H,PChar(MesStr),PChar(CapStr),Icon);
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

procedure CopyFileA(Source, Destination: string; Overwrite: Boolean=True; RaiseException: Boolean=True);
begin
  if not Windows.CopyFile(PChar(Source),PChar(Destination),not Overwrite) and RaiseException then
    RaiseLastOSErrorA;
end;

procedure MoveFileA(Source, Destination: string; Overwrite: Boolean=True; RaiseException: Boolean=True);
begin
  if Overwrite then DeleteFileA(Destination,False);
  if not Windows.MoveFile(PChar(Source),PChar(Destination)) and RaiseException then
    RaiseLastOSErrorA;
end;

procedure DeleteFileA(FileName: string; RaiseException: Boolean=True);
begin
  if not Windows.DeleteFile(PChar(FileName)) and RaiseException then
    RaiseLastOSErrorA;
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
        DeleteFileA(Path+SR.Name,RaiseException);
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

procedure MoveFile_( ASource, ADest: string);
var
	le: integer;
begin
	if not Windows.CopyFile( PChar( ASource),
		PChar( ADest), False) then
	begin
		le := GetLastError;
		raise Exception.Create( 'Ошибка при копировании. Код : ' + IntToStr( le) +
			#10 + #13 + 'Исходный файл : ' + ASource +
			#10 + #13 + 'Файл приемник : ' + ADest);
	end;
	if not Windows.DeleteFile( PChar( ASource)) then
	begin
		le := GetLastError;
		raise Exception.Create( 'Ошибка при удалении. Код : ' + IntToStr( le) +
			#10 + #13 + 'Файл : ' + ASource);
	end;
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

  {procedure XMLTableToStrings(XML: string; TableName: string; Strings: TStrings);
    procedure ProcessNode(Node: IXMLNode);
    var
      I: Integer;
    begin
      if (Node.NodeType=ntText)and(Node.ParentNode<>nil)and(Node.ParentNode.ParentNode<>nil)and
        (AnsiUpperCase(Node.ParentNode.ParentNode.NodeName)=TableName) then
        Strings.Values[Node.ParentNode.NodeName]:=Node.Text;
      for I:=0 to Node.ChildNodes.Count-1 do
        ProcessNode(Node.ChildNodes[I]);
    end;
  begin
    TableName:=AnsiUpperCase(Trim(TableName));
    Strings.Clear;
    XMLDocument.LoadFromXML(XML);
    try
      ProcessNode(XMLDocument.DocumentElement);
    finally
      XMLDocument.Active:=False;
    end;
  end;}

initialization
  //инициализация глобальных переменных
  ExePath:=IncludeTrailingBackslash(ExtractFileDir(ParamStr(0))); //путь к программе
  ExeName:=ExtractFileName(ParamStr(0)); //наименование EXE-шника (без пути)
  DatabaseName:=ChangeFileExt(ExeName,'.mdb');
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
  IniFile.Free;
end.

