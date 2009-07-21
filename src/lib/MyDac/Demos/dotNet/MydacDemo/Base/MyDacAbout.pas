
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDac About Window
//  Created:            24.07.01
//  Last modified:      14.01.02
//////////////////////////////////////////////////

{$I DacDemo.inc}

unit MyDacAbout;

interface
uses
{$IFDEF FPC}
  LResources,
{$ELSE}
{$IFDEF WIN32}
  Jpeg,
{$ENDIF}
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, ShellApi,
{$ENDIF}
{$IFDEF KYLIX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QComCtrls, QGrids, QDBGrids, QDBCtrls, QButtons, QExtCtrls;
{$ELSE}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons, ExtCtrls;
{$ENDIF}

type
  TMyDacAboutForm = class(TForm)
    OKBtn: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbMail: TLabel;
    lbWeb: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    lbForum: TLabel;
    procedure lbWebClick(Sender: TObject);
    procedure lbMailClick(Sender: TObject);
    procedure lbWebMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbForumMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbForumClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MyDacAboutForm: TMyDacAboutForm;

procedure ShowAbout;

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

procedure ShowAbout;
begin
  with TMyDacAboutForm.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMyDacAboutForm.lbWebClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('http://www.devart.com/mydac'), '', '', SW_SHOW);
  lbWeb.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TMyDacAboutForm.lbMailClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('mailto:mydac@devart.com'), 'zxczxc', '', SW_SHOW);
  lbMail.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TMyDacAboutForm.lbForumClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'open', {$IFDEF FPC}PChar{$ENDIF}('www.devart.com/forums/viewforum.php?f=7'), '', '', SW_SHOW);
  lbWeb.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TMyDacAboutForm.lbWebMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbWeb.Font.Color := $4080FF;
end;

procedure TMyDacAboutForm.lbMailMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  lbMail.Font.Color := $4080FF;
end;

procedure TMyDacAboutForm.lbForumMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbForum.Font.Color := $4080FF;
end;

procedure TMyDacAboutForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbWeb.Font.Color := $FF0000;
  lbMail.Font.Color := $FF0000;
  lbForum.Font.Color := $FF0000;
end;

{$IFDEF FPC}
initialization
  {$i MyDacAbout.lrs}
{$ENDIF}

end.
