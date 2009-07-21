unit uCachedUpdates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBase, IWCompLabel, IWControl, IWCompRectangle, IWHTMLControls,
  IWCompButton, IWContainer, IWRegion, IWCompMemo, IWCompCheckbox, DB,
  MemDS, DBAccess, MyAccess, IWGrids, IWDBGrids, IWDBStdCtrls,
  IWCSStdCtrls, IWClientSideDatasetBase, IWClientSideDatasetDBLink,
  IWDynGrid;

type
  TfmCachedUpdates = class(TfmBase)
    IWRegion4: TIWRegion;
    IWRectangle3: TIWRectangle;
    cbCachedUpdates: TIWCheckBox;
    IWRegion1: TIWRegion;
    meSQL: TIWMemo;
    IWLabel1: TIWLabel;
    btOpen: TIWButton;
    btClose: TIWButton;
    Query: TMyQuery;
    cbUnmodified: TIWCheckBox;
    cbModified: TIWCheckBox;
    cbInserted: TIWCheckBox;
    cbDeleted: TIWCheckBox;
    IWLabel2: TIWLabel;
    lbResult: TIWLabel;
    lbUpdates: TIWLabel;
    btApply: TIWButton;
    btCommit: TIWButton;
    btCancel: TIWButton;
    btRevert: TIWButton;
    btTransStart: TIWButton;
    btTransCommit: TIWButton;
    btTransRollback: TIWButton;
    DataSource: TDataSource;
    IWLabel4: TIWLabel;
    IWLabel6: TIWLabel;
    IWDBNavigator1: TIWDBNavigator;
    lbTransaction: TIWLabel;
    IWDBGrid1: TIWDBGrid;
    rgEdits: TIWRegion;
    rcEdits: TIWRectangle;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormRender(Sender: TObject);
    procedure cbModifiedClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btApplyClick(Sender: TObject);
    procedure btCommitClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
    procedure btRevertClick(Sender: TObject);
    procedure btTransStartClick(Sender: TObject);
    procedure btTransCommitClick(Sender: TObject);
    procedure btTransRollbackClick(Sender: TObject);
  protected
    procedure ReadFromControls; override;
    procedure DeleteCreatedControls;
  end;

implementation

{$R *.dfm}

uses
  ServerController, UData, IWForm;

procedure TfmCachedUpdates.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  Query.Connection := DM.Connection;
end;

procedure TfmCachedUpdates.ReadFromControls;
begin
  inherited;
  UserSession.UseCachedUpdates := cbCachedUpdates.Checked;
  UserSession.CachedSQL := meSQL.Lines.Text;

  UserSession.CachedRecordTypes := [];
  if cbUnmodified.Checked then
    Include(UserSession.CachedRecordTypes, rtUnmodified);
  if cbModified.Checked then
    Include(UserSession.CachedRecordTypes, rtModified);
  if cbInserted.Checked then
    Include(UserSession.CachedRecordTypes, rtInserted);
  if cbDeleted.Checked then
    Include(UserSession.CachedRecordTypes, rtDeleted);
end;

procedure TfmCachedUpdates.IWAppFormRender(Sender: TObject);
begin
  inherited;
  cbCachedUpdates.Checked := UserSession.UseCachedUpdates;
  cbUnmodified.Checked := rtUnmodified in UserSession.CachedRecordTypes;
  cbModified.Checked := rtModified in UserSession.CachedRecordTypes;
  cbInserted.Checked := rtInserted in UserSession.CachedRecordTypes;
  cbDeleted.Checked := rtDeleted in UserSession.CachedRecordTypes;
  meSQL.Lines.Text := UserSession.CachedSQL;

  if Query.CachedUpdates then
    Query.UpdateRecordTypes := UserSession.CachedRecordTypes;
  if Query.UpdatesPending then
    lbUpdates.Text := 'Updates Pending'
  else
    lbUpdates.Text := '';
  if Query.Connection.InTransaction then
    lbTransaction.Text := 'In Transaction'
  else
    lbTransaction.Text := '';

  lbResult.Font.Color := ResultColors[UserSession.IsGoodCached];
  lbResult.Caption := UserSession.CachedResult;

  IWDBGrid1.Visible := Query.Active;

end;

procedure TfmCachedUpdates.cbModifiedClick(Sender: TObject);
begin
  ReadFromControls;
end;

procedure TfmCachedUpdates.btOpenClick(Sender: TObject);
var
  i, ATop: integer;
begin
  ReadFromControls;
  UserSession.isGoodCached := False;
  DeleteCreatedControls;
  try
    IWDBGrid1.Columns.Clear;
    Query.SQL.Text := UserSession.CachedSQL;
    Query.CachedUpdates := UserSession.UseCachedUpdates;
    Query.Execute;
    UserSession.isGoodCached := True;
    UserSession.CachedResult := 'Query is openned';
    ATop := 8;
    if Query.FieldCount > 0 then begin
      for i := 0 to Query.FieldCount - 1 do begin
        with TIWLabel.Create(Self) do begin
          Parent := rgEdits;
          Caption := Query.Fields[i].FieldName;
          Left := 24;
          Top := ATop;
        end;
        with TIWDBEdit.Create(Self) do begin
          Parent := rgEdits;
          DataSource := Self.DataSource;
          DataField := Query.Fields[i].FieldName;
          Left := 240;
          Top := ATop;
          Width := 240;
        end;
        ATop := ATop + 24;
      end;
      rgEdits.Height := ATop + 4;
      rcEdits.Height := rgEdits.Height - 2;
      rgEdits.Visible := True;
    end;
  except
    on E:Exception do
      UserSession.CachedResult := 'Error: '+ E.Message;
  end;
end;

procedure TfmCachedUpdates.btCloseClick(Sender: TObject);
begin
  ReadFromControls;
  UserSession.isGoodCached := False;
  DeleteCreatedControls;
  try
    IWDBGrid1.Columns.Clear;
    Query.Close;
    UserSession.isGoodCached := True;
    UserSession.CachedResult := ''
  except
    on E:Exception do
      UserSession.CachedResult := 'Error: '+ E.Message;
  end;
end;

procedure TfmCachedUpdates.btApplyClick(Sender: TObject);
begin
  ReadFromControls;
  Query.ApplyUpdates;
end;

procedure TfmCachedUpdates.btCommitClick(Sender: TObject);
begin
  ReadFromControls;
  Query.CommitUpdates;
end;

procedure TfmCachedUpdates.btCancelClick(Sender: TObject);
begin
  ReadFromControls;
  Query.CancelUpdates;
end;

procedure TfmCachedUpdates.btRevertClick(Sender: TObject);
begin
  ReadFromControls;
  Query.RevertRecord;
end;

procedure TfmCachedUpdates.btTransStartClick(Sender: TObject);
begin
  ReadFromControls;
  Query.Connection.StartTransaction;
end;

procedure TfmCachedUpdates.btTransCommitClick(Sender: TObject);
begin
  ReadFromControls;
  Query.Connection.Commit;
end;

procedure TfmCachedUpdates.btTransRollbackClick(Sender: TObject);
begin
  ReadFromControls;
  Query.Connection.Rollback;
end;

procedure TfmCachedUpdates.DeleteCreatedControls;
var
  i: integer;
begin
  i := 0;
  while i < rgEdits.ControlCount do
    if not (rgEdits.Controls[i] is TIWRectangle) then
      rgEdits.Controls[i].Free
    else
      Inc(i);
  rgEdits.Visible := False;
end;

end.
