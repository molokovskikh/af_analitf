unit AProcTests;

interface

uses
  SysUtils,
  Windows,
  Variants,
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
    procedure CheckGetSupplierNameFromFileNameParam(
      inFileName,
      resultSupplierName : String);
    procedure TestCheckStartupFolderByPathParam(
      path : String;
      resultCheck : Boolean);
   published
    procedure CheckGetNonExistsFileNameInFolder;
    procedure CheckGetOriginalWaybillFileName;
    procedure CheckGetSupplierNameFromFileName;
    procedure TestCheckStartupFolderByPath;
    procedure TestListToStrError;
    procedure TestListToStr;
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

procedure TTestAProc.CheckGetSupplierNameFromFileName;
begin
  CheckGetSupplierNameFromFileNameParam('', '');
  CheckGetSupplierNameFromFileNameParam('1_ds(erg).txt', 'ds');
  CheckGetSupplierNameFromFileNameParam('1_(erg).txt', '');
  CheckGetSupplierNameFromFileNameParam('1(erg).txt', '');
  CheckGetSupplierNameFromFileNameParam('1_erg).txt', '');
  CheckGetSupplierNameFromFileNameParam('1_(erg.txt', '');
end;

procedure TTestAProc.CheckGetSupplierNameFromFileNameParam(inFileName,
  resultSupplierName: String);
var
  realSupplierName: String;
begin
  realSupplierName := GetSupplierNameFromFileName(inFileName);
  CheckEqualsString(resultSupplierName, realSupplierName);
end;

procedure TTestAProc.TestCheckStartupFolderByPath;
var
  usersDir : String;
begin
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('ProgramFiles'), False);
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('ProgramFiles') + '\AnalitF', False);
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('SystemRoot'), False);
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('SystemRoot') + '\AnalitF', False);
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('USERPROFILE'), True);
  TestCheckStartupFolderByPathParam(GetEnvironmentVariable('USERPROFILE') + '\AnalitF', True);
  TestCheckStartupFolderByPathParam('C:\', True);
  TestCheckStartupFolderByPathParam('C:\AnalitF', True);
  usersDir := ExtractFilePath(GetEnvironmentVariable('USERPROFILE'));
  TestCheckStartupFolderByPathParam(usersDir, False);
  TestCheckStartupFolderByPathParam(usersDir + '\AnalitF', False);
end;

procedure TTestAProc.TestCheckStartupFolderByPathParam(path: String;
  resultCheck: Boolean);
var
  realResult: Boolean;
begin
  realResult := CheckStartupFolderByPath(path);
  CheckEquals(resultCheck, realResult);
end;

procedure TTestAProc.TestListToStr;
begin
  CheckEquals('', ListToStr([], []));
  CheckEquals('1: 1', ListToStr(['1'], ['1']));
  CheckEquals('1: Нет', ListToStr(['1'], [False]));
  CheckEquals('', ListToStr(['1'], [Null]));
  CheckEquals('1:   3: Да', ListToStr(['1', '2', '3'], ['', Null, True]));
  CheckEquals('1: afb  3: Да  4: ' + FloatToStr(1.2) + '  5: 4', ListToStr(['1', '2', '3', '4', '5'], ['afb', Null, True, 1.2, 4]));
end;

procedure TTestAProc.TestListToStrError;
begin
  try
    ListToStr([], [1]);
    Fail('Предыдущий вызов должен вызвать Exception');
  except
    on E : Exception do
      CheckEquals('ListToStr: Кол-во названий не совпадает со списком значений.', e.Message);
  end;
  try
    ListToStr(['1', '1'], [1]);
    Fail('Предыдущий вызов должен вызвать Exception');
  except
    on E : Exception do
      CheckEquals('ListToStr: Кол-во названий не совпадает со списком значений.', e.Message);
  end;
end;

initialization
  TestFramework.RegisterTest(TTestAProc.Suite);
end.
