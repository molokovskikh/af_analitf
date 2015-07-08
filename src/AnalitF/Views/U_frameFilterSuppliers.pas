unit U_frameFilterSuppliers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  Menus,
  GridsEh,
  DbGridEh,
  ToughDBGrid,
  AProc,
  DBGridHelper,
  U_Supplier,
  SupplierController;

type
  TframeFilterSuppliers = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FVertical : Boolean;
    FCanvas : TCanvas;
    FOnChangeFilter : TThreadMethod;

    procedure CreateVisualComponent;
    procedure CreateMenu;
    procedure ProcessResize;

    procedure SuppliersClick(Sender: TObject);

    procedure ChangeSelected(ASelected: Boolean);
    procedure SelectedAllClick(Sender: TObject);
    procedure UnselectedAllClick(Sender: TObject);
    procedure ChangeSelectSupplierClick(Sender: TObject);

    procedure InternalCreate();
  public
    { Public declarations }
    pmSelectedSuppliers: TPopupMenu;

    gbSuppliers: TGroupBox;
    sbSuppliers : TSpeedButton;
    lFilter : TLabel;

    constructor Create(AOwner: TComponent); override;
    constructor CreateVertical(AOwner: TComponent; Vertical : Boolean);
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      ALeft,
      AHeight : Integer;
      AOnChangeFilter : TThreadMethod;
      AVertical : Boolean = False) : TframeFilterSuppliers;

    procedure PrepareFrame;
    procedure ProcessChangeFilter;
  end;

implementation

{$R *.dfm}

{ TframeFilterSuppliers }

class function TframeFilterSuppliers.AddFrame(Owner: TComponent;
  Parent: TWinControl; ALeft, AHeight: Integer; 
  AOnChangeFilter: TThreadMethod;
  AVertical : Boolean = False): TframeFilterSuppliers;
begin
  Result := TframeFilterSuppliers.CreateVertical(Owner, AVertical);
  Result.Name := '';
  Result.Parent := Parent;
  Result.Left := ALeft;
  Result.Height := AHeight - 2;
  Result.Top := 1;
  Result.FOnChangeFilter := AOnChangeFilter;
  Result.PrepareFrame;
end;

procedure TframeFilterSuppliers.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  for I := 3 to pmSelectedSuppliers.Items.Count-1 do begin
    pmSelectedSuppliers.Items.Items[i].Checked := ASelected;
    TSupplier(TMenuItem(pmSelectedSuppliers.Items.Items[i]).Tag).Selected := ASelected;
  end;
  ProcessChangeFilter;
  pmSelectedSuppliers.Popup(pmSelectedSuppliers.PopupPoint.X, pmSelectedSuppliers.PopupPoint.Y);
end;

procedure TframeFilterSuppliers.ChangeSelectSupplierClick(Sender: TObject);
var
  supplier : TSupplier;
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  supplier := TSupplier(TMenuItem(Sender).Tag);
  supplier.Selected := TMenuItem(Sender).Checked;
  ProcessChangeFilter;
  pmSelectedSuppliers.Popup(pmSelectedSuppliers.PopupPoint.X, pmSelectedSuppliers.PopupPoint.Y);
end;

constructor TframeFilterSuppliers.Create(AOwner: TComponent);
begin
  FVertical := False;
  inherited;

  InternalCreate();
end;

procedure TframeFilterSuppliers.CreateMenu;
var
  I : Integer;
  supplier : TSupplier;
  mi :TMenuItem;
begin
  pmSelectedSuppliers := TPopupMenu.Create(Self);

  mi := TMenuItem.Create(pmSelectedSuppliers);
  mi.Name := 'miSelectAll';
  mi.Caption := 'Выбрать всех';
  mi.OnClick := SelectedAllClick;
  pmSelectedSuppliers.Items.Add(mi);

  mi := TMenuItem.Create(pmSelectedSuppliers);
  mi.Name := 'miUnSelectAll';
  mi.Caption := 'Исключить всех';
  mi.OnClick := UnselectedAllClick;
  pmSelectedSuppliers.Items.Add(mi);

  mi := TMenuItem.Create(pmSelectedSuppliers);
  mi.Name := 'miSeparator';
  mi.Caption := '-';
  pmSelectedSuppliers.Items.Add(mi);

  for I := 0 to GetSupplierController.Suppliers.Count-1 do begin
    supplier := TSupplier(GetSupplierController.Suppliers[i]);
    mi := TMenuItem.Create(pmSelectedSuppliers);
    mi.Name := 'sl' + IntToStr(supplier.Id);
    mi.Caption := supplier.FullName;
    mi.Checked := supplier.Selected;
    mi.Tag := Integer(supplier);
    mi.OnClick := ChangeSelectSupplierClick;
    pmSelectedSuppliers.Items.Add(mi);
  end;  
end;

procedure TframeFilterSuppliers.CreateVisualComponent;
begin
  CreateMenu;

  gbSuppliers := TGroupBox.Create(Self);
  gbSuppliers.Parent := Self;
  gbSuppliers.Align := alClient;

  sbSuppliers := TSpeedButton.Create(Self);
  sbSuppliers.Parent := gbSuppliers;
  sbSuppliers.Caption := 'Поставщики';
  sbSuppliers.Height := 25;
  sbSuppliers.Left := 5;
  sbSuppliers.OnClick := SuppliersClick;
  try
    sbSuppliers.Glyph.LoadFromResourceName(HInstance, 'spindown');
    sbSuppliers.Layout := blGlyphRight;
    sbSuppliers.Width := FCanvas.TextWidth(sbSuppliers.Caption) + sbSuppliers.Glyph.Width + 20;
  except
    sbSuppliers.Width := FCanvas.TextWidth(sbSuppliers.Caption) + 20;
  end;

  lFilter := TLabel.Create(Self);
  lFilter.Parent := gbSuppliers;
  lFilter.Caption := '(Фильтр применен)';
  if FVertical then
    lFilter.Left := sbSuppliers.Left
  else
    lFilter.Left := sbSuppliers.Left + sbSuppliers.Width + 5;
end;

procedure TframeFilterSuppliers.PrepareFrame;
begin
  ProcessChangeFilter;
  Self.Width := lFilter.Left + lFilter.Width + 10;
end;

procedure TframeFilterSuppliers.ProcessChangeFilter;
begin
  lFilter.Visible := GetSupplierController.IsFilter;
  if Assigned(FOnChangeFilter) then
    FOnChangeFilter();
end;

procedure TframeFilterSuppliers.ProcessResize;
var
  allHeight : Integer;
  sbTop : Integer;
begin
  if Assigned(lFilter) then begin
    Self.Width := lFilter.Left + lFilter.Width + 10;
    if FVertical then begin
      allHeight := sbSuppliers.Height + lFilter.Height + 3;
      if (gbSuppliers.Height - allHeight > 1) then
        sbTop := ( gbSuppliers.Height - allHeight) div 2
      else
        sbTop := 2;
      sbSuppliers.Top := sbTop;
      lFilter.Top := sbSuppliers.Top + sbSuppliers.Height + 3;
    end
    else begin
      sbSuppliers.Top := ( gbSuppliers.Height - sbSuppliers.Height) div 2;
      lFilter.Top := ( gbSuppliers.Height - lFilter.Height) div 2;
    end;
  end;
end;

procedure TframeFilterSuppliers.SelectedAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TframeFilterSuppliers.SuppliersClick(Sender: TObject);
begin
  pmSelectedSuppliers.Popup(sbSuppliers.ClientOrigin.X, sbSuppliers.ClientOrigin.Y + sbSuppliers.Height);
end;

procedure TframeFilterSuppliers.UnselectedAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TframeFilterSuppliers.FrameResize(Sender: TObject);
begin
  ProcessResize;
end;

constructor TframeFilterSuppliers.CreateVertical(AOwner: TComponent;
  Vertical: Boolean);
begin
  FVertical := Vertical;
  inherited Create(AOwner);
  InternalCreate();
end;

procedure TframeFilterSuppliers.InternalCreate;
begin
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  CreateVisualComponent;

  gbSuppliers.ControlStyle := gbSuppliers.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

end.
