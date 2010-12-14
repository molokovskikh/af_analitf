unit UserMessageParams;

interface

uses
  SysUtils,
  Classes,
  Windows,
  Variants,
  MyAccess,
  AProc,
  GlobalParams;

type
  TUserMessageParams = class(TGlobalParams)
   public
    UserMessage : String;
    Confirmed : Boolean;
    procedure ReadParams; override;
    procedure SaveParams; override;
    function NeedConfirm : Boolean;
    procedure UpdateUserMessage(AUserMessage : String);
    procedure ConfirmedMessage();
  end;

  procedure ShowUserMessage(Connection : TCustomMyConnection);

implementation

{ TUserMessageParams }

procedure TUserMessageParams.ConfirmedMessage;
begin
  UserMessage := '';
  SaveParams;
end;

function TUserMessageParams.NeedConfirm: Boolean;
begin
  Result := (UserMessage <> '') and Confirmed; 
end;

procedure TUserMessageParams.ReadParams;
var
  value : Variant;
begin
  value := GetParam('UserMessage');
  if VarIsNull(value) then
    UserMessage := ''
  else
    UserMessage := value;
  Confirmed := GetParamDef('UserMessageConfirmed', False);
end;

procedure TUserMessageParams.SaveParams;
begin
  SaveParam('UserMessage', UserMessage);
  SaveParam('UserMessageConfirmed', Confirmed);
end;

procedure TUserMessageParams.UpdateUserMessage(AUserMessage: String);
begin
  UserMessage := AUserMessage;
  Confirmed := False;
  SaveParams;
end;

procedure ShowUserMessage(Connection : TCustomMyConnection);
var
  userMessage : TUserMessageParams;
begin
  userMessage := TUserMessageParams.Create(Connection);
  try
    if AProc.MessageBoxEx(
      userMessage.UserMessage,
      'Сообщение от АК "Инфорум"',
      MB_OK or MB_ICONWARNING) = IDOK
    then begin
      userMessage.Confirmed := True;
      userMessage.SaveParams;
    end;
  finally
    userMessage.Free;
  end;
end;

end.
