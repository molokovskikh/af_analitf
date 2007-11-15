program AnalitF;

{%ToDo 'AnalitF.todo'}

uses
  Forms,
  SysUtils,
  Windows,
  ActiveX,
  Registry,
  SHDocVw,
  Main in 'Main.pas' {MainForm},
  DModule in 'DModule.pas' {DM: TDataModule},
  AProc in 'AProc.pas',
  DBProc in 'DBProc.pas',
  Client in 'Client.pas' {ClientForm},
  Config in 'Config.pas' {ConfigForm},
  Core in 'Core.pas' {CoreForm: TFrame},
  CoreFirm in 'CoreFirm.pas' {CoreFirmForm: TFrame},
  Child in 'Child.pas' {ChildForm},
  NamesForms in 'NamesForms.pas' {NamesFormsForm},
  Prices in 'Prices.pas' {PricesForm},
  Defectives in 'Defectives.pas' {DefectivesForm},
  Registers in 'Registers.pas' {RegistersForm},
  FormHistory in 'FormHistory.pas' {FormsHistoryForm},
  Summary in 'Summary.pas' {SummaryForm},
  OrdersH in 'OrdersH.pas' {OrdersHForm},
  Orders in 'Orders.pas' {OrdersForm},
  Expireds in 'Expireds.pas' {ExpiredsForm},
  Exchange in 'Exchange.pas' {ExchangeForm},
  NotFound in 'NotFound.pas' {NotFoundForm},
  ActiveUsers in 'ActiveUsers.pas' {ActiveUsersForm},
  ExchangeThread in 'ExchangeThread.pas',
  Retry in 'Retry.pas' {RetryForm},
  SOAPThroughHTTP in 'SOAPThroughHTTP.pas',
  ProVersion in 'ProVersion.pas',
  Constant in 'Constant.pas',
  Compact in 'Compact.pas' {CompactForm},
  UniqueID in 'UniqueID.pas',
  CRC32Unit in 'CRC32Unit.pas',
  RecThread in 'RecThread.pas',
  NotOrders in 'NotOrders.pas' {NotOrdersForm},
  SysNames in 'SysNames.pas',
  Exclusive in 'Exclusive.pas' {ExclusiveForm},
  Wait in 'Wait.pas' {WaitForm},
  AlphaUtils in 'AlphaUtils.pas',
  About in 'About.pas' {AboutForm},
  Waiting in 'Waiting.pas' {WaitingForm},
  CompactThread in 'CompactThread.pas',
  WayBillList in 'WayBillList.pas' {WayBillListForm},
  U_FolderMacros in 'U_FolderMacros.pas',
  LU_Tracer in 'common\LU_Tracer.pas',
  LU_MutexSystem in 'common\LU_MutexSystem.pas',
  U_TINFIBInputDelimitedStream in 'U_TINFIBInputDelimitedStream.pas',
  inforoomapi in 'RC_RND\inforoomapi.pas',
  hlpcodecs in 'RC_RND\hlpcodecs.pas',
  incrt in 'RC_RND\incrt.pas',
  inforoomalg in 'RC_RND\inforoomalg.pas',
  LU_TSGHashTable in 'common\LU_TSGHashTable.pas',
  SevenZip in 'common\SevenZip.pas',
  SQLWaiting in 'SQLWaiting.pas' {frmSQLWaiting},
  infver in 'RC_RND\infver.pas',
  infvercls in 'RC_RND\infvercls.pas',
  NtlmMsgs in 'NTLM\NtlmMsgs.pas',
  DADAuthenticationNTLM in 'NTLM\DADAuthenticationNTLM.pas',
  Encryption in 'NTLM\Encryption.pas',
  SynonymSearch in 'SynonymSearch.pas' {SynonymSearchForm},
  U_UpdateDBThread in 'U_UpdateDBThread.pas',
  U_frmOldOrdersDelete in 'U_frmOldOrdersDelete.pas' {frmOldOrdersDelete},
  U_frmSendLetter in 'U_frmSendLetter.pas' {frmSendLetter},
  U_SXConversions in 'common\U_SXConversions.pas',
  U_SGXMLGeneral in 'common\U_SGXMLGeneral.pas',
  U_RecvThread in 'U_RecvThread.pas';

{$R *.RES}
{$R EraserDLL.RES}
{$R Progress.RES}
{$R Icons.RES}
{$R CompareScript41.RES}
{$R CompareScript42.RES}
{$R CompareScript43.RES}
{$R LastScript.RES}

var
  B : TWebBrowser;

  procedure CopyRegSettings;
  var
    R : TRegistry;
  begin
    R := TRegistry.Create;
    try
      R.RootKey := HKEY_CURRENT_USER;
      if R.KeyExists('Software\Inforoom\AnalitF\' + IntToHex(GetCopyID, 8)) and not R.KeyExists('Software\Inforoom\AnalitF\' + GetPathCopyID) then
      begin
        //TODO: ___ Должно работать всегда, но надо будет специально проверить на Win95, Win98, WinNT
        R.MoveKey('Software\Inforoom\AnalitF\' + IntToHex(GetCopyID, 8), 'Software\Inforoom\AnalitF\' + GetPathCopyID, False);
        //Если работаем на WinNT, то будем делать рекурсию
        //if (GetVersion() < $80000000) then
      end;
    finally
      R.Free;
    end;
  end;

begin
  try
    CoInitialize(nil);
    try
      B := TWebBrowser.Create(nil);
      B.Free;
    finally
      CoUninitialize;
    end;
  except
    LogExitError('Для запуска приложения необходим установленный Internet Explorer 4.0 или выше.', Integer(ecIE40));
  end;
  //Производим попытку скопировать настройки в реестре из старой копии программы 
  try
    CopyRegSettings;
  except
  end;
  Application.Initialize;
  Application.Title := 'АналитФАРМАЦИЯ';
  Application.HintHidePause := 10*60*1000;
  Application.CreateForm(TMainForm, MainForm);
  MainForm.FormPlacement.IniFileName := 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\';
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
