unit Registers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  Placemnt, StdCtrls, DBCtrls, DBGridEh, ToughDBGrid, ExtCtrls, 
  FIBDataSet, pFIBDataSet, DBProc, GridsEh;

const
	RegistrySql	= 'SELECT * FROM Registry ORDER BY ';

type
  TRegistersForm = class(TChildForm)
    dsRegistry: TDataSource;
    dbtName: TDBText;
    dbtBox: TDBText;
    dbtProducer: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    dbgRegistry: TToughDBGrid;
    Bevel1: TBevel;
    adsRegistry: TpFIBDataSet;
    adsRegistryID: TFIBBCDField;
    adsRegistryNAME: TFIBStringField;
    adsRegistryFORM: TFIBStringField;
    adsRegistryPRODUCER: TFIBStringField;
    adsRegistryBOX: TFIBStringField;
    adsRegistryPRICE: TFIBBCDField;
    adsRegistryCURR: TFIBStringField;
    adsRegistryPRICERUB: TFIBBCDField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbgRegistrySortMarkingChanged(Sender: TObject);
  private
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  DModule, Main, DBGridHelper;

procedure TRegistersForm.FormCreate(Sender: TObject);
begin
  inherited;
  with adsRegistry do begin
    Screen.Cursor:=crHourglass;
    try
      Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
  TDBGridHelper.RestoreColumnsLayout(dbgRegistry, Self.ClassName);
  ShowForm;
end;

procedure TRegistersForm.FormDestroy(Sender: TObject);
begin
  TDBGridHelper.SaveColumnsLayout(dbgRegistry, Self.ClassName);
end;

procedure TRegistersForm.dbgRegistrySortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

end.
