unit FormHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DBCtrls, DB, ADODB, DBGridEh,
  ToughDBGrid;

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
    adsOrders: TADODataSet;
    adsWareData: TADODataSet;
    adsWareDataName: TWideStringField;
    adsWareDataForm: TWideStringField;
    adsWareDataPriceAvg: TBCDField;
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
        Parameters.ParamByName('AFullCode').Value:=FullCode;
        Parameters.ParamByName('AClientId').Value:=ClientId;
        Open;
      end;
      with adsOrders do begin
        Parameters.ParamByName('AFullCode').Value:=FullCode;
        Parameters.ParamByName('AClientId').Value:=ClientId;
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
