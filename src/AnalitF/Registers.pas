unit Registers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, Grids, DBGrids, RXDBCtrl, DB,
  Placemnt, StdCtrls, DBCtrls, DBGridEh, ToughDBGrid, ExtCtrls, Registry,
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
  DModule, Main;

procedure TRegistersForm.FormCreate(Sender: TObject);
var
	Reg: TRegIniFile;
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
	Reg := TRegIniFile.Create;
  try
    if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, False)
    then
      dbgRegistry.RestoreColumnsLayout(Reg, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
  finally
  	Reg.Free;
  end;
  ShowForm;
end;

procedure TRegistersForm.FormDestroy(Sender: TObject);
var
	Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + Self.ClassName, True);
    dbgRegistry.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

procedure TRegistersForm.dbgRegistrySortMarkingChanged(Sender: TObject);
begin
  FIBDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

end.
