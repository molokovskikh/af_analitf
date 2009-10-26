program TestDeleteFolder;

uses
  Forms,
  U_frmMain in 'U_frmMain.pas' {frmMain},
  LU_Tracer in '..\common\LU_Tracer.pas',
  LU_MutexSystem in '..\common\LU_MutexSystem.pas',
  LU_TSGHashTable in '..\common\LU_TSGHashTable.pas',
  U_SGXMLGeneral in '..\common\U_SGXMLGeneral.pas',
  U_SXConversions in '..\common\U_SXConversions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
