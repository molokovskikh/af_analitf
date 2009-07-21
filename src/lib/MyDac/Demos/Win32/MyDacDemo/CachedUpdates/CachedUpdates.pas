{$I DacDemo.inc}

unit CachedUpdates;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, QButtons, MyDacClx,
{$ELSE}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons, MyDacVcl,
{$ENDIF}
{$IFDEF CLR}
  System.ComponentModel,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, DBAccess, MyAccess, Db, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DemoFrame, MyScript;

type

  { TCachedUpdatesFrame }

  TCachedUpdatesFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    MyQuery: TMyQuery;
    Panel8: TPanel;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    RefreshRecord: TSpeedButton;
    Panel1: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    btApply: TSpeedButton;
    btCommit: TSpeedButton;
    btCancel: TSpeedButton;
    btRevertRecord: TSpeedButton;
    Panel2: TPanel;
    cbCachedUpdates: TCheckBox;
    cbCustomUpdate: TCheckBox;
    Panel4: TPanel;
    Label3: TLabel;
    Panel5: TPanel;
    btStartTrans: TSpeedButton;
    btCommitTrans: TSpeedButton;
    btRollBackTrans: TSpeedButton;
    Panel6: TPanel;
    Label1: TLabel;
    cbDeleted: TCheckBox;
    cbInserted: TCheckBox;
    cbModified: TCheckBox;
    cbUnmodified: TCheckBox;
    Panel7: TPanel;
    Label4: TLabel;
    edUpdateBatchSize: TEdit;
    Panel9: TPanel;
    DBNavigator: TDBNavigator;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btStartTransClick(Sender: TObject);
    procedure btCommitTransClick(Sender: TObject);
    procedure btRollbackTransClick(Sender: TObject);
    procedure cbCachedUpdatesClick(Sender: TObject);
    procedure MyQueryUpdateError(DataSet: TDataSet; E: EDatabaseError;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure MyQueryUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    procedure cbCustomUpdateClick(Sender: TObject);
    procedure MyQueryCalcFields(DataSet: TDataSet);
    procedure btCommitClick(Sender: TObject);
    procedure cbUnmodifiedClick(Sender: TObject);
    procedure cbModifiedClick(Sender: TObject);
    procedure cbInsertedClick(Sender: TObject);
    procedure cbDeletedClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DataSourceStateChange(Sender: TObject);
  {$IFDEF FPC}
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  {$ELSE}
    procedure DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
  {$ENDIF}
    procedure btRevertRecordClick(Sender: TObject);
    procedure RefreshRecordClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTrans;
    procedure ShowPending;
    procedure ShowUpdateRecordTypes;
  public
    destructor Destroy; override;

    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

uses
  UpdateAction, MyDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

destructor TCachedUpdatesFrame.Destroy;
begin
  inherited;
  FreeAndNil(UpdateActionForm);
end;

procedure TCachedUpdatesFrame.ShowTrans;
begin
  if MyQuery.Connection.InTransaction then
    MyDACForm.StatusBar.Panels[2].Text := 'In Transaction'
  else
    MyDACForm.StatusBar.Panels[2].Text := '';
end;

procedure TCachedUpdatesFrame.ShowPending;
begin
  if MyQuery.UpdatesPending then
    MyDACForm.StatusBar.Panels[1].Text := 'Updates Pending'
  else
    MyDACForm.StatusBar.Panels[1].Text := '';
end;

procedure TCachedUpdatesFrame.ShowUpdateRecordTypes;
begin
  if MyQuery.CachedUpdates then begin
    cbUnmodified.Checked := rtUnmodified in MyQuery.UpdateRecordTypes;
    cbModified.Checked := rtModified in MyQuery.UpdateRecordTypes;
    cbInserted.Checked := rtInserted in MyQuery.UpdateRecordTypes;
    cbDeleted.Checked := rtDeleted in MyQuery.UpdateRecordTypes;
  end;
end;

procedure TCachedUpdatesFrame.btOpenClick(Sender: TObject);
begin
  MyQuery.Open;
end;

procedure TCachedUpdatesFrame.btCloseClick(Sender: TObject);
begin
  MyQuery.Close;
end;

procedure TCachedUpdatesFrame.btApplyClick(Sender: TObject);
begin
  MyQuery.Options.UpdateBatchSize := StrToInt(edUpdateBatchSize.Text);
  MyQuery.ApplyUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btCommitClick(Sender: TObject);
begin
  MyQuery.CommitUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btCancelClick(Sender: TObject);
begin
  MyQuery.CancelUpdates;
  ShowPending;
end;

procedure TCachedUpdatesFrame.btStartTransClick(Sender: TObject);
begin
  MyQuery.Connection.StartTransaction;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.btCommitTransClick(Sender: TObject);
begin
  MyQuery.Connection.Commit;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.btRollbackTransClick(Sender: TObject);
begin
  MyQuery.Connection.Rollback;
  ShowTrans;
end;

procedure TCachedUpdatesFrame.cbCachedUpdatesClick(Sender: TObject);
begin
  try
    MyQuery.CachedUpdates := cbCachedUpdates.Checked;
  except
    cbCachedUpdates.Checked := MyQuery.CachedUpdates;
    raise;
  end;
  ShowUpdateRecordTypes;
end;

procedure TCachedUpdatesFrame.MyQueryUpdateError(DataSet: TDataSet; E: EDatabaseError;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  UpdateActionForm.rgAction.ItemIndex := Ord(UpdateAction);
  UpdateActionForm.rgKind.ItemIndex := Ord(UpdateKind);
  if DataSet.Fields[0].IsNull then
    UpdateActionForm.lbField.Caption := 'NULL'
  else
    UpdateActionForm.lbField.Caption := String(DataSet.Fields[0].Value);
  UpdateActionForm.lbMessage.Caption := Trim(E.Message);
  UpdateActionForm.ShowModal;
  UpdateAction := TUpdateAction(UpdateActionForm.rgAction.ItemIndex);
end;

procedure TCachedUpdatesFrame.MyQueryUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  UpdateActionForm.rgAction.ItemIndex := Ord(UpdateAction);
  UpdateActionForm.rgKind.ItemIndex := Ord(UpdateKind);
  UpdateActionForm.lbField.Caption := String(DataSet.Fields[0].NewValue);
  UpdateActionForm.lbMessage.Caption := '';
  UpdateActionForm.ShowModal;
  UpdateAction := TUpdateAction(UpdateActionForm.rgAction.ItemIndex);
end;

procedure TCachedUpdatesFrame.cbCustomUpdateClick(Sender: TObject);
begin
  if cbCustomUpdate.Checked then
    MyQuery.OnUpdateRecord := MyQueryUpdateRecord
  else
    MyQuery.OnUpdateRecord := nil;
end;

procedure TCachedUpdatesFrame.MyQueryCalcFields(DataSet: TDataSet);
var
  St:string;
begin
  case Ord(TCustomMyDataSet(DataSet).UpdateStatus) of
    0: St := 'Unmodified';
    1: St := 'Modified';
    2: St := 'Inserted';
    3: St := 'Deleted';
  end;
  DataSet.FieldByName('Status').AsString := St;

{  case Ord(TMyDataSet(DataSet).UpdateResult) of
    0: St := 'Fail';
    1: St := 'Abort';
    2: St := 'Skip';
    3: St := 'Applied';
  end;
  DataSet.FieldByName('Result').AsString := St;}
end;

procedure TCachedUpdatesFrame.cbUnmodifiedClick(Sender: TObject);
begin
  if cbUnmodified.Checked then
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes + [rtUnmodified]
  else
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes - [rtUnmodified];
end;

procedure TCachedUpdatesFrame.cbModifiedClick(Sender: TObject);
begin
  if cbModified.Checked then
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes + [rtModified]
  else
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes - [rtModified];
end;

procedure TCachedUpdatesFrame.cbInsertedClick(Sender: TObject);
begin
  if cbInserted.Checked then
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes + [rtInserted]
  else
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes - [rtInserted];
end;

procedure TCachedUpdatesFrame.cbDeletedClick(Sender: TObject);
begin
  if cbDeleted.Checked then
    MyQuery.UpdateRecordTypes:= MyQuery.UpdateRecordTypes + [rtDeleted]
  else
    MyQuery.UpdateRecordTypes := MyQuery.UpdateRecordTypes - [rtDeleted];
end;

procedure TCachedUpdatesFrame.DataSourceStateChange(Sender: TObject);
begin
  ShowPending;
  MyDACForm.StatusBar.Panels[3].Text := 'Record: ' + IntToStr(MyQuery.RecNo) + ' of '+ IntToStr(MyQuery.RecordCount);
end;

procedure TCachedUpdatesFrame.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  DataSourceStateChange(nil);
end;

{$IFDEF FPC}
procedure TCachedUpdatesFrame.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
{$ELSE}
procedure TCachedUpdatesFrame.DBGridDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
{$ENDIF}
begin
  if MyQuery.UpdateResult in [uaFail,uaSkip] then
    TDBGrid(Sender).Canvas.Brush.Color := clRed
  else
    if MyQuery.UpdateStatus <> usUnmodified then
      TDBGrid(Sender).Canvas.Brush.Color := clYellow;

{$IFNDEF FPC}
  TDBGrid(Sender).DefaultDrawDataCell(Rect, Field, State);
{$ENDIF}
end;

procedure TCachedUpdatesFrame.btRevertRecordClick(Sender: TObject);
begin
  MyQuery.RevertRecord;
  ShowPending;
end;

procedure TCachedUpdatesFrame.RefreshRecordClick(Sender: TObject);
begin
  MyQuery.RefreshRecord;
end;

// Demo management
procedure TCachedUpdatesFrame.Initialize;
begin
  MyQuery.Connection := Connection as TCustomMyConnection;
  if UpdateActionForm = nil then
    UpdateActionForm  := TUpdateActionForm.Create(MyDacForm);
  cbCachedUpdates.Checked := MyQuery.CachedUpdates;
  ShowUpdateRecordTypes;
end;

procedure TCachedUpdatesFrame.SetDebug(Value: boolean);
begin
  MyQuery.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i CachedUpdates.lrs}
{$ENDIF}

end.
