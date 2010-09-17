unit IdSASL_NTLM;

interface
{$i IdCompilerDefines.inc}
uses
  IdSASL,
  IdSASLUserPass;
  
type
  TIdSASLNTLM = class(TIdSASLUserPass)
  public
    class function ServiceName: TIdSASLServiceName; override;
    function StartAuthenticate(const AChallenge, AHost, AProtocolName:string) : String; override;
    function ContinueAuthenticate(const ALastResponse, AHost, AProtocolName: String): string; override;
    function IsReadyToStart: Boolean; override;
  end;

implementation
uses IdNTLM;

{ TIdSASLNTLM }

function TIdSASLNTLM.ContinueAuthenticate(const ALastResponse, AHost,
  AProtocolName: String): string;
var
  LType2: type_2_message_header;
  s : String;
  LDomain, LUserName : String;
begin
  s := ALastResponse;
  Move(S[1], Ltype2, SizeOf(Ltype2));
  Delete(S, 1, SizeOf(Ltype2));
  GetDomain(GetUsername,LDomain,LUsername);
//  S := LType2.Nonce;
  Result := 'NTLM ' + BuildType3Message(LDomain, AHost,LUserName, GetPassword, LType2.Nonce);
//  Result := 'NTLM ' + S;    {do not localize}
end;

function TIdSASLNTLM.IsReadyToStart: Boolean;
begin
  Result := inherited IsReadyToStart;
  if Result then begin
    Result := NTLMFunctionsLoaded;
  end;
end;

class function TIdSASLNTLM.ServiceName: TIdSASLServiceName;
begin
  Result := 'NTLM';   {Do not localize}
end;

function TIdSASLNTLM.StartAuthenticate(const AChallenge, AHost,
  AProtocolName: string): String;
var LDomain,LUsername : String;
begin
  GetDomain(GetUsername,LDomain,LUsername);
  Result := BuildType1Message(LDomain,AHost);
end;

end.
