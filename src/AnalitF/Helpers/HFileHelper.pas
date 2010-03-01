unit HFileHelper;

interface

uses
  SysUtils, Classes, Windows, FileUtil, AProc, U_ExchangeLog;

type
  //HFileHelper - это сокращение от hosts file helper
  //Даные взяты отсюда : http://ru.wikipedia.org/wiki/Hosts
  THFileHelper = class
   private
    FClientFileName : String;
    function CodesToString(Codes : String) : String;
   public
    constructor Create();
    //Получить исходное содержимое файла
    function GetSourceFileContent : String;
    //Получить содержимое файла, готовое к отправке по http
    function GetFileContent : String;
    //Сохранить новое кодированое содержимое файла
    procedure SaveFileContent(Content : String);
    //Сохранить новое раскодированое содержимое файла
    procedure SaveDecodedFileContent(Content : String);
    //Местонахождение файла hosts на компьютере клиента
    property ClientFileName : String read FClientFileName;
  end;

implementation

{ THFileHelper }

function THFileHelper.CodesToString(Codes: String): String;
const
  Convert : array['0'..'9'] of byte = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
var
  I : Integer;
begin
  Result := '';
  I := 1;
  while (I <= Length(Codes) - 2) do begin
    Result := Result +
      Chr(
        Convert[Codes[i]]*100 +
        Convert[Codes[i+1]]*10 +
        Convert[Codes[i+2]]);
    Inc(I, 3);
  end;
end;

constructor THFileHelper.Create;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    FClientFileName := GetEnvironmentVariable('SystemRoot') +
      '\system32\drivers\etc\hosts'
  else
    FClientFileName := GetEnvironmentVariable('WinDir') + '\hosts';
end;

function THFileHelper.GetFileContent: String;
begin
  Result := StringToCodes(GetSourceFileContent);
end;

function THFileHelper.GetSourceFileContent: String;
var
  StringList : TStringList;
begin
  if not FileExists(FClientFileName) then
    Result := ''
  else begin
    StringList := TStringList.Create;
    try
      StringList.LoadFromFile(FClientFileName);
      Result := StringList.Text;
    finally
      StringList.Free;
    end;
  end;
end;

procedure THFileHelper.SaveDecodedFileContent(Content: String);
var
  StringList : TStringList;
  FileStream : TFileStream;
begin
  StringList := TStringList.Create;
  try
    StringList.Text := Content;
    if FileExists(FClientFileName) then begin
      FileStream := TFileStream.Create(FClientFileName, fmOpenWrite or fmShareDenyWrite);
      try
        FileStream.Size := 0;
        FileStream.Position := 0;
        StringList.SaveToStream(FileStream);
      finally
        FileStream.Free;
      end;
    end
    else
      StringList.SaveToFile(FClientFileName);
  finally
    StringList.Free;
  end;
end;

procedure THFileHelper.SaveFileContent(Content: String);
begin
  SaveDecodedFileContent(CodesToString(Content));
end;

end.
 