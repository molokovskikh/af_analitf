unit U_AwaitedProductsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid;

type
  TAwaitedProductsForm = class(TChildForm)
    pButtons: TPanel;
    dbgAwaitedProducts: TToughDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAwaitedProducts;

implementation

uses
  Main,
  AlphaUtils,
  DModule,
  AProc;

{$R *.dfm}

procedure ShowAwaitedProducts;
begin
  MainForm.ShowChildForm(TAwaitedProductsForm);
end;

procedure TAwaitedProductsForm.FormCreate(Sender: TObject);
begin
  inherited;
  NeedFirstOnDataSet := False;

  dbgAwaitedProducts.PopupMenu := nil;

  ShowForm;
end;

end.
