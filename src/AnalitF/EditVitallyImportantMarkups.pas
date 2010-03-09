unit EditVitallyImportantMarkups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons;

type
  TEditVitallyImportantMarkupsForm = class(TVistaCorrectForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    btnSave : TButton;
    btnCancel : TButton;
    pButton : TPanel;
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

    dsMarkups : TDataSource;

    FMarkups : array of TRetMass;
    MarkupsChanges : Boolean;

    procedure CreateVisibleComponents;
    procedure AddBottomPanel;
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
    procedure FormCloseQuery(
      Sender: TObject;
      var CanClose: Boolean);

    procedure CreateNonVisibleComponents;
    procedure MarkupsAfterPost(DataSet: TDataSet);
    procedure MarkupsBeforePost(DataSet: TDataSet);

    procedure LoadMarkups;

    procedure LoadVitallyImportantMarkups;
  public
    { Public declarations }
    procedure SaveVitallyImportantMarkups;
  end;


  procedure ShowEditVitallyImportantMarkups;

implementation

{$R *.dfm}

procedure ShowEditVitallyImportantMarkups;
var
  EditVitallyImportantMarkupsForm: TEditVitallyImportantMarkupsForm;
  modalResultForm : TModalResult;
begin
  EditVitallyImportantMarkupsForm := TEditVitallyImportantMarkupsForm.Create(Application);
  try
    modalResultForm := EditVitallyImportantMarkupsForm.ShowModal;
    if modalResultForm = mrOk then begin
      EditVitallyImportantMarkupsForm.SaveVitallyImportantMarkups;
      DM.LoadVitallyImportantMarkups;
    end;
  finally
    EditVitallyImportantMarkupsForm.Free;
  end;
end;

procedure TEditVitallyImportantMarkupsForm.AddBottomPanel;
begin
  pButton := TPanel.Create(Self);
  pButton.Parent := Self;
  pButton.Align := alBottom;
  pButton.Caption := '';
  pButton.BevelOuter := bvNone;

  btnSave := TButton.Create(Self);
  btnSave.Parent := pButton;
  btnSave.Caption := 'Сохранить';
  btnSave.Width := Self.Canvas.TextWidth(btnSave.Caption) + 20;
  pButton.Height := btnSave.Height + 20;
  btnSave.Left := 10;
  btnSave.Top := 10;
  btnSave.Default := True;
  btnSave.ModalResult := mrOk;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := pButton;
  btnCancel.Caption := 'Отменить';
  btnCancel.Width := Self.Canvas.TextWidth(btnCancel.Caption) + 20;
  btnCancel.Left := 10 + btnSave.Width + 10;
  btnCancel.Top := 10;
  btnCancel.Cancel := True;
  btnCancel.ModalResult := mrCancel;
end;

procedure TEditVitallyImportantMarkupsForm.AddEditButtonsPanel;
begin
  pEditButtons := TPanel.Create(Self);
  pEditButtons.Parent := pClient;
  pEditButtons.Align := alRight;
  pEditButtons.Caption := '';
  pEditButtons.BevelOuter := bvNone;

  btnAdd := TButton.Create(Self);
  btnAdd.Parent := pEditButtons;
  btnAdd.Caption := 'Добавить';
  btnAdd.Width := Self.Canvas.TextWidth(btnAdd.Caption) + 30;
  btnAdd.Top := 5;
  btnAdd.Left := 10;
  btnAdd.OnClick := AddMarkupClick;

  btnDelete := TButton.Create(Self);
  btnDelete.Parent := pEditButtons;
  btnDelete.Caption := 'Удалить';
  btnDelete.Width := Self.Canvas.TextWidth(btnDelete.Caption) + 30;
  btnDelete.Left := 10;
  btnDelete.Top := 5 + btnAdd.Height + 10;
  btnDelete.OnClick := DeleteMarkupClick;

  if btnAdd.Width > btnDelete.Width then
    btnDelete.Width := btnAdd.Width
  else
   btnAdd.Width := btnDelete.Width;
  pEditButtons.Width := btnAdd.Width + 20;

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
end;

procedure TEditVitallyImportantMarkupsForm.AddGridPanel;
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
  TDBGridHelper.AddColumn(dbgMarkups, 'Markup', 'Наценка (%)', False);

  dbgMarkups.DataSource := dsMarkups;
end;

procedure TEditVitallyImportantMarkupsForm.AddMarkupClick(Sender: TObject);
begin
  mdMarkups.Append;
  dbgMarkups.SetFocus();
end;

procedure TEditVitallyImportantMarkupsForm.CreateNonVisibleComponents;
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

  mdMarkups.AfterPost := MarkupsAfterPost;
  mdMarkups.BeforePost := MarkupsBeforePost;

  dsMarkups := TDataSource.Create(Self);
  dsMarkups.DataSet := mdMarkups;
end;

procedure TEditVitallyImportantMarkupsForm.CreateVisibleComponents;
begin
  AddBottomPanel;

  pClient := TPanel.Create(Self);
  pClient.Parent := Self;
  pClient.Align := alClient;
  pClient.Caption := '';
  pClient.BevelOuter := bvNone;

  AddEditButtonsPanel;

  AddGridPanel;

  Self.Width := pEditButtons.Width + TDBGridHelper.GetColumnWidths(dbgMarkups) + 20;

  dbgMarkups.AutoFitColWidths := True;
end;

procedure TEditVitallyImportantMarkupsForm.DeleteMarkupClick(
  Sender: TObject);
begin
  if not mdMarkups.IsEmpty then begin
    mdMarkups.Delete;
    dbgMarkups.SetFocus;
  end;
end;

procedure TEditVitallyImportantMarkupsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Res : Boolean;
  PrevRight : Currency;
begin
  if (ModalResult = mrOK) then begin
    if CanClose and MarkupsChanges then begin
      try
        SoftPost(mdMarkups);
      except
      end;
      mdMarkups.SortOnFields(fLeftLimit.FieldName);
      if mdMarkups.RecordCount > 0 then begin
        mdMarkups.First;
        Res := (not fLeftLimit.IsNull) and (not fRightLimit.IsNull) and (not fMarkup.IsNull) and
              (fLeftLimit.AsCurrency <= fRightLimit.AsCurrency);
        PrevRight := fRightLimit.AsCurrency;
        mdMarkups.Next;
        while not mdMarkups.Eof and Res do begin
          Res := PrevRight <= fLeftLimit.AsCurrency;
          if Res then
            Res := (not fLeftLimit.IsNull) and (not fRightLimit.IsNull) and (not fMarkup.IsNull) and
                  (fLeftLimit.AsCurrency <= fRightLimit.AsCurrency);
          mdMarkups.Next;
        end;
        if not Res then begin
          CanClose := False;
          dbgMarkups.SetFocus;
          AProc.MessageBox('Некорректно введены границы цен.', MB_ICONWARNING);
        end;
      end;
    end;
  end;
end;

procedure TEditVitallyImportantMarkupsForm.FormCreate(Sender: TObject);
begin
  inherited;
  MarkupsChanges := False;
  Self.Caption := 'Редактирование наценок для ЖНВЛС';
  Self.Position := poMainFormCenter;
  Self.OnCloseQuery := FormCloseQuery;
  CreateNonVisibleComponents;
  CreateVisibleComponents;
  LoadVitallyImportantMarkups;
end;

procedure TEditVitallyImportantMarkupsForm.LoadMarkups;
var
  I : Integer;
  C : Integer;
begin
  SetLength(FMarkups, mdMarkups.RecordCount);
  C := mdMarkups.RecNo;
  try
    mdMarkups.First;
    I := 0;
    while not mdMarkups.Eof do begin
      FMarkups[i][1] := fLeftLimit.AsCurrency;
      FMarkups[i][2] := fRightLimit.AsCurrency;
      FMarkups[i][3] := fMarkup.Value;
      Inc(I);
      mdMarkups.Next;
    end;
  finally
    mdMarkups.RecNo := C;
  end;
end;

procedure TEditVitallyImportantMarkupsForm.LoadVitallyImportantMarkups;
begin
  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text :=
    'select LeftLimit, RightLimit, Markup from VitallyImportantMarkups order by LeftLimit';
  DM.adsQueryValue.Open;
  try
    mdMarkups.LoadFromDataSet(DM.adsQueryValue, 0, lmAppend);
  finally
    DM.adsQueryValue.Close;
  end;

  LoadMarkups;
end;

procedure TEditVitallyImportantMarkupsForm.MarkupsAfterPost(
  DataSet: TDataSet);
begin
  mdMarkups.SortOnFields(fLeftLimit.FieldName);
  LoadMarkups;
  MarkupsChanges := True;
end;

procedure TEditVitallyImportantMarkupsForm.MarkupsBeforePost(
  DataSet: TDataSet);
begin
  if (fLeftLimit.IsNull) or (fRightLimit.IsNull) or (fMarkup.IsNull) then
    Abort;
end;

procedure TEditVitallyImportantMarkupsForm.MarkupsGetCellParams(
  Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if (fLeftLimit.AsCurrency > fRightLimit.AsCurrency) and
    ((Column.Field = fLeftLimit) or (Column.Field = fRightLimit))
  then
    Background := lLeftLessRightColor.Color;

  if (mdMarkups.RecNo > 1) and (Length(FMarkups) >= mdMarkups.RecNo-1)
  then begin
    if (FMarkups[mdMarkups.RecNo-2][2] > fLeftLimit.Value)
      and (Column.Field = fLeftLimit)
    then
      Background := lIntervalsIntersectColor.Color
    else
      if (FMarkups[mdMarkups.RecNo-2][2] <> fLeftLimit.Value)
        and (Column.Field = fLeftLimit)
      then
        Background := lBreakingExistsColor.Color
  end;
end;

procedure TEditVitallyImportantMarkupsForm.SaveVitallyImportantMarkups;
begin
  DM.MainConnection.ExecSQL('truncate VitallyImportantMarkups', []);
  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := 'insert into VitallyImportantMarkups ' +
    '(LeftLimit, RightLimit, Markup) values ' +
    '(:LeftLimit, :RightLimit, :Markup);';

  mdMarkups.First;
  while not mdMarkups.Eof do begin
    DM.adsQueryValue.ParamByName('LeftLimit').Value := fLeftLimit.Value;
    DM.adsQueryValue.ParamByName('RightLimit').Value := fRightLimit.Value;
    DM.adsQueryValue.ParamByName('Markup').Value := fMarkup.Value;
    DM.adsQueryValue.Execute;
    mdMarkups.Next;
  end;
end;

end.
