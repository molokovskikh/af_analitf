unit ActiveUsers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ComObj;

type
  {TUserInfo=record
    Computer, User: array[0..31] of Char;
  end;}

  TActiveUsersForm = class(TForm)
    ListView: TListView;
    ImageList: TImageList;
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowActiveUsers;

implementation

uses DModule, AProc, Constant;

{$R *.dfm}

procedure ShowActiveUsers;
begin
  with TActiveUsersForm.Create(Application) do try
    if ListView.Items.Count>0 then ListView.ItemIndex:=0;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TActiveUsersForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if Key = VK_ESCAPE then ModalResult := mrOK;
end;

end.
