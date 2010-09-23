unit PostSomeOrdersController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  //App modules
  Constant, DModule, ExchangeParameters, U_ExchangeLog, SOAPThroughHTTP,
  DatabaseObjects;

const
  //����������� ��������� �� ������� ��� �������� �������
  SendOrdersErrorTexts : array[0..3] of string =
  ('������ ��������.',
   '��������� ���� ���������������� �� ������ ����������.',
   '�������� ������� ��� ������� ������� ���������.',
   '�������� ������� ����������� ��������.');

type
  TOrderSendResult = (osrSuccess, osrLessThanMinReq, osrNeedCorrect);
  TPositionSendResult =
    (psrNotExists, psrDifferentCost, psrDifferentQuantity,
    psrDifferentCostAndQuantity);

const
  //����������� �����������
  OrderSendResultText : array[TOrderSendResult] of string =
  ('����� ��������� �������',
   '��������� ����������� ����� ������.',
   '��������� ������������� ������.');
  PositionSendResultText : array[TPositionSendResult] of string =
  ('����������� �����������',
   '������� �������� � ���� ���������',
   '��������� ���������� ��������� � �����-����� ������ ����������� �����',
   '������� �������� � �����-������ � ���� � ���������� ����������� ���������');

type
  TPostSomeOrdersController = class
   private
    FDataLayer : TDM;
    FExchangeParams : TExchangeParams;
    FForceSend : Boolean;
    FPostParams : TStringList;
    FSOAP : TSOAP;
    FOrderSendSuccess : Boolean;
    FSendedOrders     : TStringList;
    FOrderPostHeaders : TObjectList;
    FUseCorrectOrders : Boolean;

    procedure FillPostParams;
    procedure SendOrders;
    procedure ProcessServerResult;

    procedure FillOrderHeadParams;
    procedure FillOrderDetailParams;

    procedure FillOrderDetailGeneralParams(dataSet : TDataSet);
    procedure FillOrderDetailLeaderParams(dataSet : TDataSet);

    procedure AddPostParam(Param, Value : String);

    function ParsePostHeader(
      serverResponse : TStringList;
      startIndex : Integer) : Integer;
    function FloatToServiceStr(cost : Extended) : String;
   public
    constructor Create(
      dataLayer : TDM;
      exchangeParams : TExchangeParams;
      forceSend : Boolean;
      soap : TSOAP;
      useCorrectOrders : Boolean);
    procedure PostSomeOrders;
    destructor Destroy; override;
  end;

  TPostOrderHeader = class
   public
    ClientOrderId : Int64;
    PostResult    : TOrderSendResult;
    ServerOrderId : Int64;
    ErrorReason   : String;
    ServerMinReq  : String;

    OrderPositions : TObjectList;
    constructor Create(
      clientOrderId : Int64;
      postResult    : TOrderSendResult;
      serverOrderId : Int64;
      errorReason   : String;
      serverMinReq  : String);
    destructor Destroy; override;
  end;

  TPostOrderPosition = class
   public
    ClientPositionID : Int64;
    DropReason       : TPositionSendResult;
    ServerCost       : Currency;
    ServerQuantity   : String;
    constructor Create(
      clientPositionID : Int64;
      dropReason       : TPositionSendResult;
      serverCost       : Currency;
      serverQuantity   : String);
  end;

implementation

uses
  Main, AProc, DBProc;

{ TPostSomeOrdersController }

procedure TPostSomeOrdersController.AddPostParam(Param, Value: String);
begin
  FPostParams.Add(Param + '=' + FSOAP.PreparePostValue(Value));
end;

function TPostSomeOrdersController.FloatToServiceStr(cost: Extended): String;
begin
  Result := FloatToStr(Cost, FDataLayer.FFS);
end;

constructor TPostSomeOrdersController.Create(
  dataLayer: TDM;
  exchangeParams : TExchangeParams;
  forceSend : Boolean;
  soap : TSOAP;
  useCorrectOrders : Boolean);
begin
  FDataLayer := dataLayer;

  FExchangeParams := exchangeParams;
  FExchangeParams.SendedOrders.Clear();
  FExchangeParams.SendedOrdersErrorLog.Clear();

  FForceSend := forceSend;
  FPostParams := TStringList.Create;
  FSendedOrders := TStringList.Create;
  FSOAP := soap;
  FUseCorrectOrders := useCorrectOrders;
end;

destructor TPostSomeOrdersController.Destroy;
begin
  FSendedOrders.Free;
  FPostParams.Free;
  if Assigned(FOrderPostHeaders) then
    FOrderPostHeaders.Free;
  inherited;
end;

procedure TPostSomeOrdersController.FillOrderDetailGeneralParams(
  dataSet: TDataSet);
var
  RetailMarkup : Currency;
begin
  AddPostParam('ClientPositionID', dataSet.FieldByName('Id').AsString);
  AddPostParam('ClientServerCoreID', dataSet.FieldByName('ServerCoreId').AsString);
  AddPostParam('ProductID', dataSet.FieldByName('ProductID').AsString);
  AddPostParam('CodeFirmCr', dataSet.FieldByName('CodeFirmCr').AsString);
  AddPostParam('SynonymCode', dataSet.FieldByName('SynonymCode').AsString);
  AddPostParam('SynonymFirmCrCode', dataSet.FieldByName('SynonymFirmCrCode').AsString);
  AddPostParam('Code', dataSet.FieldByName('Code').AsString);
  AddPostParam('CodeCr', dataSet.FieldByName('CodeCr').AsString);
  AddPostParam('Junk', BoolToStr(dataSet.FieldByName('Junk').AsBoolean, True));
  AddPostParam('Await', BoolToStr(dataSet.FieldByName('Await').AsBoolean, True));
  AddPostParam(
    'RequestRatio',
    IfThen(
      dataSet.FieldByName('RequestRatio').IsNull,
      '',
      dataSet.FieldByName('RequestRatio').AsString));
  AddPostParam(
    'OrderCost',
    IfThen(
      dataSet.FieldByName('OrderCost').IsNull,
      '',
      FloatToServiceStr(dataSet.FieldByName('OrderCost').AsFloat)));
  AddPostParam(
    'MinOrderCount',
    IfThen(
      dataSet.FieldByName('MinOrderCount').IsNull,
      '',
      dataSet.FieldByName('MinOrderCount').AsString));
  AddPostParam(
    'Quantity',
    IfThen(
      dataSet.FieldByName('Ordercount').AsInteger <= MaxOrderCount,
      dataSet.FieldByName('Ordercount').AsString,
      IntToStr(MaxOrderCount)));
  AddPostParam(
    'SupplierPriceMarkup',
    IfThen(
      dataSet.FieldByName('SupplierPriceMarkup').IsNull,
      '',
      FloatToServiceStr(dataSet.FieldByName('SupplierPriceMarkup').AsFloat)));

  AddPostParam('CoreQuantity', dataSet.FieldByName('CoreQuantity').AsString);
  AddPostParam('Unit', dataSet.FieldByName('Unit').AsString);
  AddPostParam('Volume', dataSet.FieldByName('Volume').AsString);
  AddPostParam('Note', dataSet.FieldByName('Note').AsString);
  AddPostParam('Period', dataSet.FieldByName('Period').AsString);
  AddPostParam('Doc', dataSet.FieldByName('Doc').AsString);
  AddPostParam(
    'RegistryCost',
    IfThen(
      dataSet.FieldByName('RegistryCost').IsNull,
      '',
      FloatToServiceStr(dataSet.FieldByName('RegistryCost').AsFloat)));
  AddPostParam('VitallyImportant', BoolToStr(dataSet.FieldByName('VitallyImportant').AsBoolean, True));
  if not FDataLayer.adsUser.FieldByName('SendRetailMarkup').AsBoolean
  then begin
    AddPostParam('RetailMarkup', '');
    FDataLayer.adcUpdate.SQL.Text := 'update CurrentOrderLists set RetailMarkup = null where Id = :Id';
    FDataLayer.adcUpdate.ParamByName('Id').Value := dataSet.FieldByName('Id').AsString;
    FDataLayer.adcUpdate.Execute;
  end
  else begin
    if dataSet.FieldByName('RetailMarkup').IsNull then begin
      RetailMarkup := FDataLayer.GetRetUpCost(dataSet.FieldByName('Price').AsFloat);
      AddPostParam(
        'RetailMarkup',
        FloatToServiceStr(RetailMarkup));
      FDataLayer.adcUpdate.SQL.Text := 'update CurrentOrderLists set RetailMarkup = :RetailMarkup where Id = :Id';
      FDataLayer.adcUpdate.ParamByName('Id').Value := dataSet.FieldByName('Id').AsString;
      FDataLayer.adcUpdate.ParamByName('RetailMarkup').Value := RetailMarkup;
      FDataLayer.adcUpdate.Execute;
    end
    else
      AddPostParam(
        'RetailMarkup',
        FloatToServiceStr(dataSet.FieldByName('RetailMarkup').AsFloat));
  end;

  AddPostParam(
    'ProducerCost',
    IfThen(
      dataSet.FieldByName('ProducerCost').IsNull,
      '',
      FloatToServiceStr(dataSet.FieldByName('ProducerCost').AsFloat)));
  AddPostParam(
    'NDS',
    IfThen(
      dataSet.FieldByName('NDS').IsNull,
      '',
      dataSet.FieldByName('NDS').AsString));
end;

procedure TPostSomeOrdersController.FillOrderDetailLeaderParams(
  dataSet: TDataSet);
var
  TmpOrderCost,
  TmpMinCost : Double;
  postMinCost,
  postMinPriceCode,
  postLeaderMinCost,
  postLeaderMinPriceCode : String;
begin
  postMinCost := '';
  postMinPriceCode := '';
  postLeaderMinCost := '';
  postLeaderMinPriceCode := '';
  try
    if Length(dataSet.FieldByName('RealPRICE').AsString) > 0 then
      TmpOrderCost := dataSet.FieldByName('RealPRICE').AsFloat
    else
      TmpOrderCost := 0.0;
    AddPostParam('Cost', FloatToServiceStr(TmpOrderCost));
  except
    on E : Exception do begin
      WriteExchangeLog('Exchange', '������ ��� ����������� ���� : ' + E.Message
        + '  ������ : "' + dataSet.FieldByName('RealPRICE').AsString + '"');
      raise Exception.
        CreateFmt(
          '��� �������� ������ ��� "%s" ���������� ������������ ���� �� ������� "%s".',
          [FDataLayer.adsOrdersHeaders.FieldByName('PriceName').AsString,
          dataSet.FieldByName('SYNONYMNAME').AsString]);
    end;
  end;

  //���� ���������� ���� - ������������ �������,
  if FDataLayer.adtClientsCALCULATELEADER.AsBoolean then begin

    if FDataLayer.adsOrderCore.Active then
      FDataLayer.adsOrderCore.Close();

    FDataLayer.adsOrderCore.ParamByName( 'RegisterId').Value := RegisterId;
    FDataLayer.adsOrderCore.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
    FDataLayer.adsOrderCore.ParamByName( 'ClientId').Value :=
      FDataLayer.adtClients.FieldByName('ClientId').Value;
    FDataLayer.adsOrderCore.ParamByName( 'ParentCode').Value :=
      dataSet.FieldByName('FullCode').Value;
    FDataLayer.adsOrderCore.ParamByName( 'ShowRegister').Value := False;
    FDataLayer.adsOrderCore.Open;
    try
      FDataLayer.adsOrderCore.FetchAll;
      FDataLayer.adsOrderCore.IndexFieldNames := 'RealCost ASC';

      //�������� ������������ �� ���� �������
      DBProc.SetFilter(FDataLayer.adsOrderCore,
        'JUNK = ' + dataSet.FieldByName( 'Junk').AsString
        + ' and CodeFirmCr = '
        + IfThen(
            dataSet.FieldByName('CodeFirmCr').IsNull,
            'null',
            dataSet.FieldByName('CodeFirmCr').AsString)
        + ' and ProductId = '
        + dataSet.FieldByName('ProductId').AsString);

      FDataLayer.adsOrderCore.First;

      try
        if not FDataLayer.adsOrderCoreRealCost.IsNull then begin
          TmpMinCost := FDataLayer.adsOrderCoreRealCost.AsFloat;
          postMinCost := FloatToServiceStr(TmpMinCost);
          postMinPriceCode := FDataLayer.adsOrderCorePRICECODE.AsString;

          //���� ����������� ���� ��������� � ����� ������, �� ����������� �����-���� - �����-���� ������
          if (Abs(TmpMinCost - TmpOrderCost) < 0.01)
          then
            postMinPriceCode := FDataLayer.adsOrdersHeaders.FieldByName('PriceCode').AsString
        end
        else begin
          postMinCost := '';
          postMinPriceCode := '';
          WriteExchangeLog('Exchange', '�� ������� ����������� ���� �� ���� �������� : '
            + dataSet.FieldByName('FullCode').AsString);
        end;
      except
        on E : Exception do begin
          WriteExchangeLog('Exchange', '������ ��� ����������� ����������� ���� : ' + E.Message
            + '  ������ : "' + FDataLayer.adsOrderCoreRealCOST.AsString + '"');
        end;
      end;

      //�������� ������������ �� �������� �������
      DBProc.SetFilter(FDataLayer.adsOrderCore,
        'JUNK = ' + FDataLayer.adsOrderDetails.FieldByName( 'Junk').AsString +
        ' and CodeFirmCr = ' + IfThen(FDataLayer.adsOrderDetails.FieldByName( 'CodeFirmCr').IsNull, 'null', FDataLayer.adsOrderDetails.FieldByName( 'CodeFirmCr').AsString) +
        ' and ProductId = ' + FDataLayer.adsOrderDetails.FieldByName( 'ProductId').AsString +
        ' and PriceEnabled = True');

      FDataLayer.adsOrderCore.First;

      //� �������� �����-������ ����� �� ���� �����������
      if not FDataLayer.adsOrderCore.IsEmpty then begin
        try
          if not FDataLayer.adsOrderCoreRealCost.IsNull then begin
            TmpMinCost := FDataLayer.adsOrderCoreRealCost.AsFloat;
            postLeaderMinCost := FloatToServiceStr(TmpMinCost);
            postLeaderMinPriceCode := FDataLayer.adsOrderCorePRICECODE.AsString;

            //���� ����������� ���� ������� ��������� � ����� ������ � �����-���� ���� �����, �� ����������� �����-���� - �����-���� ������
            if (FDataLayer.adsOrdersHeaders.FieldByName('PriceEnabled').AsBoolean)
              and (Abs(TmpMinCost - TmpOrderCost) < 0.01)
            then
              postLeaderMinPriceCode := FDataLayer.adsOrdersHeaders.FieldByName('PriceCode').AsString;
          end
          else begin
            postLeaderMinCost := '';
            postLeaderMinPriceCode := '';
            WriteExchangeLog('Exchange', '�� ������� ����������� ���� ����� ������� �� ���� �������� : '
              + dataSet.FieldByName('FullCode').AsString);
          end;
        except
          on E : Exception do begin
            WriteExchangeLog('Exchange', '������ ��� ����������� ����������� ���� ������ : ' + E.Message
              + '  ������ : "' + FDataLayer.adsOrderCoreRealCOST.AsString + '"');
          end;
        end;
      end;

    finally
      FDataLayer.adsOrderCore.Close;
    end;
  end;

  AddPostParam('MinCost', postMinCost);
  AddPostParam('MinPriceCode', postMinPriceCode);
  AddPostParam('LeaderMinCost', postLeaderMinCost);
  AddPostParam('LeaderMinPriceCode', postLeaderMinPriceCode);
end;

procedure TPostSomeOrdersController.FillOrderDetailParams;
begin
  FDataLayer.adsOrderDetails.Close;
  FDataLayer.adsOrderDetails.ParamByName( 'OrderId').Value :=
    FDataLayer.adsOrdersHeaders.FieldByName( 'OrderId').Value;
  FDataLayer.adsOrderDetails.Open;

  try
    while not FDataLayer.adsOrderDetails.Eof do begin
      FillOrderDetailGeneralParams(FDataLayer.adsOrderDetails);
      FillOrderDetailLeaderParams(FDataLayer.adsOrderDetails);
      FDataLayer.adsOrderDetails.Next;
    end;
  finally
    FDataLayer.adsOrderDetails.Close;
  end;
end;

procedure TPostSomeOrdersController.FillOrderHeadParams;
begin
  AddPostParam(
    'ClientOrderID',
    FDataLayer.adsOrdersHeaders.FieldByName( 'OrderId').AsString);
  AddPostParam(
    'PriceCode',
    FDataLayer.adsOrdersHeaders.FieldByName( 'PriceCode').AsString);
  AddPostParam(
    'RegionCode',
    FDataLayer.adsOrdersHeaders.FieldByName( 'RegionCode').AsString);
  AddPostParam(
    'PriceDate',
    GetXMLDateTime(
      FDataLayer.adsOrdersHeaders.FieldByName( 'DatePrice').AsDateTime));
  AddPostParam(
    'ClientAddition',
    StringToCodes(
      FDataLayer.adsOrdersHeaders.FieldByName( 'MessageTO').AsString));
  AddPostParam(
    'RowCount',
    FDataLayer.adsOrdersHeaders.FieldByName( 'Positions').AsString);
  AddPostParam(
    'DelayOfPayment',
    IfThen(
      FDataLayer.adsOrdersHeaders.FieldByName('DelayOfPayment').IsNull,
      '',
      FloatToServiceStr(FDataLayer.adsOrdersHeaders.FieldByName('DelayOfPayment').AsFloat)));
end;

procedure TPostSomeOrdersController.FillPostParams;
begin
  if FDataLayer.adsOrderDetails.Active then
    FDataLayer.adsOrderDetails.Close;
  FDataLayer.adsOrderDetails.SQL.Text := FDataLayer.adsOrderDetailsEtalon.SQL.Text; 
  FDataLayer.adsOrdersHeaders.Close;
  FDataLayer.adsOrdersHeaders.ParamByName( 'ClientId').Value :=
    FDataLayer.adtClients.FieldByName( 'ClientId').Value;
  FDataLayer.adsOrdersHeaders.ParamByName( 'Closed').Value := False;
  FDataLayer.adsOrdersHeaders.ParamByName( 'Send').Value := True;
  FDataLayer.adsOrdersHeaders.ParamByName( 'TimeZoneBias').Value := 0;
  FDataLayer.adsOrdersHeaders.Open;
  if FDataLayer.adsOrdersHeaders.Eof then begin
    FDataLayer.adsOrdersHeaders.Close;
    Exit;
  end;

  AddPostParam('UniqueID', IntToHex( GetCopyID, 8));
  AddPostParam('EXEVersion', GetLibraryVersionFromPathForExe(ExePath + ExeName));
  if not FUseCorrectOrders then
    AddPostParam('ForceSend', BoolToStr( True, True))
  else
    AddPostParam('ForceSend', BoolToStr( FForceSend, True));
  AddPostParam('UseCorrectOrders', BoolToStr( FUseCorrectOrders, True));
  AddPostParam(
    'ClientCode', FDataLayer.adtClients.FieldByName( 'ClientId').AsString);
  AddPostParam(
    'OrderCount', IntToStr(FDataLayer.adsOrdersHeaders.RecordCount));

  try
    while not FDataLayer.adsOrdersHeaders.Eof do begin
      FSendedOrders.Add(
        FDataLayer.adsOrdersHeaders.FieldByName( 'OrderId').AsString);
      FillOrderHeadParams;
      FillOrderDetailParams;
      WriteExchangeLog(
        'Exchange',
        Format('������� �������� ������ %s �� ������ %s-%s (%s) �� %s � ���-��� ������� %d',
          [FDataLayer.adsOrdersHeaders.FieldByName('OrderId').AsString,
          FDataLayer.adsOrdersHeaders.FieldByName('PriceName').AsString,
          FDataLayer.adsOrdersHeaders.FieldByName('RegionName').AsString,
          FDataLayer.adsOrdersHeaders.FieldByName('PriceCode').AsString,
          FDataLayer.adsOrdersHeaders.FieldByName('DatePrice').AsString,
          FDataLayer.adsOrdersHeaders.FieldByName('Positions').AsInteger]));
      FDataLayer.adsOrdersHeaders.Next;
    end;
  finally
    FDataLayer.adsOrdersHeaders.Close;
  end;
end;

function TPostSomeOrdersController.ParsePostHeader(
  serverResponse: TStringList; startIndex: Integer): Integer;
var
  currentHeader : TPostOrderHeader;
begin
  currentHeader :=
    TPostOrderHeader.Create(
      StrToInt64(serverResponse.ValueFromIndex[startIndex]),
      TOrderSendResult(StrToInt(serverResponse.ValueFromIndex[startIndex + 1])),
      StrToInt64(serverResponse.ValueFromIndex[startIndex + 2]),
      Utf8ToAnsi(serverResponse.ValueFromIndex[startIndex + 3]),
      serverResponse.ValueFromIndex[startIndex + 4]);
  FOrderPostHeaders.Add(currentHeader);

  startIndex := startIndex + 5;
  while (startIndex < serverResponse.Count)
        and (AnsiCompareText(serverResponse.Names[startIndex], 'ClientPositionID') = 0)
  do begin
    currentHeader.OrderPositions.Add(
      TPostOrderPosition.Create(
        StrToInt64(serverResponse.ValueFromIndex[startIndex]),
        TPositionSendResult(StrToInt(serverResponse.ValueFromIndex[startIndex + 1])),
        StrToCurr(serverResponse.ValueFromIndex[startIndex + 2], FDataLayer.FFS),
        serverResponse.ValueFromIndex[startIndex + 3]
      )
    );
    startIndex := startIndex + 4;
  end;
  Result := startIndex;
end;

procedure TPostSomeOrdersController.PostSomeOrders;
begin
  FillPostParams;

  if FPostParams.Count > 0 then begin
    SendOrders;

    ProcessServerResult;
  end;
end;

procedure TPostSomeOrdersController.ProcessServerResult;
var
  I,
  J : Integer;
  currentHeader : TPostOrderHeader;
  SendDate : TDateTime;
  currentPosition : TPostOrderPosition;
  priceName, regionName : String;
  LastPostedOrderId : Variant;
begin
  //���������� ��� ���� ������������ ������� ��������� ������,
  //�.�. ��� ��� ����� ������������� ��������� ������
  FDataLayer.adcUpdate.SQL.Text :=
    DM.GetClearSendResultSql(
      TLargeintField(FDataLayer.adtClients.FieldByName('ClientId')).AsLargeInt);
  FDataLayer.adcUpdate.Execute;

  //���� �������� ������ � ���� ������� � ���� ������ ���� ���� � �� ��
  SendDate := Now;
  if not FUseCorrectOrders or FOrderSendSuccess then begin
    //����� ����� ��������� ������
    for I := 0 to FOrderPostHeaders.Count-1 do begin
      currentHeader := TPostOrderHeader(FOrderPostHeaders[i]);

      if currentHeader.PostResult <> osrSuccess then
        Continue;

      FDataLayer.adcUpdate.SQL.Text := ''
        +'update '
        +'  CurrentOrderHeads '
        +'set '
        +'  Send = 1, Closed = 1, SendDate = :SendDate, '
        +'  ServerOrderId = :ServerOrderId, '
        +'  SendResult = null, '
        +'  ErrorReason = null, '
        +'  ServerMinReq = null '
        +'where '
        +'  OrderID = :OrderId;'
        +'update '
        +'  CurrentOrderLists '
        +'set '
        +'  CoreId = NULL, '
        +'  DropReason = NULL, '
        +'  ServerCost = NULL, '
        +'  ServerQuantity = NULL '
        +'where '
        +'  ORDERId = :OrderId;';
      FDataLayer.adcUpdate.ParamByName('SendDate').Value := SendDate;
      FDataLayer.adcUpdate.ParamByName('ServerOrderId').Value :=
        currentHeader.ServerOrderId;
      FDataLayer.adcUpdate.ParamByName('OrderId').Value :=
        currentHeader.ClientOrderId;
      FDataLayer.adcUpdate.Execute;

      FDataLayer.adcUpdate.SQL.Text := ''
        +'insert into '
        +'  PostedOrderHeads '
        +'  (SERVERORDERID, CLIENTID, PRICECODE, REGIONCODE, PRICENAME, RegionName, '
        +'   OrderDate, SendDate, Closed, Send, Comments, MessageTo, SendResult, '
        +'   ErrorReason, ServerMinReq, DelayOfPayment, PriceDate) '
        +'select '
        +'   CurrentOrderHeads.SERVERORDERID, CurrentOrderHeads.CLIENTID, CurrentOrderHeads.PRICECODE, CurrentOrderHeads.REGIONCODE, CurrentOrderHeads.PRICENAME, CurrentOrderHeads.RegionName, '
        +'   CurrentOrderHeads.OrderDate, CurrentOrderHeads.SendDate, CurrentOrderHeads.Closed, CurrentOrderHeads.Send, CurrentOrderHeads.Comments, CurrentOrderHeads.MessageTo, CurrentOrderHeads.SendResult, '
        +'   CurrentOrderHeads.ErrorReason, CurrentOrderHeads.ServerMinReq, CurrentOrderHeads.DelayOfPayment, pricesdata.DATEPRICE '
        +'from '
        +'  CurrentOrderHeads '
        +'  inner join pricesdata on pricesdata.PriceCode = CurrentOrderHeads.PriceCode '
        +'where '
        +'  OrderID = :OrderId;'
        +'set @LastPostedOrderId = last_insert_id();'
        +' '
        +' '
        +'insert into '
        +'  PostedOrderLists '
        +'  (ORDERID, CLIENTID, CoreId, ProductId, CodeFirmcr, SynonymCode, '
        +'   SynonymFirmCrCode, Code, CodeCr, SynonymName, SynonymFirm, '
        +'   Price, Await, Junk, OrderCount, RequestRatio, OrderCost, '
        +'   MinOrderCount, RealPrice, DropReason, ServerCost, ServerQuantity, '
        +'   SupplierPriceMarkup, CoreQuantity, ServerCoreID, '
        +'   Unit, Volume, Note, Period, Doc, RegistryCost, VitallyImportant, '
        +'   RetailMarkup, ProducerCost, NDS) '
        +'select '
        +'   @LastPostedOrderId, CLIENTID, CoreId, ProductId, CodeFirmcr, SynonymCode, '
        +'   SynonymFirmCrCode, Code, CodeCr, SynonymName, SynonymFirm, '
        +'   Price, Await, Junk, OrderCount, RequestRatio, OrderCost, '
        +'   MinOrderCount, RealPrice, DropReason, ServerCost, ServerQuantity, '
        +'   SupplierPriceMarkup, CoreQuantity, ServerCoreID, '
        +'   Unit, Volume, Note, Period, Doc, RegistryCost, VitallyImportant, '
        +'   RetailMarkup, ProducerCost, NDS '
        +'from '
        +'  CurrentOrderLists '
        +'where '
        +'  OrderID = :OrderId;'
        +' '
        +' '
        +' delete CurrentOrderHeads, CurrentOrderLists'
        +' FROM CurrentOrderHeads, CurrentOrderLists '
        +' where '
        +'     (CurrentOrderHeads.OrderId = :OrderId)'
        +' and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)'
        ;
      FDataLayer.adcUpdate.ParamByName('OrderId').Value :=
        currentHeader.ClientOrderId;
      FDataLayer.adcUpdate.Execute;

      LastPostedOrderId := FDataLayer.QueryValue('select @LastPostedOrderId', [], []);

      WriteExchangeLog(
        'Exchange',
        Format('����� %d ������� ���������, Id ������ �� �������: %d',
          [currentHeader.ClientOrderId,
          currentHeader.ServerOrderId]));

      FExchangeParams.SendedOrders.Add(VarToStr(LastPostedOrderId));
    end;

    DatabaseController.BackupDataTable(doiPostedOrderHeads);
    DatabaseController.BackupDataTable(doiPostedOrderLists);
    DatabaseController.BackupDataTable(doiCurrentOrderHeads);
    DatabaseController.BackupDataTable(doiCurrentOrderLists);

  end;
  if not FOrderSendSuccess then begin
    for I := 0 to FOrderPostHeaders.Count-1 do begin
      currentHeader := TPostOrderHeader(FOrderPostHeaders[i]);
      if currentHeader.PostResult = osrSuccess then
        Continue;

      FDataLayer.GetOrderInfo(
        currentHeader.ClientOrderId,
        priceName,
        regionName);

      WriteExchangeLog(
        'Exchange',
        Format('����� %d �� ��� ���������. �������: %s  ����� �������: %s',
          [currentHeader.ClientOrderId,
          OrderSendResultText[currentHeader.PostResult],
          currentHeader.ErrorReason]));

      case currentHeader.PostResult of
        osrLessThanMinReq :
          FExchangeParams.SendedOrdersErrorLog.Add(
            Format('����� � %d �� �����-����� %s (%s) �� ��� ���������. ������� : %s',
              [currentHeader.ClientOrderId,
               priceName,
               regionName,
               currentHeader.ErrorReason])
          );
        osrNeedCorrect :
          FExchangeParams.SendedOrdersErrorLog.Add(
            Format(
              '����� � %d �� �����-����� %s (%s) �� ��� ���������. ������� : '
                + '�������� � ������� �����-������ �� �������.',
              [currentHeader.ClientOrderId,
               priceName,
               regionName])
          );
        else
          FExchangeParams.SendedOrdersErrorLog.Add(
            Format('����� � %d �� �����-����� %s (%s) �� ��� ���������. ��� ������: %d  ������� : %s',
              [currentHeader.ClientOrderId,
               priceName,
               regionName,
               Integer(currentHeader.PostResult),
               currentHeader.ErrorReason])
          );
      end;

      FDataLayer.adcUpdate.SQL.Text := ''
        +'update '
        +'  CurrentOrderHeads '
        +'set '
        +'  SendResult = :SendResult, '
        +'  ErrorReason = :ErrorReason, '
        +'  ServerMinReq = :ServerMinReq '
        +'where '
        +'  CurrentOrderHeads.OrderId = :ClientOrderId; ';
      FDataLayer.adcUpdate.ParamByName('SendResult').Value :=
        Integer(currentHeader.PostResult);
      if Length(currentHeader.ErrorReason) > 0 then
        FDataLayer.adcUpdate.ParamByName('ErrorReason').Value :=
          currentHeader.ErrorReason
      else
        FDataLayer.adcUpdate.ParamByName('ErrorReason').Clear;
      if Length(currentHeader.ServerMinReq) > 0 then
        FDataLayer.adcUpdate.ParamByName('ServerMinReq').Value :=
          currentHeader.ServerMinReq
      else
        FDataLayer.adcUpdate.ParamByName('ServerMinReq').Clear;
      FDataLayer.adcUpdate.ParamByName('ClientOrderId').Value :=
        currentHeader.ClientOrderId;
      FDataLayer.adcUpdate.Execute;

      for J := 0 to currentHeader.OrderPositions.Count-1 do begin
        currentPosition := TPostOrderPosition(currentHeader.OrderPositions[j]);
        if currentPosition.DropReason = psrNotExists then begin
          FDataLayer.adcUpdate.SQL.Text := ''
            +'update '
            +'  CurrentOrderLists '
            +'set '
            +'  DropReason = :DropReason, '
            +'  ServerCost = RealPrice, '
            +'  ServerQuantity = OrderCount '
            +'where '
            +'  CurrentOrderLists.ID = :ClientPositionId; ';
        end
        else begin
          FDataLayer.adcUpdate.SQL.Text := ''
            +'update '
            +'  CurrentOrderLists '
            +'set '
            +'  DropReason = :DropReason, '
            +'  ServerCost = :ServerCost, '
            +'  ServerQuantity = :ServerQuantity '
            +'where '
            +'  CurrentOrderLists.ID = :ClientPositionId; ';
          FDataLayer.adcUpdate.ParamByName('ServerCost').Value :=
            currentPosition.ServerCost;
          if Length(currentPosition.ServerQuantity) > 0 then
            FDataLayer.adcUpdate.ParamByName('ServerQuantity').Value :=
              currentPosition.ServerQuantity
          else
            FDataLayer.adcUpdate.ParamByName('ServerQuantity').Clear;
        end;
        FDataLayer.adcUpdate.ParamByName('DropReason').Value :=
          Integer(currentPosition.DropReason);
        FDataLayer.adcUpdate.ParamByName('ClientPositionId').Value :=
          currentPosition.ClientPositionID;
        FDataLayer.adcUpdate.Execute;
      end;
    end;
  end;
end;

procedure TPostSomeOrdersController.SendOrders;
var
  rawResult,
  soapResult : String;
  serverResponse : TStringList;
  Index : Integer;
begin
{
  if FileExists('PostSomeOrders.txt') then
    DeleteFile('PostSomeOrders.txt');
  FPostParams.SaveToFile('PostSomeOrders.txt');
}    
  soapResult := FSOAP.SimpleInvoke('PostSomeOrdersFullEx', FPostParams);
  rawResult := soapResult;

  serverResponse := TStringList.Create;
  try
    { QueryResults.DelimitedText �� �������� ��-�� �������, ������� ������-�� ��������� ������������ }
    while soapResult <> '' do
      serverResponse.Add(GetNextWord(soapResult, ';'));

    if Length(serverResponse.Values['Error']) > 0 then
      raise Exception
        .Create(
          Utf8ToAnsi(serverResponse.Values['Error']) + #13#10
          + Utf8ToAnsi(serverResponse.Values['Desc']));

    //������������, ��� ��� ������ ���� ���������� �������,
    //���� ���� �� ���� �� ����� ��������� �������, �� ���� ����������
    //������������ ������
    FOrderSendSuccess := True;
    Index := 0;
    FOrderPostHeaders := TObjectList.Create(True);

    try
      while (Index < serverResponse.Count) do begin
        if AnsiCompareText(serverResponse.Names[Index], 'ClientOrderID') = 0
        then begin
          Index := ParsePostHeader(serverResponse, Index);
          if TPostOrderHeader(FOrderPostHeaders[FOrderPostHeaders.Count-1])
            .PostResult in [osrLessThanMinReq, osrNeedCorrect]
          then
            FOrderSendSuccess := False;
        end
        else
          raise Exception.CreateFmt(
            '����������� �������� ��� ������� ��������� ������ : %s',
            [serverResponse.Names[Index]]);
      end;

      if FSendedOrders.Count <> FOrderPostHeaders.Count then begin
        raise Exception.Create('���-�� �������������� ������� �� ��������� � ���-��� ������������');
      end;
    except
      on E : Exception do begin
        FOrderSendSuccess := False;
        //��� ������� ������ ���������� �������� ������� �� �������,
        //�������� ������ � �������� "�����" �����
        WriteExchangeLog('Exchange', 'CurrentIndex = ' + IntToStr(Index));
        if Index < serverResponse.Count then
          WriteExchangeLog('Exchange', 'CurrentRow = ' + serverResponse[Index]);
        WriteExchangeLog('Exchange', 'PostSendOrderServerResult ='#13#10
          + rawResult);
        raise;
      end;
    end;
  finally
    serverResponse.Free;
  end;
end;

{ TPostOrderHeader }

constructor TPostOrderHeader.Create(clientOrderId: Int64;
  postResult: TOrderSendResult; serverOrderId: Int64; errorReason: String;
  serverMinReq  : String);
begin
  OrderPositions := TObjectList.Create(True);
  Self.ClientOrderId := clientOrderId;
  Self.PostResult := postResult;
  Self.ServerOrderId := serverOrderId;
  Self.ErrorReason := errorReason;
  Self.ServerMinReq := serverMinReq;
end;

destructor TPostOrderHeader.Destroy;
begin
  OrderPositions.Free;
  inherited;
end;

{ TPostOrderPosition }

constructor TPostOrderPosition.Create(clientPositionID: Int64;
  dropReason: TPositionSendResult; serverCost: Currency;
  serverQuantity: String);
begin
  Self.ClientPositionID := clientPositionID;
  Self.DropReason := dropReason;
  Self.ServerCost := serverCost;
  Self.ServerQuantity := serverQuantity;
end;

end.
