unit PreviousOrders;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, ExtCtrls, DB, MemDS, DBAccess, MyAccess, DBCtrls,
  StdCtrls, GridsEh, DBGridEh, ToughDBGrid, ActnList;

type
  TPreviousOrdersForm = class(TChildForm)
    dsPreviousOrders: TDataSource;
    adsPreviousOrders: TMyQuery;
    adsPreviousOrdersFullCode: TLargeintField;
    adsPreviousOrdersCode: TStringField;
    adsPreviousOrdersCodeCR: TStringField;
    adsPreviousOrdersSynonymName: TStringField;
    adsPreviousOrdersSynonymFirm: TStringField;
    adsPreviousOrdersOrderCount: TIntegerField;
    adsPreviousOrdersOrderDate: TDateTimeField;
    adsPreviousOrdersPriceName: TStringField;
    adsPreviousOrdersRegionName: TStringField;
    adsPreviousOrdersPrice: TFloatField;
    adsPreviousOrdersAwait: TBooleanField;
    adsPreviousOrdersJunk: TBooleanField;
    gbPrevOrders: TGroupBox;
    dbgHistory: TToughDBGrid;
    pBottom: TPanel;
    lblPriceAvg: TLabel;
    dbtPriceAvg: TDBText;
    adsAvgOrders: TMyQuery;
    adsAvgOrdersPRICEAVG: TFloatField;
    adsAvgOrdersPRODUCTID: TLargeintField;
    dsAvgOrders: TDataSource;
    adsPreviousOrdersproductid: TLargeintField;
    procedure dbgHistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowForm(ParentCode : Integer; ByShortCode : Boolean); reintroduce;
  end;

implementation

uses DModule, AProc, NamesForms;

{$R *.dfm}

{ TPreviousOrdersForm }

procedure TPreviousOrdersForm.ShowForm(ParentCode: Integer;
  ByShortCode: Boolean);
begin
  if adsPreviousOrders.Active then
    adsPreviousOrders.Close;

  if adsAvgOrders.Active then
    adsAvgOrders.Close;

  adsPreviousOrders.ParamByName('ClientID').Value := DM.adtClients.FieldByName( 'ClientId').AsInteger;
  adsPreviousOrders.ParamByName('ParentCode').AsInteger := ParentCode;
  adsPreviousOrders.ParamByName('ByShortCode').AsBoolean := ByShortCode;

  adsAvgOrders.ParamByName( 'ClientId').Value :=
    DM.adtClients.FieldByName( 'ClientId').AsInteger;

  adsPreviousOrders.Open;

  adsAvgOrders.Open;

  if adsPreviousOrders.RecordCount = 0 then
  begin
    AProc.MessageBox( 'Нет истории заказов', MB_ICONWARNING);
    Abort;
  end;

  inherited ShowForm; // д.б. перед MainForm.actPrint.OnExecute

  dbgHistory.SetFocus;
end;

procedure TPreviousOrdersForm.dbgHistoryKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ( Key = VK_ESCAPE) then
  begin
    if Self.PrevForm is TNamesFormsForm then
    begin
      Self.PrevForm.ShowForm;
      if TNamesFormsForm( Self.PrevForm).actNewSearch.Checked then
         TNamesFormsForm( Self.PrevForm).dbgCatalog.SetFocus
      else
        if TNamesFormsForm( Self.PrevForm).actUseForms.Checked then
          TNamesFormsForm( Self.PrevForm).dbgForms.SetFocus
        else TNamesFormsForm( Self.PrevForm).dbgNames.SetFocus;
    end;
  end;
end;

end.
