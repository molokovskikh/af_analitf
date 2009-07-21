//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyScript
//////////////////////////////////////////////////
{$IFNDEF CLR}

{$I MyDac.inc}

unit MyScript;
{$ENDIF}

interface

uses
  SysUtils, Classes, DAScript, CRParser, MyParser, DBAccess, MyAccess,
  MyScriptProcessor;

Type
  TMyScript = class(TDAScript)
  protected
    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);
    function GetDataSet: TCustomMyDataSet;
    procedure SetDataSet(const Value: TCustomMyDataSet);
    function CreateCommand: TCustomDASQL; override;
    function GetProcessorClass: TDAScriptProcessorClass; override;

  public
    constructor Create(Owner: TComponent); override;
    procedure Execute; override;
    function ExecuteNext: boolean; override;
  published
    property Connection: TCustomMyConnection read GetConnection write SetConnection;
    property DataSet: TCustomMyDataSet read GetDataSet write SetDataSet;
    property UseOptimization;
  end;

implementation

{ TMyScript }

constructor TMyScript.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FMacros.SetParserClass(TMyParser);
//d  CheckProcessor;
  FDelimiter := ';';
end;

function TMyScript.GetProcessorClass: TDAScriptProcessorClass;
begin
  Result := TMyScriptProcessor;
end;

function TMyScript.GetConnection: TCustomMyConnection;
begin
  Result := TCustomMyConnection(inherited Connection);
end;

procedure TMyScript.SetConnection(Value: TCustomMyConnection);
begin
  inherited Connection := Value;
end;

function TMyScript.GetDataSet: TCustomMyDataSet;
begin
  Result := TCustomMyDataSet(inherited DataSet);
end;

procedure TMyScript.SetDataSet(const Value: TCustomMyDataSet);
begin
  inherited DataSet := Value;
end;

function TMyScript.CreateCommand: TCustomDASQL;
begin
  Result := TMyCommand.Create(nil);
  TMyCommand(Result).AutoCommit := False;
end;

procedure TMyScript.Execute;
var
  OldDelimiter: string;
begin
  OldDelimiter := Delimiter;
  try
    inherited;
  finally
    Delimiter := OldDelimiter;
  end;
end;

function TMyScript.ExecuteNext: boolean;
var
  OldCommandTimeout: integer;
begin
  OldCommandTimeout := 0;
  if Assigned(DataSet) then
    OldCommandTimeout := DataSet.CommandTimeout;
  try
    Result := inherited ExecuteNext;
  finally
    if Assigned(DataSet) then
      DataSet.CommandTimeout := OldCommandTimeout;
  end;
end;

end.
