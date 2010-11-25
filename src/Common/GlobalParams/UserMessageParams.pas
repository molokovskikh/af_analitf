unit UserMessageParams;

interface

uses
  SysUtils,
  Classes,
  Variants,
  MyAccess,
  GlobalParams;

type
  TUserMessageParams = class(TGlobalParams)
   public
    UserMessage : String;
    procedure ReadParams; override;
    procedure SaveParams; override;
    function NeedConfirm : Boolean;
  end;

implementation

{ TUserMessageParams }

function TUserMessageParams.NeedConfirm: Boolean;
begin
  Result := UserMessage <> ''; 
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
end;

procedure TUserMessageParams.SaveParams;
begin
  SaveParam('UserMessage', UserMessage);
end;

end.
