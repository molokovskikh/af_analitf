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
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
	DM.adsQueryValue.SQL.Text :='' 
+'SELECT OrdersH.OrderId                 , ' 
+'       OrdersH.PriceName               , ' 
+'       OrdersH.RegionName              , ' 
+'       pricesregionaldata.minreq       , ' 
+'       pricesregionaldata.ControlMinReq, ' 
+'       OrdersPositions.Positions ' 
+'FROM ((OrdersH ' 
+'       INNER JOIN ' 
+'              ( SELECT  Orders.OrderId, ' 
+'                       COUNT(*) AS Positions ' 
+'              FROM     Orders ' 
+'              WHERE    Orders.OrderCount > 0 ' 
+'              GROUP BY Orders.OrderId ' 
+'              ) OrdersPositions     ON OrdersPositions.OrderId = OrdersH.OrderId ' 
+'       LEFT JOIN PricesData         ON OrdersH.PriceCode=PricesData.PriceCode) ' 
+'       LEFT JOIN pricesregionaldata ON pricesregionaldata.PriceCode = OrdersH.PriceCode AND pricesregionaldata.regioncode = OrdersH.regioncode) ' 
+'       LEFT JOIN RegionalData       ON (RegionalData.RegionCode=OrdersH.RegionCode) AND (PricesData.FirmCode=RegionalData.FirmCode) ' 
+'WHERE (OrdersH.ClientId = :AClientId) ' 
+'   AND (OrdersH.Closed = 0) ' 
+'   AND (OrdersH.Send = 1) ' 
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

  finally
	  Strings.Free;
  end;

  if Strings.Count > 0 then
    result := ShowNotOrders( Strings);
end;

procedure TNotOrdersForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile( SaveDialog.FileName);
end;

end.
