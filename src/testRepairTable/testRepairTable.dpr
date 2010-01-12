program testRepairTable;

uses
  Forms,
  MainForm in 'MainForm.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
