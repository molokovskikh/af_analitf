unit PortingKylix;
interface

{$IFNDEF LINUX}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs, StdCtrls;
{$ELSE}
uses
  Libc, SysUtils, Classes, QForms, QDialogs, QTypes, QStdCtrls, QGraphics, QGrids;
{$ENDIF}

{$IFDEF LINUX}
const
  MB_OK : TMessageButtons = [smbOK];
  MB_YESNO : TMessageButtons = [smbYes,smbNo];
  MB_OKCANCEL : TMessageButtons = [smbok,smbCancel];
  IDOK : TMessageButton = smbOK;
  IDNO : TMessageButton = smbNO;
{$ENDIF}

 procedure SetKylixFont(F : TForm);

implementation

procedure SetKylixFont(F : TForm);
{$IFDEF LINUX}
  procedure SetFont(F : TFont);
  begin
    F.Name := 'Helvetica';
    //F.Name := 'System';
    F.Size := 9;
    //F.Height := 13;
  end;
var
 I : integer;
 TL : Tlabel;
begin
    SetFont(F.Font);
    F.PixelsPerInch := 75;
    F.VertScrollBar.Range := 65;
    F.ParentFont := True;
    F.Scaled := True;

    for i:= 0 to F.ComponentCount -1 do
    begin
      //Showmessage(F.Components[I].Name);
      //ParentFont:=True;

      if (F.Components[I] is TButton) then
          SetFont(TButton(F.Components[I]).Font)
      else
      if (F.Components[I] is TLabel) then
         begin
          TL:=TLabel(F.Components[I]);
          SetFont(TL.Font);
          //SetFont(TLabel(F.Components[I]).Font);
          if TL.FocusControl is TEdit then
            TEdit(TL.FocusControl).Left:=TL.Left+TL.Width+5;
         end
      else if (F.Components[I] is TEdit) then
          SetFont(TEdit(F.Components[I]).Font)
      else if (F.Components[I] is TComboBox) then
          SetFont(TComboBox(F.Components[I]).Font)
      else if (F.Components[I] is TStringGrid) then
          SetFont(TStringGrid(F.Components[I]).Font);
    end;
{$ELSE}
begin
{$ENDIF}
end;

end.
