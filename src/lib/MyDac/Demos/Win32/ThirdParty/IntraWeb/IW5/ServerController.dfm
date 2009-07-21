object IWServerController: TIWServerController
  OldCreateOrder = True
  AppName = 'MyIWApp'
  ComInitialization = ciNone
  SessionTrackingMethod = tmURL
  Description = 'MySQL Data Access Demo - IntraWeb'
  DestinationDevice = ddWeb
  ExceptionDisplayMode = smAlert
  ExecCmd = 'EXEC'
  HistoryEnabled = False
  Port = 0
  RestrictIPs = False
  ShowResyncWarning = True
  SessionTimeout = 10
  SSLPort = 0
  SupportedBrowsers = [brIE, brNetscape6, brOpera]
  OnNewSession = IWServerControllerBaseNewSession
  Left = 171
  Top = 149
  Height = 105
  Width = 206
end
