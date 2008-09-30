unit U_frameLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TframeLegeng = class(TFrame)
    gbLegend: TGroupBox;
    lVitallyImportantLegend: TLabel;
    lNotBasicLegend: TLabel;
    lLeaderLegend: TLabel;
    lJunkLegend: TLabel;
    lAwaitLegend: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TframeLegeng }

constructor TframeLegeng.Create(AOwner: TComponent);
begin
  inherited;
  gbLegend.ControlStyle := gbLegend.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

end.
