program AnalitF;

{%ToDo 'AnalitF.todo'}

uses
  VCLFixPack in 'Helpers\VCLFixPack.pas',
  Forms,
  SysUtils,
  Windows,
  ActiveX,
  Registry,
  SHDocVw,
  LU_MutexSystem in '..\Common\System\LU_MutexSystem.pas',
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
  SysNames in '..\Common\System\SysNames.pas',
  AlphaUtils in 'AlphaUtils.pas',
  About in 'About.pas' {AboutForm},
  Waiting in 'Waiting.pas' {WaitingForm},
  CompactThread in 'CompactThread.pas',
  WayBillList in 'WayBillList.pas' {WayBillListForm},
  LU_Tracer in '..\Common\Classes\LU_Tracer.pas',
  inforoomapi in 'RC_RND\inforoomapi.pas',
  hlpcodecs in 'RC_RND\hlpcodecs.pas',
  incrt in 'RC_RND\incrt.pas',
  inforoomalg in 'RC_RND\inforoomalg.pas',
  SevenZip in '..\Common\Utils\SevenZip.pas',
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
  U_SXConversions in '..\Common\XMLParser\U_SXConversions.pas',
  U_SGXMLGeneral in '..\Common\XMLParser\U_SGXMLGeneral.pas',
  U_RecvThread in 'U_RecvThread.pas',
  U_GroupUtils in 'U_GroupUtils.pas',
  U_ExchangeLog in 'U_ExchangeLog.pas',
  U_DeleteDBThread in 'U_DeleteDBThread.pas',
  U_SendArchivedOrdersThread in 'U_SendArchivedOrdersThread.pas',
  U_frameLegend in 'U_frameLegend.pas' {frameLegend: TFrame},
  HFileHelper in 'Helpers\HFileHelper.pas',
  ULoginHelper in 'Helpers\ULoginHelper.pas',
  U_VistaCorrectForm in 'U_VistaCorrectForm.pas' {VistaCorrectForm},
  PreviousOrders in 'PreviousOrders.pas' {PreviousOrdersForm},
  CorrectOrders in 'CorrectOrders.pas' {CorrectOrdersForm},
  INFHelpers in 'RC_RND\INFHelpers.pas',
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas',
  InforoomException in '..\Common\Exceptions\InforoomException.pas',
  DataIntegrityExceptions in '..\Common\Exceptions\DataIntegrityExceptions.pas',
  PostSomeOrdersController in 'BusinessLogic\PostSomeOrdersController.pas',
  ExchangeParameters in 'BusinessLogic\ExchangeParameters.pas',
  EhLibMTE in 'EhLibMT\EhLibMTE.pas',
  DatabaseObjects in '..\Common\DataLayer\DatabaseObjects.pas',
  CriticalDatabaseObjects in '..\Common\DataLayer\CriticalDatabaseObjects.pas',
  BackupDatabaseObjects in '..\Common\DataLayer\BackupDatabaseObjects.pas',
  DatabaseViews in '..\Common\DataLayer\DatabaseViews.pas',
  IgnoreDatabaseObjects in '..\Common\DataLayer\IgnoreDatabaseObjects.pas',
  SynonymDatabaseObjects in '..\Common\DataLayer\SynonymDatabaseObjects.pas',
  GeneralDatabaseObjects in '..\Common\DataLayer\GeneralDatabaseObjects.pas',
  U_framePosition in 'U_framePosition.pas' {framePosition: TFrame},
  MnnSearch in 'MnnSearch.pas' {MnnSearchForm},
  DescriptionFrm in 'DescriptionFrm.pas' {DescriptionForm},
  NetworkAdapterHelpers in 'Helpers\NetworkAdapterHelpers.pas',
  DocumentHeaders in 'DocumentHeaders.pas' {DocumentHeaderForm},
  DocumentBodies in 'DocumentBodies.pas' {DocumentBodiesForm},
  DocumentTypes in '..\Common\DataLayer\DocumentTypes.pas',
  sumprops in 'Helpers\sumprops.pas',
  EditVitallyImportantMarkups in 'EditVitallyImportantMarkups.pas' {EditVitallyImportantMarkupsForm},
  DBGridHelper in 'Helpers\DBGridHelper.pas',
  PostWaybillsController in 'BusinessLogic\PostWaybillsController.pas',
  U_frameEditVitallyImportantMarkups in 'U_frameEditVitallyImportantMarkups.pas' {frameEditVitallyImportantMarkups: TFrame},
  U_frameEditAddress in 'U_frameEditAddress.pas' {frameEditAddress: TFrame},
  EditAddressForm in 'EditAddressForm.pas' {EditAddressFrm},
  RegistryHelper in 'Helpers\RegistryHelper.pas',
  U_OrderBatchForm in 'U_OrderBatchForm.pas' {OrderBatchForm},
  ArchiveHelper in '..\Common\Helpers\ArchiveHelper.pas',
  U_frameBaseLegend in 'U_frameBaseLegend.pas' {frameBaseLegend: TFrame},
  U_frameOrderHeadLegend in 'U_frameOrderHeadLegend.pas' {frameOrderHeadLegend: TFrame},
  StartupHelper in 'Helpers\StartupHelper.pas',
  SendWaybillTypes in 'BusinessLogic\SendWaybillTypes.pas',
  GlobalExchangeParameters in 'BusinessLogic\GlobalExchangeParameters.pas',
  GlobalParams in '..\Common\GlobalParams\GlobalParams.pas',
  TicketReportParams in '..\Common\GlobalParams\TicketReportParams.pas',
  EditTicketReportParams in 'EditTicketReportParams.pas' {EditTicketReportParamsForm},
  NetworkSettings in '..\Common\GlobalParams\NetworkSettings.pas',
  ExclusiveParams in '..\Common\GlobalParams\ExclusiveParams.pas',
  Exclusive in 'Exclusive.pas' {ExclusiveForm},
  Wait in 'Wait.pas' {WaitForm},
  U_MinPricesForm in 'U_MinPricesForm.pas' {MinPricesForm},
  DataSetHelper in '..\Common\Helpers\DataSetHelper.pas',
  NetworkParams in '..\Common\GlobalParams\NetworkParams.pas',
  U_ServiceLogForm in 'U_ServiceLogForm.pas' {ServiceLogForm},
  U_frameServiceLogLegend in 'U_frameServiceLogLegend.pas' {frameServiceLogLegend: TFrame},
  U_Address in '..\Common\Models\U_Address.pas',
  U_CurrentOrderHead in '..\Common\Models\U_CurrentOrderHead.pas',
  U_CurrentOrderItem in '..\Common\Models\U_CurrentOrderItem.pas',
  U_DBMapping in '..\Common\Models\U_DBMapping.pas',
  U_Offer in '..\Common\Models\U_Offer.pas',
  AllOrdersParams in '..\Common\GlobalParams\AllOrdersParams.pas',
  AddressController in 'BusinessLogic\AddressController.pas',
  U_frameFilterAddresses in 'Views\U_frameFilterAddresses.pas' {frameFilterAddresses: TFrame},
  KeyboardHelper in '..\Common\Helpers\KeyboardHelper.pas',
  UserMessageParams in '..\Common\GlobalParams\UserMessageParams.pas',
  RackCardReportParams in '..\Common\GlobalParams\RackCardReportParams.pas',
  EditRackCardReportParams in 'EditRackCardReportParams.pas' {EditRackCardReportParamsForm},
  LU_TDataExportAsXls in '..\Common\Classes\LU_TDataExportAsXls.pas',
  U_Supplier in '..\Common\Models\U_Supplier.pas',
  SupplierController in 'BusinessLogic\SupplierController.pas',
  U_frameFilterSuppliers in 'Views\U_frameFilterSuppliers.pas' {frameFilterSuppliers: TFrame},
  U_frameContextReclame in 'Views\U_frameContextReclame.pas' {frameContextReclame: TFrame},
  GlobalSettingParams in '..\Common\GlobalParams\GlobalSettingParams.pas',
  MyEmbConnectionEx in '..\Common\DataLayer\MyEmbConnectionEx.pas',
  U_ShowPromotionsForm in 'U_ShowPromotionsForm.pas' {ShowPromotionsForm},
  PromotionLabel in 'Helpers\PromotionLabel.pas',
  U_SupplierPromotion in '..\Common\Models\U_SupplierPromotion.pas',
  VCLHelper in 'Helpers\VCLHelper.pas',
  U_framePromotion in 'Views\U_framePromotion.pas' {framePromotion: TFrame},
  U_frameBlockPromotion in 'Views\U_frameBlockPromotion.pas' {frameBlockPromotion: TFrame};

{$R *.RES}
{$R EraserDLL.RES}
{$R Progress.RES}
{$R Icons.RES}
{$R Bitmaps.RES}
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
{$R CompareScript60.RES}
{$R CompareScript62.RES}
{$R CompareScript63.RES}
{$R CompareScript64.RES}
{$R CompareScript65.RES}
{$R CompareScript66.RES}
{$R CompareScript67.RES}
{$R CompareScript68.RES}
{$R CompareScript69.RES}
{$R CompareScript70.RES}
{$R CompareScript71.RES}
{$R CompareScript72.RES}
{$R CompareScript73.RES}
{$R CompareScript74.RES}

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
  //DSP - для служебного пользования
{$ifdef DSP}
  Application.Title := 'АналитФАРМАЦИЯ  Для служебного пользования';
{$else}
  Application.Title := 'АналитФАРМАЦИЯ';
{$endif}
  Application.HintHidePause := 10*60*1000;
  mainStartupHelper.Write('AnalitF', 'Начали создание MainForm');
  Application.CreateForm(TMainForm, MainForm);
  mainStartupHelper.Write('AnalitF', 'Закончили создание MainForm');
  MainForm.FormPlacement.IniFileName := 'Software\Inforoom\AnalitF\' + GetPathCopyID + '\';
  mainStartupHelper.Write('AnalitF', 'Начали создание MainForm');
  Application.CreateForm(TDM, DM);
  mainStartupHelper.Write('AnalitF', 'Закончили создание DModule');
  Application.Run;
end.
