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
    procedure FormCreate(Sender: TObject);
    procedure btnTestPrepareClick(Sender: TObject);
    procedure btnCorruptDataFileClick(Sender: TObject);
    procedure btnCorruptIndexFileClick(Sender: TObject);
  private
    { Private declarations }
    table : TSynonymFirmCrTable;
  public
    { Public declarations }
    procedure PrepareSynonymFirmCr;
    procedure CorruptFile(corruptFileName : String);
    procedure TryToRepare(MethodName : String; FileExtention : String);
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

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

procedure TMainFrm.PrepareSynonymFirmCr;
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
begin
  try
    PrepareSynonymFirmCr;

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
        sc.RepairTable([rtExtended, rtUseFrm]);
        //Msg_type
        //Msg_text
        if (sc.RecordCount > 0) then begin
          if (AnsiCompareText(sc
                .FieldByName('Msg_type').AsString, 'status') <> 0)
            or (AnsiCompareText(sc
                .FieldByName('Msg_text').AsString, 'OK') <> 0)
          then
            mLog.Lines.Add(
              Format('Метод: %s  Восстановление: тип сообщения: %s  сообщение: %s',
              [MethodName,
               sc.FieldByName('Msg_type').AsString,
               sc.FieldByName('Msg_text').AsString]))
          else
            mLog.Lines.Add(
              Format('Метод: %s  Восстановление: успешно', [MethodName]));
        end
        else
          mLog.Lines.Add(
            Format('Метод: %s  Восстановление: нет данных', [MethodName]));
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
end;

procedure TMainFrm.btnCorruptDataFileClick(Sender: TObject);
begin
{$ifndef USENEWMYSQLTYPES}
  TryToRepare('CorruptDataFile', '.MYD');
{$else}
  TryToRepare('CorruptDataFile', DataFileExtention);
{$endif}
end;

procedure TMainFrm.btnCorruptIndexFileClick(Sender: TObject);
begin
{$ifndef USENEWMYSQLTYPES}
  TryToRepare('CorruptIndexFile', '.MYI');
{$else}
  TryToRepare('CorruptIndexFile', IndexFileExtention);
{$endif}
end;

end.
