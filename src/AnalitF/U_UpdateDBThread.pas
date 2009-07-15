unit U_UpdateDBThread;

interface

uses
  Windows, Messages, SysUtils, Classes, FIB, FIBQuery, pFIBQuery, FIBDataSet,
  pFIBDataSet, FIBDatabase, pFIBDatabase, MyAccess, MyEmbConnection;

type
  TOnUpdateDBFileData = procedure (dbCon : TCustomMyConnection) of object;

  TOnUpdateDBFile = procedure (dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData) of object;

procedure RunUpdateDBFile(
  dbCon : TCustomMyConnection;
  DBDirectoryName : String;
  OldDBVersion : Integer;
  AOnUpdateDBFile : TOnUpdateDBFile;
  AOnUpdateDBFileData : TOnUpdateDBFileData;
  ShowCaption : String = 'Происходит обновление базы данных. Подождите...');

implementation

uses
  Waiting;

type
  TRunUpdateDBFile = class(TThread)
   public
    OnUpdateDBFile : TOnUpdateDBFile;
    OnUpdateDBFileData : TOnUpdateDBFileData;
    dbCon : TCustomMyConnection;
    DBDirectoryName : String;
    OldDBVersion : Integer;
    ErrorStr : String;
   protected
    procedure Execute; override;
  end;

{ TRunUpdateDBFile }

procedure TRunUpdateDBFile.Execute;
begin
  ErrorStr := '';
  try
    if Assigned(OnUpdateDBFile) then
      OnUpdateDBFile(dbCon, DBDirectoryName, OldDBVersion, OnUpdateDBFileData);
  except
    on E : Exception do
      ErrorStr := E.Message;
  end;
end;

procedure RunUpdateDBFile(
  dbCon : TCustomMyConnection;
  DBDirectoryName : String;
  OldDBVersion : Integer;
  AOnUpdateDBFile : TOnUpdateDBFile;
  AOnUpdateDBFileData : TOnUpdateDBFileData;
  ShowCaption : String = 'Происходит обновление базы данных. Подождите...');
var
  RunT : TRunUpdateDBFile;
  Error : String;
begin
  Error := '';
  RunT := TRunUpdateDBFile.Create(True);
  RunT.OnUpdateDBFile := AOnUpdateDBFile;
  RunT.OnUpdateDBFileData := AOnUpdateDBFileData;
  try
    RunT.dbCon := dbCon;
    if Assigned(RunT.dbCon) and (RunT.dbCon is TMyEmbConnection) then
      TMyEmbConnection(RunT.dbCon).DataDir := DBDirectoryName;
    RunT.DBDirectoryName := DBDirectoryName;
    RunT.OldDBVersion := OldDBVersion;
    RunT.FreeOnTerminate := False;
    ShowWaiting(ShowCaption, RunT);
    Error := RunT.ErrorStr;
  finally
    RunT.Free;
  end;
  if Length(Error) <> 0 then
    raise Exception.Create(Error);
end;


end.
