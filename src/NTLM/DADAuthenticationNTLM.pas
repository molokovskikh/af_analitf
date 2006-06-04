{ $HDR$}
{

  Implementation of the NTLM authentication as specified in
  http://www.innovation.ch/java/ntlm.html with some fixes

}
unit DADAuthenticationNTLM;

interface

Uses
  Classes, SysUtils,
  IdAuthentication, NtlmMsgs;

Type
  TDADNTLMAuthentication = class(TIdAuthentication)
  private
    FNTLM : TNTLM;
  protected
    FNTLMInfo: String;
    LDomain, LUser: String;
    function DoNext: TIdAuthWhatsNext; override;
    function GetSteps: Integer; override;
    procedure SetUserName(const Value: String); override;
  public
    constructor Create; override;
    destructor  Destroy; override;
    function Authentication: String; override;
    function KeepAlive: Boolean; override;
    procedure Reset; override;
  end;

implementation

Uses
  IdGlobal;

{ TDADNTLMAuthentication }

constructor TDADNTLMAuthentication.Create;
begin
  inherited Create;

  FNTLM := TNTLM.Create;
end;

function TDADNTLMAuthentication.DoNext: TIdAuthWhatsNext;
begin
  result := wnDoRequest;

  case FCurrentStep of
    0:
      begin
        result := wnDoRequest;
        FCurrentStep := 1;
      end;
    1:
      begin
        FCurrentStep := 2;
        if (Length(Username) > 0) {and (Length(Password) > 0)} then
        begin
          result := wnDoRequest;
        end
        else begin
          result := wnAskTheProgram;
        end;
      end;
    3:
      begin
        FCurrentStep := 4;
        result := wnDoRequest;
      end;
    4:
      begin
        Reset;
        result := wnFail;
      end;
  end;
end;

function TDADNTLMAuthentication.Authentication: String;
Var
  S: String;
  NTLM_Message2 : TNTLM_Message2;
  LHost: String;
begin
  result := '';    {do not localize}
  case FCurrentStep of
    1:
      begin
        LHost := IndyGetHostName;

        result := 'NTLM ' + FNTLM.GetMensaje1(LHost, LDomain);
        
        FNTLMInfo := '';    {Do not Localize}
      end;
    2:
      begin
        if Length(FNTLMInfo) = 0 then
        begin
          FNTLMInfo := ReadAuthInfo('NTLM');   {do not localize}
          Fetch(FNTLMInfo);
        end;

        if Length(FNTLMInfo) = 0 then
        begin
          Reset;
          Abort;
        end;

        LHost := IndyGetHostName;
        NTLM_Message2 := FNTLM.GetMensaje2(FNTLMInfo);
        S := FNTLM.GetMensaje3(LDomain, LHost, LUser, Password, NTLM_Message2.Nonce);

        result := 'NTLM ' + S;    {do not localize}

        FCurrentStep := 3;

//        Inc(FAuthRetries);
      end;
  end;
end;

procedure TDADNTLMAuthentication.Reset;
begin
  inherited Reset;
  FCurrentStep := 1;
end;

function TDADNTLMAuthentication.KeepAlive: Boolean;
begin
  result := true;
end;

function TDADNTLMAuthentication.GetSteps: Integer;
begin
  result := 3;
end;

procedure TDADNTLMAuthentication.SetUserName(const Value: String);
var
 i: integer;
begin
 if Value <> Username then
 begin
   inherited;
   i := Pos('\', Username);
   if i > -1 then
   begin
     LDomain := Copy(Username, 1, i - 1);
     LUser := Copy(Username, i + 1, Length(UserName));
   end
   else
   begin
     LDomain := ' ';         {do not localize}
     LUser := UserName;
   end;
 end;
end;

destructor TDADNTLMAuthentication.Destroy;
begin
  FNTLM.Free;
  
  inherited;
end;

initialization
  RegisterAuthenticationMethod('NTLM', TDADNTLMAuthentication);    {do not localize}
end.

