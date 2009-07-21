{$I DacDemo.inc}

unit InheritedConnectForm;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons,
  {$IFNDEF FPC}Mask,{$ENDIF}
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, MyDacClx, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  MyConnectForm;

type
  TfmInheritedConnect = class(TMyConnectForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmInheritedConnect: TfmInheritedConnect;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

initialization
  if GetClass('TfmInheritedConnect') = nil then
    Classes.RegisterClass(TfmInheritedConnect);
{$IFDEF FPC}
  {$i InheritedConnectForm.lrs}
{$ENDIF}
end.
