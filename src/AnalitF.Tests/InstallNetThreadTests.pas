unit InstallNetThreadTests;

interface

uses
  SysUtils,
  Windows,
  Classes,
  TestFrameWork,
  IdHTTP,
  U_InstallNetThread;

type
  TTestInstallNetThread = class(TTestCase)
   protected
    FInstallNetThread : TInstallNetThread;
    procedure SetUp; override;
    procedure TearDown; override;
   published
    procedure SimpleCreate;
    procedure GetInstallNet;
  end;

implementation

{ TTestInstallNetThread }

procedure TTestInstallNetThread.GetInstallNet;
var
  idHttp: TIdHttp;
  i : Integer;
  url : String;
begin
  idHttp := TIdHTTP.Create;
  try
//    url := 'http://www.microsoft.com/en-us/download/confirmation.aspx?id=17718';
    url := 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe';
    idHttp.Head(url);
    Status('request: ' + url);
    for i := 0 to idHttp.Response.RawHeaders.Count-1 do
      Status(idHttp.Response.RawHeaders[i]);
  finally
    idHttp.Free;
  end;    
end;

procedure TTestInstallNetThread.SetUp;
begin
  FInstallNetThread := TInstallNetThread.Create(True);
end;

procedure TTestInstallNetThread.SimpleCreate;
begin
  CheckNotNull(FInstallNetThread);
end;

procedure TTestInstallNetThread.TearDown;
begin
  FreeAndNil(FInstallNetThread);
end;

initialization
  TestFramework.RegisterTest(TTestInstallNetThread.Suite);
end.