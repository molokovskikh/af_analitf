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
    dsPreviosOrders: TDataSource;
    Label1: TLabel;
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
    adsPreviosOrders: TMyQuery;
    adsPreviosOrdersFullCode: TLargeintField;
    adsPreviosOrdersCode: TStringField;
    adsPreviosOrdersCodeCR: TStringField;
    adsPreviosOrdersSynonymName: TStringField;
    adsPreviosOrdersSynonymFirm: TStringField;
    adsPreviosOrdersOrderCount: TIntegerField;
    adsPreviosOrdersPrice: TFloatField;
    adsPreviosOrdersOrderDate: TDateTimeField;
    adsPreviosOrdersPriceName: TStringField;
    adsPreviosOrdersRegionName: TStringField;
    adsPreviosOrdersAwait: TBooleanField;
    adsPreviosOrdersJunk: TBooleanField;
    adsCatalogName: TMyQuery;
    adsCatalogNameNAME: TStringField;
    adsCatalogNameFORM: TStringField;
    dsCatalogName: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowFormHistory(GroupByProducts : Boolean; FullCode, ProductId : Int64; ClientId: Integer);

implementation

uses DModule;

{$R *.dfm}

procedure ShowFormHistory(GroupByProducts : Boolean; FullCode, ProductId : Int64; ClientId: Integer);
var
  Avr : Currency;
  Count : Integer;
begin
  with TFormsHistoryForm.Create(Application) do try
    Screen.Cursor:=crHourglass;
    try
      adsCatalogName.ParamByName('FullCode').Value := FullCode;
      adsCatalogName.Open;
      
      with adsPreviosOrders do begin
        ParamByName('GroupByProducts').Value := GroupByProducts;
        ParamByName('ProductId').Value       := ProductId;
        ParamByName('FullCode').Value        := FullCode;
        ParamByName('ClientId').Value        := ClientId;
        Open;
      end;
      Count := 0;
      Avr := 0;
      while not adsPreviosOrders.Eof do
      begin
        if (Now - adsPreviosOrdersORDERDATE.Value < 183) then begin
          Avr := Avr + adsPreviosOrdersPRICE.Value;
          Inc(Count);
          adsPreviosOrders.Next;
        end
        else
          Break;
      end;
      adsPreviosOrders.First;
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
