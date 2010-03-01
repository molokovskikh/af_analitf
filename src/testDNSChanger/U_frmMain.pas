unit U_frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  NetworkAdapterHelpers,
  U_ExchangeLog;

type
  TfrmMain = class(TForm)
    btnChange: TButton;
    btnGetNotFoundAdapter: TButton;
    btnGetRoute: TButton;
    btnNetworkCount: TButton;
    btnGetPath: TButton;
    btnReadAndWrite: TButton;
    mLog: TMemo;
    btnGetActiveRas: TButton;
    btnTestUpdateRASIp: TButton;
    btnUpdateRASIp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnGetNotFoundAdapterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGetRouteClick(Sender: TObject);
    procedure btnNetworkCountClick(Sender: TObject);
    procedure btnGetPathClick(Sender: TObject);
    procedure btnReadAndWriteClick(Sender: TObject);
    procedure btnGetActiveRasClick(Sender: TObject);
    procedure btnTestUpdateRASIpClick(Sender: TObject);
    procedure btnUpdateRASIpClick(Sender: TObject);
  private
    { Private declarations }
    PreviousAdapter : TNetworkAdapterSettings;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses ComObj, ActiveX, UrlMon, ARas, Ras;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  DefaultGatewayFromActiveRoutes : String;
  t : TNetworkAdapterSettings;
begin
  DefaultGatewayFromActiveRoutes := TNetworkAdapterHelper.GetGatewayForDefaultRoute();
  PreviousAdapter := TNetworkAdapterHelper.GetDNSSettingsByDefaultGetway(DefaultGatewayFromActiveRoutes);
  Assert(Assigned(PreviousAdapter), 'Адаптер "Подключение по локальной сети" не найден');
end;

procedure TfrmMain.btnChangeClick(Sender: TObject);
var
  changed : TNetworkAdapterSettings;
  test : TNetworkAdapterSettings;
begin
  changed := TNetworkAdapterHelper.GetDNSSettingsByConnectionName(PreviousAdapter.Name);
  try
    //195.98.64.65
    mLog.Lines.Add('after get');
    mLog.Lines.Add('IsDynamicDnsEnabled = ' + BoolToStr(changed.IsDynamicDnsEnabled, True));
    mLog.Lines.Add('PrimaryDNS = ' + changed.PrimaryDNS);
    mLog.Lines.Add('AlternateDNS = ' + changed.AlternateDNS);
    if changed.PrimaryDNS = '195.98.64.65' then begin
      changed.IsDynamicDnsEnabled := True;
      changed.PrimaryDNS := '';
      changed.AlternateDNS := '';
    end
    else begin
      changed.IsDynamicDnsEnabled := False;
      changed.AlternateDNS := changed.PrimaryDNS;
      changed.PrimaryDNS := '195.98.64.65';
    end;
    mLog.Lines.Add('Before change');
    mLog.Lines.Add('IsDynamicDnsEnabled = ' + BoolToStr(changed.IsDynamicDnsEnabled, True));
    mLog.Lines.Add('PrimaryDNS = ' + changed.PrimaryDNS);
    mLog.Lines.Add('AlternateDNS = ' + changed.AlternateDNS);
    TNetworkAdapterHelper.ApplyDNSSettings(changed);

    test := TNetworkAdapterHelper.GetDNSSettingsByConnectionName(changed.Name);
    try
      mLog.Lines.Add('in test');
      mLog.Lines.Add('IsDynamicDnsEnabled = ' + BoolToStr(test.IsDynamicDnsEnabled, True));
      mLog.Lines.Add('PrimaryDNS = ' + test.PrimaryDNS);
      mLog.Lines.Add('AlternateDNS = ' + test.AlternateDNS);
      Assert(changed.IsDynamicDnsEnabled = test.IsDynamicDnsEnabled, 'не совпадает галочка');
      if not changed.IsDynamicDnsEnabled then begin
        Assert(changed.PrimaryDNS = test.PrimaryDNS, 'не совпадает первичный днс');
        Assert(changed.AlternateDNS = test.AlternateDNS, 'не совпадает альтернативный днс');
      end
      else begin
        Assert(changed.PrimaryDNS = '', 'не совпадает первичный днс для измененного');
        Assert(changed.AlternateDNS = '', 'не совпадает альтернативный днс для измененного');
        Assert(test.PrimaryDNS = PreviousAdapter.PrimaryDNS, 'не совпадает первичный днс для полученного');
        Assert(test.AlternateDNS = PreviousAdapter.AlternateDNS, 'не совпадает альтернативный днс для полученного');
      end;
    finally
      test.Free;
    end;
  finally
    changed.Free;
  end;
end;

{
Где надо менять:
если в программе установлено соединение, то у него.
Если нет соединения, то смотрим на постоянный маршрут по умолчанию и определяем для него соединение,
тогда у этого соединения устанавливаем ДНС.

Это все имеет место, если операционная система от Win2000 до Vista (не включая).

При подмене DNS надо формировать зашифрованный файл с данными:
 - для какого соединения изменили настройки
 - был ли там статичный ДНС
 - если был, то его значения

При возврате надо восстанавливать настройки из этого файла и удалять его
}

procedure TfrmMain.btnGetNotFoundAdapterClick(Sender: TObject);
var
  adapter : TNetworkAdapterSettings;
begin
  adapter := TNetworkAdapterHelper.GetDNSSettingsByConnectionName('dsdsd');
  Assert(not Assigned(adapter), 'Адаптер найден');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //TNetworkAdapterHelper.ApplyDNSSettings(PreviousAdapter);
end;

procedure TfrmMain.btnGetRouteClick(Sender: TObject);
var
  DefaultGateway,
  DefaultGatewayFromActiveRoutes : String;
  t : TNetworkAdapterSettings;
begin
  //DefaultGateway := TNetworkAdapterHelper.GetGatewayForDefaultRouteFromPersistend();
  DefaultGatewayFromActiveRoutes := TNetworkAdapterHelper.GetGatewayForDefaultRoute();
  ShowMessage(DefaultGatewayFromActiveRoutes);
  //Assert(DefaultGateway <> '', 'не найден маршрут по умолчанию');
  Assert(DefaultGatewayFromActiveRoutes <> '', 'не найден маршрут по умолчанию');
  //Assert(DefaultGateway = DefaultGatewayFromActiveRoutes, 'маршруты не совпадают');
  t := TNetworkAdapterHelper.GetDNSSettingsByDefaultGetway(DefaultGatewayFromActiveRoutes);
  ShowMessage(Format('Name : %s  SettingId : %s', [t.Name, t.SettingID]));
end;

procedure TfrmMain.btnNetworkCountClick(Sender: TObject);
var
  NetworkCount : Integer;
  NetworkCountByFilter : Integer;
  DefaultGatewayFromActiveRoutes : String;
begin
  NetworkCount := TNetworkAdapterHelper.GetActiveNetworkCount();
  mLog.Lines.Add('NetworkCount = ' + IntToStr(NetworkCount));
  Assert(NetworkCount > 0, 'нет активных сетей');
  DefaultGatewayFromActiveRoutes := TNetworkAdapterHelper.GetGatewayForDefaultRoute();
  NetworkCountByFilter := TNetworkAdapterHelper.GetActiveNetworkCountByDefaultGetway(DefaultGatewayFromActiveRoutes);
  mLog.Lines.Add('NetworkCountByFilter = ' + IntToStr(NetworkCountByFilter));
  Assert(NetworkCountByFilter > 0, 'нет активных сетей');
  Assert(NetworkCountByFilter = 1, 'на один шлюз ссылаются больше одного интерфейса');
end;

procedure TfrmMain.btnGetPathClick(Sender: TObject);
var
  fn : String;
begin
  fn := TNetworkAdapterHelper.GetnahFileName;
  Assert(fn <> '', 'не получилось сформировать файл');
end;

procedure TfrmMain.btnReadAndWriteClick(Sender: TObject);
var
  test : TNetworkAdapterSettings;
begin
  PreviousAdapter.SaveToFile(TNetworkAdapterHelper.GetnahFileName());
  test := TNetworkAdapterSettings.Create;
  try
    test.ReadFromFile(TNetworkAdapterHelper.GetnahFileName());
    Assert(PreviousAdapter.Name = test.Name, 'не совпадает Name');
    Assert(PreviousAdapter.SettingId = test.SettingId, 'не совпадает SettingId');
    Assert(PreviousAdapter.IsRAS = test.IsRAS, 'не совпадает IsRAS');
    Assert(PreviousAdapter.RASName = test.RASName, 'не совпадает RASName');
    Assert(PreviousAdapter.DefaultGateway = test.DefaultGateway, 'не совпадает DefaultGateway');
    Assert(PreviousAdapter.IsDynamicDnsEnabled = test.IsDynamicDnsEnabled, 'не совпадает галочка');
    Assert(PreviousAdapter.PrimaryDNS = test.PrimaryDNS, 'не совпадает первичный днс');
    Assert(PreviousAdapter.AlternateDNS = test.AlternateDNS, 'не совпадает альтернативный днс');
  finally
    test.Free;
  end;
end;

procedure TfrmMain.btnGetActiveRasClick(Sender: TObject);
var
  ras : TARas;
  I : Integer;
  connectedEntry: String;
  hRas: THRasConn;
  entry : LPRasEntry;
  entryBufSize : Integer;
  devInfoBufSize : Integer;
  errorRas : Longint;
  realEntrySize : Integer;

  function GetIpToString(address : TRasIPAddr) : String;
  begin
    Result := IntToStr(address.a)
      + '.' + IntToStr(address.b)
      + '.' + IntToStr(address.c)
      + '.' + IntToStr(address.d);
  end;

  function IpIsNull(address : TRasIPAddr) : Boolean;
  begin
    Result := (address.a = 0) and (address.b = 0) and (address.c = 0) and (address.d = 0);
  end;

begin
  ras := TARas.Create(nil);
  try
    mLog.Lines.Add('GetEntries()');
    ras.GetEntries();
    for I := 0 to ras.Items.Count-1 do begin
      mLog.Lines.Add('RasEntry : ' + ras.Items[i]);
    end;
    mLog.Lines.Add('GetConnections()');
    ras.GetConnections();
    connectedEntry := '';
    for I := 0 to ras.Items.Count-1 do begin
      mLog.Lines.Add('Connection : ' + ras.Items[i]);
      connectedEntry := ras.Items[i];
      hRas := Integer(ras.Items.Objects[i]);
    end;

    if Length(connectedEntry) > 0 then begin
    //Entries^.dwSize:=SizeOf(TRasEntryName);
    entryBufSize := 0;
    devInfoBufSize := 0;
    errorRas := RasGetEntryProperties(nil, PChar(connectedEntry), nil, entryBufSize, nil, devInfoBufSize);
    mLog.Lines.Add('entryBufSize after test get: ' + IntToStr(entryBufSize));
    mLog.Lines.Add('SizeOf(TRasEntry) : ' + IntToStr(SizeOf(TRasEntry)));
    if errorRas <> 0 then
      ShowMessageFmt('Ошибка при получении размера структуры : %d', [errorRas]);
    if entryBufSize > SizeOf(TRasEntry) then
      realEntrySize := entryBufSize
    else
      realEntrySize := SizeOf(TRasEntry);

    entry := AllocMem(realEntrySize);
    try
      FillChar(entry^, realEntrySize, 0);
      entry^.dwSize := realEntrySize;
      entryBufSize := realEntrySize;
      mLog.Lines.Add('entryBufSize before get: ' + IntToStr(entryBufSize));

      devInfoBufSize := 0;

      errorRas := RasGetEntryProperties(nil, PChar(connectedEntry), entry, entryBufSize, nil, devInfoBufSize);
      mLog.Lines.Add('Flags after first get: ' + IntToStr(entry^.dwfOptions));
      if errorRas <> 0 then
        ShowMessageFmt('Ошибка при получении свойств : %d', [errorRas])
      else begin
        mLog.Lines.Add('entryBufSize after get: ' + IntToStr(entryBufSize));
        mLog.Lines.Add('EntryProperties : ');
        mLog.Lines.Add('DNS     : ' + GetIpToString(entry^.ipaddrDns));
        mLog.Lines.Add('DNS Alt : ' + GetIpToString(entry^.ipaddrDnsAlt));
        mLog.Lines.Add('Device  : ' + entry^.szDeviceName);
        mLog.Lines.Add('DeviceType: ' + entry^.szDeviceType);
        if IpIsNull(entry^.ipaddrDns) then begin
          entry^.ipaddrDns.a := 91;
          entry^.ipaddrDns.b := 209;
          entry^.ipaddrDns.c := 124;
          entry^.ipaddrDns.d := 65;
          entry^.dwfOptions := entry^.dwfOptions or RASEO_SpecificNameServers;
          mLog.Lines.Add('Flags after change: ' + IntToStr(entry^.dwfOptions));
          devInfoBufSize := 0;
          errorRas := RasSetEntryProperties(nil, PChar(connectedEntry), entry, entryBufSize, nil, devInfoBufSize);
          if errorRas <> 0 then
            ShowMessageFmt('Ошибка при изменении свойств : %d', [errorRas])
          else begin
            FillChar(entry^, realEntrySize, 0);
            entry^.dwSize := realEntrySize;
            entryBufSize := realEntrySize;
            devInfoBufSize := 0;
            errorRas := RasGetEntryProperties(nil, PChar(connectedEntry), entry, entryBufSize, nil, devInfoBufSize);
            mLog.Lines.Add('Flags after get after change: ' + IntToStr(entry^.dwfOptions));
            if (entry^.dwfOptions and RASEO_SpecificNameServers) > 0 then
              mLog.Lines.Add('RASEO_SpecificNameServers in Flags');
            mLog.Lines.Add('PrimaryDNS : ' + GetIpToString(entry^.ipaddrDns));
          end;
        end;
      end;
    finally
      FreeMem(entry);
    end;
    end;
  finally
    ras.Free;
  end;
end;

procedure TfrmMain.btnTestUpdateRASIpClick(Sender: TObject);
var
  addr : TRasIPAddr;
  I, J, K, L : Integer;
  newIp : String;
begin
  TNetworkAdapterHelper.UpdateRASIp('', addr);
  Assert(addr.a = 0);
  Assert(addr.b = 0);
  Assert(addr.c = 0);
  Assert(addr.d = 0);
  for I := 1 to 3 do
    for J := 1 to 3 do
      for K := 1 to 3 do
        for L := 1 to 3 do begin
          newIp :=  StringOfChar('1', i)
            + '.' + StringOfChar('1', j)
            + '.' + StringOfChar('1', k)
            + '.' + StringOfChar('1', l);
          TNetworkAdapterHelper.UpdateRASIp(newIp, addr);
          Assert(addr.a = StrToInt(StringOfChar('1', i)));
          Assert(addr.b = StrToInt(StringOfChar('1', j)));
          Assert(addr.c = StrToInt(StringOfChar('1', k)));
          Assert(addr.d = StrToInt(StringOfChar('1', l)));
        end;
end;

procedure TfrmMain.btnUpdateRASIpClick(Sender: TObject);
var
  entry : LPRasEntry;
  entryBufSize : Integer;
  errorRas : Longint;
  devInfoBufSize : Integer;
  realEntrySize : Integer;

begin
  entryBufSize := 0;
  devInfoBufSize := 0;
  RasGetEntryProperties(nil, PChar('vpn.analit.net'), nil, entryBufSize, nil, devInfoBufSize);
  if entryBufSize > SizeOf(TRasEntry) then
    realEntrySize := entryBufSize
  else
    realEntrySize := SizeOf(TRasEntry);

  entry := AllocMem(realEntrySize);
  try
    FillChar(entry^.ipaddrDns, SizeOf(entry^.ipaddrDns), 0);
    TNetworkAdapterHelper.UpdateRASIp('111.111.111.111', entry^.ipaddrDns);
    Assert(entry^.ipaddrDns.a = 111, 'не совпадает цифра');
  finally
    FreeMem(entry);
  end;
end;

end.
