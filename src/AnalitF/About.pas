unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBCtrls, ShellApi;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    DBMemo1: TDBMemo;
    BitBtn1: TBitBtn;
    DBText1: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    lIndent: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses DModule, Main, DB;

{$R *.dfm}

procedure TAboutForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key = VK_ESCAPE then ModalResult := mrOK;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
	Label1.Caption := Application.Title;
	Label2.Caption := 'Версия : ' + MainForm.VerInfo.FileVersion +
		' (' + DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString + ')';
	lIndent.Caption := 'Идентификация : ' + DM.adtClients.FieldByName('ClientID').AsString +
    ' (' + DM.adtClients.FieldByName('Name').AsString + ')';
	Label4.Caption := MainForm.VerInfo.LegalCopyright;
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
	ShellExecute( Self.Handle, 'open', 'www.analit.net', nil, nil, SW_SHOWNORMAL);
end;

end.
