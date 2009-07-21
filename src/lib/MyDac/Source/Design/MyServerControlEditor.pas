
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  ServerControl Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyServerControlEditor;
{$ENDIF}
interface
uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, DBGrids, Grids, 
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QButtons, QGrids, QDBGrids,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  CREditor, CRTabEditor, DB, MyAccess, MyServerControl, MyConsts;

type
  TMyServerControlEditorForm = class(TCRTabEditorForm)
    Label2: TLabel;
    shTables: TTabSheet;
    shStatus: TTabSheet;
    shVariables: TTabSheet;
    shProcessList: TTabSheet;
    btAnalyze: TBitBtn;
    btOptimize: TBitBtn;
    cbTableNames: TComboBox;
    DataSource: TDataSource;
    DBGridTables: TDBGrid;
    DBGridStatus: TDBGrid;
    DBGridVariables: TDBGrid;
    DBGridProcessList: TDBGrid;
    Panel1: TPanel;
    btCheck: TBitBtn;
    cbQuick: TCheckBox;
    cbUseFrm: TCheckBox;
    cbExtended: TCheckBox;
    btRepair: TBitBtn;
    Shape1: TShape;
    Shape2: TShape;
    cbCheckQuick: TCheckBox;
    cbCheckFast: TCheckBox;
    cbCheckChanged: TCheckBox;
    cbCheckMedium: TCheckBox;
    cbCheckExtended: TCheckBox;
    Panel2: TPanel;
    cbFullProcessList: TCheckBox;
    btKill: TBitBtn;
    btRefreshPL: TBitBtn;
    Panel3: TPanel;
    btRefreshVar: TBitBtn;
    Panel4: TPanel;
    btRefreshStatus: TBitBtn;
    procedure edSizeChange(Sender: TObject);
    procedure cbTableNamesExit(Sender: TObject);
    procedure btAnalyzeClick(Sender: TObject);
    procedure btOptimizeClick(Sender: TObject);
    procedure btCheckClick(Sender: TObject);
    procedure cbFullProcessListClick(Sender: TObject);
    procedure btRepairClick(Sender: TObject);
    procedure cbTableNamesDropDown(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btKillClick(Sender: TObject);
    procedure btRefreshPLClick(Sender: TObject);

  protected
    FServerControl: TMyServerControl;

    procedure DoInit; override;
    procedure DoSave; override;
    procedure DoFinish; override;

  {$IFDEF MSWINDOWS}
    procedure SaveColumnStates;
    procedure LoadColumnStates;

    function GetActiveDBGrid: TDBGrid;
    function SaveState: boolean; override;
    function LoadState: boolean; override;
  {$ENDIF}

    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;

    procedure DoPageControlChanging(Sender: TObject; var AllowChange: Boolean); override;
    procedure DoPageControlChange(Sender: TObject); override;
  public
    property ServerControl: TMyServerControl read FServerControl write FServerControl;

    procedure ActivateServerControlSheet;
  end;

implementation
uses
  DBAccess, CRAccess, MyCall,
  MemData, CRParser, MyNamesEditor, TypInfo, MyClasses
  {$IFDEF MSWINDOWS}
  , Registry
  {$ENDIF}
  {$IFDEF VER6P}
  , Variants
  {$ENDIF}
  ;

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyServerControlEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

function TMyServerControlEditorForm.GetComponent: TComponent;
begin
  Result := FServerControl;
end;

procedure TMyServerControlEditorForm.SetComponent(Value: TComponent);
begin
  FServerControl := Value as TMyServerControl;
end;

procedure TMyServerControlEditorForm.DoInit;
  procedure Replace(var DBGrid: TDBGrid);
  var
    cg: TCustomDBGrid;
  begin
    cg := DBGrid;
    if ReplaceGridToCRGrid(cg) then begin
      DBGrid := TDBGrid(cg);
      SetPropValue(DBGrid, 'Options', 'dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgConfirmDelete,dgCancelOnExit]');
      SetPropValue(DBGrid, 'OptionsEx', 'dgeRecordCount,dgeSearchBar,dgeLocalFilter]');
    end;
  end;

var
  Major, Minor, Release: integer;
begin
  inherited;

  Modified := False;

  Assert(ServerControl <> nil);
  ServerControl.Close;
  ServerControl.Options.LongStrings := True;

  cbTableNames.Text := ServerControl.TableNames;
  DataSource.DataSet := ServerControl;

  if ServerControl.Connection <> nil then begin
    DecodeVersion(ServerControl.Connection.ClientVersion, Major, Minor, Release);
    cbUseFrm.Enabled := ((Major = 4) and (Minor >= 1)) or (Major > 4);
  end;

  Replace(DBGridTables);
  Replace(DBGridStatus);
  Replace(DBGridVariables);
  Replace(DBGridProcessList);
end;

procedure TMyServerControlEditorForm.DoSave;
begin
end;

procedure TMyServerControlEditorForm.DoFinish;
begin
  ServerControl.Close;
  ServerControl.Options.LongStrings := False;
end;

procedure TMyServerControlEditorForm.ActivateServerControlSheet;
begin
  PageControl.ActivePage := shTables;
end;

procedure TMyServerControlEditorForm.edSizeChange(Sender: TObject);
begin
//  if ModifyLocked then
//    Exit;

  Modified := True;
end;

procedure TMyServerControlEditorForm.cbTableNamesExit(Sender: TObject);
begin
  inherited;

  ServerControl.TableNames := cbTableNames.Text;
  cbTableNames.Text := ServerControl.TableNames;
end;

procedure TMyServerControlEditorForm.btAnalyzeClick(Sender: TObject);
begin
  ServerControl.AnalyzeTable;
{$IFDEF MSWINDOWS}
  LoadColumnStates;
{$ENDIF}
end;

procedure TMyServerControlEditorForm.btOptimizeClick(Sender: TObject);
begin
  ServerControl.OptimizeTable;
{$IFDEF MSWINDOWS}
  LoadColumnStates;
{$ENDIF}
end;

procedure TMyServerControlEditorForm.btCheckClick(Sender: TObject);
var
  CheckTypes: TMyCheckTypes;
begin
  CheckTypes := [];

  if cbCheckQuick.Checked then
    CheckTypes := CheckTypes + [ctQuick];
  if cbCheckFast.Checked then
    CheckTypes := CheckTypes + [ctFast];
  if cbCheckChanged.Checked then
    CheckTypes := CheckTypes + [ctChanged];
  if cbCheckMedium.Checked then
    CheckTypes := CheckTypes + [ctMedium];
  if cbCheckExtended.Checked then
    CheckTypes := CheckTypes + [ctExtended];

  ServerControl.CheckTable(CheckTypes);

{$IFDEF MSWINDOWS}
  LoadColumnStates;
{$ENDIF}
end;

procedure TMyServerControlEditorForm.DoPageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
{$IFDEF MSWINDOWS}
  SaveColumnStates;
{$ENDIF}
end;

procedure TMyServerControlEditorForm.DoPageControlChange(Sender: TObject);
begin
  ServerControl.Close;
  if PageControl.ActivePage = shStatus then
    ServerControl.ShowStatus
  else
  if PageControl.ActivePage = shVariables then
    ServerControl.ShowVariables
  else
  if PageControl.ActivePage = shProcessList then
    ServerControl.ShowProcessList(cbFullProcessList.Checked);

{$IFDEF MSWINDOWS}
  LoadColumnStates;
{$ENDIF}
end;

procedure TMyServerControlEditorForm.cbFullProcessListClick(
  Sender: TObject);
begin
  PageControlChange(nil);
end;

procedure TMyServerControlEditorForm.btRepairClick(Sender: TObject);
var
  RepairTypes: TMyRepairTypes;
begin
  RepairTypes := [];
  if cbQuick.Checked then
    RepairTypes := RepairTypes + [rtQuick];
  if cbExtended.Checked then
    RepairTypes := RepairTypes + [rtExtended];
  if cbUseFrm.Checked then
    RepairTypes := RepairTypes + [rtUseFrm];

  ServerControl.RepairTable(RepairTypes);
{$IFDEF MSWINDOWS}
  LoadColumnStates;
{$ENDIF}
end;

{$IFDEF MSWINDOWS}

function TMyServerControlEditorForm.GetActiveDBGrid: TDBGrid;
begin
  Result := nil;
  if PageControl.ActivePage = shTables then
    Result := DBGridTables
  else
  if PageControl.ActivePage = shStatus then
    Result := DBGridStatus
  else
  if PageControl.ActivePage = shVariables then
    Result := DBGridVariables
  else
  if PageControl.ActivePage = shProcessList then
    Result := DBGridProcessList
  else
    Assert(False);
end;

procedure TMyServerControlEditorForm.SaveColumnStates;
var
  Registry: TRegistry;
  i: integer;
  DBGrid: TDBGrid;
  Columns: TDBGridColumns;

begin
  DBGrid := GetActiveDBGrid;
  if (DBGrid = nil)
    or (DBGrid.DataSource = nil)
    or (DBGrid.DataSource.DataSet = nil)
    or not DBGrid.DataSource.DataSet.Active then
    Exit;
  Columns := TDBGridColumns(DBGrid.Columns);

  Registry := TRegistry.Create;
  try
    with Registry do begin
      if DBGrid.DataSource.DataSet.Active then begin
        OpenKey(KeyPath + '\' + FolderName + '\' + DBGrid.Name, True);
        for i := 0 to Columns.Count - 1 do
          WriteInteger('ColumnWidth' + IntToStr(i), Columns[i].Width);
        CloseKey;
      end;
    end;
  finally
    Registry.Free;
  end;
end;

procedure TMyServerControlEditorForm.LoadColumnStates;
var
  Registry: TRegistry;
  i, n: integer;
  DBGrid: TDBGrid;
  Columns: TDBGridColumns;

begin
  DBGrid := GetActiveDBGrid;
  if (DBGrid = nil)
    or (DBGrid.DataSource = nil)
    or (DBGrid.DataSource.DataSet = nil)
    or not DBGrid.DataSource.DataSet.Active then
    Exit;
  Columns := TDBGridColumns(DBGrid.Columns);

  Registry := TRegistry.Create;
  try
    with Registry do
      if OpenKey(KeyPath + '\' + FolderName + '\' + DBGrid.Name, False) then begin
        for i := 0 to Columns.Count - 1 do
          if ValueExists('ColumnWidth' + IntToStr(i)) then
            Columns[i].Width := ReadInteger('ColumnWidth' + IntToStr(i));
        CloseKey;
      end
      else begin
        if (DBGrid = DBGridTables) and (DBGrid.Columns.Count = 4) then begin
          DBGrid.Columns[0].Width := 100;
          DBGrid.Columns[3].Width := DBGrid.ClientWidth - DBGrid.Columns[0].Width
            - DBGrid.Columns[1].Width - DBGrid.Columns[2].Width - 15;
        end;
        if ((DBGrid = DBGridStatus) or (DBGrid = DBGridVariables)) and (DBGrid.Columns.Count = 2) then begin
          DBGrid.Columns[0].Width := 200;
          DBGrid.Columns[1].Width := DBGrid.ClientWidth - DBGrid.Columns[0].Width - 15;
        end;
        if (DBGrid = DBGridProcessList) and (DBGrid.Columns.Count = 8) then begin
          DBGrid.Columns[0].Width := 50;
          DBGrid.Columns[1].Width := 40;
          DBGrid.Columns[2].Width := 90;
          DBGrid.Columns[3].Width := 60;
          DBGrid.Columns[4].Width := 60;
          DBGrid.Columns[5].Width := 35;
          DBGrid.Columns[6].Width := 50;
          n := DBGrid.ClientWidth - DBGrid.Columns[0].Width
            - DBGrid.Columns[1].Width - DBGrid.Columns[2].Width - DBGrid.Columns[3].Width
            - DBGrid.Columns[4].Width - DBGrid.Columns[5].Width - DBGrid.Columns[6].Width - 20;
          if n < 100 then
            DBGrid.Columns[7].Width := 200
          else
            DBGrid.Columns[7].Width := n;
        end;
     end;
  finally
    Registry.Free;
  end
end;

function TMyServerControlEditorForm.SaveState: boolean;
var
  Registry: TRegistry;
  j: integer;
begin
  Result := inherited SaveState;

  Registry := TRegistry.Create;
  try
    with Registry do begin
      OpenKey(KeyPath + '\' + FolderName, True);
      for j := 0 to ComponentCount - 1 do
        if Components[j] is TCheckBox then
          WriteBool(Components[j].Name, TCheckBox(Components[j]).Checked);
    end;
  finally
    Registry.Free;
  end;
end;

function TMyServerControlEditorForm.LoadState: boolean;
var
  Registry: TRegistry;
  j: integer;
begin
  Result := inherited LoadState;
  Registry := TRegistry.Create;
  try
    with Registry do begin
      OpenKey(KeyPath + '\' + FolderName, True);
      for j := 0 to ComponentCount - 1 do
        if ValueExists(Components[j].Name) then
          if Components[j] is TCheckBox then
            TCheckBox(Components[j]).Checked := ReadBool(Components[j].Name);
    end;
  finally
    Registry.Free;
  end
end;
{$ENDIF}

procedure TMyServerControlEditorForm.cbTableNamesDropDown(Sender: TObject);
begin
  cbTableNamesExit(nil);
  with TMyNamesForm.Create(nil, DADesignUtilsClass) do
    try
      Connection := ServerControl.Connection;
      Names := cbTableNames.Text;
      Mode := nmTables;

      ShowModal;
      if ModalResult = mrOk then
        cbTableNames.Text := Names;

      cbTableNames.Update;

    finally
      Free;
    end;
end;

procedure TMyServerControlEditorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{$IFDEF MSWINDOWS}
  SaveColumnStates;
{$ENDIF}

  inherited;
end;

procedure TMyServerControlEditorForm.btKillClick(Sender: TObject);
var
  OldRecNo: integer;
  
begin
  if MessageDlg(SAreYouSureKill, mtConfirmation, [mbYes,mbNo], 0) = mrNo then
    Exit;

{$IFDEF MSWINDOWS}
  SaveColumnStates;
{$ENDIF}

  OldRecNo := ServerControl.RecNo;
  try
    ServerControl.KillProcess(ServerControl.FieldByName('id').AsInteger);
    PageControlChange(nil);
  finally
    ServerControl.RecNo := OldRecNo;
  end;
end;

procedure TMyServerControlEditorForm.btRefreshPLClick(Sender: TObject);
var
  OldRecNo: integer;
begin
  OldRecNo := ServerControl.RecNo;
  ServerControl.Refresh;
  ServerControl.RecNo := OldRecNo;
end;

{$IFDEF FPC}
initialization
  {$i MyServerControlEditor.lrs}
{$ENDIF}

end.
