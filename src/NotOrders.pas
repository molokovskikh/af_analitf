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
begin
	result := True;
	DM.adsSelect.Close;
	DM.adsSelect.SQLs.SelectSQL.Text :=
'SELECT OH.*, PRD.MinReq '+
'FROM OrdersHShow(:ClientID, :Closed, :TimeZoneBias) OH ' +
'LEFT JOIN PricesRegionalData PRD ON (OH.PriceCode=PRD.PriceCode AND OH.RegionCode=PRD.RegionCode) '+
'WHERE OH.SumOrder<PRD.MinReq AND Send = 1';
	DM.adsSelect.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	DM.adsSelect.ParamByName( 'AClosed').Value := False;
	DM.adsSelect.ParamByName( 'TimeZoneBias').Value := TimeZoneBias;
	DM.adsSelect.Open;
	Strings := TStringList.Create;
	if not DM.adsSelect.IsEmpty then
	begin
		while not DM.adsSelect.Eof do
		begin
			Strings.Append( Format( '%s (%s) : минимальный заказ %s - заказано %s',
				[ DM.adsSelect.FieldByName( 'PriceName').AsString,
				DM.adsSelect.FieldByName( 'RegionName').AsString,
				DM.adsSelect.FieldByName( 'MinReq').AsString,
				DM.adsSelect.FieldByName( 'SumOrder').AsString]));
			DM.adsSelect.Next;
		end;
		result := ShowNotOrders( Strings);
	end;
	Strings.Free;
	DM.adsSelect.Close;
end;

procedure TNotOrdersForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile( SaveDialog.FileName);
end;

end.
