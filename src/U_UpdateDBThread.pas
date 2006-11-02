unit U_UpdateDBThread;

interface

uses
  Windows, Messages, SysUtils, Classes, FIB, FIBQuery, pFIBQuery, FIBDataSet,
  pFIBDataSet, FIBDatabase, pFIBDatabase;

type
  TOnUpdateDBFileData = procedure (dbCon : TpFIBDatabase; trMain : TpFIBTransaction) of object;
  
  TOnUpdateDBFile = procedure (dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData) of object;

procedure RunUpdateDBFile(
  dbCon : TpFIBDatabase;
  trMain : TpFIBTransaction;
  FileName : String;
  OldDBVersion : Integer;
  AOnUpdateDBFile : TOnUpdateDBFile;
  AOnUpdateDBFileData : TOnUpdateDBFileData);

implementation

uses
  Waiting;

type
  TRunUpdateDBFile = class(TThread)
   public
    OnUpdateDBFile : TOnUpdateDBFile;
    OnUpdateDBFileData : TOnUpdateDBFileData;
    dbCon : TpFIBDatabase;
    trMain : TpFIBTransaction;
    FileName : String;
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
      OnUpdateDBFile(dbCon, trMain, FileName, OldDBVersion, OnUpdateDBFileData);
  except
    on E : Exception do
      ErrorStr := E.Message;
  end;
end;

procedure RunUpdateDBFile(
  dbCon : TpFIBDatabase;
  trMain : TpFIBTransaction;
  FileName : String;
  OldDBVersion : Integer;
  AOnUpdateDBFile : TOnUpdateDBFile;
  AOnUpdateDBFileData : TOnUpdateDBFileData);
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
    RunT.trMain := trMain;
    RunT.FileName := FileName;
    RunT.OldDBVersion := OldDBVersion;
    RunT.FreeOnTerminate := False;
    ShowWaiting('Происходит обновление базы данных. Подождите...', RunT);
    Error := RunT.ErrorStr;
  finally
    RunT.Free;
  end;
  if Length(Error) <> 0 then
    raise Exception.Create(Error);
end;


end.
