unit ExpiringArticlesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, ADBGrid, DModule, DB, ADODB, AProc,
  Placemnt;

type
  TExpiringArticlesForm = class(TChildForm)
    dbgExpiringArticles: TADBGrid;
    adsExpiringArticles: TADODataSet;
    dsExpriringArticles: TDataSource;
    adsExpiringArticlesFirmId: TWideStringField;
    adsExpiringArticless1: TWideStringField;
    adsExpiringArticlesname: TWideStringField;
    adsExpiringArticlescomments: TWideStringField;
    adsExpiringArticlesExpDate: TDateTimeField;
    adsExpiringArticlesFullName: TWideStringField;
    adsExpiringArticlesPriceDate: TDateTimeField;
    adsExpiringArticlesPriceFor: TBCDField;
    adsExpiringArticlesQuantity: TWideStringField;
    adsExpiringArticlesOrder: TIntegerField;
    adsExpiringArticlesPriceRet: TCurrencyField;
    adsExpiringArticlesSumOrder: TCurrencyField;
    adsExpiringArticlesFirmsId: TSmallintField;
    adsExpiringArticlesPrice: TBCDField;
    fpExpiringArticles: TFormPlacement;
    adsExpiringArticlesId: TAutoIncField;
    adsExpiringArticlesClientsId: TSmallintField;
    adsExpiringArticlesWaresId: TIntegerField;
    procedure adsExpiringArticlesCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    RegionIdStr, RegionPriceRet: string;
    RetailForcount: Double;
    Round10: Boolean;
  public
    { Public declarations }
  end;

var
  ExpiringArticlesForm: TExpiringArticlesForm;

implementation

{$R *.dfm}
uses
  Main, ADOInt;

procedure TExpiringArticlesForm.adsExpiringArticlesCalcFields(
  DataSet: TDataSet);
begin
  //вычисляем розничную цену PriceRet
  // по формуле с параметрами в RegionPriceRet
  {if adsExpiringArticlesFirmsId.AsInteger=RegisterId then begin
    with DM.adsSelect do begin
      CommandText:='SELECT '+RegionPriceRet+' FROM Regions WHERE Id='+RegionIdStr;
      Parameters.Refresh;
      if Parameters.Count>0 then
        Parameters.ParamByName('Price').Value:=adsExpiringArticlesPrice.Value;
      try
        Screen.Cursor:=crHourGlass;
        Open;
        if not IsEmpty then
          adsExpiringArticlesPriceRet.AsCurrency:=adsExpiringArticlesPrice.AsFloat*Fields[0].AsFloat;
      finally
        Close;
        Screen.Cursor:=crDefault;
      end;
    end;
  end
  else begin
    adsExpiringArticlesPriceRet.AsCurrency:=adsExpiringArticlesPriceFor.AsCurrency*
      RetailForcount;
    if Round10 then adsExpiringArticlesPriceRet.AsFloat:=
      RoundFloat(adsExpiringArticlesPriceRet.AsCurrency,1);
  end;
  //вычисляем сумму заказа по товару SumOrder
  adsExpiringArticlesSumOrder.AsCurrency:=adsExpiringArticlesPriceFor.AsCurrency*
    adsExpiringArticlesOrder.AsInteger;}
end;

procedure TExpiringArticlesForm.FormCreate(Sender: TObject);
begin
  {with DM.adtClients do begin
    RetailForcount:=1+FieldByName('Forcount').AsFloat/100;
    Round10:=FieldByName('Round10').AsBoolean;
    RegionIdStr:=FieldByName('RegionsId').AsString;
  end;

  //выборка формулы подсчета цены в строковой форме
  with DM.adsSelect do begin
    CommandText:='SELECT PriceRet FROM Regions WHERE Id='+RegionIdStr;
    try
      Open;
      Screen.Cursor:=crHourGlass;
      if not IsEmpty then
        RegionPriceRet:=Fields[0].AsString;
    finally
      Close;
      Screen.Cursor:=crDefault;
    end;
  end;
  adsExpiringArticles.Parameters.ParamByName('ClientId').Value:=DM.adtClients.FieldByName('Id').AsInteger;
  try
    Screen.Cursor:=crHourGlass;
    with adsExpiringArticles do
      begin
        Open;
        Properties['Update Criteria'].Value:=adCriteriaKey;
        Properties['Unique Table'].Value:='Prices';
      end;
  finally
    Screen.Cursor:=crDefault;
  end;
  MainForm.SetCaption('Препараты с истекающими сроками годности');
  ShowForm;}
end;

end.
