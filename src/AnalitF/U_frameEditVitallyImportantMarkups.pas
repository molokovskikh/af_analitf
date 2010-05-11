unit U_frameEditVitallyImportantMarkups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, DatabaseObjects,
  Contnrs;

type
  TframeEditVitallyImportantMarkups = class(TFrame)
  private
    { Private declarations }
    FMarkups : TObjectList;
    MarkupsChanges : Boolean;
    FTableId : TDatabaseObjectId;
    FLoadMarkups : TThreadMethod;


    procedure CreateVisibleComponents;
    procedure AddEditButtonsPanel;
    procedure AddGridPanel;

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

    dsMarkups : TDataSource;

    constructor CreateFrame(
      AOwner: TComponent;
      TableId : TDatabaseObjectId;
      LoadMarkups : TThreadMethod); overload;
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
  btnAdd.Caption := 'Добавить';
  btnAdd.Top := 5;
  btnAdd.Left := 10;
  btnAdd.OnClick := AddMarkupClick;

  btnDelete := TButton.Create(Self);
  btnDelete.Parent := pEditButtons;
  btnDelete.Caption := 'Удалить';
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
  lLeftLessRightInfo.Caption := 'Левая граница'#13#10'меньше правой.';

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
  lIntervalsIntersectInfo.Caption := 'Интервалы'#13#10'пересекаются'#13#10'с друг другом.';

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
  lBreakingExistsInfo.Caption := 'Имеется разрыв'#13#10'между'#13#10'интервалами.';


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

  TDBGridHelper.AddColumn(dbgMarkups, 'LeftLimit', 'Левая граница', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'RightLimit', 'Правая граница', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'Markup', 'Наценка (%)', '0.00;;', False);
  TDBGridHelper.AddColumn(dbgMarkups, 'MaxMarkup', 'Макс. наценка (%)', '0.00;;', False);

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
  LoadMarkups : TThreadMethod);
begin
  FTableId := TableId;
  FLoadMarkups := LoadMarkups;
  FMarkups := TObjectList.Create(True);
  Self.Name := 'frameEdit' + DatabaseController.GetById(TableId).Name;
  inherited Create(AOwner);
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

  dsMarkups := TDataSource.Create(Self);
  dsMarkups.DataSet := mdMarkups;
end;

procedure TframeEditVitallyImportantMarkups.CreateVisibleComponents;
begin
  pClient := TPanel.Create(Self);
  pClient.Parent := Self;
  pClient.Caption := '';
  pClient.BevelOuter := bvNone;

  AddEditButtonsPanel;

  AddGridPanel;

  Self.Width := pEditButtons.Width + TDBGridHelper.GetColumnWidths(dbgMarkups) + 20;
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
var
  Res : Boolean;
  PrevRight : Currency;
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
            AProc.MessageBox('Максимальная наценка меньше наценки.', MB_ICONWARNING)
          else
            AProc.MessageBox('Некорректно введены границы цен.', MB_ICONWARNING);
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
          FMaxMarkup.Value));
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
    'select LeftLimit, RightLimit, Markup, MaxMarkup from ' +
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
  if MarkupsChanges then begin
    DM.MainConnection.ExecSQL(
      'truncate ' + DatabaseController.GetById(FTableId).Name, []);
    DM.adsQueryValue.Close;
    DM.adsQueryValue.SQL.Text :=
       'insert into ' +
       DatabaseController.GetById(FTableId).Name +
      ' (LeftLimit, RightLimit, Markup, MaxMarkup) values ' +
      '(:LeftLimit, :RightLimit, :Markup, :MaxMarkup);';

    mdMarkups.First;
    while not mdMarkups.Eof do begin
      DM.adsQueryValue.ParamByName('LeftLimit').Value := fLeftLimit.Value;
      DM.adsQueryValue.ParamByName('RightLimit').Value := fRightLimit.Value;
      DM.adsQueryValue.ParamByName('Markup').Value := fMarkup.Value;
      DM.adsQueryValue.ParamByName('MaxMarkup').Value := fMaxMarkup.Value;
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
  inherited;
end;

end.
