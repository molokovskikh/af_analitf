unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBCtrls, ShellApi;

type
  TAboutForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    BitBtn1: TBitBtn;
    DBText1: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    lIndent: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetVersionInformation(var Version, LegalCopyright: String);
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses DModule, Main, DB, RxVerInf;

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
	Label1.Caption := Application.Title;
	Label2.Caption := 'Версия : ' + Version +
		' (' + DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString + ')';
	lIndent.Caption := 'Идентификация : ' + DM.adtClients.FieldByName('ClientID').AsString +
    ' (' + DM.adtClients.FieldByName('Name').AsString + ')';
	Label4.Caption := LegalCopyright;
end;

procedure TAboutForm.Label4Click(Sender: TObject);
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

end.
