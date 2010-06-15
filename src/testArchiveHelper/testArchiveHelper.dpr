program testArchiveHelper;

uses
  Forms,
  U_frmMain in 'U_frmMain.pas' {frmMain},
  LU_Tracer in '..\AnalitF\common\LU_Tracer.pas',
  SevenZip in '..\AnalitF\common\SevenZip.pas',
  ArchiveHelper in '..\AnalitF\Helpers\ArchiveHelper.pas',
  U_ExchangeLog in '..\AnalitF\U_ExchangeLog.pas',
  AProc in '..\AnalitF\AProc.pas',
  U_SXConversions in '..\AnalitF\common\U_SXConversions.pas',
  U_SGXMLGeneral in '..\AnalitF\common\U_SGXMLGeneral.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
