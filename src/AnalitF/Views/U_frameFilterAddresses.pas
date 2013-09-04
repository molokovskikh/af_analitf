unit U_frameFilterAddresses;

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
  U_Address,
  AddressController;

const
  filterText = '(Фильтр применен)';

type
  TframeFilterAddresses = class(TFrame)
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FCanvas : TCanvas;
    FOnChangeCheckBox : TThreadMethod;
    FOnChangeFilter : TThreadMethod;
    FDBGrid : TToughDBGrid;
    FAddressName : TColumnEh;
    FOldCellParams : TGetCellEhParamsEvent;
    procedure CreateVisualComponent;
    procedure CreateMenu;
    procedure ProcessResize;

    procedure AllOrdersClick(Sender : TObject);
    procedure AddressesClick(Sender: TObject);

    procedure ChangeSelected(ASelected: Boolean);
    procedure SelectedAllClick(Sender: TObject);
    procedure UnselectedAllClick(Sender: TObject);
    procedure CnageSelectAddressClick(Sender: TObject);

    procedure DBGridGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);

    procedure UpdateFilterLabel;
  public
    { Public declarations }
    pmSelectedAddresses: TPopupMenu;

    gbAddresses: TGroupBox;
    cbAllOrders : TCheckBox;
    sbAddresses : TSpeedButton;
    lFilter : TLabel;

    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      ALeft,
      AHeight : Integer;
      ADBGrid : TToughDBGrid;
      AOnChangeCheckBox : TThreadMethod;
      AOnChangeFilter : TThreadMethod) : TframeFilterAddresses;

    procedure PrepareFrame;
    procedure ProcessChangeFilter;
    procedure ProcessChangeCheckBox;
    //Обновление визуальной части фрейма
    procedure UpdateLayout();
    procedure UpdateFrame();
  end;

implementation

{$R *.dfm}

{ TframeFilterAddresses }

class function TframeFilterAddresses.AddFrame(Owner: TComponent;
  Parent: TWinControl;
  ALeft,
  AHeight : Integer;
  ADBGrid : TToughDBGrid;
  AOnChangeCheckBox : TThreadMethod;
  AOnChangeFilter : TThreadMethod): TframeFilterAddresses;
begin
  Result := TframeFilterAddresses.Create(Owner);
  Result.Name := '';
  Result.Parent := Parent;
  Result.Left := ALeft;
  Result.Height := AHeight - 2;
  Result.Top := 1;
  //Result.Visible := GetAddressController.AllowAllOrders;
  Result.FOnChangeCheckBox := AOnChangeCheckBox;
  Result.FOnChangeFilter := AOnChangeFilter;
  Result.FDBGrid := ADBGrid;
  Result.PrepareFrame;
end;

constructor TframeFilterAddresses.Create(AOwner: TComponent);
begin
  inherited;
  FAddressName := nil; 
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  CreateVisualComponent;

  //Если у TGroupBox, на котором лежит lFilterLabel будет выставленно свойство ControlStyle,
  //то lFilterLabel перестанет скрываться по Visible := False
  //возможно, одно из решений здесь: http://qc.embarcadero.com/wc/qcmain.aspx?d=3850
  //gbAddresses.ControlStyle := gbAddresses.ControlStyle - [csParentBackground] + [csOpaque];

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeFilterAddresses.CreateVisualComponent;
begin
  CreateMenu;
  
  gbAddresses := TGroupBox.Create(Self);
  gbAddresses.Parent := Self;
  gbAddresses.Align := alClient;

  cbAllOrders := TCheckBox.Create(Self);
  cbAllOrders.Parent := gbAddresses;
  cbAllOrders.Caption := 'Все заказы';
  cbAllOrders.Checked := GetAddressController.ShowAllOrders;
  cbAllOrders.Left := 5;
  cbAllOrders.Width := Self.FCanvas.TextWidth(cbAllOrders.Caption) + 30;
  cbAllOrders.OnClick := AllOrdersClick;

  sbAddresses := TSpeedButton.Create(Self);
  sbAddresses.Parent := gbAddresses;
  sbAddresses.Caption := 'Адреса';
  sbAddresses.Height := 25;
  sbAddresses.Width := FCanvas.TextWidth(sbAddresses.Caption) + 20;
  sbAddresses.Left := cbAllOrders.Left + cbAllOrders.Width + 5;
  sbAddresses.OnClick := AddressesClick;

  lFilter := TLabel.Create(Self);
  lFilter.Parent := gbAddresses;
  lFilter.Caption := filterText;
  lFilter.Left := sbAddresses.Left + sbAddresses.Width + 5;
end;

procedure TframeFilterAddresses.ProcessResize;
begin
  if Assigned(lFilter) then begin
    Self.Width := lFilter.Left + lFilter.Canvas.TextWidth(filterText) + 10;
    cbAllOrders.Top := ( gbAddresses.Height - cbAllOrders.Height) div 2;
    sbAddresses.Top := ( gbAddresses.Height - sbAddresses.Height) div 2;
    lFilter.Top := ( gbAddresses.Height - lFilter.Height) div 2;
  end;
end;

procedure TframeFilterAddresses.FrameResize(Sender: TObject);
begin
  ProcessResize;
end;

procedure TframeFilterAddresses.ProcessChangeCheckBox;
begin
  UpdateLayout();
  ProcessChangeFilter;
  if Assigned(FOnChangeCheckBox) then
    FOnChangeCheckBox();
end;

procedure TframeFilterAddresses.ProcessChangeFilter;
begin
  UpdateFilterLabel();
  if Assigned(FOnChangeFilter) then
    FOnChangeFilter();
end;

procedure TframeFilterAddresses.PrepareFrame;
begin
  if Assigned(FDBGrid) then begin
    FOldCellParams := FDBGrid.OnGetCellParams;
    FDBGrid.OnGetCellParams := DBGridGetCellParams;
  end;
  ProcessChangeCheckBox;
  Self.Width := lFilter.Left + lFilter.Canvas.TextWidth(filterText) + 10;
end;

procedure TframeFilterAddresses.AllOrdersClick(Sender: TObject);
begin
  GetAddressController.ShowAllOrders := cbAllOrders.Checked;
  if Assigned(FDBGrid) and FDBGrid.CanFocus then
    try FDBGrid.SetFocus; except end;
  ProcessChangeCheckBox;
end;

procedure TframeFilterAddresses.AddressesClick(Sender: TObject);
begin
  pmSelectedAddresses.Popup(sbAddresses.ClientOrigin.X, sbAddresses.ClientOrigin.Y + sbAddresses.Height);
end;

procedure TframeFilterAddresses.CreateMenu;
var
  I : Integer;
  address : TAddress;
  mi :TMenuItem;
begin
  pmSelectedAddresses := TPopupMenu.Create(Self);

  mi := TMenuItem.Create(pmSelectedAddresses);
  mi.Name := 'miSelectAll';
  mi.Caption := 'Выбрать всех';
  mi.OnClick := SelectedAllClick;
  pmSelectedAddresses.Items.Add(mi);

  mi := TMenuItem.Create(pmSelectedAddresses);
  mi.Name := 'miUnSelectAll';
  mi.Caption := 'Исключить всех';
  mi.OnClick := UnselectedAllClick;
  pmSelectedAddresses.Items.Add(mi);

  mi := TMenuItem.Create(pmSelectedAddresses);
  mi.Name := 'miSeparator';
  mi.Caption := '-';
  pmSelectedAddresses.Items.Add(mi);

  for I := 0 to GetAddressController.Addresses.Count-1 do begin
    address := TAddress(GetAddressController.Addresses[i]);
    mi := TMenuItem.Create(pmSelectedAddresses);
    mi.Name := 'sl' + IntToStr(address.Id);
    mi.Caption := address.Name;
    mi.Checked := address.Selected;
    mi.Tag := Integer(address);
    mi.OnClick := CnageSelectAddressClick;
    pmSelectedAddresses.Items.Add(mi);
  end;  
end;

procedure TframeFilterAddresses.ChangeSelected(ASelected: Boolean);
var
  I : Integer;
begin
  for I := 3 to pmSelectedAddresses.Items.Count-1 do begin
    pmSelectedAddresses.Items.Items[i].Checked := ASelected;
    TAddress(TMenuItem(pmSelectedAddresses.Items.Items[i]).Tag).Selected := ASelected;
  end;
  ProcessChangeFilter;
  pmSelectedAddresses.Popup(pmSelectedAddresses.PopupPoint.X, pmSelectedAddresses.PopupPoint.Y);
end;

procedure TframeFilterAddresses.SelectedAllClick(Sender: TObject);
begin
  ChangeSelected(True);
end;

procedure TframeFilterAddresses.UnselectedAllClick(Sender: TObject);
begin
  ChangeSelected(False);
end;

procedure TframeFilterAddresses.CnageSelectAddressClick(Sender: TObject);
var
  address : TAddress;
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  address := TAddress(TMenuItem(Sender).Tag);
  address.Selected := TMenuItem(Sender).Checked;
  ProcessChangeFilter;
  pmSelectedAddresses.Popup(pmSelectedAddresses.PopupPoint.X, pmSelectedAddresses.PopupPoint.Y);
end;

procedure TframeFilterAddresses.DBGridGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if Assigned(FAddressName) and (FAddressName = Column) then begin
    if GetAddressController.IsCurrent(FAddressName.DisplayText) then
      AFont.Style := AFont.Style + [fsBold];
  end;

  if Assigned(FOldCellParams) then
    FOldCellParams(Sender, Column, AFont, Background, State);
end;

procedure TframeFilterAddresses.UpdateFrame;
var
  I : Integer;
  menuItem : TMenuItem;
  address : TAddress;
begin
  cbAllOrders.Checked := GetAddressController.ShowAllOrders;
  for I := 0 to pmSelectedAddresses.Items.Count-1 do begin
    menuItem := pmSelectedAddresses.Items[i];
    if Assigned(TAddress(menuItem.Tag)) then begin
      address := TAddress(menuItem.Tag);
      menuItem.Checked := address.Selected;
    end;
  end;
  UpdateLayout();
end;

procedure TframeFilterAddresses.UpdateLayout;
begin
  if Assigned(FDBGrid) then begin
    if GetAddressController.ShowAllOrders then begin
      FAddressName := ColumnByNameT(FDBGrid, 'AddressName');
      if not Assigned(FAddressName) then begin
        FAddressName := TColumnEh(FDBGrid.Columns.Insert(0));
        FAddressName.FieldName := 'AddressName';
        FAddressName.Title.Caption := 'Адрес заказа';
        FAddressName.Visible := True;
        FAddressName.Width := FDBGrid.Canvas.TextWidth(FAddressName.Title.Caption);
        FAddressName.Title.TitleButton := True;
      end;
    end
    else begin
      if Assigned(FAddressName) then begin
        FDBGrid.Columns.Delete(FAddressName.Index);
        FAddressName := nil;
      end;
    end;
  end;
  sbAddresses.Enabled := GetAddressController.ShowAllOrders;
  UpdateFilterLabel();
end;

procedure TframeFilterAddresses.UpdateFilterLabel;
begin
  lFilter.Visible := cbAllOrders.Checked and GetAddressController.IsFilter;
end;

end.
