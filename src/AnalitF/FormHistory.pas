unit FormHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, DB, DBGridEh,
  ToughDBGrid, FIBDataSet, pFIBDataSet, GridsEh, MemDS, DBAccess, MyAccess;

type
  TFormsHistoryForm = class(TForm)
    dbtName: TDBText;
    dbrForm: TDBText;
    btnClose: TButton;
    dsOrders: TDataSource;
    Label1: TLabel;
    dbtPriceAvg: TDBText;
    Grid: TToughDBGrid;
    adsOrdersOld: TpFIBDataSet;
    adsOrdersOldFULLCODE: TFIBBCDField;
    adsOrdersOldSYNONYMNAME: TFIBStringField;
    adsOrdersOldSYNONYMFIRM: TFIBStringField;
    adsOrdersOldORDERCOUNT: TFIBIntegerField;
    adsOrdersOldCODE: TFIBStringField;
    adsOrdersOldCODECR: TFIBStringField;
    adsOrdersOldORDERDATE: TFIBDateTimeField;
    adsOrdersOldPRICENAME: TFIBStringField;
    adsOrdersOldREGIONNAME: TFIBStringField;
    adsOrdersOldAWAIT: TFIBIntegerField;
    adsOrdersOldJUNK: TFIBIntegerField;
    lPriceAvg: TLabel;
    adsOrdersOldPRICE: TFIBStringField;
    adsOrdersOldSENDPRICE: TFIBBCDField;
    adsOrders: TMyQuery;
    adsOrdersFullCode: TLargeintField;
    adsOrdersCode: TStringField;
    adsOrdersCodeCR: TStringField;
    adsOrdersSynonymName: TStringField;
    adsOrdersSynonymFirm: TStringField;
    adsOrdersOrderCount: TIntegerField;
    adsOrdersPrice: TFloatField;
    adsOrdersOrderDate: TDateTimeField;
    adsOrdersPriceName: TStringField;
    adsOrdersRegionName: TStringField;
    adsOrdersAwait: TBooleanField;
    adsOrdersJunk: TBooleanField;
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
      with adsOrders do begin
        ParamByName('FullCode').Value:=FullCode;
        ParamByName('ClientId').Value:=ClientId;
        Open;
      end;
      Count := 0;
      Avr := 0;
      while not adsOrders.Eof do
      begin
        if (Now - adsOrdersORDERDATE.Value < 183) then begin
          Avr := Avr + adsOrdersPRICE.Value;
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
