unit Child;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, SHDocVw, ToughDBGrid, ExtCtrls, DB, DBProc, DBGrids;

type
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
    OldAfterPost : TDataSetNotifyEvent;
    OldBeforePost : TDataSetNotifyEvent;
    OldBeforeScroll : TDataSetNotifyEvent;
    OldExit : TNotifyEvent;
    
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    procedure DoShow; override;
    procedure UpdateReclame;
    procedure PatchNonBrowser;
    //Проверяем, что заказ сделан кратно Volume
    function  CheckVolume : Boolean; 
    //очищаем созданный заказ
    procedure ClearOrder;
    procedure ShowVolumeMessage;
    procedure NewAfterPost(DataSet : TDataSet);
    procedure NewBeforePost(DataSet: TDataSet);
    procedure NewBeforeScroll(DataSet : TDataSet);
    procedure NewExit(Sender : TObject);
  public
    PrintEnabled: Boolean;
    //Разрешено сохранять отображаемую таблицу
    SaveEnabled: Boolean;
    //Требуется вызвать First после сортировки DataSet
    NeedFirstOnDataSet : Boolean;
    procedure ShowForm; overload; virtual;
    procedure Print( APreview: boolean = False); virtual;
    constructor Create(AOwner: TComponent); override;
  published
    //Вытаскивае FActionList у класса TForm
    property ActionLists: TList read GetActionLists write SetActionLists;
  end;

  TChildFormClass=class of TChildForm;

implementation

uses Main, AProc, DBGridEh;

{$R *.DFM}

procedure TChildForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //форма будет дочерней
  Params.Style:=Params.Style or WS_CHILD;
end;

procedure TChildForm.Loaded;
begin
  inherited Loaded;
  //родителем будет главная форма
  Parent:=Application.MainForm;
  UpdateReclame;
  PatchNonBrowser;
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
  MainForm.ActiveChild:=Self;
  if Caption <> '' then
    MainForm.Caption := Application.Title + ' - ' + Caption;
  for I := 0 to Self.ComponentCount-1 do
    if (Self.Components[i] is TToughDBGrid)
    then begin
      TToughDBGrid(Self.Components[i]).Options := TToughDBGrid(Self.Components[i]).Options + [dgRowLines];
      TToughDBGrid(Self.Components[i]).Font.Size := 10;
      TToughDBGrid(Self.Components[i]).GridLineColors.DarkColor := clBlack;
      TToughDBGrid(Self.Components[i]).GridLineColors.BrightColor := clDkGray;

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
  if Parent<>nil then
    for I:=0 to Parent.ControlCount-1 do
      if (Parent.Controls[I] is TChildForm)and(Parent.Controls[I]<>Self) then begin
        if Parent.Controls[I].Visible then PrevForm:=
          TChildForm(Parent.Controls[I]);
        Parent.Controls[I].Hide;
      end;
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
begin
	for i := 0 to Self.ComponentCount - 1 do
		if Self.Components[ i].ClassNameIs( 'TToughDBGrid') then
				TToughDBGrid( Self.Components[ i]).OnMouseMove :=
					MainForm.Label1MouseMove;
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
  fOrder.AsInteger := fOrder.AsInteger - (fOrder.AsInteger mod fVolume.AsInteger);
  dsCheckVolume.Post;
end;

procedure TChildForm.ShowVolumeMessage;
begin
  tCheckVolume.Enabled := False;
  if (dsCheckVolume.RecordCount > 0) and not CheckVolume then begin
    AProc.MessageBox(
      Format('Заказ "%s" не кратен минимальному отпуску "%s"!', [fOrder.AsString, fVolume.AsString]),
      MB_ICONWARNING);
    ClearOrder;
    Abort;
  end;
end;

procedure TChildForm.tCheckVolumeTimer(Sender: TObject);
begin
  ShowVolumeMessage;
end;

procedure TChildForm.FormCreate(Sender: TObject);
begin
  if Assigned(dsCheckVolume) and Assigned(dgCheckVolume) and Assigned(fOrder)
     and Assigned(fVolume)
  then begin
    OldAfterPost := dsCheckVolume.AfterPost;
    dsCheckVolume.AfterPost := NewAfterPost;
    OldBeforeScroll := dsCheckVolume.BeforeScroll;
    dsCheckVolume.BeforeScroll := NewBeforeScroll;
    OldBeforePost := dsCheckVolume.BeforePost;
    dsCheckVolume.BeforePost := NewBeforePost;
    OldExit := dgCheckVolume.OnExit;
    dgCheckVolume.OnExit := NewExit;
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
end;

end.
