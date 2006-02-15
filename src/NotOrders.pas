unit NotOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TNotOrdersForm = class(TForm)
    Memo: TMemo;
    Label1: TLabel;
    btnOK: TButton;
    Button1: TButton;
    btnCancel: TButton;
    SaveDialog: TSaveDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function CheckMinReq: boolean;

implementation

uses DModule, AProc;

{$R *.dfm}

function ShowNotOrders( Strings: TStrings): boolean;
begin
	with TNotOrdersForm.Create( Application) do
	begin
		try
	        	Memo.Lines.Assign( Strings);
			result := ShowModal = mrOK;
	        finally
			Free;
		end;
	end;
end;

function CheckMinReq: boolean;
var
	Strings: TStrings;
  C : Currency;
begin
	result := True;
	DM.adsSelect.Close;
	DM.adsSelect.SQLs.SelectSQL.Text :=
'SELECT OH.*, PRD.MinReq '+
'FROM OrdersHShow(:AClientID, :AClosed, :TimeZoneBias) OH ' +
'LEFT JOIN PricesRegionalData PRD ON (OH.PriceCode=PRD.PriceCode AND OH.RegionCode=PRD.RegionCode) '+
'WHERE Send = 1';
	DM.adsSelect.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsSelect.ParamByName( 'AClosed').Value := False;
	DM.adsSelect.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	DM.adsSelect.Open;
	Strings := TStringList.Create;
  while not DM.adsSelect.Eof do
  begin
    C := DM.GetSumOrder(DM.adsSelect.FieldByName( 'OrderID').AsInteger);
    if C < DM.adsSelect.FieldByName( 'MinReq').AsCurrency then
      Strings.Append( Format( '%s (%s) : минимальный заказ %s - заказано %m',
        [ DM.adsSelect.FieldByName( 'PriceName').AsString,
        DM.adsSelect.FieldByName( 'RegionName').AsString,
        DM.adsSelect.FieldByName( 'MinReq').AsString,
        C]));
    DM.adsSelect.Next;
  end;
  if Strings.Count > 0 then
    result := ShowNotOrders( Strings);
	Strings.Free;
	DM.adsSelect.Close;
end;

procedure TNotOrdersForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile( SaveDialog.FileName);
end;

end.
