unit ExternalOrders;

interface

uses Windows, SysUtils, StdCtrls, ComCtrls, Classes, Forms, ActiveX, Dialogs,
     pFIBDatabase;

type

{ �������� ����� ��������� ������� ���������� �  ������}
{   AHandle := Application.Handle }
TExternalOrdersConfig = procedure(
  Connection: TpFIBDatabase;
	AHandle: THandle);

{�������� ������� ������� ���������}
{  OrderID - �����, ������� ����� ����������}
{  ���� ������� ���������� True, �� ����� ����� �������� ��� ������������}
TExternalOrdersThreading = function(
  AHandle: THandle;
  Connection: TpFIBDatabase;
  OrderID : Integer;
	inStStatus: TLabel;
  inProgressBar: TProgressBar;
	inTotalProgressBar: TProgressBar;
  var ErrorStr : PChar) : Boolean;

{�������� ����, ��� ����� �������� �������}
TExternalOrdersPriceIsProtek = function(
  Connection: TpFIBDatabase;
  AOrderId : Integer) : Boolean;

{������ ��������� "������" ��� ��������� �������}
TExternalOrdersRun = function(
  AHandle: THandle;
  Connection: TpFIBDatabase;
  var ErrorStr : PChar) : Boolean;

TExternalOrdersClearTempDirectory = procedure;

procedure LoadExternalOrdersDLL;
procedure UnLoadExternalOrdersDLL;
function IsExternalOrdersDLLPresent: Boolean;

procedure RunExternalOrders;

var
  ExternalOrdersConfig        : TExternalOrdersConfig = nil;
  ExternalOrdersThreading     : TExternalOrdersThreading = nil;
  ExternalOrdersPriceIsProtek : TExternalOrdersPriceIsProtek = nil;
  ExternalOrdersRun           : TExternalOrdersRun = nil;
  ExternalOrdersClearTempDirectory : TExternalOrdersClearTempDirectory = nil;

implementation

uses
  DModule, Waiting, AProc;

type
  TRunExternalOrders = class(TThread)
   protected
    procedure Execute; override;
  end;

var
	hExternalOrdersDLL: THandle;
  RunExternalOrdersError : String;


procedure LoadExternalOrdersDLL;
begin
  hExternalOrdersDLL := LoadLibrary( 'ExternalOrders.dll');
  if hExternalOrdersDLL <> 0 then
    try
      @ExternalOrdersConfig        := GetProcAddress( hExternalOrdersDLL, 'ExternalOrdersConfig');
      @ExternalOrdersThreading     := GetProcAddress( hExternalOrdersDLL, 'ExternalOrdersThreading');
      @ExternalOrdersPriceIsProtek := GetProcAddress( hExternalOrdersDLL, 'ExternalOrdersPriceIsProtek');
      @ExternalOrdersRun           := GetProcAddress( hExternalOrdersDLL, 'ExternalOrdersRun');
      @ExternalOrdersClearTempDirectory := GetProcAddress( hExternalOrdersDLL, 'ExternalOrdersClearTempDirectory');
    except
    end;
end;

procedure UnLoadExternalOrdersDLL;
begin
  FreeLibrary(hExternalOrdersDLL);
  ExternalOrdersConfig := nil;
  ExternalOrdersThreading := nil;
  ExternalOrdersPriceIsProtek := nil;
  ExternalOrdersRun := nil;
  ExternalOrdersClearTempDirectory := nil;
  hExternalOrdersDLL := 0;
end;

function IsExternalOrdersDLLPresent: Boolean;
begin
	Result := (hExternalOrdersDLL <> 0)
    and (Assigned(ExternalOrdersConfig))
    and (Assigned(ExternalOrdersThreading))
    and (Assigned(ExternalOrdersPriceIsProtek))
    and (Assigned(ExternalOrdersRun))
    and (Assigned(ExternalOrdersClearTempDirectory));
end;

procedure RunExternalOrders;
var
  RunT : TRunExternalOrders;
begin
  RunExternalOrdersError := '';
  RunT := TRunExternalOrders.Create(True);
  RunT.FreeOnTerminate := True;
  ShowWaiting('���������� �������� ������� �������. ���������...', RunT);
  if Length(RunExternalOrdersError) <> 0 then
    MessageBox('�� ����� ������� ��������� "������" ��������� ������ : ' + RunExternalOrdersError, MB_ICONSTOP)
end;

{ TRunExternalOrders }

procedure TRunExternalOrders.Execute;
var
  ExternalRes : Boolean;
  ErrorStr : PChar;
  ExtErrorMessage : String;
begin
  try
    ExternalRes := ExternalOrdersRun(
      Application.Handle,
      DM.MainConnection1,
      ErrorStr);

    if not ExternalRes then begin
      SetLength(ExtErrorMessage, StrLen(ErrorStr));
      StrCopy(PChar(ExtErrorMessage), ErrorStr);
      CoTaskMemFree(ErrorStr);
      RunExternalOrdersError := ExtErrorMessage;
    end;
  except
    on E : Exception do
      RunExternalOrdersError := E.Message;
  end;
end;

initialization
  LoadExternalOrdersDLL;
finalization
  UnLoadExternalOrdersDLL;
end.
