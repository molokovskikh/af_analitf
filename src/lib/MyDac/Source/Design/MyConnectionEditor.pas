
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyConnection Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyConnectionEditor;
{$ENDIF}
interface
uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, 
  {$IFDEF FPC}MaskEdit,{$ELSE}Mask,{$ENDIF}
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QButtons, QMask,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  MemUtils, DAConnectionEditor, MyAccess, TypInfo, CREditor;

type
  TMyConnectionEditorForm = class(TDAConnectionEditorForm)
    lbDatabase: TLabel;
    edDatabase: TComboBox;
    lbPort: TLabel;
    edPort: TEdit;
    cbDirect: TCheckBox;
    cbEmbedded: TCheckBox;
    shEmbParams: TTabSheet;
    Label4: TLabel;
    edBaseDir: TEdit;
    btBaseDir: TBitBtn;
    btDataDir: TBitBtn;
    edDataDir: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edTempDir: TEdit;
    btTempDir: TBitBtn;
    btCharsetsDir: TBitBtn;
    edCharsetsDir: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edLanguage: TEdit;
    btLanguage: TBitBtn;
    btBinaryLogIndex: TBitBtn;
    edBinaryLogIndex: TEdit;
    Label12: TLabel;
    btBinaryLog: TBitBtn;
    edBinaryLog: TEdit;
    Label11: TLabel;
    cbInnoDBSafeBinLog: TCheckBox;
    cbFlush: TCheckBox;
    cbSkipInnoDB: TCheckBox;
    cbSkipGrantTables: TCheckBox;
    cbLogShortFormat: TCheckBox;
    btAdvanced: TButton;
    cbExisting: TComboBox;
    lbExisting: TLabel;
    procedure edPortExit(Sender: TObject);
    procedure edDatabaseDropDown(Sender: TObject);
    procedure cbDirectClick(Sender: TObject);
    procedure cbEmbeddedClick(Sender: TObject);
    procedure btAdvancedClick(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edDatabaseExit(Sender: TObject);
    procedure cbExistingChange(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
  protected
  {$IFDEF DBTOOLS}
    function GetExistingConnectionComboBox: TComboBox; override;
    function GetConnectionCondition: string; override;
  {$ENDIF}
    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);

    procedure DoInit; override;
    procedure DoActivate; override;
    procedure DoSave; override;
    procedure FillInfo; override;

    procedure ConnToControls; override;
    procedure ControlsToConn; override;
    procedure ShowState(Yellow: boolean = False); override;

    //procedure TrimParams(Params: TStrings);
    procedure ParamsToControls(Params: TStrings);
    procedure ControlsToParams(Params: TStrings);

  public
  {$IFNDEF CLR}
    procedure ReplaceEdit(var Edit: TWinControl);
    procedure SpinEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  {$ENDIF}
    property Connection: TCustomMyConnection read GetConnection write SetConnection;
end;

implementation

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyConnectionEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

uses
{$IFNDEF KYLIX}
  DacVcl, 
{$ELSE}
  DacClx, 
{$ENDIF}
  DAConsts{$IFNDEF STD}, MyEmbConnection, MyEmbConParamsEditor{$ENDIF}, DBAccess;

{ TMyConnectionEditorForm }

procedure TMyConnectionEditorForm.DoInit;
{$IFDEF MSWINDOWS}
{$IFNDEF CLR}
var
  WinControl: TWinControl;
{$ENDIF}
{$ENDIF}
begin

{$IFDEF MSWINDOWS}
{$IFNDEF CLR}
  WinControl := edPort;
  ReplaceEdit(WinControl);
{$ENDIF}
{$ELSE}
  meInfo.Font.Name := 'adobe-courier';
  meInfo.Font.Pitch := fpFixed;
  Label4.Height := 18;
  Label7.Height := 18;
  Label8.Height := 18;
  Label9.Height := 18;
  Label10.Height := 18;
  Label11.Height := 18;
  Label12.Height := 18;
  cbInnoDBSafeBinLog.Width := 217;
{$ENDIF}

  inherited;
  lbVersion.Caption := MyDACVersion;


{$IFNDEF HAVE_DIRECT}
  cbDirect.Enabled := False;
{$ENDIF}
{$IFNDEF STD}
  shEmbParams.TabVisible := FConnection is TMyEmbConnection;
  if FConnection is TMyEmbConnection then
    ParamsToControls(TMyEmbConnection(FConnection).Params);
{$ELSE}
  shEmbParams.TabVisible := False;
{$ENDIF}

{$IFDEF MSWINDOWS}
  if not DADesignUtilsClass.DBToolsAvailable and cbExisting.Visible then
{$ENDIF}
  begin
    lbExisting.Visible := False;
    cbExisting.Visible := False;
    
    Height := Height - 33;
    Panel.Height := Panel.Height + 33;

    Panel.Top := Panel.Top - 33;
    cbLoginPrompt.Top := cbLoginPrompt.Top - 33;
    cbDirect.Top := cbDirect.Top - 33;
    cbEmbedded.Top := cbEmbedded.Top - 33;
  end;
end;

procedure TMyConnectionEditorForm.DoActivate;
begin
  inherited;
  
{$IFNDEF STD}
  if InitialProperty = 'Params' then
    PageControl.ActivePage := shEmbParams
  else
{$ENDIF}  
  if InitialProperty <> '' then
    Assert(False, InitialProperty);
end;

procedure TMyConnectionEditorForm.DoSave;
begin
  inherited;

{$IFNDEF STD}
  if FConnection is TMyEmbConnection then
    ControlsToParams(TMyEmbConnection(FConnection).Params);
  // Connection.Assign(FConnection);
{$ENDIF}  
end;

procedure TMyConnectionEditorForm.FillInfo;

function CompleteWithSpaces(s: string; ResultLength: word): string;
  var
    n, i: integer;
  begin
    result := s;
    n := ResultLength - Length(s);
    if n > 0 then
      for i := 1 to n do
        result := result + ' ';
  end;

var
  OldConnectionTimeout: integer;
  MyQuery: TMyQuery;
begin
  OldConnectionTimeout := Connection.ConnectionTimeout;
  try
    Connection.ConnectionTimeout := 1;
    meInfo.Lines.BeginUpdate;
    inherited;

    if Connection.Connected then
      meInfo.Lines.Text := 'MySQL server version: ' + Connection.ServerVersion + LineSeparator;

    if Connection.Connected then begin
    {$IFDEF HAVE_DIRECT}
      /// CR 3443
      if not (Connection is TMyConnection) or not TMyConnection(Connection).Options.Direct then
        meInfo.Lines.Text := meInfo.Lines.Text + 'MySQL client version: ' + Connection.ClientVersion
      else
        if (Connection is TMyConnection) and TMyConnection(Connection).Options.Direct then
          meInfo.Lines.Text := meInfo.Lines.Text + 'MySQL client version: Direct';
    {$ELSE}
      meInfo.Lines.Text := meInfo.Lines.Text + 'MySQL client version: ' + Connection.ClientVersion;
    {$ENDIF}

      meInfo.Lines.Text := meInfo.Lines.Text + LineSeparator + LineSeparator;

      MyQuery := TMyQuery.Create(nil);
      try
        MyQuery.Connection := Connection;
        MyQuery.SQL.Text := 'SHOW variables';
        MyQuery.FetchAll := True;
        MyQuery.Open;
        while not MyQuery.Eof do begin
          meInfo.Lines.Add(CompleteWithSpaces(MyQuery.Fields[0].AsString, 33) + MyQuery.Fields[1].AsString);
          MyQuery.Next;
        end;
        meInfo.SelStart := 0;
      finally
        MyQuery.Free;
      end;
    end;

  finally
    meInfo.Lines.EndUpdate;
    Connection.ConnectionTimeout := OldConnectionTimeout;
  end;
end;

procedure TMyConnectionEditorForm.ConnToControls;
begin
  inherited;

  edDatabase.Text := Connection.Database;
  if FConnection is TMyConnection then begin
    edPort.Text := IntToStr(TMyConnection(FConnection).Port);
    cbEmbedded.Checked := TMyConnection(FConnection).Embedded;
  {$IFDEF HAVE_DIRECT}
    cbDirect.Checked := TMyConnection(FConnection).Options.Direct;
  {$ENDIF}
  end
  else
  begin
  {$IFNDEF STD}
    Assert(FConnection is TMyEmbConnection, FConnection.ClassName);
    edServer.Text := '';
    edPort.Text := '';
    cbEmbedded.Enabled := False;
    cbEmbedded.Checked := True;

//    ParamsToControls(TMyEmbConnection(FConnection).Params);
  {$ELSE}
    Assert(False);
  {$ENDIF}
  end;
end;

procedure TMyConnectionEditorForm.ControlsToConn;
begin
  Connection.Database := edDatabase.Text; // OnExit event is not generated on Kylix when dialog is closing
  // all other parameters are set in controls OnChange event handlers
end;

procedure TMyConnectionEditorForm.ShowState(Yellow: boolean = False);
begin
  edServer.Enabled := not cbEmbedded.Checked;
  edPort.Enabled := not cbEmbedded.Checked;
  cbDirect.Enabled := not cbEmbedded.Checked;

  lbServer.Enabled := edServer.Enabled;
  lbPort.Enabled := edPort.Enabled;

  inherited;
end;

function TMyConnectionEditorForm.GetConnection: TCustomMyConnection;
begin
  Result := FConnection as TCustomMyConnection;
end;

procedure TMyConnectionEditorForm.SetConnection(
  Value: TCustomMyConnection);
begin
  FConnection := Value;
end;

procedure TMyConnectionEditorForm.edPortExit(Sender: TObject);
begin
  if FInDoInit then
    Exit;

{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}
  try
    Assert(Connection is TMyConnection);
    try
      if edPort.Text = '' then begin
        TMyConnection(Connection).Port := 3306;
        edPort.Text := '3306';
      end
      else
        TMyConnection(Connection).Port := StrToInt(edPort.Text);
    except
      PageControl.ActivePage := shConnect;
      edPort.SetFocus;
      edPort.SelectAll;
      raise;
    end;
  finally
    ShowState;
  end;
end;

procedure TMyConnectionEditorForm.edPortChange(Sender: TObject);
begin
  if FInDoInit or (edPort.Text = '') then
    Exit;

  try
    Assert(Connection is TMyConnection);
    try
      TMyConnection(Connection).Port := StrToInt(edPort.Text);
    except
      PageControl.ActivePage := shConnect;
      edPort.SetFocus;
      edPort.SelectAll;
      raise;
    end;
  finally
    ShowState;
  end;
end;

procedure TMyConnectionEditorForm.edDatabaseDropDown(Sender: TObject);
var
  List: _TStringList;
begin
  ShowState(True);
  StartWait;
  try
    (FConnection as TCustomMyConnection).Database := '';
    FConnection.PerformConnect;
    if FConnection.Connected then begin
      List := _TStringList.Create;
      try
        Connection.GetDatabaseNames(List);
        AssignStrings(List, edDatabase.Items);
      finally
        List.Free;
      end;
      if edDatabase.Items.Count < 20 then
        edDatabase.DropDownCount := edDatabase.Items.Count
      else
        edDatabase.DropDownCount := 20;
    end;
  finally
    StopWait;
    ShowState;
  end;

end;

procedure TMyConnectionEditorForm.cbEmbeddedClick(Sender: TObject);
begin
  inherited;

  if not cbEmbedded.Enabled then
    Exit;

  try
    Assert(FConnection is TMyConnection);
    btDisconnectClick(nil);
    TMyConnection(FConnection).Embedded := cbEmbedded.Checked;
  {$IFDEF DBTOOLS}
    ChooseExistingConnection;
  {$ENDIF}
  finally
    ShowState(False);
  end;
end;

procedure TMyConnectionEditorForm.cbDirectClick(Sender: TObject);
begin
  if FInDoInit or not cbDirect.Enabled then
    Exit;

  try
    Assert(Connection is TMyConnection);
    btDisconnectClick(nil);
    TMyConnection(FConnection).Options.Direct := cbDirect.Checked;
  {$IFDEF DBTOOLS}
    ChooseExistingConnection;
  {$ENDIF}
  finally
    ShowState;
  end;
end;

{procedure TMyConnectionEditorForm.TrimParams(Params: TStrings);
var
  i: integer;
begin
  for i := 0 to Params.Count - 1 do
    Params[i] := Trim(Params[i]);
end;}

procedure TMyConnectionEditorForm.ParamsToControls(Params: TStrings);
begin
  edBaseDir.Text := Params.Values['--basedir'];
  edDataDir.Text := Params.Values['--datadir'];
  edTempDir.Text := Params.Values['--tempdir'];
  edCharsetsDir.Text := Params.Values['--character-sets-dir'];
  edLanguage.Text := Params.Values['--language'];
  edBinaryLog.Text := Params.Values['--log-bin'];
  edBinaryLogIndex.Text := Params.Values['--log-bin-index'];

  cbInnoDBSafeBinLog.Checked := Params.IndexOf('--innodb-safe-binlog') <> -1;
  cbFlush.Checked := Params.IndexOf('--flush') <> -1;
  cbSkipInnoDB.Checked := Params.IndexOf('--skip-innodb') <> -1;
  cbSkipGrantTables.Checked := Params.IndexOf('--skip-grant-tables') <> -1;
  cbLogShortFormat.Checked := Params.IndexOf('--log-short-format') <> -1;
end;

procedure TMyConnectionEditorForm.ControlsToParams(Params: TStrings);
  procedure cbToParams(CheckBox: TCheckBox; const ParamName: string);
  var
    Idx: integer;
  begin
    Idx := Params.IndexOf(ParamName);
    if CheckBox.Checked then begin
      if Idx = -1 then
        Params.Add(ParamName);
    end
    else
      if Idx <> -1 then
        Params.Delete(Idx);
  end;

begin
  Params.Values['--basedir'] := Trim(edBaseDir.Text);
  Params.Values['--datadir'] := Trim(edDataDir.Text);
  Params.Values['--tempdir'] := Trim(edTempDir.Text);
  Params.Values['--character-sets-dir'] := Trim(edCharsetsDir.Text);
  Params.Values['--language'] := Trim(edLanguage.Text);
  Params.Values['--log-bin'] := Trim(edBinaryLog.Text);
  Params.Values['--log-bin-index'] := Trim(edBinaryLogIndex.Text);

  cbToParams(cbInnoDBSafeBinLog, '--innodb-safe-binlog');
  cbToParams(cbFlush, '--flush');
  cbToParams(cbSkipInnoDB, '--skip-innodb');
  cbToParams(cbSkipGrantTables, '--skip-grant-tables');
  cbToParams(cbLogShortFormat, '--log-short-format');
end;

procedure TMyConnectionEditorForm.btAdvancedClick(Sender: TObject);
begin
{$IFNDEF STD}
  Assert(FConnection is TMyEmbConnection, FConnection.ClassName);
  ControlsToParams(TMyEmbConnection(FConnection).Params);

  with TMyEmbConParamsEditorForm.Create(nil, DADesignUtilsClass) do
    try
      Connection := Self.Connection as TMyEmbConnection; 
      if ShowModal = mrOK then 
        ParamsToControls(TMyEmbConnection(FConnection).Params);
    finally
      Free;
    end;
{$ELSE}
  Assert(False)
{$ENDIF}
end;

{$IFNDEF CLR}
procedure TMyConnectionEditorForm.ReplaceEdit(var Edit: TWinControl);
type
  TSetProc = procedure (Self: TObject; Ptr: pointer);
var
  EditClass: string;
  NewEdit: TCustomControl;
  OldName: string;
  TypeInfo: PTypeInfo;
begin
  if GetClass('TSpinEdit') <> nil then
    EditClass := 'TSpinEdit'
  else
{$IFDEF BCB}
  if GetClass('TCSpinEdit') <> nil then
    EditClass := 'TCSpinEdit'
  else
{$ENDIF}
    EditClass := '';

  if EditClass <> '' then begin
    NewEdit := TCustomControl(GetClass(EditClass).NewInstance);
    NewEdit.Create(Edit.Owner);

    with NewEdit do begin
      Parent := Edit.Parent;
      Left := Edit.Left;
      Top := Edit.Top;
      Width := Edit.Width;
      Height := Edit.Height;
      Align := Edit.Align;
      TabOrder := Edit.TabOrder;
      Anchors := Edit.Anchors;
      //Constraints := Edit.Constraints;
      TypeInfo := GetClass(EditClass).ClassInfo;
      HelpContext := Edit.HelpContext;

      if Edit is TEdit then begin
        SetReadOnly(NewEdit, TEdit(Edit).ReadOnly);
        SetOrdProp(NewEdit, 'Color', Longint(TEdit(Edit).Color));
      end;

      OnKeyDown := SpinEditKeyDown;
      if GetPropInfo(Edit.ClassInfo, 'OnChange') <> nil then
        SetMethodProp(NewEdit, GetPropInfo(TypeInfo, 'OnChange'),
          GetMethodProp(Edit, GetPropInfo(Edit.ClassInfo, 'OnChange')));
      SetMethodProp(NewEdit, GetPropInfo(TypeInfo, 'OnExit'),
        GetMethodProp(Edit, GetPropInfo(Edit.ClassInfo, 'OnExit')));
      SetMethodProp(NewEdit, GetPropInfo(TypeInfo, 'OnKeyDown'),
        GetMethodProp(Edit, GetPropInfo(Edit.ClassInfo, 'OnKeyDown')));
      SetMethodProp(NewEdit, GetPropInfo(TypeInfo, 'OnKeyPress'),
        GetMethodProp(Edit, GetPropInfo(Edit.ClassInfo, 'OnKeyPress')));
    end;

    if (Edit.Owner <> nil) and (TForm(Edit.Owner).ActiveControl = Edit) then
      TForm(Edit.Owner).ActiveControl := NewEdit;

    OldName := Edit.Name;
    Edit.Free;
    Edit := TEdit(NewEdit);
    NewEdit.Name := OldName;

    if (EditClass = 'TSpinEdit') {$IFDEF BCB} or (EditClass = 'TCSpinEdit' ){$ENDIF} then begin
      SetOrdProp(NewEdit, 'MaxValue', 65535);
      SetOrdProp(NewEdit, 'MinValue', 0);
    end;
  end;
end;

procedure TMyConnectionEditorForm.SpinEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    btConnectClick(self);
end;
{$ENDIF}

procedure TMyConnectionEditorForm.edDatabaseExit(Sender: TObject);
begin
{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}
  try
    Connection.Database := edDatabase.Text;
  finally
    ShowState;
  end;
end;

{$IFDEF DBTOOLS}
function TMyConnectionEditorForm.GetExistingConnectionComboBox: TComboBox;
begin
  Result := cbExisting;
end;

function TMyConnectionEditorForm.GetConnectionCondition: string;
begin
  if Connection is TMyConnection then
    Result := ''
  else
    Result := 'Embedded=True'
end;
{$ENDIF}

{$IFNDEF DBTOOLS}
procedure TMyConnectionEditorForm.cbExistingChange(Sender: TObject);
begin
  //
end;
{$ELSE}
procedure TMyConnectionEditorForm.cbExistingChange(Sender: TObject);
var
  ConnectionStrList: TStrings;
begin
  if FInDoInit or (cbExisting.ItemIndex < 0) then
    Exit;
  ConnectionStrList := GetDBToolsService(DADesignUtilsClass).GetConnectionStrList(cbExisting.Text);
  try
    FInExistingChange := True;
    with TCustomMyConnection(Connection) do begin
      if Connection is TMyConnection then begin
        Server := ConnectionStrList.Values['Host'];
        TMyConnection(Connection).Port := StrToInt(ConnectionStrList.Values['Port']);
        with TMyConnection(Connection).SSLOptions do begin
          CACert := ConnectionStrList.Values['SSL CA Cert'];
          Cert := ConnectionStrList.Values['SSL Cert'];
          Key := ConnectionStrList.Values['SSL Key'];
          ChipherList := ConnectionStrList.Values['SSL Cipher List'];
        end;
        with TMyConnection(Connection).Options do begin
        {$IFDEF HAVE_DIRECT}
          Direct := StrToBool(ConnectionStrList.Values['Direct']);
        {$ENDIF}
          Embedded := StrToBool(ConnectionStrList.Values['Embedded']);
        end;
      end;
    {$IFNDEF STD}
      if Connection is TMyEmbConnection then begin
        TMyEmbConnection(Connection).Params.Text :=
          StringReplace(ConnectionStrList.Values['Server Parameters'], ';', LineSeparator, [rfReplaceAll]);
        ParamsToControls(TMyEmbConnection(FConnection).Params);          
      end;
    {$ENDIF}
      Database := ConnectionStrList.Values['Database'];
      Username := ConnectionStrList.Values['User Id'];
      Password := ConnectionStrList.Values['Password'];
      Options.UseUnicode := StrToBool(ConnectionStrList.Values['Unicode']);
    end;
  finally
    ConnToControls;
    FInExistingChange := False;
  end;
end;
{$ENDIF}

procedure TMyConnectionEditorForm.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
{$IFNDEF STD}
  if (PageControl.ActivePage = shEmbParams) and (Connection is TMyEmbConnection) then
    ControlsToParams(TMyEmbConnection(FConnection).Params);
{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}  
{$ENDIF}
end;

{$IFDEF FPC}
initialization
  {$i MyConnectionEditor.lrs}
{$ENDIF}

end.
