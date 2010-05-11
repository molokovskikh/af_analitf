unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBCtrls, ShellApi, U_VistaCorrectForm;

type
  TAboutForm = class(TVistaCorrectForm)
    Image1: TImage;
    Image2: TImage;
    bbtnOk: TBitBtn;
    dbtProviderName: TDBText;
    lApplicationTitle: TLabel;
    lVersion: TLabel;
    lCopyright: TLabel;
    lIndent: TLabel;
    lUserAddition: TLabel;
    lEmails: TLabel;
    mEmails: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure lCopyrightClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure GetVersionInformation(var Version, LegalCopyright: String);
    procedure FillEmails;
    procedure IncreaseMemo;
    function GetNeedHeight(Memo: TMemo): Integer;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses DModule, Main, DB, RxVerInf,
  U_ExchangeLog;

{$R *.dfm}

procedure TAboutForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key = VK_ESCAPE then ModalResult := mrOK;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var
  Version,
  LegalCopyright: String;
begin
  GetVersionInformation(Version, LegalCopyright);
  lApplicationTitle.Caption := Application.Title;
  lVersion.Caption := 'Версия : ' + Version +
    ' (' + DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString + ')';
  lIndent.Caption := 'Идентификация : ' + DM.adsUser.FieldByName('UserId').AsString;
  lUserAddition.Caption := DM.adsUser.FieldByName('Addition').AsString;
  lCopyright.Caption := LegalCopyright;
  FillEmails;
end;

procedure TAboutForm.lCopyrightClick(Sender: TObject);
begin
	ShellExecute( Self.Handle, 'open', 'www.analit.net', nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.GetVersionInformation(var Version,
  LegalCopyright: String);
var
  RxVer : TVersionInfo;
begin
  if FileExists(Application.ExeName) then begin
    try
      RxVer := TVersionInfo.Create(Application.ExeName);
      try
        try
          Version := LongVersionToString(RxVer.FileLongVersion);
        except
          Version := '';
        end;
        try
          LegalCopyright := RxVer.LegalCopyright;
        except
          LegalCopyright := '';
        end;
      finally
        RxVer.Free;
      end;
    except
      Version := '';
      LegalCopyright := '';
    end;
  end
  else begin
    Version := '';
    LegalCopyright := '';
  end;
end;

procedure TAboutForm.FillEmails;
var
  header : String;
begin
  mEmails.Clear;
  if DM.adsQueryValue.Active then
    DM.adsQueryValue.Close;

  try
    DM.adsQueryValue.SQL.Text := 'select ClientId, Name from analitf.clients';
    DM.adsQueryValue.Open;
    if DM.adsQueryValue.RecordCount > 0 then begin
      if DM.adsUser.FieldByName('IsFutureClient').AsBoolean then
        header := 'адрес заказа '
      else
        header := 'клиент ';
      try
        while not DM.adsQueryValue.Eof do begin
          if DM.adsQueryValue.RecNo > 1 then begin
            mEmails.Lines.Add('');
          end;
          mEmails.Lines.Add(header + DM.adsQueryValue.FieldByName('Name').AsString);
          mEmails.Lines.Add('   E-mail для накладных: ' + DM.adsQueryValue.FieldByName('ClientId').AsString + '@waybills.analit.net ');
          mEmails.Lines.Add('   E-mail для отказов: ' + DM.adsQueryValue.FieldByName('ClientId').AsString + '@refused.analit.net');
          DM.adsQueryValue.Next;
        end;
      finally
        DM.adsQueryValue.Close;
      end;
    end;
  except
    on E : Exception do
      WriteExchangeLog('AboutForm', 'Ошибка при заполнении email: ' + E.Message);
  end;
end;

procedure TAboutForm.IncreaseMemo;
var
  newHeight,
  diffHeight : Integer;
begin
  try
    if mEmails.Lines.Count > 0 then begin
      newHeight := GetNeedHeight(mEmails);
      diffHeight := newHeight - mEmails.Height;
      if diffHeight > 0 then begin
        Self.Height := Self.Height + diffHeight;
        lCopyright.Top := lCopyright.Top + diffHeight;
        bbtnOk.Top := bbtnOk.Top + diffHeight;
        mEmails.Height := newHeight;
      end;
    end;
  except
    on E : Exception do
      WriteExchangeLog('AboutForm', 'Ошибка вычислении новой высоты mEmails: ' + E.Message);
  end;
end;

function TAboutForm.GetNeedHeight(Memo: TMemo): Integer;
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

procedure TAboutForm.FormShow(Sender: TObject);
begin
  inherited;
  IncreaseMemo;
end;

end.
