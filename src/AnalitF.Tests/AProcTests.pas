unit AProcTests;

interface

uses
  SysUtils,
  Windows,
  TestFrameWork,
  AProc;

type
  TTestAProc = class(TTestCase)
   private
    procedure CheckGetNonExistsFileNameInFolderParam(
      folder,
      inFileName,
      resultFileName : String;
      existsFiles : array of string);
    procedure CheckGetOriginalWaybillFileNameParam(
      inFileName,
      resultFileName : String);
   published
    procedure CheckGetNonExistsFileNameInFolder;
    procedure CheckGetOriginalWaybillFileName;
  end;


implementation

{ TTestAProc }

procedure TTestAProc.CheckGetNonExistsFileNameInFolder;
var
  folder : String;
begin
  folder := 'TestCheckGetNonExistsFileNameInFolder';
  if DirectoryExists(folder) then
    DeleteDirectory(folder);
  CreateDir(folder);
  try
    CheckGetNonExistsFileNameInFolderParam(folder, 'out.txt', 'out.txt', []);
    CheckGetNonExistsFileNameInFolderParam(folder, 'out.txt', 'out_0.txt', ['out.txt']);
    CheckGetNonExistsFileNameInFolderParam(folder, 'out.txt', 'out_2.txt', ['out.txt', 'out_0.txt', 'out_1.txt']);
    CheckGetNonExistsFileNameInFolderParam(folder, 'out.txt', 'out_0.txt', ['out.txt', 'out_0.txt', 'out_1.txt', 'out_2.txt', 'out_3.txt', 'out_4.txt', 'out_5.txt', 'out_6.txt', 'out_7.txt', 'out_8.txt', 'out_9.txt']);
  finally
    if DirectoryExists(folder) then
      DeleteDirectory(folder);
  end;
end;

procedure TTestAProc.CheckGetNonExistsFileNameInFolderParam(folder,
  inFileName, resultFileName: String; existsFiles: array of string);
var
  i,
  createResult : Integer;
  realResultFileName : String;
begin
  DeleteFilesByMask(folder + '\*.*');
  for I := Low(existsFiles) to High(existsFiles) do begin
    createResult := FileCreate(folder + '\' + existsFiles[i]);
    Check(createResult > 0, Format('Не получилось создать файл %s', [folder + '\' + existsFiles[i]]));
    FileClose(createResult);
  end;

  realResultFileName := GetNonExistsFileNameInFolder(inFileName, folder);

  CheckEqualsString(resultFileName, realResultFileName);
end;

procedure TTestAProc.CheckGetOriginalWaybillFileName;
begin
  CheckGetOriginalWaybillFileNameParam('', '');
  CheckGetOriginalWaybillFileNameParam('1_ds(erg).txt', 'erg.txt');
  CheckGetOriginalWaybillFileNameParam('1_(erg).txt', 'erg.txt');
  CheckGetOriginalWaybillFileNameParam('1(erg).txt', '1(erg).txt');
  CheckGetOriginalWaybillFileNameParam('1_erg).txt', '1_erg).txt');
  CheckGetOriginalWaybillFileNameParam('1_(erg.txt', '1_(erg.txt');
end;

procedure TTestAProc.CheckGetOriginalWaybillFileNameParam(inFileName,
  resultFileName: String);
var
  realResultFileName: String;
begin
  realResultFileName := GetOriginalWaybillFileName(inFileName);
  CheckEqualsString(resultFileName, realResultFileName);
end;

initialization
  TestFramework.RegisterTest(TTestAProc.Suite);
end.
