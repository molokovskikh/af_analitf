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
  ExchangeThread in 'ExchangeThread.pas',
  Retry in 'Retry.pas' {RetryForm},
  SOAPThroughHTTP in 'SOAPThroughHTTP.pas',
  Constant in 'Constant.pas',
  Compact in 'Compact.pas' {CompactForm},
  UniqueID in 'UniqueID.pas',
  CRC32Unit in 'CRC32Unit.pas',
  RecThread in 'RecThread.pas',
  NotOrders in 'NotOrders.pas' {NotOrdersForm},
  SysNames in 'SysNames.pas',
  AlphaUtils in 'AlphaUtils.pas',
  About in 'About.pas' {AboutForm},
  Waiting in 'Waiting.pas' {WaitingForm},
  CompactThread in 'CompactThread.pas',
  WayBillList in 'WayBillList.pas' {WayBillListForm},
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
  U_RecvThread in 'U_RecvThread.pas',
  U_GroupUtils in 'U_GroupUtils.pas',
  U_ExchangeLog in 'U_ExchangeLog.pas',
  U_DeleteDBThread in 'U_DeleteDBThread.pas',
  U_SendArchivedOrdersThread in 'U_SendArchivedOrdersThread.pas',
  U_frameLegend in 'U_frameLegend.pas' {frameLegeng: TFrame},
  HFileHelper in 'Helpers\HFileHelper.pas',
  ULoginHelper in 'Helpers\ULoginHelper.pas',
  U_VistaCorrectForm in 'U_VistaCorrectForm.pas' {VistaCorrectForm},
  PreviousOrders in 'PreviousOrders.pas' {PreviousOrdersForm},
  CorrectOrders in 'CorrectOrders.pas' {CorrectOrdersForm},
  INFHelpers in 'RC_RND\INFHelpers.pas',
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas',
  InforoomException in 'Exceptions\InforoomException.pas',
  DataIntegrityExceptions in 'Exceptions\DataIntegrityExceptions.pas',
  PostSomeOrdersController in 'BusinessLogic\PostSomeOrdersController.pas',
  ExchangeParameters in 'BusinessLogic\ExchangeParameters.pas',
  EhLibMTE in 'EhLibMT\EhLibMTE.pas',
  DatabaseObjects in 'DataLayer\DatabaseObjects.pas',
  CriticalDatabaseObjects in 'DataLayer\CriticalDatabaseObjects.pas',
  BackupDatabaseObjects in 'DataLayer\BackupDatabaseObjects.pas',
  DatabaseViews in 'DataLayer\DatabaseViews.pas',
  IgnoreDatabaseObjects in 'DataLayer\IgnoreDatabaseObjects.pas',
  SynonymDatabaseObjects in 'DataLayer\SynonymDatabaseObjects.pas',
  GeneralDatabaseObjects in 'DataLayer\GeneralDatabaseObjects.pas',
  U_framePosition in 'U_framePosition.pas' {framePosition: TFrame},
  MnnSearch in 'MnnSearch.pas' {MnnSearchForm},
  DescriptionFrm in 'DescriptionFrm.pas' {DescriptionForm},
  NetworkAdapterHelpers in 'Helpers\NetworkAdapterHelpers.pas',
  DocumentHeaders in 'DocumentHeaders.pas' {DocumentHeaderForm},
  DocumentBodies in 'DocumentBodies.pas' {DocumentBodiesForm},
  DocumentTypes in 'DataLayer\DocumentTypes.pas',
  sumprops in 'Helpers\sumprops.pas',
  EditVitallyImportantMarkups in 'EditVitallyImportantMarkups.pas' {EditVitallyImportantMarkupsForm},
  DBGridHelper in 'Helpers\DBGridHelper.pas',
  PostWaybillsController in 'BusinessLogic\PostWaybillsController.pas',
  U_frameEditVitallyImportantMarkups in 'U_frameEditVitallyImportantMarkups.pas' {frameEditVitallyImportantMarkups: TFrame},
  U_frameEditAddress in 'U_frameEditAddress.pas' {frameEditAddress: TFrame},
  EditAddressForm in 'EditAddressForm.pas' {EditAddressFrm};

{$R *.RES}
{$R EraserDLL.RES}
{$R Progress.RES}
{$R Icons.RES}
{$R CompareScript50.RES}
{$R CompareScript51.RES}
{$R CompareScript52.RES}
{$R CompareScript53.RES}
{$R CompareScript54.RES}
{$R CompareScript55.RES}
{$R CompareScript56.RES}
{$R CompareScript57.RES}
{$R CompareScript58.RES}
{$R CompareScript59.RES}
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
        //TODO: ___ ƒолжно работать всегда, но надо будет специально проверить на Win95, Win98, WinNT
        R.MoveKey('Software\Inforoom\AnalitF\' + IntToHex(GetCopyID, 8), 'Software\Inforoom\AnalitF\' + GetPathCopyID, False);
        //≈сли работаем на WinNT, то будем делать рекурсию
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
    LogExitError('ƒл€ запуска приложени€ необходим установленный Internet Explorer 4.0 или выше.', Integer(ecIE40));
  end;
  //ѕроизводим попытку скопировать настройки в реестре из старой копии программы 
  try
    CopyRegSettings;
  except
  end;
  Application.Initialize;
  //DSP - дл€ служебного пользовани€
{$ifdef DSP}
  Application.Title := 'јналит‘ј–ћј÷»я  ƒл€ служебного пользовани€';
{$else}
  Application.Title := 'јналит‘ј–ћј÷»я';
{$endif}
  Application.HintHidePause := 10*60*1000;
  Application.CreateForm(TMainForm, MainForm);
  MainForm.FormPlacement.IniFileName := 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\';
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
