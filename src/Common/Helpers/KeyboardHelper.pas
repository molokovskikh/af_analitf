unit KeyboardHelper;

interface

uses
  SysUtils,
  Classes,
  Windows,
  U_ExchangeLog;

type
  TKeyboardHelper = class
   private
    FIsWindowsSeven : Boolean;
    FIsDebug : Boolean;
    function InternalSwitchToLanguage(Language : HKL) : HKL;
   public
    RussianKeyboard: HKL;
    EnglishKeyboard: HKL;
    constructor Create();
    function SwitchToLanguage(Language : HKL) : HKL;
    function SwitchToRussian() : HKL;
    function SwitchToEnglish() : HKL;
    function SwitchToPrev() : HKL;
    function GetCurrentKeyboard : HKL;
  end;

  function GetKeyboardHelper() : TKeyboardHelper;

implementation

var
  FKeyboardHelper : TKeyboardHelper;

function GetKeyboardHelper() : TKeyboardHelper;
begin
  Result := FKeyboardHelper;
end;

{ TKeyboardHelper }

constructor TKeyboardHelper.Create;
begin
  FIsDebug := FindCmdLineSwitch('extd');
  FIsWindowsSeven := CheckWin32Version(6, 1);
  RussianKeyboard := LoadKeyboardLayout('00000419', 0);
  EnglishKeyboard := LoadKeyboardLayout('00000409', 0);
  if FIsDebug then
    WriteExchangeLog('KeyboardHelper', Format('Русская раскладка: %d  Английская раскладка: %d', [RussianKeyboard, EnglishKeyboard]));
end;

function TKeyboardHelper.GetCurrentKeyboard: HKL;
begin
  Result := GetKeyboardLayout(0);
end;

function TKeyboardHelper.InternalSwitchToLanguage(Language: HKL): HKL;
var
  Flags : Cardinal;
  LastError : DWORD;
begin
  Flags := 0;
  if FIsWindowsSeven then
    Flags := $00000100;
  Result := ActivateKeyboardLayout(Language, Flags);
  if (Result = 0) and FIsDebug then begin
    LastError := GetLastError();
    WriteExchangeLog(
      'KeyboardHelper',
      Format('Ошибка переключения раскладки на %d: (%d) %s',
        [Language, LastError, SysErrorMessage(LastError)]));
  end;
end;

function TKeyboardHelper.SwitchToEnglish: HKL;
begin
  Result := SwitchToLanguage(EnglishKeyboard);
end;

function TKeyboardHelper.SwitchToLanguage(Language: HKL): HKL;
begin
  if Language <> 0 then begin
    Result := InternalSwitchToLanguage(Language);
  end
  else
    Result := 0;
end;

function TKeyboardHelper.SwitchToPrev: HKL;
begin
  Result := InternalSwitchToLanguage(HKL_PREV);
end;

function TKeyboardHelper.SwitchToRussian: HKL;
begin
  Result := SwitchToLanguage(RussianKeyboard);
end;

initialization
  fKeyboardHelper := TKeyboardHelper.Create();
end.
