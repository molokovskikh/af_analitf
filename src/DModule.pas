unit DModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, ADOInt, Variants, FileUtil, ARas, ComObj, FR_Class, FR_View,
  FR_DBSet, FR_DCtrl, FR_ADODB, FR_RRect, FR_Chart, FR_Shape, FR_ChBox, FR_OLE,
  frRtfExp, frexpimg, frOLEExl, FR_E_HTML2, FR_E_TXT, FR_Rich, CompactThread;

const
  HistoryMaxRec=5;
  //макс. кол-во писем доставаемых с сервера
  RegisterId=59; //код реестра в справочнике фирм

type
  //способ вычисления разницы в цены от другого поставщика
  //pdmPrev - от предыдущего Поставщика, pdmMin - от Поставщика с min ценой,
  //pdmMinEnabled - от Основн.Пост. с min ценой
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
    {function OrderToArchiv(ClientId: Integer=0; PriceCode: Integer=0;
      RegionCode: Integer=0): Boolean;}
  end;

var
  DM: TDM;

implementation

{$R *.DFM}

uses AProc, Main, DBProc, Exchange, Constant, SysNames, UniqueID;

procedure TDM.DMCreate(Sender: TObject);
begin
	MainConnection.ConnectionString :=
		SetConnectionProperty( MainConnection.ConnectionString, 'Data Source',
			ExePath + DatabaseName);

	DM.MainConnection.Mode := cmRead;
	try
		CheckRestrictToRun;
	finally
		MainConnection.Close;
		DM.MainConnection.Mode := cmReadWrite;
	end;

	MainConnection.Open;
	{ устанавливаем текущие записи в Clients и Users }
	if not adtClients.Locate('ClientId',adtParams.FieldByName('ClientId').Value,[])
		then adtClients.First;
  //Проверяем, что работа с программой была завершена корректно
  if GetStarted then
  begin
		MessageBox(
      'Последний сеанс работы с программой не был корректно завершен. '+
        'Сейчас будет произведено сжатие и восстановление базы данных.');
  	MainForm.FreeChildForms;
    RunCompactDataBase;
		MessageBox( 'Сжатие и восстановление базы данных завершено.');
  end;
  SetStarted;
	//MainForm.dblcbClients.KeyValue:=adtClients.FieldByName('ClientId').Value;
	ClientChanged;
	{ устанавливаем параметры печати }
	frReport.Title := Application.Title;
	{ проверяем и если надо создаем нужные каталоги }
	if not DirectoryExists( ExePath + SDirDocs) then CreateDir( ExePath + SDirDocs);
	if not DirectoryExists( ExePath + SDirIn) then CreateDir( ExePath + SDirIn);
	if not DirectoryExists( ExePath + SDirReclame) then CreateDir( ExePath + SDirReclame);
	MainForm.SetUpdateDateTime;
	Application.HintPause := 0;

	{ Запуск с ключем -e (Получение данных и выход)}
	if ( AnsiLowerCase( ParamStr( 1)) = '-e') or
		( AnsiLowerCase( ParamStr( 1)) = '/e') then
	begin
		MainForm.ExchangeOnly := True;
		RunExchange([ eaGetPrice]);
		Application.Terminate;
	end;
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
	//открываем таблицы с параметрами
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

{ Проверки на невозможность запуска программы }
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
		MessageBox( 'Запуск двух копий программы на одном компьютере невозможен.',
			MB_ICONWARNING or MB_OK);
		Application.Terminate;
	end;

	if ( MaxUsers > 0) and ( list.Count > MaxUsers) then
	begin
		MessageBox( Format( 'Исчерпан лимит на подключение к базе данных (копий : %d). ' +
			'Запуск программы невозможен.', [ MaxUsers]),
			MB_ICONWARNING or MB_OK);
		Application.Terminate;
	end;

	if list.Count > 1 then
	begin
		if ( ExID = IntToHex( GetUniqueID( Application.ExeName,
			''{MainForm.VerInfo.FileVersion}), 8)) or ( ExID = '') then exit;

		MessageBox( Format( 'Копия программы на компьютере %s работает в режиме ' + #10 + #13 +
			'монопольного доступ к базе данных. Запуск программы невозможен.', [ CompName]),
			MB_ICONWARNING or MB_OK);
		Application.Terminate;
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
  MainForm.StatusText:='Сжатие и восстановление базы данных';
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

//загружает отчет и выводит на экран или печатает; если указан DataSet, то
//блокируется визуальное перемещение по нему и происходит возврат на первичную запись
procedure TDM.ShowFastReport(FileName: string; DataSet: TDataSet = nil;
	APreview: boolean = False; PrintDlg: boolean = True);
var
  Mark: TBookmarkStr;
begin
  //находим и проверяем полное имя файла; загружаем файл
  FileName:=Trim(FileName);
  if FileName<>'' then begin
    FileName:=ExePath+FileName;
    if not FileExists(FileName) then
      raise Exception.Create( 'Файл не найден:'+#13+FileName);
    frReport.LoadFromFile(FileName);
  end;
  //находим набор данных для табличной части для того, чтобы сделать невидимым
  //передвижение по нему в процессе построения отчета и вернуться на старую запись
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

//получает информацию об обновлении заданного отношения из TablesUpdates
function TDM.GetTablesUpdatesInfo(ParamTableName: string): string;
begin
  Result:='';
  with adtTablesUpdates do begin
    Open;
    try
      if Locate('TableName',ParamTableName,[loCaseInsensitive]) then
        Result:='Данные обновлены : '+FieldByName('UpdateDate').AsString;
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

//подключает в качестве внешних текстовые таблицы из папки In
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

// подключает таблицы из старого MDB
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

//отключает все подключенные внешние таблицы
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
    MainForm.StatusText:='Очищается MinPrices';
    CommandText:='EXECUTE MinPricesDelete'; Execute;
    CommandText:='EXECUTE OrdersSetCoreNull'; Execute;
    CommandText:='EXECUTE OrdersHDeleteNotClosedAll'; Execute;
    MainForm.StatusText:='Очищается Core';
    CommandText:='EXECUTE CoreDeleteAll'; Execute;
    MainForm.StatusText:='Очищается CatalogCurrency';
    CommandText:='EXECUTE CatalogCurrencyDelete'; Execute;
    MainForm.StatusText:='Очищается Catalog';
    CommandText:='EXECUTE CatalogDelete'; Execute;
    MainForm.StatusText:='Очищается PricesRegionalData';
    CommandText:='EXECUTE PricesRegionalDataDeleteAll'; Execute;
    MainForm.StatusText:='Очищается PricesData';
    CommandText:='EXECUTE PricesDataDeleteAll'; Execute;
    MainForm.StatusText:='Очищается RegionalData';
    CommandText:='EXECUTE RegionalDataDeleteAll'; Execute;
    MainForm.StatusText:='Очищается ClientsDataN';
    CommandText:='EXECUTE ClientsDataNDeleteAll'; Execute;
    MainForm.StatusText:='Очищается Synonym';
    CommandText:='EXECUTE SynonymDeleteAll'; Execute;
    MainForm.StatusText:='Очищается SynonymFirmCr';
    CommandText:='EXECUTE SynonymFirmCrDeleteAll'; Execute;
    MainForm.StatusText:='Очищается Defectives';
    CommandText:='EXECUTE DefectivesDeleteAll'; Execute;
    MainForm.StatusText:='Очищается Registry';
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
      if Result=0 then raise Exception.Create('Не удается создать заголовок заказа');
    end
    else
      Result:=0;
  end
  else if NRecs>1 then
    raise Exception.Create('По данным клиенту, прайс-листу и региону найдено больше одного неотправленного заказа');
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
  if MessageBox( 'Удалить данного клиента?',MB_ICONWARNING+MB_OKCANCEL)<>IDOK then Abort;
end;

{ Запомнить последнюю успешную стадию импорта }
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
	{ Снятие запроса на монопольный доступ }
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
	{ Установка запроса на монопольный доступ }
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

end.
