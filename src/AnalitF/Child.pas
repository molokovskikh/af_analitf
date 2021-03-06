unit Child;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ToughDBGrid, ExtCtrls, DB, DBProc, DBGrids, Contnrs,
  MyAccess, DBAccess, StdCtrls, DescriptionFrm, Buttons,
  DayOfWeekHelper,
  Menus,
  HtmlView,
  DBGridEh,
  GlobalSettingParams;

type
  {����� ��� ������������� WindowProc ���� ToughDBGrid �� �������� �����,
   ����� � ������� ����� ���� ���� ����������� ����� WindowProc.
   ���� ����� �� �������, �� ����� ��������� ������ "A call to an OS function failed"
   ������� ��������� �� ��������: http://www.delphikingdom.com/asp/answer.asp?IDAnswer=34018
   �������� ������� � ���, ��� �� ���������� �������������� ������ � DB-��������� ����� ����,
   ��� ������������ ������� �� WebBrowser'�, ������� ���������� �� ��� �� ����� ��� � DB-���������.
  }
  TDBComponentWindowProc = class
   private
    FFormHandle : THandle;
    FOldDBGridWndProc: TWndMethod;
    FGrid : TToughDBGrid;
    FGridCopy : TMenuItem;
    FOldOnBeforePopup : TNotifyEvent;
    FOldOnPopupColumnsClick : TNotifyEvent;
    procedure HackDBGirdWndProc(var Message: TMessage);
    procedure OnPopupCopyGridClick(Sender: TObject);
    procedure OnBeforePopup(Sender : TObject);
    function GetSaveFlag() : Boolean;
    procedure OnPopupColumnsClick(Sender: TObject);
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
    tmrOverCostHide: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tCheckVolumeTimer(Sender: TObject);
    procedure tmrOverCostHideTimer(Sender: TObject);
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
    fCoreQuantity : TField;
    disableCoreQuantityCheck : Boolean;
    disableClearOrder : Boolean;
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

    plOverCost : TPanel;
    lWarning : TLabel;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure DoShow; override;
    procedure UpdateReclame;
    procedure PatchNonBrowser;
    //������������ connection ��� MySQL-���������
    procedure PatchMyDataSets;
    //���������, ��� ����� ������ ������ Volume
    function  CheckVolume : Boolean;
    //���������, ��� ����� ������ >= OrderCost
    function  CheckByOrderCost : Boolean;
    //���������, ��� ���������� ���-�� >= MinOrderCount
    function  CheckByMinOrderCount : Boolean;
    //���������, ��� ������� �� ��������� � ������
    function  CheckByBuyingMatrixType : Boolean;
    //������� ��������� �����
    procedure ClearOrder;
    //������� ��������� �����
    procedure ClearOrderByOrderCost;
    //������������� ��������
    procedure ClearOrderByMinOrderCount;
    //������� ��������� �����
    procedure ClearOrderByVolume;
    function  GetCorrectOrder(order : Integer) : Integer;
    function  AllowOrderByCoreQuantity(order : Integer; var coreQuantity : Integer) : Boolean;
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
    procedure CreateOverCostPanel;
    procedure ShowOverCostPanel(panelCaption : String; grid : TCustomDBGridEh);
  public
    PrintEnabled: Boolean;
    //��������� ��������� ������������ �������
    SaveEnabled: Boolean;
    //��������� ������� First ����� ���������� DataSet
    NeedFirstOnDataSet : Boolean;
    //����������� ���� � �������
    SortOnOrderGrid : Boolean;

    FGS : TGlobalSettingParams;
    procedure ShowForm; overload; virtual;
    procedure ShowAsPrevForm; virtual;
    procedure Print( APreview: boolean = False); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function SearchInProgress : Boolean; virtual;
  published
    //���������� FActionList � ������ TForm
    property ActionLists: TList read GetActionLists write SetActionLists;
    procedure BeforeUpdateExecuteForClientID(
      Sender: TCustomMyDataSet;
      StatementTypes: TStatementTypes;
      Params: TDAParams);
  end;

  TChildFormClass=class of TChildForm;

implementation

uses Main, AProc, Constant, DModule, MyEmbConnection, Core,
  NamesForms,
  DBGridHelper, Variants, Math;

{$R *.DFM}

procedure TChildForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //����� ����� ��������
  Params.Style:=Params.Style or WS_CHILD;
end;

procedure TChildForm.Loaded;
begin
  inherited Loaded;
  //��������� ����� ������� �����
  Parent:=Application.MainForm;
  UpdateReclame;
end;

//��� ����, ����� TAction, ��������� �� �������� ����� ��������, ���� ��������
//�� �� ������� �����
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

//��� �������� �������� ����� ���� ������� �� ������� �� TAction
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
  Self.Width := MainForm.pMain.Width;
  Self.Height := MainForm.pMain.Height;
  plOverCost.Hide();
  SetActiveChildToMainForm;
  for I := 0 to Self.ComponentCount-1 do
    if (Self.Components[i] is TToughDBGrid)
    then begin
      TDBGridHelper.SetMinWidthToColumns(TToughDBGrid(Self.Components[i]));
      TToughDBGrid(Self.Components[i]).AllowedSelections := [gstRecordBookmarks, gstRectangle];;
      TToughDBGrid(Self.Components[i]).Options := TToughDBGrid(Self.Components[i]).Options + [dgRowLines];
      TToughDBGrid(Self.Components[i]).OptionsEh := TToughDBGrid(Self.Components[i]).OptionsEh + [dghResizeWholeRightPart];
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
  htmlView : String;
begin
  for i := 0 to Self.ComponentCount - 1 do
    if Self.Components[ i] is THTMLViewer then
    begin
      try
        if DM.adsUser.FieldByName('ShowAdvertising').IsNull or DM.adsUser.FieldByName('ShowAdvertising').AsBoolean
        then begin
          openFileName := RootFolder() + SDirReclame + '\' + '2block.gif';
          if SysUtils.FileExists(openFileName)
          then begin
            htmlView := '' +
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' +
'<html>' +
'<head>' +
'<title>Untitled Document</title>' +
'<meta http-equiv="Content-Type" content="text/html; charset=KOI8-R">' +
'</head>' +
'<body style="padding:0;margin:0;">' +
'<div align="center" style="padding:0;margin:0;font-size:0;"><img src="' + openFileName + '" width="481" height="125"> </div>' +
'</body>' +
'</html>';
            THTMLViewer(Self.Components[i]).LoadFromBuffer(PChar(htmlView), Length(htmlView));
          end;
        end
        else
          THTMLViewer( Self.Components[i] ).Clear;
      except
        on E : Exception do
          LogCriticalError(
            '������ ��� �������� ����� � WebBrowser�: ' + E.Message + #13#10 +
            '��������� ������: ' + SysErrorMessage(GetLastError()));
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
  FGS := TGlobalSettingParams.Create(DM.MainConnection);
  disableCoreQuantityCheck := False;
  disableClearOrder := False;
  NeedFirstOnDataSet := True;
  SortOnOrderGrid := True;
  FUseCorrectOrders := DM.adsUser.FieldByName('UseCorrectOrders').AsBoolean;
  FAllowDelayOfPayment := DM.adsUser.FieldByName('AllowDelayOfPayment').AsBoolean;
  FShowSupplierCost := DM.adsUser.FieldByName('ShowSupplierCost').AsBoolean;

  ModifiedActions        := TObjectList.Create(True);
  DBComponentWindowProcs := TObjectList.Create(True);
  inherited;
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
  fOrder.AsInteger := 0;
  dsCheckVolume.Post;
end;

procedure TChildForm.ShowVolumeMessage;
begin
  tCheckVolume.Enabled := False;

  if dsCheckVolume.IsEmpty then
    Exit;

  //�������� �� ������������ ����� ������, ������������ ��������
  if fOrder.AsInteger > MaxOrderCount then begin
    SoftEdit(dsCheckVolume);
    fOrder.AsInteger := GetCorrectOrder(MaxOrderCount);
    dsCheckVolume.Post;
  end;

  if (dsCheckVolume.RecordCount > 0) and not CheckVolume then begin
    AProc.MessageBox(
      Format(
        '����������� ���������� ��������� �� ������������ �������.'#13#10 +
        '��������� �������� "%s" �� ������ �������������� �������� "%s".',
        [fOrder.AsString, fVolume.AsString]),
      MB_ICONWARNING);
    ClearOrderByVolume;
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
    ClearOrderByMinOrderCount;
    Abort;
  end;
  if (dsCheckVolume.RecordCount > 0) and not CheckByBuyingMatrixType then begin
    if AProc.MessageBox(
        '�������� �� ������ � ����������� ������� �������.'#13#10 +
        '�� ������������� ������ �������� ���?',
         MB_ICONWARNING or MB_OKCANCEL) = ID_CANCEL
    then begin
      ClearOrder;
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
  PatchNonBrowser;
  CreateOverCostPanel;
  if Assigned(dsCheckVolume) and Assigned(dgCheckVolume) and Assigned(fOrder)
     and Assigned(fVolume) and Assigned(fOrderCost) and Assigned(fSumOrder) and Assigned(fMinOrderCount)
     and Assigned(fCoreQuantity)
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
        gotoMNNAction.Caption := '�������� �������� (Ctrl+N)';
        gotoMNNAction.Hint := '������� � ������� � ����������� �� ���';
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
      ShowDescriptionAction.Caption := '�������� �������� (Space)';
      ShowDescriptionAction.ShortCut := TextToShortCut('Space');
      ShowDescriptionAction.OnUpdate := ShowDescriptionUpdate;
      ShowDescriptionAction.OnExecute := ShowDescriptionExecute;
      ShowDescriptionAction.ActionList := al;

      ShowDescriptionActionByF1 := TAction.Create(al);
      ShowDescriptionActionByF1.Name := '';
      ShowDescriptionActionByF1.Caption := '�������� �������� (F1)';
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
  //��� ���: ����� ����� �� ����������� �� adsCore �� ����� TOrdersForm  
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
  fOrder.AsInteger := GetCorrectOrder(fOrder.AsInteger);
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
  FGS.Free;
end;

{ TDBComponentWindowProc }

constructor TDBComponentWindowProc.Create(AFormHandle: THandle;
  AOldDBGridWndProc: TWndMethod; Grid : TToughDBGrid);
var
  columnsItem : TMenuItem;
begin
  FFormHandle := AFormHandle;
  FOldDBGridWndProc := AOldDBGridWndProc;
  FGrid := Grid;

  if Assigned(FGrid.PopupMenu) then begin
    FOldOnBeforePopup := FGrid.PopupMenu.OnPopup;
    FGrid.PopupMenu.OnPopup := OnBeforePopup;
    columnsItem := FGrid.PopupMenu.Items.Find('�������...');
    if Assigned(columnsItem) then begin
      FOldOnPopupColumnsClick := columnsItem.OnClick;
      columnsItem.OnClick := OnPopupColumnsClick;
    end;
    FGridCopy := TMenuItem.Create(FGrid.PopupMenu);
    FGridCopy.Caption := '����������';
    FGridCopy.OnClick := OnPopupCopyGridClick;
    FGrid.PopupMenu.Items.Add(FGridCopy);
  end;
end;

function TDBComponentWindowProc.GetSaveFlag: Boolean;
begin
  Result := (FGrid.Tag = -1) or ((FGrid.Tag and DM.SaveGridMask) > 0);  
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
    //�������� ��������, ����� ��������� "ClientId" �� ����� � ����������� �������
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
  noteColumn : TColumnEh;
  periodColumn : TColumnEh;

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
  periodColumn := ColumnByNameT(Grid, 'Period');
  if Assigned(periodColumn) then begin
    periodColumn.FieldName := 'Exp';
  end;
  noteColumn := ColumnByNameT(Grid, 'Note');
  if Assigned(noteColumn) then begin
    noteColumn.Visible := True;
    noteColumn.Tag := 1;
  end;
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
      if SortOnOrderGrid then
        producerNameColumn.Title.TitleButton := True;
    end;
  end;

  if Assigned(realCostColumn) then  begin
    ndsColumn := ColumnByNameT(Grid, 'NDS');
    if not Assigned(ndsColumn) then begin
      ndsColumn := TColumnEh(Grid.Columns.Insert(realCostColumn.Index));
      ndsColumn.FieldName := 'NDS';
      ndsColumn.Title.Caption := '���';
      ndsColumn.Width := Grid.Canvas.TextWidth(ndsColumn.Title.Caption);
      if SortOnOrderGrid then
        ndsColumn.Title.TitleButton := True;
    end;
    supplierPriceMarkupColumn := ColumnByNameT(Grid, 'SupplierPriceMarkup');
    if not Assigned(supplierPriceMarkupColumn) then begin
      supplierPriceMarkupColumn := TColumnEh(Grid.Columns.Insert(ndsColumn.Index));
      supplierPriceMarkupColumn.FieldName := 'SupplierPriceMarkup';
      supplierPriceMarkupColumn.Title.Caption := '������� ����������';
      supplierPriceMarkupColumn.Width := Grid.Canvas.TextWidth('00.00');
      if SortOnOrderGrid then
        supplierPriceMarkupColumn.Title.TitleButton := True;
      supplierPriceMarkupColumn.DisplayFormat := '0.00;;''''';
    end;
    producerCostColumn := ColumnByNameT(Grid, 'ProducerCost');
    if not Assigned(producerCostColumn) then begin
      producerCostColumn := TColumnEh(Grid.Columns.Insert(supplierPriceMarkupColumn.Index));
      producerCostColumn.FieldName := 'ProducerCost';
      producerCostColumn.Title.Caption := '���� �������������';
      producerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      if SortOnOrderGrid then
        producerCostColumn.Title.TitleButton := True;
      producerCostColumn.DisplayFormat := '0.00;;''''';
    end;
    maxProducerCostColumn := ColumnByNameT(Grid, 'MaxProducerCost');
    if not Assigned(maxProducerCostColumn) then begin
      maxProducerCostColumn := TColumnEh(Grid.Columns.Insert(producerCostColumn.Index));
      maxProducerCostColumn.FieldName := 'MaxProducerCost';
      maxProducerCostColumn.Title.Caption := '����.�����.����';
      maxProducerCostColumn.Width := Grid.Canvas.TextWidth('000.00');
      if SortOnOrderGrid then
        maxProducerCostColumn.Title.TitleButton := True;
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
        AProc.MessageBox('��� ������ ������� �� ����������� ���.', MB_ICONWARNING);
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
  if Self.SearchInProgress then
    Exit;
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
+'       Descriptions.Interaction, '
+'       Descriptions.SideEffect, '
+'       Descriptions.IndicationsForUse, '
+'       Descriptions.Dosing, '
+'       Descriptions.Warnings, '
+'       Descriptions.ProductForm, '
+'       Descriptions.PharmacologicalAction, '
+'       Descriptions.Storage, '
+'       Descriptions.Expiration, '
+'       Descriptions.Composition, '
+'       Descriptions.Hidden '
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
          AProc.MessageBoxEx('�������� �����������.', '��������', MB_ICONWARNING)
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
        and not Self.SearchInProgress    
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
  Show;
  SetActiveChildToMainForm;
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

procedure TDBComponentWindowProc.OnPopupColumnsClick(Sender: TObject);
var
  I : Integer;
begin
  if Assigned(FOldOnPopupColumnsClick) then
    FOldOnPopupColumnsClick(Sender);
  for I := 0 to FGrid.Columns.Count-1 do
    if (FGrid.Columns[i].Tag = 1) and not FGrid.Columns[i].Visible then
      FGrid.Columns[i].Visible := True;
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

procedure TChildForm.CreateOverCostPanel;
begin
  plOverCost := TPanel.Create(Self);
  plOverCost.Name := 'plOverCost';
  plOverCost.Visible := False;
  plOverCost.ParentFont := False;
  plOverCost.Font.Color := clRed;
  plOverCost.Font.Size := 16;
  plOverCost.Parent := Self;
  plOverCost.ControlStyle := plOverCost.ControlStyle - [csParentBackground] + [csOpaque];

  lWarning := TLabel.Create(Self);
  lWarning.Name := 'lWarning';
  lWarning.AutoSize := False;
  lWarning.Parent := plOverCost;
  lWarning.Align := alClient;
  lWarning.Alignment := taCenter;
  lWarning.Layout := tlCenter;
  lWarning.ControlStyle := lWarning.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TChildForm.tmrOverCostHideTimer(Sender: TObject);
begin
  tmrOverCostHide.Enabled := False;
  plOverCost.Hide;
  plOverCost.SendToBack;
end;

procedure TChildForm.ShowOverCostPanel(panelCaption: String; grid : TCustomDBGridEh);
var
  PanelHeight : Integer;
  sl : TStringList;
  CaptionWordCount,
  I,
  panelWidth : Integer;
begin
  if tmrOverCostHide.Enabled then
    tmrOverCostHide.OnTimer(nil);

  if lWarning.Canvas.Font.Size <> lWarning.Font.Size then
    lWarning.Canvas.Font.Size := lWarning.Font.Size;

  sl := TStringList.Create;
  try
    sl.Text := panelCaption;
    CaptionWordCount := sl.Count;
    panelWidth := lWarning.Canvas.TextWidth(sl[0]);
    for I := 1 to sl.Count-1 do
      if lWarning.Canvas.TextWidth(sl[i]) > panelWidth then
        panelWidth := lWarning.Canvas.TextWidth(sl[i]);
  finally
    sl.Free;
  end;

  lWarning.Caption := PanelCaption;
  PanelHeight := lWarning.Canvas.TextHeight(PanelCaption);
  plOverCost.Height := PanelHeight * CaptionWordCount + 20;
  plOverCost.Width := panelWidth + 40;

  plOverCost.Parent := grid.Parent;
  plOverCost.Top := grid.Top + ( grid.Height - plOverCost.Height) div 2;
  plOverCost.Left := grid.Left + ( grid.Width - plOverCost.Width) div 2;
  plOverCost.BringToFront;
  plOverCost.Show;
  tmrOverCostHide.Enabled := True;
end;

function TChildForm.SearchInProgress: Boolean;
begin
  Result := False;
end;

procedure TChildForm.ClearOrderByMinOrderCount;
var
  newOrder : Integer;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := GetCorrectOrder(fOrder.AsInteger);
  dsCheckVolume.Post;
end;

function TChildForm.AllowOrderByCoreQuantity(order: Integer; var coreQuantity : Integer): Boolean;
var
  Quantity, E: Integer;
begin
  Result := Assigned(fCoreQuantity);
  if Result then begin
    Val(fCoreQuantity.AsString, Quantity, E);
    if E <> 0 then Quantity := 0;
    coreQuantity := Quantity;
    Result := (Quantity <= 0) or (Quantity >= order);
  end;
end;

procedure TChildForm.ClearOrderByVolume;
var
  value : Integer;
begin
  SoftEdit(dsCheckVolume);
  fOrder.AsInteger := GetCorrectOrder(fOrder.AsInteger);
  dsCheckVolume.Post;
end;

function TChildForm.GetCorrectOrder(order: Integer): Integer;
var
  volumeOrder,
  minCountOrder,
  minSumOrder,
  coreQuantity : Integer;
begin
  coreQuantity := order;

  //�������� ����������� �������� �� ���������
  if not CheckVolume then begin
    volumeOrder := order - (order mod fVolume.AsInteger);
    if volumeOrder = 0 then
      volumeOrder := fVolume.AsInteger;
  end
  else
    volumeOrder := order;

  //�������� ����������� �������� �� ����������
  if not CheckByMinOrderCount then
    minCountOrder := fMinOrderCount.AsInteger
  else
    minCountOrder := 0;

  //�������� ����������� �������� ������ �� ����� ������
  if not CheckByOrderCost then
    minSumOrder := Ceil( fOrderCost.AsCurrency / (fSumOrder.AsCurrency / fOrder.AsInteger))
  else
    minSumOrder := 0;

  //������� ������������ �������� ����� ����������� � ������ ������
  minCountOrder := Max(minCountOrder, minSumOrder);

  //���� ����� �� ��������� ������ ������������ ������, �� ����������� �� ������������ ��������
  if volumeOrder < minCountOrder then
    if not fVolume.IsNull and (fVolume.AsInteger > 0 ) then
      volumeOrder := Ceil(minCountOrder / fVolume.AsInteger) * fVolume.AsInteger
    else
      volumeOrder := minCountOrder;

  //���� ��������� �� ������� � ���� ���������� �� �������    
  if not disableCoreQuantityCheck and not AllowOrderByCoreQuantity(volumeOrder, coreQuantity) then begin
    //��������� �����, ����� ������������ �������
    if not fVolume.IsNull and (fVolume.AsInteger > 0 ) then
      volumeOrder := (coreQuantity div fVolume.AsInteger) * fVolume.AsInteger
    else
      volumeOrder := coreQuantity;

    //���� ���������� ������ ����� ����� �� ������������� ������������ ����������, �� ���������� �����  
    if volumeOrder < minCountOrder then
      volumeOrder := 0;
  end;

  //���� � ���������� �������� �� �������� ������, ��� ���� ������������, �� ���������� ��� �������� 
  if not disableClearOrder and (volumeOrder > order) then
    volumeOrder := 0;

  Result := volumeOrder;
end;

end.
