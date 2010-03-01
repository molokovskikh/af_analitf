program testExecutePreparedSQL;

uses
  Forms,
  U_frmMain in 'U_frmMain.pas' {frmMain},
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas',
  AProc in '..\AnalitF\AProc.pas',
  hlpcodecs in '..\AnalitF\RC_RND\hlpcodecs.pas',
  incrt in '..\AnalitF\RC_RND\incrt.pas',
  INFHelpers in '..\AnalitF\RC_RND\INFHelpers.pas',
  inforoomalg in '..\AnalitF\RC_RND\inforoomalg.pas',
  inforoomapi in '..\AnalitF\RC_RND\inforoomapi.pas',
  infver in '..\AnalitF\RC_RND\infver.pas',
  infvercls in '..\AnalitF\RC_RND\infvercls.pas',
  SevenZip in '..\AnalitF\common\SevenZip.pas',
  LU_MutexSystem in '..\AnalitF\common\LU_MutexSystem.pas',
  LU_Tracer in '..\AnalitF\common\LU_Tracer.pas',
  LU_TSGHashTable in '..\AnalitF\common\LU_TSGHashTable.pas',
  U_SGXMLGeneral in '..\AnalitF\common\U_SGXMLGeneral.pas',
  U_SXConversions in '..\AnalitF\common\U_SXConversions.pas',
  U_ExchangeLog in '..\AnalitF\U_ExchangeLog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
