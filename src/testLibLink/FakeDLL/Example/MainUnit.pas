unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FakeDll;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button4: TButton;
    GroupBox2: TGroupBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    procedure NormalLoad(DllName : String);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    NormalDllHandle : HINST;
    FakeDll         : TFakeDll;
    Proc            : procedure;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  DllExampleName = 'test_dll.dll';
  Proc1Name      = 'Function1';
  Proc2Name      = 'Function2';
  Proc3Name      = 'Function3';
  Ord1           = 1;
  Ord2           = 2;
  Ord3           = 3;

{$INCLUDE dll_dump.bin}

implementation

{$R *.DFM}

procedure TForm1.NormalLoad(DllName : String);
begin
  NormalDllHandle := GetModuleHandle(PChar(DllName));
  if NormalDllHandle = 0 then
    NormalDllHandle := LoadLibrary(PChar(DllName));
  Label2.Caption := IntToHex(NormalDllHandle, 8) + 'h';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  NormalLoad(DllExampleName);
  if NormalDllHandle = 0 then Exit;

  Button2.Enabled  := true;
  Button3.Enabled  := true;
  Button8.Enabled  := true;
  Button9.Enabled  := true;
  Button10.Enabled := true;
  Button11.Enabled := true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, Proc1Name);
  Proc;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, Proc2Name);
  Proc;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if FakeDll = nil then FakeDll := TFakeDll.Create;
  FakeDll.InjectDll(@DumpData[1], true);

  Button6.Enabled  := true;
  Button7.Enabled  := true;
  Button12.Enabled := true;
  Button13.Enabled := true;
  Button14.Enabled := true;
  Button15.Enabled := true;

  Label4.Caption := IntToHex(FakeDll.FDHandle, 8) + 'h';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if NormalDllHandle <> 0 then FreeLibrary(NormalDllHandle);
  if FakeDll <> nil then FakeDll.Free;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(Proc1Name);
  Proc;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(Proc2Name);
  Proc;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, Proc3Name);
  Proc;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, PChar(Ord1));
  Proc;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, PChar(Ord2));
  Proc;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Proc := GetProcAddress(NormalDllHandle, PChar(Ord3));
  Proc;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(Proc3Name);
  Proc;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(PChar(Ord1));
  Proc;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(PChar(Ord2));
  Proc;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  Proc := FakeDll.GetFDProcAddress(PChar(Ord3));
  Proc;
end;

end.
