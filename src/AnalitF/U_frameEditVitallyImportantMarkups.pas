unit U_frameEditVitallyImportantMarkups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, DatabaseObjects,
  Contnrs,
  VitallyImportantMarkupsParams;

type
  TframeEditVitallyImportantMarkups = class(TFrame)
  private
    { Private declarations }
    FMarkups : TObjectList;
    MarkupsChanges : Boolean;
    FTableId : TDatabaseObjectId;
    FLoadMarkups : TThreadMethod;
    VitallyEdit : Boolean;

    FParams : TVitallyImportantMarkupsParams;

    procedure CreateVisibleComponents;
    procedure AddEditButtonsPanel;
    procedure AddGridPanel;
    procedure AddCheckBoxPanel;

    procedure MarkupsGetCellParams(
      Sender: TObject;
      Column: TColumnEh;
      AFont: TFont;
      var Background: TColor;
      State: TGridDrawState);
    procedure AddMarkupClick(Sender: TObject);
    procedure DeleteMarkupClick(Sender: TObject);

    procedure CreateNonVisibleComponents;
    procedure MarkupsAfterPost(DataSet: TDataSet);
    procedure MarkupsBeforePost(DataSet: TDataSet);
    procedure MarkupsAfterDelete(DataSet: TDataSet);

    procedure LoadMarkups;

    procedure LoadVitallyImportantMarkups;
  public
    { Public declarations }
    pClient : TPanel;
    pEditButtons : TPanel;
    btnAdd : TButton;
    btnDelete : TButton;
    pGrid : TPanel;
    dbgMarkups : TToughDBGrid;
    lLeftLessRightColor : TLabel;
    lLeftLessRightInfo : TLabel;
    lIntervalsIntersectColor : TLabel;
    lIntervalsIntersectInfo : TLabel;
    lBreakingExistsColor : TLabel;
    lBreakingExistsInfo : TLabel;

    mdMarkups : TRxMemoryData;
    fId : TIntegerField;
    fLeftLimit : TCurrencyField;
    fRightLimit : TCurrencyField;
    fMarkup : TCurrencyField;
    fMaxMarkup : TCurrencyField;
    fMaxSupplierMarkup : TCurrencyField;

    dsMarkups : TDataSource;

    pCheckBox : TPanel;
    cbUseProducerCostWithNDS : TCheckBox;
    cbApply : TCheckBox;

    constructor CreateFrame(
      AOwner: TComponent;
      TableId : TDatabaseObjectId;
      LoadMarkups : TThreadMethod;
      AComponentName : String = ''); overload;
    destructor Destroy(); override;
    procedure SaveVitallyImportantMarkups;
    function ProcessCloseQuery(var CanClose: Boolean) : Boolean;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TframeEditVitallyImportantMarkups.AddEditButtonsPanel;
begin
  pEditButtons := TPanel.Create(Self);
  pEditButtons.Parent := pClient;
  pEditButtons.Align := alRight;
  pEditButtons.Caption := '';
  pEditButtons.BevelOuter := bvNone;

  btnAdd := TButton.Create(Self);
  btnAdd.Parent := pEditButtons;
  btnAdd.Caption := '��������';
  btnAdd.Top := 5;
  btnAdd.Left := 10;
  btnAdd.OnClick := AddMarkupClick;

  btnDelete := TButton.Create(Self);
  btnDelete.Parent := pEditButtons;
  btnDelete.Caption := '�������';
  btnDelete.Left := 10;
  btnDelete.Top := 5 + btnAdd.Height + 10;
  btnDelete.OnClick := DeleteMarkupClick;

  lLeftLessRightColor := TLabel.Create(Self);
  lLeftLessRightColor.Parent := pEditButtons;
  lLeftLessRightColor.AutoSize := False;
  lLeftLessRightColor.ParentColor := False;
  lLeftLessRightColor.Transparent := False;
  lLeftLessRightColor.Color := clRed;
  lLeftLessRightColor.Height := 13;
  lLeftLessRightColor.Width := 30;
  lLeftLessRightColor.Left := 10;
  lLeftLessRightColor.Top := btnDelete.Top + btnDelete.Height + 15;

  lLeftLessRightInfo := TLabel.Create(Self);
  lLeftLessRightInfo.Parent := pEditButtons;
  lLeftLessRightInfo.Left := 10;
  lLeftLessRightInfo.Top := lLeftLessRightColor.Top + lLeftLessRightColor.Height + 5;
  lLeftLessRightInfo.Caption := '����� �������'#13#10'������ ������.';

  lIntervalsIntersectColor := TLabel.Create(Self);
  lIntervalsIntersectColor.Parent := pEditButtons;
  lIntervalsIntersectColor.AutoSize := False;
  lIntervalsIntersectColor.ParentColor := False;
  lIntervalsIntersectColor.Transparent := False;
  lIntervalsIntersectColor.Color := clOlive;
  lIntervalsIntersectColor.Height := 13;
  lIntervalsIntersectColor.Width := 30;
  lIntervalsIntersectColor.Left := 10;
  lIntervalsIntersectColor.Top := lLeftLessRightInfo.Top + lLeftLessRightInfo.Height + 10;

  lIntervalsIntersectInfo := TLabel.Create(Self);
  lIntervalsIntersectInfo.Parent := pEditButtons;
  lIntervalsIntersectInfo.Left := 10;
  lIntervalsIntersectInfo.Top := lIntervalsIntersectColor.Top + lIntervalsIntersectColor.Height + 5;
  lIntervalsIntersectInfo.Caption := '���������'#13#10'������������'#13#10'� ���� ������.';

  lBreakingExistsColor := TLabel.Create(Self);
  lBreakingExistsColor.Parent := pEditButtons;
  lBreakingExistsColor.AutoSize := False;
  lBreakingExistsColor.ParentColor := False;
  lBreakingExistsColor.Transparent := False;
  lBreakingExistsColor.Color := clMaroon;
  lBreakingExistsColor.Height := 13;
  lBreakingExistsColor.Width := 30;
  lBreakingExistsColor.Left := 10;
  lBreakingExistsColor.Top := lIntervalsIntersectInfo.Top + lIntervalsIntersectInfo.Height + 10;

  lBreakingExistsInfo := TLabel.Create(Self);
  lBreakingExistsInfo.Parent := pEditButtons;
  lBreakingExistsInfo.Left := 10;
  lBreakingExistsInfo.Top := lBreakingExistsColor.Top + lBreakingExistsColor.Height + 5;
  lBreakingExistsInfo.Caption := '������� ������'#13#10'�����'#13#10'�����������.';


  btnAdd.Width := lBreakingExistsInfo.Canvas.TextWidth(btnAdd.Caption) + 30;
  btnDelete.Width := lBreakingExistsInfo.Canvas.TextWidth(btnDelete.Caption) + 30;
  if btnAdd.Width > btnDelete.Width then
    btnDelete.Width := btnAdd.Width
  else
   btnAdd.Width := btnDelete.Width;
  pEditButtons.Width := btnAdd.Width + 20;
  pClient.Height := lBreakingExistsInfo.Top + lBreakingExistsInfo.Height + 10;
  pEditButtons.Height := pClient.Height;
end;

procedure TframeEditVitallyImportantMarkups.AddGridPanel;
begin
  pGrid := TPanel.Create(Self);
  pGrid.Parent := pClient;
  pGrid.Align := alClient;
  pGrid.Caption := '';
  pGrid.BevelOuter := bvNone;


  dbgMarkups := TToughDBGrid.Create(Self);
  dbgMarkups.Parent := pGrid;
  dbgMarkups.Align := alClient;

  TDBGridHelper.SetDefaultSettingsToGrid(dbgMarkups);
  dbgMarkups.Options := dbgMarkups.Options + [dgEditing];

  dbgMarkups.AutoFitColWidths := False;

  dbgMarkups.OnGetCellParams := MarkupsGetCellParams;

  TDBGridHelper.AddColumn(dbgMarkups, 'LeftLimit', '����� �������', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'RightLimit', '������ �������', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'Markup', '�������(%)', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'MaxMarkup', '����.�������(%)', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'MaxSupplierMarkup', '����.���.���.�����(%)', '0.00;;', False);

  dbgMarkups.DataSource := dsMarkups;
end;

procedure TframeEditVitallyImportantMarkups.AddMarkupClick(Sender: TObject);
begin
  mdMarkups.Append;
  dbgMarkups.SetFocus();
end;

constructor TframeEditVitallyImportantMarkups.CreateFrame(
  AOwner: TComponent;
  TableId : TDatabaseObjectId;
  LoadMarkups : TThreadMethod;
  AComponentName : String = '');
begin
  inherited Create(AOwner);

  FTableId := TableId;
  VitallyEdit := TableId = doiVitallyImportantMarkups;
  FLoadMarkups := LoadMarkups;
  FMarkups := TObjectList.Create(True);
  if AComponentName <> '' then
    Self.Name := AComponentName
  else
    Self.Name := 'frameEditMargins' + DatabaseController.GetById(TableId).Name;
  FParams := TVitallyImportantMarkupsParams.Create(DM.MainConnection);

  MarkupsChanges := False;

  CreateNonVisibleComponents;
  CreateVisibleComponents;
  LoadVitallyImportantMarkups;

  pClient.ControlStyle := pClient.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeEditVitallyImportantMarkups.CreateNonVisibleComponents;
begin
  mdMarkups := TRxMemoryData.Create(Self);

  fId := TIntegerField.Create(mdMarkups);
  fId.fieldname := 'Id';
  fId.Dataset := mdMarkups;

  fLeftLimit := TCurrencyField.Create(mdMarkups);
  fLeftLimit.fieldname := 'LeftLimit';
  fLeftLimit.Dataset := mdMarkups;

  fRightLimit := TCurrencyField.Create(mdMarkups);
  fRightLimit.fieldname := 'RightLimit';
  fRightLimit.Dataset := mdMarkups;

  fMarkup := TCurrencyField.Create(mdMarkups);
  fMarkup.fieldname := 'Markup';
  fMarkup.Dataset := mdMarkups;

  fMaxMarkup := TCurrencyField.Create(mdMarkups);
  fMaxMarkup.fieldname := 'MaxMarkup';
  fMaxMarkup.Dataset := mdMarkups;

  fMaxSupplierMarkup := TCurrencyField.Create(mdMarkups);
  fMaxSupplierMarkup.fieldname := 'MaxSupplierMarkup';
  fMaxSupplierMarkup.Dataset := mdMarkups;

  dsMarkups := TDataSource.Create(Self);
  dsMarkups.DataSet := mdMarkups;
end;

procedure TframeEditVitallyImportantMarkups.CreateVisibleComponents;
var
  maxWidth : Integer;
begin
  pClient := TPanel.Create(Self);
  pClient.Parent := Self;
  pClient.Caption := '';
  pClient.BevelOuter := bvNone;

  AddEditButtonsPanel;

  if VitallyEdit then
    AddCheckBoxPanel;

  AddGridPanel;

  maxWidth := pEditButtons.Width + TDBGridHelper.GetColumnWidths(dbgMarkups) + 20;
  if VitallyEdit and (maxWidth < cbUseProducerCostWithNDS.Width + 40) then
    maxWidth := cbUseProducerCostWithNDS.Width + 40;
  Self.Width := maxWidth;
  Self.Height := pClient.Height;
  Self.Constraints.MinHeight := Self.Height;
  Self.Constraints.MinWidth := Self.Width;
  pClient.Align := alClient;

  dbgMarkups.AutoFitColWidths := True;
end;

procedure TframeEditVitallyImportantMarkups.DeleteMarkupClick(Sender: TObject);
begin
  if not mdMarkups.IsEmpty then begin
    mdMarkups.Delete;
    dbgMarkups.SetFocus;
  end;
end;

function TframeEditVitallyImportantMarkups.ProcessCloseQuery(var CanClose: Boolean) : Boolean;
const
  viLimis : array[0..2] of Integer = (0, 50, 500);
var
  Res : Boolean;
  PrevRight : Currency;
  viSet : set of byte;
  i : Byte;
  viExists : Boolean;
begin
  Result := True;
  if CanClose then begin
    try
      SoftPost(mdMarkups);
    except
    end;
    if MarkupsChanges then begin
      mdMarkups.SortOnFields(fLeftLimit.FieldName);
      if mdMarkups.RecordCount > 0 then begin
        mdMarkups.First;
        Res := (not fLeftLimit.IsNull) and (not fRightLimit.IsNull)
             and (not fMarkup.IsNull) and (not fMaxMarkup.IsNull)
             and (fLeftLimit.AsCurrency <= fRightLimit.AsCurrency)
             and (fMarkup.AsCurrency <= fMaxMarkup.AsCurrency);
        PrevRight := fRightLimit.AsCurrency;
        mdMarkups.Next;
        while not mdMarkups.Eof and Res do begin
          Res := PrevRight <= fLeftLimit.AsCurrency;
          if Res then
            Res := (not fLeftLimit.IsNull) and (not fRightLimit.IsNull)
              and (not fMarkup.IsNull) and (not fMaxMarkup.IsNull)
              and (fLeftLimit.AsCurrency <= fRightLimit.AsCurrency)
              and (fMarkup.AsCurrency <= fMaxMarkup.AsCurrency);
          mdMarkups.Next;
        end;
        if not Res then begin
          Result := False;
          CanClose := False;
          if (not fMarkup.IsNull) and (not fMaxMarkup.IsNull) and (fMarkup.AsCurrency > fMaxMarkup.AsCurrency)
          then
            AProc.MessageBox('������������ ������� ������ �������.', MB_ICONWARNING)
          else
            AProc.MessageBox('����������� ������� ������� ���.', MB_ICONWARNING);
        end;
      end;

      if VitallyEdit and CanClose then begin
        if mdMarkups.RecordCount < 3 then begin
          CanClose := False;
          AProc.MessageBox('�� ������ ������������ ��������� ������ ���: [0, 50], [50, 500], [500, 1000000].', MB_ICONWARNING);
        end
        else begin

          viSet := [];
          
          mdMarkups.First;
          while not mdMarkups.Eof do begin
            for I := 0 to 2 do begin
              viExists := (abs(fLeftLimit.Value - viLimis[i]) < 0.0001);
              if viExists and not (i in viSet) then
                viSet := viSet + [i]; 
            end;
            mdMarkups.Next;
          end;

          CanClose := viSet = [0, 1, 2];

          if not CanClose then
            AProc.MessageBox('�� ������ ������������ ��������� ������ ���: [0, 50], [50, 500], [500, 1000000].', MB_ICONWARNING);
        end;
      end;
    end;
  end;
end;

procedure TframeEditVitallyImportantMarkups.LoadMarkups;
var
  C : Integer;
begin
  FMarkups.Clear;
  C := mdMarkups.RecNo;
  try
    mdMarkups.First;
    while not mdMarkups.Eof do begin
      FMarkups.Add(TRetailMarkup
        .Create(
          fLeftLimit.AsCurrency,
          fRightLimit.AsCurrency,
          fMarkup.Value,
          fMaxMarkup.Value,
          fMaxSupplierMarkup.Value));
      mdMarkups.Next;
    end;
  finally
    mdMarkups.RecNo := C;
  end;
end;

procedure TframeEditVitallyImportantMarkups.LoadVitallyImportantMarkups;
begin
  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text :=
    'select LeftLimit, RightLimit, Markup, MaxMarkup, MaxSupplierMarkup from ' +
    DatabaseController.GetById(FTableId).Name  +
    ' order by LeftLimit';
  DM.adsQueryValue.Open;
  try
    mdMarkups.LoadFromDataSet(DM.adsQueryValue, 0, lmAppend);
  finally
    DM.adsQueryValue.Close;
  end;

  mdMarkups.AfterPost := MarkupsAfterPost;
  mdMarkups.BeforePost := MarkupsBeforePost;
  mdMarkups.AfterDelete := MarkupsAfterDelete;
  LoadMarkups;
end;

procedure TframeEditVitallyImportantMarkups.MarkupsAfterPost(DataSet: TDataSet);
begin
  mdMarkups.SortOnFields(fLeftLimit.FieldName);
  LoadMarkups;
  MarkupsChanges := True;
end;

procedure TframeEditVitallyImportantMarkups.MarkupsBeforePost(DataSet: TDataSet);
begin
  if (fLeftLimit.IsNull) or (fRightLimit.IsNull) or (fMarkup.IsNull) or (fMaxMarkup.IsNull) then
    Abort;
end;

procedure TframeEditVitallyImportantMarkups.MarkupsGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if (fLeftLimit.AsCurrency > fRightLimit.AsCurrency) and
    ((Column.Field = fLeftLimit) or (Column.Field = fRightLimit))
  then
    Background := lLeftLessRightColor.Color;

  if (mdMarkups.RecNo > 1) and (FMarkups.Count >= mdMarkups.RecNo-1)
  then begin
    if (TRetailMarkup(FMarkups[mdMarkups.RecNo-2]).RightLimit > fLeftLimit.Value)
      and (Column.Field = fLeftLimit)
    then
      Background := lIntervalsIntersectColor.Color
    else
      if (TRetailMarkup(FMarkups[mdMarkups.RecNo-2]).RightLimit <> fLeftLimit.Value)
        and (Column.Field = fLeftLimit)
      then
        Background := lBreakingExistsColor.Color
  end;
end;

procedure TframeEditVitallyImportantMarkups.SaveVitallyImportantMarkups;
begin
  if VitallyEdit then begin
    if FParams.UseProducerCostWithNDS <> cbUseProducerCostWithNDS.Checked then begin
      FParams.UseProducerCostWithNDS := cbUseProducerCostWithNDS.Checked;
      FParams.SaveParams;
    end;
  end;
  if MarkupsChanges then begin
    DM.MainConnection.ExecSQL(
      'truncate ' + DatabaseController.GetById(FTableId).Name, []);
    DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text :=
       'insert into ' +
       DatabaseController.GetById(FTableId).Name +
      ' (LeftLimit, RightLimit, Markup, MaxMarkup, MaxSupplierMarkup) values ' +
      '(:LeftLimit, :RightLimit, :Markup, :MaxMarkup, :MaxSupplierMarkup);';

    mdMarkups.First;
    while not mdMarkups.Eof do begin
      DM.adsQueryValue.ParamByName('LeftLimit').Value := fLeftLimit.Value;
      DM.adsQueryValue.ParamByName('RightLimit').Value := fRightLimit.Value;
      DM.adsQueryValue.ParamByName('Markup').Value := fMarkup.Value;
      DM.adsQueryValue.ParamByName('MaxMarkup').Value := fMaxMarkup.Value;
      DM.adsQueryValue.ParamByName('MaxSupplierMarkup').Value := fMaxSupplierMarkup.Value;
      DM.adsQueryValue.Execute;
      mdMarkups.Next;
    end;
    if Assigned(FLoadMarkups) then
      FLoadMarkups();
    DatabaseController.BackupDataTable(FTableId);
  end;
end;

procedure TframeEditVitallyImportantMarkups.MarkupsAfterDelete(
  DataSet: TDataSet);
begin
  mdMarkups.SortOnFields(fLeftLimit.FieldName);
  LoadMarkups;
  MarkupsChanges := True;
end;

destructor TframeEditVitallyImportantMarkups.Destroy;
begin
  FMarkups.Free;
  FParams.Free;
  inherited;
end;

procedure TframeEditVitallyImportantMarkups.AddCheckBoxPanel;
begin
  //  pClient.Height := lBreakingExistsInfo.Top + lBreakingExistsInfo.Height + 10;
  //  pEditButtons.Height := pClient.Height;

  pClient.Height := pClient.Height + 70;

  pCheckBox := TPanel.Create(Self);
  pCheckBox.Parent := pClient;
  pCheckBox.Height := 70;
  pCheckBox.Align := alBottom;
  pCheckBox.Caption := '';
  pCheckBox.BevelOuter := bvNone;

  cbUseProducerCostWithNDS := TCheckBox.Create(Self);
  cbUseProducerCostWithNDS.Parent := pCheckBox;
  cbUseProducerCostWithNDS.Left := 5;
  cbUseProducerCostWithNDS.Top := 15;
  cbUseProducerCostWithNDS.Caption := '������������ ���� ������ � ��� ��� ����������� �������� ���������';
  cbUseProducerCostWithNDS.Checked := FParams.UseProducerCostWithNDS;
  cbUseProducerCostWithNDS.Width := lLeftLessRightColor.Canvas.TextWidth(cbUseProducerCostWithNDS.Caption) + 30;

  cbApply := TCheckBox.Create(Self);
  cbApply.Parent := pCheckBox;
  cbApply.Left := 5;
  cbApply.Top := cbUseProducerCostWithNDS.Top + cbUseProducerCostWithNDS.Height + 5;
  cbApply.Caption := '��������� �� ���� �������(������) ��������';
  cbApply.Width := lLeftLessRightColor.Canvas.TextWidth(cbApply.Caption) + 30;
end;

end.
