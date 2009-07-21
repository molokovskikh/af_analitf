{$I ..\MyDac.inc}

unit Devart.MyDac.Design.MyDacReg;

{$R ..\..\Images\Devart.MyDac.Design.CRMyHelpItem.bmp}
{$R ..\..\Images\Devart.MyDac.Design.CRMyFAQItem.bmp}
{$R ..\..\Images\Devart.MyDac.Design.CRMyHomePageItem.bmp}
{$R ..\..\Images\Devart.MyDac.Design.CRMyDACPageItem.bmp}
{$R ..\..\Images\Devart.MyDac.Design.MyDACDBMonitorItem.bmp}
{$R ..\..\Images\Devart.MyDac.Design.MyDACMyBuilderItem.bmp}
{$IFDEF DBTOOLS}
{$R ..\..\Images\Devart.MyDac.Design.MyDACDeveloperToolsPageItem.bmp}
{$ENDIF}

{$IFDEF VER10P}

{$IFNDEF STD}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove.bmp}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove16.bmp}
{$R ..\..\Images\Devart.Dac.CRBatchMove.TCRBatchMove32.bmp}
{$ENDIF}

{$R ..\..\Images\Devart.MyDac.MyAccess.TMyCommand.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyConnection.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyQuery.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyStoredProc.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyTable.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyUpdateSQL.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyDataSource.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyMetaData.bmp}
{$R ..\..\Images\Devart.MyDac.MyDacVcl.TMyConnectDialog.bmp}
{$R ..\..\Images\Devart.MyDac.MyDump.TMyDump.bmp}
{$R ..\..\Images\Devart.MyDac.MyEmbConnection.TMyEmbConnection.bmp}
{$R ..\..\Images\Devart.MyDac.MyLoader.TMyLoader.bmp}
{$R ..\..\Images\Devart.MyDac.MyScript.TMyScript.bmp}
{$R ..\..\Images\Devart.MyDac.MyServerControl.TMyServerControl.bmp}
{$R ..\..\Images\Devart.MyDac.MySQLMonitor.TMySQLMonitor.bmp}
{$R ..\..\Images\Devart.MyDac.MyBackup.TMyBackup.bmp}
{$R ..\..\Images\Devart.MyDac.MyBuilderClient.TMyBuilder.bmp}

{$R ..\..\Images\Devart.MyDac.MyAccess.TMyCommand16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyConnection16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyQuery16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyStoredProc16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyTable16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyUpdateSQL16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyDataSource16.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyMetaData16.bmp}
{$R ..\..\Images\Devart.MyDac.MyDacVcl.TMyConnectDialog16.bmp}
{$R ..\..\Images\Devart.MyDac.MyDump.TMyDump16.bmp}
{$R ..\..\Images\Devart.MyDac.MyEmbConnection.TMyEmbConnection16.bmp}
{$R ..\..\Images\Devart.MyDac.MyLoader.TMyLoader16.bmp}
{$R ..\..\Images\Devart.MyDac.MyScript.TMyScript16.bmp}
{$R ..\..\Images\Devart.MyDac.MyServerControl.TMyServerControl16.bmp}
{$R ..\..\Images\Devart.MyDac.MySQLMonitor.TMySQLMonitor16.bmp}
{$R ..\..\Images\Devart.MyDac.MyBackup.TMyBackup16.bmp}
{$R ..\..\Images\Devart.MyDac.MyBuilderClient.TMyBuilder16.bmp}

{$R ..\..\Images\Devart.MyDac.MyAccess.TMyCommand32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyConnection32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyQuery32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyStoredProc32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyTable32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyUpdateSQL32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyDataSource32.bmp}
{$R ..\..\Images\Devart.MyDac.MyAccess.TMyMetaData32.bmp}
{$R ..\..\Images\Devart.MyDac.MyDacVcl.TMyConnectDialog32.bmp}
{$R ..\..\Images\Devart.MyDac.MyDump.TMyDump32.bmp}
{$R ..\..\Images\Devart.MyDac.MyEmbConnection.TMyEmbConnection32.bmp}
{$R ..\..\Images\Devart.MyDac.MyLoader.TMyLoader32.bmp}
{$R ..\..\Images\Devart.MyDac.MyScript.TMyScript32.bmp}
{$R ..\..\Images\Devart.MyDac.MyServerControl.TMyServerControl32.bmp}
{$R ..\..\Images\Devart.MyDac.MySQLMonitor.TMySQLMonitor32.bmp}
{$R ..\..\Images\Devart.MyDac.MyBackup.TMyBackup32.bmp}
{$R ..\..\Images\Devart.MyDac.MyBuilderClient.TMyBuilder32.bmp}

{$ELSE}

{$IFNDEF STD}
{$R ..\..\Images\Delphi8\Devart.Dac.CRBatchMove.TCRBatchMove.bmp}
{$ENDIF}

{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyCommand.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyConnection.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyQuery.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyStoredProc.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyTable.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyUpdateSQL.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyDataSource.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyAccess.TMyMetaData.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyDacVcl.TMyConnectDialog.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyDump.TMyDump.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyEmbConnection.TMyEmbConnection.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyLoader.TMyLoader.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyScript.TMyScript.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyServerControl.TMyServerControl.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MySQLMonitor.TMySQLMonitor.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyBackup.TMyBackup.bmp}
{$R ..\..\Images\Delphi8\Devart.MyDac.MyBuilderClient.TMyBuilder.bmp}

{$ENDIF}


{$I ..\Design\MyDacReg.pas}
