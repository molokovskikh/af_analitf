unit Child;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, SHDocVw, ToughDBGrid, ExtCtrls, DB, DBProc, DBGrids, Contnrs,
  MyAccess, DBAccess, StdCtrls, DescriptionFrm, Buttons;

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
    procedure HackDBGirdWndProc(var Message: TMessage);
   public
    constructor Create(AFormHandle : THandle; AOldDBGridWndProc: TWndMethod);
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
    fOrder        : TField;
    fVolume       : TField;
    fOrderCost    : TField;
    fSumOrder     : TField;
    fMinOrderCount : TField;
    OldAfterPost : TDataSetNotifyEvent;
    OldBeforePost : TDataSetNotifyEvent;
    OldBeforeScroll : TDataSetNotifyEvent;
    OldExit : TNotifyEvent;

    DBComponentWindowProcs : TObjectList;

    FUseCorrectOrders : Boolean;

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
    //������������ connection ��� MySQL-���������
    procedure PatchMyDataSets;
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
    procedure NewAfterPost(DataSet : TDataSet);
    procedure NewBeforePost(DataSet: TDataSet);
    procedure NewBeforeScroll(DataSet : TDataSet);
    procedure NewExit(Sender : TObject);
    procedure FilterByMNNExecute(Sender: TObject);
    procedure ShowDescriptionExecute(Sender: TObject);
    procedure ShowDescriptionUpdate(Sender: TObject);
    procedure PrepareColumnsInOrderGrid(Grid : TToughDBGrid);
    procedure SetPrevForm;
    procedure HideAllForms;
    procedure SetActiveChildToMainForm;
    procedure UpdateOrderDataset; virtual;
  public
    PrintEnabled: Boolean;
    //��������� ��������� ������������ �������
    SaveEnabled: Boolean;
    //��������� ������� First ����� ���������� DataSet
    NeedFirstOnDataSet : Boolean;
    procedure ShowForm; overload; virtual;
    procedure ShowAsPrevForm; virtual;
    procedure Print( APreview: boolean = False); virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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

uses Main, AProc, DBGridEh, Constant, DModule, MyEmbConnection, Menus, Core,
  NamesForms;

{$R *.DFM}

procedure TChildForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //����� ����� ��������
  Params.Style:=Params.Style or WS_CHILD;
  // This only works on Windows XP and above
  if CheckWin32Version(5, 1) then
    Params.ExStyle := Params.ExStyle or WS_EX_COMPOSITED;
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
  SetActiveChildToMainForm;
  for I := 0 to Self.ComponentCount-1 do
    if (Self.Components[i] is TToughDBGrid)
    then begin
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
begin
	for i := 0 to Self.ComponentCount - 1 do
		if Self.Components[ i] is TWebBrowser then
		begin
			if SysUtils.FileExists( ExePath + SDirReclame + '\' +
				FormatFloat( '00', Self.Components[ i].Tag) + '.htm') then
				TWebBrowser( Self.Components[ i]).Navigate(
				ExePath + SDirReclame + '\' + FormatFloat( '00',
				Self.Components[ i].Tag) + '.htm');
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
      hack := TDBComponentWindowProc.Create(Self.Handle, TToughDBGrid( Self.Components[ i]).WindowProc);
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
  FUseCorrectOrders := False;
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
end;

{ TDBComponentWindowProc }

constructor TDBComponentWindowProc.Create(AFormHandle: THandle;
  AOldDBGridWndProc: TWndMethod);
begin
  FFormHandle := AFormHandle;
  FOldDBGridWndProc := AOldDBGridWndProc;
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
  if (DM.MainConnection is TMyEmbConnection) then
    for I := 0 to ComponentCount-1 do
      if Components[i] is TCustomMyDataSet then
        TCustomMyDataSet(Components[i]).Connection := DM.MainConnection;
end;

procedure TChildForm.BeforeUpdateExecuteForClientID(
  Sender: TCustomMyDataSet; StatementTypes: TStatementTypes;
  Params: TDAParams);
begin
  if (stUpdate in StatementTypes) or (stRefresh in StatementTypes) then
    //�������� ��������, ����� ��������� "ClientId" �� ����� � ����������� �������
    if Assigned(Params.FindParam('ClientId')) then
      Params.ParamByName('ClientId').Value := Sender.Params.ParamByName('ClientId').Value;
end;

procedure TChildForm.PrepareColumnsInOrderGrid(Grid : TToughDBGrid);
var
  realCostColumn : TColumnEh;
  supplierPriceMarkupColumn : TColumnEh;
begin
  realCostColumn := ColumnByNameT(Grid, 'RealCost');
  if not Assigned(realCostColumn) then
    realCostColumn := ColumnByNameT(Grid, 'RealPrice');

  if Assigned(realCostColumn) then  begin
    supplierPriceMarkupColumn := ColumnByNameT(Grid, 'SupplierPriceMarkup');
    if not Assigned(supplierPriceMarkupColumn) then begin
      supplierPriceMarkupColumn := TColumnEh(Grid.Columns.Insert(realCostColumn.Index));
      supplierPriceMarkupColumn.FieldName := 'SupplierPriceMarkup';
      supplierPriceMarkupColumn.Title.Caption := '������� ����������';
      supplierPriceMarkupColumn.DisplayFormat := '0.00;;''''';
    end;
    realCostColumn.Title.Caption := '���� ����������';
    //������� ������� "���� ��� ��������", ���� �� ������� �������� � ��������� �������
    if not DM.adtClientsAllowDelayOfPayment.Value then
      Grid.Columns.Delete(realCostColumn.Index)
    else
      //���� �� �������� �������, �� ������� ������ ������������ �� ���������
      realCostColumn.Visible := True;
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
  grid : TToughDBGrid;
begin
  if (MainForm.ActiveChild = Self)
     and Assigned(Screen.ActiveControl)
     and (Screen.ActiveControl is TToughDBGrid)
  then begin
  grid := TToughDBGrid(Screen.ActiveControl);
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
  grid : TToughDBGrid;
begin
  if Assigned(Sender) and (Sender is TAction) then

    TAction(Sender).Enabled := (MainForm.ActiveChild = Self);

    if TAction(Sender).Enabled then begin

      TAction(Sender).Enabled :=
            Assigned(Screen.ActiveControl)
        and (Screen.ActiveControl is TToughDBGrid);

      if TAction(Sender).Enabled then begin

        grid := TToughDBGrid(Screen.ActiveControl);

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
  MainForm.ActiveChild:=Self;
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

end.
