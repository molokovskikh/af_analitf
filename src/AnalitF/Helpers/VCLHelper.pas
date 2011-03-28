unit VCLHelper;

interface

uses
  SysUtils,
  Classes,
  Windows,
  StdCtrls; 

type
  TVCLHelper = class
   public
    class function GetMemoNeedHeight(Memo: TMemo): Integer;
  end;

implementation

{ TVCLHelper }

class function TVCLHelper.GetMemoNeedHeight(Memo: TMemo): Integer;
var
  OldFont: HFont;
  Hand: THandle;
  TM: TTextMetric;
  tempint: integer;
begin
  Hand:= GetDC(Memo.Handle);
  try
    OldFont:= SelectObject(Hand, Memo.Font.Handle);
    try
      GetTextMetrics(Hand, TM);
      tempint := (Memo.Lines.Count + 2)* (TM.tmHeight + TM.tmExternalLeading);
    finally
      SelectObject(Hand, OldFont);
    end;
  finally
    ReleaseDC(Memo.Handle, Hand);
  end;
  Result:= tempint;
end;

end.
 