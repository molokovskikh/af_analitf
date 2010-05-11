unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, MyAccess, MyEmbConnection, AProc, DatabaseObjects,
  StdCtrls, SynonymDatabaseObjects, MyServerControl, MySqlApi;

type
  TMySQLAPIEmbeddedEx = class(TMySQLAPIEmbedded)
  end;

  TMainFrm = class(TForm)
    MyEmbConnection: TMyEmbConnection;
    btnTestPrepare: TButton;
    btnCorruptDataFile: TButton;
    mLog: TMemo;
    btnCorruptIndexFile: TButton;
    btnCorruptStructFile: TButton;
    btnAnalyzeTable: TButton;
    btnOptimizeTable: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnTestPrepareClick(Sender: TObject);
    procedure btnCorruptDataFileClick(Sender: TObject);
    procedure btnCorruptIndexFileClick(Sender: TObject);
    procedure btnCorruptStructFileClick(Sender: TObject);
    procedure btnAnalyzeTableClick(Sender: TObject);
    procedure btnOptimizeTableClick(Sender: TObject);
  private
    { Private declarations }
    table : TSynonymFirmCrTable;
    function ParseMethodResuls(MethodName: String; ServiceControl : TMyServerControl) : Boolean;
  public
    { Public declarations }
    function PrepareSynonymFirmCr : LargeInt;
    procedure CorruptFile(corruptFileName : String);
    procedure TryToRepare(MethodName : String; FileExtention : String);
    procedure TryToAnalyze(MethodName : String);
    procedure TryToOptimize(MethodName : String);
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

uses
  DBProc;

function GetFirstFileNameFromDir(
  DirName: String): String;
var
  SR: TSearchrec;
begin
  try
    if SysUtils.FindFirst(DirName + '\*.*', faAnyFile-faDirectory,SR)=0
    then begin
      Result := ChangeFileExt(SR.Name, '');
      Exit;
    end;
  finally
    SysUtils.FindClose(SR);
  end;
  Result := '';
end;


procedure TMainFrm.FormCreate(Sender: TObject);
begin
{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

  //Устанавливаем параметры embedded-соединения
  MyEmbConnection.Params.Clear();
{$ifndef USENEWMYSQLTYPES}
  MyEmbConnection.Params.Add('--basedir=.');
  MyEmbConnection.Params.Add('--datadir=data');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  //MyEmbConnection.Params.Add('--character_set_filesystem=cp1251');
  MyEmbConnection.Params.Add('--skip-innodb');
  MyEmbConnection.Params.Add('--tmpdir=tmpdir');
{$else}
  MyEmbConnection.Params.Add('--basedir=.');
  MyEmbConnection.Params.Add('--datadir=data');
  MyEmbConnection.Params.Add('--character_set_server=cp1251');
  //MyEmbConnection.Params.Add('--character_set_filesystem=cp1251');
  MyEmbConnection.Params.Add('--tmpdir=tmpdir');
{$endif}
  table := TSynonymFirmCrTable.Create;
end;

function TMainFrm.PrepareSynonymFirmCr : LargeInt;
begin
  if MyEmbConnection.Connected then
    MyEmbConnection.Close;
    
  if TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount > 0 then
    ShowMessage(
      Format('MySql Clients Count при восстановлении: %d',
        [TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount]));
  MyAPIEmbedded.FreeMySQLLib;
  
  DeleteFilesByMask(ExePath + 'Data\analitf\*.*');
  MyEmbConnection.Open;
  try
    MyEmbConnection.ExecSQL(table.GetCreateSQL('analitf'), []);
    if Length(table.FileSystemName) = 0 then
      table.FileSystemName := GetFirstFileNameFromDir(ExePath + 'Data\analitf');
    MyEmbConnection.ExecSQL(GetLoadDataSQL('SynonymFirmCr', ExePath + 'In\SynonymFirmCr.txt'), []);
    Result := DBProc.QueryValue(MyEmbConnection, 'select count(*) from analitf.SynonymFirmCr', [], []);
  finally
    MyEmbConnection.Close;
  end;
end;

procedure TMainFrm.btnTestPrepareClick(Sender: TObject);
begin
  PrepareSynonymFirmCr;
end;

procedure TMainFrm.CorruptFile(corruptFileName: String);
var
  dataFile : TFileStream;
  f        : TMemoryStream;
  quarter  : Int64;
begin
  dataFile := TFileStream.Create(
    corruptFileName,
    fmOpenReadWrite or fmShareDenyWrite);
  try
    f := TMemoryStream.Create;
    try
      quarter := dataFile.Size div 4;
      dataFile.Position := dataFile.Size - quarter;
      f.CopyFrom(dataFile, quarter);
      f.Position := 0;
      dataFile.Position := dataFile.Size - (2*quarter);
      dataFile.CopyFrom(f, quarter);
      dataFile.Size := dataFile.Size - quarter;
    finally
      f.Free;
    end;
  finally
    dataFile.Free;
  end;
end;

procedure TMainFrm.TryToRepare(MethodName, FileExtention: String);
var
  sc : TMyServerControl;
  repaired : Boolean;
  sourceCount,
  afterCount : LargeInt;
begin
  mLog.Lines.Add('');
  mLog.Lines.Add('');
  mLog.Lines.Add(Format('Старт метода %s на файле %s', [MethodName, FileExtention]));
  try
    sourceCount := PrepareSynonymFirmCr;

  {
    if TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount > 0 then
      ShowMessage(
        Format('MySql Clients Count при восстановлении: %d',
          [TMySQLAPIEmbeddedEx(MyAPIEmbedded).FClientsCount]));
  }
    MyAPIEmbedded.FreeMySQLLib;

    CorruptFile(ExePath + 'Data\analitf\' + table.FileSystemName + FileExtention);

    sc := TMyServerControl.Create(nil);
    try
      sc.Connection := MyEmbConnection;
      MyEmbConnection.Open;
      MyEmbConnection.ExecSQL('use analitf', []);
      try
        sc.TableNames := table.Name;
        sc.CheckTable();
        repaired := False;
        if not ParseMethodResuls(MethodName, sc) then begin
          mLog.Lines.Add('Попытка восстановить без использования frm');
          sc.RepairTable([rtExtended]);
          if not ParseMethodResuls(MethodName, sc) then begin
            mLog.Lines.Add('Попытка восстановить с использованием frm');
            sc.RepairTable([rtExtended, rtUseFrm]);
            if not ParseMethodResuls(MethodName, sc) then
              mLog.Lines.Add('Ошибка Восстановление не удалось!!!')
            else
              repaired := True;
          end
          else
           repaired := True;

          if repaired then begin
            sc.CheckTable();
            if not ParseMethodResuls(MethodName, sc) then
              mLog.Lines.Add('Проверка после восстановления - не успешна!!!')
            else begin
              afterCount := DBProc.QueryValue(MyEmbConnection, 'select count(*) from analitf.SynonymFirmCr', [], []);
              mLog.Lines.Add(
                Format(
                  'Кол-во записей до теста: %d   после теста: %d',
                  [sourceCount,
                   afterCount]))
            end;
          end;
        end;
      finally
        MyEmbConnection.Close;
      end;
    finally
      sc.Free;
    end;
  except
    on E : Exception do
      mLog.Lines.Add(
        Format(
          'Метод: %s  ошибка: %s',
          [MethodName,
           E.Message]));
  end;
  mLog.Lines.Add(Format('Окончание метода %s на файле %s', [MethodName, FileExtention]));
end;

procedure TMainFrm.btnCorruptDataFileClick(Sender: TObject);
begin
{$ifndef USENEWMYSQLTYPES}
  TryToRepare('CorruptDataFile', '.MYD');
{$else}
  //TryToRepare('CorruptDataFile', DataFileExtention);
  TryToRepare('CorruptDataFile', '.dbf');
{$endif}
end;

procedure TMainFrm.btnCorruptIndexFileClick(Sender: TObject);
begin
{$ifndef USENEWMYSQLTYPES}
  TryToRepare('CorruptIndexFile', '.MYI');
{$else}
  //TryToRepare('CorruptIndexFile', IndexFileExtention);
  TryToRepare('CorruptIndexFile', '.idx');
{$endif}
end;

procedure TMainFrm.btnCorruptStructFileClick(Sender: TObject);
begin
{$ifndef USENEWMYSQLTYPES}
  TryToRepare('CorruptStructFile', '.frm');
{$else}
  TryToRepare('CorruptStructFile', '.index');
{$endif}
end;

procedure TMainFrm.TryToAnalyze(MethodName: String);
var
  sc : TMyServerControl;
begin
  mLog.Lines.Add('');
  mLog.Lines.Add('');
  mLog.Lines.Add(Format('Старт метода %s', [MethodName]));
  try
    //PrepareSynonymFirmCr;

    MyAPIEmbedded.FreeMySQLLib;

    sc := TMyServerControl.Create(nil);
    try
      sc.Connection := MyEmbConnection;
      MyEmbConnection.Open;
      MyEmbConnection.ExecSQL('use analitf', []);
      try
        sc.TableNames := table.Name;
        sc.AnalyzeTable;
        if not ParseMethodResuls(MethodName, sc) then
          mLog.Lines.Add('Анализ завершился с ошибкой!!!')
        else
          mLog.Lines.Add('Анализ успешно завершен');
      finally
        MyEmbConnection.Close;
      end;
    finally
      sc.Free;
    end;
  except
    on E : Exception do
      mLog.Lines.Add(
        Format(
          'Метод: %s  ошибка: %s',
          [MethodName,
           E.Message]));
  end;
  mLog.Lines.Add(Format('Окончание метода %s', [MethodName]));
end;

procedure TMainFrm.btnAnalyzeTableClick(Sender: TObject);
begin
  TryToAnalyze('Analyze');
end;

procedure TMainFrm.btnOptimizeTableClick(Sender: TObject);
begin
  TryToOptimize('Optimize');
end;

procedure TMainFrm.TryToOptimize(MethodName: String);
var
  sc : TMyServerControl;
  sourceCount,
  deletefromBegin,
  deleteFromEnd,
  afterCount : LargeInt;

begin
  mLog.Lines.Add('');
  mLog.Lines.Add('');
  mLog.Lines.Add(Format('Старт метода %s', [MethodName]));
  try
    sourceCount := PrepareSynonymFirmCr;

    MyAPIEmbedded.FreeMySQLLib;

    sc := TMyServerControl.Create(nil);
    try
      sc.Connection := MyEmbConnection;
      MyEmbConnection.Open;
      MyEmbConnection.ExecSQL('use analitf', []);
      try
        MyEmbConnection.ExecSQL('delete from synonymfirmcr limit 10000', []);
        deletefromBegin := 10000;
        MyEmbConnection.ExecSQL('delete from synonymfirmcr order by SynonymFirmCrCode desc limit 20000', []);
        deletefromEnd := 20000;

        sc.TableNames := table.Name;
        sc.OptimizeTable;
        if not ParseMethodResuls(MethodName, sc) then
          mLog.Lines.Add('Оптимизация завершилась с ошибкой!!!')
        else
          mLog.Lines.Add('Оптимизация успешно завершена');

        afterCount := DBProc.QueryValue(MyEmbConnection, 'select count(*) from analitf.SynonymFirmCr', [], []);
        if afterCount <> sourceCount - deletefromBegin - deletefromEnd then
          mLog.Lines.Add('Неожидаемое кол-во элементов после оптимизации!!!')
        else begin

          sc.CheckTable();
          if ParseMethodResuls(MethodName, sc) then
            mLog.Lines.Add('Проверка успешна завершена')
          else
            mLog.Lines.Add('Проверка завершилась с ошибкой');
            
        end;
      finally
        MyEmbConnection.Close;
      end;
    finally
      sc.Free;
    end;
  except
    on E : Exception do
      mLog.Lines.Add(
        Format(
          'Метод: %s  ошибка: %s',
          [MethodName,
           E.Message]));
  end;
  mLog.Lines.Add(Format('Окончание метода %s', [MethodName]));
end;

function TMainFrm.ParseMethodResuls(
  MethodName: String;
  ServiceControl: TMyServerControl): Boolean;
begin
  //Op
  //Msg_type
  //Msg_text
  if (ServiceControl.RecordCount > 0) then begin
    mLog.Lines.Add(
      Format('Кол-во записей в статусе метода %s операции %s: %d',
      [MethodName,
       ServiceControl.FieldByName('Op').AsString,
       ServiceControl.RecordCount]));
    while not ServiceControl.Eof do begin
      if (AnsiCompareText(ServiceControl
            .FieldByName('Msg_type').AsString, 'status') <> 0)
        or (AnsiCompareText(ServiceControl
            .FieldByName('Msg_text').AsString, 'OK') <> 0)
      then
        mLog.Lines.Add(
          Format('Метод: %s  результат %s: тип сообщения: %s  сообщение: %s',
          [MethodName,
           ServiceControl.FieldByName('Op').AsString,
           ServiceControl.FieldByName('Msg_type').AsString,
           ServiceControl.FieldByName('Msg_text').AsString]))
      else
        mLog.Lines.Add(
          Format('Метод: %s  результат %s: успешно  тип сообщения: %s  сообщение: %s',
          [MethodName,
           ServiceControl.FieldByName('Op').AsString,
           ServiceControl.FieldByName('Msg_type').AsString,
           ServiceControl.FieldByName('Msg_text').AsString]));
      ServiceControl.Next;
    end;
    Result :=
      (AnsiCompareText(ServiceControl.FieldByName('Msg_type').AsString, 'status') = 0)
        and
        (
        (AnsiCompareText(ServiceControl
            .FieldByName('Msg_text').AsString, 'OK') = 0)
        or
        (AnsiCompareText(ServiceControl
            .FieldByName('Msg_text').AsString, 'Table is already up to date') = 0)
        );
  end
  else begin
    mLog.Lines.Add(
      Format('Метод: %s  результат: нет данных', [MethodName]));
    Result := False;
  end;
end;

end.
