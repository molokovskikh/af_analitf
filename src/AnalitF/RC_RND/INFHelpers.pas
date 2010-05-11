unit INFHelpers;

interface

uses
  SysUtils, Classes, infvercls;

const
  LibraryFileNameStart = 'appd';

  procedure EncodeStream(InputStream : TStream; EncodedStream : TStream);

  procedure DecodeStream(EncodedStream : TStream; DecodedStream : TStream);

  function GetEncryptedMemoryStream(fileName : String = '') : TMemoryStream;

var
  LibraryFileNameEnd : String;

implementation

const
  StreamKeyStart = 'rklkwedk';
  StreamKeyEnd   = 'fhqpalfh';
  //Читаем размером по 10 КБайт
  FileBufferLen  = 10*1024;

type
  TMemoryStreamExtend = class(TMemoryStream);

procedure EncodeStream(InputStream : TStream; EncodedStream : TStream);
var
  crypter : TINFCrypt;
  BufferString : String;
  RestOfStream : Int64;
  CryptedString : String;
begin
  if EncodedStream.Size > 0 then
    raise Exception.Create('EncodedStream содержит данные.');

  if InputStream.Size = 0 then
    Exit;

  crypter := TINFCrypt.Create(
    StreamKeyStart + StreamKeyEnd,
    FileBufferLen + INFDataLen);
  try
    SetLength(BufferString, FileBufferLen);

    while (InputStream.Size - InputStream.Position) > 0 do begin

      RestOfStream := InputStream.Size - InputStream.Position;

      if RestOfStream < FileBufferLen then begin
        SetLength(BufferString, RestOfStream);
        InputStream.ReadBuffer(BufferString[1], RestOfStream);
      end
      else
        InputStream.ReadBuffer(BufferString[1], FileBufferLen);

      CryptedString := crypter.Encode(BufferString);
      EncodedStream.WriteBuffer(CryptedString[1], Length(CryptedString));
    end;

  finally
    crypter.Free;
  end;
end;

procedure DecodeStream(EncodedStream : TStream; DecodedStream : TStream);
var
  crypter : TINFCrypt;
  BufferString : String;
  RestOfStream : Int64;
  DeCryptedString : String;
  DecryptBufferLen : Integer;

  procedure SetMemoryCapacity(DecodedStream : TMemoryStreamExtend);
  var
    BlockCount : Longint;
    RestOfSize : Longint;
{$ifdef DEBUG}
    NewCapacity: Longint;
{$endif}
  begin
    BlockCount := (EncodedStream.Size div (FileBufferLen + INFDataLen));
    RestOfSize := (EncodedStream.Size mod (FileBufferLen + INFDataLen));
    if BlockCount < 0 then
      raise Exception.Create('Не получилось выделить достаточное кол-во памяти')
    else
      if BlockCount = 0 then
        DecodedStream.Capacity := RestOfSize - INFDataLen
      else begin
{$ifdef DEBUG}
        NewCapacity := (BlockCount * FileBufferLen) + (RestOfSize - INFDataLen);
        DecodedStream.Capacity := NewCapacity;
{$else}
        DecodedStream.Capacity := (BlockCount * FileBufferLen) + (RestOfSize - INFDataLen);
{$endif}
      end;
  end;

begin
  if DecodedStream.Size > 0 then
    raise Exception.Create('DecodedStream содержит данные.');

  if EncodedStream.Size = 0 then
    Exit;

  //Устнавливаем сразу емкость MemoryStream,
  //чтобы сразу выделить нужное кол-во памяти, а не выделять частями
  if DecodedStream is TMemoryStream then
    SetMemoryCapacity(TMemoryStreamExtend(DecodedStream));

  crypter := TINFCrypt.Create(
    StreamKeyStart + StreamKeyEnd,
    FileBufferLen + INFDataLen);
  try
    DecryptBufferLen := FileBufferLen + INFDataLen;
    SetLength(BufferString, DecryptBufferLen);

    while (EncodedStream.Size - EncodedStream.Position) > 0 do begin

      RestOfStream := EncodedStream.Size - EncodedStream.Position;

      if RestOfStream < DecryptBufferLen then begin
        SetLength(BufferString, RestOfStream);
        EncodedStream.ReadBuffer(BufferString[1], RestOfStream);
      end
      else
        EncodedStream.ReadBuffer(BufferString[1], DecryptBufferLen);

      DeCryptedString := crypter.Decode(BufferString);
      DecodedStream.WriteBuffer(DeCryptedString[1], Length(DeCryptedString));
    end;

  finally
    crypter.Free;
  end;
end;

function GetEncryptedMemoryStream(fileName : String = '') : TMemoryStream;
var
  EncodedFile : TFileStream;
begin
  if Length(fileName) = 0 then
  begin
    if not FileExists(
      IncludeTrailingBackslash(ExtractFileDir(ParamStr(0)))
        + LibraryFileNameStart + LibraryFileNameEnd)
    then
      raise Exception.Create('Нет необходимого файла')
  end
  else
    if not FileExists(fileName) 
    then
      raise Exception.Create('Нет необходимого файла');

  if Length(fileName) = 0 then
    EncodedFile := TFileStream
      .Create(
        IncludeTrailingBackslash(ExtractFileDir(ParamStr(0)))
          + LibraryFileNameStart + LibraryFileNameEnd,
        fmOpenRead or fmShareDenyWrite)
  else
    EncodedFile := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := TMemoryStream.Create();
    try
      DecodeStream(EncodedFile, Result);
    except
      Result.Free;
      Result := nil;
      raise;
    end;
  finally
    EncodedFile.Free;
  end;
end;

initialization
  LibraryFileNameEnd := 'bhlp.dll';
end.
