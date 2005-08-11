unit Registers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, ADODB, DB,
  Placemnt, StdCtrls, DBCtrls, DBGridEh, ToughDBGrid, ExtCtrls, Registry,
  FIBDataSet, pFIBDataSet;

const
	RegistrySql	= 'SELECT * FROM Registry ORDER BY ';

type
  TRegistersForm = class(TChildForm)
    dsRegistry: TDataSource;
    dbtName: TDBText;
    dbtBox: TDBText;
    dbtProducer: TDBText;
    adsRegistry2: TADODataSet;
    adsRegistry2Id: TAutoIncField;
    adsRegistry2Name: TWideStringField;
    adsRegistry2Form: TWideStringField;
    adsRegistry2Producer: TWideStringField;
    adsRegistry2Box: TWideStringField;
    adsRegistry2Price: TBCDField;
    adsRegistry2Currency: TWideStringField;
    adsRegistry2PriceRub: TBCDField;
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
    procedure dbgRegistrySortChange(Sender: TObject; SQLOrderBy: String);
  private
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  DModule, Main;

procedure TRegistersForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
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
//  txtTablesUpdates.Caption:=DM.GetTablesUpdatesInfo('Registry');
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgRegistry.LoadFromRegistry( Reg);
	Reg.Free;
  ShowForm;
end;

procedure TRegistersForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgRegistry.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TRegistersForm.dbgRegistrySortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsRegistry.DisableControls;
	Screen.Cursor := crHourglass;
	try
		adsRegistry.Close;
		adsRegistry.SelectSQL.Text := RegistrySql + SQLOrderBy;
		adsRegistry.Open;
	finally
		adsRegistry.EnableControls;
		Screen.Cursor := crDefault;
	end;
end;

end.
