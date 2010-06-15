unit U_frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,
  SevenZip;

type
  TfrmMain = class(TForm)
    sbOpen: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure sbOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  ArchiveHelper;

{$R *.dfm}

procedure TfrmMain.sbOpenClick(Sender: TObject);
var
  ar : TArchiveHelper;
  Content : String;
begin
  if OpenDialog.Execute then begin
    ar := TArchiveHelper.Create(OpenDialog.FileName);
    try
      Content := ar.GetEncodedContent;
    finally
      ar.Free;
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if not LoadSevenZipDLL then
    ShowMessage('Не найдена библиотека 7-zip32.dll, необходимая для работы программы.');
end;

end.
