unit VitallyImportantMarkupsParams;

interface

uses
  SysUtils,
  Classes,
  Variants,
  MyAccess,
  GlobalParams;

type
  TVitallyImportantMarkupsParams = class(TGlobalParams)
   public
    UseProducerCostWithNDS : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

{ TVitallyImportantMarkupsParams }

procedure TVitallyImportantMarkupsParams.ReadParams;
begin
  UseProducerCostWithNDS := GetParamDef('UseProducerCostWithNDS', False);
end;

procedure TVitallyImportantMarkupsParams.SaveParams;
begin
  SaveParam('UseProducerCostWithNDS', UseProducerCostWithNDS);
  inherited;
end;

end.
