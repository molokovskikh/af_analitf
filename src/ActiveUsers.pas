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

uses DModule, AProc, ADODB, ADOInt, Constant;

{$R *.dfm}

procedure ShowActiveUsers;
begin
  with TActiveUsersForm.Create(Application) do try
    //читаем список пользователей из файла *.ldb
    {FileName:=ExePath+ChangeFileExt(DatabaseName,'.ldb');
    AssignFile(F,FileName);
    ListView.Items.BeginUpdate;
    Reset(F);
    try
      while not Eof(F) do begin
        Read(F,UserInfo);
        with ListView.Items.Add do begin
          ImageIndex:=0;
          Caption:=UserInfo.User;
          SubItems.Add(UserInfo.Computer);
        end;
      end;
    finally
      CloseFile(F);
      ListView.Items.EndUpdate;
    end;}
    //получаем список пользователей с помощью ADOX
    //C:\Documents and Settings\Alex\Application Data\Microsoft\Access\System.mdw
    {Catalog:=CreateOleObject('ADOX.Catalog');
    try
      Catalog.ActiveConnection:=DM.MainConnection.ConnectionObject;
      MessageBox(IntToStr(Catalog.Users.Count));
      for I:=0 to Catalog.Users.Count-1 do
        with ListView.Items.Add do begin
          ImageIndex:=0;
          Caption:=Catalog.Users[I].Name;
          //SubItems.Add(UserInfo.Computer);
        end;
    finally
      Catalog:=Unassigned;
    end;}
    //читаем с помощью User Roster
    DM.MainConnection.OpenSchema(siProviderSpecific,EmptyParam,
      JET_SCHEMA_USERROSTER,DM.adsSelect);
    with DM.adsSelect do try
      while not Eof do begin
        with ListView.Items.Add do begin
          ImageIndex:=0;
          Caption:=FieldByName('LOGIN_NAME').AsString;
          SubItems.Add(FieldByName('COMPUTER_NAME').AsString);
        end;
        Next;
      end;
    finally
      Close;
    end;
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
