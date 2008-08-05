unit U_SendArchivedOrdersThread;

interface

uses
  Classes, SysUtils, Windows, StrUtils, DModule, IdHTTP, IdSSLOpenSSL, AProc,
  SOAPThroughHTTP, Contnrs, pFIBDataSet, pFIBProps, U_RecvThread;

type
  TSendArchivedOrdersThread = class(TReceiveThread)
   private
    procedure FillFileList(ASoapResult : String; AFileList : TStringList);
   protected
    procedure Execute; override;
    //Отправка файлов от клиента на сервер
    procedure SendFileFromClient;
    //Отправка архивных заказов на сервер
    procedure SendArchivedOrders;
    procedure SendArchivedOrder(ServerOrderId : Int64; adsOrderData : TpFIBDataSet);
  end;

implementation

uses
  Exchange, Main;
  
{ TSendArchivedOrdersThread }

procedure TSendArchivedOrdersThread.Execute;
var
  SleepCount : Integer;
begin
  try
    //Ждем некоторое время пока запустить процесс получения данных (15 сек)
    SleepCount := 0;
    while not Terminated and (SleepCount < 30) do begin
      Sleep(500);
      Inc(SleepCount);
    end;
    if Terminated then exit;

    FSOAP := TSOAP.Create(FURL, FHTTPName, FHTTPPass, OnConnectError, ReceiveHTTP);
    try

     if Terminated then exit;

     if eaSendOrders in ExchangeForm.ExchangeActs then
       SendArchivedOrders();

     if Terminated then exit;

      SendFileFromClient();
    finally
      FSOAP.Free;
    end;

  except
    on E : Exception do begin
      Log('SendArchivedOrders', 'Ошибка : ' + E.Message);
    end;
  end;
end;

procedure TSendArchivedOrdersThread.FillFileList(ASoapResult: String;
  AFileList: TStringList);
var
  FileName : String;
  DeletedMark : String;
begin
  while (Length(ASoapResult) > 0) do begin
    FileName := GetNextWord(ASoapResult, '|');
    DeletedMark := GetNextWord(ASoapResult, '|');
    //Если есть что-то
    if (Length(FileName) > 0) and ((DeletedMark = '0') or (DeletedMark = '1'))
    then begin
      //Формируем абсолютное имя файла
      FileName := ExtractFilePath(ParamStr(0)) + FileName;
      if FileExists(FileName) then
        AFileList.AddObject(FileName, TObject(StrToInt(DeletedMark)));
    end;
  end;
end;

procedure TSendArchivedOrdersThread.SendArchivedOrder(ServerOrderId: Int64;
  adsOrderData: TpFIBDataSet);
const
  OrderParamCount : Integer = 14;
var
	params, values: array of string;
  I : Integer;
  S,
  ResError : String;
  Res : TStrings;
begin
  if adsOrderData.Active then
    adsOrderData.Close();
  adsOrderData.ParamByName('AServerOrderId').Value := ServerOrderId;
  adsOrderData.Open();
  try
    if not adsOrderData.IsEmpty then begin
      Log('SendArchivedOrders', Format('Отправка архивного заказа ClientOrderId=%s ServerOrderId=%d по прайсу #%s',
        [adsOrderData.FieldByName( 'OrderId').AsString, ServerOrderId, adsOrderData.FieldByName( 'PriceCode').AsString]));

		  SetLength( params, 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 3);
      SetLength( values, 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 3);

      params[ 0] := 'ClientCode';
      params[ 1] := 'PriceCode';
      params[ 2] := 'RegionCode';
      params[ 3] := 'PriceDate';
      params[ 4] := 'ClientAddition';
      params[ 5] := 'RowCount';
      values[ 0] := adsOrderData.FieldByName( 'ClientId').AsString;
      values[ 1] := adsOrderData.FieldByName( 'PriceCode').AsString;
      values[ 2] := adsOrderData.FieldByName( 'RegionCode').AsString;
      //Дата отправляется текущая, т.к. архивный заказ сделал непонятно по какому-прайсу
      values[ 3] := GetXMLDateTime( Now );
      values[ 4] := StringToCodes( adsOrderData.FieldByName( 'MessageTO').AsString);
      values[ 5] := IntToStr( adsOrderData.RecordCountFromSrv);

      for i := 0 to adsOrderData.RecordCountFromSrv - 1 do
      begin
        params[ i * OrderParamCount + 6] := 'ProductId';
        params[ i * OrderParamCount + 7] := 'CodeFirmCr';
        params[ i * OrderParamCount + 8] := 'SynonymCode';
        params[ i * OrderParamCount + 9] := 'SynonymFirmCrCode';
        params[ i * OrderParamCount + 10] := 'Code';
        params[ i * OrderParamCount + 11] := 'CodeCr';
        params[ i * OrderParamCount + 12] := 'Quantity';
        params[ i * OrderParamCount + 13] := 'Junk';
        params[ i * OrderParamCount + 14] := 'Await';
        params[ i * OrderParamCount + 15] := 'Cost';
        values[ i * OrderParamCount + 6] := adsOrderData.FieldByName( 'ProductId').AsString;
        values[ i * OrderParamCount + 7] := adsOrderData.FieldByName( 'CodeFirmCr').AsString;
        values[ i * OrderParamCount + 8] := adsOrderData.FieldByName( 'SynonymCode').AsString;
        values[ i * OrderParamCount + 9] := adsOrderData.FieldByName( 'SynonymFirmCrCode').AsString;
        values[ i * OrderParamCount + 10] := adsOrderData.FieldByName( 'Code').AsString;
        values[ i * OrderParamCount + 11] := adsOrderData.FieldByName( 'CodeCr').AsString;
        values[ i * OrderParamCount + 12] := adsOrderData.FieldByName( 'Ordercount').AsString;
        values[ i * OrderParamCount + 13] := BoolToStr( adsOrderData.FieldByName( 'Junk').AsBoolean, True);
        values[ i * OrderParamCount + 14] := BoolToStr( adsOrderData.FieldByName( 'Await').AsBoolean, True);

        if Length(adsOrderData.FieldByName( 'SENDPRICE').AsString) > 0 then
          S := adsOrderData.FieldByName( 'SENDPRICE').AsString
        else
          S := CurrToStr(0.0);
        S := StringReplace(S, DM.FFS.DecimalSeparator, '.', [rfReplaceAll]);
        values[ i * OrderParamCount + 15] := S;

        params[ i * OrderParamCount + 16] := 'MinCost';
        params[ i * OrderParamCount + 17] := 'MinPriceCode';
        params[ i * OrderParamCount + 18] := 'LeaderMinCost';
        params[ i * OrderParamCount + 19] := 'LeaderMinPriceCode';

        adsOrderData.Next;
      end;

      //Передаем уникальный идентификатор
      params[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount ] := 'UniqueID';
      values[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount ] := IntToHex( GetCopyID, 8);
      params[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 1] := 'ClientOrderID';
      values[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 1] := adsOrderData.FieldByName( 'OrderId').AsString;
      params[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 2] := 'ServerOrderId';
      values[ 6 + adsOrderData.RecordCountFromSrv * OrderParamCount + 2] := IntToStr(ServerOrderId);

			Res := FSOAP.Invoke( 'PostOrder', params, values);
			// проверяем отсутствие ошибки при удаленном запросе
			ResError := Utf8ToAnsi( Res.Values[ 'Error']);
			if ResError <> '' then
        Log('SendArchivedOrders', Format('Ошибка при отправке архивного заказа: %s - %s',
          [ResError, Utf8ToAnsi( Res.Values[ 'Desc'])]));
    end
    else
      Log('SendArchivedOrders', Format('Архивный заказ с ID %d не найден', [ServerOrderId]));
  finally
    adsOrderData.Close();
  end;
end;

procedure TSendArchivedOrdersThread.SendArchivedOrders;
var
  Res, OrdersList : TStrings;
  I : Integer;
  ServerOrderId : Int64;
  adsOrderData : TpFIBDataSet;
begin
  adsOrderData := TpFIBDataSet.Create(nil);

  try
    adsOrderData.Database := DM.MainConnection1;
    adsOrderData.Transaction := DM.MainConnection1.DefaultTransaction;
    adsOrderData.UpdateTransaction := DM.MainConnection1.DefaultUpdateTransaction;
    adsOrderData.SelectSQL.Text := 'SELECT OrdersH.serverorderid, OrdersH.orderid, Orders.orderid, OrdersH.clientid, OrdersH.pricecode, OrdersH.regioncode, null as PriceDate, OrdersH.messageto, ' +
      'Orders.CoreId, Orders.productid, Orders.codefirmcr, Orders.synonymcode, Orders.synonymfirmcrcode, Orders.code, Orders.codecr, Orders.synonymname, Orders.synonymfirm, Orders.price, Orders.await, ' +
      'Orders.junk, Orders.ordercount, Orders.SendPrice*Orders.OrderCount AS SumOrder, Orders.SendPrice,  core.requestratio, core.ordercost, core.minordercount ' +
      'FROM OrdersH inner join Orders on Orders.orderid = ordersh.orderid left join core on core.coreid = orders.coreid ' +
      'WHERE  (ordersh.serverorderid = :AServerOrderId) AND (OrderCount>0) ORDER BY SynonymName, SynonymFirm';
    adsOrderData.Options := adsOrderData.Options - [poTrimCharFields];

    OrdersList := TStringList.Create;
    try
      if Terminated then exit;
      Res := FSOAP.Invoke('GetArchivedOrdersList', [], []);
      Log('SendArchivedOrders', 'ArchivedList : ' + IntToStr(Res.Count));
      if Terminated then exit;

      OrdersList.Clear();
      OrdersList.AddStrings(Res);
      for I := 0 to OrdersList.Count-1 do begin
        ServerOrderId := 0;
        if TryStrToInt64(OrdersList[i], ServerOrderId) then
          SendArchivedOrder(ServerOrderId, adsOrderData)
        else
          Log('SendArchivedOrders', 'Не получилось конвертировать ID заказа : "' + OrdersList[i] + '"');
      end;
    finally
      OrdersList.Free;
    end;
  finally
    adsOrderData.Free;
  end;
end;

procedure TSendArchivedOrdersThread.SendFileFromClient;
var
	LibVersions: TObjectList;
  ParamNames, ParamValues : array of String;
  fi : TFileUpdateInfo;
  SoapResult : String;
  FileList : TStringList;
  I : Integer;
begin
  LibVersions := AProc.GetLibraryVersionFromAppPath;
  try
    SetLength(ParamNames, LibVersions.Count*3);
    SetLength(ParamValues, LibVersions.Count*3);
    for I := 0 to LibVersions.Count-1 do begin
      fi := TFileUpdateInfo(LibVersions[i]);
      ParamNames[i*3] := 'LibraryName';
      ParamValues[i*3] := fi.FileName;
      ParamNames[i*3+1] := 'LibraryVersion';
      ParamValues[i*3+1] := fi.Version;
      ParamNames[i*3+2] := 'LibraryHash';
      ParamValues[i*3+2] := fi.MD5;
    end;
  finally
    LibVersions.Free;
  end;

  if Terminated then exit;

  SoapResult := FSOAP.SimpleInvoke('GetInfo', ParamNames, ParamValues);

  if Terminated then exit;

  if (Length(SoapResult) > 0) and not Terminated then begin
    FileList := TStringList.Create;
    try
      FillFileList(SoapResult, FileList);

      if Terminated then exit;

      AProc.InternalDoSendLetter(ReceiveHTTP, FURL, 'AFRec', FileList, 'Файлы от клиента', 'Смотри вложение');

      for I := 0 to FileList.Count-1 do
        if Integer(FileList.Objects[i]) = 1 then
          OSDeleteFile(FileList[i], False);
    finally
      FileList.Free;
    end;
  end;
end;

end.
