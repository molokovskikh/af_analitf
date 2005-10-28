unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, IB_Services,
  FIBQuery, pFIBQuery, FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase,
  frRtfExp, frexpimg, FR_E_HTML2, FR_E_TXT, FR_Rich,
  CompactThread, FIB, IB_ErrorCodes, Math, IdIcmpClient, FIBMiscellaneous, VCLUnZip,
  U_TINFIBInputDelimitedStream, incrt, hlpcodecs, StrUtils, RxMemDS,
  Contnrs, U_CryptIndex;

{
�����������
  �������� - ��� � ����� ��� %
  ����     - ��� � ����� ��� %
  Code, CodeCr - ��������� ���

}

const
  HistoryMaxRec=5;
  //����. ���-�� ����� ����������� � �������
  RegisterId=59; //��� ������� � ����������� ����

//Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=AnalitF.mdb;Persist Security Info=False;Jet OLEDB:Registry Path="";Jet OLEDB:Database Password=commonpas;Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Don't Copy Locale on Compact=False;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False

type
  //������ ���������� ������� � ���� �� ������� ����������
  //pdmPrev - �� ����������� ����������, pdmMin - �� ���������� � min �����,
  //pdmMinEnabled - �� ������.����. � min �����
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  //exit codes - ���� ������ ������ �� ���������
  TAnalitFExitCode = (ecOK, ecDBFileNotExists, ecDBFileReadOnly, ecDBFileError,
    ecDoubleStart, ecColor, ecTCPNotExists, ecUserLimit, ecFreeDiskSpace,
    ecGetFreeDiskSpace, ecIE40);

  TRetMass = array[1..3] of Variant;

  TDM = class(TDataModule)
    frReport: TfrReport;
    dsParams: TDataSource;
    dsAnalit: TDataSource;
    dsClients: TDataSource;
    dsTablesUpdates: TDataSource;
    Ras: TARas;
    frRichObject: TfrRichObject;
    frCheckBoxObject: TfrCheckBoxObject;
    frShapeObject: TfrShapeObject;
    frChartObject: TfrChartObject;
    frRoundRectObject: TfrRoundRectObject;
    frTextExport: TfrTextExport;
    frDialogControls: TfrDialogControls;
    frHTML2Export: TfrHTML2Export;
    frBMPExport: TfrBMPExport;
    frJPEGExport: TfrJPEGExport;
    frTIFFExport: TfrTIFFExport;
    frRtfAdvExport: TfrRtfAdvExport;
    dsReclame: TDataSource;
    MainConnection1: TpFIBDatabase;
    DefTran: TpFIBTransaction;
    adtParams: TpFIBDataSet;
    adtProvider: TpFIBDataSet;
    adtReclame: TpFIBDataSet;
    adtClients: TpFIBDataSet;
    adtTablesUpdates: TpFIBDataSet;
    adtFlags: TpFIBDataSet;
    adcUpdate: TpFIBQuery;
    adsSelect: TpFIBDataSet;
    adsSelect2: TpFIBDataSet;
    adsSelect3: TpFIBDataSet;
    adsCore: TpFIBDataSet;
    adsOrdersH: TpFIBDataSet;
    adsOrders: TpFIBDataSet;
    BackService: TpFIBBackupService;
    RestService: TpFIBRestoreService;
    ConfigService: TpFIBConfigService;
    ValidService: TpFIBValidationService;
    adtClientsCLIENTID: TFIBBCDField;
    adtClientsNAME: TFIBStringField;
    adtClientsREGIONCODE: TFIBBCDField;
    adtClientsADDRESS: TFIBStringField;
    adtClientsPHONE: TFIBStringField;
    adtClientsFORCOUNT: TFIBIntegerField;
    adtClientsEMAIL: TFIBStringField;
    adtClientsMAXUSERS: TFIBIntegerField;
    adtClientsUSEEXCESS: TFIBBooleanField;
    adtClientsEXCESS: TFIBIntegerField;
    adtClientsDELTAMODE: TFIBSmallIntField;
    adtClientsONLYLEADERS: TFIBBooleanField;
    adtClientsREQMASK: TFIBBCDField;
    adtClientsTECHSUPPORT: TFIBStringField;
    adtClientsLEADFROMBASIC: TFIBSmallIntField;
    t: TpFIBQuery;
    UpTran: TpFIBTransaction;
    adsSelect3ID: TFIBBCDField;
    adsSelect3COREID: TFIBBCDField;
    adsSelect3PRICECODE: TFIBBCDField;
    adsSelect3REGIONCODE: TFIBBCDField;
    adsSelect3CODE: TFIBStringField;
    adsSelect3CODECR: TFIBStringField;
    adsSelect3PRICE: TFIBStringField;
    adsSelect3SYNONYMCODE: TFIBBCDField;
    adsSelect3SYNONYMFIRMCRCODE: TFIBBCDField;
    adsSelect3SYNONYMNAME: TFIBStringField;
    adsSelect3SYNONYMFIRM: TFIBStringField;
    adsSelect3JUNK: TFIBBooleanField;
    adsSelect3AWAIT: TFIBBooleanField;
    adsSelect3ORDERCOUNT: TFIBIntegerField;
    adsSelect3PRICENAME: TFIBStringField;
    adsSelect3CryptSYNONYMNAME: TStringField;
    adsSelect3CryptSYNONYMFIRM: TStringField;
    adsSelect3CryptCODE: TStringField;
    adsSelect3CryptCODECR: TStringField;
    adsSelect3CryptPRICE: TCurrencyField;
    adsCoreCOREID: TFIBBCDField;
    adsCoreFULLCODE: TFIBBCDField;
    adsCoreSHORTCODE: TFIBBCDField;
    adsCoreCODEFIRMCR: TFIBBCDField;
    adsCoreSYNONYMCODE: TFIBBCDField;
    adsCoreSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreCODE: TFIBStringField;
    adsCoreCODECR: TFIBStringField;
    adsCoreVOLUME: TFIBStringField;
    adsCoreDOC: TFIBStringField;
    adsCoreNOTE: TFIBStringField;
    adsCorePERIOD: TFIBStringField;
    adsCoreAWAIT: TFIBIntegerField;
    adsCoreJUNK: TFIBIntegerField;
    adsCoreBASECOST: TFIBStringField;
    adsCoreQUANTITY: TFIBStringField;
    adsCoreSYNONYMNAME: TFIBStringField;
    adsCoreSYNONYMFIRM: TFIBStringField;
    adsCoreMINPRICE: TFIBBCDField;
    adsCoreLEADERPRICECODE: TFIBBCDField;
    adsCoreLEADERREGIONCODE: TFIBBCDField;
    adsCoreLEADERREGIONNAME: TFIBStringField;
    adsCoreLEADERPRICENAME: TFIBStringField;
    adsCoreORDERSCOREID: TFIBBCDField;
    adsCoreORDERSORDERID: TFIBBCDField;
    adsCoreORDERSCLIENTID: TFIBBCDField;
    adsCoreORDERSFULLCODE: TFIBBCDField;
    adsCoreORDERSCODEFIRMCR: TFIBBCDField;
    adsCoreORDERSSYNONYMCODE: TFIBBCDField;
    adsCoreORDERSSYNONYMFIRMCRCODE: TFIBBCDField;
    adsCoreORDERSCODE: TFIBStringField;
    adsCoreORDERSCODECR: TFIBStringField;
    adsCoreORDERCOUNT: TFIBIntegerField;
    adsCoreORDERSSYNONYM: TFIBStringField;
    adsCoreORDERSSYNONYMFIRM: TFIBStringField;
    adsCoreORDERSPRICE: TFIBStringField;
    adsCoreORDERSJUNK: TFIBIntegerField;
    adsCoreORDERSAWAIT: TFIBIntegerField;
    adsCoreORDERSHORDERID: TFIBBCDField;
    adsCoreORDERSHCLIENTID: TFIBBCDField;
    adsCoreORDERSHPRICECODE: TFIBBCDField;
    adsCoreORDERSHREGIONCODE: TFIBBCDField;
    adsCoreORDERSHPRICENAME: TFIBStringField;
    adsCoreORDERSHREGIONNAME: TFIBStringField;
    adsRetailMargins: TpFIBDataSet;
    adsRetailMarginsID: TFIBBCDField;
    adsRetailMarginsLEFTLIMIT: TFIBBCDField;
    adsRetailMarginsRIGHTLIMIT: TFIBBCDField;
    adsRetailMarginsRETAIL: TFIBIntegerField;
    dsRetailMargins: TDataSource;
    adsSumOrders: TpFIBDataSet;
    adsSumOrdersCODE: TFIBStringField;
    adsSumOrdersCODECR: TFIBStringField;
    adsSumOrdersPRICE: TFIBStringField;
    adsSumOrdersORDERCOUNT: TFIBIntegerField;
    adsSumOrdersCryptPRICE: TCurrencyField;
    adsSumOrdersSumOrders: TCurrencyField;
    procedure DMCreate(Sender: TObject);
    procedure adtClientsAfterInsert(DataSet: TDataSet);
    procedure adtParamsAfterOpen(DataSet: TDataSet);
    procedure adtClientsAfterOpen(DataSet: TDataSet);
    procedure adtClientsAfterPost(DataSet: TDataSet);
    procedure adtClientsBeforeDelete(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MainConnection1AfterConnect(Sender: TObject);
    procedure adsSelect3CalcFields(DataSet: TDataSet);
    procedure adsRetailMarginsLEFTLIMITChange(Sender: TField);
    procedure adsSumOrdersCalcFields(DataSet: TDataSet);
  private
    ClientInserted: Boolean;
    //��������� �� ������������� ������
    FNeedCommitExchange : Boolean;
    SynonymPassword,
    CodesPassword,
    BaseCostPassword : String;
    FRetMargins : array of TRetMass;
    procedure CheckRestrictToRun;
    procedure ReadPasswords;
  public
    FFS : TFormatSettings;
    function DatabaseOpenedBy: string;
    function DatabaseOpenedList( var ExclusiveID, ComputerName: string): TStringList;
    procedure CompactDataBase(NewPassword: string='');
    procedure ClearPassword( ADatasource: string);
    procedure OpenDatabase( ADatasource: string);
    procedure ShowFastReport(FileName: string; DataSet: TDataSet = nil;
  APreview: boolean = False; PrintDlg: boolean = True);
    procedure ClientChanged;
    function GetTablesUpdatesInfo(ParamTableName: string): string;
    procedure LinkExternalTables;
    procedure LinkExternalMDB( ATablesList: TStringList);
    procedure UnLinkExternalTables;
    procedure ClearDatabase;
    function GetCurrentOrderId(ClientId, PriceCode, RegionCode: Integer;
      CreateIfNotExists: Boolean=True): Integer;
    procedure DeleteEmptyOrders;
    procedure SetImportStage( AValue: integer);
    function GetImportStage: integer;
    procedure BackupDatabase( APath: string);
    procedure RestoreDatabase( APath: string);
    function IsBackuped( APath: string): boolean;
    procedure ClearBackup( APath: string);
    function Unpacked: boolean;
    procedure SetExclusive;
    procedure ResetExclusive;
    procedure SetCumulative;
    procedure ResetCumulative;
    function GetCumulative: boolean;
    procedure SetStarted;
    procedure ResetStarted;
    function GetStarted: Boolean;
    //��� ��������� �������, ����� ��� ����� ��������
    procedure VersionValid;
    {function OrderToArchiv(ClientId: Integer=0; PriceCode: Integer=0;
      RegionCode: Integer=0): Boolean;}
    procedure SweepDB;
    procedure SetSweepInterval;
    function GetDisplayColors : Integer;
    function TCPPresent : Boolean;
    function NeedCommitExchange : Boolean;
    procedure SetNeedCommitExchange;
    procedure ResetNeedCommitExchange;
{
}    
    //DecodeCryptS
    function D_C_S(Pass, S : String) : String;
    //CodeCryptS
    function C_C_S(Pass, S : String) : String;
    //DecodeSynonym
    function D_S(CodeS : String) : String;
    //DecodeCode
    function D_C(CodeS : String) : String;
    //DecodeBasecost
    function D_B(CodeS1, CodeS2 : String) : String;
    procedure SavePass(ASyn, ACodes, AB : String);
    procedure LoadRetailMargins;
    function GetPriceRet(BaseCost : Currency) : Currency;
  end;

var
  DM: TDM;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID, RxVerInf,
     U_FolderMacros, LU_Tracer, LU_MutexSystem;

procedure TDM.DMCreate(Sender: TObject);
var
  LDBFileName : String;
  DBCompress : Boolean;
begin
  ResetNeedCommitExchange;
  GetLocaleFormatSettings(0, FFS);
  //�������� ������
//  VersionValid;

{
  MainConnection.ConnectionString :=
    SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
      ExePath + DatabaseName);
}

  MainConnection1.DBName := ExePath + DatabaseName;
//  MainConnection1.LibraryName := 'gds32.dll';

  if not FileExists(ExePath + DatabaseName) then begin
    MessageBox( Format( '���� ���� ������ %s �� ����������.', [ ExePath + DatabaseName ]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDBFileNotExists) );
  end;

  if ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then begin
    MessageBox( Format( '���� ���� ������ %s ����� ������� "������ ������".', [ ExePath + DatabaseName ]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDBFileReadOnly) );
  end;

  LDBFileName := ChangeFileExt(ExeName, '.ldb');
  DBCompress := FileExists(LDBFileName) and DeleteFile(LDBFileName);

  try
    try
      CheckRestrictToRun;
    finally
      MainConnection1.Close;
    end;
  except
    on E : Exception do begin
      MessageBox( Format( '�� �������� ������� ���� ���� ������ : %s ', [ E.Message ]),
        MB_ICONERROR or MB_OK);
      ExitProcess( Integer(ecDBFileError) );
    end;
  end;

  MainConnection1.Open;
  { ������������� ������� ������ � Clients � Users }
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
    then adtClients.First;
  //���������, ��� ������ � ���������� ���� ��������� ���������
  if DBCompress then
  begin
    MessageBox(
      '��������� ����� ������ � ���������� �� ��� ��������� ��������. '+
        '������ ����� ����������� ������ ���� ������.');
    MainForm.FreeChildForms;
    RunCompactDataBase;
    MessageBox( '������ ���� ������ ���������.');
  end;
  SetStarted;
  //MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
  ClientChanged;
  { ������������� ��������� ������ }
  frReport.Title := Application.Title;
  { ��������� � ���� ���� ������� ������ �������� }
  if not DirectoryExists( ExePath + SDirDocs) then CreateDir( ExePath + SDirDocs);
  if not DirectoryExists( ExePath + SDirExports) then CreateDir( ExePath + SDirExports);
  if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
  if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
  MainForm.SetUpdateDateTime;
  Application.HintPause := 0;

  DeleteFilesByMask(ExePath + SDirIn + '\*.zip', False);
  DeleteFilesByMask(ExePath + SDirIn + '\*.zi_', False);

  { ������ � ������ -e (��������� ������ � �����)}
  if ( AnsiLowerCase( ParamStr( 1)) = '-e') or
    ( AnsiLowerCase( ParamStr( 1)) = '/e') then
  begin
    MainForm.ExchangeOnly := True;
    RunExchange([ eaGetPrice]);
    Application.Terminate;
  end;
  if adtParams.FieldByName('HTTPNameChanged').AsBoolean then
    MainForm.DisableByHTTPName;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if not MainConnection1.Connected then exit;

  try
    adtParams.Edit;
    adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
    adtParams.Post;
  except
  end;
  ResetStarted;
end;

procedure TDM.ClientChanged;
begin
  MainForm.FreeChildForms;
  MainForm.dblcbClients.KeyValue := adtClients.FieldByName( 'ClientId').Value;
  MainForm.SetOrdersInfo;
end;

{ �������� �� ������������� ������� ��������� }
procedure TDM.CheckRestrictToRun;
var
  list: TStringList;
//  ExID, CompName: string;
  MaxUsers: integer;
  FreeAvail,
  Total,
  TotalFree,
  DBFileSize : Int64;
  DBErrorMess : String;
  N : Integer;
  OldDBFileName,
  ErrFileName : String;
begin
{
  DM.MainConnection.Open;
  MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
  list := DM.DatabaseOpenedList( ExID, CompName);
  DM.MainConnection.Close;

  if list.Count > 1 then
  begin
    if ( ExID = IntToHex( GetUniqueID( Application.ExeName,
      ''), 8)) or ( ExID = '') then exit;

    MessageBox( Format( '����� ��������� �� ���������� %s �������� � ������ ' + #10 + #13 +
      '������������ ������ � ���� ������. ������ ��������� ����������.', [ CompName]),
      MB_ICONWARNING or MB_OK);
    ExitProcess(3);
  end;
}
  if not IsOneStart then begin
    MessageBox( '������ ���� ����� ��������� �� ����� ���������� ����������.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecDoubleStart) );
  end;

  if GetDisplayColors < 16 then begin
    MessageBox( '�� �������� ������ ��������� � ������� ��������� �������������. ����������� �������� ������������� : 16 ���.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecColor) );
  end;

  if not TCPPresent then begin
    MessageBox( '�� �������� ������ ��������� ��� ������������� ���������� Windows Sockets ������ 2.0.',
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecTCPNotExists) );
  end;

  try
    DM.MainConnection1.Open;
  except
    on E : EFIBError do begin
      if E.IBErrorCode = isc_network_error then
        raise Exception.Create('�� �������� ������ ��������� � �������� �����. ����������, ����������� ��������� ����.')
      else begin
        {
        ����� �� ������ �������:
        1. ������� ����������, ���� �������
        2. ��������� ��� ������ ��� ��������
        3. ������������� � ��������� ���� ������
        4. ����������� �� ��������� ���� ������
        5. ������� ��������� ���� ������
        }
        DBErrorMess := Format('�� ������� ������� ���� ������ ���������.'#13#10 +
          '��� SQL       : %d'#13#10 +
          '��������� SQL : %s'#13#10 +
          '��� IB        : %d'#13#10 +
          '��������� IB  : %s',
          [E.SQLCode, E.SQLMessage, E.IBErrorCode, E.IBMessage]
        );
        //����� ���� ������������ �� ������� ����������� ��������������?
        if MessageBox(DBErrorMess + #13#10#13#10 + '���������� �������������� �� ��������� �����?', MB_ICONERROR or MB_YESNO or MB_DEFBUTTON2) = IDYES then
        begin
          //�������� �������� � �����-�� ������� � ���� ���� ������ ���������, ������� ��������� ��.
          if DM.MainConnection1.Connected then
            try
              DM.MainConnection1.Close;
            except
            end;

          //��������� ��� ���������� �����
          ErrFileName := ChangeFileExt(ParamStr(0), '.e');
          N := 0;
          while (FileExists(ErrFileName + IntToHex(N, 2)) and (N <= 255)) do Inc(N);

          if N > 255 then
            //������� ����� ��������� ������
            raise Exception.Create('������� ������ ��������� ����� ���� ������.')
          else begin
            ErrFileName := ErrFileName + IntToHex(N, 2);
            OldDBFileName := ChangeFileExt(ParamStr(0), '.fdb');

            if not Windows.MoveFile(PChar(OldDBFileName), PChar(ErrFileName)) then
              raise Exception.CreateFmt('�� ������� ������������� � ��������� ���� %s : %s',
                [ErrFileName, SysErrorMessage(GetLastError)]);

            if not Windows.CopyFile(PChar(OldDBFileName + '.etl'), PChar(OldDBFileName), True) then
              raise Exception.CreateFmt('�� ������� ����������� �� ��������� ����� : %s',
                [SysErrorMessage(GetLastError)]);
                
            try
              MainConnection1.Open;
            except
              on E : Exception do
                raise Exception.CreateFmt('�� ������� ������������ ���� ������ �� ��������� �����. '#13#10 +
                  '��������� �� ������ : %s'#13#10 + '����������, ���������� � ������ ���������.',
                  [E.Message]);
            end;
          end;
        end
        else
          raise Exception.Create(DBErrorMess + #13#10#13#10 +
            '����������, ��������� �������� �������� ����� �� ������� ������.');
      end;
    end;
  end;
  try
    MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
    list := DM.MainConnection1.UserNames;
  finally
    DM.MainConnection1.Close;
  end;
  if ( MaxUsers > 0) and ( list.Count > MaxUsers) then
  begin
    MessageBox( Format( '�������� ����� �� ����������� � ���� ������ (����� : %d). ' +
      '������ ��������� ����������.', [ MaxUsers]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecUserLimit) );
  end;

  if GetDiskFreeSpaceEx(PChar(ExtractFilePath(ParamStr(0))), FreeAvail, Total, @TotalFree) then begin
    DBFileSize := GetFileSize(MainConnection1.DBName);
    DBFileSize := Max(2*DBFileSize, 200*1024*1024);
    if DBFileSize > FreeAvail then begin
      MessageBox( Format( '������������ ���������� ����� �� ����� ��� ������� ����������. ���������� %d ����.', [ DBFileSize ]),
        MB_ICONERROR or MB_OK);
      ExitProcess( Integer(ecFreeDiskSpace) );
    end;
  end
  else begin
    MessageBox( Format( '�� ������� �������� ���������� ���������� ����� �� �����.' +
      #13#10#13#10'��������� �� ������:'#13#10'%s', [ SysErrorMessage(GetLastError) ]),
      MB_ICONERROR or MB_OK);
    ExitProcess( Integer(ecGetFreeDiskSpace) );
  end;
  //������������� �������� ��� ����� ������
  SetSweepInterval;
end;

function TDM.DatabaseOpenedBy: string;
var
  WasConnected: boolean;
begin
  result := '';
{
  WasConnected := MainConnection.Connected;
  MainConnection.OpenSchema( siProviderSpecific, EmptyParam,
    JET_SCHEMA_USERROSTER, adsSelect);
  if adsSelect.RecordCount > 1 then
    result := adsSelect.FieldByName( 'COMPUTER_NAME').AsString;
  adsSelect.Close;
  if not WasConnected then MainConnection.Close;
}  
end;

function TDM.DatabaseOpenedList( var ExclusiveID, ComputerName: string): TStringList;
var
  WasConnected: boolean;
begin
  result := TStringList.Create;
{
  WasConnected := MainConnection.Connected;
  MainConnection.OpenSchema( siProviderSpecific, EmptyParam,
    JET_SCHEMA_USERROSTER, adsSelect);
  while not adsSelect.Eof do
  begin
    result.Add( adsSelect.FieldByName( 'COMPUTER_NAME').AsString);
    adsSelect.Next;
  end;
  MainForm.CS.Enter;
  try
    ExclusiveID := DM.adtFlags.FieldByName( 'ExclusiveID').AsString;
    ComputerName := DM.adtFlags.FieldByName( 'ComputerName').AsString;
  except
    ExclusiveID := '';
    ComputerName := '';
  end;
  MainForm.CS.Leave;
  adsSelect.Close;
  if not WasConnected then MainConnection.Close;
}  
end;

procedure TDM.CompactDataBase(NewPassword: string='');
var
  JetEngine: OleVariant;
  TempName: string;
  ok: boolean;
  FBR : TpFIBBackupRestoreService;
begin
  ok := False;
  //TODO: ��������� �� �� ����� ������. ������������ ������ ��� ��� ����������� �����������
  Tracer.TR('BackupRestore', 'Start');
  MainConnection1.Close;
  try
    try
      with ConfigService do
      begin
        ServerName := '';
        DatabaseName := MainConnection1.DBName;
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Tracer.TR('BackupRestore', 'Try shutdown database');
          ShutdownDatabase(Forced, 0);
          Tracer.TR('BackupRestore', 'Shutdown complete');
        finally
          Active := False;
        end;
      end;
      with BackService do
      begin
        ServerName := '';
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Verbose := True;
          DatabaseName := MainConnection1.DBName;
          BackupFile.Clear;
          BackupFile.Add(ChangeFileExt(MainConnection1.DBName, '.gbk'));

          ServiceStart;
          While not Eof do
            Tracer.TR('Backup', GetNextLine);
        finally
          Active := False;
        end;
      end;
      with RestService do
      begin
        ServerName := '';
        Params.Clear;
        Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
        Params.Add('password=' + MainConnection1.ConnectParams.Password);
        Active := True;
        try
          Verbose := True;
          DatabaseName.Clear;
          DatabaseName.Add(MainConnection1.DBName);
          BackupFile.Clear;
          BackupFile.Add(ChangeFileExt(MainConnection1.DBName, '.gbk'));
          ServiceStart;
          While not Eof do
            Tracer.TR('Restore', GetNextLine);
        finally
          Active := False;
        end;
      end;
      ok := True;
    except
      on E : Exception do
        Tracer.TR('BackupRestore', 'Error : ' + E.Message);
    end;
  finally
    Tracer.TR('BackupRestore', 'Stop');
    MainConnection1.Open;
  end;
  if ok then
  begin
    adtParams.Edit;
    adtParams.FieldByName( 'LastCompact').AsDateTime := Now;
    adtParams.Post;
  end;
{
  NewPassword:=Trim(NewPassword);
  if NewPassword='' then NewPassword:=GetConnectionProperty(
    MainConnection.ConnectionString,'Jet OLEDB:Database Password');
  TempName:=GetTempDir+'New.mdb';
  if FileExists(TempName) then AProc.DeleteFileA(TempName,True);
  MainConnection.Close;
  Screen.Cursor:=crHourglass;
  MainForm.StatusText:='������ � �������������� ���� ������';
  try
    JetEngine:=CreateOleObject('JRO.JetEngine');
    try
      JetEngine.CompactDatabase(MainConnection.ConnectionString,
        Format('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Database Password=%s',
        [TempName,NewPassword]));
      MainConnection.ConnectionString:=SetConnectionProperty(MainConnection.ConnectionString,
        'Jet OLEDB:Database Password',NewPassword);
      ok := True;
    finally
      JetEngine:=Unassigned;
    end;
    Aproc.MoveFileA(TempName,GetConnectionProperty(MainConnection.ConnectionString,
      'Data Source'),True,True);
  finally
    MainConnection.Open;
    Screen.Cursor:=crDefault;
    MainForm.StatusText:='';
  if ok then
  begin
    adtParams.Edit;
    adtParams.FieldByName( 'LastCompact').AsDateTime := Now;
    adtParams.Post;
  end;
  end;
}  
end;

procedure TDM.ClearPassword( ADatasource: string);
begin
{
  if MainConnection.Connected then MainConnection.Close;
  MainConnection.Mode := cmShareExclusive;
  MainConnection.ConnectionString := SetConnectionProperty(
    MainConnection.ConnectionString, 'Data Source', ADataSource);
  MainConnection.Open;
  adcUpdate.CommandText := 'ALTER DATABASE PASSWORD NULL ' +
    GetConnectionProperty( MainConnection.ConnectionString,
    'Jet OLEDB:Database Password');
  try
    adcUpdate.Execute;
  except
  end;
  MainConnection.Close;
  MainConnection.Mode := cmReadWrite;
}  
end;

procedure TDM.OpenDatabase( ADatasource: string);
begin
  if MainConnection1.Connected then MainConnection1.Close;
{
  MainConnection.ConnectionString :=
    SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
      ADatasource);
}
  MainConnection1.Open;
end;

//��������� ����� � ������� �� ����� ��� ��������; ���� ������ DataSet, ��
//����������� ���������� ����������� �� ���� � ���������� ������� �� ��������� ������
procedure TDM.ShowFastReport(FileName: string; DataSet: TDataSet = nil;
  APreview: boolean = False; PrintDlg: boolean = True);
var
  Mark: TBookmarkStr;
begin
  //������� � ��������� ������ ��� �����; ��������� ����
  FileName:=Trim(FileName);
  if FileName<>'' then begin
    FileName:=ExePath+FileName;
    if not FileExists(FileName) then
      raise Exception.Create( '���� �� ������:'+#13+FileName);
    frReport.LoadFromFile(FileName);
  end;
  //������� ����� ������ ��� ��������� ����� ��� ����, ����� ������� ���������
  //������������ �� ���� � �������� ���������� ������ � ��������� �� ������ ������
  if (DataSet<>nil) and DataSet.Active then begin
    Mark:=DataSet.BookMark;
    DataSet.DisableControls;
  end;
  try

    if not APreview then begin
      frReport.PrepareReport;
      if PrintDlg then
        frReport.PrintPreparedReportDlg
      else
        frReport.PrintPreparedReport( '', 1, False, frAll);
    end
    else
      frReport.ShowReport;
  finally
    if (DataSet<>nil) and DataSet.Active then begin
      DataSet.BookMark:=Mark;
      DataSet.EnableControls;
    end;
  end;
end;

procedure TDM.adtClientsAfterInsert(DataSet: TDataSet);
begin
  ClientInserted:=True;
  adtClients.Post;
end;

procedure TDM.adtParamsAfterOpen(DataSet: TDataSet);
begin
//  adtParams.Properties['Update Criteria'].Value:=adCriteriaAllCols;
end;

procedure TDM.adtClientsAfterOpen(DataSet: TDataSet);
begin
//  adtClients.Properties['Update Criteria'].Value:=adCriteriaKey;
//  adtClients.Properties['Update Resync'].Value:=adResyncAll;
  if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
  then adtClients.First;
//  MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
  ClientChanged;
end;

//�������� ���������� �� ���������� ��������� ��������� �� TablesUpdates
function TDM.GetTablesUpdatesInfo(ParamTableName: string): string;
begin
  Result:='';
  with adtTablesUpdates do begin
    Open;
    try
      if Locate('TableName',ParamTableName,[loCaseInsensitive]) then
        Result:='������ ��������� : '+FieldByName('UpdateDate').AsString;
    finally
      Close;
    end;
  end;
end;

procedure TDM.adtClientsAfterPost(DataSet: TDataSet);
begin
  if ClientInserted then
    with adcUpdate do begin
      SQL.Text:=Format('EXECUTE PROCEDURE ClientFirmInsert %d', [adtClients.FieldByName('Id').AsInteger]);
      adcUpdate.ExecProc;
    end;
  ClientInserted:=False
end;

//���������� � �������� ������� ��������� ������� �� ����� In
procedure TDM.LinkExternalTables;
var
  SR: TSearchRec;
  FileName,
  ShortName : String;
  up : TpFIBDataSet;
  Files : TStringList;
  Tables : TStringList;
  I : Integer;
  InDelimitedFile : TFIBInputDelimitedFile;
begin
{
  if FindFirst(ExePath+SDirIn+'\*.txt',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    try
      repeat
        FileName := ExePath+SDirIn+ '\' + SR.Name;
        ShortName := ChangeFileExt(SR.Name,'');
        adcUpdate.SQL.Text := 'EXECUTE PROCEDURE CREATEEXT' + ShortName + '(:PATH)';
        adcUpdate.ParamByName('PATH').Value := FileName;
        adcUpdate.ExecQuery;
      until FindNext(SR)<>0;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
}
  if FindFirst(ExePath+SDirIn+'\*.txt',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    Files := TStringList.Create;
    Tables := TStringList.Create;
    try
      UpTran.StartTransaction;
      try

        //������� ������� ������� �������
        repeat
          FileName := ExePath+SDirIn+ '\' + SR.Name;
          ShortName := ChangeFileExt(SR.Name,'');
          adcUpdate.SQL.Text := 'EXECUTE PROCEDURE CREATEEXT' + ShortName + '(:PATH)';
          adcUpdate.ParamByName('PATH').Value := FileName;
          Tracer.TR('CreateExternal', adcUpdate.SQL.Text);
          adcUpdate.ExecQuery;
          Files.Add(FileName);
          Tables.Add('EXT' + UpperCase(ShortName));
        until FindNext(SR)<>0;
        FindClose(SR);

        UpTran.CommitRetaining;

        //����� ��������� �� �������
        up := TpFIBDataSet.Create(nil);
        try
          up.Database := MainConnection1;
          up.Transaction := UpTran;

          InDelimitedFile := TFIBInputDelimitedFile.Create;
          try
            InDelimitedFile.SkipTitles := False;
            InDelimitedFile.ReadBlanksAsNull := False;
            InDelimitedFile.ColDelimiter := Chr(159);
            InDelimitedFile.RowDelimiter := Chr(161);


            for I := 0 to Files.Count-1 do begin
              if (Tables[i] <> 'EXTCORE') and (Tables[i] <> 'EXTSYNONYM')
                and (Tables[i] <> 'EXTREGISTRY') and (Tables[i] <> 'EXTMINPRICES')
              then begin
                up.SelectSQL.Text := 'select * from ' + Tables[i];
                up.Prepare;
                up.Open;
                up.AutoUpdateOptions.UpdateTableName := Tables[i];
                up.InsertSQL.Text := up.GenerateSQLText(Tables[i], up.Fields[0].FieldName, skInsert);
                Tracer.TR(Tables[i], up.InsertSQL.Text);
                up.Close;
                up.SelectSQL.Text := up.InsertSQL.Text;
                InDelimitedFile.Filename := Files[i];
                up.BatchInput(InDelimitedFile);
              end;
            end;

          finally
            InDelimitedFile.Free;
          end;

        finally
          up.Free;
        end;

        UpTran.Commit;
      except
        UpTran.Rollback;
        raise;
      end;

    finally
      Files.Free;
      Tables.Free;
      Screen.Cursor:=crDefault;
    end;
  end;


//������ � ����������� ������
{
  if FindFirst(ExePath+SDirIn+'\*.zip',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    Files := TStringList.Create;
    Tables := TStringList.Create;
    Indecies := TStringList.Create;
    UnZip := TVCLUnZip.Create(nil);
    try
      UnZip.ZipName := ExePath+SDirIn+ '\' + SR.Name;
      UnZip.ReadZip;
      for I := 0 to UnZip.Count-1 do begin
        if (pos('\', UnZip.Filename[i]) = 0) and (pos('.txt', UnZip.Filename[i]) > 0) then begin
          FileName := ExePath+SDirIn+ '\' + UnZip.Filename[i];
          ShortName := ChangeFileExt(UnZip.Filename[i],'');
          adcUpdate.SQL.Text := 'EXECUTE PROCEDURE CREATEEXT' + ShortName + '(:PATH)';
          adcUpdate.ParamByName('PATH').Value := FileName;
          Tracer.TR('CreateExternal', adcUpdate.SQL.Text);
          adcUpdate.ExecQuery;
          Files.Add(FileName);
          Tables.Add('EXT' + UpperCase(ShortName));
          Indecies.Add(IntToStr(i));
        end;
      end;

//      repeat
//        FileName := ExePath+SDirIn+ '\' + SR.Name;
//        ShortName := ChangeFileExt(SR.Name,'');
//        adcUpdate.SQL.Text := 'EXECUTE PROCEDURE CREATEEXT' + ShortName + '(:PATH)';
//        adcUpdate.ParamByName('PATH').Value := FileName;
//        Tracer.TR('CreateExternal', adcUpdate.SQL.Text);
//        adcUpdate.ExecQuery;
//        Files.Add(FileName);
//        Tables.Add('EXT' + UpperCase(ShortName));
//      until FindNext(SR)<>0;

      FindClose(SR);

      DefTran.CommitRetaining;


      up := TpFIBDataSet.Create(nil);
      try
        up.Database := MainConnection1;
        up.Transaction := DefTran;

        InDelimitedFile := TINFIBInputDelimitedStream.Create;
        MS := TMemoryStream.Create;
        try
          InDelimitedFile.SkipTitles := False;
          InDelimitedFile.ReadBlanksAsNull := False;
          InDelimitedFile.ColDelimiter := Chr(159);
          InDelimitedFile.RowDelimiter := Chr(161);

          UnZip.Password := '12345678';

          for I := 0 to Files.Count-1 do begin
            if (Tables[i] <> 'EXTCORE') and (Tables[i] <> 'EXTSYNONYM') then begin
              MS.Size := UnZip.UnCompressedSize[StrToInt(Indecies[i])];
              MS.Clear;
              UnZip.UnZipToStreamByIndex(MS, StrToInt(Indecies[i]));
              up.SelectSQL.Text := 'select * from ' + Tables[i];
              up.Prepare;
              up.Open;
              up.AutoUpdateOptions.UpdateTableName := Tables[i];
              up.InsertSQL.Text := up.GenerateSQLText(Tables[i], up.Fields[0].FieldName, skInsert);
              Tracer.TR(Tables[i], up.InsertSQL.Text);
              up.Close;
              up.SelectSQL.Text := up.InsertSQL.Text;
              InDelimitedFile.Filename := Files[i];
              InDelimitedFile.Stream := MS;
              MS.Seek(0, soFromBeginning);
              up.BatchInput(InDelimitedFile);
            end;
          end;

        finally
          InDelimitedFile.Free;
          MS.Free;
        end;

      finally
        up.Free;
      end;

      DefTran.CommitRetaining;

    finally
      UnZip.Free;
      Indecies.Free;
      Files.Free;
      Tables.Free;
      Screen.Cursor:=crDefault;
    end;
  end;
}  
end;

// ���������� ������� �� ������� MDB
procedure TDM.LinkExternalMDB( ATablesList: TStringList);
var
  Table, Catalog: Variant;
  i: integer;
begin
{
  Catalog := CreateOleObject( 'ADOX.Catalog');
        Catalog.ActiveConnection := MainConnection.ConnectionObject;

  try
    for i := 0 to ATablesList.Count - 1 do
    begin
      if Pos( 'Tmp', ATablesList[ i]) = 1 then continue;
      Table := CreateOleObject( 'ADOX.Table');
      Table.ParentCatalog := Catalog;
      Table.Name := 'Old' + ATablesList[ i];
      Table.Properties( 'Jet OLEDB:Create Link') := True;
      Table.Properties( 'Jet OLEDB:Link Datasource') := ExePath + DatabaseName;
      Table.Properties( 'Jet OLEDB:Remote Table Name') := ATablesList[ i];
      try
        Catalog.Tables.Append( Table);
      except
      end;
      Table := Unassigned;
    end;
  finally
    Catalog := Unassigned;
  end;
  }
end;

//��������� ��� ������������ ������� �������
procedure TDM.UnLinkExternalTables;
var
  I: Integer;
  Catalog: Variant;
  TN : TStringList;
begin
{
  Screen.Cursor:=crHourglass;
  try
    Catalog:=CreateOleObject('ADOX.Catalog');
    try
      Catalog.ActiveConnection:=MainConnection.ConnectionObject;
      for I:=Catalog.Tables.Count-1 downto 0 do
        if Catalog.Tables.Item[I].Type='LINK' then
          Catalog.Tables.Delete(Catalog.Tables.Item[I].Name);
    finally
      Catalog:=Unassigned;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  }
  Screen.Cursor:=crHourglass;
  try
    TN := TStringList.Create;
    try
      MainConnection1.GetTableNames(TN, False);
      DM.MainConnection1.DefaultUpdateTransaction.StartTransaction;
      try
        for I:=TN.Count-1 downto 0 do
          if Pos('EXT', UpperCase(TN[i])) = 1 then
          begin
            adcUpdate.SQL.Text := 'drop table ' + TN[i];
            adcUpdate.ExecQuery;
          end;
        DM.MainConnection1.DefaultUpdateTransaction.Commit;
      except
        DM.MainConnection1.DefaultUpdateTransaction.Rollback;
        raise;
      end;
    finally
      TN.Free;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDM.ClearDatabase;
begin
  Screen.Cursor:=crHourglass;
  with adcUpdate do try
    UpTran.StartTransaction;
    try

      MainForm.StatusText:='��������� MinPrices';
      SQL.Text:='EXECUTE PROCEDURE MinPricesDeleteALL';
      ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersSetCoreNull'; ExecQuery;
      SQL.Text:='EXECUTE PROCEDURE OrdersHDeleteNotClosedAll'; ExecQuery;
      MainForm.StatusText:='��������� Core';
      SQL.Text:='EXECUTE PROCEDURE CoreDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� CatalogCurrency';
      SQL.Text:='EXECUTE PROCEDURE CatalogCurrencyDelete'; ExecQuery;
      MainForm.StatusText:='��������� Catalog';
      SQL.Text:='EXECUTE PROCEDURE CatalogDelete'; ExecQuery;
      MainForm.StatusText:='��������� PricesRegionalData';
      SQL.Text:='EXECUTE PROCEDURE PricesRegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� PricesData';
      SQL.Text:='EXECUTE PROCEDURE PricesDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� RegionalData';
      SQL.Text:='EXECUTE PROCEDURE RegionalDataDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� ClientsDataN';
      SQL.Text:='EXECUTE PROCEDURE ClientsDataNDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Synonym';
      SQL.Text:='EXECUTE PROCEDURE SynonymDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� SynonymFirmCr';
      SQL.Text:='EXECUTE PROCEDURE SynonymFirmCrDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Defectives';
      SQL.Text:='EXECUTE PROCEDURE DefectivesDeleteAll'; ExecQuery;
      MainForm.StatusText:='��������� Registry';
      SQL.Text:='EXECUTE PROCEDURE RegistryDelete'; ExecQuery;

      UpTran.Commit;
    except
      UpTran.Rollback;
      raise;
    end;
  finally
    Screen.Cursor:=crDefault;
    MainForm.StatusText:='';
  end;
end;

function TDM.GetCurrentOrderId(ClientId, PriceCode, RegionCode: Integer;
  CreateIfNotExists: Boolean=True): Integer;
var
  NRecs: Integer;
begin
  with adsSelect do begin
    SelectSQL.Text:=Format('SELECT OrderId FROM OrdersH WHERE ClientId=%d And PriceCode=%d And RegionCode=%d And Closed = 0',
      [ClientId, PriceCode, RegionCode]);
    Open;
    try
      NRecs:=RecordCount;
      Result:=Fields[0].AsInteger;
    finally
      Close;
    end;
  end;
  if NRecs=0 then begin
    if CreateIfNotExists then with adcUpdate do begin
      SQL.Text:=Format('INSERT INTO OrdersH (ClientId,PriceCode,RegionCode) VALUES (%d,%d,%d)',
        [ClientId, PriceCode, RegionCode]);
      ExecQuery;
      Result:=GetCurrentOrderId(ClientId,PriceCode,RegionCode,False);
      if Result=0 then raise Exception.Create('�� ������� ������� ��������� ������');
    end
    else
      Result:=0;
  end
  else if NRecs>1 then
    raise Exception.Create('�� ������ �������, �����-����� � ������� ������� ������ ������ ��������������� ������');
end;

procedure TDM.DeleteEmptyOrders;
begin
  Screen.Cursor:=crHourglass;
  try
    UpTran.StartTransaction;
    try
      with adcUpdate do begin
        SqL.Text:='EXECUTE PROCEDURE OrdersDeleteEmpty'; ExecQuery;
        SQL.Text:='EXECUTE PROCEDURE OrdersHDeleteEmpty'; ExecQuery;
      end;
      UpTran.Commit;
    except
      UpTran.Rollback;
      raise;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDM.adtClientsBeforeDelete(DataSet: TDataSet);
begin
  if MessageBox( '������� ������� �������?',MB_ICONWARNING+MB_OKCANCEL)<>IDOK then Abort;
end;

{ ��������� ��������� �������� ������ ������� }
procedure TDM.SetImportStage( AValue: integer);
begin
  DM.adtParams.Edit;
  DM.adtParams.FieldByName( 'ImportStage').AsInteger := AValue;
  DM.adtParams.Post;
end;

function TDM.GetImportStage: integer;
begin
  result := DM.adtParams.FieldByName( 'ImportStage').AsInteger;
end;

procedure TDM.BackupDatabase( APath: string);
begin
  MainConnection1.Close;
  Windows.CopyFile( PChar( APath + DatabaseName),
    PChar( APath + ChangeFileExt( DatabaseName, '.bak')), False);
end;

function TDM.IsBackuped( APath: string): boolean;
begin
  result := FileExists( APath + ChangeFileExt( DatabaseName, '.bak'));
end;

procedure TDM.RestoreDatabase( APath: string);
begin
  Windows.DeleteFile( PChar( APath + ChangeFileExt( DatabaseName, '.ldb')));
  MoveFile_( APath + ChangeFileExt( DatabaseName, '.bak'),
    APath + DatabaseName);
end;

procedure TDM.ClearBackup( APath: string);
begin
  Windows.DeleteFile( PChar( APath + ChangeFileExt( DatabaseName, '.bak')));
end;

function TDM.Unpacked: boolean;
var
  SR: TSearchRec;
begin
  result := FindFirst( ExePath + SDirIn + '\*.zi_', faAnyFile, SR) <> 0;
  if not result then
  begin
    MoveFile_( ExePath + SDirIn + '\' + SR.Name,
      ExePath + SDirIn + '\' + ChangeFileExt( SR.Name, '.zip'));
  end;
  FindClose( SR);
end;

procedure TDM.ResetExclusive;
begin
  { ������ ������� �� ����������� ������ }
  MainForm.CS.Enter;
  try
    try
      adtFlags.Edit;
      adtFlags.FieldByName( 'ComputerName').AsString := '';
      adtFlags.FieldByName( 'ExclusiveID').AsString := '';
      adtFlags.Post;
    except
    end;
  finally
    MainForm.CS.Leave;
  end;
end;

procedure TDM.SetExclusive;
begin
  { ��������� ������� �� ����������� ������ }
  MainForm.CS.Enter;
  try
    try
      adtFlags.Edit;
      adtFlags.FieldByName( 'ComputerName').AsString := GetComputerName_;
      adtFlags.FieldByName( 'ExclusiveID').AsString := IntToHex(
        GetUniqueID( Application.ExeName, ''{MainForm.VerInfo.FileVersion}), 8);
      adtFlags.Post;
    except
    end;
  finally
    MainForm.CS.Leave;
  end;
end;

function TDM.GetCumulative: boolean;
begin
  try
    result := adtParams.FieldByName( 'Cumulative').AsBoolean;
  except
    result := False;
  end;
end;

procedure TDM.ResetCumulative;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Cumulative').AsBoolean := False;
    adtParams.Post;
  except
  end;
end;

procedure TDM.SetCumulative;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Cumulative').AsBoolean := True;
    adtParams.Post;
  except
  end;
end;

function TDM.GetStarted: Boolean;
begin
  try
    result := adtParams.FieldByName( 'Started').AsBoolean;
  except
    result := False;
  end;
end;

procedure TDM.ResetStarted;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Started').AsBoolean := False;
    adtParams.Post;
  except
  end;
end;

procedure TDM.SetStarted;
begin
  try
    adtParams.Edit;
    adtParams.FieldByName( 'Started').AsBoolean := True;
    adtParams.Post;
  except
  end;
end;

procedure TDM.VersionValid;

function GetLibraryVersionFromPath(AName: String): String;
var
  RxVer : TVersionInfo;
begin
  if FileExists(AName) then begin
    RxVer := TVersionInfo.Create(AName);
    try
      Result := LongVersionToString(RxVer.FileLongVersion);
    finally
      RxVer.Free;
    end;
  end
  else
    Result := '';
end;

function GetLibraryVersionByName(AName: String): String;
var
  hLib : THandle;
  FileName : String;
begin
  Result := '';
  hLib := LoadLibraryEx(PChar(AName), 0, 0);
  if hLib <> 0 then begin
    try
      FileName := GetModuleName(hLib);
      Result := GetLibraryVersionFromPath(FileName);
    finally
      FreeLibrary(hLib);
    end;
  end;
end;

procedure GetJETMDACVersions(var AJETVersion, AJETDesc,
  AMDACVersion, AMDACDesc: String);
const
  JETVersions : array[0..8, 0..1] of String = (
    ('4.0.2927.4', '����� ���������� 3 (SP3)'),
    ('4.0.3714.7', '����� ���������� 4 (SP4)'),
    ('4.0.4431.1', '����� ���������� 5 (SP5)'),
    ('4.0.4431.3', '����� ���������� 5 (SP5)'),
    ('4.0.6218.0', '����� ���������� 6 (SP6)'),
    ('4.0.6807.0', '����� ���������� 6 (SP6), ������������ ������ � Windows Server 2003'),
    ('4.0.7328.0', '����� ���������� 7 (SP7)'),
    ('4.0.8015.0', '����� ���������� 8 (SP8)'),
    ('4.0.8618.0', '����� ���������� 8 (SP8) c ���������� �� ������������ MS04-014')
  );

  MDACVersions : array[0..13, 0..1] of String = (
    ('2.10.4202.0', 'MDAC 2.1 SP2'),
    ('2.50.4403.6', 'MDAC 2.5'),
    ('2.51.5303.2', 'MDAC 2.5 SP1'),
    ('2.52.6019.0', 'MDAC 2.5 SP2'),
    ('2.53.6200.0', 'MDAC 2.5 SP3'),
    ('2.60.6526.0', 'MDAC 2.6 RTM'),
    ('2.61.7326.0', 'MDAC 2.6 SP1'),
    ('2.62.7926.0', 'MDAC 2.6 SP2'),
    ('2.62.7400.0', 'MDAC 2.6 SP2 Refresh'),
    ('2.70.7713.0', 'MDAC 2.7 RTM'),
    ('2.70.9001.0', 'MDAC 2.7 Refresh'),
    ('2.71.9030.0', 'MDAC 2.7 SP1'),
    ('2.80.1022.0', 'MDAC 2.8 RTM'),
    ('2.81.1117.0', 'MDAC 2.8 SP1 on Windows XP SP2')
  );

var
  I : Integer;
  Found : Boolean;
begin
  AJETVersion := '';
  AJETDesc := '';
  AMDACVersion := '';
  AMDACDesc := '';
  try
  AJETVersion := GetLibraryVersionByName('Msjet40.dll');
  if Length(AJETVersion) = 0 then
    AJETVersion := 'JET �� ����������'
  else begin
    if AnsiCompareStr(AJETVersion, JETVersions[0, 0]) < 0 then begin
      AJETVersion := AJETVersion;
      AJETDesc := '���� ��� ' + JETVersions[0, 1];
    end
    else
      if AnsiCompareStr(AJETVersion, JETVersions[8, 0]) > 0 then begin
        AJETVersion := AJETVersion;
        AJETDesc := '���� ��� ' + JETVersions[8, 1];
      end
      else begin
        Found := False;
        for I := 0 to 8 do
          if AnsiCompareStr(AJETVersion, JETVersions[i, 0]) = 0 then begin
            Found := True;
            AJETVersion := AJETVersion;
            AJETDesc := JETVersions[i, 1];
            Break;
          end;
        if not Found then begin
          AJETVersion := AJETVersion;
          AJETDesc := '������ �� �����������';
        end;
      end;
  end;

  //��������� MDDAC � ������� MSDASQL.DLL
  AMDACVersion := GetLibraryVersionFromPath(ReplaceMacros('$(COMMONFILES)\system\ole db\') + 'MSDASQL.DLL');
  if Length(AMDACVersion) = 0 then
    AMDACVersion := 'MDAC �� ����������'
  else begin
    if AnsiCompareStr(AMDACVersion, MDACVersions[0, 0]) < 0 then begin
      AMDACDesc := '���� ��� ' + MDACVersions[0, 1];
    end
    else
      if AnsiCompareStr(AMDACVersion, MDACVersions[High(MDACVersions), 0]) > 0 then begin
        AMDACDesc := '���� ��� ' + MDACVersions[High(MDACVersions), 1];
      end
      else begin
        Found := False;
        for I := 0 to High(MDACVersions) do
          if AnsiCompareStr(AMDACVersion, MDACVersions[i, 0]) = 0 then begin
            Found := True;
            AMDACDesc := MDACVersions[i, 1];
            Break;
          end;
        if not Found then begin
          AMDACDesc := '������ �� �����������';
        end;
      end;
  end;
  except
  end;
end;

var
  AJETVersion, AJETDesc, AMDACVersion, AMDACDesc: String;
  UserJETVer, UserMDACVer, EtalonJETVer, EtalonMDACVer : TLongVersion;
begin
  GetJETMDACVersions(AJETVersion, AJETDesc, AMDACVersion, AMDACDesc);
  UserJETVer := StringToLongVersion(AJETVersion);
  UserMDACVer := StringToLongVersion(AMDACVersion);
  EtalonJETVer := StringToLongVersion('4.0.8015.0');
  EtalonMDACVer := StringToLongVersion('2.53.6200.0');
  if (UserJETVer.MS >= EtalonJETVer.MS) and (UserJETVer.LS >= EtalonJETVer.LS)
    and (UserMDACVer.MS >= EtalonMDACVer.MS) //and (UserMDACVer.LS >= EtalonMDACVer.LS)
  then
  else begin
    MessageBox(Format('�� ������ ���������� ������ JET � MDAC �� ������������� ����������� �����������.'#13#10'JET : %s'#13#10'MDAC : %s', [AJETVersion, AMDACVersion]), MB_ICONERROR);
    ExitProcess(0);
  end;
end;

procedure TDM.MainConnection1AfterConnect(Sender: TObject);
begin
  //��������� ������� � �����������
  adtParams.CloseOpen(True);
  ReadPasswords;
  adtProvider.CloseOpen(True);
  adtReclame.CloseOpen(True);
  adtClients.CloseOpen(True);
  adsRetailMargins.CloseOpen(True);
  LoadRetailMargins;
  try
    adtFlags.CloseOpen(True);
  except
  end;
end;

procedure TDM.SweepDB;
begin
  MainConnection1.Close;
  try
    with ValidService do
    begin
      ServerName := '';
      DatabaseName := MainConnection1.DBName;
      Params.Clear;
      Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
      Params.Add('password=' + MainConnection1.ConnectParams.Password);
      Active := True;
      try
        Tracer.TR('Sweep', 'Try sweep DB');
        ServiceStart;
        While not Eof do
          Tracer.TR('Sweep', GetNextLine);
      finally
        Active := False;
      end;
    end;
  finally
    MainConnection1.Open;
  end;
end;

procedure TDM.SetSweepInterval;
begin
  with ConfigService do
  begin
    ServerName := '';
    DatabaseName := MainConnection1.DBName;
    Params.Clear;
    Params.Add('user_name=' + MainConnection1.ConnectParams.UserName);
    Params.Add('password=' + MainConnection1.ConnectParams.Password);
    Active := True;
    try
      Tracer.TR('Config', 'Set sweep interval');
      SetSweepInterval(0);
      Tracer.TR('Config', 'Set sweep interval complete');
    finally
      Active := False;
    end;
  end;
end;

function TDM.GetDisplayColors: Integer;
var
  tHDC: hdc;
begin
  tHDC := GetDC(0);
  result := GetDeviceCaps(tHDC, BITSPIXEL);
  ReleaseDC(0, tHDC);
end;

function TDM.TCPPresent: Boolean;
var
//  idPing : TIdIcmpClient;
  hWS : THandle;
begin
  try
    hWS := LoadLibrary('ws2_32.dll');
    Result := hWS <> 0;
    if Result then
      FreeLibrary(hWS);
      {
    idPing := TIdIcmpClient.Create(nil);
    try
      idPing.Host := 'localhost';
      idPing.Ping();
      Result := idPing.ReplyStatus.ReplyStatusType = rsEcho;
    finally
      idPing.Free;
    end;
    }
  except
    Result := False;
  end;
end;

function TDM.NeedCommitExchange: Boolean;
begin
  Result := FNeedCommitExchange;
end;

procedure TDM.ResetNeedCommitExchange;
begin
  FNeedCommitExchange := False;
end;

procedure TDM.SetNeedCommitExchange;
begin
  FNeedCommitExchange := True;
end;

function TDM.D_C_S(Pass, S: String): String;
begin
  Result := DeCryptString(S, Pass);
end;

procedure TDM.ReadPasswords;
var
  PassPass : String;
begin
  PassPass := in_Encode('1234567890123456');
try
  SynonymPassword := in_Encode( D_C_S(PassPass, in_Decode(adtParams.FieldByName('SYNPASS').AsString) ) );
  CodesPassword := in_Encode( D_C_S(PassPass, in_Decode(adtParams.FieldByName('CODESPASS').AsString) ) );
  BasecostPassword := in_Encode( D_C_S(PassPass, in_Decode(adtParams.FieldByName('BPASS').AsString) ) );
except
  SynonymPassword := '';
  CodesPassword := '';
  BasecostPassword := '';
end;

{
  SynonymPassword := in_Encode('Test1234Test1234');
  CodesPassword := in_Encode('Test4321Test4321');
  BasecostPassword := in_Encode('Test3412Test3412');
}
end;

function TDM.D_S(CodeS: String): String;
begin
  if (Length(CodeS) > 1) and (CodeS[1] = ' ') then
    Result := D_C_S(SynonymPassword, in_Decode( Copy(CodeS, 2, Length(CodeS)) ))
  else
    Result := CodeS;
end;

function TDM.D_C(CodeS: String): String;
begin
  CodeS := Copy(CodeS, 1, Length(CodeS)-16);
  if Length(CodeS) >= 16 then
    Result := D_C_S(CodesPassword, rc_Decode(CodeS))
  else
    Result := CodeS;
end;

function TDM.D_B(CodeS1, CodeS2: String): String;
var
  tmp : String;
begin
  tmp := in_Decode( RightStr(CodeS1, 16) + RightStr(CodeS2, 16) );
  if Length(tmp) > 1 then begin
    Result := D_C_S(BaseCostPassword, tmp);
    Result := Trim(Result);
    Result := StringReplace(Result, '.', DM.FFS.DecimalSeparator, [rfReplaceAll]);
  end
  else
    Result := '';
end;

function TDM.C_C_S(Pass, S: String): String;
begin
  Result := EnCryptString(S, Pass);
end;

procedure TDM.SavePass(ASyn, ACodes, AB: String);
var
  PassPass : String;
begin
  PassPass := in_Encode('1234567890123456');
  SynonymPassword := ASyn;
  CodesPassword := ACodes;
  BaseCostPassword := AB;
  adtParams.Edit;
  adtParams.FieldByName('SYNPASS').AsString := in_Encode( C_C_S(PassPass, in_Decode(SynonymPassword)) );
  adtParams.FieldByName('CODESPASS').AsString := in_Encode( C_C_S(PassPass, in_Decode(CodesPassword)) );
  adtParams.FieldByName('BPASS').AsString := in_Encode( C_C_S(PassPass, in_Decode(BaseCostPassword)) );
  adtParams.Post;
end;

procedure TDM.adsSelect3CalcFields(DataSet: TDataSet);
var
  S : String;
begin
  try
    adsSelect3CryptSYNONYMNAME.AsString := DM.D_S(adsSelect3SYNONYMNAME.AsString);
    adsSelect3CryptSYNONYMFIRM.AsString := DM.D_S(adsSelect3SYNONYMFIRM.AsString);
    adsSelect3CryptCODE.AsString := DM.D_C(adsSelect3CODE.AsString);
    adsSelect3CryptCODECR.AsString := DM.D_C(adsSelect3CODE.AsString);
    S := DM.D_B(adsSelect3CODE.AsString, adsSelect3CODECR.AsString);
    adsSelect3CryptPRICE.AsString := S;
  except
  end;
end;

function TDM.GetPriceRet(BaseCost: Currency): Currency;
var
  I, Ret : Integer;
begin
  Ret := 0;
  I := 0;
  while (I < Length(FRetMargins)) and (BaseCost >= FRetMargins[i][1]) do begin
    if (FRetMargins[i][1] <= BaseCost) and (BaseCost <= FRetMargins[i][2]) then begin
      Ret := FRetMargins[i][3];
      Break;
    end;
    Inc(I);
  end;
  Result := (1 + Ret/100)*BaseCost;
end;

procedure TDM.LoadRetailMargins;
var
  I : Integer;
begin
  SetLength(FRetMargins, adsRetailMargins.RecordCount);
  adsRetailMargins.First;
  I := 0;
  while not adsRetailMargins.Eof do begin
    FRetMargins[i][1] := adsRetailMarginsLEFTLIMIT.AsCurrency;
    FRetMargins[i][2] := adsRetailMarginsRIGHTLIMIT.AsCurrency;
    FRetMargins[i][3] := adsRetailMarginsRETAIL.Value;
    Inc(I);
    adsRetailMargins.Next;
  end;
end;

procedure TDM.adsRetailMarginsLEFTLIMITChange(Sender: TField);
begin
  adsRetailMargins.DoSort(['LEFTLIMIT'], [True]);
end;

procedure TDM.adsSumOrdersCalcFields(DataSet: TDataSet);
var
  S : String;
begin
  try
    S := D_B(adsSumOrdersCODE.AsString, adsSumOrdersCODECR.AsString);
  except
    on E : Exception do
      raise EINCryptException.Create('PRICE', E.Message);
  end;
  adsSumOrdersCryptPRICE.AsCurrency := StrToCurr(S);
  adsSumOrdersSumOrders.AsCurrency := StrToCurr(S) * adsSumOrdersORDERCOUNT.AsInteger;
end;

end.
