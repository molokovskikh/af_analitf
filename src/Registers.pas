unit Registers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, ADODB, DB,
  Placemnt, StdCtrls, DBCtrls, DBGridEh, ToughDBGrid, ExtCtrls, Registry;

const
	RegistrySql	= 'SELECT * FROM Registry ORDER BY ';

type
  TRegistersForm = class(TChildForm)
    dsRegistry: TDataSource;
    dbtName: TDBText;
    dbtBox: TDBText;
    dbtProducer: TDBText;
    adsRegistry: TADODataSet;
    adsRegistryId: TAutoIncField;
    adsRegistryName: TWideStringField;
    adsRegistryForm: TWideStringField;
    adsRegistryProducer: TWideStringField;
    adsRegistryBox: TWideStringField;
    adsRegistryPrice: TBCDField;
    adsRegistryCurrency: TWideStringField;
    adsRegistryPriceRub: TBCDField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    dbgRegistry: TToughDBGrid;
    Bevel1: TBevel;
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
		adsRegistry.CommandText := RegistrySql + SQLOrderBy;
		adsRegistry.Open;
	finally
		adsRegistry.EnableControls;
		Screen.Cursor := crDefault;
	end;
end;

end.
