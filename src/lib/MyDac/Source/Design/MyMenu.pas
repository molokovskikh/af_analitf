
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 2001-2009 Devart. All right reserved.
//  MyDAC IDE Menu
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyMenu;
{$ENDIF}
{$IFNDEF STD}
{$IFDEF MYBUILDER}
  {$DEFINE MYBUILDERSHOW}
{$ENDIF}
{$ENDIF}  
interface

{$IFDEF VER7P}
  {$WARN UNIT_DEPRECATED OFF}
{$ENDIF}

uses
{$IFDEF MYBUILDERSHOW}
  MyBuilderClient,
{$ENDIF}
  DAMenu, Windows;

type
  TMyMenu = class(TDAProductMenu)
  private
  {$IFDEF MYBUILDERSHOW}
    FMyBuilder: TMyBuilder;
  {$ENDIF}

    procedure HomePageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure MydacPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure AboutItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure DBMonitorItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
    procedure DBMonitorPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
  {$IFDEF MYBUILDERSHOW}
    procedure MyBuilderItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
  {$IFNDEF DBTOOLS}
    procedure MyBuilderPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
  {$ENDIF}
  {$ENDIF}
  {$IFDEF DBTOOLS}
    procedure DeveloperToolsPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
  {$ENDIF}
  public
    constructor Create;
  {$IFDEF MYBUILDERSHOW}
    destructor Destroy; override;
  {$ENDIF}
    function AddItems(Instance: HINST): boolean; override;
  {$IFNDEF STD}
  {$IFDEF MYBUILDER}
    class procedure DownloadMyBuilder;
  {$ENDIF}
  {$ENDIF}
  end;

var
  Menu: TMyMenu;

implementation

uses
  Classes, MyConsts,
{$IFDEF CLR}
  WinUtils,
{$ENDIF}
{$IFDEF DBTOOLS}
  MyDesignUtils, Download,
{$ENDIF}
  SysUtils, Forms, ShellApi, MyAbout, DBMonitorIntf, DBMonitorClient,
  HelpUtils;

resourcestring
  sCRMenuName = 'DevartMenuMydac';
  sMyDACMenu = '&MySQL';
  sHelpItemCaption = 'MyDAC Help';
  sHelpItemName = 'CRMyHelpItem';
  sHomePageCaption = 'Devart Home Page';
  sHomePageName = 'CRMyHomePageItem';
  sFAQCaption = 'MyDAC FAQ';
  sFAQName = 'CRMyFAQItem';
  sMydacPageCaption = 'MyDAC Home Page';
  sMydacPageName = 'CRMyDACPageItem';
  sAboutItemCaption = 'About MyDAC...';
{$IFDEF CLR}
  sAboutItemName = 'CRMyAboutItemCLR';
{$ELSE}
  sAboutItemName = 'CRMyAboutItemWin32';
{$ENDIF}
  sDBMonitorItemCaption = 'DBMonitor';
  sDBMonitorItemName = 'MyDACDBMonitorItem';
  sDBMonitorPageCaption = 'Download DBMonitor';
  sDBMonitorPageName = 'MyDACDBMonitorPageItem';
{$IFDEF MYBUILDERSHOW}
  sMyBuilderItemCaption = 'SQLBuilder for MySQL';
  sMyBuilderItemName = 'MyDACMyBuilderItem';
{$IFNDEF DBTOOLS}
  sMyBuilderPageCaption = 'Download SQLBuilder for MySQL';
  sMyBuilderPageName = 'MyDACMyBuilderPageItem';
{$ENDIF}
{$ENDIF}
{$IFDEF DBTOOLS}
  sDeveloperToolsPageCaption = 'Download MySQL Developer Tools';
  sDeveloperToolsPageName = 'MyDACDeveloperToolsPageItem';
{$ENDIF}
{ TMyMenu }

constructor TMyMenu.Create;
begin
  inherited Create (sCRMenuName, sAboutItemCaption, sAboutItemName, sMyDACMenu);
  FAboutClickEvent := AboutItemClick;

{$IFDEF MYBUILDERSHOW}
  FMyBuilder := TMyBuilder.Create(nil);
{$ENDIF}
end;

{$IFDEF MYBUILDERSHOW}
destructor TMyMenu.Destroy;
begin
  FMyBuilder.Free;

  inherited;
end;
{$ENDIF}

{$IFNDEF STD}
{$IFDEF MYBUILDER}
class procedure TMyMenu.DownloadMyBuilder;
begin
  OpenUrl('http://www.devart.com/mybuilder/mybuilderadd.exe');
end;
{$ENDIF}
{$ENDIF}

function TMyMenu.AddItems(Instance: HINST): boolean;
begin
  Result := inherited AddItems(Instance);
  if not Result then
    Exit;

  with SubMenu do begin
  {$IFDEF MYBUILDERSHOW}
    if FMyBuilder.Available then begin
      Add(sMyBuilderItemCaption, sMyBuilderItemName, MyBuilderItemClick);
      AddSeparator;
    end;
  {$ENDIF}
    if HasMonitor then
      Add(sDBMonitorItemCaption, sDBMonitorItemName, DBMonitorItemClick);

    AddWizards;
    AddSeparator;

    AddHelp(sHelpItemCaption, sHelpItemName, 'Mydac');
    AddFAQ(sFAQCaption, sFAQName, 'Mydac');
    AddSeparator;

    Add(sHomePageCaption, sHomePageName, HomePageItemClick);
    Add(sMydacPageCaption, sMydacPageName, MydacPageItemClick);
  {$IFDEF MYBUILDERSHOW}
  {$IFNDEF DBTOOLS}
    Add(sMyBuilderPageCaption, sMyBuilderPageName, MyBuilderPageItemClick);
  {$ENDIF}
  {$ENDIF}
    Add(sDBMonitorPageCaption, sDBMonitorPageName, DBMonitorPageItemClick);
  {$IFDEF DBTOOLS}
    Add(sDeveloperToolsPageCaption, sDeveloperToolsPageName, DeveloperToolsPageItemClick);
  {$ENDIF}
    AddSeparator;
    AddAbout;
  end;
end;

procedure TMyMenu.HomePageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com');
end;

procedure TMyMenu.MydacPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com/mydac');
end;

procedure TMyMenu.AboutItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  ShowAbout;
end;

procedure TMyMenu.DBMonitorItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  ShellExecute(0, 'open',
  {$IFDEF CLR}
    WhereMonitor,
  {$ELSE}
    PChar(WhereMonitor),
  {$ENDIF}
    '', '', SW_SHOW);
end;

procedure TMyMenu.DBMonitorPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  OpenUrl('http://www.devart.com/dbmonitor/dbmon.exe');
end;

{$IFDEF MYBUILDERSHOW}
procedure TMyMenu.MyBuilderItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  FMyBuilder.Show;
end;

{$IFNDEF DBTOOLS}
procedure TMyMenu.MyBuilderPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  DownloadMyBuilder;
end;
{$ENDIF}
{$ENDIF}

{$IFDEF DBTOOLS}
procedure TMyMenu.DeveloperToolsPageItemClick(Sender: TDAMenuClickSender{$IFDEF CLR}; E: EventArgs{$ENDIF});
begin
  TMyDesignUtils.SetDBToolsDownloadParams(False, False);
  DownloadTools({$IFDEF PRO}True{$ELSE}False{$ENDIF});
end;
{$ENDIF}

initialization
  Menu := TMyMenu.Create;
finalization
  Menu.Free;
end.