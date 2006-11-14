unit FormHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, DB, DBGridEh,
  ToughDBGrid, FIBDataSet, pFIBDataSet;

type
  TFormsHistoryForm = class(TForm)
    dbtName: TDBText;
    dbrForm: TDBText;
    btnClose: TButton;
    dsOrders: TDataSource;
    dsWareData: TDataSource;
    Label1: TLabel;
    dbtPriceAvg: TDBText;
    Grid: TToughDBGrid;
    adsOrders: TpFIBDataSet;
    adsWareData: TpFIBDataSet;
    adsOrdersFULLCODE: TFIBBCDField;
    adsOrdersSYNONYMNAME: TFIBStringField;
    adsOrdersSYNONYMFIRM: TFIBStringField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsOrdersCODE: TFIBStringField;
    adsOrdersCODECR: TFIBStringField;
    adsOrdersORDERDATE: TFIBDateTimeField;
    adsOrdersPRICENAME: TFIBStringField;
    adsOrdersREGIONNAME: TFIBStringField;
    adsOrdersAWAIT: TFIBIntegerField;
    adsOrdersJUNK: TFIBIntegerField;
    lPriceAvg: TLabel;
    adsOrdersPRICE: TFIBStringField;
    adsOrdersSENDPRICE: TFIBBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowFormHistory(FullCode, ClientId: Integer);

implementation

uses DModule;

{$R *.dfm}

procedure ShowFormHistory(FullCode, ClientId: Integer);
var
  Avr : Currency;
  Count : Integer;
begin
  with TFormsHistoryForm.Create(Application) do try
    Screen.Cursor:=crHourglass;
    try
{
      with adsWareData do begin
        ParamByName('AFullCode').Value:=FullCode;
        ParamByName('AClientId').Value:=ClientId;
        Open;
      end;
}
      with adsOrders do begin
        ParamByName('AFullCode').Value:=FullCode;
        ParamByName('AClientId').Value:=ClientId;
        Open;
      end;
      Count := 0;
      Avr := 0;
      while not adsOrders.Eof do
      begin
        if (Now - adsOrdersORDERDATE.Value < 183) then begin
          Avr := Avr + adsOrdersSENDPRICE.Value;
          Inc(Count);
          adsOrders.Next;
        end
        else
          Break;
      end;
      adsOrders.First;
      if Count > 0 then
        Avr := Avr / Count;
      lPriceAvg.Caption := FloatToStrF(Avr, ffCurrency, 15, 2);
    finally
      Screen.Cursor:=crDefault;
    end;
    ShowModal;
  finally
    Free;
  end;
end;

end.
