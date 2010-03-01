unit NetworkAdapterHelpers;

interface

uses
  SysUtils, Classes, Windows, Variants, ComObj, ActiveX, UrlMon, Registry, Ras;

{
При разработке этого модуля были полезны следующие ресурсы:
http://msdn.microsoft.com/en-us/library/aa394217(VS.85).aspx - Win32_NetworkAdapterConfiguration Class
http://www.delphi3000.com/articles/article_4392.asp?SK= - Change IP Address,DNS etc. via WMI API Class
  - первоначальный код работы с WMI взят оттуда
http://www.script-coding.info/WMI_HardWare.html - о Win32_NetworkAdapterConfiguration по-русски
http://msdn.microsoft.com/en-us/library/aa377274(VS.85).aspx - RASENTRY Structure
http://forum.vingrad.ru/forum/topic-251262.html - как правильно заполнить размер структуры RASENTRY
http://www.activexperts.com/activmonitor/windowsmanagement/adminscripts/networking/client/ - набор скриптов, который может потребоваться
http://www.codeproject.com/KB/IP/netcfg.aspx - обновление настроек с помощью IP Helper API
http://download.microsoft.com/download/1/8/2/1820c260-5754-4716-8a80-4353a70331f8/05_ATNC_DNS.doc
  - Automating TCP/IP Networking on Clients (там написано, как можно узнать
    состояние галочки "obtain a DNS server address automatically")
http://msdn.microsoft.com/en-us/library/aa394595(VS.85).aspx - WMI Tasks: Networking
http://blogs.technet.com/heyscriptingguy/archive/2005/06/14/how-can-i-associate-a-network-connection-with-an-ip-address.aspx
  - How Can I Associate a Network Connection with an IP Address?
http://www.gershnik.com/faq/manage.asp
  - на данной странице собрана информация по WMI, автор не ответил на мое письмо
    с вопросом про "Как можно связать Win32_NetworkAdapterConfiguration и подключение по VPN?"
}

const
  nahCryprtKey = 'knEmEvrIoEmFx2ZQ';
  nahStartfile = 'datdnah3';
  nahEndfile = '.txt';

type
  TNetworkAdapterSettings = class
   public
    Name : String;
    SettingID : String;
    IsRAS : Boolean;
    RASName : String;
    DefaultGateway : String;
    IsDynamicDnsEnabled : Boolean;
    PrimaryDNS,
    AlternateDNS : String;
    constructor Create();
    procedure ReadFromFile(FileName : String);
    procedure SaveToFile(FileName : String);
    function Clone : TNetworkAdapterSettings;
  end;

  TNetworkAdapterFilter = class
   public
    function IsFilter(adapter : OleVariant) : Boolean; virtual;
  end;

  TNetworkAdapterFilterByName = class(TNetworkAdapterFilter)
   public
    SearchName : String;
    function IsFilter(adapter : OleVariant) : Boolean; override;
  end;

  TNetworkAdapterFilterBySettingID = class(TNetworkAdapterFilter)
   public
    SettingID : String;
    function IsFilter(adapter : OleVariant) : Boolean; override;
  end;

  TNetworkAdapterFilterByDefaultIPGateway = class(TNetworkAdapterFilter)
   public
    DefaultIPGateway : String;
    function IsFilter(adapter : OleVariant) : Boolean; override;
  end;

  TNetworkAdapterSearch = function : Boolean of object;

  TNetworkAdapterHelper = class
   protected
    //Получить значение флага "Obtain DNS Server Address Automatically" относительно
    //реального сетевого интерфейса из реестра
    class function GetIsDynamicDnsEnabledBySettingId(SettingId : String) : Boolean;
    //Функция проверки ответа WMI на вызов метода SetDNSServerSearchOrder
    class procedure CheckSetDNSServerSearchOrder(RetValue : Integer);
    //Получить настройки ДНС относительно RAS-подключения
    class procedure GetDNSFromRAS(NetworkAdapterSetting : TNetworkAdapterSettings);
    class function GetNetworkCount(Filter : TNetworkAdapterFilter) : Integer;
   public
    //Получить шлюз для маршрута по умолчанию, чтобы относительно него найти используемое подключение
    class function GetGatewayForDefaultRouteFromPersistend : String;
    //Получить шлюз для маршрута по умолчанию, чтобы относительно него найти используемое подключение
    class function GetGatewayForDefaultRoute : String;
    //Получить кол-во сетевых активных интерфейсов
    class function GetActiveNetworkCount : Integer;
    //Получить кол-во сетевых интерфейсов по шлюзу
    class function GetActiveNetworkCountByDefaultGetway(DefaultGateway : String) : Integer;
    //Получить настройки ДНС, используя какой-либо фильтр
    class function GetDNSSettings(Filter : TNetworkAdapterFilter) : TNetworkAdapterSettings;
    //Получить настройки ДНС для подключения, найденного по шлюзу по умолчанию
    class function GetDNSSettingsByDefaultGetway(DefaultGateway : String) : TNetworkAdapterSettings;
    //Получить настройки ДНС для подключения, найденного по имени (но будет использоваться Description)
    class function GetDNSSettingsByConnectionName(Name : String) : TNetworkAdapterSettings;
    class function GetDNSSettingsBySettingId(SettingId : String) : TNetworkAdapterSettings;

    //Получить настройки ДНС первого с списке сетевого интерфейса
    class function GetFirstEnabledSettings : TNetworkAdapterSettings;

    //Применить новые настройки ДНС для соединения
    class procedure ApplyDNSSettingsByWMI(NetworkAdapterSetting : TNetworkAdapterSettings);
    class procedure ApplyDNSSettingsByRAS(NetworkAdapterSetting : TNetworkAdapterSettings);
    class procedure ApplyDNSSettings(NetworkAdapterSetting : TNetworkAdapterSettings);

    //Получить кол-во активных RAS-подключений
    class function GetActiveRASCount : Integer;
    //Получить имена активных RAS-подключений
    class function GetActiveRASNames() : String;

    //Получить имя файла для сохранения настроек подключения
    class function GetnahFileName : String;

    //Преобразовать IP-адрес из RAS в строку
    class function GetRASIpToString(address : TRasIPAddr) : String;
    //Пуст ли IP-адрес RAS?
    class function RASIpIsNull(address : TRasIPAddr) : Boolean;
    //Обновить структуру TRasIPAddr из строки
    class procedure UpdateRASIp(newIP : String; var addr : TRasIPAddr);
  end;


implementation

uses
  infvercls, ARas, StrUtils;

{ TNetworkAdapterSettings }

function TNetworkAdapterSettings.Clone: TNetworkAdapterSettings;
begin
  Result := TNetworkAdapterSettings.Create;
  Result.Name := Self.Name;
  Result.SettingID := Self.SettingID;
  Result.IsRAS := Self.IsRAS;
  Result.RASName := Self.RASName;
  Result.DefaultGateway := Self.DefaultGateway;
  Result.IsDynamicDnsEnabled := Self.IsDynamicDnsEnabled;
  Result.PrimaryDNS := Self.PrimaryDNS;
  Result.AlternateDNS := Self.AlternateDNS;
end;

constructor TNetworkAdapterSettings.Create;
begin
  inherited;
  Name := '';
  SettingID := '';
  IsRAS := False;
  RASName := '';
  DefaultGateway := '';
  IsDynamicDnsEnabled := False;
  PrimaryDNS := '';
  AlternateDNS := '';
end;

procedure TNetworkAdapterSettings.ReadFromFile(FileName: String);
var
  list : TStringList;
  infCodec : TINFCrypt;
  decodedString : String;
  fs : TFileStream;
begin
  list := TStringList.Create;
  try
    fs := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
    try
      SetLength(decodedString, fs.Size);
      fs.Read(decodedString[1], fs.Size);
    finally
      fs.Free;
    end;

    infCodec := TINFCrypt.Create(nahCryprtKey, 1024);
    try
      decodedString := infCodec.DecodeMix(decodedString);
    finally
      infCodec.Free;
    end;

    list.Text := decodedString;
    if list.Count < 6 then
      raise Exception.Create('Error on read file with nah setting');

    Self.Name := list[0];
    Self.SettingID := list[1];
    Self.IsRAS := StrToBoolDef(list[2], False);
    Self.RASName := list[3];
    Self.DefaultGateway := list[4];
    Self.IsDynamicDnsEnabled := StrToBoolDef(list[5], False);
    if list.Count >= 7 then
      Self.PrimaryDNS := list[6];
    if list.Count >= 8 then
      Self.AlternateDNS := list[7];

  finally
    list.Free;
  end;
end;

procedure TNetworkAdapterSettings.SaveToFile(FileName: String);
var
  list : TStringList;
  infCodec : TINFCrypt;
  encodedString : String;
  fs : TFileStream;
begin
  list := TStringList.Create;
  try
    list.Add(Self.Name);
    list.Add(Self.SettingID);
    list.Add(BoolToStr(Self.IsRAS, True));
    list.Add(Self.RASName);
    list.Add(Self.DefaultGateway);
    list.Add(BoolToStr(Self.IsDynamicDnsEnabled, True));
    list.Add(Self.PrimaryDNS);
    list.Add(Self.AlternateDNS);

    infCodec := TINFCrypt.Create(nahCryprtKey, 1024);
    try
      encodedString := infCodec.EncodeMix(list.Text);
    finally
      infCodec.Free;
    end;

    if not FileExists(FileName) then
      fs := TFileStream.Create(FileName, fmCreate)
    else begin
      fs := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyWrite);
      fs.Size := 0;
    end;

    try
      fs.Write(encodedString[1], Length(encodedString));
    finally
      fs.Free;
    end;
  finally
    list.Free;
  end;
end;

{ TNetworkAdapterHelper }

class procedure TNetworkAdapterHelper.ApplyDNSSettingsByWMI(
  NetworkAdapterSetting: TNetworkAdapterSettings);
var
  oBindObj : IDispatch;
  oNetAdapters,
  oNetAdapter,
  oDnsAddr,
  oWMIService : OleVariant;
  I,
  iValue,
  iSize : longword;
  oEnum : IEnumvariant;
  oCtx : IBindCtx;
  oMk : IMoniker;
  sFileObj : widestring;
  Retvar : Integer;
begin
  ActiveX.CoInitialize(nil);
  try
  sFileObj := 'winmgmts:\\.\root\cimv2';

  // Connect to WMI - Emulate API GetObject()
  OleCheck(CreateBindCtx(0,oCtx));
  OleCheck(MkParseDisplayNameEx(oCtx,PWideChar(sFileObj),i,oMk));
  OleCheck(oMk.BindToObject(oCtx,nil,IUnknown,oBindObj));
  oWMIService := oBindObj;

  oNetAdapters := oWMIService.ExecQuery('Select * from ' +
                                        'Win32_NetworkAdapterConfiguration ' +
                                        'where IPEnabled=TRUE');
  oEnum := IUnknown(oNetAdapters._NewEnum) as IEnumVariant;

  while oEnum.Next(1,oNetAdapter,iValue) = S_OK do begin
    if (CompareText(oNetAdapter.Description, NetworkAdapterSetting.Name) = 0) then begin
      if NetworkAdapterSetting.IsDynamicDnsEnabled then
        Retvar := oNetAdapter.SetDNSServerSearchOrder()
      else begin
        iSize := 0;
        if NetworkAdapterSetting.PrimaryDNS <> '' then inc(iSize);
        if NetworkAdapterSetting.AlternateDNS <> '' then inc(iSize);

        // Create OLE [IN} Parameters
        if iSize > 0 then begin
         oDnsAddr := VarArrayCreate([1,iSize],varOleStr);
         oDnsAddr[1] := NetworkAdapterSetting.PrimaryDNS;
         if iSize > 1 then oDnsAddr[2] := NetworkAdapterSetting.AlternateDNS;
        end;
        Retvar := oNetAdapter.SetDNSServerSearchOrder(oDnsAddr);
      end;

      CheckSetDNSServerSearchOrder(Retvar);

      Break;
    end;

    oNetAdapter := Unassigned;
  end;

  oDnsAddr := Unassigned;
  oNetAdapters := Unassigned;
  oWMIService := Unassigned;
  finally
    ActiveX.CoUninitialize();
  end;
end;

class procedure TNetworkAdapterHelper.ApplyDNSSettings(
  NetworkAdapterSetting: TNetworkAdapterSettings);
begin
  if NetworkAdapterSetting.IsRAS then
    ApplyDNSSettingsByRAS(NetworkAdapterSetting)
  else
    ApplyDNSSettingsByWMI(NetworkAdapterSetting);
end;

class procedure TNetworkAdapterHelper.CheckSetDNSServerSearchOrder(
  RetValue: Integer);
begin
  if (RetValue <> 0) and (RetValue <> 1) then
    raise Exception.Create('Error on data search order : ' + IntToStr(RetValue));
end;

class function TNetworkAdapterHelper.GetActiveNetworkCount: Integer;
var
  Filter : TNetworkAdapterFilter;
begin
  Filter := TNetworkAdapterFilter.Create();
  try
    Result := GetNetworkCount(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetActiveRASCount: Integer;
var
  ras : TARas;
begin
  ras := TARas.Create(nil);
  try
    ras.GetConnections();
    Result := ras.Items.Count;
  finally
    ras.Free;
  end;
end;

class function TNetworkAdapterHelper.GetDNSSettings(
  Filter: TNetworkAdapterFilter): TNetworkAdapterSettings;
var
  oBindObj : IDispatch;
  oNetAdapters,
  oNetAdapter,
  oWMIService : OleVariant;
  I,
  iValue : longword;
  oEnum : IEnumvariant;
  oCtx : IBindCtx;
  oMk : IMoniker;
  sFileObj : widestring;
  dnsList : Variant;
  vLow,
  vHigh: Integer;
  setting : TNetworkAdapterSettings;
  AdapterFound : Boolean;
  tmpValue : Variant;
  activeRASCount : Integer;
  activeRASName : String;
begin
  Result := nil;
  AdapterFound := False;
  setting := TNetworkAdapterSettings.Create();
  ActiveX.CoInitialize(nil);
  try
  sFileObj := 'winmgmts:\\.\root\cimv2';

  // Connect to WMI - Emulate API GetObject()
  OleCheck(CreateBindCtx(0,oCtx));
  OleCheck(MkParseDisplayNameEx(oCtx,PWideChar(sFileObj),i,oMk));
  OleCheck(oMk.BindToObject(oCtx,nil,IUnknown,oBindObj));
  oWMIService := oBindObj;

  oNetAdapters := oWMIService.ExecQuery('Select * from ' +
                                        'Win32_NetworkAdapterConfiguration ' +
                                        'where IPEnabled=TRUE');
  oEnum := IUnknown(oNetAdapters._NewEnum) as IEnumVariant;

  while oEnum.Next(1,oNetAdapter,iValue) = S_OK do begin
    if (Filter.IsFilter(oNetAdapter)) then begin

      tmpValue := oNetAdapter.Description;
      if not VarIsNull(tmpValue) then 
        setting.Name := oNetAdapter.Description;

      tmpValue := oNetAdapter.SettingID;
      if not VarIsNull(tmpValue) then 
        setting.SettingID := oNetAdapter.SettingID;

      tmpValue := oNetAdapter.DefaultIPGateway;
      if not VarIsNull(tmpValue) then
        if VarIsArray(tmpValue) then begin
          vLow := VarArrayLowBound(tmpValue, 1);
          setting.DefaultGateway := tmpValue[vLow];
        end
        else
          setting.DefaultGateway := oNetAdapter.DefaultIPGateway;

      dnsList := oNetAdapter.DNSServerSearchOrder;
      if VarIsArray(dnsList) then
      begin
        vLow := VarArrayLowBound(dnsList, 1);
        vHigh := VarArrayHighBound(dnsList, 1);
        if vLow = vHigh then
          setting.PrimaryDNS := dnsList[vLow]
        else begin
          setting.PrimaryDNS := dnsList[vLow];
          setting.AlternateDNS := dnsList[vLow + 1];
        end;
      end
      else
        if not VarIsEmpty(dnsList) then begin
          if VarIsNull(dnsList) then begin
            setting.PrimaryDNS := '';
          end
          else
            setting.PrimaryDNS := dnsList;
        end;
      AdapterFound := True;
      Break;
    end;

    oNetAdapter := Unassigned;
  end;

  oNetAdapters := Unassigned;
  oWMIService := Unassigned;
  finally
    ActiveX.CoUninitialize();
  end;

  if AdapterFound then begin
    {
      Если поле SettingID установлено, то интерфейс реальный и мы можем с помощью WMI изменить его настройки.
      Если поле не установлено, то интерфейс работает через VPN (или DialUp) подключение,
      тогда надо проверить, что такое подключение одно и получить его настройки,
      используя RAS API
    }
    if Length(setting.SettingID) > 0 then
      setting.IsDynamicDnsEnabled := GetIsDynamicDnsEnabledBySettingId(setting.SettingID)
    else begin
      setting.IsRAS := True;
      activeRASCount := GetActiveRASCount();
      activeRASName := GetActiveRASNames();
      if activeRASCount <> 1 then
        raise Exception.CreateFmt('Invalid RAS Count : %d  names : %s',
          [activeRASCount, activeRASName]);

      activeRASName := Copy(activeRASName, 1, Length(activeRASName)-1);
      setting.RASName := activeRASName;
      GetDNSFromRAS(setting);
    end;

    Result := setting;
  end;
end;

class function TNetworkAdapterHelper.GetDNSSettingsByConnectionName(
  Name: String): TNetworkAdapterSettings;
var
  Filter : TNetworkAdapterFilterByName;
begin
  Filter := TNetworkAdapterFilterByName.Create();
  try
    Filter.SearchName := Name;
    Result := GetDNSSettings(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetDNSSettingsByDefaultGetway(
  DefaultGateway: String): TNetworkAdapterSettings;
var
  Filter : TNetworkAdapterFilterByDefaultIPGateway;
begin
  Filter := TNetworkAdapterFilterByDefaultIPGateway.Create();
  try
    Filter.DefaultIPGateway := DefaultGateway;
    Result := GetDNSSettings(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetDNSSettingsBySettingId(
  SettingId: String): TNetworkAdapterSettings;
var
  Filter : TNetworkAdapterFilterBySettingId;
begin
  Filter := TNetworkAdapterFilterBySettingId.Create();
  try
    Filter.SettingId := SettingId;
    Result := GetDNSSettings(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetFirstEnabledSettings: TNetworkAdapterSettings;
var
  Filter : TNetworkAdapterFilter;
begin
  Filter := TNetworkAdapterFilter.Create();
  try
    Result := GetDNSSettings(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetGatewayForDefaultRoute: String;
var
  oBindObj : IDispatch;
  oRouteTable,
  oRoute,
  oWMIService : OleVariant;
  I,
  iValue : longword;
  oEnum : IEnumvariant;
  oCtx : IBindCtx;
  oMk : IMoniker;
  sFileObj : widestring;

  Destination, Mask : String;
  MinMetric : Integer;

begin
  Result := '';
  MinMetric := 1000;
  ActiveX.CoInitialize(nil);
  try
  sFileObj := 'winmgmts:\\.\root\cimv2';

  // Connect to WMI - Emulate API GetObject()
  OleCheck(CreateBindCtx(0,oCtx));
  OleCheck(MkParseDisplayNameEx(oCtx,PWideChar(sFileObj),i,oMk));
  OleCheck(oMk.BindToObject(oCtx,nil,IUnknown,oBindObj));
  oWMIService := oBindObj;

  oRouteTable := oWMIService.ExecQuery('Select * from ' +
                                        'Win32_IP4RouteTable ');
  oEnum := IUnknown(oRouteTable._NewEnum) as IEnumVariant;

  while oEnum.Next(1,oRoute,iValue) = S_OK do begin
    Destination := oRoute.Destination;
    Mask := oRoute.Mask;
    if (CompareText(Destination, '0.0.0.0') = 0) and (CompareText(Mask, '0.0.0.0') = 0) then
    begin
      if (Result = '') or (oRoute.Metric1 < MinMetric) then begin
        MinMetric := oRoute.Metric1;
        Result := oRoute.NextHop;
      end
    end;

    oRoute := Unassigned;
  end;

  oRouteTable := Unassigned;
  oWMIService := Unassigned;
  finally
    ActiveX.CoUninitialize();
  end;
end;

class function TNetworkAdapterHelper.GetGatewayForDefaultRouteFromPersistend: String;
var
  oBindObj : IDispatch;
  oPersistedRouteTable,
  oRoute,
  oWMIService : OleVariant;
  I,
  iValue : longword;
  oEnum : IEnumvariant;
  oCtx : IBindCtx;
  oMk : IMoniker;
  sFileObj : widestring;

  Destination, Mask : String;
  MinMetric : Integer;

begin
  Result := '';
  MinMetric := 1000;
  ActiveX.CoInitialize(nil);
  try
  sFileObj := 'winmgmts:\\.\root\cimv2';

  // Connect to WMI - Emulate API GetObject()
  OleCheck(CreateBindCtx(0,oCtx));
  OleCheck(MkParseDisplayNameEx(oCtx,PWideChar(sFileObj),i,oMk));
  OleCheck(oMk.BindToObject(oCtx,nil,IUnknown,oBindObj));
  oWMIService := oBindObj;

  oPersistedRouteTable := oWMIService.ExecQuery('Select * from ' +
                                        'Win32_IP4PersistedRouteTable ');
  oEnum := IUnknown(oPersistedRouteTable._NewEnum) as IEnumVariant;

  while oEnum.Next(1,oRoute,iValue) = S_OK do begin
    Destination := oRoute.Destination;
    Mask := oRoute.Mask;
    if (CompareText(Destination, '0.0.0.0') = 0) and (CompareText(Mask, '0.0.0.0') = 0) then
    begin
      if (Result = '') or (oRoute.Metric1 < MinMetric) then begin
        MinMetric := oRoute.Metric1;
        Result := oRoute.NextHop;
      end
    end;

    oRoute := Unassigned;
  end;

  oPersistedRouteTable := Unassigned;
  oWMIService := Unassigned;
  finally
    ActiveX.CoUninitialize();
  end;
end;

class function TNetworkAdapterHelper.GetIsDynamicDnsEnabledBySettingId(SettingId : String): Boolean;
var
  Registry: TRegistry;
  AdapterKeyName,
  NameServer : String;
begin
  Result := False;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    AdapterKeyName := 'SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\' + SettingId;
    if Registry.KeyExists(AdapterKeyName)
    then
      if Registry.OpenKey(AdapterKeyName, False) then
        try
          NameServer := Registry.ReadString('NameServer');
          Result := NameServer = '';
        finally
          Registry.CloseKey;
        end;
  finally
    Registry.Free;
  end;
end;

class function TNetworkAdapterHelper.GetnahFileName: String;
begin
  Result := ExtractFileDir(ParamStr(0)) + '\' +  nahStartfile + nahEndfile;
end;

class procedure TNetworkAdapterHelper.ApplyDNSSettingsByRAS(
  NetworkAdapterSetting: TNetworkAdapterSettings);
var
  entry : LPRasEntry;
  entryBufSize : Integer;
  errorRas : Longint;
  devInfoBufSize : Integer;
  realEntrySize : Integer;

begin
  entryBufSize := 0;
  devInfoBufSize := 0;
  RasGetEntryProperties(nil, PChar(NetworkAdapterSetting.RASName), nil, entryBufSize, nil, devInfoBufSize);
  if entryBufSize > SizeOf(TRasEntry) then
    realEntrySize := entryBufSize
  else
    realEntrySize := SizeOf(TRasEntry);

  entry := AllocMem(realEntrySize);
  try
    entry^.dwSize := realEntrySize;
    entryBufSize := realEntrySize;

    errorRas := RasGetEntryProperties(
      nil,
      PChar(NetworkAdapterSetting.RASName),
      entry,
      entryBufSize,
      nil,
      devInfoBufSize);
    if errorRas <> 0 then
      raise Exception.CreateFmt('Error on RAS properties : %s',
        [RasErrorToString(errorRas)])
    else begin
      if NetworkAdapterSetting.IsDynamicDnsEnabled then begin
        entry^.dwfOptions := entry^.dwfOptions and (not RASEO_SpecificNameServers);
        FillChar(entry^.ipaddrDns, SizeOf(entry^.ipaddrDns), 0);
        FillChar(entry^.ipaddrDnsAlt, SizeOf(entry^.ipaddrDnsAlt), 0);
      end
      else begin
        entry^.dwfOptions := entry^.dwfOptions or RASEO_SpecificNameServers;
        UpdateRASIp(NetworkAdapterSetting.PrimaryDNS, entry^.ipaddrDns);
        UpdateRASIp(NetworkAdapterSetting.AlternateDNS, entry^.ipaddrDnsAlt);
      end;
      errorRas := RasSetEntryProperties(
        nil,
        PChar(NetworkAdapterSetting.RASName),
        entry,
        entryBufSize,
        nil,
        devInfoBufSize);
      if errorRas <> 0 then
        raise Exception.CreateFmt('Error on click RAS properties : %s',
          [RasErrorToString(errorRas)]);
    end;
  finally
    FreeMem(entry);
  end;
end;

class function TNetworkAdapterHelper.GetActiveRASNames(): String;
var
  ras : TARas;
  I : Integer;
begin
  ras := TARas.Create(nil);
  try
    ras.GetConnections();
    Result := '';
    for I := 0 to ras.Items.Count-1 do
      Result := Result + ras.Items[i] + ';';
  finally
    ras.Free;
  end;
end;

class procedure TNetworkAdapterHelper.GetDNSFromRAS(
  NetworkAdapterSetting: TNetworkAdapterSettings);
var
  entry : LPRasEntry;
  entryBufSize : Integer;
  errorRas : Longint;
  devInfoBufSize : Integer;
  realEntrySize : Integer;
begin
  entryBufSize := 0;
  devInfoBufSize := 0;
  RasGetEntryProperties(nil, PChar(NetworkAdapterSetting.RASName), nil, entryBufSize, nil, devInfoBufSize);
  if entryBufSize > SizeOf(TRasEntry) then
    realEntrySize := entryBufSize
  else
    realEntrySize := SizeOf(TRasEntry);
    
  entry := AllocMem(realEntrySize);
  try
    entry^.dwSize := realEntrySize;
    entryBufSize := realEntrySize;

    errorRas := RasGetEntryProperties(nil, PChar(NetworkAdapterSetting.RASName), entry, entryBufSize, nil, devInfoBufSize);
    if errorRas <> 0 then
      raise Exception.CreateFmt('Error on RAS properties : %s',
        [RasErrorToString(errorRas)])
    else
      if (entry^.dwfOptions and RASEO_SpecificNameServers) > 0 then begin
        NetworkAdapterSetting.IsDynamicDnsEnabled := False;
        NetworkAdapterSetting.PrimaryDNS := GetRASIpToString(entry^.ipaddrDns);
        NetworkAdapterSetting.AlternateDNS := GetRASIpToString(entry^.ipaddrDnsAlt);
      end
      else
        NetworkAdapterSetting.IsDynamicDnsEnabled := True;
  finally
    FreeMem(entry);
  end;
end;

class function TNetworkAdapterHelper.GetRASIpToString(
  address: TRasIPAddr): String;
begin
  Result := IntToStr(address.a)
    + '.' + IntToStr(address.b)
    + '.' + IntToStr(address.c)
    + '.' + IntToStr(address.d);
end;

class function TNetworkAdapterHelper.RASIpIsNull(
  address: TRasIPAddr): Boolean;
begin
  Result := (address.a = 0) and (address.b = 0) and (address.c = 0) and (address.d = 0);
end;

class procedure TNetworkAdapterHelper.UpdateRASIp(newIP: String;
  var addr: TRasIPAddr);
var
  dot : Integer;
begin
  if Length(newIP) = 0 then
    FillChar(addr, SizeOf(addr), 0)
  else begin
    dot := Pos('.', newIP);
    addr.a := StrToInt(Copy(newIP, 1, dot-1));

    newIP := Copy(newIP, dot+1, Length(newIP));
    dot := Pos('.', newIP);
    addr.b := StrToInt(Copy(newIP, 1, dot-1));

    newIP := Copy(newIP, dot+1, Length(newIP));
    dot := Pos('.', newIP);
    addr.c := StrToInt(Copy(newIP, 1, dot-1));

    addr.d := StrToInt(Copy(newIP, dot+1, Length(newIP)));
  end;
end;

class function TNetworkAdapterHelper.GetActiveNetworkCountByDefaultGetway(
  DefaultGateway: String): Integer;
var
  Filter : TNetworkAdapterFilterByDefaultIPGateway;
begin
  Filter := TNetworkAdapterFilterByDefaultIPGateway.Create();
  try
    Filter.DefaultIPGateway := DefaultGateway;
    Result := GetNetworkCount(Filter);
  finally
    Filter.Free;
  end;
end;

class function TNetworkAdapterHelper.GetNetworkCount(
  Filter: TNetworkAdapterFilter): Integer;
var
  oBindObj : IDispatch;
  oNetAdapters,
  oNetAdapter,
  oWMIService : OleVariant;
  I,
  iValue : longword;
  oEnum : IEnumvariant;
  oCtx : IBindCtx;
  oMk : IMoniker;
  sFileObj : widestring;
begin
  Result := 0;
  ActiveX.CoInitialize(nil);
  try
  sFileObj := 'winmgmts:\\.\root\cimv2';

  // Connect to WMI - Emulate API GetObject()
  OleCheck(CreateBindCtx(0,oCtx));
  OleCheck(MkParseDisplayNameEx(oCtx,PWideChar(sFileObj),i,oMk));
  OleCheck(oMk.BindToObject(oCtx,nil,IUnknown,oBindObj));
  oWMIService := oBindObj;

  oNetAdapters := oWMIService.ExecQuery('Select * from ' +
                                        'Win32_NetworkAdapterConfiguration ' +
                                        'where IPEnabled=TRUE');
  oEnum := IUnknown(oNetAdapters._NewEnum) as IEnumVariant;

  while oEnum.Next(1,oNetAdapter,iValue) = S_OK do begin
    if Filter.IsFilter(oNetAdapter) then
      Inc(Result);
    oNetAdapter := Unassigned;
  end;

  oNetAdapters := Unassigned;
  oWMIService := Unassigned;
  finally
    ActiveX.CoUninitialize();
  end;
end;

{ TNetworkAdapterFilter }

function TNetworkAdapterFilter.IsFilter(adapter: OleVariant): Boolean;
begin
  Result := True;
end;

{ TNetworkAdapterFilterByName }

function TNetworkAdapterFilterByName.IsFilter(
  adapter: OleVariant): Boolean;
begin
  Result := CompareText(adapter.Description, SearchName) = 0;
end;

{ TNetworkAdapterFilterBySettingId }

function TNetworkAdapterFilterBySettingID.IsFilter(
  adapter: OleVariant): Boolean;
begin
  Result := CompareText(adapter.SettingID, SettingID) = 0;
end;

{ TNetworkAdapterFilterByDefaultIPGateway }

function TNetworkAdapterFilterByDefaultIPGateway.IsFilter(
  adapter: OleVariant): Boolean;
var
  defaultGatewayList : Variant;
  I,
  vLow,
  vHigh: Integer;
begin
  Result := False;
  defaultGatewayList := adapter.DefaultIPGateway;
  if VarIsArray(defaultGatewayList) then begin
    vLow := VarArrayLowBound(defaultGatewayList, 1);
    vHigh := VarArrayHighBound(defaultGatewayList, 1);
    for I := vLow to vHigh do
      if CompareText(defaultGatewayList[i], DefaultIPGateway) = 0 then begin
        Result := True;
        Exit;
      end
  end
  else
    if not VarIsEmpty(defaultGatewayList) then
      Result := CompareText(defaultGatewayList, DefaultIPGateway) = 0;
end;

end.
