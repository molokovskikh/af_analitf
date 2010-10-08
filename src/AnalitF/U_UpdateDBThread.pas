unit U_UpdateDBThread;

interface

uses
  Windows, Messages, SysUtils, Classes,
  MyAccess, MyEmbConnection;

type
  TOnUpdateDBFileData = procedure (dbCon : TCustomMyConnection) of object;

  TOnUpdateDBFile = procedure (dbCon : TCustomMyConnection; DBDirectoryName : String; OldDBVersion : Integer; AOnUpdateDBFileData : TOnUpdateDBFileData) of object;

procedure RunUpdateDBFile(
  dbCon : TCustomMyConnection;
  DBDirectoryName : String;
  OldDBVersion : Integer;
  AOnUpdateDBFile : TOnUpdateDBFile;
  AOnUpdateDBFileData : TOnUpdateDBFileData;
  ShowCaption : String = '���������� ���������� ���� ������. ���������...');

implementation

uses
  Waiting,
  DatabaseObjects;

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
var
  InternalConnection : TCustomMyConnection;
begin
  ErrorStr := '';
  try
    InternalConnection := nil;
    if Assigned(dbCon) then begin
      InternalConnection := DatabaseController.GetNewConnection(dbCon);

      if (dbCon is TMyEmbConnection) then
        TMyEmbConnection(InternalConnection).DataDir := DBDirectoryName;

{
      InternalConnection := TMyEmbConnection.Create(nil);
      InternalConnection.Database := dbCon.Database;
      InternalConnection.Username := dbCon.Username;
      InternalConnection.DataDir := DBDirectoryName;
      InternalConnection.Options := TMyEmbConnection(dbCon).Options;
      InternalConnection.Params.Clear;
      InternalConnection.Params.AddStrings(TMyEmbConnection(dbCon).Params);
      InternalConnection.LoginPrompt := False;
}      
    end;
    try
    if Assigned(OnUpdateDBFile) then
      OnUpdateDBFile(InternalConnection, DBDirectoryName, OldDBVersion, OnUpdateDBFileData);
    finally
      try if Assigned(InternalConnection) then InternalConnection.Free; except end;
    end;
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
  ShowCaption : String = '���������� ���������� ���� ������. ���������...');
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
{
    if Assigned(RunT.dbCon) and (RunT.dbCon is TMyEmbConnection) then
      TMyEmbConnection(RunT.dbCon).DataDir := DBDirectoryName;
}      
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
