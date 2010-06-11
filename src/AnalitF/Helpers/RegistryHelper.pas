unit RegistryHelper;

interface

uses
  Windows, SysUtils, Classes, Registry;

type
  TRegistryAction = procedure (CurrentKey : TRegistry) of object;

  TRegistryHelper = class
   private
    class procedure ProcessKey(CurrentKey : TRegistry; CurrentPath : String; Action : TRegistryAction);
   public
    class procedure DoAction(RootPath : String; Action : TRegistryAction);
  end;

implementation

{ TRegistryHelper }

class procedure TRegistryHelper.DoAction(RootPath: String;
  Action: TRegistryAction);
var
  Reg : TRegistry;
begin
  if Length(RootPath) = 0 then
    raise Exception.Create('Не установлен параметр RootPath.');

  if not Assigned(Action) then
    raise Exception.Create('Не установлен параметр Action.');

  Reg := TRegistry.Create;
  try
    ProcessKey(Reg, RootPath, Action);
    {
    Reg.OpenKey( 'Software\Inforoom\AnalitF\' + GetPathCopyID, True);
    Reg.WriteBool('NewSearch', actNewSearch.Checked);
    }
  finally
    Reg.Free;
  end;
end;

class procedure TRegistryHelper.ProcessKey(CurrentKey: TRegistry;
  CurrentPath: String; Action: TRegistryAction);
var
  currentKeys : TStringList;
  I : Integer;
begin
  currentKeys := nil;
  if CurrentKey.OpenKey( CurrentPath, True) then
    try
      Action(CurrentKey);
      currentKeys := TStringList.Create;
      CurrentKey.GetKeyNames(currentKeys);
    finally
      CurrentKey.CloseKey;
    end;
  if Assigned(currentKeys) then
    for I := 0 to currentKeys.Count-1 do
      ProcessKey(CurrentKey, CurrentPath + '\' + currentKeys[i], Action);
end;

end.
 