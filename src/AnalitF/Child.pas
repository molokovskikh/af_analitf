unit Child;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, SHDocVw, ToughDBGrid, ExtCtrls, DB, DBProc, DBGrids, Contnrs,
  MyAccess, DBAccess, StdCtrls, DescriptionFrm, Buttons,
  DayOfWeekHelper,
  Menus;

type
  {Класс для корректировки WindowProc всех ToughDBGrid на дочерней форме,
   чтобы у каждого грида была своя собственная новая WindowProc.
   Если этого не сделать, то будет возникать ошибка "A call to an OS function failed"
   Решение приведено на странице: http://www.delphikingdom.com/asp/answer.asp?IDAnswer=34018
   Проблема связана с тем, что не происходит восстановление фокуса у DB-компонент после того,
   как пользователь кликает по WebBrowser'у, который установлен на той же форме что и DB-компонент.
  }
  TDBComponentWindowProc = class
   private
    FFormHandle : THandle;
    FOldDBGridWndProc: TWndMethod;
    FGrid : TToughDBGrid;
    FGridCopy : TMenuItem;
    FOldOnBeforePopup : TNotifyEvent;
    procedure HackDBGirdWndProc(var Message: TMessage);
    procedure OnPopupCopyGridClick(Sender: TObject);
    procedure OnBeforePopup(Sender : TObject);
    function GetSaveFlag() : Boolean;
   public
    constructor Create(AFormHandle : THandle; AOldDBGridWndProc: TWndMethod; Grid : TToughDBGrid);
  end;

  TModifiedAction = class
   private
    FOwner : TForm;
    FAction : TCustomAction;
    FOldUpdate : TNotifyEvent;
    procedure ModifedUpdate(Sender: TObject);
   public
    constructor Create(Action : TCustomAction; Owner : TForm);
  end;

  TChildForm = class(TForm)
    tCheckVolume: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tCheckVolumeTimer(Sender: TObject);
  private
    procedure AddActionList(ActionList: TCustomActionList);
    procedure RemoveActionList(ActionList: TCustomActionList);
    function  GetActionLists : TList;
    procedure SetActionLists(AValue : TList);
  protected
    PrevForm: TChildForm;
    dsCheckVolume : TDataSet;
    dgCheckVolume : TToughDBGrid;
    OldOrderValue : Variant;
    fOrder        : TField;
    fVolume       : TField;
    fOrderCost    : TField;
    fSumOrder     : TField;
    fMinOrderCount : TField;
    fBuyingMatrixType : TIntegerField;
    OldAfterPost : TDataSetNotifyEvent;
    OldBeforePost : TDataSetNotifyEvent;
    OldBeforeScroll : TDataSetNotifyEvent;
    OldExit : TNotifyEvent;
    OldAfterScroll : TDataSetNotifyEvent;
    OldAfterOpen : TDataSetNotifyEvent;

    DBComponentWindowProcs : TObjectList;
    ModifiedActions        : TObjectList;

    FUseCorrectOrders : Boolean;
    FAllowDelayOfPayment : Boolean;
    FShowSupplierCost : Boolean;

    gotoMNNAction : TAction;
    gotoMNNButton : TSpeedButton;

    ShowDescriptionAction : TAction;
    ShowDescriptionActionByF1 : TAction;


    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure DoShow; override;
    procedure UpdateReclame;
    procedure PatchNonBrowser;
    //Корректируем connection для MySQL-компонент
    procedure PatchMyDataSets;
    //Проверяем, что заказ сделан кратно Volume
    function  CheckVolume : Boolean;
    //Проверяем, что заказ сделан >= OrderCost
    function  CheckByOrderCost : Boolean;
    //Проверяем, что заказанное кол-во >= MinOrderCount
    function  CheckByMinOrderCount : Boolean;
    //Проверяем, что позиция не запрещена к заказу
    function  CheckByBuyingMatrixType : Boolean;
    //очищаем созданный заказ
    procedure ClearOrder;
    //очищаем созданный заказ
    procedure ClearOrderByOrderCost;
    procedure ShowVolumeMessage;
    procedure NewAfterPost(DataSet : TDataSet);
    procedure NewBeforePost(DataSet: TDataSet);
    procedure NewBeforeScroll(DataSet : TDataSet);
    procedure NewExit(Sender : TObject);
    procedure NewAfterScroll(DataSet : TDataSet);
    procedure NewAfterOpen(DataSet : TDataSet);
    procedure FilterByMNNExecute(Sender: TObject);
    procedure FilterByMNNUpdate(Sender: TObject);
    procedure ShowDescriptionExecute(Sender: TObject);
    procedure ShowDescriptionUpdate(Sender: TObject);
    procedure PrepareColumnsInOrderGrid(Grid : TToughDBGrid);
    procedure SetPrevForm;
    procedure HideAllForms;
    procedure SetActiveChildToMainForm;
    procedure UpdateOrderDataset; virtual;
    procedure ModifyActionList(ActionList: TCustomActionList);
  public
    PrintEnabled: Boolean;
    //Разрешено сохранять отображаемую таблицу
    SaveEnabled: Boolean;
    //Требуется вызвать First после сортировки DataSet
    NeedFirstOnDataSet : Boolean;
    //Сортировать грид с заказом
    SortOnOrderGrid : Boolean;
    procedure ShowForm; overload; virtual;
    procedure ShowAsPrevForm; virtual;
    procedure Print( APreview: boolean = False); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //Вытаскивае FActionList у класса TForm
    property ActionLists: TList read GetActionLists write SetActionLists;
    procedure BeforeUpdateExecuteForClientID(
      Sender: TCustomMyDataSet;
      StatementTypes: TStatementTypes;
      Params: TDAParams);
  end;

  TChildFormClass=class of TChildForm;

implementation

uses Main, AProc, DBGridEh, Constant, DModule, MyEmbConnection, Core,
  NamesForms,
  DBGridHelper, Variants;

{$R *.DFM}

procedure TChildForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //форма будет дочерней
  Params.Style:=Params.Style or WS_CHILD;
  // This only works on Windows XP and above
  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
end;

procedure TChildForm.Loaded;
begin
  inherited Loaded;
  //родителем будет главная форма
  Parent:=Application.MainForm;
  UpdateReclame;
end;

//для того, чтобы TAction, созданные на дочерней форме работали, надо вставить
//их на главную форму
procedure TChildForm.AddActionList(ActionList: TCustomActionList);
var
  Form: TCustomForm;
begin
  Form:=GetParentForm(Self);
  if (Form<>nil)and(Form is TMainForm) then
  begin
    if TMainForm(Form).ActionLists=nil then TMainForm(Form).ActionLists:=TList.Create;
    TMainForm(Form).ActionLists.Add(ActionList);
  end;
end;

//при закрытии дочерней формы надо удалить из главной ее TAction
procedure TChildForm.RemoveActionList(ActionList: TCustomActionList);
var
  Form: TCustomForm;
begin
  Form:=GetParentForm(Self);
  if (Form<>nil)and(Form is TMainForm)and(TMainForm(Form).ActionLists<>nil) then
    TMainForm(Form).ActionLists.Remove(ActionList);
end;

procedure TChildForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  case Operation of
    opInsert:
      if AComponent is TCustomActionList then
        AddActionList(TCustomActionList(AComponent));
    opRemove:
      if AComponent is TCustomActionList then
        RemoveActionList(TCustomActionList(AComponent));
  end;
end;

procedure TChildForm.SetParent(AParent: TWinControl);
  procedure UpdateActionLists(Operation: TOperation);
  var
    I: Integer;
    Component: TComponent;
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      Component := Components[I];
      if Component is TCustomActionList then
        case Operation of
          opInsert: AddActionList(TCustomActionList(Component));
          opRemove: RemoveActionList(TCustomActionList(Component));
        end;
    end;
  end;
begin
  if Parent<>nil then UpdateActionLists(opRemove);
  inherited;
  if Parent <> nil then UpdateActionLists(opInsert);
end;

procedure TChildForm.ShowForm;
var
  I: Integer;
begin
  SetActiveChildToMainForm;
  for I := 0 to Self.ComponentCount-1 do
    if (Self.Components[i] is TToughDBGrid)
    then begin
      TDBGridHelper.SetMinWidthToColumns(TToughDBGrid(Self.Components[i]));
      TToughDBGrid(Self.Components[i]).AllowedSelections := [gstRecordBookmarks, gstRectangle];;
      TToughDBGrid(Self.Components[i]).Options := TToughDBGrid(Self.Components[i]).Options + [dgRowLines];
      TToughDBGrid(Self.Components[i]).Font.Size := 10;
      TToughDBGrid(Self.Components[i]).GridLineColors.DarkColor := clBlack;
      TToughDBGrid(Self.Components[i]).GridLineColors.BrightColor := clDkGray;
      if CheckWin32Version(5, 1) then
        TToughDBGrid(Self.Components[i]).OptionsEh := TToughDBGrid(Self.Components[i]).OptionsEh + [dghTraceColSizing];

      if Assigned(TToughDBGrid(Self.Components[i]).OnSortMarkingChanged )
         and Assigned(TToughDBGrid(Self.Components[i]).DataSource)
         and Assigned(TToughDBGrid(Self.Components[i]).DataSource.DataSet)
         and TToughDBGrid(Self.Components[i]).DataSource.DataSet.Active
      then begin
        TToughDBGrid(Self.Components[i]).OnSortMarkingChanged( Self.Components[i] );

        if NeedFirstOnDataSet then
          TToughDBGrid(Self.Components[i]).DataSource.DataSet.First;
      end;

    end;
  Show;
  SetPrevForm;
end;

procedure TChildForm.DoShow;
begin
  inherited;
  FocusControl(ActiveControl);
end;

procedure TChildForm.Print( APreview: boolean = False);
begin
end;

procedure TChildForm.UpdateReclame;
var
  i: integer;
  openFileName : String;
begin
  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[ i] is TWebBrowser then
    begin
      try
        if DM.adsUser.FieldByName('ShowAdvertising').IsNull or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean
        then begin
          openFileName := RootFolder() + SDirReclame + '\' + FormatFloat('00', Self.Components[ i].Tag) + '.htm';
          if SysUtils.FileExists(openFileName)
          then
            TWebBrowser(Self.Components[i]).Navigate(openFileName);
        end
        else
          TWebBrowser( Self.Components[i] ).Navigate('about:blank');
      except
        on E : Exception do
          LogCriticalError(
            'Ошибка при открытии файла в WebBrowserе: ' + E.Message + #13#10 +
            'Системная ошибка: ' + SysErrorMessage(GetLastError()));
      end;
    end;
end;

procedure TChildForm.PatchNonBrowser;
var
  i: integer;
  hack : TDBComponentWindowProc;
begin
  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[ i].ClassNameIs( 'TToughDBGrid') then
    begin
      hack := TDBComponentWindowProc.Create(
        Self.Handle,
        TToughDBGrid( Self.Components[ i]).WindowProc,
        TToughDBGrid( Self.Components[ i]));
      DBComponentWindowProcs.Add(hack);
      TToughDBGrid( Self.Components[ i]).WindowProc := hack.HackDBGirdWndProc;
    end;
end;

procedure TChildForm.SetActionLists(AValue: TList);
begin
  if AValue <> FActionLists then
    FActionLists := AValue;
end;

function TChildForm.GetActionLists: TList;
begin
  Result := FActionLists;
end;

constructor TChildForm.Create(AOwner: TComponent);
begin
  NeedFirstOnDataSet := True;
  SortOnOrderGrid := True;
  FUseCorrectOrders := DM.adsUser.FieldByName('UseCorrectOrders').AsBoolean;
  FAllowDelayOfPayment := DM.adsUser.FieldByName('AllowDelayOfPayment').AsBoolean;
  FShowSupplierCost := DM.adsUser.FieldByName('ShowSupplierCost').AsBoolean;

  ModifiedActions        := TObjectList.Create(True);
  inherited;
  DBComponentWindowProcs := TObjectList.Create(True);
  PatchNonBrowser;
end;

function TChildForm.CheckVolume: Boolean;
begin
  if not fVolume.IsNull and (fVolume.AsInteger > 0 ) then
    Result := (fOrder.AsInteger mod fVolume.AsInteger = 0)
  else
    Result := True;
end;

procedure TChildForm.ClearOrder;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := fOrder.AsInteger - (fOrder.AsInteger mod fVolume.AsInteger);
  dsCheckVolume.Post;
end;

procedure TChildForm.ShowVolumeMessage;
begin
  tCheckVolume.Enabled := False;

  //Проверка на максимальную сумму заказа, выставляемую сервером
  if fOrder.AsInteger > MaxOrderCount then begin
    SoftEdit(dsCheckVolume);
    fOrder.AsInteger := MaxOrderCount;
    dsCheckVolume.Post;
  end;

  if (dsCheckVolume.RecordCount > 0) and not CheckVolume then begin
    AProc.MessageBox(
      Format(
        'Поставщиком определена кратность по заказываемой позиции.'#13#10 +
        'Введенное значение "%s" не кратно установленному значению "%s".',
        [fOrder.AsString, fVolume.AsString]),
      MB_ICONWARNING);
    ClearOrder;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByOrderCost then begin
    AProc.MessageBox(
      Format(
        'Сумма заказа "%s" меньше минимальной сумме заказа "%s" по данной позиции!',
        [fSumOrder.AsString, fOrderCost.AsString]),
      MB_ICONWARNING);
    ClearOrderByOrderCost;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByMinOrderCount then begin
    AProc.MessageBox(
      Format(
        'Заказанное количество "%s" меньше минимального количества "%s" по данной позиции!',
        [fOrder.AsString, fMinOrderCount.AsString]),
      MB_ICONWARNING);
    ClearOrderByOrderCost;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByBuyingMatrixType then begin
    if AProc.MessageBox(
        'Препарат не входит в разрешенную матрицу закупок.'#13#10 +
        'Вы действительно хотите заказать его?',
         MB_ICONWARNING or MB_OKCANCEL) = ID_CANCEL
    then begin
      ClearOrderByOrderCost;
      Abort;
    end;
  end;

  if Assigned(fBuyingMatrixType) then
    OldOrderValue := fOrder.Value;
end;

procedure TChildForm.tCheckVolumeTimer(Sender: TObject);
begin
  ShowVolumeMessage;
end;

procedure TChildForm.FormCreate(Sender: TObject);
var
  I : Integer;
  al : TActionList;
begin
  gotoMNNAction := nil;
  ShowDescriptionAction := nil;
  ShowDescriptionActionByF1 := nil;
  PatchMyDataSets;
  if Assigned(dsCheckVolume) and Assigned(dgCheckVolume) and Assigned(fOrder)
     and Assigned(fVolume) and Assigned(fOrderCost) and Assigned(fSumOrder) and Assigned(fMinOrderCount)
  then begin
    OldAfterPost := dsCheckVolume.AfterPost;
    dsCheckVolume.AfterPost := NewAfterPost;
    OldBeforeScroll := dsCheckVolume.BeforeScroll;
    dsCheckVolume.BeforeScroll := NewBeforeScroll;
    OldBeforePost := dsCheckVolume.BeforePost;
    dsCheckVolume.BeforePost := NewBeforePost;
    OldExit := dgCheckVolume.OnExit;
    dgCheckVolume.OnExit := NewExit;
    if Assigned(fBuyingMatrixType) then begin
      OldAfterOpen := dsCheckVolume.AfterOpen;
      dsCheckVolume.AfterOpen := NewAfterOpen;
      OldAfterScroll := dsCheckVolume.AfterScroll;
      dsCheckVolume.AfterScroll := NewAfterScroll;
    end;
    PrepareColumnsInOrderGrid(dgCheckVolume);
    if not (Self is TCoreForm) then
    for I := 0 to Self.ComponentCount-1 do
      if Self.Components[i] is TActionList then begin
        al := TActionList(Self.Components[i]);
        gotoMNNAction := TAction.Create(al);
        gotoMNNAction.Name := '';
        gotoMNNAction.Caption := 'Показать синонимы (Ctrl+N)';
        gotoMNNAction.Hint := 'Переход в каталог с фильтрацией по МНН';
        gotoMNNAction.ShortCut := TextToShortCut('Ctrl+N');// ShortCut(VK_F5, []);
        gotoMNNAction.OnExecute := FilterByMNNExecute;
        gotoMNNAction.OnUpdate  := FilterByMNNUpdate;
        gotoMNNAction.ActionList := al;
        if Assigned(gotoMNNButton) then begin
          gotoMNNButton.Action := gotoMNNAction;
          gotoMNNButton.Width := Self.Canvas.TextWidth(gotoMNNAction.Caption) + 30;
        end
      end;
  end;

  for I := 0 to Self.ComponentCount-1 do
    if Self.Components[i] is TActionList then begin
      al := TActionList(Self.Components[i]);

      ModifyActionList(al);

      ShowDescriptionAction := TAction.Create(al);
      ShowDescriptionAction.Name := '';
      ShowDescriptionAction.Caption := 'Показать описание (Space)';
      ShowDescriptionAction.ShortCut := TextToShortCut('Space');
      ShowDescriptionAction.OnUpdate := ShowDescriptionUpdate;
      ShowDescriptionAction.OnExecute := ShowDescriptionExecute;
      ShowDescriptionAction.ActionList := al;

      ShowDescriptionActionByF1 := TAction.Create(al);
      ShowDescriptionActionByF1.Name := '';
      ShowDescriptionActionByF1.Caption := 'Показать описание (F1)';
      ShowDescriptionActionByF1.ShortCut := TextToShortCut('F1');
      ShowDescriptionActionByF1.OnUpdate := ShowDescriptionUpdate;
      ShowDescriptionActionByF1.OnExecute := ShowDescriptionExecute;
      ShowDescriptionActionByF1.ActionList := al;
    end;
end;

procedure TChildForm.NewAfterPost(DataSet: TDataSet);
begin
  tCheckVolume.Enabled := False;
  tCheckVolume.Enabled := True;
  if Assigned(OldAfterPost) then
    OldAfterPost(DataSet);
end;

procedure TChildForm.NewBeforeScroll(DataSet: TDataSet);
begin
  ShowVolumeMessage;
  if Assigned(OldBeforeScroll) then
    OldBeforeScroll(DataSet);
end;

procedure TChildForm.NewExit(Sender: TObject);
begin
  ShowVolumeMessage;
  if Assigned(OldExit) then
    OldExit(Sender);
end;

procedure TChildForm.NewBeforePost(DataSet: TDataSet);
begin
  tCheckVolume.Enabled := False;
  if Assigned(OldBeforePost) then
    OldBeforePost(DataSet);
  //Это хак: чтобы метод не отрабатывал на adsCore из формы TOrdersForm  
  if Assigned(DataSet.FindField('ORDERSORDERID')) then
    DM.InsertOrderHeader(TCustomMyDataSet(DataSet));
end;

function TChildForm.CheckByOrderCost: Boolean;
begin
  if (not fOrderCost.IsNull) and (fOrderCost.AsCurrency > 0 ) and (not fSumOrder.IsNull)
     and (fSumOrder.AsCurrency > 0)
  then
    Result := (fSumOrder.AsCurrency >= fOrderCost.AsCurrency)
  else
    Result := True;
end;

procedure TChildForm.ClearOrderByOrderCost;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := 0;
  dsCheckVolume.Post;
end;

function TChildForm.CheckByMinOrderCount: Boolean;
begin
  if (not fMinOrderCount.IsNull) and (fMinOrderCount.AsInteger > 0 ) and (not fOrder.IsNull)
     and (fOrder.AsInteger > 0)
  then
    Result := (fOrder.AsInteger >= fMinOrderCount.AsInteger)
  else
    Result := True;
end;

destructor TChildForm.Destroy;
var
  I : Integer;
begin
  if Parent <> nil then
    for I := 0 to Parent.ControlCount-1 do
      if (Parent.Controls[I] is TChildForm) and (Parent.Controls[I] <> Self) then
        if Parent.Controls[I].Visible and (TChildForm(Parent.Controls[I]).PrevForm = Self) then
          TChildForm(Parent.Controls[I]).PrevForm := nil;
  inherited;
  DBComponentWindowProcs.Free;
  ModifiedActions.Free;
end;

{ TDBComponentWindowProc }

constructor TDBComponentWindowProc.Create(AFormHandle: THandle;
  AOldDBGridWndProc: TWndMethod; Grid : TToughDBGrid);
begin
  FFormHandle := AFormHandle;
  FOldDBGridWndProc := AOldDBGridWndProc;
  FGrid := Grid;

  if Assigned(FGrid.PopupMenu) then begin
    FOldOnBeforePopup := FGrid.PopupMenu.OnPopup;
    FGrid.PopupMenu.OnPopup := OnBeforePopup;
    FGridCopy := TMenuItem.Create(FGrid.PopupMenu);
    FGridCopy.Caption := 'Копировать';
    FGridCopy.OnClick := OnPopupCopyGridClick;
    FGrid.PopupMenu.Items.Add(FGridCopy);
  end;
end;

function TDBComponentWindowProc.GetSaveFlag: Boolean;
begin
  Result := ((FGrid.Tag and DM.SaveGridMask) > 0);  
end;

procedure TDBComponentWindowProc.HackDBGirdWndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_LBUTTONDOWN) or (Message.Msg = WM_RBUTTONDOWN) then
    Windows.SetFocus(FFormHandle);
  if Assigned(FOldDBGridWndProc) then
    FOldDBGridWndProc(Message);
end;

procedure TChildForm.PatchMyDataSets;
var
  I : Integer;
begin
  for I := 0 to ComponentCount-1 do
    if Components[i] is TCustomMyDataSet then
      if (DM.MainConnection is TMyEmbConnection) then
        TCustomMyDataSet(Components[i]).Connection := DM.MainConnection
      else
        if TCustomMyDataSet(Components[i]).Connection <> DM.MainConnection then
          TCustomMyDataSet(Components[i]).Connection := DM.MainConnection;
end;

procedure TChildForm.BeforeUpdateExecuteForClientID(
  Sender: TCustomMyDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if (stUpdate in StatementTypes) or (stRefresh in StatementTypes) then begin
    //Возможна ситуация, когда параметра "ClientId" не будет в выполняемой команде
    if Assigned(Params.FindParam('ClientId')) then
      Params.ParamByName('ClientId').Value := Sender.Params.ParamByName('ClientId').Value;
    if Assigned(Params.FindParam('DayOfWeek')) then
      Params.ParamByName('DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();
  end;
end;

procedure TChildForm.PrepareColumnsInOrderGrid(Grid : TToughDBGrid);
var
  realCostColumn : TColumnEh;
  supplierPriceMarkupColumn : TColumnEh;
  producerCostColumn : TColumnEh;
  ndsColumn : TColumnEh;
  maxProducerCostColumn : TColumnEh;
  registryCostColumn : TColumnEh;
  synonymFirmColumn : TColumnEh;
  priceRetColumn : TColumnEh;
  producerNameColumn : TColumnEh;

  procedure ChangeTitleCaption(FieldName, NewTitleCaption : String);
  var
    changedColumn : TColumnEh;
  begin
    changedColumn := ColumnByNameT(Grid, FieldName);
    if Assigned(changedColumn) then
      changedColumn.Title.Caption := NewTitleCaption;
  end;

begin
  Grid.AutoFitColWidths := False;
  try
  priceRetColumn := ColumnByNameT(Grid, 'PriceRet');
  if not Assigned(priceRetColumn) then
    priceRetColumn := ColumnByNameT(Grid, 'CryptPriceRet');
  if Assigned(priceRetColumn) then begin
    priceRetColumn.Visible := False;
    priceRetColumn.Title.Caption := 'Розн.цена';
  end;

  ChangeTitleCaption('Quantity', 'Остаток');
  ChangeTitleCaption('OrderCost', 'Мин.сумма');
  ChangeTitleCaption('MinOrderCount', 'Мин.кол-во');

  realCostColumn := ColumnByNameT(Grid, 'RealCost');
  if not Assigned(realCostColumn) then
    realCostColumn := ColumnByNameT(Grid, 'RealPrice');

  registryCostColumn := ColumnByNameT(Grid, 'RegistryCost');
  if Assigned(registryCostColumn) then begin
    registryCostColumn.Visible := True;
    registryCostColumn.Title.Caption := 'Реестр.цена';
  end;

  synonymFirmColumn  := ColumnByNameT(Grid, 'SynonymFirm');
  if Assigned(synonymFirmColumn) then begin
    Grid.ParentShowHint := False;
    Grid.ShowHint := True;
    synonymFirmColumn.ToolTips := True;

    producerNameColumn := ColumnByNameT(Grid, 'ProducerName');
    if not Assigned(producerNameColumn) then begin
      producerNameColumn := TColumnEh(Grid.Columns.Insert(synonymFirmColumn.Index+1));
      producerNameColumn.FieldName := 'ProducerName';
    producerNameColumn.Title.Caption := 'Кат.производитель';
      producerNameColumn.Visible := False;
      producerNameColumn.Width := Grid.Canvas.TextWidth(producerNameColumn.Title.Caption);
      if SortOnOrderGrid then
        producerNameColumn.Title.TitleButton := True;
    end;
  end;

  if Assigned(realCostColumn) then  begin
    ndsColumn := ColumnByNameT(Grid, 'NDS');
    if not Assigned(ndsColumn) then begin
      ndsColumn := TColumnEh(Grid.Columns.Insert(realCostColumn.Index));
      ndsColumn.FieldName := 'NDS';
      ndsColumn.Title.Caption := 'НДС';
      ndsColumn.Width := Grid.Canvas.TextWidth(ndsColumn.Title.Caption);
      if SortOnOrderGrid then
        ndsColumn.Title.TitleButton := True;
    end;
    supplierPriceMarkupColumn := ColumnByNameT(Grid, 'SupplierPriceMarkup');
    if not Assigned(supplierPriceMarkupColumn) then begin
      supplierPriceMarkupColumn := TColumnEh(Grid.Columns.Insert(ndsColumn.Index));
      supplierPriceMarkupColumn.FieldName := 'SupplierPriceMarkup';
      supplierPriceMarkupColumn.Title.Caption := 'Наценка поставщика';
      supplierPriceMarkupColumn.Width := Grid.Canvas.TextWidth('00.00');
      if SortOnOrderGrid then
        supplierPriceMarkupColumn.Title.TitleButton := True;
      supplierPriceMarkupColumn.DisplayFormat := '0.00;;''''';
    end;
    producerCostColumn := ColumnByNameT(Grid, 'ProducerCost');
    if not Assigned(producerCostColumn) then begin
      producerCostColumn := TColumnEh(Grid.Columns.Insert(supplierPriceMarkupColumn.Index));
      producerCostColumn.FieldName := 'ProducerCost';
      producerCostColumn.Title.Caption := 'Цена производителя';
      producerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      if SortOnOrderGrid then
        producerCostColumn.Title.TitleButton := True;
      producerCostColumn.DisplayFormat := '0.00;;''''';
    end;
    maxProducerCostColumn := ColumnByNameT(Grid, 'MaxProducerCost');
    if not Assigned(maxProducerCostColumn) then begin
      maxProducerCostColumn := TColumnEh(Grid.Columns.Insert(producerCostColumn.Index));
      maxProducerCostColumn.FieldName := 'MaxProducerCost';
      maxProducerCostColumn.Title.Caption := 'Пред.зарег.цена';
      maxProducerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      if SortOnOrderGrid then
        maxProducerCostColumn.Title.TitleButton := True;
      maxProducerCostColumn.DisplayFormat := '0.00;;''''';
    end;

    realCostColumn.Title.Caption := 'Цена поставщика';
    realCostColumn.Width := Grid.Canvas.TextWidth('0000.00');
    //удаляем столбец "Цена без отсрочки", если не включен механизм с отсрочкой платежа
    if not FAllowDelayOfPayment
      or not FShowSupplierCost
    then
      Grid.Columns.Delete(realCostColumn.Index)
    else
      //Если же механизм включен, то колонка должна отображаться по умолчанию
      realCostColumn.Visible := True;
  end;
  finally
    Grid.AutoFitColWidths := True;
  end;
end;

procedure TChildForm.FilterByMNNExecute(Sender: TObject);
var
  mnnField : TField;
  MnnId : Int64;
  lastControl : TWinControl;
begin
  lastControl := Self.ActiveControl;
  if (MainForm.ActiveChild = Self)
     and (Assigned(dsCheckVolume))
     and not dsCheckVolume.IsEmpty
  then begin
    mnnField := dsCheckVolume.FindField('MnnId');
    if Assigned(mnnField) then begin
      if not mnnField.IsNull and (mnnField is TLargeintField) then begin
        MnnId := TLargeintField(mnnField).Value;
        FlipToMNNFromMNNSearch(MnnId);
        Exit;
      end
      else
        AProc.MessageBox('Для данной позиции не установлено МНН.', MB_ICONWARNING);
    end;
  end;
  if Assigned(lastControl) and (lastControl is TToughDBGrid) and lastControl.CanFocus
  then
    lastControl.SetFocus;
end;

procedure TChildForm.ShowDescriptionExecute(Sender: TObject);
var
  fullCodeField : TField;
  fullCode : Int64;
  grid : TCustomDBGridEh;
begin
  if (MainForm.ActiveChild = Self)
     and Assigned(Screen.ActiveControl)
     and (Screen.ActiveControl is TCustomDBGridEh)
  then begin
  grid := TCustomDBGridEh(Screen.ActiveControl);
  if Assigned(grid.DataSource)
     and Assigned(grid.DataSource.DataSet)
     and not grid.DataSource.DataSet.IsEmpty
  then begin
    fullCodeField := grid.DataSource.DataSet.FindField('FullCode');
    if Assigned(fullCodeField) and not fullCodeField.IsNull and (fullCodeField is TLargeintField)
    then begin
      fullCode := TLargeintField(fullCodeField).Value;
      if DM.adsQueryValue.Active then
        DM.adsQueryValue.Close;
      DM.adsQueryValue.SQL.Text := ''
+'SELECT '
+'       Descriptions.Id, '
+'       Descriptions.Name  , '
+'       Descriptions.EnglishName, '
+'       Descriptions.Description, '
+'       Descriptions.* '
+'FROM '
+'       Catalogs, '
+'       Descriptions '
+'WHERE '
+'  (Catalogs.FullCode = :FullCode) '
+'  and (Descriptions.Id = Catalogs.DescriptionId) ';

      DM.adsQueryValue.ParamByName('FullCode').Value := fullCode;
      DM.adsQueryValue.Open;
      try
        if DM.adsQueryValue.IsEmpty then
          AProc.MessageBoxEx('Описание отсутствует.', 'Описание', MB_ICONWARNING)
        else
          ShowDescription(DM.adsQueryValue);
      finally
        DM.adsQueryValue.Close;
      end;
    end;
  end;
  end;
end;

procedure TChildForm.ShowDescriptionUpdate(Sender: TObject);
var
  grid : TCustomDBGridEh;
begin
  if Assigned(Sender) and (Sender is TAction) then

    TAction(Sender).Enabled := (MainForm.ActiveChild = Self);

    if TAction(Sender).Enabled then begin

      TAction(Sender).Enabled :=
            Assigned(Screen.ActiveControl)
        and (Screen.ActiveControl is TCustomDBGridEh);

      if TAction(Sender).Enabled then begin

        grid := TCustomDBGridEh(Screen.ActiveControl);

        TAction(Sender).Enabled :=
              Assigned(grid.DataSource)
          and Assigned(grid.DataSource.DataSet)
          and not grid.DataSource.DataSet.IsEmpty;
      end;
    end;
end;

procedure TChildForm.ShowAsPrevForm;
begin
  SetActiveChildToMainForm;
  Show;
  HideAllForms;
  UpdateOrderDataset;
end;

procedure TChildForm.SetPrevForm;
var
  I : Integer;
begin
  if Parent<>nil then
    for I:=0 to Parent.ControlCount-1 do
      if (Parent.Controls[I] is TChildForm)and(Parent.Controls[I]<>Self) then begin
        if Parent.Controls[I].Visible then PrevForm:=
          TChildForm(Parent.Controls[I]);
        Parent.Controls[I].Hide;
      end;
end;

procedure TChildForm.SetActiveChildToMainForm;
begin
  MainForm.ActiveChild := Self;
  //todo: ClientId-UserId
  if Caption <> '' then begin
    if (Length(MainForm.CurrentUser) > 0) then
      MainForm.Caption := Application.Title + ' - ' + MainForm.CurrentUser + ' - ' + Self.Caption
    else
      MainForm.Caption := Application.Title + ' - ' + Self.Caption;
  end;
end;

procedure TChildForm.UpdateOrderDataset;
var
  coreId : TField;
  lastCoreId : Variant;
begin
  if assigned(dsCheckVolume) then begin
    coreId := dsCheckVolume.FindField('CoreId');
    if Assigned(coreId) then
      lastCoreId := coreId.Value;
    dsCheckVolume.DisableControls;
    try
      dsCheckVolume.First;
      while not dsCheckVolume.Eof do begin
        if not fOrder.IsNull then
          TMyQuery(dsCheckVolume).RefreshRecord;
        dsCheckVolume.Next;
      end;
      dsCheckVolume.First;
      if Assigned(coreId) then
        dsCheckVolume.Locate('CoreId', lastCoreId, []);
    finally
      dsCheckVolume.EnableControls;
    end;
  end;
end;

procedure TChildForm.HideAllForms;
var
  I : Integer;
begin
  if Parent<>nil then
    for I:=0 to Parent.ControlCount-1 do
      if (Parent.Controls[I] is TChildForm)and(Parent.Controls[I]<>Self) then begin
        {
        if Parent.Controls[I].Visible then PrevForm:=
          TChildForm(Parent.Controls[I]);
        }
        Parent.Controls[I].Hide;
      end;
end;

procedure TDBComponentWindowProc.OnBeforePopup(Sender: TObject);
begin
  FGridCopy.Enabled := GetSaveFlag();
  if Assigned(FOldOnBeforePopup) then
    FOldOnBeforePopup(Sender);
end;

procedure TDBComponentWindowProc.OnPopupCopyGridClick(Sender: TObject);
var
  SaveGridFlag : Boolean;
begin
  SaveGridFlag := GetSaveFlag();
  if SaveGridFlag then
    TDBGridHelper.CopyGridToClipboard(FGrid);
end;

{ TModifiedAction }

constructor TModifiedAction.Create(Action: TCustomAction; Owner : TForm);
begin
  FAction := Action;
  FOldUpdate := FAction.OnUpdate;
  FAction.OnUpdate := Self.ModifedUpdate;
  FOwner := Owner;
end;

procedure TModifiedAction.ModifedUpdate(Sender: TObject);
begin
  if Assigned(FOldUpdate) then
    FOldUpdate(Sender)
  else
    if not FAction.Enabled and (MainForm.ActiveChild = FOwner) then
      FAction.Enabled := True
    else
      if FAction.Enabled and (MainForm.ActiveChild <> FOwner) then
        FAction.Enabled := False;
end;

procedure TChildForm.ModifyActionList(ActionList: TCustomActionList);
var
  I : Integer;
begin
  for I := 0 to ActionList.ActionCount-1 do
    if ActionList.Actions[i] is TCustomAction then
      ModifiedActions
        .Add( TModifiedAction
          .Create(
            TCustomAction(ActionList.Actions[i]),
            Self) );
end;

procedure TChildForm.FilterByMNNUpdate(Sender: TObject);
var
  mnnField : TField;
begin
  if Assigned(Sender) and (Sender is TAction) then begin
    if (MainForm.ActiveChild = Self)
       and (Assigned(dsCheckVolume))
       and not dsCheckVolume.IsEmpty
    then begin
      mnnField := dsCheckVolume.FindField('MnnId');
      TAction(Sender).Enabled := Assigned(mnnField) and not mnnField.IsNull and (mnnField is TLargeintField)
    end
    else
      TAction(Sender).Enabled := False;
  end;
end;

function TChildForm.CheckByBuyingMatrixType: Boolean;
begin
  if Assigned(fBuyingMatrixType) and (not fBuyingMatrixType.IsNull) and (not fOrder.IsNull)
     and (fOrder.AsInteger > 0) and (VarIsNull(OldOrderValue) or (OldOrderValue <> fOrder.AsInteger))
  then
    Result := fBuyingMatrixType.Value < 2
  else
    Result := True;
end;

procedure TChildForm.NewAfterOpen(DataSet : TDataSet);
begin
  OldOrderValue := fOrder.Value;
  if Assigned(OldAfterOpen) then
    OldAfterOpen(DataSet);
end;

procedure TChildForm.NewAfterScroll(DataSet : TDataSet);
begin
  OldOrderValue := fOrder.Value;
  if Assigned(OldAfterScroll) then
    OldAfterScroll(DataSet);
end;

end.
