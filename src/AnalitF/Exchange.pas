unit Exchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ARas, StrUtils, ComObj,
  Variants, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExchangeThread, CheckLst, DateUtils,
  ActnList, Math, IdAuthentication, IdAntiFreezeBase, IdAntiFreeze, WinSock,
  IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, Contnrs,
  IdIOHandlerStack, IdSSL, U_VistaCorrectForm, ExchangeParameters,
  GlobalExchangeParameters,
  U_CurrentOrderItem,
  U_CurrentOrderHead,
  U_Address,
  U_DBMapping;

{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}

type
  TExchangeAction=(
    eaGetPrice,
    eaSendOrders,
    eaImportOnly,
    eaGetFullData,
    eaMDBUpdate,
    eaGetWaybills,
    eaSendLetter,
    eaForceSendOrders,
    eaSendWaybills,
    eaPostOrderBatch,
    eaGetHistoryOrders);

  TExchangeActions=set of TExchangeAction;

  TExchangeForm = class(TVistaCorrectForm)
    btnCancel: TButton;
    Timer: TTimer;
    ProgressBar: TProgressBar;
    Ras: TARas;
    TotalProgress: TProgressBar;
    Image1: TImage;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    lblElapsed: TLabel;
    stStatus: TLabel;
    Timer1: TTimer;
    HTTP: TIdHTTP;
    HTTPReclame: TIdHTTP;
    sslMain: TIdSSLIOHandlerSocketOpenSSL;
    sslReclame: TIdSSLIOHandlerSocketOpenSSL;
    httpReceive: TIdHTTP;
    sslReceive: TIdSSLIOHandlerSocketOpenSSL;
    procedure RasStateChange(Sender: TObject; State: Integer;
      StateStr: String);
    procedure TimerTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HTTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
  private
    FStatusPosition: Integer;
    ExchangeActions: TExchangeActions;
    StartTime: TTime;
    ConnectCount: integer;
    ConnectPause: cardinal;

    //����� ������, ������� ���������
    ErrMsg: string;

    //���������� ���������� ������
    FStatusStr      : String;

    function GetAppHandle: HWND;
    function GetStatusText: string;
    procedure SetStatusText(Value: string);
    procedure SetStatusPosition(Value: Integer);
    procedure SetRasParams;
    procedure SetHTTPParams;
  public
    DoStop: Boolean;

    property StatusText: string read GetStatusText write SetStatusText;
    property StatusPosition: Integer write SetStatusPosition;
    property ExchangeActs: TExchangeActions read ExchangeActions write ExchangeActions;
    property AppHandle: HWND read GetAppHandle;
    procedure CheckStop;
    function PauseAfterError : TModalResult;
  end;

var
  ExchangeForm: TExchangeForm;
  ExThread: TExchangeThread;
  NeedRetrySendOrder : Boolean;
  NeedEditCurrentOrders : Boolean;
  BatchFileName : String;

procedure TryToRepareOrders();
procedure PrintOrdersAfterSend;
function RunExchange(AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;

implementation

uses Main, AProc, DModule, Retry, NotFound, Constant, Compact, NotOrders,
  CompactThread, DB, SQLWaiting, U_ExchangeLog, OrdersH, Orders,
  Child, Config, RxMemDS, CorrectOrders, PostSomeOrdersController,
  PostWaybillsController,
  DocumentHeaders,
  U_OrderBatchForm,
  SendWaybillTypes,
  Exclusive,
  NetworkSettings;

{$R *.DFM}

type
  TAddressInfo = class
   public
    Address : TAddress;
    Orders : TObjectList;

    constructor Create(aAddress : TAddress);
    destructor Destroy; override;

    function CorrectionExists() : Boolean;
  end;


  TInternalRepareOrders = class
   public
    Strings  : TStrings;
    mdOutput : TRxMemoryData;
    ProcessSendOrdersResponse : Boolean;

    _infos : TObjectList;

    procedure RepareOrders;
    procedure InternalRepareOrders;
    procedure FillData;
    procedure FormatOutput;

    procedure FillAddresses();
    procedure RestoreOrders();
    procedure FormatLog();
    function  CorrectionExists(): Boolean;

    destructor Destroy; override;
  end;



function RunExchange( AExchangeActions: TExchangeActions=[eaGetPrice]): Boolean;
{//$ifndef USENEWMYSQLTYPES}
var
 mr: integer;
{//$endif}
//  hMenuHandle: HMENU;
  needAuth : Boolean;
begin
  NeedRetrySendOrder := False;
  NeedEditCurrentOrders := False;
  //����� �������� �������������� � �������� ��������� ��� �������� ����
  MainForm.FreeChildForms;
  Result := False;
  if Assigned(GlobalExchangeParams) then
    FreeAndNil(GlobalExchangeParams);
  GlobalExchangeParams := nil;
  if AExchangeActions = [] then exit;
  if (eaPostOrderBatch in AExchangeActions) and (Length(BatchFileName) = 0) then
    Exit;
{$ifdef NetworkVersion}
  if GetNetworkSettings.DisableUpdate
    and ([eaGetPrice, eaGetFullData, eaGetWaybills, eaSendWaybills, eaPostOrderBatch, eaGetHistoryOrders] * AExchangeActions <> [])
  then
    Exit;
  if GetNetworkSettings.DisableSendOrders and (eaSendOrders in AExchangeActions)
  then
    Exit;
{$endif}

  try

  if (Length(DM.adtParams.FieldByName( 'HTTPName').AsString) = 0)
  then begin
    AProc.MessageBox( '��� ������ ������ � ���������� ���������� ��������� ������� ������',
      MB_ICONWARNING or MB_OK);
    if FindCmdLineSwitch('e') then
      Exit
    else begin
      ShowConfig( True );
      if (Length(DM.adtParams.FieldByName( 'HTTPName').AsString) = 0) then
        Exit;
    end;
  end;

  if [eaSendLetter] <> AExchangeActions then begin
    DM.GlobalExclusiveParams.ReadParams;
    if not DM.GlobalExclusiveParams.ClearOrSelfExclusive then
      Exit
    else
      if not ShowExclusive() then
        Exit;
  end;

  DM.DeleteEmptyOrders;

  //���� �� ��������� ���� "�������� ������������ ����������", �� ��� ������� ���������� �� ����� ����������� ������������,
  //����� ��������, ����� ������������ ������ "�������������� ������"
  if DM.GetCumulative and ([eaImportOnly] <> AExchangeActions)
     and (eaGetPrice in AExchangeActions)
  then
    AExchangeActions := AExchangeActions + [eaGetFullData];

  if ( eaSendOrders in AExchangeActions) and not CheckMinReq then begin
    NeedEditCurrentOrders := True;
    Exit;
  end;

  if (eaGetFullData in AExchangeActions) then
    DM.ResetNeedCommitExchange;

  //������� ����� � �������� ����� �������
  ExchangeForm := TExchangeForm.Create( Application);

  if not MainForm.Showing then ExchangeForm.Position := poDesktopCenter;
  try
    needAuth := False;
    repeat
      ExchangeForm.ErrMsg := '';
      if Assigned(GlobalExchangeParams) then
        FreeAndNil(GlobalExchangeParams);
      GlobalExchangeParams := nil;
      //��� ��������� ������������ ������, ������ �� ������������ ��� �������
      //������ ���� ������ �� �������, �� ����� ������������� ����������� � �������, ������� ��������� ����������
      ExchangeForm.SetRasParams;
      ExchangeForm.SetHTTPParams;

      ExchangeForm.ExchangeActions := AExchangeActions;
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '-');
      WriteExchangeLog('Exchange', '---------------------------');
      WriteExchangeLog('Exchange', '������ ������');
      try
        ExchangeForm.Timer.Enabled := True;
        DM.MainConnection.Close;
        Result := ExchangeForm.ShowModal = mrOk;
        if not Result then
          AProc.MessageBox(ExchangeForm.ErrMsg, MB_ICONERROR);
        Sleep(500);
        DM.MainConnection.Open;
        if not Result and AnsiStartsText('������ ��������', ExchangeForm.ErrMsg)
        then begin
          if needAuth then
            needAuth := False
          else
            needAuth := (ShowConfig( True ) * AuthChanges) <> [];
        end
        else
          needAuth := False;
      except
        on E: Exception do
          AProc.MessageBox(Copy(E.Message, 1, 1024), MB_ICONSTOP);
      end;
      WriteExchangeLog('Exchange', '������ ��������');
      WriteExchangeLog('Exchange', '---------------------------');
    until not needAuth;
  finally
    ExchangeForm.Free;
  end;

  //���������� ���� ������������� ����������, ����� ������� �������� ����������,
  //��� �������������� ������. �.�. ���� �� �������� ����������, ���� ��������������� ������� ������,
  //��� ������ �� �������������, ���� �������� ������ ������ ����� ��������� ����� ��������� �
  //������������� ������ ����� ������ exe-�����.
  if Result and
    ((eaGetPrice in AExchangeActions) or (eaGetFullData in AExchangeActions)
      or (eaImportOnly in AExchangeActions)
      or (eaPostOrderBatch in AExchangeActions)
      )
  then
    DM.ResetCumulative;

  if (( eaGetPrice in AExchangeActions) or
      (eaImportOnly in AExchangeActions) or (eaGetFullData in AExchangeActions)
      or (eaPostOrderBatch in AExchangeActions)
      )
      and Result
  then
    TryToRepareOrders();

  if MainForm.ExchangeOnly then exit;

  if Result and (Trim(GlobalExchangeParams.ServerAddition) <> '')
  then
    AProc.MessageBoxEx(
      GlobalExchangeParams.ServerAddition,
      '��������� �� �� "�������"',
      MB_OK or MB_ICONINFORMATION);

  if Result and (( eaGetPrice in AExchangeActions) or
    ( eaImportOnly in AExchangeActions) or (eaPostOrderBatch in AExchangeActions))
  then begin
    AProc.MessageBox('���������� ��������� �������.', MB_OK or MB_ICONINFORMATION);
{$ifndef NetworkVersion}
    if not WaybillsHelper.CheckWaybillFolders(DM.MainConnection) then
      AProc.MessageBox('���������� ��������� ����� ��� �������� ��������� �� ����� "������������"', MB_ICONWARNING);
{$endif}
  end;

  if Result and (eaGetWaybills in AExchangeActions)
  then
    AProc.MessageBox('��������� ���������� ��������� �������.', MB_OK or MB_ICONINFORMATION);

  if Result and (eaSendWaybills in AExchangeActions)
  then begin
    case
      GlobalExchangeParams.SendWaybillsResult
    of
      swsNotFiles:
        AProc.MessageBox('��������� ���������� ��������� �������.', MB_OK or MB_ICONINFORMATION);
      swsOk:
        AProc.MessageBox('�������� ��������� ��������� �������.', MB_OK or MB_ICONINFORMATION);
      swsRepeat:
        AProc.MessageBox(
         '��������� ���������� �� ����������� ��������� �������.'#13#10 +
         '�������� ��������� ��������� �������.',
         MB_OK or MB_ICONWARNING);
      swsRetryLater:
        AProc.MessageBox(
         '��������� ���������� �� ����������� ��������� �������.'#13#10 +
         '��������� ����������� ��������� ��������� �������.',
         MB_OK or MB_ICONWARNING);
    end;
  end;


  if Result and (eaSendLetter in AExchangeActions)
  then
    AProc.MessageBox('������ ������� ����������.', MB_OK or MB_ICONINFORMATION);

  if Result and ( [eaSendOrders] * AExchangeActions = [eaSendOrders]) then
  begin
    MainForm.SetOrdersInfo;
    if (GlobalExchangeParams.SendedOrdersErrorLog.Count = 0)
    then
      AProc.MessageBox('�������� ������� ��������� �������.', MB_OK or MB_ICONINFORMATION);

    if ((DM.SaveGridMask and PrintSendedOrder) > 0)
      and (DM.adtParams.FieldByName('PrintOrdersAfterSend').AsBoolean)
      and (GlobalExchangeParams.SendedOrders.Count > 0)
    then
      PrintOrdersAfterSend;
  end;

  if Result and ( AExchangeActions = [ eaSendOrders])
    and (GlobalExchangeParams.SendedOrdersErrorLog.Count > 0)
  then begin
    NeedRetrySendOrder := True;
  end;

  //������� ������� ���������� ���������, ������ � ��������� �� �� �������
  if Result and (( eaGetPrice in AExchangeActions) or
    ( eaGetWaybills in AExchangeActions) or (eaSendWaybills in AExchangeActions)
    or (eaImportOnly in AExchangeActions) or (eaPostOrderBatch in AExchangeActions))
  then
    DM.ProcessDocs(GlobalExchangeParams.ImportDocs);

  if Result and (AExchangeActions = [ eaGetHistoryOrders])
  then
    if GlobalExchangeParams.FullHistoryOrders
    then
      AProc.MessageBox('� ������� ��������� ��� ������� �������.', MB_OK or MB_ICONINFORMATION)
    else
      AProc.MessageBox('�������� ������� ������� ��������� �������.', MB_OK or MB_ICONINFORMATION);

  MainForm.UpdateReclame;

{//$ifndef USENEWMYSQLTYPES}
//� ������������������ ������ �� �������� ���� ������ ���� ������,
//������� ��� ������ ��������� � ��� ������������ ������
  if Result and ( eaGetPrice in AExchangeActions) and
    ( DaysBetween( DM.adtParams.FieldByName( 'LastCompact').AsDateTime, Now) >= COMPACT_PERIOD) then
  begin
    CompactForm := TCompactForm.Create( Application);
    CompactForm.lblMessage.Caption := '������ ���� �� ������������� ����� ' +
      IntToStr( COMPACT_PERIOD) + ' ����.' + #10 + #13 +
      '���������� ������ ����? (�������������)';
    mr := CompactForm.ShowModal;
    CompactForm.Close;
    CompactForm.Free;
    if mr = mrOK then begin
      //����� ������� ������ ���� ������ ��������� ��� �������� ����. ��������, ��� �� ���� ������,
      //�.�. �������� ���� ��������� �����
      MainForm.FreeChildForms;
      Application.ProcessMessages;
      RunCompactDatabase;
      AProc.MessageBox( '������ ���� ������ ���������');
    end;
  end;
{//$endif}

  if Result then
    if (eaPostOrderBatch in AExchangeActions) then
      ShowOrderBatch
    else
      if (( eaGetPrice in AExchangeActions) or
          ( eaGetWaybills in AExchangeActions) or (eaSendWaybills in AExchangeActions)
           or (eaImportOnly in AExchangeActions))
         and GlobalExchangeParams.ImportDocs
      then
        ShowDocumentHeaders;

  finally
    BatchFileName := '';
    if ([eaSendLetter] <> AExchangeActions) and DM.GlobalExclusiveParams.SelfExclusive then
      try DM.GlobalExclusiveParams.ResetExclusive; except end;
    if Assigned(GlobalExchangeParams) then
      try FreeAndNil(GlobalExchangeParams) except end;
  end;
end;

//������������� ������������ ������
procedure PrintOrdersAfterSend;
var
  I : Integer;
  PrintDialog : TPrintDialog;
begin
  PrintDialog := TPrintDialog.Create(Application);
  try

    if PrintDialog.Execute then
      for I := 0 to GlobalExchangeParams.SendedOrders.Count-1 do
        DM.ShowOrderDetailsReport(
          StrToInt(GlobalExchangeParams.SendedOrders[i]),
          True,
          True,
          False,
          False);

  finally
    PrintDialog.Free;
  end;

end;

{ ��������������� ������ ����� ���������� }
procedure TryToRepareOrders();
var
  t : TInternalRepareOrders;
begin
  t := TInternalRepareOrders.Create;
  try
    t.ProcessSendOrdersResponse := False;
    t.RepareOrders;
  finally
    t.Free;
  end;
end;


//����� ����� ������
function TExchangeForm.PauseAfterError : TModalResult;
begin
  RetryForm := TRetryForm.Create( Application);
  RetryForm.lblError.Caption := GlobalExchangeParams.ErrorMessage;
  RetryForm.Seconds := ConnectPause;
  Result := RetryForm.ShowModal;
  RetryForm.Close;
  RetryForm.Free;
end;

procedure TExchangeForm.TimerTimer(Sender: TObject);
var
  ConnectNumber: Integer;
begin
  //����� ���������� �� ��������, ������� ����� ���� ��������
  StartTime := Now;
  FStatusStr := '';
  Timer1.Enabled := True;
  Timer.Enabled := False;
  DoStop := False;

  Caption := '����� �������';

  //������� ���� ����������
  for ConnectNumber := 1 to ConnectCount do
  begin
    ExThread := TExchangeThread.Create( False);
    GlobalExchangeParams := ExThread.ExchangeParams;
    while not GlobalExchangeParams.Terminated do
    begin
      CheckSynchronize;
      Application.ProcessMessages;
      Sleep( 10);
    end;

    if GlobalExchangeParams.ErrorMessage <> '' then
    begin
      if ( ConnectNumber < ConnectCount) and not GlobalExchangeParams.CriticalError then begin
        if PauseAfterError = mrCancel then begin
          btnCancel.Click;
          break;
        end;
      end
      else begin
        //��������� DialUp � ������ ������
        try
          Ras.Disconnect;
        except
        end;
        break;
      end;
    end
    else break;
  end;

  ErrMsg := GlobalExchangeParams.ErrorMessage;

  { ��������� ���������� ��������� }
  if Assigned( ExThread) and ( ErrMsg = 'Terminate') then
  begin
    DM.MainConnection.Close;
    Application.Terminate;
  end;

  if Assigned( ExThread) and ( ErrMsg <> '') then
  begin
    //��� ������� ���������� ����� ��������� ������ ��� ������������ �������� ��������
    ModalResult := mrAbort;
    {
    ����� ���� ��� ���������� � ����� � ����������� #1632 ������ ��� ����������
    ��� ������ ������ ������� (������� �� ������ "������") ������ ������
    ������� ����� ExThread, ���� ���� ��������� �������� �������� �����,
    ���� �������� ��, ����� ��� �� ��������� ChildThreads,
    � �� ��������� ������ ��� ��������� � ChildThreads
    }
    if Assigned( ExThread) then
      FreeAndNil(ExThread);
  end
  else
  begin
    ModalResult := mrOk;
    //��� ���� ��������� � ���������� #1632 ������ ��� ����������
    if Assigned( ExThread) then
      FreeAndNil(ExThread);
  end;
end;


procedure TExchangeForm.CheckStop;
begin
  StatusText := '';
  StatusPosition := 0;
  if DoStop then
  begin
    GlobalExchangeParams.Terminated := True;
    Abort;
  end;
end;

procedure TExchangeForm.RasStateChange(Sender: TObject; State: Integer;
  StateStr: String);
begin
  StatusText := StateStr;
end;

procedure TExchangeForm.btnCancelClick(Sender: TObject);
begin
  DoStop := True;
  if GlobalExchangeParams.DownloadChildThreads then
    ExThread.StopChildThreads
  else
    try
      GlobalExchangeParams.CriticalError := True;
      GlobalExchangeParams.ErrorMessage := '�������� ��������';
      HTTP.Disconnect;
      Ras.Disconnect;
    except
    end;
end;

procedure TExchangeForm.SetRasParams;
begin
  // ��������� ���������� ����������
  if DM.adtParams.FieldByName( 'RasConnect').AsBoolean then
  begin
    Ras.Entry := DM.adtParams.FieldByName( 'RasEntry').AsString;
    Ras.UserName := DM.adtParams.FieldByName( 'RasName').AsString;
    Ras.Password := DM.adtParams.FieldByName( 'RasPass').AsString;
  end;
end;

procedure TExchangeForm.SetHTTPParams;
begin
  DM.InternalSetHTTPParams(HTTP);
  DM.InternalSetHTTPParams(HTTPReclame);
  DM.InternalSetHTTPParams(httpReceive);
  AProc.InternalSetSSLParams(sslMain);
  AProc.InternalSetSSLParams(sslReclame);
  AProc.InternalSetSSLParams(sslReceive);
end;

function TExchangeForm.GetAppHandle: HWND;
begin
  result := Application.Handle;
end;

function TExchangeForm.GetStatusText: string;
begin
  result := stStatus.Caption;
end;

procedure TExchangeForm.SetStatusText(Value: string);
begin
  Value := Trim( Value);
  stStatus.Caption := Value;
  if Value <> '' then
    WriteExchangeLog('Exchange', Value);
  Application.ProcessMessages;
end;

procedure TExchangeForm.SetStatusPosition(Value: Integer);
begin
  if FStatusPosition<>Value then
  begin
    FStatusPosition := Value;
    ProgressBar.Position := Value;
    Application.ProcessMessages;
  end;
end;

procedure TExchangeForm.Timer1Timer(Sender: TObject);
begin
  lblElapsed.Caption := TimeToStr( Now - StartTime);
end;

procedure TExchangeForm.FormCreate(Sender: TObject);
begin
  HTTP.ConnectTimeout := -2;
  HTTPReclame.ConnectTimeout := -2;
  httpReceive.ConnectTimeout := -2;
  ConnectCount := DM.adtParams.FieldByName( 'ConnectCount').AsInteger;
  ConnectPause := DM.adtParams.FieldByName( 'ConnectPause').AsInteger;
end;

procedure TExchangeForm.HTTPStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  WriteExchangeLog('Exchange', 'IdStatus : ' + AStatusText);
end;

{ TInternalRepareOrders }

function TInternalRepareOrders.CorrectionExists: Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to _infos.Count-1 do
    if (TAddressInfo(_infos[i]).CorrectionExists()) then begin
      Result := True;
      Exit;
    end;
end;

destructor TInternalRepareOrders.Destroy;
begin
  if Assigned(_infos) then
    FreeAndNil(_infos);
  inherited;
end;

procedure TInternalRepareOrders.FillAddresses;
var
  addresses : TObjectList;
  index : Integer;
  info : TAddressInfo;

begin
  addresses := TDBMapping.GetAddresses(DM.MainConnection);
  try
    addresses.OwnsObjects := False;

    for index := 0 to addresses.Count-1 do begin
      info := TAddressInfo.Create(TAddress(addresses[index]));
      _infos.Add(info);
    end;
  finally
    addresses.Free;
  end;
end;

procedure TInternalRepareOrders.FillData;
var
  Order, CurOrder, Quantity, E: Integer;
  SynonymCode, SynonymFirmCrCode, JUNK, AWAIT: Variant;
  Code, RequestRatio, OrderCost, MinOrderCount, Period, ProducerCost: Variant;
  //���� �� ���������� �� ����?
  CostReason : String;
  OldPrice : Currency;

  procedure SetOrderDropReason(reason : TPositionSendResult);
  begin
    DM.adsRepareOrders.Edit;
    DM.adsRepareOrdersDropReason.Value := Integer(reason);
    DM.adsRepareOrders.Post;
  end;

  procedure SetOrder( Order: integer);
  var
    OldOrderCount : Integer;
    ServerCost    : Currency;
  begin
    DM.adsRepareOrders.Edit;
    OldOrderCount := DM.adsRepareOrdersORDERCOUNT.AsInteger;
    ServerCost := DM.adsRepareOrdersRealPrice.AsCurrency;
// ����������� ���, �.�. ��� ������ �����������
//    if not ProcessSendOrdersResponse then
      DM.adsRepareOrdersORDERCOUNT.AsInteger := Order;
    if Order = 0 then
      DM.adsRepareOrdersCOREID.Clear
    else begin
      DM.adsRepareOrdersCOREID.AsVariant := DM.adsCoreRepareCOREID.AsVariant;
      DM.adsRepareOrdersCODE.AsVariant := DM.adsCoreRepareCODE.AsVariant;
      DM.adsRepareOrdersCODECR.AsVariant := DM.adsCoreRepareCODECR.AsVariant;
      DM.adsRepareOrdersPRICE.AsVariant := DM.adsCoreRepareCOST.AsVariant;
      DM.adsRepareOrdersRealPrice.AsVariant := DM.adsCoreRepareRealCost.AsVariant;
      DM.adsRepareOrdersCodeFirmCr.AsVariant := DM.adsCoreRepareCodeFirmCr.AsVariant;
      DM.adsRepareOrdersSupplierPriceMarkup.AsVariant := DM.adsCoreRepareSupplierPriceMarkup.AsVariant;
      DM.adsRepareOrdersCoreQuantity.AsVariant := DM.adsCoreRepareQuantity.AsVariant;
      DM.adsRepareOrdersServerCoreID.AsVariant := DM.adsCoreRepareServerCoreID.AsVariant;
      DM.adsRepareOrdersUnit.AsVariant := DM.adsCoreRepareUnit.AsVariant;
      DM.adsRepareOrdersVolume.AsVariant := DM.adsCoreRepareVolume.AsVariant;
      DM.adsRepareOrdersNote.AsVariant := DM.adsCoreRepareNote.AsVariant;
      DM.adsRepareOrdersPeriod.AsVariant := DM.adsCoreReparePeriod.AsVariant;
      DM.adsRepareOrdersDoc.AsVariant := DM.adsCoreRepareDoc.AsVariant;
      DM.adsRepareOrdersRegistryCost.AsVariant := DM.adsCoreRepareRegistryCost.AsVariant;
      DM.adsRepareOrdersVitallyImportant.AsVariant := DM.adsCoreRepareVitallyImportant.AsVariant;
      DM.adsRepareOrdersProducerCost.AsVariant := DM.adsCoreRepareProducerCost.AsVariant;
      DM.adsRepareOrdersNDS.AsVariant := DM.adsCoreRepareNDS.AsVariant;
    end;
    DM.adsRepareOrdersServerCost.AsCurrency := ServerCost;
    DM.adsRepareOrdersServerQuantity.Value := OldOrderCount;
    DM.adsRepareOrders.Post;
  end;

begin
  while not DM.adsRepareOrders.Eof do
  begin
    Application.ProcessMessages;
    if DM.adsCoreRepare.Active then
      DM.adsCoreRepare.Close;
    Screen.Cursor := crHourglass;
    try
      //�������� ������, ����������������� �������
      Order := DM.adsRepareOrdersORDERCOUNT.AsInteger;
      OldPrice := DM.adsRepareOrdersPrice.AsCurrency;
      CurOrder := 0;
      CostReason := '';

      Code := DM.adsRepareOrdersCODE.AsVariant;
      RequestRatio := DM.adsRepareOrdersREQUESTRATIO.AsVariant;
      OrderCost := DM.adsRepareOrdersORDERCOST.AsVariant;
      MinOrderCount := DM.adsRepareOrdersMINORDERCOUNT.AsVariant;
      Period := DM.adsRepareOrdersPeriod.AsVariant;
      ProducerCost := DM.adsRepareOrdersProducerCost.AsVariant;

      SynonymCode := DM.adsRepareOrdersSYNONYMCODE.AsInteger;
      SynonymFirmCrCode := DM.adsRepareOrdersSYNONYMFIRMCRCODE.AsVariant;
      JUNK := DM.adsRepareOrdersJUNK.AsVariant;
      AWAIT := DM.adsRepareOrdersAWAIT.AsVariant;

      DM.adsCoreRepare.ParamByName( 'ClientId').Value :=
        DM.adtClients.FieldByName('ClientId').Value;
      DM.adsCoreRepare.ParamByName( 'PriceCode').Value :=
        DM.adsRepareOrders.FieldByName( 'PriceCode').Value;
      DM.adsCoreRepare.ParamByName( 'RegionCode').Value :=
        DM.adsRepareOrders.FieldByName( 'RegionCode').Value;
      DM.adsCoreRepare.ParamByName( 'SynonymCode').Value := SynonymCode;
      DM.adsCoreRepare.ParamByName( 'JUNK').Value := JUNK;
      DM.adsCoreRepare.ParamByName( 'AWAIT').Value := AWAIT;

      DM.adsCoreRepare.RestoreSQL;
      if (VarIsNull(SynonymFirmCrCode)) then
        DM.adsCoreRepare.AddWhere('(CCore.SYNONYMFIRMCRCODE is null)')
      else begin
        DM.adsCoreRepare.AddWhere('(CCore.SYNONYMFIRMCRCODE = :SYNONYMFIRMCRCODE)');
        DM.adsCoreRepare.ParamByName( 'SYNONYMFIRMCRCODE').Value := SynonymFirmCrCode;
      end;

      DM.adsCoreRepare.Open;
      DM.adsCoreRepare.IndexFieldNames := 'Cost ASC';
      DM.adsCoreRepare.First;
      { ��������� ������� �����-����� }
      if DM.adsCoreRepare.IsEmpty then
      begin
        mdOutput.AppendRecord(
         [DM.adsRepareOrdersClientName.AsString,
         DM.adsRepareOrdersPRICENAME.AsString,
         DM.adsRepareOrdersSYNONYMNAME.AsString,
         DM.adsRepareOrdersSYNONYMFIRM.AsString,
         '����������� �����������',
         Order,
         Null,
         OldPrice,
         Null,
         DM.adsRepareOrdersId.AsLargeInt,
         DM.adsRepareOrdersProductId.AsLargeInt,
         DM.adsRepareOrdersClientId.AsLargeInt]);
        DM.adsCoreRepare.Close;
        SetOrder( 0);
        SetOrderDropReason(psrNotExists);
        DM.adsRepareOrders.Next;
        continue;
      end;

      if DM.adsCoreRepare
        .Locate(
          'Code;REQUESTRATIO;ORDERCOST;MINORDERCOUNT;Period;ProducerCost',
          VarArrayOf([Code, RequestRatio, OrderCost, MinOrderCount, Period, ProducerCost]), [])
      then
      begin
        Val( DM.adsCoreRepareQUANTITY.AsString, Quantity, E);
        if E <> 0 then Quantity := 0;
        if Quantity > 0 then
          CurOrder := Min( Order, Quantity)
        else
          CurOrder := Order;
        if not DM.adsCoreRepareREQUESTRATIO.IsNull and (DM.adsCoreRepareREQUESTRATIO.AsInteger > 0) then
          CurOrder := CurOrder - (CurOrder mod DM.adsCoreRepareREQUESTRATIO.AsInteger);
      end;
      SetOrder( CurOrder);

      if (CurOrder > 0) then
        if OldPrice < DM.adsRepareOrdersPrice.AsCurrency then
          CostReason := '������ ���� ������ ������ ������� ����'
        else
          if OldPrice > DM.adsRepareOrdersPrice.AsCurrency then
            CostReason := '������ ���� ������ ������ ������� ����';

      { ���� ��� ��� �� ����������, �� ����� ��������� }
      if ( Order - CurOrder) > 0 then
      begin
        if CurOrder > 0 then
        begin
          SetOrderDropReason(psrDifferentQuantity);
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           IfThen(Length(CostReason) > 0, CostReason + '; ') +
             '��������� ���������� ��������� � �����-����� ������ ����������� �����',
           Order,
           CurOrder,
           OldPrice,
           DM.adsRepareOrdersPrice.AsCurrency,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);
        end
        else
        begin
          SetOrderDropReason(psrNotExists);
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           '����������� �����������',
           Order,
           Null,
           OldPrice,
           Null,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);
        end;
      end
      else
        if Length(CostReason) > 0 then begin
          SetOrderDropReason(psrDifferentCost);
          mdOutput.AppendRecord(
           [DM.adsRepareOrdersClientName.AsString,
           DM.adsRepareOrdersPRICENAME.AsString,
           DM.adsRepareOrdersSYNONYMNAME.AsString,
           DM.adsRepareOrdersSYNONYMFIRM.AsString,
           CostReason,
           Order,
           CurOrder,
           OldPrice,
           DM.adsRepareOrdersPrice.AsCurrency,
           DM.adsRepareOrdersId.AsLargeInt,
           DM.adsRepareOrdersProductId.AsLargeInt,
           DM.adsRepareOrdersClientId.AsLargeInt]);
        end;

      DM.adsRepareOrders.Next;
    finally
      DM.adsCoreRepare.Close;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TInternalRepareOrders.FormatLog;
var
  infoIndex : Integer;
  info : TAddressInfo;
  orderIndex : Integer;
  order : TCurrentOrderHead;
  positionIndex : Integer;
  position : TCurrentOrderItem;
begin
  if (CorrectionExists()) then begin

    for infoIndex := 0 to _infos.Count-1 do
      if (TAddressInfo(_infos[infoIndex]).CorrectionExists()) then begin

        info := TAddressInfo(_infos[infoIndex]);
        Strings.Add('������ ' + info.Address.Name);

        for orderIndex := 0 to info.Orders.Count-1 do
          if (TCurrentOrderHead(info.Orders[orderIndex]).CorrectionExists()) then begin

            order := TCurrentOrderHead(info.Orders[orderIndex]);
            Strings.Add('   �����-���� ' + order.PriceName);

            for positionIndex := 0 to order.OrderItems.Count-1 do begin
              position := TCurrentOrderItem(order.OrderItems[positionIndex]);
              if (not VarIsNull(position.DropReason)) then
                Strings.Add('      ' + position.ToRestoreReport());
            end;

          end;

      end;

  end;
end;

procedure TInternalRepareOrders.FormatOutput;
var
  ClientName, PriceName : String;
begin
  mdOutput.SortOnFields('ClientName;PriceName;SynonymName;SynonymFirm');
  mdOutput.First;
  if mdOutput.RecordCount > 0 then begin
    ClientName := mdOutput.FieldByName('ClientName').AsString;
    PriceName := mdOutput.FieldByName('PriceName').AsString;
    Strings.Append(Format('������ %s', [ClientName]));
    Strings.Append(Format('   �����-���� %s', [PriceName]));
    while not mdOutput.Eof do begin
      if     (ClientName = mdOutput.FieldByName('ClientName').AsString)
         and (PriceName  <> mdOutput.FieldByName('PriceName').AsString)
      then begin
        PriceName := mdOutput.FieldByName('PriceName').AsString;
        Strings.Append('');
        Strings.Append(Format('   �����-���� %s', [PriceName]));
      end
      else
        if     (ClientName <> mdOutput.FieldByName('ClientName').AsString)
           and (PriceName  <> mdOutput.FieldByName('PriceName').AsString)
        then begin
          ClientName := mdOutput.FieldByName('ClientName').AsString;
          PriceName := mdOutput.FieldByName('PriceName').AsString;
          Strings.Append('');
          Strings.Append('');
          Strings.Append(Format('������ %s', [ClientName]));
          Strings.Append(Format('   �����-���� %s', [PriceName]));
        end;

      Strings.Append( Format( '      %s - %s : %s (������ ����: %s; ������ �����: %s; ����� ����: %s; ������� �����: %s)',
        [mdOutput.FieldByName('SynonymName').AsString,
         mdOutput.FieldByName('SynonymFirm').AsString,
         mdOutput.FieldByName('Reason').AsString,
         mdOutput.FieldByName('OldPrice').AsString,
         mdOutput.FieldByName('OldOrderCount').AsString,
         mdOutput.FieldByName('NewPrice').AsString,
         mdOutput.FieldByName('NewOrderCount').AsString]));
      mdOutput.Next;
    end;
  end;
end;

procedure TInternalRepareOrders.InternalRepareOrders;
begin
  FillAddresses();
  RestoreOrders();
  FormatLog();
end;

procedure TInternalRepareOrders.RepareOrders;
begin
  _infos := TObjectList.Create();

  DM.adsRepareOrders.Close;

  DM.adsRepareOrders.RestoreSQL;
  //���� ������������ ����� �� �������, �� ������������� ������ "������������" ������
// ����������� ���, �.�. ��� ������ False  
//  if ProcessSendOrdersResponse then
//    DM.adsRepareOrders.AddWhere('(CurrentOrderHeads.Send = 1)');

  DM.adsRepareOrders.Open;

  if DM.adsRepareOrders.IsEmpty then
  begin
    DM.adsRepareOrders.Close;
    exit;
  end;

  Strings := TStringList.Create;

  try

    mdOutput := TRxMemoryData.Create(nil);
    try

      mdOutput.FieldDefs.Add('ClientName', ftString, 500);
      mdOutput.FieldDefs.Add('PriceName', ftString, 500);
      mdOutput.FieldDefs.Add('SynonymName', ftString, 500);
      mdOutput.FieldDefs.Add('SynonymFirm', ftString, 500);
      mdOutput.FieldDefs.Add('Reason', ftString, 500);
      mdOutput.FieldDefs.Add('OldOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('NewOrderCount', ftInteger);
      mdOutput.FieldDefs.Add('OldPrice', ftCurrency);
      mdOutput.FieldDefs.Add('NewPrice', ftCurrency);
      mdOutput.FieldDefs.Add('OrderListId', ftLargeint);
      mdOutput.FieldDefs.Add('ProductId', ftLargeint);
      mdOutput.FieldDefs.Add('ClientId', ftLargeint);

      mdOutput.Open;
      try
        ShowSQLWaiting(InternalRepareOrders, '���������� �������� �������');

        { ���� �� ����� ���-��, �� ������� ��������� }
        if (Strings.Count > 0) and (Length(Strings.Text) > 0) then begin
          WriteExchangeLog('RestoreOrders', '��������������� ������ ����� ����������:'#13#10 + Strings.Text);
          ShowCorrectOrders(False);
        end;
      finally
        mdOutput.Close;
      end;

    finally
      mdOutput.Free;
    end;

  finally
    Strings.Free;
    DM.adsRepareOrders.Close;
  end;
end;

procedure TInternalRepareOrders.RestoreOrders;
var
  I : Integer;
  info : TAddressInfo;
  order : TCurrentOrderHead;
  orderIndex : Integer;
  offers : TObjectList;
  positionIndex : Integer;
begin
  for I := 0 to _infos.Count-1 do begin
    info := TAddressInfo(_infos[i]);

    info.Orders := TDBMapping.GetCurrentOrderHeadsByAddress(DM.MainConnection, info.Address);

    for orderIndex := 0 to info.Orders.Count-1 do begin
      order := TCurrentOrderHead(info.Orders[orderIndex]);

      offers := TDBMapping.GetOffersByPriceAndProductId(
        DM.MainConnection,
        order.PriceCode,
        order.RegionCode,
        //order.OrderItems.Select(item => item.ProductId).ToArray()
        order.GetProductIds());

      try
        order.RestoreOrderItems(offers);
      finally
        offers.Free;
      end;

      for positionIndex := 0 to order.OrderItems.Count-1 do
        TDBMapping.SaveOrderItem(
          DM.MainConnection,
          TCurrentOrderItem(order.OrderItems[positionIndex]));
    end;
  end;
end;

{ TAddressInfo }

function TAddressInfo.CorrectionExists: Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to Orders.Count-1 do
    if TCurrentOrderHead(Orders[i]).CorrectionExists then begin
      Result := True;
      Exit;
    end
end;

constructor TAddressInfo.Create(aAddress: TAddress);
begin
  Address := aAddress;
  Orders := nil;
end;

destructor TAddressInfo.Destroy;
begin
  if Assigned(Address) then
    FreeAndNil(Address);
  if Assigned(Orders) then
    FreeAndNil(Orders);
  inherited;
end;

initialization
  BatchFileName := '';
  ExThread := nil;
finalization
end.
