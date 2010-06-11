unit U_framePosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, DB, ActnList, Buttons, RXCtrls,
  MyAccess;

type
  TframePosition = class(TFrame)
    gbPosition: TGroupBox;
    lSynonymName: TLabel;
    lMNN: TLabel;
    dbtSynonymName: TDBText;
    btnShowDescription: TRxSpeedButton;
    lVitallyImportant: TLabel;
    lMandatoryList: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure btnShowDescriptionClick(Sender: TObject);
  private
    { Private declarations }
    showDescriptionAction : TAction;
    oldAfterOpen : TDataSetNotifyEvent;
    oldAfterScroll : TDataSetNotifyEvent;
    descriptionId : TField;
    catalogVitallyImportant : TField;
    catalogMandatoryList : TField;

    adsMNN : TMyQuery;
    mnnIdField : TLargeintField;
    mnnField : TStringField;
    russianMnnField : TStringField;
    dsMnn : TDataSource;

    lMnnInfo : TLabel;

    procedure ProcessResize;
    procedure SetFrameSize;
    procedure NewAfterOpen(DataSet : TDataSet);
    procedure NewAfterScroll(DataSet : TDataSet);
    procedure RefreshPositionDetail(DataSet : TDataSet);
    procedure CreateMNNDataSet(Source: TDataSource; MnnIdFieldName : String);
    procedure MnnUpdateLabel(DataSet: TDataSet);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      Source: TDataSource;
      SynonymNameField,
      MnnField : String;
      DescriptionAction : TAction) : TframePosition;
  end;

implementation

{$R *.dfm}

constructor TframePosition.Create(AOwner: TComponent);
begin
  inherited;
  lMnnInfo := TLabel.Create(Self);
  lMnnInfo.Name := 'lMnnInfo';
  lMnnInfo.Parent := gbPosition;
  lMnnInfo.AutoSize := False;

  showDescriptionAction := nil;
  oldAfterOpen := nil;
  oldAfterScroll := nil;
  descriptionId := nil;
  catalogVitallyImportant := nil;
  catalogMandatoryList := nil;
  gbPosition.ControlStyle := gbPosition.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframePosition.FrameResize(Sender: TObject);
begin
  ProcessResize;
end;

procedure TframePosition.ProcessResize;
const
  leftInc = 10;
var
  heightOnHalf,
  labelWidth : Integer;
  buttonWidth : Integer;
begin
  labelWidth := lSynonymName.Canvas.TextWidth(lSynonymName.Caption);
  heightOnHalf := gbPosition.ClientHeight div 2;

  btnShowDescription.Left := leftInc;
  buttonWidth := btnShowDescription.Width;

  lSynonymName.Left := 2*leftInc + buttonWidth;
  lMNN.Left := lSynonymName.Left;
  lSynonymName.Top := heightOnHalf div 3;
  lMNN.Top := heightOnHalf + (heightOnHalf div 4);

  btnShowDescription.Top := heightOnHalf;

  dbtSynonymName.Top := lSynonymName.Top;
  lMnnInfo.Top := lMNN.Top;
  dbtSynonymName.Left := labelWidth + 2*leftInc + (leftInc div 2) + buttonWidth;
  lMnnInfo.Left := dbtSynonymName.Left;
  dbtSynonymName.Width := gbPosition.Width - (labelWidth + + buttonWidth + 3*leftInc);
  lMnnInfo.Width := dbtSynonymName.Width;

  lVitallyImportant.Top := lSynonymName.Top;
  lMandatoryList.Top := lVitallyImportant.Top;
  lVitallyImportant.Left := btnShowDescription.Left;
  lMandatoryList.Left := lVitallyImportant.Left + lVitallyImportant.Width + (leftInc div 2);
end;

class function TframePosition.AddFrame(Owner: TComponent;
  Parent: TWinControl;
  Source: TDataSource;
  SynonymNameField,
  MnnField : String;
  DescriptionAction : TAction) : TframePosition;
begin
  Result := TframePosition.Create(Owner);
  Result.showDescriptionAction := DescriptionAction;
  Result.btnShowDescription.Enabled := False;
  Result.lVitallyImportant.Visible := False;
  Result.lMandatoryList.Visible := False;
  if Assigned(Source.DataSet) then begin
    Result.CreateMNNDataSet(Source, MnnField);
    Result.oldAfterOpen := Source.DataSet.AfterOpen;
    Source.DataSet.AfterOpen := Result.NewAfterOpen;
    Result.oldAfterScroll := Source.DataSet.AfterScroll;
    Source.DataSet.AfterScroll := Result.NewAfterScroll;
  end;
  Result.Name := '';
  Result.Parent := Parent;
  Result.Align := alBottom;
  Result.dbtSynonymName.DataSource := Source;
  Result.dbtSynonymName.DataField := SynonymNameField;
  Result.dbtSynonymName.Font.Style := Result.dbtSynonymName.Font.Style + [fsBold];
  Result.lMnnInfo.Font.Style := Result.lMnnInfo.Font.Style + [fsBold];
  Result.SetFrameSize;
  Result.BringToFront();
end;

procedure TframePosition.SetFrameSize;
var
  labelHeight : Integer;
begin
  lSynonymName.Alignment := taRightJustify;
  lMNN.Alignment := taRightJustify;
  lSynonymName.Caption := '������������: ';
  lMNN.Caption := '���: ';
  lSynonymName.AutoSize := False;
  lMNN.AutoSize := False;
  lSynonymName.Width := lSynonymName.Canvas.TextWidth(lSynonymName.Caption);
  lMNN.Width := lSynonymName.Width;
  btnShowDescription.Caption := '�������� (F1, ������)';
  btnShowDescription.Width := lSynonymName.Canvas.TextWidth(btnShowDescription.Caption) + 20;
  btnShowDescription.Height := lSynonymName.Canvas.TextHeight(btnShowDescription.Caption) + 8;
  labelHeight := lSynonymName.Canvas.TextHeight(lSynonymName.Caption)*4;
  Self.Height := labelHeight;
  lVitallyImportant.AutoSize := False;
  lVitallyImportant.Caption := '�����';
  lVitallyImportant.Width := lVitallyImportant.Canvas.TextWidth(lVitallyImportant.Caption);

  lMandatoryList.AutoSize := False;
  lMandatoryList.Caption := '����. ������';
  lMandatoryList.Width := lMandatoryList.Canvas.TextWidth(lMandatoryList.Caption);
end;

procedure TframePosition.btnShowDescriptionClick(Sender: TObject);
begin
  if Assigned(showDescriptionAction) then
    showDescriptionAction.Execute;
end;

procedure TframePosition.NewAfterOpen(DataSet: TDataSet);
begin
  descriptionId := DataSet.FindField('DescriptionId');
  catalogVitallyImportant := DataSet.FindField('CatalogVitallyImportant');
  catalogMandatoryList := DataSet.FindField('CatalogMandatoryList');

  RefreshPositionDetail(DataSet);

  if Assigned(oldAfterOpen) then
    oldAfterOpen(DataSet)
end;

procedure TframePosition.NewAfterScroll(DataSet: TDataSet);
begin
  RefreshPositionDetail(DataSet);

  if Assigned(oldAfterScroll) then
    oldAfterScroll(DataSet)
end;

procedure TframePosition.RefreshPositionDetail(DataSet: TDataSet);
begin
  btnShowDescription.Enabled :=
    not DataSet.IsEmpty
    and Assigned(descriptionId)
    and not descriptionId.IsNull;
  lVitallyImportant.Visible :=
    not DataSet.IsEmpty
    and Assigned(catalogVitallyImportant)
    and not catalogVitallyImportant.IsNull
    and (((catalogVitallyImportant.DataType = ftBoolean) and catalogVitallyImportant.AsBoolean) or (catalogVitallyImportant.Value > 0));
  lMandatoryList.Visible :=
    not DataSet.IsEmpty
    and Assigned(catalogMandatoryList)
    and not catalogMandatoryList.IsNull
    and (((catalogMandatoryList.DataType = ftBoolean) and catalogMandatoryList.AsBoolean) or (catalogMandatoryList.Value > 0));
end;

procedure TframePosition.CreateMNNDataSet(Source: TDataSource; MnnIdFieldName : String);
begin
  adsMNN := TMyQuery.Create(Self);
  if Assigned(Source.DataSet) and (Source.DataSet is TCustomMyDataSet) then
    adsMNN.Connection := TCustomMyDataSet(Source.DataSet).Connection;

  adsMNN.SQL.Text := 'select Mnn.Id, Mnn.Mnn, Mnn.RussianMnn from mnn';

  adsMNN.MasterSource := Source;
  adsMNN.MasterFields := MnnIdFieldName;
  adsMNN.DetailFields := 'Id';
  adsMNN.AfterRefresh := MnnUpdateLabel;
  adsMNN.AfterOpen := MnnUpdateLabel;

  mnnIdField := TLargeintField.Create(adsMNN);
  mnnIdField.fieldname := 'Id';
  mnnIdField.Dataset := adsMNN;

  mnnField := TStringField.Create(adsMNN);
  mnnField.fieldname := 'Mnn';
  mnnField.Size := 250;
  mnnField.Dataset := adsMNN;

  russianMnnField := TStringField.Create(adsMNN);
  russianMnnField.fieldname := 'RussianMnn';
  russianMnnField.Size := 250;
  russianMnnField.Dataset := adsMNN;

  dsMnn := TDataSource.Create(Self);
  dsMnn.DataSet := adsMNN;

  if not adsMNN.Active then
    adsMNN.Open;
end;

procedure TframePosition.MnnUpdateLabel(DataSet: TDataSet);
begin
  if not mnnField.IsNull and not russianMnnField.IsNull then
    lMnnInfo.Caption := mnnField.Value + '  (' + russianMnnField.Value + ')'
  else
    if not mnnField.IsNull then
      lMnnInfo.Caption := mnnField.Value
    else
      lMnnInfo.Caption := russianMnnField.Value;
end;

end.
