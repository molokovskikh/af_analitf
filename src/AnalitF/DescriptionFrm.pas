unit DescriptionFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, DB, RxRichEd, ExtCtrls;

type
  TDescriptionForm = class(TVistaCorrectForm)
    pButton: TPanel;
    btnOk: TButton;
    RxRichEdit: TRxRichEdit;
    PrintDialog: TPrintDialog;
    btnPrint: TButton;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    catalogName : String;
    slDesc : TStringList;
    procedure reDescriptionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    { Public declarations }
    procedure PrepareDesc(inputDesc : String; edit : TRxRichEdit);
  end;

procedure ShowDescription(dataSet : TDataSet);

implementation

{$R *.dfm}

procedure ShowDescription(dataSet : TDataSet);
const
  ColumnsByTitles : array[0..1, 0..10] of string =
  ((
    'Composition',
    'PharmacologicalAction',
    'IndicationsForUse',
    'Warnings',
    'Dosing',
    'SideEffect',
    'Interaction',
    'ProductForm',
    'Description',
    'Storage',
    'Expiration'
    ),
   (
    '—остав',
    '‘армакологическое действие',
    'ѕоказани€ к применению',
    'ѕредостережени€ и противопоказани€',
    '—пособ применени€ и дозы',
    'ѕобочные действи€',
    '¬заимодействие',
    '‘орма выпуска',
    'ƒополнительно',
    '”слови€ хранени€',
    '—рок годности'
    ));
var
  I : Integer;
  Name, EnglishName : String;
  descField : TField;
  RichEd : TRxRichEdit;
  FDescriptionForm: TDescriptionForm;

  headerSize,
  bodySize : Integer;
begin
  FDescriptionForm := TDescriptionForm.Create(nil);
  try
    Name := dataSet.FieldByName('Name').AsString;
    FDescriptionForm.catalogName := Name;
    EnglishName := dataSet.FieldByName('EnglishName').AsString;

    FDescriptionForm.ControlStyle := FDescriptionForm.ControlStyle - [csParentBackground] + [csOpaque];
    FDescriptionForm.pButton.ControlStyle := FDescriptionForm.pButton.ControlStyle - [csParentBackground] + [csOpaque];

    RichEd := FDescriptionForm.RxRichEdit;

    RichEd.OnKeyDown := FDescriptionForm.reDescriptionKeyDown;
    RichEd.ReadOnly := True;

    FDescriptionForm.Width := (Application.MainForm.Width div 3) * 2;
    FDescriptionForm.Height := (Application.MainForm.Height div 3) * 2;

    //выставили параметры заголовка
    RichEd.Paragraph.Alignment := paCenter;
    RichEd.SelAttributes.Style := RichEd.SelAttributes.Style + [fsBold];
    RichEd.SelAttributes.Size := RichEd.SelAttributes.Size + 8;

    //ƒобавили заголовок
    RichEd.Lines.Add(Name + ' (' + EnglishName + ')');
    RichEd.Lines.Add('');

    bodySize := RichEd.SelAttributes.Size;
    headerSize := bodySize + 3;

    for I := 0 to High(ColumnsByTitles[0]) do begin
      descField := dataSet.FindField(ColumnsByTitles[0, i]);
      if Assigned(descField) and (descField.AsString <> '') then begin

        //выставили параметры пункта описани€
        RichEd.Paragraph.Alignment := paLeftJustify;
        RichEd.Paragraph.FirstIndent := 5;
        RichEd.SelAttributes.Style := RichEd.SelAttributes.Style + [fsBold];
        RichEd.SelAttributes.Size := headerSize;

        //добавили название пукнта описани€
        RichEd.Lines.Add(ColumnsByTitles[1, i] + ':');
        RichEd.Lines.Add('');

        //выставили параметры тела описани€
        RichEd.Paragraph.Alignment := paLeftJustify;
        RichEd.SelAttributes.Size := bodySize;

        //добавл€ем тело описани€
        FDescriptionForm.PrepareDesc(descField.AsString, RichEd);

        RichEd.Lines.Add('');
      end;
    end;

    //удал€ем пустые строки с конца текста
    for I := RichEd.Lines.Count-1 downto 0 do
      if Trim(RichEd.Lines[i]) = '' then
        RichEd.Lines.Delete(i)
      else
        Break;

    //устанавливаем курсор в начала текста
    RichEd.SelStart := 0;
    RichEd.SelLength := 0;

    FDescriptionForm.ShowModal;
  finally
    FDescriptionForm.Free;
  end;
end;

procedure TDescriptionForm.reDescriptionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_SPACE) or (Key = VK_ESCAPE) then
    Close;
end;

procedure TDescriptionForm.FormResize(Sender: TObject);
const
  interval = 20;
var
  allWidth : Integer;
begin
  allWidth := btnOk.Width + interval + btnPrint.Width;
  btnOk.Left := (pButton.ClientWidth div 2) - (allWidth div 2);
  btnPrint.Left := btnOk.Left + btnOk.Width + interval;
end;

procedure TDescriptionForm.FormCreate(Sender: TObject);
begin
  inherited;
  slDesc := TStringList.Create;
end;

procedure TDescriptionForm.FormDestroy(Sender: TObject);
begin
  slDesc.Free;
  inherited;
end;

procedure TDescriptionForm.PrepareDesc(inputDesc: String; edit : TRxRichEdit);
var
  I : Integer;
begin
  inputDesc := Trim(inputDesc);
  if Length(inputDesc) > 0 then begin
    inputDesc := StringReplace(inputDesc, #151, '-', [rfReplaceAll]);
    inputDesc := StringReplace(inputDesc, #150, '-', [rfReplaceAll]);
    slDesc.Clear;
    slDesc.Text := inputDesc;
    for I := 0 to slDesc.Count-1 do
      edit.Lines.Add(slDesc[i]);
  end
  else
    edit.Lines.Add(inputDesc);
end;

procedure TDescriptionForm.btnPrintClick(Sender: TObject);
begin
  if PrintDialog.Execute() then
    RxRichEdit.Print('ѕечать описани€ ' + catalogName);
end;

end.
