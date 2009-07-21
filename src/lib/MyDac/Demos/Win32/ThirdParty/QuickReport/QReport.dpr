program QReport;

uses
  Forms,
  Main in 'Main.pas' {fmMain},
  Report1 in 'Report1.pas' {qrReport1: TQuickRep};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TqrReport1, qrReport1);
  Application.Run;
end.
