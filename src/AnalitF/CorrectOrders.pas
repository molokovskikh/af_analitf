unit CorrectOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh,
  ToughDBGrid, ComCtrls, DB, RxMemDS, DAScript, MyScript, Child, DBCtrls,
  Grids, MemDS, DBAccess, MyAccess, Constant, MemTableDataEh, MemTableEh,
  StrUtils, EhLibMTE, Contnrs,
  U_CurrentOrderItem,
  NetworkParams,
  DayOfWeekHelper;

type
  TCorrectResult = (crClose, crEditOrders, crForceSended, crGetPrice);
  TCorrectNodeType = (cntClient, cntOrder, cntPosition);

  TCorrectOrdersForm = class(TVistaCorrectForm)
    pBottom: TPanel;
    pClient: TPanel;
    btnClose: TButton;
    btnSaveReport: TButton;
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
    mtLogSelfId: TLargeintField;
    gbCorrectMessage: TGroupBox;
    dbmCorrectMessage: TDBMemo;
    mtLogNodeType: TIntegerField;
    adsCoreSupplierPriceMarkup: TFloatField;
    adsCoreProducerCost: TFloatField;
    adsCoreNDS: TSmallintField;
    adsCoreMnnId: TLargeintField;
    adsCoreMnn: TStringField;
    adsCoreMaxProducerCost: TFloatField;
    adsCoreProducerName: TStringField;
    adsCoreCatalogVitallyImportant: TBooleanField;
    adsCoreRetailVitallyImportant: TBooleanField;
    adsCoreMarkup: TFloatField;
    procedure FormCreate(Sender: TObject);
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
    procedure btnSaveReportClick(Sender: TObject);
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
    procedure mtLogAfterScroll(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    UseExcess: Boolean;
    Excess : Integer;
    //���������, ��� ����� ������ ������ Volume
    function  CheckVolume : Boolean;
    //���������, ��� ����� ������ >= OrderCost
    function  CheckByOrderCost : Boolean;
    //���������, ��� ���������� ���-�� >= MinOrderCount
    function  CheckByMinOrderCount : Boolean;
    //������� ��������� �����
    procedure ClearOrder;
    //������� ��������� �����
    procedure ClearOrderByOrderCost;
    procedure ShowVolumeMessage;
  protected
    dsCheckVolume : TDataSet;
    dgCheckVolume : TToughDBGrid;
    fOrder        : TField;
    fVolume       : TField;
    fOrderCost    : TField;
    fSumOrder     : TField;
    fMinOrderCount : TField;
    ProcessSendOrdersResponse : Boolean;
    FNetworkParams : TNetworkParams;
    FAllowDelayOfPayment : Boolean;
    FShowSupplierCost : Boolean;
    procedure SetOffers;
    procedure PrepareVisual;
    procedure PrepareData;
    function GetReportOrdersLogSql : String;
    procedure SetGridParams(Grid : TToughDBGrid);
    procedure PrepareColumnsInOrderGrid(Grid : TToughDBGrid);
  public
    { Public declarations }
    Report : TStrings;
    FormResult : TCorrectResult;
    procedure Prepare;
  end;

{
todo: ����������� � ������� �������� ������ ���� � DataSet: Access Violation �� "New Field"
������ ������� ������ �����:
http://qc.embarcadero.com/wc/qcmain.aspx?d=2659
��� �������� �������� � ������ ����� "InterBase Data Access Components" (DCLIB70.bpl),
���� ������ ��� ���� � �������
}

function ShowCorrectOrders(ProcessSendOrdersResponse : Boolean) : TCorrectResult;

implementation

{$R *.dfm}

uses
  DModule, AProc, DBProc, PostSomeOrdersController, NotFound, U_framePosition,
  DBGridHelper;

function ShowCorrectOrders(ProcessSendOrdersResponse : Boolean) : TCorrectResult;
var
  CorrectOrdersForm: TCorrectOrdersForm;
begin
  CorrectOrdersForm := TCorrectOrdersForm.Create(Application);
  try
    CorrectOrdersForm.ProcessSendOrdersResponse := ProcessSendOrdersResponse;
    CorrectOrdersForm.Prepare;
    if not DM.adsUser.FieldByName('UseCorrectOrders').AsBoolean then begin
      if ProcessSendOrdersResponse then
        ShowNotSended(CorrectOrdersForm.Report.Text)
      else
        ShowNotFound(CorrectOrdersForm.Report);
      Result := crClose;
    end
    else begin
      CorrectOrdersForm.ShowModal;
      Result := CorrectOrdersForm.FormResult;
    end;
  finally
    CorrectOrdersForm.Free;
  end;
end;

procedure TCorrectOrdersForm.FormCreate(Sender: TObject);
begin
  FAllowDelayOfPayment := DM.adsUser.FieldByName('AllowDelayOfPayment').AsBoolean;
  FShowSupplierCost := DM.adsUser.FieldByName('ShowSupplierCost').AsBoolean;
  FNetworkParams := TNetworkParams.Create(DM.MainConnection);
  FormResult := crClose;
  Report := TStringList.Create;
  dbgLog.PopupMenu := nil;

  adsCore.Connection := DM.MainConnection;
  adsAvgOrders.Connection := DM.MainConnection;
  
  //todo: ����� ������, �.�. �������� �� ������������
  TframePosition.AddFrame(Self, pClient, dsCore, 'SynonymName', 'MnnId', nil);

  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  adsAvgOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;
  plOverCost.Hide();
  if not adsAvgOrders.Active then
    adsAvgOrders.Open;
  Self.WindowState := wsMaximized;
  SetGridParams(dbgCore);
  SetGridParams(dbgLog);

  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
  PrepareColumnsInOrderGrid(dbgCore);
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);
end;

procedure TCorrectOrdersForm.PrepareData;
var
  ClientName, PriceName : String;
  ClientId, OrderId : Int64;
  AutoId : Int64;

  function GetNextId : Int64;
  var
    LastId : Int64;
  begin
    LastId := AutoId;
    Inc(AutoId);
    Result := LastId;
  end;

  procedure AddOrderInfo();
  begin
    mtLog.Append;
    mtLog.FieldValues['Id'] := OrderId;
    if not ProcessSendOrdersResponse then
      mtLog.FieldValues['ParentId'] := ClientId;
    mtLog.FieldValues['SelfId'] :=
      TLargeintField(DM.adcUpdate.FieldByName('OrderId')).AsLargeInt;
    mtLog.FieldValues['NodeName'] := PriceName;
    mtLog.FieldValues['NodeType'] := Integer(cntOrder);
    mtLog.FieldValues['Send'] := DM.adcUpdate.FieldByName('Send').AsBoolean;
    if not DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      mtLog.FieldValues['Reason'] :=
        DM.adcUpdate.FieldByName('ErrorReason').AsString;
    mtLog.Post;
    if DM.adcUpdate.FieldByName('ErrorReason').IsNull then
      Report.Append(Format('   �����-���� %s', [PriceName]))
    else
      Report.Append(Format('%s�����-���� %s  -  ����������� ����� %s  -  �������� %s',
        [IfThen(not ProcessSendOrdersResponse, '   '),
         PriceName,
         DM.adcUpdate.FieldByName('ServerMinReq').AsString,
         CurrToStr(DM.GetSumOrder(DM.adcUpdate.FieldByName('OrderId').AsInteger, False))]));
  end;

  procedure AddClient();
  begin
    ClientName := DM.adcUpdate.FieldByName('ClientName').AsString;
    PriceName := DM.adcUpdate.FieldByName('PriceName').AsString;
    ClientId := GetNextId;
    OrderId := GetNextId;

    if not ProcessSendOrdersResponse then begin
      mtLog.Append;
      mtLog.FieldValues['Id'] := ClientId;
      mtLog.FieldValues['NodeName'] := ClientName;
      mtLog.FieldValues['NodeType'] := Integer(cntClient);
      mtLog.FieldValues['SelfId'] :=
        TLargeintField(DM.adcUpdate.FieldByName('ClientId')).AsLargeInt;
      mtLog.Post;
    end;

    if not ProcessSendOrdersResponse then
      if DM.adsUser.FieldByName('IsFutureClient').AsBoolean then
        Report.Append(Format('����� ������ %s', [ClientName]))
      else
        Report.Append(Format('������ %s', [ClientName]));

    AddOrderInfo();
  end;

  procedure AddOrder();
  begin
    PriceName := DM.adcUpdate.FieldByName('PriceName').AsString;
    OrderId := GetNextId;

    AddOrderInfo();
  end;

  procedure AddPosition();
  var
    PositionId : Int64;
    PostionReason : String;
    PositionResult : TPositionSendResult;
  begin
    PositionId := GetNextId;

    mtLog.Append;
    mtLog.FieldValues['Id'] := PositionId;
    mtLog.FieldValues['ParentId'] := OrderId;
    mtLog.FieldValues['SelfId'] :=
      TLargeintField(DM.adcUpdate.FieldByName('OrderListId')).AsLargeInt;
    mtLog.FieldValues['NodeName'] :=
      DM.adcUpdate.FieldByName('SynonymName').AsString;
    mtLog.FieldValues['NodeType'] := Integer(cntPosition);
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
      psrDifferentCostAndQuantity :
        begin
          mtLog.FieldValues['OldOrderCount'] :=
            DM.adcUpdate.FieldByName('OldOrderCount').Value;
          mtLog.FieldValues['NewOrderCount'] :=
            DM.adcUpdate.FieldByName('NewOrderCount').Value;
          mtLog.FieldValues['OldPrice'] :=
            DM.adcUpdate.FieldByName('OldPrice').Value;
          mtLog.FieldValues['NewPrice'] :=
            DM.adcUpdate.FieldByName('NewPrice').Value;
        end;
    end;

    mtLog.Post;

    if (PositionResult in [psrNotExists, psrUnoin]) then
      Report.Append( Format( '      %s%s : %s (������ ����: %s; ������ �����: %s)',
        [DM.adcUpdate.FieldByName('SynonymName').AsString,
         IfThen(Length(DM.adcUpdate.FieldByName('SynonymFirm').AsString) > 0,
           ' - ' + DM.adcUpdate.FieldByName('SynonymFirm').AsString),
         PostionReason,
         DM.adcUpdate.FieldByName('OldPrice').AsString,
         DM.adcUpdate.FieldByName('OldOrderCount').AsString]))
    else
      Report.Append( Format( '      %s%s : %s (������ ����: %s; ������ �����: %s; ����� ����: %s; ������� �����: %s)',
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
  AutoId := 1;

  mtLog.Close;
  mtLog.Open;
  mtLog.TreeList.Active := True;

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

  //�������� ������ �������, ��������� �������������
  if ProcessSendOrdersResponse then begin
    mtLogSend.OnChange := mtLogSendChange;
  end;
end;

procedure TCorrectOrdersForm.SetOffers;
var
  ClientId,
  ProductId : Variant;
begin
  ClientId := DM
    .QueryValue(
      'select ClientId from CurrentOrderLists where Id = ' + mtLogSelfId.AsString,
      [],
      []);
  ProductId := DM
    .QueryValue(
      'select ProductId from CurrentOrderLists where Id = ' + mtLogSelfId.AsString,
      [],
      []);
  if adsCore.Active then
    adsCore.Close;
  adsCore.ParamByName('TimeZoneBias').Value := AProc.TimeZoneBias;
  adsCore.ParamByName('ClientId').Value := ClientId;
  adsCore.ParamByName('ProductId').Value := ProductId;
  adsCore.ParamByName( 'DayOfWeek').Value := TDayOfWeekHelper.DayOfWeek();
  adsCore.Open;
  if not adsCore.IsEmpty then
    adsCore.Locate('OrderListId', mtLogSelfId.Value, []);
end;

procedure TCorrectOrdersForm.adsCoreBeforeUpdateExecute(
  Sender: TCustomMyDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if (stUpdate in StatementTypes) or (stRefresh in StatementTypes) then
    //�������� ��������, ����� ��������� "ClientId" �� ����� � ����������� �������
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
      //���� ��� ������, �������� �����
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
        //���� ����� ����������, �������� ����
        if ( Column.Field = adsCoreSYNONYMNAME) or ( Column.Field = adsCoreSYNONYMFIRM)
          then Background := clBtnFace;
      end;

      //���� ��������� �����, �������� ����
      if adsCoreJunk.AsBoolean and (( Column.Field = adsCorePERIOD) or ( Column.Field = adsCoreCOST)) then
        Background := JUNK_CLR;
      //��������� ����� �������� �������
      if adsCoreAwait.AsBoolean and ( Column.Field = adsCoreSYNONYMNAME) then
        Background := AWAIT_CLR;
    end;
  end;
end;

procedure TCorrectOrdersForm.adsCoreCalcFields(DataSet: TDataSet);
begin
  try
    if FAllowDelayOfPayment and not FShowSupplierCost then
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreCost.AsCurrency,
          adsCoreMarkup.AsVariant)
    else
      adsCorePriceRet.AsCurrency :=
        DM.GetRetailCostLast(
          adsCoreRetailVitallyImportant.Value,
          adsCoreRealCost.AsCurrency,
          adsCoreMarkup.AsVariant);
  except
  end;
end;

procedure TCorrectOrdersForm.dbgValuesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
{
  ��� ���� ��������� ���� ��� ������� ������������ ��������
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
    { ��������� ����� �� ������������ ������� ������ �� ������ }
    Val( adsCoreQuantity.AsString,Quantity,E);
    if E<>0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) 
    then begin
      AProc.MessageBox(
        '����� ��������� ������� �� ������, ����� ����� ������� � ���������� ' + adsCoreQuantity.AsString,
        MB_ICONWARNING);
      adsCoreORDERCOUNT.AsInteger := Quantity;
    end;

    PanelCaption := '';

    { ��������� �� ���������� ���� }
    if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*( 1 + Excess / 100)) then
      begin
        PanelCaption := ExcessAvgCostMessage;
      end;
    end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + OrderJunkMessage
      else
        PanelCaption := OrderJunkMessage;

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + WarningOrderCountMessage
      else
        PanelCaption := WarningOrderCountMessage;

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
  //��� ���: ����� ����� �� ����������� �� adsCore �� ����� TOrdersForm  
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

  //�������� �� ������������ ����� ������, ������������ ��������
  if fOrder.AsInteger > MaxOrderCount then begin
    SoftEdit(dsCheckVolume);
    fOrder.AsInteger := MaxOrderCount;
    dsCheckVolume.Post;
  end;

  if (dsCheckVolume.RecordCount > 0) and not CheckVolume then begin
    AProc.MessageBox(
      Format(
        '����������� ���������� ��������� �� ������������ �������.'#13#10 +
        '��������� �������� "%s" �� ������ �������������� �������� "%s".',
        [fOrder.AsString, fVolume.AsString]),
      MB_ICONWARNING);
    ClearOrder;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByOrderCost then begin
    AProc.MessageBox(
      Format(
        '����� ������ "%s" ������ ����������� ����� ������ "%s" �� ������ �������!',
        [fSumOrder.AsString, fOrderCost.AsString]),
      MB_ICONWARNING);
    ClearOrderByOrderCost;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByMinOrderCount then begin
    AProc.MessageBox(
      Format(
        '���������� ���������� "%s" ������ ������������ ���������� "%s" �� ������ �������!',
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
  if not ProcessSendOrdersResponse then
    pTop.Height := Self.ClientHeight div 2;
end;

procedure TCorrectOrdersForm.btnSaveReportClick(Sender: TObject);
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
const
  StartPosition = 16;
  ButtonInterval = 15;
  ButtonWidthIncrease = 30;
var
  VisibleButtons : TObjectList;
  I : Integer;
  currentPosition,
  currentButtonTextWidth : Integer;
  currentButton : TButton;
begin
  VisibleButtons := TObjectList.Create(False);
  try
    if ProcessSendOrdersResponse then begin
      btnClose.Visible := False;
      if DM.adsUser.FieldByName('IsFutureClient').AsBoolean then
        Self.Caption := '������ �������� ������� ��� ������ ������ '
        + DM.adtClientsNAME.AsString
      else
        Self.Caption := '������ �������� ������� ��� ������� '
        + DM.adtClientsNAME.AsString;
      dbgCore.Align := alNone;
      dbgCore.Visible := False;
      pTop.Align := alClient;
      VisibleButtons.Add(btnSaveReport);
      VisibleButtons.Add(btnRetrySend);
      VisibleButtons.Add(btnRefresh);
      VisibleButtons.Add(btnEditOrders);
    end
    else begin
      btnRetrySend.Visible := False;
      btnRefresh.Visible := False;
      btnEditOrders.Visible := False;

      //dbgCore.Align := alNone;
      //dbgCore.Visible := False;
      //pTop.Align := alClient;
      dbgLog.Columns.Items[1].ReadOnly := True;
      VisibleButtons.Add(btnClose);
      VisibleButtons.Add(btnSaveReport);
    end;
    currentPosition := StartPosition;
    for I := 0 to VisibleButtons.Count-1 do begin
      currentButton := TButton(VisibleButtons[i]);
      currentButtonTextWidth := Self.Canvas.TextWidth(currentButton.Caption);
      Inc(currentButtonTextWidth, ButtonWidthIncrease);
      currentButton.Width := currentButtonTextWidth;
      currentButton.Left := currentPosition;
      currentPosition := currentButton.Left + currentButton.Width + ButtonInterval;
    end;
  finally
    VisibleButtons.Free;
  end;
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
    + '  CurrentOrderHeads.ClientId, '
    + '  clients.Name as ClientName, '
    + '  CurrentOrderHeads.OrderId, '
    + '  CurrentOrderHeads.PriceName, '
    + '  CurrentOrderHeads.Send, '
    + '  CurrentOrderHeads.SendResult, '
    + '  CurrentOrderHeads.ErrorReason, '
    + '  CurrentOrderHeads.ServerMinReq, '
    + '  CurrentOrderLists.Id As OrderListId, '
    + '  CurrentOrderLists.SynonymName, '
    + '  CurrentOrderLists.SynonymFirm, '
    + '  CurrentOrderLists.DropReason, '
    + '  CurrentOrderLists.OrderCount as OldOrderCount, '
    + '  if(CurrentOrderLists.ServerQuantity is null, CurrentOrderLists.OrderCount, if(CurrentOrderLists.ServerQuantity > CurrentOrderLists.OrderCount, CurrentOrderLists.OrderCount, CurrentOrderLists.ServerQuantity)) as NewOrderCount, '
    + '  CurrentOrderLists.Price as OldPrice, '
+'                  if(dop.OtherDelay is null, '
+'                      CurrentOrderLists.ServerCost, '
+'                      if(CurrentOrderLists.VitallyImportant || ifnull(catalogs.VitallyImportant, 0), '
+'                          cast(CurrentOrderLists.ServerCost * (1 + dop.VitallyImportantDelay/100) as decimal(18, 2)), '
+'                          cast(CurrentOrderLists.ServerCost * (1 + dop.OtherDelay/100) as decimal(18, 2)) '
+'                       ) '
+'                  ) '
    + '   as NewPrice '
    + 'from '
    + '  CurrentOrderHeads '
    + '  inner join clients   on (clients.clientid = CurrentOrderHeads.ClientId) '
    + '  inner JOIN PricesData cpd  ON (cpd.PriceCode = CurrentOrderHeads.pricecode)'
    + '  left join CurrentOrderLists on CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId and (CurrentOrderLists.DropReason is not null)'
    + '  left join products on products.ProductId = CurrentOrderLists.ProductId '
    + '  left join catalogs on catalogs.FullCode = products.CatalogId '
    + '  left join DelayOfPayments dop on (dop.PriceCode = cpd.PriceCode) and (dop.DayOfWeek = "' + TDayOfWeekHelper.DayOfWeek() + '") '
    + ' '
    + 'where '
    + '    CurrentOrderHeads.ClientId = ' + IntToStr(DM.adtClientsCLIENTID.Value) + '  '
    + 'and CurrentOrderHeads.Closed = 0 '
    + 'and CurrentOrderHeads.Frozen = 0 '
    + 'and CurrentOrderHeads.Send = 1 '
    + 'and CurrentOrderHeads.SendResult is not null '
    + 'order by clients.Name, CurrentOrderHeads.PriceName, CurrentOrderLists.SynonymName, CurrentOrderLists.SynonymFirm';
  end
  else begin
    Result := ''
    + 'select '
    + '  CurrentOrderHeads.ClientId, '
    + '  clients.Name as ClientName, '
    + '  CurrentOrderHeads.OrderId, '
    + '  CurrentOrderHeads.PriceName, '
    + '  CurrentOrderHeads.Send, '
    + '  CurrentOrderHeads.SendResult, '
    + '  CurrentOrderHeads.ErrorReason, '
    + '  CurrentOrderHeads.ServerMinReq, '
    + '  CurrentOrderLists.Id As OrderListId, '
    + '  CurrentOrderLists.SynonymName, '
    + '  CurrentOrderLists.SynonymFirm, '
    + '  CurrentOrderLists.DropReason, '

    + '  CurrentOrderLists.ServerQuantity as OldOrderCount, '
    + '  CurrentOrderLists.OrderCount as NewOrderCount, '
    + '  CurrentOrderLists.ServerCost as OldPrice, '
    + '  CurrentOrderLists.Price as NewPrice '

    + 'from '
    + '  CurrentOrderHeads '
    + '  inner join clients   on (clients.clientid = CurrentOrderHeads.ClientId) '
    + '  inner join CurrentOrderLists on CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId and (CurrentOrderLists.DropReason is not null)'
    + '  inner JOIN PricesData cpd  ON (cpd.PriceCode = CurrentOrderHeads.pricecode)'

    + ' '
    + 'where '
    + '    CurrentOrderHeads.Closed = 0 '
    + 'and CurrentOrderHeads.Frozen = 0 '
    + 'order by clients.Name, CurrentOrderHeads.PriceName, CurrentOrderLists.SynonymName, CurrentOrderLists.SynonymFirm';
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
    if TCorrectNodeType(mtLogNodeType.AsInteger) <> cntOrder then
      TDBGridEh(Sender).Canvas.FillRect(Rect);
  end;
end;

procedure TCorrectOrdersForm.dbgLogGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if TCorrectNodeType(mtLogNodeType.AsInteger) = cntPosition then begin
    //���������� ������� ��� �������
    {
      ��� ���� ��������� ���� ��� ������� ������������ ��������
      Background := RGB(255, 0, 128);
    }
      if (Column.Field = mtLogOldOrderCount) or (Column.Field = mtLogNewOrderCount) then
        if (mtLogOldOrderCount.AsString <> mtLogNewOrderCount.AsString) then
          Background := RGB(239, 82, 117);
      if (Column.Field = mtLogOldPrice) or (Column.Field = mtLogNewPrice) then
        if (mtLogOldPrice.Value * (1 + FNetworkParams.NetworkPositionPercent/100) > mtLogNewPrice.Value) then
          Background := RGB(239, 82, 117);
  end;
end;

procedure TCorrectOrdersForm.mtLogSendChange(Sender: TField);
begin
  DM.adcUpdate.SQL.Text := 'update CurrentOrderHeads set Send = :Send where OrderId = :OrderId';
  DM.adcUpdate.ParamByName('Send').AsBoolean := Sender.AsBoolean;
  DM.adcUpdate.ParamByName('OrderId').Value := mtLogSelfId.Value;
  DM.adcUpdate.Execute;
end;

procedure TCorrectOrdersForm.dbgLogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not ProcessSendOrdersResponse and (Key = VK_RETURN) and not adsCore.IsEmpty
  then
    dbgCore.SetFocus;
end;

procedure TCorrectOrdersForm.SetGridParams(Grid: TToughDBGrid);
begin
  Grid.AllowedSelections := [gstRecordBookmarks, gstRectangle]; 
  Grid.Options := Grid.Options + [dgRowLines];
  Grid.OptionsEh := Grid.OptionsEh + [dghResizeWholeRightPart];
  if CheckWin32Version(5, 1) then
    Grid.OptionsEh := Grid.OptionsEh + [dghTraceColSizing];
  Grid.Font.Size := 10;
  Grid.GridLineColors.DarkColor := clBlack;
  Grid.GridLineColors.BrightColor := clDkGray;
end;

procedure TCorrectOrdersForm.mtLogAfterScroll(DataSet: TDataSet);
begin
  if TCorrectNodeType(mtLogNodeType.AsInteger) = cntPosition then
    SetOffers
  else
    adsCore.Close;
end;

procedure TCorrectOrdersForm.PrepareColumnsInOrderGrid(Grid: TToughDBGrid);
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
    priceRetColumn.Title.Caption := '����.����';
  end;

  ChangeTitleCaption('Quantity', '�������');
  ChangeTitleCaption('OrderCost', '���.�����');
  ChangeTitleCaption('MinOrderCount', '���.���-��');

  realCostColumn := ColumnByNameT(Grid, 'RealCost');
  if not Assigned(realCostColumn) then
    realCostColumn := ColumnByNameT(Grid, 'RealPrice');

  registryCostColumn := ColumnByNameT(Grid, 'RegistryCost');
  if Assigned(registryCostColumn) then begin
    registryCostColumn.Visible := True;
    registryCostColumn.Title.Caption := '������.����';
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
    producerNameColumn.Title.Caption := '���.�������������';
      producerNameColumn.Visible := False;
      producerNameColumn.Width := Grid.Canvas.TextWidth(producerNameColumn.Title.Caption);
    end;
  end;

  if Assigned(realCostColumn) then  begin
    ndsColumn := ColumnByNameT(Grid, 'NDS');
    if not Assigned(ndsColumn) then begin
      ndsColumn := TColumnEh(Grid.Columns.Insert(realCostColumn.Index));
      ndsColumn.FieldName := 'NDS';
      ndsColumn.Title.Caption := '���';
      ndsColumn.Width := Grid.Canvas.TextWidth(ndsColumn.Title.Caption);
    end;
    supplierPriceMarkupColumn := ColumnByNameT(Grid, 'SupplierPriceMarkup');
    if not Assigned(supplierPriceMarkupColumn) then begin
      supplierPriceMarkupColumn := TColumnEh(Grid.Columns.Insert(ndsColumn.Index));
      supplierPriceMarkupColumn.FieldName := 'SupplierPriceMarkup';
      supplierPriceMarkupColumn.Title.Caption := '������� ����������';
      supplierPriceMarkupColumn.Width := Grid.Canvas.TextWidth('00.00');
      supplierPriceMarkupColumn.DisplayFormat := '0.00;;''''';
    end;
    producerCostColumn := ColumnByNameT(Grid, 'ProducerCost');
    if not Assigned(producerCostColumn) then begin
      producerCostColumn := TColumnEh(Grid.Columns.Insert(supplierPriceMarkupColumn.Index));
      producerCostColumn.FieldName := 'ProducerCost';
      producerCostColumn.Title.Caption := '���� �������������';
      producerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      producerCostColumn.DisplayFormat := '0.00;;''''';
    end;
    maxProducerCostColumn := ColumnByNameT(Grid, 'MaxProducerCost');
    if not Assigned(maxProducerCostColumn) then begin
      maxProducerCostColumn := TColumnEh(Grid.Columns.Insert(producerCostColumn.Index));
      maxProducerCostColumn.FieldName := 'MaxProducerCost';
      maxProducerCostColumn.Title.Caption := '����.�����.����';
      maxProducerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      maxProducerCostColumn.DisplayFormat := '0.00;;''''';
    end;
    
    realCostColumn.Title.Caption := '���� ����������';
    realCostColumn.Width := Grid.Canvas.TextWidth('0000.00');
    //������� ������� "���� ��� ��������", ���� �� ������� �������� � ��������� �������
    if not FAllowDelayOfPayment
      or not FShowSupplierCost
    then
      Grid.Columns.Delete(realCostColumn.Index)
    else
      //���� �� �������� �������, �� ������� ������ ������������ �� ���������
      realCostColumn.Visible := True;
  end;
  finally
    Grid.AutoFitColWidths := True;
  end;
end;

procedure TCorrectOrdersForm.FormDestroy(Sender: TObject);
begin
  TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
  inherited;
end;

end.
