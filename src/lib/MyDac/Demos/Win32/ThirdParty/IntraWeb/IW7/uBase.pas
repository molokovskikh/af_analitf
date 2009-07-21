unit uBase;
{PUBDIST}

interface

uses
  IWAppForm, IWApplication, IWTypes, Classes, Controls, IWControl,
  IWCompRectangle, IWCompButton, IWGrids, IWDBGrids, IWDBStdCtrls,
  IWCompMemo, IWCompEdit, IWCompText, IWCompLabel, IWHTMLControls,
  IWContainer, IWRegion,
  Forms, Graphics, DB, MemDS, DBAccess, MyAccess, IWVCLBaseContainer,
  IWHTMLContainer, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl;
type
  TfmBase = class(TIWAppForm)
    IWRectangle: TIWRectangle;
    lbDemoCaption: TIWLabel;
    lbPageName: TIWLabel;
    lnkMain: TIWLink;
    lnkQuery: TIWLink;
    lnkCachedUpdates: TIWLink;
    lnkMasterDetail: TIWLink;
    rgConnection: TIWRegion;
    IWRectangle4: TIWRectangle;
    btConnect: TIWButton;
    btDisconnect: TIWButton;
    lbStateConnection: TIWLabel;
    procedure lnkMainClick(Sender: TObject);
    procedure lnkQueryClick(Sender: TObject);
    procedure lnkCachedUpdatesClick(Sender: TObject);
    procedure IWAppFormRender(Sender: TObject);
    procedure lnkMasterDetailClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
  protected
    procedure ReadFromControls; virtual;
  end;

const
  ResultColors: array[boolean] of TColor = (clRed, $006A240A);

implementation
{$R *.dfm}

uses
  IWInit, ServerController, SysUtils, IWForm;


procedure TfmBase.IWAppFormRender(Sender: TObject);

  procedure SetLinkState(Link: TIWLink; Form: TfmBase);
  begin
    Link.Enabled := Sender <> Form;
    if Link.Enabled then
      Link.Font.Style := []
    else
      Link.Font.Style := [fsBold];
  end;

begin
  SetLinkState(lnkMain, UserSession.fmMain);
  SetLinkState(lnkQuery, UserSession.fmQuery);
  SetLinkState(lnkCachedUpdates, UserSession.fmCachedUpdates);
  SetLinkState(lnkMasterDetail, UserSession.fmMasterDetail);

  lbStateConnection.Font.Color := ResultColors[UserSession.IsGoodConnection];
  lbStateConnection.Caption := UserSession.ConnectionResult;
  btDisconnect.Enabled := DM.Connection.Connected;
  btConnect.Enabled := not DM.Connection.Connected;
end;

procedure TfmBase.lnkMainClick(Sender: TObject);
begin
  ReadFromControls;
  WebApplication.SetActiveForm(UserSession.fmMain);
end;

procedure TfmBase.lnkQueryClick(Sender: TObject);
begin
  ReadFromControls;
  WebApplication.SetActiveForm(UserSession.fmQuery);
end;

procedure TfmBase.lnkCachedUpdatesClick(Sender: TObject);
begin
  ReadFromControls;
  WebApplication.SetActiveForm(UserSession.fmCachedUpdates);
end;

procedure TfmBase.lnkMasterDetailClick(Sender: TObject);
begin
  ReadFromControls;
  WebApplication.SetActiveForm(UserSession.fmMasterDetail);
end;

procedure TfmBase.btConnectClick(Sender: TObject);
begin
  ReadFromControls;
  try
    DM.Connection.Connect;
    UserSession.IsGoodConnection := True;
  except
    UserSession.IsGoodConnection := False;
    UserSession.ConnectionResult := 'Failed';
  end;
end;

procedure TfmBase.btDisconnectClick(Sender: TObject);
begin
  ReadFromControls;
  try
    DM.Connection.Disconnect;
    UserSession.ConnectionResult := ''
  except
    UserSession.IsGoodConnection := False;
    UserSession.ConnectionResult := 'Failed';
  end;
end;

procedure TfmBase.ReadFromControls;
begin
end;

end.
