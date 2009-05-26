unit NotOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, U_VistaCorrectForm;

type
  TNotOrdersForm = class(TVistaCorrectForm)
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
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
	DM.adsQueryValue.SQL.Text :=''
+'SELECT OrdersHead.OrderId                 , '
+'       OrdersHead.PriceName               , '
+'       OrdersHead.RegionName              , '
+'       pricesregionaldata.minreq       , '
+'       pricesregionaldata.ControlMinReq, '
+'       OrdersPositions.Positions '
+'FROM ((OrdersHead '
+'       INNER JOIN '
+'              ( SELECT  OrdersList.OrderId, '
+'                       COUNT(*) AS Positions '
+'              FROM     OrdersList '
+'              WHERE    OrdersList.OrderCount > 0 '
+'              GROUP BY OrdersList.OrderId '
+'              ) OrdersPositions     ON OrdersPositions.OrderId = OrdersHead.OrderId '
+'       LEFT JOIN PricesData         ON OrdersHead.PriceCode=PricesData.PriceCode) '
+'       LEFT JOIN pricesregionaldata ON pricesregionaldata.PriceCode = OrdersHead.PriceCode AND pricesregionaldata.regioncode = OrdersHead.regioncode) '
+'       LEFT JOIN RegionalData       ON (RegionalData.RegionCode=OrdersHead.RegionCode) AND (PricesData.FirmCode=RegionalData.FirmCode) '
+'WHERE (OrdersHead.ClientId = :AClientId) '
+'   AND (OrdersHead.Closed = 0) '
+'   AND (OrdersHead.Send = 1) '
+'   AND (PricesData.PriceCode IS NOT NULL) '
+'   AND (RegionalData.RegionCode IS NOT NULL) '
+'   AND (pricesregionaldata.PriceCode IS NOT NULL) '
+'   AND (OrdersPositions.Positions > 0)';
	DM.adsQueryValue.ParamByName( 'AClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	Strings := TStringList.Create;
  try
    DM.adsQueryValue.Open;

    try
      while not DM.adsQueryValue.Eof do
      begin
        if ((DM.adsQueryValue.FieldByName('ControlMinReq').AsBoolean)) then begin
          C := DM.GetSumOrder(DM.adsQueryValue.FieldByName( 'OrderID').AsInteger);
          if (C < DM.adsQueryValue.FieldByName( 'MinReq').AsCurrency) then
            Strings.Append( Format( '%s (%s) : минимальный заказ %s - заказано %m',
              [ DM.adsQueryValue.FieldByName( 'PriceName').AsString,
              DM.adsQueryValue.FieldByName( 'RegionName').AsString,
              DM.adsQueryValue.FieldByName( 'MinReq').AsString,
              C]));
        end;
        DM.adsQueryValue.Next;
      end;
    finally
      DM.adsQueryValue.Close;
    end;

    if Strings.Count > 0 then
      result := ShowNotOrders( Strings);
      
  finally
	  Strings.Free;
  end;

end;

procedure TNotOrdersForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile( SaveDialog.FileName);
end;

end.
