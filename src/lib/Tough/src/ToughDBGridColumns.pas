unit ToughDBGridColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, XPMan, ExtCtrls, DBGrids, ToughDBGrid, DBGridEh;

type

TColWidth = class
	Width: integer;
end;

TfrmColumns = class(TForm)
    clbColumns: TCheckListBox;
    Label1: TLabel;
    Bevel1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    btnUp: TButton;
    BtnDown: TButton;
    btnShow: TButton;
    btnHide: TButton;
    Label2: TLabel;
    edWidth: TEdit;
    Label3: TLabel;
    procedure clbColumnsClick(Sender: TObject);
    procedure clbColumnsEnter(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edWidthExit(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
	FOwnerDBGrid: TToughDBGrid;

	function GetColumnByCaption( ACaption: string): TColumnEh;
	procedure ReadColumns;
  public
  published
	property OwnerDBGrid: TToughDBGrid read FOwnerDBGrid write FOwnerDbGrid;
  end;

var
  frmColumns: TfrmColumns;

implementation

{$R *.dfm}

function TfrmColumns.GetColumnByCaption( ACaption: string): TColumnEh;
var
	i: integer;
begin
	result := nil;
	if OwnerDBGrid.Columns.Count = 0 then exit;

	for i := 0 to OwnerDBGrid.Columns.Count - 1 do
		if ACaption = OwnerDBGrid.Columns.Items[ i].Title.Caption then
		begin
			result := OwnerDBGrid.Columns.Items[ i];
			break;
		end;
end;

procedure TfrmColumns.ReadColumns;
var
	i: integer;
	cw: TColWidth;
begin
	clbColumns.Clear;
	if OwnerDBGrid.Columns.Count = 0 then exit;
	for i := 0 to OwnerDBGrid.Columns.Count - 1 do
	begin
		cw := TColWidth.Create;
		cw.Width := OwnerDBGrid.Columns[ i].Width;
		clbColumns.Items.AddObject( OwnerDBGrid.Columns[ i].Title.Caption, cw);
		clbColumns.Checked[ i] := OwnerDBGrid.Columns[ i].Visible;
	end;
	clbColumns.SetFocus;
end;

procedure TfrmColumns.clbColumnsClick(Sender: TObject);
begin
	if clbColumns.ItemIndex = 0 then btnUp.Enabled := False
		else btnUp.Enabled := True;

	if clbColumns.ItemIndex = clbColumns.Items.Count - 1 then btnDown.Enabled := False
		else btnDown.Enabled := True;

	if clbColumns.ItemIndex = -1 then exit;

	if clbColumns.Checked[ clbColumns.ItemIndex] then btnShow.Enabled := False
		else btnShow.Enabled := True;

	if clbColumns.Checked[ clbColumns.ItemIndex] then btnHide.Enabled := True
		else btnHide.Enabled := False;

	edWidth.Text := IntToStr( TColWidth( clbColumns.Items.Objects[ clbColumns.ItemIndex]).Width);
end;

procedure TfrmColumns.clbColumnsEnter(Sender: TObject);
begin
	if ( clbColumns.ItemIndex = -1) and ( clbColumns.Items.Count > 0) then
		clbColumns.ItemIndex := 0;
	clbColumnsClick( Sender);
end;

procedure TfrmColumns.btnShowClick(Sender: TObject);
begin
	if clbColumns.ItemIndex = -1 then exit;
	clbColumns.Checked[ clbColumns.ItemIndex] := True;
	clbColumnsClick( Sender);
end;

procedure TfrmColumns.btnHideClick(Sender: TObject);
begin
	if clbColumns.ItemIndex = -1 then exit;
	clbColumns.Checked[ clbColumns.ItemIndex] := False;
	clbColumnsClick( Sender);
end;

procedure TfrmColumns.FormShow(Sender: TObject);
var
	P: TPoint;
begin
	if Owner is TControl then
	begin
		P.X := TControl( Owner).Left;
		P.Y := TControl( Owner).Top;
		P := TControl( Owner).ClientToScreen( P);
		Top := P.Y;
		Left := P.X;
		Top := P.Y + ( TControl( Owner).Height - Height) div 2;
		Left := P.X + ( TControl( Owner).Width - Width) div 2;
	end;
	ReadColumns;
end;

procedure TfrmColumns.edWidthExit(Sender: TObject);
var
	Dummy: integer;
begin
	if clbColumns.ItemIndex = -1 then exit;
	if TryStrToInt( edWidth.Text, Dummy) then
		TColWidth( clbColumns.Items.Objects[ clbColumns.ItemIndex]).Width := Dummy
	else
		edWidth.Text := IntToStr( TColWidth( clbColumns.Items.Objects[ clbColumns.ItemIndex]).Width);
end;

procedure TfrmColumns.btnUpClick(Sender: TObject);
begin
	clbColumns.Items.Exchange( clbColumns.ItemIndex, clbColumns.ItemIndex - 1);
	clbColumnsClick( Sender);
end;

procedure TfrmColumns.BtnDownClick(Sender: TObject);
begin
	clbColumns.Items.Exchange( clbColumns.ItemIndex, clbColumns.ItemIndex + 1);
	clbColumnsClick( Sender);
end;

procedure TfrmColumns.btnOKClick(Sender: TObject);
var
	i: integer;
begin
	edWidthExit( Sender);

	if clbColumns.Items.Count = 0 then exit;
	for i := 0 to clbColumns.Items.Count - 1 do
	begin
		GetColumnByCaption( clbColumns.Items[ i]).Width := TColWidth( clbColumns.Items.Objects[ i]).Width;
		GetColumnByCaption( clbColumns.Items[ i]).Visible := clbColumns.Checked[ i];
		GetColumnByCaption( clbColumns.Items[ i]).Index := i;
	end;
	ModalResult := mrOK;
end;

procedure TfrmColumns.btnCancelClick(Sender: TObject);
begin
	ModalResult := mrCancel;
end;

procedure TfrmColumns.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	case Key of
		VK_RETURN: btnOKClick( Sender);
		VK_ESCAPE: btnCancelClick( Sender);
	end;
end;

end.
