unit ContextMenuGrid;

interface

uses
  SysUtils,
  Classes,
  Windows,
  GridsEh,
  DBGridEh,
  ToughDBGrid,
  Menus,
  ToughDBGridColumns,
  DBGridHelper;

type
  TContextMenuGrid = class
   private
    FGrid : TDBGridEh;
    FSaveGridMask : Integer;
    FGridPopup : TPopupMenu;
    FGridColumns : TMenuItem;
    FGridCopy : TMenuItem;
   protected
    function GetSaveFlag() : Boolean;
    procedure OnBeforePopup(Sender : TObject);
    procedure GridColumnsClick(Sender : TObject);
    procedure OnPopupCopyGridClick(Sender: TObject);
   public
    constructor Create(Grid : TDBGridEh; SaveGridMask : Integer);
  end;

implementation

{ TContextMenuGrid }

constructor TContextMenuGrid.Create(Grid: TDBGridEh; SaveGridMask : Integer);
begin
  FGrid := Grid;
  FSaveGridMask := SaveGridMask;

  FGridPopup := TPopupMenu.Create(FGrid.Owner);
  FGridPopup.OnPopup := OnBeforePopup;
  FGrid.PopupMenu := FGridPopup;
  FGridColumns := TMenuItem.Create(FGridPopup);
  FGridColumns.Caption := 'Столбцы...';
  FGridColumns.OnClick := GridColumnsClick;
  FGridPopup.Items.Add(FGridColumns);

  FGridCopy := TMenuItem.Create(FGrid.PopupMenu);
  FGridCopy.Caption := 'Копировать';
  FGridCopy.OnClick := OnPopupCopyGridClick;
  FGrid.PopupMenu.Items.Add(FGridCopy);
end;

function TContextMenuGrid.GetSaveFlag: Boolean;
begin
  Result := (FGrid.Tag = -1) or ((FGrid.Tag and FSaveGridMask) > 0);
end;

procedure TContextMenuGrid.GridColumnsClick(Sender: TObject);
var
  FColumnsForm : TfrmColumns;
begin
  FColumnsForm := TfrmColumns.Create(FGrid.Owner);
  try
    FColumnsForm.OwnerDBGrid := TToughDBGrid(FGrid);
    FColumnsForm.ShowModal;
  finally
    FColumnsForm.Free;
  end;
end;

procedure TContextMenuGrid.OnBeforePopup(Sender: TObject);
begin
  FGridCopy.Enabled := GetSaveFlag();
end;

procedure TContextMenuGrid.OnPopupCopyGridClick(Sender: TObject);
var
  SaveGridFlag : Boolean;
begin
  SaveGridFlag := GetSaveFlag();
  if SaveGridFlag then
    TDBGridHelper.CopyGridToClipboard(FGrid);
end;

end.
