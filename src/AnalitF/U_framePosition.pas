unit U_framePosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, DB, ActnList, Buttons;

type
  TframePosition = class(TFrame)
    gbPosition: TGroupBox;
    lSynonymName: TLabel;
    lMNN: TLabel;
    dbtSynonymName: TDBText;
    dbtMNN: TDBText;
    btnShowDescription: TSpeedButton;
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
    procedure ProcessResize;
    procedure SetFrameSize;
    procedure NewAfterOpen(DataSet : TDataSet);
    procedure NewAfterScroll(DataSet : TDataSet);
    procedure RefreshPositionDetail(DataSet : TDataSet);
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
  btnShowDescription.Top := heightOnHalf div 3 + 1;
  buttonWidth := btnShowDescription.Width;

  lSynonymName.Left := 2*leftInc + buttonWidth;
  lMNN.Left := lSynonymName.Left;
  lSynonymName.Top := heightOnHalf div 3;
  lMNN.Top := heightOnHalf + (heightOnHalf div 4);

  dbtSynonymName.Top := lSynonymName.Top;
  dbtMNN.Top := lMNN.Top;
  dbtSynonymName.Left := labelWidth + 2*leftInc + (leftInc div 2) + buttonWidth;
  dbtMNN.Left := dbtSynonymName.Left;
  dbtSynonymName.Width := gbPosition.Width - (labelWidth + + buttonWidth + 3*leftInc);
  dbtMNN.Width := dbtSynonymName.Width;

  lVitallyImportant.Top := lMNN.Top;
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
  Result.dbtMNN.DataSource := Source;
  if MnnField <> '' then
    Result.dbtMNN.DataField := MnnField;
  Result.dbtSynonymName.Font.Style := Result.dbtSynonymName.Font.Style + [fsBold];
  Result.dbtMNN.Font.Style := Result.dbtMNN.Font.Style + [fsBold];
  Result.SetFrameSize;
  Result.BringToFront();
end;

procedure TframePosition.SetFrameSize;
var
  labelHeight : Integer;
begin
  lSynonymName.Alignment := taRightJustify;
  lMNN.Alignment := taRightJustify;
  lSynonymName.Caption := 'Наименование: ';
  lMNN.Caption := 'МНН: ';
  lSynonymName.AutoSize := False;
  lMNN.AutoSize := False;
  lSynonymName.Width := lSynonymName.Canvas.TextWidth(lSynonymName.Caption);
  lMNN.Width := lSynonymName.Width;
  btnShowDescription.Caption := 'Описание (F1, Пробел)';
  btnShowDescription.Width := lSynonymName.Canvas.TextWidth(btnShowDescription.Caption) + 20;
  btnShowDescription.Height := lSynonymName.Canvas.TextHeight(btnShowDescription.Caption) + 8;
  labelHeight := lSynonymName.Canvas.TextHeight(lSynonymName.Caption)*4;
  Self.Height := labelHeight;
  lVitallyImportant.AutoSize := False;
  lVitallyImportant.Caption := 'ЖНВЛС';
  lVitallyImportant.Width := lVitallyImportant.Canvas.TextWidth(lVitallyImportant.Caption);

  lMandatoryList.AutoSize := False;
  lMandatoryList.Caption := 'Обяз. список';
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

end.
