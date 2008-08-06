unit U_frameLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TframeLegeng = class(TFrame)
    pLegend: TPanel;
    lVitallyImportantLegend: TLabel;
    lJunkLegend: TLabel;
    lAwaitLegend: TLabel;
    pNotBasicLegend: TPanel;
    lNotBasicLegend: TLabel;
    lLeaderLegend: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
