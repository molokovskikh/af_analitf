unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBCtrls, ShellApi, U_VistaCorrectForm;

type
  TAboutForm = class(TVistaCorrectForm)
    Image1: TImage;
    Image2: TImage;
    BitBtn1: TBitBtn;
    dbtProviderName: TDBText;
    lApplicationTitle: TLabel;
    lVersion: TLabel;
    lCopyright: TLabel;
    lIndent: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure lCopyrightClick(Sender: TObject);
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
  lApplicationTitle.Caption := Application.Title;
  lVersion.Caption := 'Версия : ' + Version +
    ' (' + DM.adtParams.FieldByName( 'ProviderMDBVersion').AsString + ')';
  lIndent.Caption := 'Идентификация : ' + DM.adsUser.FieldByName('UserId').AsString;
  lCopyright.Caption := LegalCopyright;
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

end.
