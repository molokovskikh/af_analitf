program testDNSChanger;

uses
  Forms,
  U_frmMain in 'U_frmMain.pas' {frmMain},
  NetworkAdapterHelpers in '..\AnalitF\Helpers\NetworkAdapterHelpers.pas',
  hlpcodecs in '..\AnalitF\RC_RND\hlpcodecs.pas',
  incrt in '..\AnalitF\RC_RND\incrt.pas',
  inforoomalg in '..\AnalitF\RC_RND\inforoomalg.pas',
  inforoomapi in '..\AnalitF\RC_RND\inforoomapi.pas',
  infver in '..\AnalitF\RC_RND\infver.pas',
  infvercls in '..\AnalitF\RC_RND\infvercls.pas',
  U_ExchangeLog in '..\AnalitF\U_ExchangeLog.pas',
  LU_Tracer in '..\AnalitF\common\LU_Tracer.pas',
  ARas in '..\lib\ARas\src\ARas.pas',
  Ras in '..\lib\ARas\src\Ras.pas',
  CreateEntry in '..\lib\ARas\src\CreateEntry.pas' {CreateRasEntryForm},
  InputBox in '..\lib\ARas\src\InputBox.pas' {InputBoxForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
