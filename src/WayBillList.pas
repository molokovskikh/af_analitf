unit WayBillList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGridEh, ToughDBGrid, ExtCtrls, DB, 
  DBCtrls, StdCtrls, FIBDataSet, pFIBDataSet;

type
  TWayBillListForm = class(TChildForm)
    pHeader: TPanel;
    dbgWBL: TToughDBGrid;
    dsWBL: TDataSource;
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
    adsWBL: TpFIBDataSet;
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
  adsWBL.ParamByName('AWayBillId').Value := AServerWayBillId;
  if adsWBL.Active then adsWBL.CloseOpen(False) else adsWBL.Open;
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
