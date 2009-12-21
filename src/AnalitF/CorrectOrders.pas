unit CorrectOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh,
  ToughDBGrid, ComCtrls, DB, RxMemDS, DAScript, MyScript, Child, DBCtrls,
  Grids, MemDS, DBAccess, MyAccess, Constant;

type
  TCorrectOrdersForm = class(TVistaCorrectForm)
    pBottom: TPanel;
    pClient: TPanel;
    btnClose: TButton;
    btnGoToReport: TButton;
    dbgCore: TToughDBGrid;
    pTop: TPanel;
    Splitter1: TSplitter;
    pRight: TPanel;
    tvList: TTreeView;
    Splitter2: TSplitter;
    MyScript1: TMyScript;
    lReason: TLabel;
    dsOrders: TDataSource;
    dbtReason: TDBText;
    dsCore: TDataSource;
    adsCore: TMyQuery;
    adsCoreCoreId: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreproductid: TLargeintField;
    adsCorefullcode: TLargeintField;
    adsCoreshortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCorePeriod: TStringField;
    adsCoreVolume: TStringField;
    adsCoreNote: TStringField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoredoc: TStringField;
    adsCoreregistrycost: TFloatField;
    adsCorevitallyimportant: TBooleanField;
    adsCorerequestratio: TIntegerField;
    adsCoreordercost: TFloatField;
    adsCoreminordercount: TIntegerField;
    adsCoreSynonymName: TStringField;
    adsCoreSynonymFirm: TStringField;
    adsCoreDatePrice: TDateTimeField;
    adsCorePriceName: TStringField;
    adsCorePriceEnabled: TBooleanField;
    adsCoreFirmCode: TLargeintField;
    adsCoreStorage: TBooleanField;
    adsCoreRegionName: TStringField;
    adsCoreOrderListId: TLargeintField;
    adsCoreOrdersCoreId: TLargeintField;
    adsCoreOrdersOrderId: TLargeintField;
    adsCoreOrdersClientId: TLargeintField;
    adsCoreOrdersFullCode: TLargeintField;
    adsCoreOrdersCodeFirmCr: TLargeintField;
    adsCoreOrdersSynonymCode: TLargeintField;
    adsCoreOrdersSynonymFirmCrCode: TLargeintField;
    adsCoreOrdersCode: TStringField;
    adsCoreOrdersCodeCr: TStringField;
    adsCoreOrderCount: TIntegerField;
    adsCoreOrdersSynonym: TStringField;
    adsCoreOrdersSynonymFirm: TStringField;
    adsCoreOrdersPrice: TFloatField;
    adsCoreSumOrder: TFloatField;
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrdersHClientId: TLargeintField;
    adsCoreOrdersHPriceCode: TLargeintField;
    adsCoreOrdersHRegionCode: TLargeintField;
    adsCoreOrdersHPriceName: TStringField;
    adsCoreOrdersHRegionName: TStringField;
    adsCorePriceRet: TCurrencyField;
    dbgValues: TToughDBGrid;
    mdValues: TRxMemoryData;
    mdValuesParametrName: TStringField;
    mdValuesOldValue: TStringField;
    mdValuesNewValue: TStringField;
    dsValues: TDataSource;
    plOverCost: TPanel;
    lWarning: TLabel;
    OverCostHideTimer: TTimer;
    adsAvgOrders: TMyQuery;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    tCheckVolume: TTimer;
    adsCoreRealCost: TFloatField;
    btnRetrySend: TButton;
    SaveDialog: TSaveDialog;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tvListChange(Sender: TObject; Node: TTreeNode);
    procedure tvListChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure adsCoreBeforeUpdateExecute(Sender: TCustomMyDataSet;
      StatementTypes: TStatementTypes; Params: TDAParams);
    procedure tvListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure adsCoreCalcFields(DataSet: TDataSet);
    procedure dbgValuesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure OverCostHideTimerTimer(Sender: TObject);
    procedure adsCoreBeforePost(DataSet: TDataSet);
    procedure tCheckVolumeTimer(Sender: TObject);
    procedure adsCoreAfterPost(DataSet: TDataSet);
    procedure adsCoreBeforeScroll(DataSet: TDataSet);
    procedure dbgCoreExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnGoToReportClick(Sender: TObject);
  private
    { Private declarations }
    UseExcess: Boolean;
    Excess : Integer;
    //Проверяем, что заказ сделан кратно Volume
    function  CheckVolume : Boolean;
    //Проверяем, что заказ сделан >= OrderCost
    function  CheckByOrderCost : Boolean;
    //Проверяем, что заказанное кол-во >= MinOrderCount
    function  CheckByMinOrderCount : Boolean;
    //очищаем созданный заказ
    procedure ClearOrder;
    //очищаем созданный заказ
    procedure ClearOrderByOrderCost;
    procedure ShowVolumeMessage;
  protected
    Orders : TRxMemoryData;
    dsCheckVolume : TDataSet;
    dgCheckVolume : TToughDBGrid;
    fOrder        : TField;
    fVolume       : TField;
    fOrderCost    : TField;
    fSumOrder     : TField;
    fMinOrderCount : TField;
    procedure SetOffers;
  public
    { Public declarations }
    Report : TStrings;
    procedure Prepare;
  end;

{
todo: Разобраться с ошибкой создания нового поля в DataSet: Access Violation на "New Field"
Пример решения описан здесь:
http://qc.embarcadero.com/wc/qcmain.aspx?d=2659
Мне пришлось добавить в проект пакет "InterBase Data Access Components" (DCLIB70.bpl),
хотя раньше все было в порядке
}

function ShowCorrectOrders(
  Orders : TRxMemoryData;
  ShowRetry : Boolean;
  Report : TStrings) : TModalResult;

implementation

{$R *.dfm}

uses
  DModule, AProc, DBProc;

function ShowCorrectOrders(
  Orders : TRxMemoryData;
  ShowRetry : Boolean;
  Report : TStrings) : TModalResult;
var
  CorrectOrdersForm: TCorrectOrdersForm;
begin
  CorrectOrdersForm := TCorrectOrdersForm.Create(Application);
  try
    CorrectOrdersForm.Orders := Orders;
    if (ShowRetry) then begin
      CorrectOrdersForm.btnRetrySend.Visible := True;
      CorrectOrdersForm.btnRefresh.Visible := True;
    end;
    CorrectOrdersForm.Report := Report;
    CorrectOrdersForm.Prepare;
    Result := CorrectOrdersForm.ShowModal;
  finally
    CorrectOrdersForm.Free;
  end;
end;

procedure TCorrectOrdersForm.FormCreate(Sender: TObject);
begin
  Report := nil;
  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  adsAvgOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;
  plOverCost.Hide();
  adsCore.Connection := DM.MainConnection;
  adsAvgOrders.Connection := DM.MainConnection;
  if not adsAvgOrders.Active then
    adsAvgOrders.Open;
  dbgCore.Options := dbgCore.Options + [dgRowLines];
  dbgCore.Font.Size := 10;
  dbgCore.GridLineColors.DarkColor := clBlack;
  dbgCore.GridLineColors.BrightColor := clDkGray;
  Self.WindowState := wsMaximized;

  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
end;

procedure TCorrectOrdersForm.Prepare;
var
  ClientName, PriceName : String;
  ClientNode, PriceNode : TTreeNode;
begin
  tvList.Items.Clear;

  Orders.SortOnFields('ClientName;PriceName;SynonymName;SynonymFirm');
  Orders.First;

  ClientName := Orders.FieldByName('ClientName').AsString;
  PriceName := Orders.FieldByName('PriceName').AsString;
  ClientNode := tvList.Items.Add(nil, ClientName);
  PriceNode := tvList.Items.AddChild(ClientNode, PriceName);

  while not Orders.Eof do begin
    if     (ClientName = Orders.FieldByName('ClientName').AsString)
       and (PriceName  <> Orders.FieldByName('PriceName').AsString)
    then begin
      PriceName := Orders.FieldByName('PriceName').AsString;
      PriceNode := tvList.Items.AddChild(ClientNode, PriceName);
    end
    else
      if     (ClientName <> Orders.FieldByName('ClientName').AsString)
         and (PriceName  <> Orders.FieldByName('PriceName').AsString)
      then begin
        ClientName := Orders.FieldByName('ClientName').AsString;
        PriceName := Orders.FieldByName('PriceName').AsString;
        ClientNode := tvList.Items.Add(nil, ClientName);
        PriceNode := tvList.Items.AddChild(ClientNode, PriceName);
      end;

    tvList.Items.AddChildObject(
      PriceNode,
      Orders.FieldByName('SynonymName').AsString + ' - ' + Orders.FieldByName('SynonymFirm').AsString,
      TObject(TLargeintField(Orders.FieldByName('OrderListId')).AsLargeInt));

    Orders.Next;
  end;

  tvList.FullExpand;

  dsOrders.DataSet := Orders;
  //Устанавливаем верний отображаемый узел
  tvList.TopItem := tvList.Items.GetFirstNode;
  //Выделяем первую позицию, требующей корректировки
  tvList.Items.GetFirstNode.Item[0].Item[0].Selected := True;
end;

procedure TCorrectOrdersForm.SetOffers;
begin
  dsOrders.Enabled := True;
  if adsCore.Active then
    adsCore.Close;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := Orders.FieldByName('ClientId').Value;
  adsCore.ParamByName('ProductId').Value := Orders.FieldByName('ProductId').Value;
  adsCore.Open;
  if not adsCore.IsEmpty then
    adsCore.Locate('OrderListId', Orders.FieldByName('OrderListId').Value, []);
  if mdValues.Active then
    mdValues.Close;
  mdValues.Open;
  mdValues.AppendRecord([
    'Цена',
    Orders.FieldByName('OldPrice').AsString,
    Orders.FieldByName('NewPrice').AsString]);
  mdValues.AppendRecord([
    'Количество',
    Orders.FieldByName('OldOrderCount').AsString,
    Orders.FieldByName('NewOrderCount').AsString]);
  mdValues.First;
  dbgValues.Columns[0].Title.Caption := '';
end;

procedure TCorrectOrdersForm.tvListChange(Sender: TObject;
  Node: TTreeNode);
var
  value : Int64;
begin
  if Assigned(Node.Data) then begin
    value := Int64(Node.Data);
    if Orders.Locate('OrderListId', value, []) then
      SetOffers;
  end
  else begin
    adsCore.Close;
    mdValues.Close;
    dsOrders.Enabled := False;
  end;
end;

procedure TCorrectOrdersForm.tvListChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  //Это пока отключил, т.к. переходит не совсем корректно
  AllowChange := False;
  if Assigned(Node.Data) then
    AllowChange := True
  else
    if (Node.Count > 0) and (Node.Item[0].Count > 0) then begin
      //Node := Node.Item[0].Item[0];
      Node.Item[0].Item[0].Selected := True;
      AllowChange := False;
    end
    else
      if (Node.Count > 0) then begin
        //Node := Node.Item[0];
        Node.Item[0].Selected := True;
        AllowChange := False;
      end
end;

procedure TCorrectOrdersForm.adsCoreBeforeUpdateExecute(
  Sender: TCustomMyDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if (stUpdate in StatementTypes) or (stRefresh in StatementTypes) then
    //Возможна ситуация, когда параметра "ClientId" не будет в выполняемой команде
    if Assigned(Params.FindParam('ClientId')) then
      Params.ParamByName('ClientId').Value := Sender.Params.ParamByName('ClientId').Value;
end;

procedure TCorrectOrdersForm.tvListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and Assigned(tvList.Selected.Data) and not adsCore.IsEmpty
  then
    dbgCore.SetFocus;
end;

procedure TCorrectOrdersForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    tvList.SetFocus;
end;

procedure TCorrectOrdersForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCore.Active then begin
    if adsCoreSynonymCode.AsInteger < 0 then
    begin
      Background := $00fff1d8;
                  AFont.Style := [fsBold];
    end
    else
    if adsCoreFirmCode.AsInteger = RegisterId then
    begin
      //если это реестр, изменяем цвета
      if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM) or
        ( Column.Field = adsCoreCOST)or
        ( Column.Field = adsCorePriceRet) then Background := REG_CLR;
    end
    else
    begin
      if adsCoreVITALLYIMPORTANT.AsBoolean then
        AFont.Color := VITALLYIMPORTANT_CLR;

      if not adsCorePriceEnabled.AsBoolean then
      begin
        //если фирма недоступна, изменяем цвет
        if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
          then Background := clBtnFace;
      end;

      //если уцененный товар, изменяем цвет
      if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCOST)) then
        Background := JUNK_CLR;
      //ожидаемый товар выделяем зеленым
      if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
        Background := AWAIT_CLR;
    end;
  end;
end;

procedure TCorrectOrdersForm.adsCoreCalcFields(DataSet: TDataSet);
begin
  try
    adsCorePriceRet.AsCurrency := DM.GetPriceRet(adsCoreCost.AsCurrency);
  except
  end;
end;

procedure TCorrectOrdersForm.dbgValuesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
{
  Еще один возможный цвет для заливки отличающихся значений
  Background := RGB(255, 0, 128);
}
  if (Column.Field = mdValuesOldValue) or (Column.Field = mdValuesNewValue) then
    if (mdValuesOldValue.AsString <> mdValuesNewValue.AsString) then
      Background := RGB(239, 82, 117);
end;

procedure TCorrectOrdersForm.OverCostHideTimerTimer(Sender: TObject);
begin
  OverCostHideTimer.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TCorrectOrdersForm.adsCoreBeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
  tCheckVolume.Enabled := False;
  try
    { проверяем заказ на соответствие наличию товара на складе }
    Val( adsCoreQuantity.AsString,Quantity,E);
    if E<>0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
      ( AProc.MessageBox( 'Заказ превышает остаток на складе. Продолжить?',
      MB_ICONQUESTION + MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';

    { проверяем на превышение цены }
    if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
      begin
        PanelCaption := 'Превышение средней цены!';
      end;
    end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Вы заказали некондиционный препарат.'
      else
        PanelCaption := 'Вы заказали некондиционный препарат.';

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + 'Внимание! Вы заказали большое количество препарата.'
      else
        PanelCaption := 'Внимание! Вы заказали большое количество препарата.';

    if Length(PanelCaption) > 0 then begin
      if OverCostHideTimer.Enabled then
        OverCostHideTimer.OnTimer(OverCostHideTimer);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      OverCostHideTimer.Enabled := True;
    end;
  except
    adsCore.Cancel;
    raise;
  end;
  //Это хак: чтобы метод не отрабатывал на adsCore из формы TOrdersForm  
  if Assigned(DataSet.FindField('ORDERSORDERID')) then
    DM.InsertOrderHeader(TCustomMyDataSet(DataSet));
end;

procedure TCorrectOrdersForm.tCheckVolumeTimer(Sender: TObject);
begin
  ShowVolumeMessage;
end;

procedure TCorrectOrdersForm.ShowVolumeMessage;
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
end;

function TCorrectOrdersForm.CheckVolume: Boolean;
begin
  if not fVolume.IsNull and (fVolume.AsInteger > 0 ) then
    Result := (fOrder.AsInteger mod fVolume.AsInteger = 0)
  else
    Result := True;
end;

procedure TCorrectOrdersForm.ClearOrder;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := fOrder.AsInteger - (fOrder.AsInteger mod fVolume.AsInteger);
  dsCheckVolume.Post;
end;

function TCorrectOrdersForm.CheckByOrderCost: Boolean;
begin
  if (not fOrderCost.IsNull) and (fOrderCost.AsCurrency > 0 ) and (not fSumOrder.IsNull)
     and (fSumOrder.AsCurrency > 0)
  then
    Result := (fSumOrder.AsCurrency >= fOrderCost.AsCurrency)
  else
    Result := True;
end;

procedure TCorrectOrdersForm.ClearOrderByOrderCost;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := 0;
  dsCheckVolume.Post;
end;

function TCorrectOrdersForm.CheckByMinOrderCount: Boolean;
begin
  if (not fMinOrderCount.IsNull) and (fMinOrderCount.AsInteger > 0 ) and (not fOrder.IsNull)
     and (fOrder.AsInteger > 0)
  then
    Result := (fOrder.AsInteger >= fMinOrderCount.AsInteger)
  else
    Result := True;
end;

procedure TCorrectOrdersForm.adsCoreAfterPost(DataSet: TDataSet);
begin
  tCheckVolume.Enabled := False;
  tCheckVolume.Enabled := True;
end;

procedure TCorrectOrdersForm.adsCoreBeforeScroll(DataSet: TDataSet);
begin
  ShowVolumeMessage;
end;

procedure TCorrectOrdersForm.dbgCoreExit(Sender: TObject);
begin
  ShowVolumeMessage;
end;

procedure TCorrectOrdersForm.FormResize(Sender: TObject);
begin
  inherited;
  pTop.Height := Self.ClientHeight div 2;
end;

procedure TCorrectOrdersForm.btnGoToReportClick(Sender: TObject);
begin
  if Assigned(Report) and SaveDialog.Execute then
    Report.SaveToFile(SaveDialog.FileName);
end;

end.
