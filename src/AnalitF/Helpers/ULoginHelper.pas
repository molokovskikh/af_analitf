unit ULoginHelper;

interface

uses
  SysUtils, Classes, Windows;

const
  httpdialStart     = 'http';
  keyFileStart      = 'Libc';
  ProgramFolderEnd  = 'Order';
  httpdialEnd       = 'dial';
  HTTPDialFolderEnd = 'FES';
  keyFileEnd        = 'url';
  BaseFolder        = 'Base';

type
  TUStatData = record
    Login, Password, OriginalPassword : String;
    SerialData : String;
    MaxWriteTime : TDateTime;
    MaxWriteFileName : String;
    OrderWriteTime : TDateTime;
    ClientTimeZoneBias : Integer;
  end;

  TULoginHelper = class
   private
    class function GetUSettingsFolder : String;
    class function GetUSettingsKeyName : String;
    class function ReadFirstNotNullByte(keyStream : TStream) : Byte;
    class function DecryptByte(keyStream : TStream; valueStream : TStream) : Byte;
    class function GetMaxFileAgeByName(FileName : String) : TDateTime;
    class function GetMaxFileAgeByFileTime(
      LastWriteFileTime, CreationFileTime : TFileTime) : TDateTime;
    //Попытаемся получить учетные данные из программы UOrder "Сводный заказ"
    class procedure GetULoginData(var Login, Password, OriginalPassword : String);
    //Получаем серийный номер диска, где стоит программа UOrder
    class function GetUSerialData() : String;
    //Получить максимальное время изменения файла UOrder/Base/Order.dbf
    class function GetUOrderDateTime : TDateTime;
    class procedure GetMaxWriteTime(
      var MaxWriteTime : TDateTime;
      var MaxWriteFileName : String);
   public
    class function GetUSettingsFileName : String;
    //пытаемся расшифровать пароль
    class function GetUSecureData(Password : String) : String;
    //Получить путь к папке UOrder/Base
    class function GetUBaseFolder : String;
    //Получить путь к файлу UOrder/Base/Order.dbf
    class function GetUOrderFileName : String;
    //Получить данные статистики
    class function GetUStatData() : TUStatData;
  end;

implementation

uses
  AProc;
  
class function TULoginHelper.GetUSettingsFolder : String;
begin
  Result :=
    GetEnvironmentVariable('ProgramFiles') + '\U' + ProgramFolderEnd + '\'
      + 'U' + HTTPDialFolderEnd + '\';
end;

class function TULoginHelper.GetUSettingsFileName : String;
begin
  Result := GetUSettingsFolder + httpdialStart + httpdialEnd + '.ini';
end;

class function TULoginHelper.GetUSettingsKeyName : String;
begin
  Result := GetUSettingsFolder + keyFileStart + keyFileEnd + '.dll';
end;

class procedure TULoginHelper.GetULoginData(var Login, Password, OriginalPassword : String);
var
  settingsFileName : String;
  StringList : TStringList;
  I : Integer;
  Index : Integer;
begin
  Login := '';
  Password := '';
  OriginalPassword := '';
  settingsFileName := GetUSettingsFileName;
  if FileExists(settingsFileName) then begin
    StringList := TStringList.Create;
    try
      StringList.LoadFromFile(settingsFileName);
      I := 0;
      while ((Length(Login) = 0) or (Length(Password) = 0))
        and (I < StringList.Count) do
      begin
        if Pos('Login:', StringList[i]) > 0 then
        begin
          Index := Pos('Login:', StringList[i]);
          Login := Trim(Copy(StringList[i], Index + 6, 1024));
        end
        else
          if Pos('Password:', StringList[i]) > 0 then
          begin
            Index := Pos('Password:', StringList[i]);
            Password := Trim(Copy(StringList[i], Index + 9, 1024));
          end;
        Inc(I);
      end;

      if Length(Password) > 0 then
        OriginalPassword := Password;
    finally
      StringList.Free;
    end;
  end;
end;

class function TULoginHelper.ReadFirstNotNullByte(keyStream : TStream) : Byte;
var
  value : Byte;
begin
  Result := 0;
  while (keyStream.Position < keyStream.Size) do begin
    keyStream.ReadBuffer(value, 1);
    if value <> 0 then begin
      Result := value;
      Exit;
    end;
  end;
  if keyStream.Position = keyStream.Size then
    raise Exception.Create('Файл с данными (3259) закончился, а данных нет');
end;

class function TULoginHelper.DecryptByte(keyStream : TStream; valueStream : TStream) : Byte;
var
  keyByte : Byte;
  byte1   : Byte;
  byte2   : Byte;
begin
  valueStream.ReadBuffer(byte1, 1);
  valueStream.ReadBuffer(byte2, 1);
  keyByte := ReadFirstNotNullByte(keyStream);
{
  Result := Byte(
    ( Integer(byte1) + (Integer(byte2) shl 4) )  xor Integer(keyByte) );
  //В этом месте может случится Range check error, т.к. получим значение больше чем байт
}
  Result := (byte1 + (byte2 shl 4) )  xor keyByte;
end;

class function TULoginHelper.GetUSecureData(Password : String) : String;
var
  offset : Integer;
  valueStream : TMemoryStream;
  keyFile : TFileStream;
  Count : Byte;
  I : Integer;
  memoryData : array of Byte;
begin
  Result := '';
  if Length(Password) = 0 then
    Exit;

  if Password[1] = '*' then begin
    if not FileExists(GetUSettingsKeyName) then
      raise Exception.Create('Файл с данными (3259) не существует.');

    Password := Copy(Password, 2, Length(Password));

    offset :=
      StrToInt(Concat('$', Password[1]))
      + (StrToInt(Concat('$', Password[2])) shl 4)
      + (StrToInt(Concat('$', Password[3])) shl 8)
      + (StrToInt(Concat('$', Password[4])) shl 12);

    Password := Copy(Password, 5, Length(Password));

    SetLength(memoryData, Length(Password));
    for I := 1 to Length(Password) do
      memoryData[i-1] := StrToInt(Concat('$', Password[i]));

    valueStream := TMemoryStream.Create();
    try

      valueStream.WriteBuffer(memoryData[0], Length(memoryData));
      valueStream.Position := 0;

      keyFile := TFileStream.Create(GetUSettingsKeyName,
        fmOpenRead or fmShareDenyWrite);
      try

        keyFile.Position := offset;

        Count := DecryptByte(keyFile, valueStream);
        for I := 1 to Count do
          Result := Concat(Result, Chr(DecryptByte(keyFile, valueStream)));

      finally
        keyFile.Free;
      end;

    finally
      valueStream.Free;
    end;
  end
  else
    Result := Password;
end;

class function TULoginHelper.GetUSerialData() : String;
var
  VolLabel, FileSystemName: array[ 0..MAX_PATH] of Char;
  NotUsed, VolFlags: DWORD;
  SerialNum: DWORD;
  Drive: PChar;
begin
  FileSystemName[ 0] := #$00;
  VolLabel[ 0] := #$00;
  SerialNum := 0;

  Drive := PChar(ExtractFileDrive(GetUSettingsKeyName) + '\');
  GetVolumeInformation( Drive, VolLabel, DWORD( sizeof( VolLabel)),
    @SerialNum, NotUsed, VolFlags, FileSystemName, DWORD( sizeof( FileSystemName)));
  Result := IntToHex( SerialNum, 8);
end;

class function TULoginHelper.GetMaxFileAgeByName(
  FileName: String): TDateTime;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := Windows.FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Result := GetMaxFileAgeByFileTime(
        FindData.ftLastWriteTime, FindData.ftCreationTime);
      Exit;
    end;
  end;
  Result := 0;
end;

class function TULoginHelper.GetMaxFileAgeByFileTime(
  LastWriteFileTime, CreationFileTime : TFileTime) : TDateTime;
var
  tmpSystemTime : TSystemTime;
  LastWriteTime, CreationTime : TDateTime;
begin
  FileTimeToSystemTime(LastWriteFileTime, tmpSystemTime);
  LastWriteTime := SystemTimeToDateTime(tmpSystemTime);
  FileTimeToSystemTime(CreationFileTime, tmpSystemTime);
  CreationTime := SystemTimeToDateTime(tmpSystemTime);
  if LastWriteTime > CreationTime then
    Result := LastWriteTime
  else
    Result := CreationTime;
end;

class function TULoginHelper.GetUBaseFolder: String;
begin
  Result :=
    GetEnvironmentVariable('ProgramFiles') + '\U' + ProgramFolderEnd + '\'
      + BaseFolder;
end;

class function TULoginHelper.GetUOrderDateTime: TDateTime;
begin
  Result := GetMaxFileAgeByName(GetUOrderFileName);
end;

class function TULoginHelper.GetUOrderFileName: String;
begin
  Result := GetUBaseFolder + '\' + 'Order.dbf';
end;

class function TULoginHelper.GetUStatData() : TUStatData;
begin
  GetULoginData(Result.Login, Result.Password, Result.OriginalPassword);
  Result.SerialData := GetUSerialData;
  GetMaxWriteTime(Result.MaxWriteTime, Result.MaxWriteFileName);
  Result.OrderWriteTime := GetUOrderDateTime;
  Result.ClientTimeZoneBias := AProc.GetTimeZoneBias;
end;

class procedure TULoginHelper.GetMaxWriteTime(
  var MaxWriteTime : TDateTime;
  var MaxWriteFileName : String);
var
  SearchRec : TSearchRec;
  CurrentWriteTime : TDateTime;
  CurrentFileName  : String;
begin
  MaxWriteTime := 0;
  MaxWriteFileName := '';
  if DirectoryExists(GetUBaseFolder) then begin
    if FindFirst( GetUBaseFolder + '\*.*', faAnyFile, SearchRec) = 0 then
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then begin

          CurrentWriteTime := GetMaxFileAgeByFileTime(
            SearchRec.FindData.ftLastWriteTime,
            SearchRec.FindData.ftCreationTime);
          CurrentFileName := SearchRec.Name;

          if CurrentWriteTime > MaxWriteTime then begin
            MaxWriteTime := CurrentWriteTime;
            MaxWriteFileName := CurrentFileName;
          end;
        end;
      until (FindNext( SearchRec ) <> 0)
    finally
      SysUtils.FindClose( SearchRec );
    end;
  end
end;

{
var
  l, p, o : String;
  D : TDateTime;
  DateStr : String;
  statData : TUStatData;
initialization
  statData := TULoginHelper.GetUStatData();
  if (Length(statData.Password) > 0) then
  begin
    try
      p := TULoginHelper.GetUSecureData(statData.Password);
      Assert(p = 'testpass', 'Не совпадают значения');
    except
      on E : Exception do
        Assert(False, 'Ошибка при разборе: ' + E.Message);
    end;
    try
      p := TULoginHelper.GetUSecureData('*663098B3103F091CD09AF8FE1381B30');
      Assert(p = '123', 'Не совпадают значения');
    except
      on E : Exception do
        Assert(False, 'Ошибка при разборе: ' + E.Message);
    end;
    try
      p := TULoginHelper.GetUSecureData('samepass');
      Assert(p = 'samepass', 'Не совпадают значения');
    except
      on E : Exception do
        Assert(False, 'Ошибка при разборе: ' + E.Message);
    end;
    try
      p := TULoginHelper.GetUSecureData('');
      Assert(p = '', 'Не совпадают значения');
    except
      on E : Exception do
        Assert(False, 'Ошибка при разборе: ' + E.Message);
    end;
  end;
  Assert(statData.SerialData <> '', 'Серийный номер диска не получен');
  Assert(statData.MaxWriteTime > 1, 'Максимальное время изменения файлов в папке Base получили не корректно');
  Assert(statData.MaxWriteFileName <> '', 'Имя файла с максимальным временем изменения файлов в папке Base получили не корректно');
  Assert(statData.OrderWriteTime > 1, 'Время файла заказа получили не корректно');
  Assert(statData.ClientTimeZoneBias <> 0, 'TimeZoneBias получили не корректно');
}  
end.
