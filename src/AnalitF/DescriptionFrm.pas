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
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure reDescriptionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    { Public declarations }
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
    'Состав',
    'Фармакологическое действие',
    'Показания к применению',
    'Предостережения и противопоказания',
    'Способ применения и дозы',
    'Побочное действие и противопоказания',
    'Взаимодействие',
    'Форма выпуска',
    'Дополнительно',
    'Условия хранения',
    'Срок годности'
    ));
var
  I,
  J,
  lastCount,
  LastSelStart : Integer;
  Name, EnglishName : String;
  descField : TField;
  RichEd : TRxRichEdit;
  trimText : String;
  FDescriptionForm: TDescriptionForm;
begin
  FDescriptionForm := TDescriptionForm.Create(nil);
  try
    Name := dataSet.FieldByName('Name').AsString;
    EnglishName := dataSet.FieldByName('EnglishName').AsString;

    FDescriptionForm.ControlStyle := FDescriptionForm.ControlStyle - [csParentBackground] + [csOpaque];
    FDescriptionForm.pButton.ControlStyle := FDescriptionForm.pButton.ControlStyle - [csParentBackground] + [csOpaque];

    RichEd := FDescriptionForm.RxRichEdit;

    RichEd.OnKeyDown := FDescriptionForm.reDescriptionKeyDown;
    RichEd.ReadOnly := True;

    FDescriptionForm.Width := (Application.MainForm.Width div 3) * 2;
    FDescriptionForm.Height := (Application.MainForm.Height div 3) * 2;

    RichEd.Paragraph.Alignment := paCenter;
    RichEd.Lines.Add(Name + ' (' + EnglishName + ')');
    RichEd.Lines.Add('');

    RichEd.SelStart := 0;
    RichEd.SelLength := Length(RichEd.Lines[0]);
    RichEd.SelAttributes.Style := RichEd.SelAttributes.Style + [fsBold];
    RichEd.SelAttributes.Size := RichEd.SelAttributes.Size + 8;

    LastSelStart := Length(RichEd.Lines[0]) + 2;

    for I := 0 to High(ColumnsByTitles[0]) do begin
      descField := dataSet.FindField(ColumnsByTitles[0, i]);
      if Assigned(descField) and (descField.AsString <> '') then begin
        RichEd.Lines.Add(ColumnsByTitles[1, i] + ':');
        RichEd.Lines.Add('');

        RichEd.SelStart := LastSelStart;
        RichEd.SelLength := 0;
        RichEd.Paragraph.Alignment := paLeftJustify;
        RichEd.Paragraph.FirstIndent := 5;
        RichEd.SelLength := Length(ColumnsByTitles[1, i] + ':');
        RichEd.SelAttributes.Style := RichEd.SelAttributes.Style + [fsBold];
        RichEd.SelAttributes.Size := RichEd.SelAttributes.Size + 3;
        LastSelStart := LastSelStart + Length(ColumnsByTitles[1, i] + ':') + 2;

        lastCount := RichEd.Lines.Count;
        trimText := Trim(descField.AsString);
        trimText := StringReplace(trimText, #13, ' ', [rfReplaceAll]);
        trimText := StringReplace(trimText, #10, '', [rfReplaceAll]);
        RichEd.Lines.Add(trimText);

        for J := lastCount to RichEd.Lines.Count-1 do begin
          RichEd.SelStart := LastSelStart;
          RichEd.SelLength := 0;
          RichEd.Paragraph.Alignment := paLeftJustify;
          LastSelStart := LastSelStart + Length(RichEd.Lines[j]);
        end;

        RichEd.Lines.Add('');
        LastSelStart := LastSelStart + 2;
      end;
    end;

    for I := RichEd.Lines.Count-1 downto 0 do
      if Trim(RichEd.Lines[i]) = '' then
        RichEd.Lines.Delete(i)
      else
        Break;

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
begin
  btnOk.Left := (pButton.ClientWidth div 2) - (btnOk.Width div 2); 
end;

end.
