unit INFHelpersTests;

interface

uses
  SysUtils,
  Windows,
  Classes,
  TestFrameWork,
  AProc,
  INFHelpers;

type
  TTestINFHelpers = class(TTestCase)
   private
    procedure CheckStreams(originFileName : String; decodedStream : TMemoryStream);
    procedure CheckDecodedStream(originFileName, cryptFileName : String; keys : TAppDKeys);
   published
    procedure CheckCurrentLib;
    procedure CheckPreviousLib;
    procedure CheckGetEncryptedMemoryStream;
  end;

implementation

{ TTestINFHelpers }

procedure TTestINFHelpers.CheckCurrentLib;
begin
  CheckDecodedStream('..\SpecialLibs\Last\libmysqld.dll', '..\SpecialLibs\Last\appdbhlp.dll', akCurrent);
end;

procedure TTestINFHelpers.CheckDecodedStream(originFileName,
  cryptFileName: String; keys: TAppDKeys);
var
  cryptFile : TFileStream;
  decodeFile : TMemoryStream;
  originFile : TMemoryStream;
  compareResult : Boolean;
begin
  cryptFile := TFileStream.Create(cryptFileName, fmOpenRead or fmShareDenyWrite);
  try
    decodeFile := TMemoryStream.Create();
    try
      DecodeStream(cryptFile, decodeFile, keys);

      Sleep(1000);

      CheckStreams(originFileName, decodeFile);

    finally
      decodeFile.Free;
    end;
  finally
    cryptFile.Free;
  end;
end;

procedure TTestINFHelpers.CheckGetEncryptedMemoryStream;
var
  decodedFile : TMemoryStream;
begin
  OSCopyFile('..\SpecialLibs\Last\appdbhlp.dll', 'appdbhlp.dll');
  if not DirectoryExists('UpdateBackup') then
    CreateDir('UpdateBackup');
  OSCopyFile('..\SpecialLibs\1651\appdbhlp.dll', 'UpdateBackup\appdbhlp.dll.bak');

  decodedFile := GetEncryptedMemoryStream();
  try
    CheckStreams('..\SpecialLibs\Last\libmysqld.dll', decodedFile);
  finally
    decodedFile.Free;
  end;

  decodedFile := GetEncryptedMemoryStream('UpdateBackup\appdbhlp.dll.bak');
  try
    CheckStreams('..\SpecialLibs\1651\libmysqld.dll', decodedFile);
  finally
    decodedFile.Free;
  end;
end;

procedure TTestINFHelpers.CheckPreviousLib;
begin
  CheckDecodedStream('..\SpecialLibs\1651\libmysqld.dll', '..\SpecialLibs\1651\appdbhlp.dll', akPrevious);
end;

procedure TTestINFHelpers.CheckStreams(originFileName: String;
  decodedStream: TMemoryStream);
var
  originFile : TMemoryStream;
  compareResult : Boolean;
begin
  originFile := TMemoryStream.Create;
  try
    originFile.LoadFromFile(originFileName);

    CheckEquals(originFile.Size, decodedStream.Size, 'Не сопадает размер декодированного потока с оригинальным файлом');

    compareResult := CompareMem(originFile.Memory, decodedStream.memory, originFile.Size);
    CheckTrue(compareResult, 'Декодированное содержимое не совпадает с оригинальным файлом');
  finally
    originFile.Free;
  end;
end;

initialization
  TestFramework.RegisterTest(TTestINFHelpers.Suite);
end.
