unit U_frameAutoComment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DModule, StdCtrls,
  MyAccess,
  DB,
  DBGridEh,
  GlobalParams;

type
  TframeAutoComment = class(TFrame)
    gbAutoComment: TGroupBox;
    eAutoComment: TEdit;
    cbClear: TCheckBox;
    procedure eAutoCommentChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure eAutoCommentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbClearClick(Sender: TObject);
  private
    { Private declarations }
    FDBGrid : TCustomDBGridEh;
    FDataSet : TDataSet;
    fOrdersComment : TField;
    FOldAfterScroll : TDataSetNotifyEvent;
    procedure ProcessResize;
    procedure ReadClearAutoComment;
    procedure SetFocusToGrid;
    procedure RefreshAutoCommentAfterScroll(DataSet : TDataSet);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      ALeft,
      AHeight : Integer;
      ADBGrid : TCustomDBGridEh) : TframeAutoComment;
  end;

implementation

{$R *.dfm}

procedure TframeAutoComment.eAutoCommentChange(Sender: TObject);
begin
   DM.AutoComment := eAutoComment.Text;
end;

procedure TframeAutoComment.ProcessResize;
var
  summmaryHeight : Integer;
begin
  summmaryHeight := eAutoComment.Height + 1 + cbClear.Height;
  eAutoComment.Top := 5 + ( gbAutoComment.Height - summmaryHeight) div 2;
  cbClear.Top := eAutoComment.Top + eAutoComment.Height + 1;
end;

procedure TframeAutoComment.FrameResize(Sender: TObject);
begin
  ProcessResize();
end;

procedure TframeAutoComment.eAutoCommentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SetFocusToGrid;
end;

constructor TframeAutoComment.Create(AOwner: TComponent);
begin
  inherited;

  gbAutoComment.ControlStyle := gbAutoComment.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

class function TframeAutoComment.AddFrame(Owner: TComponent;
  Parent: TWinControl; ALeft, AHeight: Integer;
  ADBGrid: TCustomDBGridEh): TframeAutoComment;
begin
  Result := TframeAutoComment.Create(Owner);
  Result.Name := '';
  Result.Parent := Parent;
  Result.Left := ALeft;
  Result.Height := AHeight - 2;
  Result.Top := 1;
  Result.eAutoComment.Text := DM.AutoComment;
  Result.FDBGrid := ADBGrid;
  Result.ReadClearAutoComment;
end;

procedure TframeAutoComment.cbClearClick(Sender: TObject);
var
  newValue : Boolean;
begin
  newValue := cbClear.Checked;
  if Assigned(FDataSet) and (FDataSet is TMyQuery) then
    TGlobalParamsHelper.SaveParam(TMyQuery(FDataSet).Connection, 'ClearAutoComment', newValue);
  SetFocusToGrid;
end;

procedure TframeAutoComment.ReadClearAutoComment;
begin
  if Assigned(FDBGrid.DataSource) and Assigned(FDBGrid.DataSource.DataSet) then begin
    FDataSet := FDBGrid.DataSource.DataSet;
    if (FDataSet is TMyQuery) then begin
      cbClear.OnClick := nil;
      try
        cbClear.Checked := TGlobalParamsHelper.GetParamDef(TMyQuery(FDataSet).Connection, 'ClearAutoComment', False)
      finally
        cbClear.OnClick := cbClearClick;
      end;
    end;

    fOrdersComment := FDataSet.FindField('OrdersComment');
    if Assigned(fOrdersComment) then begin
      FOldAfterScroll := FDataSet.AfterScroll;
      FDataSet.AfterScroll := RefreshAutoCommentAfterScroll;
    end;
  end;
end;

procedure TframeAutoComment.SetFocusToGrid;
begin
  if Assigned(FDBGrid) and FDBGrid.CanFocus then
    try FDBGrid.SetFocus; except end;
end;

procedure TframeAutoComment.RefreshAutoCommentAfterScroll(
  DataSet: TDataSet);
begin
  if Assigned(FOldAfterScroll) then
    FOldAfterScroll(DataSet);

  if cbClear.Checked then
    eAutoComment.Text := fOrdersComment.AsString;
end;

end.
