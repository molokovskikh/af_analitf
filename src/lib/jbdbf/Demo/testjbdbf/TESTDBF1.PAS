unit Testdbf1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, jbDbf, Gauges, ExtCtrls, FileCtrl, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DBF1: TjbDBF;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ProgressBar: TProgressBar;
    Label1: TLabel;
    ListBox1: TListBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit2: TEdit;
    Label2: TLabel;
    Bevel1: TBevel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DBF1Found(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBF1Progress(Sender: TObject; const Operace: ShortString;
      Progress: Integer);
    procedure DBF1Query(Sender: TObject; const IdxName, IdxField,
      Key: ShortString; var Accept, Cancel: Boolean);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
  private
    { Private declarations }
    N:Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close
end;

Const
  jmspoub='test_y.dbf';
  jmidxcislo='cislo';
  jmidxtest='test';

function RandomNejakeJmeno(PLen:Integer):String;
var
  str:String;
begin
  Randomize;
  str:='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result:='';
  repeat
    Result:=Result+str[Random(Length(str))+1];
  until(Length(Result)=PLen)
end;


procedure TForm1.Button2Click(Sender: TObject);
Var
  S: String;
  I,J: Integer;
  A: Array[1..100] of String[8];
  OK: Boolean;
begin
  {zrus predchozi}
  SysUtils.DeleteFile(Edit2.Text+jmspoub);
  SysUtils.DeleteFile(Edit2.Text+jmidxcislo+'.idx');
  SysUtils.DeleteFile(Edit2.Text+jmidxtest+'.idx');
  {vyrob novou tabulku s indexy}
  With DBF1 Do
  Begin
    MakeField(1,jmidxcislo,'n',10,0,jmidxcislo+'.idx',dbfUnique,dbfDescending);
    MakeField(2,jmidxtest,'c',50,0,jmidxtest+'.idx',dbfDuplicates,dbfAscending);
    CreateDB(Edit2.Text+jmspoub,10+50,2,0);
    FileName := Edit2.Text+jmspoub;
    {make some fields}
    For I := 1 To 100 Do
    Begin
      Repeat
        OK := True;
        S := RandomNejakeJmeno(8);
        For J := 1 To I-1 Do //jen jeden vyskyt
          If A[J] = ShortString(S) Then
          Begin
            OK := False;
            Break
          End
      Until OK;
      A[I] := ShortString(S) //sup do pole
    End;
    If Open Then
    Begin
      For I := 1 To 100 Do Begin
        Store(jmidxcislo,ShortString(IntToStr(I)));
        Store(jmidxtest,{'Ahojky '}A[I]+ShortString(' ')+ShortString(IntToStr(I)));
        NewRecord;
      End;
      {preindexuj}
      Reindex;
      {RemoveIndexes(1);}
      ProgressBar.Position:=0;
      Panel2.Caption:='';
      Close;
      Button3.Enabled:=True; //je to priklad, nekontroluje predchozi existenci
    End;
  End;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  N:=0;
  {find proc}
  With DBF1 Do Begin
    FileName:=Edit2.Text+jmspoub;
    If Open Then Begin
      Find(jmidxcislo+'.idx',jmidxcislo); {hledej pres Found+Query}
      ProgressBar.Position:=0;
      Panel2.Caption:='';
      Close
    End;
  End;
end;

procedure TForm1.DBF1Found(Sender: TObject);
begin
  //find
  {standardni hlasky}
  If Radiobutton1.Checked Then Begin
    Label1.Caption:='Found ('+DBF1.Load(jmidxcislo)+'):';
    Edit1.Text:=DBF1.Load(jmidxtest);
  End
  Else Begin
    Inc(N);
    Label1.Caption:='Found '+IntToStr(N)+' fields:';
    ListBox1.Items.Add(DBF1.Load(jmidxcislo)+' -- '+DBF1.Load(jmidxtest));
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit2.Text := 'c:\_testdbf\';{toto je cesta k souboru}
  //make directory when doesn't exists
  ForceDirectories(Edit2.Text);
  Edit1.Text := '';
  Label1.Caption:='';
  N:=0;
  ListBox1.Clear;
end;

procedure TForm1.DBF1Progress(Sender: TObject; const Operace: ShortString;
  Progress: Integer);
begin
  ProgressBar.Position :=Progress;
  Panel2.Caption:=String(Operace);
  Application.ProcessMessages
end;

procedure TForm1.DBF1Query(Sender: TObject; const IdxName, IdxField,
  Key: ShortString; var Accept, Cancel: Boolean);
Var I,I1,I2:Integer;
begin
  //jen priprava promennych
  Try
    I1 := StrToInt(Edit3.Text);
    If NOT (I1 in [1..100]) Then I1 := 1;
  Except
    I1 := 1;
  End;
  Try
    I2 := StrToInt(Edit4.Text);
    If NOT (I2 in [1..100]) Then I2 := 1;
  Except
    I2 := 100
  End;
  If I1 > I2 Then
  Begin
    I := I1; I1 := I2; I2 := I;
  End;
  {zde realizace dotazu a accept/cancel}
  If Key<>'' Then
    If Radiobutton1.Checked Then Begin
      If StrToInt(String(Key))=I1 Then Begin
        Accept:=True; {tento si vezmi}
        Cancel:=True; {ale dalsi jiz odmitni}
      End;
    End
    Else Begin
      If (StrToInt(String(Key))>=I1) And (StrToInt(String(Key))<=I2) Then Accept:=True;
    End;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  Edit4.Visible :=  NOT RadioButton1.Checked;
  Edit1.Visible := RadioButton1.Checked;
  Listbox1.Visible := NOT RadioButton1.Checked;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  Edit4.Visible :=  RadioButton2.Checked;
  Edit1.Visible := NOT RadioButton2.Checked;
  Listbox1.Visible := RadioButton2.Checked;
end;

procedure TForm1.Edit3Exit(Sender: TObject);

begin
  Try
    TEdit(Sender).Text := IntToStr(StrToInt(Trim(TEdit(Sender).Text)))
  Except
    TEdit(Sender).Text := '';
  End;
end;

end.
