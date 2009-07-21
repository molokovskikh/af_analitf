//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MySQL Design
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyDesign;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Registry,
{$ENDIF}
{$IFNDEF KYLIX}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, MyDacVcl,
{$IFDEF CLR}
  Borland.Vcl.Design.DesignEditors, Borland.Vcl.Design.DesignIntf,
  Borland.Vcl.Design.FldLinks,
{$ELSE}
{$IFDEF FPC}
  PropEdits, ComponentEditors,
{$ELSE}
  {$IFDEF VER6P}DesignIntf, DesignEditors,{$ELSE}DsgnIntf,{$ENDIF}
  {$IFNDEF BCB}{$IFDEF VER5P}FldLinks,{$ENDIF} ColnEdit,{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ELSE}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  DesignIntf, DesignEditors, QExtCtrls, MyDacClx,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
{$IFNDEF STD}
  MyLoader,
{$ENDIF}
  SysUtils, Classes, TypInfo, MemUtils, CRDesign, DADesign, DBAccess, MyAccess;


{ ------------  MyDac property editors ----------- }
type
{ TMyConnectionOptionsCharsetEditor }

  TMyConnectionOptionsCharsetEditor = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: boolean; override;
  end;

  TMyServerNamePropertyEditor = class (TXStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetXStrProc); override;
    function AutoFill: Boolean; override;
  end;

  TPemFileNameProperty = class(TStringProperty)
  protected
    procedure GetDialogOptions(Dialog: TOpenDialog); virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

{$IFNDEF STD}  
  TMyLoaderTableNameEditor = class (TXStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetXStrProc); override;
    function AutoFill: boolean; override;
  end;

  TMyTableNamesEditor = class (TXStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TMyStoredProcNamesEditor = class (TXStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;
{$ENDIF}

  TMyTableOptionsHandlerIndexEditor = class (TXStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetXStrProc); override;
    function AutoFill: boolean; override;
  end;

  TMyConnectDialogPropertyEditor = class(TComponentProperty)
  private
    FCheckProc: TGetStrProc;
    procedure CheckComponent(const Value: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ ------------  MyDac component editors ----------- }
  TMyConnectionEditor = class(TDAConnectionEditor)
  protected
    procedure InitVerbs; override;
  {$IFNDEF STD}
    procedure Convert;
  {$ENDIF}
  end;

  TMyCommandEditor = class(TDASQLEditor)
  protected
    procedure InitVerbs; override;
  end;

  TMyDataSetEditor = class(TDAComponentEditor);

  TMyQueryEditor = class(TMyDataSetEditor)
  protected
    procedure InitVerbs; override;
{$IFNDEF STD}
{$IFDEF MYBUILDER}
  public
    procedure ShowMyBuilder;
{$ENDIF}
{$ENDIF}
  end;

  TMyTableEditor = class(TMyDataSetEditor)
  protected
    procedure InitVerbs; override;
  end;

  TMyStoredProcEditor = class(TMyDataSetEditor)
  protected
    procedure InitVerbs; override;
  end;

  TMyUpdateSQLEditor = class(TDAUpdateSQLEditor)
  protected
    procedure InitVerbs; override;
  end;

{$IFNDEF STD}
  TMyServerControlEditor = class (TDAComponentEditor)
  protected
    FServiceNames: TStringList;
    procedure InitVerbs; override;

  public
    constructor Create(AComponent: TComponent; 
      ADesigner: {$IFDEF FPC}TComponentEditorDesigner{$ELSE}{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}{$ENDIF}); override;
    destructor Destroy; override;

    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  end;
{$ENDIF}

  TMyScriptEditor = class(TDAScriptEditor)
  protected
    procedure InitVerbs; override;
  end;

{$IFNDEF STD}
  TMyDumpEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
  end;

  TMyBackupEditor = class (TDAComponentEditor)
  public
    procedure Edit; override;
  end;

  TMyLoaderEditor = class(TDAComponentEditor)
  protected
    procedure InitVerbs; override;
    procedure ShowColEditor;
    procedure CreateColumns;
  end;

{$IFDEF MSWINDOWS}
  TMyBuilderEditor = class (TDAComponentEditor)
  protected
    procedure InitVerbs; override;
  public
    procedure ShowMyBuilder;
  end;
{$ENDIF}
{$ENDIF}

{$IFNDEF FPC}
  TMyConnectionList = class (TDAConnectionList)
  protected
    function GetConnectionType: TCustomDAConnectionClass; override;
  end;

{$IFDEF VER6P}
  TMyDesignNotification = class(TDADesignNotification)
  public
    function CreateConnectionList: TDAConnectionList; override;
    function GetConnectionPropertyName: string; override;
  {$IFNDEF STD}
    procedure SelectionChanged(const ADesigner: IDesigner;
      const ASelection: IDesignerSelections); override;
  {$ENDIF}
    procedure ItemInserted(const ADesigner: IDesigner; AItem: TPersistent); override;
  end;
{$ENDIF}
{$ENDIF}

procedure Register;

implementation

uses
{$IFNDEF STD}
{$IFDEF MYBUILDER}
  MyBuilderClient,
{$ENDIF}
{$ENDIF}
{$IFDEF MSWINDOWS}
  {$IFNDEF FPC}
  MyMenu, WinSvc, SvcMgr,
{$ENDIF}
{$ENDIF}
{$IFDEF FPC}daemonapp,{$ENDIF}
{$IFDEF CLR}
  WinUtils,
{$ELSE}
  {$IFNDEF FPC}ToolsAPI,{$ENDIF}
{$ENDIF}
  DB{$IFNDEF STD}, DALoader, MyEmbConnection, MyServerControl, MyDump, MyBackup{$ENDIF},
  MyScript, MyConnectionEditor, MyCommandEditor, MyQueryEditor, DATableEditor,
  MyStoredProcEditor, MyUpdateSQLEditor, DAScriptEditor,
{$IFNDEF STD}
  MyDumpEditor, MyServerControlEditor,
{$ENDIF}
  MyDesignUtils
{$IFNDEF STD}
  , MyNamesEditor
{$ENDIF};

{ TMyConnectionOptionsCharsetEditor }

function TMyConnectionOptionsCharsetEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TMyConnectionOptionsCharsetEditor.AutoFill: boolean;
begin
  Result := False;
end;

procedure TMyConnectionOptionsCharsetEditor.GetValues(Proc: TGetStrProc);
var
  List: _TStringList;
  Connection: TCustomMyConnection;
  i: integer;
begin
  Connection := TDBAccessUtils.FOwner(TCustomMyConnectionOptions(GetComponent(0))) as TCustomMyConnection;
  if Connection = nil then
    Exit;

  List := _TStringList.Create;
  try
    Connection.GetCharsetNames(List);
    List.Sort;

    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

{ TPemFileNameProperty }

procedure TPemFileNameProperty.GetDialogOptions(Dialog: TOpenDialog);
begin
{$IFDEF LINUX}
  Dialog.Filter := 'All Files (*)|*';
{$ENDIF}
{$IFDEF MSWINDOWS}
  Dialog.Filter := 'Pem Files (*.pem)|*.pem|All Files (*.*)|*.*';
{$ENDIF}
  Dialog.Options := Dialog.Options + [ofFileMustExist];
end;

procedure TPemFileNameProperty.Edit;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  GetDialogOptions(OpenDialog);
  if OpenDialog.Execute then
    SetValue(OpenDialog.FileName);
  OpenDialog.Free;
end;

function TPemFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paRevertable, paDialog, paMultiSelect];
end;

{ TMyServerNamePropertyEditor }

function TMyServerNamePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TMyServerNamePropertyEditor.AutoFill: Boolean;
begin
  Result := False;
end;

procedure TMyServerNamePropertyEditor.GetValues(Proc: TGetXStrProc);
var
  i: integer;
  OldCursor: TCursor;
  sl: _TStringList;
begin
  sl := nil;
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crSQLWait;
    sl := _TStringList.Create;
    MyAccess.GetServerList(sl);

    for i := 0 to sl.Count - 1 do
      Proc(sl[i]);
  finally
    Screen.Cursor := OldCursor;
    sl.Free;
  end;
end;

{ TMyLoaderTableNameEditor }
{$IFNDEF STD}
function TMyLoaderTableNameEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

function TMyLoaderTableNameEditor.AutoFill:boolean;
begin
  Result := False;
end;

procedure TMyLoaderTableNameEditor.GetValues(Proc: TGetXStrProc);
var
  List: _TStrings;
  i: integer;
begin
  List := _TStringList.Create;
  try
    GetTablesList(TDALoader(GetComponent(0)).Connection as TCustomMyConnection, List);
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

{ TMyTableNamesEditor }

function TMyTableNamesEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TMyTableNamesEditor.Edit;
var
  Comp: TComponent;
  Conn: TCustomDAConnection;

begin
  Comp := TComponent(GetComponent(0));
  Conn := TMyDesignUtils.GetConnection(Comp);
  if Conn = nil then
    Exit;

  with TMyNamesForm.Create(nil, TMyDesignUtils) do
    try
      Connection := Conn;
      Mode := nmTables;
      if Comp is TMyServerControl then
        Names := TMyServerControl(Comp).TableNames
      else
      if Comp is TMyDump then
        Names := TMyDump(Comp).TableNames
      else
      if Comp is TMyBackup then
        Names := TMyBackup(Comp).TableNames
      else
        Assert(False);

      ShowModal;
      if ModalResult = mrOk then begin
        if Comp is TMyServerControl then
          TMyServerControl(Comp).TableNames := Names
        else
        if Comp is TMyDump then
          TMyDump(Comp).TableNames := Names
        else
        if Comp is TMyBackup then
          TMyBackup(Comp).TableNames := Names
        else
          Assert(False);
      end;

  finally
    Free;
  end;
end;

{ TMyStoredProcNamesEditor }

function TMyStoredProcNamesEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TMyStoredProcNamesEditor.Edit;
var
  Comp: TComponent;
  Conn: TCustomDAConnection;

begin
  Comp := TComponent(GetComponent(0));
  Conn := TMyDesignUtils.GetConnection(Comp);
  if Conn = nil then
    Exit;

  with TMyNamesForm.Create(nil, TMyDesignUtils) do
    try
      Connection := Conn;
      Mode := nmSProc;
      if Comp is TMyDump then begin
        Connection := TMyDump(Comp).Connection;
        Names := TMyDump(Comp).StoredProcNames;
      end
      else
        Assert(False);

      ShowModal;
      if ModalResult = mrOk then begin
        if Comp is TMyDump then
          TMyDump(Comp).StoredProcNames := Names
        else
          Assert(False);
      end;

  finally
    Free;
  end;
end;
{$ENDIF}

{ TMyTableOptionsHandlerIndexEditor }

function TMyTableOptionsHandlerIndexEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TMyTableOptionsHandlerIndexEditor.GetValues(Proc: TGetXStrProc);
var
  Connection: TCustomMyConnection;
  DataSet: TCustomMyTable;
  TableName: _string;
  List: _TStrings;
  i: integer;
begin
  DataSet := TDBAccessUtils.FOwner(GetComponent(0) as TMyTableOptions) as TCustomMyTable;
  if DataSet = nil then
    Exit;
  Connection := DataSet.Connection as TCustomMyConnection;
  if Connection = nil then
    Exit;
  TableName := DataSet.TableName;
  if TableName = '' then
    Exit;
  List := _TStringList.Create;
  try
    GetIndexNames(Connection, List, TableName);
    for i := 0 to List.Count - 1 do
      if _UpperCase(List[i]) = 'PRIMARY' then begin
        List[i] := '`' + List[i] + '`';
        break;
      end;
    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

function TMyTableOptionsHandlerIndexEditor.AutoFill: boolean;
begin
  Result := False;
end;

{ TMyConnectDialogPropertyEditor }

procedure TMyConnectDialogPropertyEditor.CheckComponent(const Value: string);
var
  Component: TComponent;
begin
  Component := {$IFDEF FPC}PropertyHook{$ELSE}Designer{$ENDIF}.GetComponent(Value);
  if Component <> nil then begin
    if not (Component is TMyConnectDialog) then
      Exit;
  end;
  FCheckProc(Value);
end;

procedure TMyConnectDialogPropertyEditor.GetValues(Proc: TGetStrProc);
begin
  FCheckProc := Proc;
  inherited GetValues(CheckComponent);
end;

{ TMyConnectionEditor }

procedure TMyConnectionEditor.InitVerbs;
{$IFNDEF STD}
var
  s: string;
{$ENDIF}  
begin
  inherited;
  AddVerb('Connection Editor...', TMyConnectionEditorForm, TMyDesignUtils);
{$IFNDEF STD}  
{$IFNDEF FPC}
  if Designer <> nil then begin
    if Component is TMyConnection then
      s := 'Convert to TMyEmbConnection'
    else
      s := 'Convert to TMyConnection';
    AddVerb(s, Convert);
  end;
{$ENDIF}
{$ENDIF}
{$IFDEF DBTOOLS}
  AddDBToolsVerbs([dbtFindInDatabaseExplorer]);
{$ENDIF}
end;

{$IFNDEF STD}
procedure TMyConnectionEditor.Convert;
begin
{$IFNDEF FPC}
  if Designer <> nil then
    if Component is TMyConnection then
      ConvertToClass(Self.Designer, Component, TMyEmbConnection)
    else
      ConvertToClass(Self.Designer, Component, TMyConnection);
{$ENDIF}
end;
{$ENDIF}

{ TMyCommandEditor }

procedure TMyCommandEditor.InitVerbs;
begin
  inherited;
  AddVerb('MyCommand E&ditor...', TMyCommandEditorForm, TMyDesignUtils);
{$IFDEF DBTOOLS}     
  AddDBToolsVerbs([dbtEditSql, dbtDebugSql]);
{$ENDIF}
end;

{ TMyQueryEditor }

procedure TMyQueryEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('MyQuery E&ditor...', TMyQueryEditorForm, TMyDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);
{$IFNDEF STD}
{$IFDEF MYBUILDER}
  AddVerb('SQLBuilder...', ShowMyBuilder);
{$ENDIF}
{$ENDIF}
{$IFDEF DBTOOLS}
  AddDBToolsVerbs([dbtEditSql, dbtQueryBuilder, dbtDebugSql, dbtRetrieveData]);
{$ENDIF}

  inherited;
end;

{$IFNDEF STD}
{$IFDEF MYBUILDER}
procedure TMyQueryEditor.ShowMyBuilder;
begin
  Assert(Component is TCustomMyDataSet);
  TMyDesignUtils.CheckForMyBuilder(True);
  MyBuilderAvailable;
  if NeedToCheckMyBuilder = cmNone then
    if MyBuilderClient.ShowMyBuilder(TCustomMyDataSet(Component)) then
      if Self.Designer <> nil then
        Self.Designer.Modified;
end;
{$ENDIF}
{$ENDIF}

{ TMyTableEditor }

procedure TMyTableEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('MyTable E&ditor...', TDATableEditorForm, TMyDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);
{$IFDEF DBTOOLS}
  AddDBToolsVerbs([dbtEditDatabaseObject, dbtFindInDatabaseExplorer]);
{$ENDIF}

  inherited;
end;

procedure TMyStoredProcEditor.InitVerbs;
begin
  AddVerb('Fields &Editor...', ShowFieldsEditor);
  AddVerb('MyStoredProc E&ditor...', TMyStoredProcEditorForm, TMyDesignUtils);
  AddVerb('Data Editor...', ShowDataEditor);
{$IFDEF DBTOOLS}
  if DADesignUtilsClass.DBToolsAvailable and
    (DADesignUtilsClass.GetDBToolsServiceVersion > 2 * $1000000000000 + 35 * $10000 {2.0.35.0}) then
    AddDBToolsVerbs([dbtFindInDatabaseExplorer, dbtDebugSql, dbtCompile, dbtCompileDebug])
  else
    AddDBToolsVerbs([dbtFindInDatabaseExplorer, dbtDebugSql]);
{$ENDIF}

  inherited;
end;

procedure TMyUpdateSQLEditor.InitVerbs;
begin
  inherited;
  AddVerb('MyUpdateSQL E&ditor...', TMyUpdateSQLEditorForm, TMyDesignUtils);
end;

{ TMyServerControlEditor }
{$IFNDEF STD}
constructor TMyServerControlEditor.Create(AComponent: TComponent; 
  ADesigner: {$IFDEF FPC}TComponentEditorDesigner{$ELSE}{$IFDEF VER6P}IDesigner{$ELSE}IFormDesigner{$ENDIF}{$ENDIF});
begin
  inherited;
  FServiceNames := TStringList.Create;
end;

destructor TMyServerControlEditor.Destroy;
begin
  FServiceNames.Free;
  inherited;
end;

procedure TMyServerControlEditor.InitVerbs;
begin
  inherited;
  AddVerb('MyServerControl E&ditor...', TMyServerControlEditorForm, TMyDesignUtils);
end;

function TMyServerControlEditor.GetVerbCount: integer;
{$IFDEF MSWINDOWS}
var
  Status: TCurrentStatus;
  i: integer;
{$ENDIF}
begin
  Result := 1;

{$IFDEF MSWINDOWS}
  if TMyServerControl(Component).Connection <> nil then begin
    try
      TMyServerControl(Component).GetServiceNames(FServiceNames);
      for i := FServiceNames.Count - 1 downto 0 do begin
        Status := TCurrentStatus(Integer(FServiceNames.Objects[i]));
        if (Status <> csRunning) and (Status <> csStopped) then
          FServiceNames.Delete(i);
      end;
      Result := Result + FServiceNames.Count;
    except
      // Win9x or something else
      // Silent
    end;
  end;
{$ENDIF}
end;

function TMyServerControlEditor.GetVerb(Index: integer): string;
{$IFDEF MSWINDOWS}
var
  Status: TCurrentStatus;
  ServiceName, Server: string;
{$ENDIF}
begin
  case Index of
    0: Result := inherited GetVerb(Index);
  {$IFDEF MSWINDOWS}
    else
    begin
      Status := TCurrentStatus(Integer(FServiceNames.Objects[Index - 1]));
      ServiceName := FServiceNames[Index - 1] + ' at ';
      Server := Trim(TMyServerControl(Component).Connection.Server);
      if  Server <> '' then
        ServiceName := ServiceName + Server
      else
        ServiceName := ServiceName + 'localhost';

      if Status = csRunning then
        Result := 'Stop ' + ServiceName
      else
        Result := 'Start ' + ServiceName;
    end;
  {$ENDIF}
  end;
end;

procedure TMyServerControlEditor.ExecuteVerb(Index: integer);
{$IFDEF MSWINDOWS}
var
  Status: TCurrentStatus;
{$ENDIF}
begin
  case Index of
    0: inherited;
  {$IFDEF MSWINDOWS}
    else
    begin
      Status := TCurrentStatus(Integer(FServiceNames.Objects[Index - 1]));
      if Status = csRunning then
        TMyServerControl(Component).ServiceStop(FServiceNames[Index - 1])
      else
        TMyServerControl(Component).ServiceStart(FServiceNames[Index - 1]);
    end;
  {$ENDIF}
  end;
end;
{$ENDIF}

{ TMyScriptEditor }

procedure TMyScriptEditor.InitVerbs;
begin
  inherited;
  AddVerb('MyScript E&ditor...', TDAScriptEditorForm, TMyDesignUtils);
{$IFDEF DBTOOLS}
  AddDBToolsVerbs([dbtEditSql, dbtDebugSql]);
{$ENDIF}
end;

{$IFNDEF STD}
{ TMyDumpEditor }

procedure TMyDumpEditor.InitVerbs;
begin
  inherited;
  AddVerb('MyDump E&ditor...', TMyDumpEditorForm, TMyDesignUtils);
end;

procedure TMyBackupEditor.Edit;
begin
  (TDefaultEditor.Create(Component, Designer) as {$IFNDEF FPC}IComponentEditor{$ELSE}TComponentEditor{$ENDIF}).Edit;
end;

{ TMyLoaderEditor }

procedure TMyLoaderEditor.InitVerbs;
begin
  inherited;
  AddVerb('Columns E&ditor...', ShowColEditor);
  AddVerb('Create Columns', CreateColumns);
end;

procedure TMyLoaderEditor.ShowColEditor;
{$IFDEF FPC}
var
  ce: TCollectionPropertyEditor;
  Hook: TPropertyEditorHook;
{$ENDIF}
begin
  Assert(Component is TDALoader);
{$IFNDEF LINUX}
{$IFNDEF CLR}
{$IFNDEF BCB}
{$IFNDEF FPC}
  with ShowCollectionEditorClass(Designer, TCollectionEditor, Component,
    TDALoader(Component).Columns, 'Columns', [coAdd,coDelete{,coMove}]) do
    UpdateListbox;
{$ELSE}
  if GetHook(Hook) then begin
    ce := TCollectionPropertyEditor.Create(Hook, 1);
    try
      ce.SetPropEntry(0, Component, GetPropInfo(Component, 'Columns'));
      ce.Initialize;
      ce.Edit;
    finally
      ce.Free;
    end;
  end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

procedure TMyLoaderEditor.CreateColumns;
begin
  Assert(Component is TDALoader);
  if (TDALoader(Component).Columns.Count = 0) or
    (MessageDlg('Do you want recreate columns for table ' +
       TDALoader(Component).TableName + '?', mtConfirmation, [mbYes,mbNo], 0) = mrYes)
  then begin
    TDALoader(Component).CreateColumns;
  {$IFDEF FPC}
    Modified;
  {$ENDIF}
    ShowColEditor;
  end;
end;

{$IFDEF MSWINDOWS}
procedure TMyBuilderEditor.InitVerbs;
begin
  inherited;
  AddVerb('SQLBuilder...', ShowMyBuilder);
end;

procedure TMyBuilderEditor.ShowMyBuilder;
begin
  Assert(Component is TMyBuilder);
  TMyDesignUtils.CheckForMyBuilder(True);
  if TMyBuilder(Component).ShowModal then
    if Self.Designer <> nil then
      Self.Designer.Modified;
end;
{$ENDIF}
{$ENDIF}

{$IFNDEF FPC}
{ TMyConnectionList }

function TMyConnectionList.GetConnectionType: TCustomDAConnectionClass;
begin
  Result := TCustomMyConnection;
end;

{$IFDEF VER6P}
function TMyDesignNotification.CreateConnectionList: TDAConnectionList;
begin
  Result := TMyConnectionList.Create;
end;

function TMyDesignNotification.GetConnectionPropertyName: string;
begin
  Result := 'Connection';
end;

procedure TMyDesignNotification.ItemInserted(const ADesigner: IDesigner; AItem: TPersistent);
begin
  if (AItem <> nil) and ((AItem is TCustomMyDataSet) or (AItem is TMyCommand) or
    (AItem is TMyScript) or
  {$IFNDEF STD}
    (AItem is TMyLoader) or
    (AItem is TMyDump) or
    (AItem is TMyBackup) or
  {$ENDIF}
    (AItem is TMyMetaData) or
    (AItem is TMyDataSource)) then
    FItem := AItem;
end;

{$IFNDEF STD}
procedure TMyDesignNotification.SelectionChanged(const ADesigner: IDesigner; const ASelection: IDesignerSelections);
{$IFDEF CLR}
begin
end;
{$ELSE}
var
  ModuleServices: IOTAModuleServices;
  CurrentModule: IOTAModule;
  Project: IOTAProject;
  ProjectOptions: IOTAProjectOptions;
  DelphiPath: string;
  s: string;

  {OptionNames: TOTAOptionNameArray;
  i: integer;}
begin
  //OFS('TMyDesignNotification.SelectionChanged=============');

  CurrentProjectOutputDir := '';

{$IFDEF CLR}
  ModuleServices := BorlandIDE.ModuleServices;
{$ELSE}
  ModuleServices :=BorlandIDEServices as IOTAModuleServices;
{$ENDIF}

  CurrentModule := ModuleServices.CurrentModule;
  //OFS('  CurrentModule.FileName = ' + CurrentModule.FileName);
  if CurrentModule.OwnerCount = 0 then
    Exit;

  Project := CurrentModule.Owners[0];
  ProjectOptions := Project.ProjectOptions;

  {OFS('  Project.FileName = ' + Project.FileName);
  OptionNames := ProjectOptions.GetOptionNames;
  for i := Low(OptionNames) to High(OptionNames) do begin
    s := OptionNames[i].Name;
    try
      s := s + '=' + ProjectOptions.Values[s];
    except
    end;
    OFS(s);
  end;}


  CurrentProjectOutputDir := Trim(ProjectOptions.Values['OutputDir']);
  //OFS('  ' + CurrentProjectOutputDir);

  // CurrentProjectOutputDir may be:
  //   - fixed path "c:\qqq\ccc"
  //   - relative path from project dpr-file "./qqq/ccc" or "..\ccc\qqq"
  //   ? empty path "", equal to $(DELPHI)/Projects
  //   ? relative path from $(DELPHI)/Projects "qqq/ccc"

{  if (CurrentProjectOutputDir <> '') and ((CurrentProjectOutputDir[1] = '/') or (CurrentProjectOutputDir[1] = '\')) then
    CurrentProjectOutputDir := Copy(CurrentProjectOutputDir, 2)
 }
  if (CurrentProjectOutputDir <> '') then begin
    if (CurrentProjectOutputDir[1] = '.') then begin // relative path
    s := Trim(ExtractFilePath(Project.FileName));
    if s = '' then
      CurrentProjectOutputDir := ''
    else
      CurrentProjectOutputDir := IncludeTrailingBackslash(s) + CurrentProjectOutputDir;
    end
    else
    if Pos('$(DELPHI)', UpperCase(CurrentProjectOutputDir)) > 0 then begin
      DelphiPath := GetEnvironmentVariable('DELPHI');
      CurrentProjectOutputDir := StringReplace(CurrentProjectOutputDir, '$(DELPHI)', DelphiPath, [rfReplaceAll, rfIgnoreCase]);
  end;
  end
  else
    CurrentProjectOutputDir := Trim(ExtractFilePath(Project.FileName));
  //OFS('  ' + CurrentProjectOutputDir);
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

procedure Register;
begin
  // Register property editors
{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(TStrings), TMyEmbConnection, 'Params', TDAPropertyEditor);
{$ENDIF}
  RegisterPropertyEditor(TypeInfo(String), TCustomMyConnectionOptions, 'Charset', TMyConnectionOptionsCharsetEditor);
{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(TCustomConnectDialog), TMyEmbConnection, 'ConnectDialog', TMyConnectDialogPropertyEditor);
{$ENDIF}
{$IFDEF HAVE_OPENSSL}
  RegisterPropertyEditor(TypeInfo(String), TMyConnectionSSLOptions, 'Key', TPemFileNameProperty);
  RegisterPropertyEditor(TypeInfo(String), TMyConnectionSSLOptions, 'Cert', TPemFileNameProperty);
  RegisterPropertyEditor(TypeInfo(String), TMyConnectionSSLOptions, 'CACert', TPemFileNameProperty);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(Boolean), TMyConnection, 'Embedded', nil);
  RegisterPropertyEditor(TypeInfo(_string), TMyConnection, 'Server', TMyServerNamePropertyEditor);
  RegisterPropertyEditor(TypeInfo(TCustomConnectDialog), TMyConnection, 'ConnectDialog', TMyConnectDialogPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TMyQuery, 'SQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyQuery, 'SQLDelete', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyQuery, 'SQLInsert', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyQuery, 'SQLRefresh', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyQuery, 'SQLUpdate', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(Boolean), TMyDataSetOptions, 'TrimFixedChar', nil);

  RegisterPropertyEditor(TypeInfo(_TStrings), TMyCommand, 'SQL', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TMyScript, 'SQL', TDAPropertyEditor);
{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(_string), TMyLoader, 'TableName', TMyLoaderTableNameEditor);
  RegisterPropertyEditor(TypeInfo(Boolean), TMyLoader, 'Debug', nil);
  RegisterPropertyEditor(TypeInfo(TDAColumnDataType), TMyColumn, 'DataType', nil);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(_TStrings), TMyStoredProc, 'SQL', nil);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyStoredProc, 'SQLDelete', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyStoredProc, 'SQLInsert', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyStoredProc, 'SQLRefresh', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyStoredProc, 'SQLUpdate', TDAPropertyEditor);

  RegisterPropertyEditor(TypeInfo(_TStrings), TMyUpdateSQL, 'InsertSQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyUpdateSQL, 'ModifySQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyUpdateSQL, 'DeleteSQL', TDAPropertyEditor);
  RegisterPropertyEditor(TypeInfo(_TStrings), TMyUpdateSQL, 'RefreshSQL', TDAPropertyEditor);

{$IFNDEF STD}
  RegisterPropertyEditor(TypeInfo(_string), TMyServerControl, 'TableNames', TMyTableNamesEditor);
  RegisterPropertyEditor(TypeInfo(_string), TMyDump, 'TableNames', TMyTableNamesEditor);
  RegisterPropertyEditor(TypeInfo(_string), TMyDump, 'StoredProcNames', TMyStoredProcNamesEditor);
  RegisterPropertyEditor(TypeInfo(_string), TMyBackup, 'TableNames', TMyTableNamesEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(_string), TMyTableOptions, 'HandlerIndex', TMyTableOptionsHandlerIndexEditor);

  // Register component editors
  DARegisterComponentEditor(TCustomMyConnection, TMyConnectionEditor, TMyConnectionEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyCommand, TMyCommandEditor, TMyCommandEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyQuery, TMyQueryEditor, TMyQueryEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyTable, TMyTableEditor, TDATableEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyStoredProc, TMyStoredProcEditor, TMyStoredProcEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyUpdateSQL, TMyUpdateSQLEditor, TMyUpdateSQLEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyScript, TMyScriptEditor, TDAScriptEditorForm, TMyDesignUtils);
{$IFNDEF STD}
  DARegisterComponentEditor(TMyServerControl, TMyServerControlEditor, TMyServerControlEditorForm, TMyDesignUtils);
  DARegisterComponentEditor(TMyBackup, TMyBackupEditor, nil, TMyDesignUtils);
  RegisterComponentEditor(TMyLoader, TMyLoaderEditor);
{$IFDEF MSWINDOWS}
  RegisterComponentEditor(TMyBuilder, TMyBuilderEditor);
{$ENDIF}
  DARegisterComponentEditor(TMyDump, TMyDumpEditor, TMyDumpEditorForm, TMyDesignUtils);
{$ENDIF}
  DARegisterComponentEditor(TMyMetaData, TDAComponentEditor, nil, TMyDesignUtils);
{$IFNDEF FPC}
  RegisterComponentEditor(TMyDataSource, TCRDataSourceEditor);
{$ENDIF}

{$IFDEF MSWINDOWS}
{$IFNDEF FPC}
{$IFNDEF DBTOOLS}
{$IFNDEF STD}
  TMyDesignUtils.CheckForMyBuilder(False);
{$ENDIF}
{$ELSE}
{$IFDEF WIN32}
  TMyDesignUtils.DBToolsAvailable;
{$ENDIF}
{$ENDIF}
  Menu.AddItems({$IFDEF CLR}WinUtils{$ELSE}SysInit{$ENDIF}.HInstance);
{$ENDIF}
{$ENDIF}
end;

{$IFNDEF FPC}
{$IFDEF VER6P}
var
  Notificator: TMyDesignNotification;
{$ENDIF}

initialization
{$IFDEF VER6P}
  Notificator := TMyDesignNotification.Create;
  RegisterDesignNotification(Notificator);
{$ENDIF}


{$IFDEF VER6P}
  UnRegisterDesignNotification(Notificator);
{$ENDIF}

{$ELSE FPC}
{$ENDIF FPC}
end.
