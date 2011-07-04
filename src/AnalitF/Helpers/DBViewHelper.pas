unit DBViewHelper;

interface

uses
  StdCtrls,
  DB,
  MyAccess;

type
  TDBViewHelper = class
   public
    class procedure LoadProcedures(
      comboList : TComboBox;
      producers : TMyQuery;
      id: TLargeintField;
      Name: TStringField);
  end;

implementation

{ TDBViewHelper }

class procedure TDBViewHelper.LoadProcedures(comboList: TComboBox;
  producers: TMyQuery; id: TLargeintField; Name: TStringField);
begin
  if not producers.Active then
    producers.Open;
  try
    comboList.Clear;
    while not producers.Eof do begin
      comboList.AddItem(Name.AsString, TObject(Id.AsInteger));
      producers.Next;
    end;
    comboList.ItemIndex := 0;
  finally
    producers.Close;
  end;
end;

end.
