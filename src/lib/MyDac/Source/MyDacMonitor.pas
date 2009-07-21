
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  SQLMonitor supports
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyDacMonitor;
{$ENDIF}

interface
uses
{$IFDEF LINUX}
  Libc, Types,
{$ENDIF}
  SysUtils, Classes, DB, MemUtils, DBAccess, DASQLMonitor, DBMonitorIntf;

type
{ TCustomMySQLMonitor }

  TCustomMySQLMonitorClass = class of TCustomMySQLMonitor;

  TCustomMySQLMonitor = class(TCustomDASQLMonitor)
  private
  protected
    FComponent: TComponent;
    class function GetMonitor: TCustomDASQLMonitor; override;
    procedure InternalSQLExecute(Component: TComponent; const SQL: _string; Params: TDAParams; const Caption: string; ATracePoint: TTracePoint; var MessageID: Cardinal); override;
    procedure OnExecuteNative(const SQL: _string);
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetCaption: AnsiString; override;
  published
    property Active default True;
    property Options;
    property TraceFlags;
    property OnSQL;
  end;

implementation

uses
  MyAccess, MyClasses;

var
  MyMonitor: TCustomMySQLMonitor;

{ TCustomMySQLMonitor }

class function TCustomMySQLMonitor.GetMonitor: TCustomDASQLMonitor;
begin
  Result := MyMonitor;
end;

class function TCustomMySQLMonitor.GetCaption: AnsiString;
begin
  Result := 'MyDAC';
end;

constructor TCustomMySQLMonitor.Create(AOwner: TComponent);
begin
  inherited;

  if MyMonitor = nil then
    MyMonitor := Self;
end;

destructor TCustomMySQLMonitor.Destroy;
begin
  if MyMonitor = Self then
    MyMonitor := nil;

  inherited;
end;

procedure TCustomMySQLMonitor.InternalSQLExecute(Component: TComponent; const SQL: _string; Params: TDAParams; const Caption: string; ATracePoint: TTracePoint; var MessageID: Cardinal); 

  procedure ProcessMySQLCommand(MySQLCommand: TMySQLCommand);
  begin
    if MySQLCommand <> nil then
      if ATracePoint = tpBeforeEvent then begin
        FComponent := Component;
        MySQLCommand.OnExecute := OnExecuteNative
      end
      else begin
        FComponent := nil;
        MySQLCommand.OnExecute := nil;
      end;
  end;

var
  UpdateQuery: TCustomMyDataSet;

begin
  if Active and (tfMisc in TraceFlags) then begin
    if Component is TMyCommand then
      ProcessMySQLCommand(TMyAccessUtils.FICommand(TMyCommand(Component)))
    else
    if Component is TCustomMyDataSet then begin
      ProcessMySQLCommand(TMyAccessUtils.FICommand(TCustomMyDataSet(Component)));
      UpdateQuery := TCustomMyDataSet(TDBAccessUtils.GetUpdateQuery(TCustomMyDataSet(Component)));
      if UpdateQuery <> nil then
        ProcessMySQLCommand(TMyAccessUtils.FICommand(UpdateQuery));
    end;
  end;
  inherited;
end;

procedure TCustomMySQLMonitor.OnExecuteNative(const SQL: _string);
begin
  if Assigned(FOnSQLEvent) then
    FOnSQLEvent(FComponent, SQL, tfMisc);
end;

end.
