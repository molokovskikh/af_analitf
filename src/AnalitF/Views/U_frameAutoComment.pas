unit U_frameAutoComment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DModule, StdCtrls,
  DBGridEh;

type
  TframeAutoComment = class(TFrame)
    gbAutoComment: TGroupBox;
    eAutoComment: TEdit;
    procedure eAutoCommentChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure eAutoCommentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FDBGrid : TCustomDBGridEh;
    procedure ProcessResize;
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
begin
  eAutoComment.Top := 4 + ( gbAutoComment.Height - eAutoComment.Height) div 2;
end;

procedure TframeAutoComment.FrameResize(Sender: TObject);
begin
  ProcessResize();
end;

procedure TframeAutoComment.eAutoCommentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if Assigned(FDBGrid) and FDBGrid.CanFocus then
      try FDBGrid.SetFocus; except end;
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
  //Result.Visible := GetAddressController.AllowAllOrders;
  Result.FDBGrid := ADBGrid;
end;

end.
