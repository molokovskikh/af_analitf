unit CorrectOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh,
  ToughDBGrid, ComCtrls, DB, RxMemDS, DAScript, MyScript, Child, DBCtrls,
  Grids, MemDS, DBAccess, MyAccess, Constant, MemTableDataEh, MemTableEh,
  StrUtils, EhLibMTE;

type
  TCorrectResult = (crClose, crEditOrders, crForceSended, crGetPrice);

  TCorrectOrdersForm = class(TVistaCorrectForm)
    pBottom: TPanel;
    pClient: TPanel;
    btnClose: TButton;
    btnGoToReport: TButton;
    dbgCore: TToughDBGrid;
    pTop: TPanel;
    Splitter1: TSplitter;
    MyScript1: TMyScript;
    dsOrders: TDataSource;
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
    btnEditOrders: TButton;
    pLog: TPanel;
    dbgLog: TToughDBGrid;
    mtLog: TMemTableEh;
    dsLog: TDataSource;
    mtLogId: TLargeintField;
    mtLogParentId: TLargeintField;
    mtLogSend: TBooleanField;
    mtLogOldOrderCount: TIntegerField;
    mtLogNewOrderCount: TIntegerField;
    mtLogOldPrice: TCurrencyField;
    mtLogNewPrice: TCurrencyField;
    mtLogNodeName: TStringField;
    mtLogSynonymFirm: TStringField;
    mtLogReason: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure tvListChange(Sender: TObject; Node: TTreeNode);
    procedure adsCoreBeforeUpdateExecute(Sender: TCustomMyDataSet;
      StatementTypes: TStatementTypes; Params: TDAParams);
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
    procedure FormResize(Sender: TObject);
    procedure btnGoToReportClick(Sender: TObject);
    procedure btnRetrySendClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnEditOrdersClick(Sender: TObject);
    procedure dbgCoreExit(Sender: TObject);
    procedure dbgLogDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure dbgLogGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure mtLogSendChange(Sender: TField);
    procedure dbgLogKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure tvListChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
  protected
    dsCheckVolume : TDataSet;
    dgCheckVolume : TToughDBGrid;
    fOrder        : TField;
    fVolume       : TField;
    fOrderCost    : TField;
    fSumOrder     : TField;
    fMinOrderCount : TField;
    ProcessSendOrdersResponse : Boolean;
    procedure SetOffers;
    procedure PrepareVisual;
    procedure PrepareData;
    procedure SaveReport;
    function GetReportOrdersLogSql : String;
    procedure SetGridParams(Grid : TToughDBGrid);
  public
    { Public declarations }
    Report : TStrings;
    FormResult : TCorrectResult;
    procedure Prepare;
  end;

{
todo: Разобраться с ошибкой создания нового поля в DataSet: Access Violation на "New Field"
Пример решения описан здесь:
http://qc.embarcadero.com/wc/qcmain.aspx?d=2659
Мне пришлось добавить в проект пакет "InterBase Data Access Components" (DCLIB70.bpl),
хотя раньше все было в порядке
}

function ShowCorrectOrders(ProcessSendOrdersResponse : Boolean) : TCorrectResult;

implementation

{$R *.dfm}

uses
  DModule, AProc, DBProc, PostSomeOrdersController;

function ShowCorrectOrders(ProcessSendOrdersResponse : Boolean) : TCorrectResult;
var
  CorrectOrdersForm: TCorrectOrdersForm;
begin
  CorrectOrdersForm := TCorrectOrdersForm.Create(Application);
  try
    CorrectOrdersForm.ProcessSendOrdersResponse := ProcessSendOrdersResponse;
    CorrectOrdersForm.Prepare;
    CorrectOrdersForm.ShowModal;
    Result := CorrectOrdersForm.FormResult;
  finally
    CorrectOrdersForm.Free;
  end;
end;

procedure TCorrectOrdersForm.FormCreate(Sender: TObject);
begin
  FormResult := crClose;
  Report := TStringList.Create;
  dbgLog.PopupMenu := nil;

  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  adsAvgOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;
  plOverCost.Hide();
  adsCore.Connection := DM.MainConnection;
  adsAvgOrders.Connection := DM.MainConnection;
  if not adsAvgOrders.Active then
    adsAvgOrders.Open;
  Self.WindowState := wsMaximized;
  SetGridParams(dbgCore);
  //SetGridParams(dbgLog);

  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
end;

procedure TCorrectOrdersForm.PrepareData;
var
  ClientName, PriceName : String;
  ClientId, OrderId : Int64;

  procedure AddClient();
  begin
    ClientName := DM.adcUpdate.FieldByName('ClientName').AsString;
    PriceName := DM.adcUpdate.FieldByName('PriceName').AsString;
    ClientId := TLargeintField(DM.adcUpdate.FieldByName('ClientId')).AsLargeInt;
    OrderId := TLargeintField(DM.adcUpdate.FieldByName('OrderId')).AsLargeInt;

    mtLog.Append;
    mtLog.FieldValues['Id'] := ClientId;
    mtLog.FieldValues['NodeName'] := ClientName;
    mtLog.Post;
    Report.Append(Format('клиент %s', [ClientName]));

    mtLog.Append;
    mtLog.FieldValues['Id'] := OrderId;
    mtLog.FieldValues['ParentId'] := ClientId;
    mtLog.FieldValues['NodeName'] := PriceName;
    mtLog.FieldValues['Send'] := DM.adcUpdate.FieldByName('Send').AsBoolean;
    if not DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      mtLog.FieldValues['Reason'] :=
        DM.adcUpdate.FieldByName('ErrorReason').AsString;
    mtLog.Post;
    if DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      Report.Append(Format('   прайс-лист %s', [PriceName]))
    else
      Report.Append(Format('   прайс-лист %s   причина: %s',
        [PriceName,
         DM.adcUpdate.FieldByName('ErrorReason').AsString]));
  end;

  procedure AddOrder();
  begin
    PriceName := DM.adcUpdate.FieldByName('PriceName').AsString;
    OrderId := TLargeintField(DM.adcUpdate.FieldByName('OrderId')).AsLargeInt;

    mtLog.Append;
    mtLog.FieldValues['Id'] := OrderId;
    mtLog.FieldValues['ParentId'] := ClientId;
    mtLog.FieldValues['NodeName'] := PriceName;
    mtLog.FieldValues['Send'] := DM.adcUpdate.FieldByName('Send').AsBoolean;
    if not DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      mtLog.FieldValues['Reason'] :=
        DM.adcUpdate.FieldByName('ErrorReason').AsString;
    mtLog.Post;
    if DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      Report.Append(Format('   прайс-лист %s', [PriceName]))
    else
      Report.Append(Format('   прайс-лист %s   причина: %s',
        [PriceName,
         DM.adcUpdate.FieldByName('ErrorReason').AsString]));
  end;

  procedure AddPosition();
  var
    PositionId : Int64;
    PostionReason : String;
    PositionResult : TPositionSendResult;
  begin
    PositionId := TLargeintField(DM.adcUpdate
      .FieldByName('OrderListId')).AsLargeInt;

    mtLog.Append;
    mtLog.FieldValues['Id'] := PositionId;
    mtLog.FieldValues['ParentId'] := OrderId;
    mtLog.FieldValues['NodeName'] :=
      DM.adcUpdate.FieldByName('SynonymName').AsString;
    mtLog.FieldValues['SynonymFirm'] :=
      DM.adcUpdate.FieldByName('SynonymFirm').AsString;
    mtLog.FieldValues['Send'] := DM.adcUpdate.FieldByName('Send').AsBoolean;
    PositionResult := TPositionSendResult(
        DM.adcUpdate.FieldByName('DropReason').AsInteger);
    PostionReason := PositionSendResultText[PositionResult];
    mtLog.FieldValues['Reason'] := PostionReason;

    case PositionResult of
      psrNotExists :
        begin
          mtLog.FieldValues['OldOrderCount'] :=
            DM.adcUpdate.FieldByName('OldOrderCount').Value;
          mtLog.FieldValues['OldPrice'] :=
            DM.adcUpdate.FieldByName('OldPrice').Value;
        end;
      psrDifferentCost :
        begin
          mtLog.FieldValues['OldPrice'] :=
            DM.adcUpdate.FieldByName('OldPrice').Value;
          mtLog.FieldValues['NewPrice'] :=
            DM.adcUpdate.FieldByName('NewPrice').Value;
        end;
      psrDifferentQuantity :
        begin
          mtLog.FieldValues['OldOrderCount'] :=
            DM.adcUpdate.FieldByName('OldOrderCount').Value;
          mtLog.FieldValues['NewOrderCount'] :=
            DM.adcUpdate.FieldByName('NewOrderCount').Value;
        end;
    end;

    mtLog.Post;

    Report.Append( Format( '      %s%s : %s (старая цена: %s; старый заказ: %s; новая цена: %s; текущий заказ: %s)',
      [DM.adcUpdate.FieldByName('SynonymName').AsString,
       IfThen(Length(DM.adcUpdate.FieldByName('SynonymFirm').AsString) > 0,
         ' - ' + DM.adcUpdate.FieldByName('SynonymFirm').AsString),
       PostionReason,
       DM.adcUpdate.FieldByName('OldPrice').AsString,
       DM.adcUpdate.FieldByName('OldOrderCount').AsString,
       DM.adcUpdate.FieldByName('NewPrice').AsString,
       DM.adcUpdate.FieldByName('NewOrderCount').AsString]));
  end;

begin

  mtLog.Close;
  mtLog.Open;
  mtLog.TreeList.Active := True;

  //Orders.SortOnFields('ClientName;PriceName;SynonymName;SynonymFirm');
  //Orders.First;
  DM.adcUpdate.Close;
  DM.adcUpdate.SQL.Text := GetReportOrdersLogSql;
  DM.adcUpdate.Open;
  try
  DM.adcUpdate.First;

  AddClient();

  while not DM.adcUpdate.Eof do begin
    if     (ClientName = DM.adcUpdate.FieldByName('ClientName').AsString)
       and (PriceName  <> DM.adcUpdate.FieldByName('PriceName').AsString)
    then begin
      AddOrder;
    end
    else
      if     (ClientName <> DM.adcUpdate.FieldByName('ClientName').AsString)
         and (PriceName  <> DM.adcUpdate.FieldByName('PriceName').AsString)
      then begin
        AddClient();
      end;

    if not DM.adcUpdate.FieldByName('OrderListId').IsNull then
      AddPosition;

    DM.adcUpdate.Next;
  end;
  finally
    DM.adcUpdate.Close
  end;

  mtLog.First;

  //dsOrders.DataSet := Orders;
  //Выделяем первую позицию, требующей корректировки
  if ProcessSendOrdersResponse then begin
    mtLogSend.OnChange := mtLogSendChange;
  end;
end;

procedure TCorrectOrdersForm.SetOffers;
begin
{
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
}  
end;

procedure TCorrectOrdersForm.tvListChange(Sender: TObject;
  Node: TTreeNode);
var
  value : Int64;
begin
  if Assigned(Node.Data) then begin
    value := Int64(Node.Data);
{
    if Orders.Locate('OrderListId', value, []) then
      SetOffers;
}      
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

procedure TCorrectOrdersForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
    dbgLog.SetFocus;
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

procedure TCorrectOrdersForm.FormResize(Sender: TObject);
begin
  inherited;
{
  if not ProcessSendOrdersResponse then
    pTop.Height := Self.ClientHeight div 2;
}    
end;

procedure TCorrectOrdersForm.btnGoToReportClick(Sender: TObject);
begin
  if Assigned(Report) and SaveDialog.Execute then
    Report.SaveToFile(SaveDialog.FileName);
end;

procedure TCorrectOrdersForm.Prepare;
begin
  PrepareVisual;
  PrepareData;
end;

procedure TCorrectOrdersForm.PrepareVisual;
begin
  if ProcessSendOrdersResponse then begin
    btnClose.Caption := 'Отменить';
    Self.Caption := 'Журнал отправки заказов';
    dbgCore.Align := alNone;
    dbgCore.Visible := False;
    pTop.Align := alClient;
  end
  else begin
    btnRetrySend.Visible := False;
    btnRefresh.Visible := False;
    btnEditOrders.Visible := False;

    dbgCore.Align := alNone;
    dbgCore.Visible := False;
    pTop.Align := alClient;
  end;
end;

procedure TCorrectOrdersForm.SaveReport;
begin
  //Здесь должно быть построение отчета
end;

procedure TCorrectOrdersForm.btnRetrySendClick(Sender: TObject);
begin
  inherited;
  FormResult := crForceSended;
end;

procedure TCorrectOrdersForm.btnRefreshClick(Sender: TObject);
begin
  inherited;
  FormResult := crGetPrice;
end;

procedure TCorrectOrdersForm.btnEditOrdersClick(Sender: TObject);
begin
  inherited;
  FormResult := crEditOrders;
end;

function TCorrectOrdersForm.GetReportOrdersLogSql: String;
begin
  Result := '';
  if ProcessSendOrdersResponse then begin
    Result := ''
    + 'select '
    + '  OrdersHead.ClientId, '
    + '  clients.Name as ClientName, '
    + '  OrdersHead.OrderId, '
    + '  OrdersHead.PriceName, '
    + '  OrdersHead.Send, '
    + '  OrdersHead.SendResult, '
    + '  OrdersHead.ErrorReason, '
    + '  OrdersList.Id As OrderListId, '
    + '  OrdersList.SynonymName, '
    + '  OrdersList.SynonymFirm, '
    + '  OrdersList.DropReason, '
    + '  OrdersList.OrderCount as OldOrderCount, '
    + '  OrdersList.ServerQuantity as NewOrderCount, '
    + '  OrdersList.Price as OldPrice, '
    + '  OrdersList.ServerCost as NewPrice '
    + 'from '
    + '  OrdersHead '
    + '  inner join clients   on (clients.clientid = OrdersHead.ClientId) '
    + '  left join OrdersList on OrdersList.OrderId = OrdersHead.OrderId and (OrdersList.DropReason is not null)'
    + ' '
    + ' '
    + 'where '
    + '    OrdersHead.ClientId = ' + DM.adtClientsCLIENTID.AsString + '  '
    + 'and OrdersHead.Closed = 0 '
    + 'and OrdersHead.Send = 1 '
    + 'and OrdersHead.SendResult is not null '
    + 'order by clients.Name, OrdersHead.PriceName, OrdersList.SynonymName, OrdersList.SynonymFirm';
  end
  else begin
    Result := ''
    + 'select '
    + '  OrdersHead.ClientId, '
    + '  clients.Name as ClientName, '
    + '  OrdersHead.OrderId, '
    + '  OrdersHead.PriceName, '
    + '  OrdersHead.Send, '
    + '  OrdersHead.SendResult, '
    + '  OrdersHead.ErrorReason, '
    + '  OrdersList.Id As OrderListId, '
    + '  OrdersList.SynonymName, '
    + '  OrdersList.SynonymFirm, '
    + '  OrdersList.DropReason, '

    + '  OrdersList.ServerQuantity as OldOrderCount, '
    + '  OrdersList.OrderCount as NewOrderCount, '
    + '  OrdersList.ServerCost as OldPrice, '
    + '  OrdersList.Price as NewPrice '
    
    + 'from '
    + '  OrdersHead '
    + '  inner join clients   on (clients.clientid = OrdersHead.ClientId) '
    + '  inner join OrdersList on OrdersList.OrderId = OrdersHead.OrderId and (OrdersList.DropReason is not null)'
    + ' '
    + ' '
    + 'where '
    + '  OrdersHead.Closed = 0 '
    + 'order by clients.Name, OrdersHead.PriceName, OrdersList.SynonymName, OrdersList.SynonymFirm';
  end;
end;

procedure TCorrectOrdersForm.dbgCoreExit(Sender: TObject);
begin
  ShowVolumeMessage;
end;

procedure TCorrectOrdersForm.dbgLogDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = mtLogSend then begin
    if mtLog.TreeNodeLevel <> 2 then
      TDBGridEh(Sender).Canvas.FillRect(Rect);
  end;
end;

procedure TCorrectOrdersForm.dbgLogGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if mtLog.TreeNodeLevel = 3 then begin
    //Производим заливку для позиций
    {
      Еще один возможный цвет для заливки отличающихся значений
      Background := RGB(255, 0, 128);
    }
      if (Column.Field = mtLogOldOrderCount) or (Column.Field = mtLogNewOrderCount) then
        if (mtLogOldOrderCount.AsString <> mtLogNewOrderCount.AsString) then
          Background := RGB(239, 82, 117);
      if (Column.Field = mtLogOldPrice) or (Column.Field = mtLogNewPrice) then
        if (mtLogOldPrice.AsString <> mtLogNewPrice.AsString) then
          Background := RGB(239, 82, 117);
  end;
end;

procedure TCorrectOrdersForm.mtLogSendChange(Sender: TField);
begin
  DM.adcUpdate.SQL.Text := 'update ordershead set Send = :Send where OrderId = :OrderId';
  DM.adcUpdate.ParamByName('Send').AsBoolean := Sender.AsBoolean;
  DM.adcUpdate.ParamByName('OrderId').Value := mtLogId.Value;
  DM.adcUpdate.Execute;
end;

procedure TCorrectOrdersForm.dbgLogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ProcessSendOrdersResponse and (Key = VK_RETURN) and not adsCore.IsEmpty
  then
    dbgCore.SetFocus;
end;

procedure TCorrectOrdersForm.SetGridParams(Grid: TToughDBGrid);
begin
  Grid.Options := Grid.Options + [dgRowLines];
  Grid.Font.Size := 10;
  Grid.GridLineColors.DarkColor := clBlack;
  Grid.GridLineColors.BrightColor := clDkGray;
end;

end.
