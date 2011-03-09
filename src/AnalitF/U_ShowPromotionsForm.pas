unit U_ShowPromotionsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  DModule,
  U_VistaCorrectForm;

type
  TShowPromotionsForm = class(TVistaCorrectForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    pcPromotions : TPageControl;

    procedure Prepare(catalogId : Int64);
  end;

  procedure ShowPromotions(catalogId : Int64);

implementation

{$R *.dfm}

procedure ShowPromotions(catalogId : Int64);
var
  ShowPromotionsForm: TShowPromotionsForm;
begin
  ShowPromotionsForm := TShowPromotionsForm.Create(Application);
  try
    ShowPromotionsForm.Prepare(catalogId);
    ShowPromotionsForm.ShowModal;
  finally
    ShowPromotionsForm.Free;
  end;

end;

{ TShowPromotionsForm }

procedure TShowPromotionsForm.Prepare(catalogId: Int64);
var
  tsCurrent : TTabSheet;
  mCurrent : TMemo;

begin
  pcPromotions := TPageControl.Create(Self);
  pcPromotions.Align := alClient;
  pcPromotions.Parent := Self;
  Self.Caption := 'Акции по препарату';

  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := '' +
' select ' +
'   concat(Catalogs.Name, '' '', Catalogs.Form) as FullName, ' +
'   SupplierPromotions.Id, ' +
'   SupplierPromotions.Annotation, ' +
'   Providers.ShortName ' +
' from ' +
'  Catalogs ' +
'  join SupplierPromotions on SupplierPromotions.CatalogId = Catalogs.FullCode ' +
'  join Providers on Providers.FirmCode = SupplierPromotions.SupplierId ' +
' where ' +
'  Catalogs.FullCode = :CatalogId ' +
' order by Providers.ShortName';

  DM.adsQueryValue.ParamByName('CatalogId').Value := catalogId;
  DM.adsQueryValue.Open;
  try
    Self.Caption := 'Акции по препарату ' + DM.adsQueryValue.FieldByName('FullName').AsString;
    while not DM.adsQueryValue.Eof do begin
      tsCurrent := TTabSheet.Create(Self);
      tsCurrent.PageControl := pcPromotions;
      tsCurrent.Caption := DM.adsQueryValue.FieldByName('ShortName').AsString;

      mCurrent := TMemo.Create(Self);
      mCurrent.Parent := tsCurrent;
      mCurrent.ReadOnly := True;
      mCurrent.Align := alClient;
      mCurrent.Text := DM.adsQueryValue.FieldByName('Annotation').AsString;

      DM.adsQueryValue.Next;
    end;
  finally
    DM.adsQueryValue.Close;
  end;
end;

procedure TShowPromotionsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
