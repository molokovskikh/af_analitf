unit WayBillList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGridEh, ToughDBGrid, ExtCtrls, DB, ADODB,
  DBCtrls, StdCtrls;

type
  TWayBillListForm = class(TChildForm)
    pHeader: TPanel;
    dbgWBL: TToughDBGrid;
    adsWBL: TADODataSet;
    dsWBL: TDataSource;
    adsWBLServerID: TIntegerField;
    adsWBLServerWayBillID: TIntegerField;
    adsWBLFullCode: TIntegerField;
    adsWBLCodeFirmCr: TIntegerField;
    adsWBLSynonymCode: TIntegerField;
    adsWBLSynonymFirmCrCode: TIntegerField;
    adsWBLSynonym: TWideStringField;
    adsWBLSynonymFirm: TWideStringField;
    adsWBLCode: TWideStringField;
    adsWBLCodeCr: TWideStringField;
    adsWBLQuantity: TIntegerField;
    adsWBLCost: TBCDField;
    Label1: TLabel;
    dbtID: TDBText;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbtDate: TDBText;
    dbtPriceName: TDBText;
    dbtRowCount: TDBText;
    gbComment: TGroupBox;
    dbmComment: TDBMemo;
    procedure dbgWBLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowForm(AServerWayBillId: Integer); reintroduce;
    procedure SetParams(AServerWayBillId: Integer);
  end;

var
  WayBillListForm: TWayBillListForm;

implementation

{$R *.dfm}

uses
  DModule, OrdersH;

{ TWayBillListForm }

procedure TWayBillListForm.SetParams(AServerWayBillId: Integer);
begin
  adsWBL.Parameters.ParamByName('[AWayBillId]').Value := AServerWayBillId;
  if adsWBL.Active then adsWBL.Requery() else adsWBL.Open;
end;

procedure TWayBillListForm.ShowForm(AServerWayBillId: Integer);
begin
  SetParams(AServerWayBillId);
  inherited ShowForm;
end;

procedure TWayBillListForm.dbgWBLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
	if Key = VK_ESCAPE then PrevForm.ShowForm;
end;

end.
