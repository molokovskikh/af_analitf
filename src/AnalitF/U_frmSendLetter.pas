unit U_frmSendLetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, U_VistaCorrectForm,
  AProc,
  U_ExchangeLog,
  ArchiveHelper,
  SQLWaiting;

type
  TfrmSendLetter = class(TVistaCorrectForm)
    odAttach: TOpenDialog;
    pBottom: TPanel;
    btnSend: TButton;
    btnCancel: TButton;
    pTop: TPanel;
    gbMessage: TGroupBox;
    lBody: TLabel;
    leSubject: TLabeledEdit;
    mBody: TMemo;
    pAttach: TPanel;
    gbAttach: TGroupBox;
    lbFiles: TListBox;
    btnAddFile: TButton;
    btnDelFile: TButton;
    pAddLogs: TPanel;
    cbAddLogs: TCheckBox;
    rgEmailGroup: TRadioGroup;
    procedure btnAddFileClick(Sender: TObject);
    procedure btnDelFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    ArchiveSize : Int64;
    procedure RefreshScrollWidth;
    procedure CheckAttachs();
    function AttachsExists() : Boolean;
  public
    { Public declarations }
  end;

var
  frmSendLetter: TfrmSendLetter;

implementation

{$R *.dfm}

procedure TfrmSendLetter.btnAddFileClick(Sender: TObject);
begin
  if odAttach.Execute then begin
    lbFiles.Items.AddStrings(odAttach.Files);
    RefreshScrollWidth;
  end;
end;

procedure TfrmSendLetter.btnDelFileClick(Sender: TObject);
begin
  lbFiles.DeleteSelected;
  RefreshScrollWidth;
end;

procedure TfrmSendLetter.RefreshScrollWidth;
var
  MaxTextWidth,
  CurrTextWidth,
  I : Integer;
begin
  if lbFiles.Count = 0 then
    lbFiles.ScrollWidth := 0
  else begin
    MaxTextWidth := lbFiles.Canvas.TextWidth(lbFiles.Items[0]);
    for I := 1 to lbFiles.Count-1 do begin
      CurrTextWidth := lbFiles.Canvas.TextWidth(lbFiles.Items[i]);
      if CurrTextWidth > MaxTextWidth then
        MaxTextWidth := CurrTextWidth;
    end;
    lbFiles.ScrollWidth := MaxTextWidth + 5;
  end;
end;

procedure TfrmSendLetter.FormShow(Sender: TObject);
begin
  {
  Êíîïêè âñå ğàâíî ñêğûâàşòñÿ ïğè èñïîëüçîâàíèè "Êğóïíûõ øğèôòîâ",
  ïîıòîìó èì ÿâíî âûñòàëÿåòñÿ ïîëîæåíèå ñëåâà
  Ğåøåíèå íàòîëêíóëà ñòğàíèöà:
  http://www.delphikingdom.com/asp/answer.asp?IDAnswer=38724
  }
  btnCancel.Left := pBottom.Width - 10 - btnCancel.Width;
  btnSend.Left := btnCancel.Left - 10 - btnSend.Width;
end;

procedure TfrmSendLetter.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and CanClose and AttachsExists() then begin
    ArchiveSize := 0;

    ShowSQLWaiting(CheckAttachs, 'Ïğîâåğêà âëîæåíèé...');

    if (ArchiveSize > 4 * 1024 * 1024) then begin
      CanClose := False;
      AProc.MessageBox('Ğàçìåğ àğõèâà ñ âëîæåííûìè ôàéëàìè ïğåâûøàåò 4Ìá.', MB_ICONWARNING);
    end;
  end;
end;

procedure TfrmSendLetter.CheckAttachs;
var
  Attachs : TStringList;
  helper : TArchiveHelper;

  procedure AddFile(FileName : String);
  begin
    if Attachs.IndexOf(FileName) = -1 then
      Attachs.Add(FileName);
  end;

begin
  try
    Attachs := TStringList.Create;
    Attachs.CaseSensitive := False;
    try
      Attachs.AddStrings(frmSendLetter.lbFiles.Items);
      if cbAddLogs.Checked then begin
        AddFile(ExeName + '.TR');
        AddFile(ExeName + '.old.TR');
        AddFile(ExePath + 'Exchange.log');
        AddFile(ExePath + 'AnalitFup.log');
      end;

      helper := TArchiveHelper.Create(Attachs);
      try
        ArchiveSize := helper.GetArchivedSize();
      finally
        helper.Free;
      end;

    finally
      Attachs.Free;
    end;
  except
    on E : Exception do
      WriteExchangeLog('TfrmSendLetter.CheckAttachs', 'Îøèáêà: ' + E.Message);
  end;
end;

function TfrmSendLetter.AttachsExists: Boolean;
begin
  Result := cbAddLogs.Checked or (lbFiles.Items.Count > 0);
end;

end.
