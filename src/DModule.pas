unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, ADOInt, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_ADODB, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, FR_OLE,
  frRtfExp, frexpimg, frOLEExl, FR_E_HTML2, FR_E_TXT, FR_Rich, CompactThread;

const
  HistoryMaxRec=5;
  //����. ���-�� ����� ����������� � �������
  RegisterId=59; //��� ������� � ����������� ����

type
  //������ ���������� ������� � ���� �� ������� ����������
  //pdmPrev - �� ����������� ����������, pdmMin - �� ���������� � min �����,
  //pdmMinEnabled - �� ������.����. � min �����
  TPriceDeltaMode =( pdmPrev, pdmMin, pdmMinEnabled);

  TDM = class(TDataModule)
    MainConnection: TADOConnection;
    adtParams: TADOTable;
    adtProvider: TADOTable;
    adcUpdate: TADOCommand;
    adsSelect: TADODataSet;
    frReport: TfrReport;
    dsParams: TDataSource;
    dsAnalit: TDataSource;
    dsClients: TDataSource;
    adtTablesUpdates: TADOTable;
    dsTablesUpdates: TDataSource;
    Ras: TARas;
    adsSelect2: TADODataSet;
    frOLEObject: TfrOLEObject;
    frRichObject: TfrRichObject;
    frCheckBoxObject: TfrCheckBoxObject;
    frShapeObject: TfrShapeObject;
    frChartObject: TfrChartObject;
    frRoundRectObject: TfrRoundRectObject;
    frTextExport: TfrTextExport;
    frDialogControls: TfrDialogControls;
    frHTML2Export: TfrHTML2Export;
    frOLEExcelExport: TfrOLEExcelExport;
    frBMPExport: TfrBMPExport;
    frJPEGExport: TfrJPEGExport;
    frTIFFExport: TfrTIFFExport;
    frRtfAdvExport: TfrRtfAdvExport;
    adsOrders: TADODataSet;
    adsSelect3: TADODataSet;
    adsCore: TADODataSet;
    adtReclame: TADOTable;
    adtClients: TADOTable;
    dsReclame: TDataSource;
    adtFlags: TADOTable;
    adsOrdersH: TADODataSet;
    procedure DMCreate(Sender: TObject);
    procedure MainConnectionAfterConnect(Sender: TObject);
    procedure adtClientsAfterInsert(DataSet: TDataSet);
    procedure adtParamsAfterOpen(DataSet: TDataSet);
    procedure adtClientsAfterOpen(DataSet: TDataSet);
    procedure adtClientsAfterPost(DataSet: TDataSet);
    procedure adtClientsBeforeDelete(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
  private
	ClientInserted: Boolean;
	procedure CheckRestrictToRun;
  public
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
  end;

var
  DM: TDM;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID, RxVerInf,
     U_FolderMacros;

procedure TDM.DMCreate(Sender: TObject);
var
  LDBFileName : String;
  DBCompress : Boolean;
begin
  //�������� ������
  VersionValid;

	MainConnection.ConnectionString :=
		SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
			ExePath + DatabaseName);

  if not FileExists(ExePath + DatabaseName) then begin
    MessageBox( Format( '���� ���� ������ %s �� ����������.', [ ExePath + DatabaseName ]),
      MB_ICONERROR or MB_OK);
    ExitProcess(7);
  end;

  if ((FileGetAttr(ExePath + DatabaseName) and SysUtils.faReadOnly) = SysUtils.faReadOnly)
  then begin
    MessageBox( Format( '���� ���� ������ %s ����� ������� "������ ������".', [ ExePath + DatabaseName ]),
      MB_ICONERROR or MB_OK);
    ExitProcess(6);
  end;

  LDBFileName := ChangeFileExt(ExeName, '.ldb');
  DBCompress := FileExists(LDBFileName) and DeleteFile(LDBFileName);


	DM.MainConnection.Mode := cmRead;
  try
    try
      CheckRestrictToRun;
    finally
      MainConnection.Close;
      DM.MainConnection.Mode := cmReadWrite;
    end;
  except
    on E : Exception do begin
  		MessageBox( Format( '�� �������� ������� ���� ���� ������ : %s ', [ E.Message ]),
			  MB_ICONERROR or MB_OK);
      ExitProcess(5);
    end;
  end;

	MainConnection.Open;
	{ ������������� ������� ������ � Clients � Users }
	if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
		then adtClients.First;
  //���������, ��� ������ � ���������� ���� ��������� ���������
  if DBCompress then
  begin
		MessageBox(
      '��������� ����� ������ � ���������� �� ��� ��������� ��������. '+
        '������ ����� ����������� ������ � �������������� ���� ������.');
  	MainForm.FreeChildForms;
    RunCompactDataBase;
		MessageBox( '������ � �������������� ���� ������ ���������.');
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
	if not MainConnection.Connected then exit;

	try
		adtParams.Edit;
		adtParams.FieldByName( 'ClientId').Value := adtClients.FieldByName( 'ClientId').Value;
		adtParams.Post;
	except
	end;
  ResetStarted;
end;

procedure TDM.MainConnectionAfterConnect(Sender: TObject);
begin
	//��������� ������� � �����������
	adtParams.Open;
	adtProvider.Open;
	adtReclame.Open;
	adtClients.Open;
	try
		adtFlags.Open;
	except
	end;
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
	i, c: integer;
	ExID, CompName: string;
	MaxUsers: integer;
begin
	DM.MainConnection.Open;
	MaxUsers := DM.adtClients.FieldByName( 'MaxUsers').AsInteger;
	list := DM.DatabaseOpenedList( ExID, CompName);
	DM.MainConnection.Close;
	c := 0;
	for i := 0 to list.Count - 1 do
		if list[ i] = GetComputerName_ then inc( c);
	if c > 1 then
	begin
		MessageBox( '������ ���� ����� ��������� �� ����� ���������� ����������.',
			MB_ICONWARNING or MB_OK);
    ExitProcess(1);
	end;

	if ( MaxUsers > 0) and ( list.Count > MaxUsers) then
	begin
		MessageBox( Format( '�������� ����� �� ����������� � ���� ������ (����� : %d). ' +
			'������ ��������� ����������.', [ MaxUsers]),
			MB_ICONWARNING or MB_OK);
    ExitProcess(2);
	end;

	if list.Count > 1 then
	begin
		if ( ExID = IntToHex( GetUniqueID( Application.ExeName,
			''{MainForm.VerInfo.FileVersion}), 8)) or ( ExID = '') then exit;

		MessageBox( Format( '����� ��������� �� ���������� %s �������� � ������ ' + #10 + #13 +
			'������������ ������ � ���� ������. ������ ��������� ����������.', [ CompName]),
			MB_ICONWARNING or MB_OK);
    ExitProcess(3);
	end;
end;

function TDM.DatabaseOpenedBy: string;
var
	WasConnected: boolean;
begin
	result := '';
	WasConnected := MainConnection.Connected;
	MainConnection.OpenSchema( siProviderSpecific, EmptyParam,
		JET_SCHEMA_USERROSTER, adsSelect);
	if adsSelect.RecordCount > 1 then
		result := adsSelect.FieldByName( 'COMPUTER_NAME').AsString;
	adsSelect.Close;
	if not WasConnected then MainConnection.Close;
end;

function TDM.DatabaseOpenedList( var ExclusiveID, ComputerName: string): TStringList;
var
	WasConnected: boolean;
begin
	result := TStringList.Create;
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
end;

procedure TDM.CompactDataBase(NewPassword: string='');
var
  JetEngine: OleVariant;
  TempName: string;
  ok: boolean;
begin
  ok := False;
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
end;

procedure TDM.ClearPassword( ADatasource: string);
begin
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
end;

procedure TDM.OpenDatabase( ADatasource: string);
begin
	if MainConnection.Connected then MainConnection.Close;
	MainConnection.ConnectionString :=
		SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
			ADatasource);
	MainConnection.Open;
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
	if PrintDlg then frReport.PrintPreparedReportDlg
		else frReport.PrintPreparedReport( '', 1, False, frAll);
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
  adtParams.Properties['Update Criteria'].Value:=adCriteriaAllCols;
end;

procedure TDM.adtClientsAfterOpen(DataSet: TDataSet);
begin
  adtClients.Properties['Update Criteria'].Value:=adCriteriaKey;
  adtClients.Properties['Update Resync'].Value:=adResyncAll;
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
  if ClientInserted then with adcUpdate do begin
    CommandText:=Format('EXECUTE ClientFirmInsert %d',
      [adtClients.FieldByName('Id').AsInteger]);
    Execute;
  end;
  ClientInserted:=False
end;

//���������� � �������� ������� ��������� ������� �� ����� In
procedure TDM.LinkExternalTables;
var
  Table, Catalog: Variant;
  SR: TSearchRec;
begin
  if FindFirst(ExePath+SDirIn+'\*.txt',faAnyFile,SR)=0 then begin
    Screen.Cursor:=crHourglass;
    try
      Catalog:=CreateOleObject('ADOX.Catalog');
      try
        Catalog.ActiveConnection:=MainConnection.ConnectionObject;
        repeat
          Table:=CreateOleObject('ADOX.Table');
          Table.ParentCatalog:=Catalog;
          Table.Name:='Ext'+ChangeFileExt(SR.Name,'');
          Table.Properties('Jet OLEDB:Create Link'):=True;
          Table.Properties('Jet OLEDB:Link Datasource'):=ExePath+SDirIn;
          Table.Properties('Jet OLEDB:Link Provider String'):='TEXT';
          Table.Properties('Jet OLEDB:Remote Table Name'):=SR.Name;
          Catalog.Tables.Append(Table);
          Table:=Unassigned;
        until FindNext(SR)<>0;
      finally
        Table:=Unassigned;
        Catalog:=Unassigned;
      end;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
end;

// ���������� ������� �� ������� MDB
procedure TDM.LinkExternalMDB( ATablesList: TStringList);
var
	Table, Catalog: Variant;
	i: integer;
begin
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
end;

//��������� ��� ������������ ������� �������
procedure TDM.UnLinkExternalTables;
var
  I: Integer;
  Catalog: Variant;
begin
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
end;

procedure TDM.ClearDatabase;
begin
  Screen.Cursor:=crHourglass;
  with adcUpdate do try
    MainForm.StatusText:='��������� MinPrices';
    CommandText:='EXECUTE MinPricesDelete'; Execute;
    CommandText:='EXECUTE OrdersSetCoreNull'; Execute;
    CommandText:='EXECUTE OrdersHDeleteNotClosedAll'; Execute;
    MainForm.StatusText:='��������� Core';
    CommandText:='EXECUTE CoreDeleteAll'; Execute;
    MainForm.StatusText:='��������� CatalogCurrency';
    CommandText:='EXECUTE CatalogCurrencyDelete'; Execute;
    MainForm.StatusText:='��������� Catalog';
    CommandText:='EXECUTE CatalogDelete'; Execute;
    MainForm.StatusText:='��������� PricesRegionalData';
    CommandText:='EXECUTE PricesRegionalDataDeleteAll'; Execute;
    MainForm.StatusText:='��������� PricesData';
    CommandText:='EXECUTE PricesDataDeleteAll'; Execute;
    MainForm.StatusText:='��������� RegionalData';
    CommandText:='EXECUTE RegionalDataDeleteAll'; Execute;
    MainForm.StatusText:='��������� ClientsDataN';
    CommandText:='EXECUTE ClientsDataNDeleteAll'; Execute;
    MainForm.StatusText:='��������� Synonym';
    CommandText:='EXECUTE SynonymDeleteAll'; Execute;
    MainForm.StatusText:='��������� SynonymFirmCr';
    CommandText:='EXECUTE SynonymFirmCrDeleteAll'; Execute;
    MainForm.StatusText:='��������� Defectives';
    CommandText:='EXECUTE DefectivesDeleteAll'; Execute;
    MainForm.StatusText:='��������� Registry';
    CommandText:='EXECUTE RegistryDelete'; Execute;
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
    CommandText:=Format('SELECT OrderId FROM OrdersH WHERE ClientId=%d And PriceCode=%d And RegionCode=%d And Not Closed',
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
      CommandText:=Format('INSERT INTO OrdersH (ClientId,PriceCode,RegionCode) VALUES (%d,%d,%d)',
        [ClientId, PriceCode, RegionCode]);
      Execute;
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
    with adcUpdate do begin
      CommandText:='EXECUTE OrdersDeleteEmpty'; Execute;
      CommandText:='EXECUTE OrdersHDeleteEmpty'; Execute;
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
	MainConnection.Close;
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
		adtFlags.Edit;
		adtFlags.FieldByName( 'ComputerName').AsString := '';
		adtFlags.FieldByName( 'ExclusiveID').AsString := '';
		adtFlags.Post;
	except
	end;
	MainForm.CS.Leave;
end;

procedure TDM.SetExclusive;
begin
	{ ��������� ������� �� ����������� ������ }
	MainForm.CS.Enter;
	try
		adtFlags.Edit;
		adtFlags.FieldByName( 'ComputerName').AsString := GetComputerName_;
		adtFlags.FieldByName( 'ExclusiveID').AsString := IntToHex(
			GetUniqueID( Application.ExeName, ''{MainForm.VerInfo.FileVersion}), 8);
		adtFlags.Post;
	except
	end;
	MainForm.CS.Leave;
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

end.
