unit CoreFirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXDBCtrl, Grids, DBGrids, ComCtrls, Db, StrUtils, Child,
  FR_DSet, FR_DBSet, ActnList, StdCtrls, Buttons, DBCtrls, Variants,
  Math, ExtCtrls, DBGridEh, ToughDBGrid, OleCtrls, SHDocVw,
  hlpcodecs, LU_Tracer, 
  SQLWaiting, ForceRus, GridsEh, 
  U_frameLegend, MemDS, DBAccess, MyAccess, U_frameBaseLegend;

type
  TFilter=( filAll, filOrder, filLeader, filProducer);

  TCoreFirmForm = class(TChildForm)
    dsCore: TDataSource;
    ActionList: TActionList;
    actFilterAll: TAction;
    actFilterOrder: TAction;
    actFilterLeader: TAction;
    actSaveToFile: TAction;
    actDeleteOrder: TAction;
    lblRecordCount: TLabel;
    cbFilter: TComboBox;
    lblOrderLabel: TLabel;
    btnDeleteOrder: TSpeedButton;
    btnFormHistory: TSpeedButton;
    lblFirmPrice: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbgCore: TToughDBGrid;
    Timer: TTimer;
    Bevel1: TBevel;
    actFlipCore: TAction;
    pTop: TPanel;
    eSearch: TEdit;
    btnSearch: TButton;
    tmrSearch: TTimer;
    plOverCost: TPanel;
    lWarning: TLabel;
    adsAvgOrders: TMyQuery;
    adsCurrentOrderHeader: TMyQuery;
    adsCountFields: TMyQuery;
    adsCore: TMyQuery;
    adsCoreCryptPriceRet: TCurrencyField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsCoreCoreId: TLargeintField;
    adsCoreproductid: TLargeintField;
    adsCorePriceCode: TLargeintField;
    adsCoreRegionCode: TLargeintField;
    adsCoreFullCode: TLargeintField;
    adsCoreshortcode: TLargeintField;
    adsCoreCodeFirmCr: TLargeintField;
    adsCoreSynonymCode: TLargeintField;
    adsCoreSynonymFirmCrCode: TLargeintField;
    adsCoreCode: TStringField;
    adsCoreCodeCr: TStringField;
    adsCoreVolume: TStringField;
    adsCoreDoc: TStringField;
    adsCoreNote: TStringField;
    adsCorePeriod: TStringField;
    adsCoreAwait: TBooleanField;
    adsCoreJunk: TBooleanField;
    adsCoreCost: TFloatField;
    adsCoreQuantity: TStringField;
    adsCoreregistrycost: TFloatField;
    adsCorevitallyimportant: TBooleanField;
    adsCorerequestratio: TIntegerField;
    adsCoreordercost: TFloatField;
    adsCoreminordercount: TIntegerField;
    adsCoreSynonymName: TStringField;
    adsCoreSynonymFirm: TStringField;
    adsCoreLeaderPriceCode: TLargeintField;
    adsCoreLeaderRegionCode: TLargeintField;
    adsCoreLeaderRegionName: TStringField;
    adsCoreLeaderPriceName: TStringField;
    adsCoreLeaderPRICE: TFloatField;
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
    adsCoreOrdersJunk: TBooleanField;
    adsCoreOrdersAwait: TBooleanField;
    adsCoreOrdersHOrderId: TLargeintField;
    adsCoreOrdersHClientId: TLargeintField;
    adsCoreOrdersHPriceCode: TLargeintField;
    adsCoreOrdersHRegionCode: TLargeintField;
    adsCoreOrdersHPriceName: TStringField;
    adsCoreOrdersHRegionName: TStringField;
    adsCoreSumOrder: TFloatField;
    btnGotoCore: TSpeedButton;
    adsCoreWithLike: TMyQuery;
    adsCoreRealCost: TFloatField;
    adsCoreSupplierPriceMarkup: TFloatField;
    adsCoreProducerCost: TFloatField;
    adsCoreNDS: TSmallintField;
    adsCoreMnnId: TLargeintField;
    adsCoreMnn: TStringField;
    btnGotoMNN: TSpeedButton;
    adsCoreDescriptionId: TLargeintField;
    adsCoreCatalogVitallyImportant: TBooleanField;
    adsCoreCatalogMandatoryList: TBooleanField;
    adsCoreMaxProducerCost: TFloatField;
    dblProducers: TDBLookupComboBox;
    adsProducers: TMyQuery;
    adsProducersId: TLargeintField;
    adsProducersName: TStringField;
    dsProducers: TDataSource;
    adsCoreBuyingMatrixType: TIntegerField;
    adsCoreProducerName: TStringField;
    procedure cbFilterClick(Sender: TObject);
    procedure actDeleteOrderExecute(Sender: TObject);
    procedure adsCore2BeforePost(DataSet: TDataSet);
    procedure adsCore2AfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure actFilterAllExecute(Sender: TObject);
    procedure actFilterOrderExecute(Sender: TObject);
    procedure actFilterLeaderExecute(Sender: TObject);
    procedure btnFormHistoryClick(Sender: TObject);
    procedure dbgCoreGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbgCoreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgCoreCanInput(Sender: TObject; Value: Integer;
      var CanInput: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure actFlipCoreExecute(Sender: TObject);
    procedure dbgCoreKeyPress(Sender: TObject; var Key: Char);
    procedure dbgCoreSortMarkingChanged(Sender: TObject);
    procedure adsCoreOldLEADERPRICENAMEGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure tmrSearchTimer(Sender: TObject);
    procedure dbgCoreDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure eSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eSearchKeyPress(Sender: TObject; var Key: Char);
    procedure dblProducersCloseUp(Sender: TObject);
  private
    PriceCode, ClientId: Integer;
    RegionCode : Int64;
    PriceName,
    RegionName : String;

    UseExcess: Boolean;
    Excess: Integer;
    InternalSearchText : String;

    BM : TBitmap;

    fr : TForceRus;

    FOpenWithSearch : Boolean;

    procedure SetOrderLabel;
    procedure SetFilter(Filter: TFilter);
    procedure RefreshCurrentOrderHeader;
    procedure AllFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OrderCountFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure LeaderFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ProducerFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ccf(DataSet: TDataSet);
    procedure SetClear;
    procedure AddKeyToSearch(Key : Char);
    procedure DeleteOrder;
  public
    frameLegend : TframeLegend;
    procedure ShowForm(
      PriceCode: Integer;
      RegionCode: Int64;
      PriceName, RegionName : String;
      OnlyLeaders: Boolean=False;
      OpenWithSearch : Boolean = False); reintroduce;
    procedure Print( APreview: boolean = False); override;
    procedure RefreshAllCore;
  end;

implementation

uses Main, AProc, DModule, DBProc, FormHistory, Prices, Constant,
  NamesForms, AlphaUtils, Orders, DASQLMonitor, FR_Class, U_framePosition,
  DBGridHelper;

{$R *.DFM}

procedure TCoreFirmForm.FormCreate(Sender: TObject);
begin
  dsCheckVolume := adsCore;
  dgCheckVolume := dbgCore;
  fOrder := adsCoreORDERCOUNT;
  fVolume := adsCoreREQUESTRATIO;
  fOrderCost := adsCoreORDERCOST;
  fSumOrder := adsCoreSumOrder;
  fMinOrderCount := adsCoreMINORDERCOUNT;
  gotoMNNButton := btnGotoMNN;

  inherited;

  frameLegend := TframeLegend.CreateFrame(Self, True, True, False);
  frameLegend.Parent := Self;
  frameLegend.Align := alBottom;
  TframePosition.AddFrame(Self, Self, dsCore, 'SynonymName', 'MnnId', ShowDescriptionAction);

  BM := TBitmap.Create;

  fr := TForceRus.Create;

  InternalSearchText := '';
  adsCore.OnCalcFields := ccf;
  PrintEnabled := (DM.SaveGridMask and PrintFirmPrice) > 0;
  UseExcess := True;
  Excess := DM.adtClients.FieldByName( 'Excess').AsInteger;
  ClientId := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  adsAvgOrders.ParamByName('ClientId').Value := ClientId;
  TDBGridHelper.RestoreColumnsLayout(dbgCore, Self.ClassName);
  if dbgCore.SortMarkedColumns.Count = 0 then
    dbgCore.FieldColumns['SYNONYMNAME'].Title.SortMarker := smUpEh;
end;

procedure TCoreFirmForm.FormDestroy(Sender: TObject);
begin
  inherited;
  TDBGridHelper.SaveColumnsLayout(dbgCore, Self.ClassName);
  fr.Free;
  BM.Free;
end;

procedure TCoreFirmForm.ShowForm(PriceCode: Integer; RegionCode: Int64;
  PriceName, RegionName : String; OnlyLeaders: Boolean=False; OpenWithSearch : Boolean = False);
begin
  FOpenWithSearch := OpenWithSearch;
  if adsProducers.Active then
    adsProducers.Close;
  adsProducers.ParamByName( 'PriceCode').Value:=PriceCode;
  adsProducers.ParamByName( 'RegionCode').Value:=RegionCode;
  adsProducers.Open;
  dblProducers.DataField := 'Id';
  dblProducers.KeyField := 'Id';
  dblProducers.ListField := 'Name';
  dblProducers.ListSource := dsProducers;
  dblProducers.KeyValue := adsProducersId.Value;

  plOverCost.Hide();
  Self.PriceCode  := PriceCode;
  Self.RegionCode := RegionCode;
  Self.PriceName  := PriceName;
  Self.RegionName := RegionName;
  //���� ������ ���� �� ������ � ������������ ������
  if FOpenWithSearch then begin
    dbgCore.InputField := '';
    if adsCore.Active then
      adsCore.Close;
  end
  else begin
    dbgCore.InputField := 'OrderCount';
    InternalSearchText := '';
    RefreshAllCore;
    SetFilter(filAll);
    if adsCore.RecordCount=0 then begin
      AProc.MessageBox('��������� �����-���� �����������',MB_ICONWARNING);
      Abort;
    end;
    if OnlyLeaders then
      SetFilter(filLeader)
    else
      SetFilter(filAll);
  end;
  //������������ ����� ������ � ���������� �������
  SetOrderLabel;
  lblFirmPrice.Caption := Format( '�����-���� %s, ������ %s',[
    PriceName,
    RegionName]);
  if not adsAvgOrders.Active then
    adsAvgOrders.Open;
  Application.ProcessMessages;
  inherited ShowForm;
end;

procedure TCoreFirmForm.ccf(DataSet: TDataSet);
begin
  try
    adsCoreCryptPriceRet.AsCurrency := DM.GetPriceRet(adsCoreCost.AsCurrency);
  except
  end;
end;

procedure TCoreFirmForm.SetFilter(Filter: TFilter);
var
  FP : TFilterRecordEvent;
begin
  FP := nil;
  case Filter of
    filAll:
      begin
        if Length(InternalSearchText) > 0 then
          FP := AllFilterRecord
        else begin
          FP := nil;
          tmrSearch.Enabled := False;
          eSearch.Text := '';
          InternalSearchText := '';
        end;
      end;
    filOrder: FP := OrderCountFilterRecord;
    filLeader: FP := LeaderFilterRecord;
    filProducer: FP := ProducerFilterRecord;
  end;
  DBProc.SetFilterProc(adsCore, FP);
  lblRecordCount.Caption:=Format( '������� : %d', [adsCore.RecordCount]);
  cbFilter.ItemIndex := Integer(Filter);
end;

procedure TCoreFirmForm.cbFilterClick(Sender: TObject);
begin
  dbgCore.SetFocus;
  SetFilter(TFilter(cbFilter.ItemIndex));
end;

procedure TCoreFirmForm.actFilterAllExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filAll);
end;

procedure TCoreFirmForm.actFilterOrderExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filOrder);
end;

procedure TCoreFirmForm.actFilterLeaderExecute(Sender: TObject);
begin
  if Self.Visible then SetFilter(filLeader);
end;

procedure TCoreFirmForm.Print( APreview: boolean = False);
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
begin
  RefreshCurrentOrderHeader;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  adsCore.DisableControls;
  try
    adsCore.Filtered := False;
    adsCore.IndexFieldNames := 'SynonymName';
    frVariables[ 'OrdersComments'] := adsCurrentOrderHeader.FieldByName('Comments').AsVariant;

    if DM.adsPrices.Active then
      DM.adsPrices.Close;
    try
      DM.adsPrices.ParamByName('ClientId').Value := Self.ClientId;
      DM.adsPrices.ParamByName('TimeZoneBias').Value := TimeZoneBias;
      DM.adsPrices.Open;
      DM.adsPrices.Locate('PriceCode;RegionCode', VarArrayOf([ PriceCode, RegionCode]), []);
      frVariables[ 'PricesSupportPhone'] := DM.adsPricesSupportPhone.Value;
      frVariables[ 'PricesFullName'] := DM.adsPricesFullName.Value;
      frVariables[ 'PricesDatePrice'] := DM.adsPricesDatePrice.AsString;
    finally
      DM.adsPrices.Close;
    end;

    DM.ShowFastReport('CoreFirm.frf', adsCore, APreview);
  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    dbgCore.OnSortMarkingChanged(dbgCore);
    adsCore.EnableControls;
  end;
end;

//������������� ��������� ��� �������� ������
//����� ��� ������. �� �������, �.�. ��������� ������ �����-�����
procedure TCoreFirmForm.RefreshCurrentOrderHeader;
begin
  with adsCurrentOrderHeader do begin
    ParamByName('ClientId').Value:=ClientId;
    ParamByName('PriceCode').Value:=PriceCode;
    ParamByName('RegionCode').Value:=RegionCode;

    if adsCurrentOrderHeader.Active then
      adsCurrentOrderHeader.Close;
    adsCurrentOrderHeader.Open;
  end;
end;

procedure TCoreFirmForm.adsCore2BeforePost(DataSet: TDataSet);
var
  Quantity, E: Integer;
  PriceAvg: Double;
  PanelCaption : String;
  PanelHeight : Integer;
begin
  try
    { ��������� ����� �� ������������ ������� ������ �� ������ }
    Val( adsCoreQuantity.AsString, Quantity, E);
    if E <> 0 then Quantity := 0;
    if ( Quantity > 0) and ( adsCoreORDERCOUNT.AsInteger > Quantity) and
      ( AProc.MessageBox( '����� ��������� ������� �� ������. ����������?',
      MB_ICONQUESTION or MB_OKCANCEL) <> IDOK) then adsCoreORDERCOUNT.AsInteger := Quantity;

    PanelCaption := '';
    
    if (adsCoreBuyingMatrixType.Value > 0) then begin
      if (adsCoreBuyingMatrixType.Value = 1) then begin
        PanelCaption := '�������� �������� � ������.';

        begin
        if Timer.Enabled then
          Timer.OnTimer(nil);

        lWarning.Caption := PanelCaption;
        PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
        plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

        plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
        plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
        plOverCost.BringToFront;
        plOverCost.Show;
        Timer.Enabled := True;
        end;

        Abort;
      end
      else begin
        //PanelCaption := '�������� �� ��������� � ������';
        if AProc.MessageBox(
            '�������� �� ������ � ����������� ������� �������.'#13#10 +
            '�� ������������� ������ �������� ���?',
             MB_ICONWARNING or MB_OKCANCEL) = ID_CANCEL
        then
          Abort;
      end;
    end;
    
    { ��������� �� ���������� ���� }
    if UseExcess and ( adsCoreORDERCOUNT.AsInteger>0) and (not adsAvgOrdersPRODUCTID.IsNull) then
    begin
      PriceAvg := adsAvgOrdersPRICEAVG.AsCurrency;
      if ( PriceAvg > 0) and ( adsCoreCOST.AsCurrency>PriceAvg*(1+Excess/100)) then
      begin
        if Length(PanelCaption) > 0 then
          PanelCaption := PanelCaption + #13#10 + '���������� ������� ����!'
        else
          PanelCaption := '���������� ������� ����!';
      end;
    end;

    if (adsCoreJUNK.AsBoolean) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + '�� �������� �������������� ��������.'
      else
        PanelCaption := '�� �������� �������������� ��������.';

    if (adsCoreORDERCOUNT.AsInteger > WarningOrderCount) then
      if Length(PanelCaption) > 0 then
        PanelCaption := PanelCaption + #13#10 + '��������! �� �������� ������� ���������� ���������.'
      else
        PanelCaption := '��������! �� �������� ������� ���������� ���������.';

    if Length(PanelCaption) > 0 then begin
      if Timer.Enabled then
        Timer.OnTimer(nil);

      lWarning.Caption := PanelCaption;
      PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
      plOverCost.Height := PanelHeight*WordCount(PanelCaption, [#13, #10]) + 20;

      plOverCost.Top := ( dbgCore.Height - plOverCost.Height) div 2;
      plOverCost.Left := ( dbgCore.Width - plOverCost.Width) div 2;
      plOverCost.BringToFront;
      plOverCost.Show;
      Timer.Enabled := True;
    end;

  except
    adsCore.Cancel;
    raise;
  end;
end;

procedure TCoreFirmForm.adsCore2AfterPost(DataSet: TDataSet);
begin
  SetOrderLabel;
  MainForm.SetOrdersInfo;
end;

procedure TCoreFirmForm.SetOrderLabel;
var
  OrderCount : Integer;
  OrderSum: Double;
begin
  OrderCount := DM.QueryValue(
  'SELECT count(*) FROM CurrentOrderLists, CurrentOrderHeads WHERE ' +
    'CurrentOrderHeads.PriceCode = :PriceCode and CurrentOrderHeads.regioncode = :RegionCode ' +
    ' and CurrentOrderHeads.ClientId = :ClientId and CurrentOrderHeads.Frozen = 0 ' +
    ' and CurrentOrderLists.OrderId = CurrentOrderHeads.orderid and CurrentOrderHeads.closed = 0 ' +
    ' AND CurrentOrderLists.OrderCount>0',
    ['PriceCode', 'RegionCode', 'ClientId'],
    [PriceCode, RegionCode, ClientId]);
  OrderSum := DM.FindOrderInfo(PriceCode, RegionCode);
  lblOrderLabel.Caption:=Format('�������� %d ������� �� ����� %0.2f ���.',
    [OrderCount,OrderSum]);
end;

procedure TCoreFirmForm.btnFormHistoryClick(Sender: TObject);
begin
  if not adsCoreproductid.IsNull then
    ShowFormHistory(
      DM.adtParams.FieldByName( 'GroupByProducts').AsBoolean,
      adsCoreFullCode.Value,
      adsCoreproductid.Value,
      ClientId);
end;

procedure TCoreFirmForm.actDeleteOrderExecute(Sender: TObject);
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
  LastPositionByCoreId : Variant;
begin
  if not Visible then Exit;
  if AProc.MessageBox( '������� ���� ����� �� ������� �����-�����?',
    MB_ICONQUESTION or MB_OKCANCEL)<>IDOK then Abort;
  adsCore.DisableControls;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  LastPositionByCoreId := adsCoreCoreId.AsVariant;
  Screen.Cursor:=crHourGlass;
  try
    with DM.adcUpdate do begin
      //������� ����������� ������ (���� ����)
      SQL.Text:= ''
        + ' delete CurrentOrderHeads, CurrentOrderLists'
        + ' FROM CurrentOrderHeads, CurrentOrderLists '
        + ' WHERE '
        + '     (CurrentOrderHeads.ClientId=:ClientId) '
        + ' and (CurrentOrderHeads.PriceCode=:PriceCode) '
        + ' and (CurrentOrderHeads.RegionCode=:RegionCode) '
        + ' and (CurrentOrderHeads.Closed <> 1)'
        + ' and (CurrentOrderHeads.Frozen = 0) '
        + ' and (CurrentOrderLists.OrderId = CurrentOrderHeads.OrderId)';
      ParamByName('CLIENTID').Value := DM.adtClients.FieldByName('ClientId').Value;
      ParamByName('PRICECODE').Value := PriceCode;
      ParamByName('REGIONCODE').Value := RegionCode;
      Execute;
    end;

    adsCore.Filtered := False;
    adsCore.First;
    while not adsCore.Eof do begin
      if not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0) then
        adsCore.RefreshRecord;
      adsCore.Next;
    end;
  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    adsCore.First;
    adsCore.Locate([adsCoreCoreId], LastPositionByCoreId, []);
    adsCore.EnableControls;
    Screen.Cursor:=crDefault;
    SetOrderLabel;
    MainForm.SetOrdersInfo;
  end;
  dbgCore.SetFocus;
  //���� �� ������ ���� �� ����� ������, �� ������������ ���� ��� ������
  if Self.PrevForm is TOrdersForm then begin
    Self.PrevForm.ShowAsPrevForm;
    //Close;
  end;
end;

procedure TCoreFirmForm.dbgCoreGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if adsCoreVITALLYIMPORTANT.AsBoolean then
    AFont.Color := VITALLYIMPORTANT_CLR;

  //������ �����-�����
  if (((adsCoreLEADERPRICECODE.AsInteger = PriceCode) and ( adsCoreLeaderRegionCode.AsLargeInt = RegionCode))
     or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
     )
    and
    (( Column.Field = adsCoreLEADERREGIONNAME) or ( Column.Field = adsCoreLEADERPRICENAME))
  then
    Background := LEADER_CLR;
  //��������� �����
  if (adsCoreJunk.AsBoolean) and (( Column.Field = adsCorePERIOD) or
    ( Column.Field = adsCoreCOST)) then Background := JUNK_CLR;
  //��������� ����� �������� �������
  if (adsCoreAwait.AsBoolean) and ( Column.Field = adsCoreSYNONYMNAME) then
    Background := AWAIT_CLR;
end;

procedure TCoreFirmForm.dbgCoreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = []) and (Key = VK_DELETE) and (not adsCore.IsEmpty) then begin
    Key := 0;
    DeleteOrder;
  end
  else
  if ( Key = VK_RETURN) then
    if tmrSearch.Enabled then
      tmrSearchTimer(nil)
    else
      btnFormHistoryClick( nil);
  if Key = VK_ESCAPE then
    if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) and FOpenWithSearch
    then begin
      tmrSearch.Enabled := False;
      Self.PrevForm.ShowAsPrevForm
    end
    else
      if tmrSearch.Enabled or (Length(InternalSearchText) > 0) then
        SetClear
      else
        if Assigned(Self.PrevForm) and (Self.PrevForm is TPricesForm) then
          //���� ������������ � Prices, �� �������� ShowForm, �.�. ������
          //������ ����� � ������� ����������� �� ����� "������ ����������"
          Self.PrevForm.ShowForm
        else
          if Assigned(Self.PrevForm) then
            Self.PrevForm.ShowAsPrevForm
          else
            Close;
end;

procedure TCoreFirmForm.dbgCoreCanInput(Sender: TObject; Value: Integer;
  var CanInput: Boolean);
begin
  CanInput :=
    (not adsCore.IsEmpty)
    and (( RegionCode and DM.adtClientsREQMASK.AsLargeInt) = RegionCode);
  if not CanInput then Exit;
end;

procedure TCoreFirmForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TCoreFirmForm.actFlipCoreExecute(Sender: TObject);
var
  FullCode, ShortCode: integer;
  CoreId : Int64;
begin
  if MainForm.ActiveChild <> Self then exit;
  if Self.PrevForm is TOrdersForm then exit;

  FullCode := adsCoreFullCode.AsInteger;
  ShortCode := adsCoreShortCode.AsInteger;

  CoreId := adsCoreCOREID.AsLargeInt;

  FlipToCode(FullCode, ShortCode, CoreId);
end;

procedure TCoreFirmForm.dbgCoreKeyPress(Sender: TObject; var Key: Char);
begin
  if ( Key > #32) and not ( Key in
    [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
  begin
    AddKeyToSearch(Key);
  end;
end;

procedure TCoreFirmForm.OrderCountFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
      and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
  else
    Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
  if Accept and (dblProducers.KeyValue <> 0) then
    if dblProducers.KeyValue = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = dblProducers.KeyValue;
end;

procedure TCoreFirmForm.LeaderFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if Length(InternalSearchText) > 0 then
    Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
    and
    (
     ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
    )
  else
    Accept := ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
      or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01);
  if Accept and (dblProducers.KeyValue <> 0) then
    if dblProducers.KeyValue = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = dblProducers.KeyValue;
end;

procedure TCoreFirmForm.RefreshAllCore;
begin
  Screen.Cursor:=crHourglass;
  try
    adsCore.ParamByName( 'PriceCode').Value:=PriceCode;
    adsCore.ParamByName( 'RegionCode').Value:=RegionCode;
    adsCore.ParamByName( 'ClientId').Value:=ClientId;
    ShowSQLWaiting(adsCore);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TCoreFirmForm.dbgCoreSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

procedure TCoreFirmForm.adsCoreOldLEADERPRICENAMEGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01) then
    Text := PriceName
  else
    Text := Sender.AsString;
end;

procedure TCoreFirmForm.tmrSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  if Length(eSearch.Text) > 2 then begin
    eSearch.Enabled := False;
    adsCore.DisableControls;
    try
      InternalSearchText := LeftStr(eSearch.Text, 50);
      if Assigned(Self.PrevForm) and (Self.PrevForm is TOrdersForm) and FOpenWithSearch
      then begin
        adsCore.Close;
        adsCore.SQL.Text := adsCoreWithLike.SQL.Text;
        adsCore.ParamByName('LikeParam').AsString := '%' + InternalSearchText + '%';
        RefreshAllCore;
        dbgCore.InputField := 'OrderCount';
      end;
      if not Assigned(adsCore.OnFilterRecord) then begin
        adsCore.OnFilterRecord := AllFilterRecord;
        adsCore.Filtered := True;
      end
      else
        DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
    finally
      adsCore.EnableControls;
      eSearch.Enabled := True;
    end;
    lblRecordCount.Caption:=Format( '������� : %d', [adsCore.RecordCount]);
    eSearch.Text := '';
  end
  else
    if Length(eSearch.Text) = 0 then
      SetClear;
end;

procedure TCoreFirmForm.AllFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
  if Accept and (dblProducers.KeyValue <> 0) then
    if dblProducers.KeyValue = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = dblProducers.KeyValue;
end;

procedure TCoreFirmForm.SetClear;
var
  p : TFilterRecordEvent;
begin
  tmrSearch.Enabled := False;
  eSearch.Enabled := False;
  adsCore.DisableControls;
  try
    eSearch.Text := '';
    InternalSearchText := '';
    p := AllFilterRecord;
    if @adsCore.OnFilterRecord = @p then begin
      adsCore.Filtered := False;
      adsCore.OnFilterRecord := nil;
    end
    else
      DBProc.SetFilterProc(adsCore, adsCore.OnFilterRecord);
  finally
    adsCore.EnableControls;
    eSearch.Enabled := True;
  end;
  lblRecordCount.Caption:=Format( '������� : %d', [adsCore.RecordCount]);
end;

procedure TCoreFirmForm.dbgCoreDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  if Column.Field = adsCoreSYNONYMNAME then
    ProduceAlphaBlendRect(InternalSearchText, Column.Field.DisplayText, dbgCore.Canvas, Rect, BM);
end;

procedure TCoreFirmForm.eSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    tmrSearchTimer(nil);
    dbgCore.SetFocus;
  end
  else
    if Key = VK_ESCAPE then
      SetClear;
end;

procedure TCoreFirmForm.eSearchKeyPress(Sender: TObject; var Key: Char);
begin
  tmrSearch.Enabled := False;
  AddKeyToSearch(Key);
  //���� �� ���-�� ������ � ��������, �� ������ �� ��� �������������
  if Ord(Key) <> VK_RETURN then
    tmrSearch.Enabled := True;
end;

procedure TCoreFirmForm.AddKeyToSearch(Key: Char);
begin
  if Ord(Key) >= 32 then begin
    tmrSearch.Enabled := False;
    if not eSearch.Focused then
      eSearch.Text := eSearch.Text + Key;
    tmrSearch.Enabled := True;
  end;
end;

procedure TCoreFirmForm.dblProducersCloseUp(Sender: TObject);
begin
  if dblProducers.KeyValue = 0 then
    SetFilter(TFilter(cbFilter.ItemIndex))
  else
    SetFilter(filProducer);
  dbgCore.SetFocus;
end;

procedure TCoreFirmForm.ProducerFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  case cbFilter.ItemIndex of
    0 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText);
      end;
    1 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
            and not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0)
        else
          Accept := not adsCoreORDERCOUNT.IsNull and (adsCoreORDERCOUNT.AsInteger > 0);
      end;
    2 :
      begin
        if Length(InternalSearchText) > 0 then
          Accept := AnsiContainsText(adsCoreSYNONYMNAME.DisplayText, InternalSearchText)
          and
          (
           ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
            or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01)
          )
        else
          Accept := ((adsCoreLEADERPRICECODE.AsVariant = PriceCode) and (adsCoreLEADERREGIONCODE.AsVariant = RegionCode))
            or (abs(adsCoreCOST.AsCurrency - adsCoreLEADERPRICE.AsCurrency) < 0.01);
      end;
  end;
  if Accept then
    if dblProducers.KeyValue = 1 then
      Accept := adsCoreCodeFirmCr.AsVariant = 0
    else
      Accept := adsCoreCodeFirmCr.AsVariant = dblProducers.KeyValue;
end;

procedure TCoreFirmForm.DeleteOrder;
var
  OldFilterEvent : TFilterRecordEvent;
  OldFiltered : Boolean;
  LastPositionByCoreId : Variant;
  I : Integer;
  selectedRows : TStringList;
begin
  if not Visible then Exit;
  selectedRows := TDBGridHelper.GetSelectedRows(dbgCore);
  if (selectedRows.Count > 0)
    and (AProc.MessageBox( '������� ��������� �������?', MB_ICONQUESTION or MB_OKCANCEL) <> IDOK)
  then
    Abort;
  adsCore.DisableControls;
  OldFiltered := adsCore.Filtered;
  OldFilterEvent := adsCore.OnFilterRecord;
  LastPositionByCoreId := adsCoreCoreId.AsVariant;
  Screen.Cursor:=crHourGlass;
  try

    for I := 0 to selectedRows.Count-1 do begin
      adsCore.Bookmark := selectedRows[i];
      if adsCoreOrderCount.Value > 0 then begin
        adsCore.Edit;
        adsCoreOrderCount.Value := 0;
        adsCore.Post;
      end;
    end;

  finally
    if OldFiltered then
      DBProc.SetFilterProc(adsCore, OldFilterEvent);
    adsCore.First;
    adsCore.Locate([adsCoreCoreId], LastPositionByCoreId, []);
    adsCore.EnableControls;
    Screen.Cursor:=crDefault;
    SetOrderLabel;
    MainForm.SetOrdersInfo;
  end;
  //���� �� ������ ���� �� ����� ������, �� ������������ ���� ��� ������
  if Self.PrevForm is TOrdersForm then begin
    Self.PrevForm.ShowAsPrevForm;
    //Close;
  end;
end;

end.
