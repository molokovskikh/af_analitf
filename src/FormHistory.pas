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
    adsOrdersFULLCODE: TFIBBCDField;
    adsOrdersSYNONYMNAME: TFIBStringField;
    adsOrdersSYNONYMFIRM: TFIBStringField;
    adsOrdersORDERCOUNT: TFIBIntegerField;
    adsOrdersPRICE: TFIBBCDField;
    adsOrdersORDERDATE: TFIBDateTimeField;
    adsOrdersPRICENAME: TFIBStringField;
    adsOrdersREGIONNAME: TFIBStringField;
    adsOrdersAWAIT: TFIBIntegerField;
    adsOrdersJUNK: TFIBIntegerField;
    adsWareData: TpFIBDataSet;
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
begin
  with TFormsHistoryForm.Create(Application) do try
    Screen.Cursor:=crHourglass;
    try
      with adsWareData do begin
        ParamByName('AFullCode').Value:=FullCode;
        ParamByName('AClientId').Value:=ClientId;
        Open;
      end;
      with adsOrders do begin
        ParamByName('AFullCode').Value:=FullCode;
        ParamByName('AClientId').Value:=ClientId;
        Open;
      end;
    finally
      Screen.Cursor:=crDefault;
    end;
    ShowModal;
  finally
    Free;
  end;
end;

end.
