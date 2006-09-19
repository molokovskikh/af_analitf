unit U_UpdateDBThread;

interface

uses
  Windows, Messages, SysUtils, Classes, FIB, FIBQuery, pFIBQuery, FIBDataSet,
  pFIBDataSet, FIBDatabase, pFIBDatabase;

type
  TOnUpdateDBFile = procedure (dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String) of object;

procedure RunUpdateDBFile(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; AOnUpdateDBFile : TOnUpdateDBFile);

implementation

uses
  Waiting;
  
type
  TRunUpdateDBFile = class(TThread)
   public
    OnUpdateDBFile : TOnUpdateDBFile;
    dbCon : TpFIBDatabase;
    trMain : TpFIBTransaction;
    FileName : String;
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
      OnUpdateDBFile(dbCon, trMain, FileName);
  except
    on E : Exception do
      ErrorStr := E.Message;
  end;
end;

procedure RunUpdateDBFile(dbCon : TpFIBDatabase; trMain : TpFIBTransaction; FileName : String; AOnUpdateDBFile : TOnUpdateDBFile);
var
  RunT : TRunUpdateDBFile;
  Error : String;
begin
  Error := '';
  RunT := TRunUpdateDBFile.Create(True);
  RunT.OnUpdateDBFile := AOnUpdateDBFile;
  try
    RunT.dbCon := dbCon;
    RunT.trMain := trMain;
    RunT.FileName := FileName;
    RunT.FreeOnTerminate := False;
    ShowWaiting('���������� ���������� ���� ������. ���������...', RunT);
    Error := RunT.ErrorStr;
  finally
    RunT.Free;
  end;
  if Length(Error) <> 0 then
    raise Exception.Create(Error);
end;


end.
