unit Normative;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RxCombos, Spin, Child, Menus;

type
  TNormativeForm = class(TChildForm)
    RichEdit: TRichEdit;
    FontDialog: TFontDialog;
    PopupMenu: TPopupMenu;
    itmFont: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure itmFontClick(Sender: TObject);
  private
    { Private declarations }
  public
    FileName: string;//имя отображаемого файла

    //печать документа
    procedure Print( APreview: boolean = False); override;
    procedure ShowForm(const FileName: string); reintroduce;
  end;

var
  NormativeForm: TNormativeForm;

implementation

{$R *.dfm}

uses
  Main, AProc;

procedure TNormativeForm.FormCreate(Sender: TObject);
begin
  inherited;
  PrintEnabled:=True;
end;

procedure TNormativeForm.ShowForm(const FileName: string);
begin
  RichEdit.Lines.LoadFromFile(ExePath+SDirDocs+'\'+ChangeFileExt(FileName,'.txt'));
  inherited ShowForm;
end;

procedure TNormativeForm.Print;
begin
  RichEdit.Print('Нормативный акт');
end;

procedure TNormativeForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #27: if Assigned(PrevForm) then PrevForm.ShowForm;
  end;
end;

procedure TNormativeForm.itmFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(RichEdit.Font);
  if FontDialog.Execute then RichEdit.Font.Assign(FontDialog.Font);
end;

end.
