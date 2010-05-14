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

uses DModule, AProc, DB;

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
  ControlMinReqOrders : String;
begin
	result := True;
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;
	DM.adsQueryValue.SQL.Text :=''
+'SELECT CurrentOrderHeads.OrderId                 , '
+'       CurrentOrderHeads.PriceName               , '
+'       CurrentOrderHeads.RegionName              , '
+'       MinReqRules.minreq       , '
+'       MinReqRules.ControlMinReq, '
+'       OrdersPositions.Positions '
+'FROM ((CurrentOrderHeads '
+'       INNER JOIN '
+'              ( SELECT  CurrentOrderLists.OrderId, '
+'                       COUNT(*) AS Positions '
+'              FROM     CurrentOrderLists '
+'              WHERE    CurrentOrderLists.OrderCount > 0 '
+'              GROUP BY CurrentOrderLists.OrderId '
+'              ) OrdersPositions     ON OrdersPositions.OrderId = CurrentOrderHeads.OrderId '
+'       LEFT JOIN PricesData         ON CurrentOrderHeads.PriceCode=PricesData.PriceCode) '
+'       LEFT JOIN pricesregionaldata ON pricesregionaldata.PriceCode = CurrentOrderHeads.PriceCode AND pricesregionaldata.regioncode = CurrentOrderHeads.regioncode) '
+'       LEFT JOIN RegionalData       ON (RegionalData.RegionCode=CurrentOrderHeads.RegionCode) AND (PricesData.FirmCode=RegionalData.FirmCode) '
+'       LEFT JOIN MinReqRules        ON (MinReqRules.ClientId = CurrentOrderHeads.ClientId) and (MinReqRules.PriceCode = CurrentOrderHeads.PriceCode) and (MinReqRules.RegionCode=CurrentOrderHeads.RegionCode) '
+'WHERE (CurrentOrderHeads.ClientId = :ClientId) '
+'   AND (CurrentOrderHeads.Closed = 0) '
+'   AND (CurrentOrderHeads.Send = 1) '
+'   AND (PricesData.PriceCode IS NOT NULL) '
+'   AND (RegionalData.RegionCode IS NOT NULL) '
+'   AND (pricesregionaldata.PriceCode IS NOT NULL) '
+'   AND (OrdersPositions.Positions > 0)';
	DM.adsQueryValue.ParamByName( 'ClientId').Value := DM.adtClients.FieldByName( 'ClientId').Value;
	Strings := TStringList.Create;
  ControlMinReqOrders := '';
  try
    DM.adsQueryValue.Open;

    try
      while not DM.adsQueryValue.Eof do
      begin
        C := DM.GetSumOrder(DM.adsQueryValue.FieldByName( 'OrderID').AsInteger);
        if (DM.adsQueryValue.FieldByName( 'MinReq').AsCurrency > 0) and (C < DM.adsQueryValue.FieldByName( 'MinReq').AsCurrency) then begin
          if (DM.adsQueryValue.FieldByName('ControlMinReq').AsBoolean) then begin
            Strings.Append( Format( '%s (%s) : необходимый минимальный заказ %s - заказано %m',
              [ DM.adsQueryValue.FieldByName( 'PriceName').AsString,
              DM.adsQueryValue.FieldByName( 'RegionName').AsString,
              DM.adsQueryValue.FieldByName( 'MinReq').AsString,
              C]));
            if ControlMinReqOrders <> '' then
              ControlMinReqOrders := ControlMinReqOrders + ', ';
            ControlMinReqOrders := ControlMinReqOrders + DM.adsQueryValue.FieldByName('OrderId').AsString;
          end
          else begin
            Strings.Append( Format( '%s (%s) : желательный минимальный заказ %s - заказано %m',
              [ DM.adsQueryValue.FieldByName( 'PriceName').AsString,
              DM.adsQueryValue.FieldByName( 'RegionName').AsString,
              DM.adsQueryValue.FieldByName( 'MinReq').AsString,
              C]));
          end;
        end;
        DM.adsQueryValue.Next;
      end;
    finally
      DM.adsQueryValue.Close;
    end;

    if Strings.Count > 0 then begin
      result := ShowNotOrders( Strings);
      if Result and (Length(ControlMinReqOrders) > 0) then begin
        DM.adcUpdate.SQL.Text :=
          'update CurrentOrderHeads set Send = 0 where OrderId in ('
          + ControlMinReqOrders + ')';
        DM.adcUpdate.Execute;
      end;
    end;

  finally
	  Strings.Free;
  end;

end;

procedure TNotOrdersForm.Button1Click(Sender: TObject);
begin
	if SaveDialog.Execute then Memo.Lines.SaveToFile( SaveDialog.FileName);
end;

end.
