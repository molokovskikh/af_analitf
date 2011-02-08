unit U_frameContextReclame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExtCtrls,
  Jpeg,
  FileUtil,
  AProc;

type
  TframeContextReclame = class(TFrame)
  private
    { Private declarations }
    FImage : TImage;
    FFileList : TStringList;
    tmrStopReclame : TTimer;
    FReclameIndex : Integer;
    procedure CreateVisualComponent;
    procedure LoadFiles;
    function ReclameExists(CatalogId : Int64) : Boolean;
    procedure LoadReclame(CatalogId : Int64);
    procedure CloseReclameOnTimer(Sender : TObject);
    procedure RecalcPosition;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl) : TframeContextReclame;
    procedure GetReclame(CatalogId : Int64);
    procedure StopReclame();
  end;

implementation

uses Math;

{$R *.dfm}

{ TframeContextReclame }

class function TframeContextReclame.AddFrame(Owner: TComponent;
  Parent: TWinControl): TframeContextReclame;
begin
  Result := TframeContextReclame.Create(Owner);
  Result.Visible := False;
  Result.Name := '';
  Result.Parent := Parent;
{
  Result.Left := ALeft;
  Result.Height := AHeight - 2;
  Result.Top := 1;
  Result.FOnChangeFilter := AOnChangeFilter;
  Result.PrepareFrame;
}  
end;

procedure TframeContextReclame.CloseReclameOnTimer(Sender: TObject);
begin
  StopReclame();
end;

constructor TframeContextReclame.Create(AOwner: TComponent);
begin
  inherited;
  FFileList := TStringList.Create;

  CreateVisualComponent;
  LoadFiles;
  FReclameIndex := 0;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeContextReclame.CreateVisualComponent;
begin
  FImage := TImage.Create(Self);
  FImage.Parent := Self;
  FImage.Align := alClient;
  FImage.AutoSize := False;
  FImage.Center := True;
  FImage.Proportional := True;
  tmrStopReclame := TTimer.Create(Self);
  tmrStopReclame.Enabled := False;
  tmrStopReclame.Interval := 3000;
  tmrStopReclame.OnTimer := CloseReclameOnTimer;
end;

destructor TframeContextReclame.Destroy;
begin
  FFileList.Free;
  inherited;
end;

procedure TframeContextReclame.GetReclame(CatalogId: Int64);
begin
  StopReclame;
  if ReclameExists(CatalogId) then begin
    LoadReclame(CatalogId);
    RecalcPosition;
    Show;
    BringToFront;
    tmrStopReclame.Enabled := True;
  end;
end;

procedure TframeContextReclame.LoadFiles;
var
  SR: TSearchrec;
begin
  try
    if SysUtils.FindFirst(RootFolder() + SDirContextReclame + '\*.jpg', faAnyFile - faDirectory, SR ) = 0
    then
      repeat
        if GetFileSize(RootFolder() + SDirContextReclame + '\' + SR.Name) > 0 then
          FFileList.Add(ChangeFileExt(SR.Name, ''));
      until FindNext(SR)<>0;
  finally
    SysUtils.FindClose(SR);
  end;
end;

procedure TframeContextReclame.LoadReclame(CatalogId: Int64);
var
  jpg: TJpegImage;
begin
  jpg := TJpegImage.Create;
  try
    //jpg.LoadFromFile(RootFolder() + SDirContextReclame + '\' + IntToStr(CatalogId) + '.jpg');
    jpg.LoadFromFile(RootFolder() + SDirContextReclame + '\' + FFileList[FReclameIndex] + '.jpg');
    FImage.Picture.Bitmap.Assign(jpg);
    Self.Width := jpg.Width;
    Self.Height := jpg.Height;
  finally
    jpg.Free;
  end;
end;

procedure TframeContextReclame.RecalcPosition;
var
  decWidth,
  decHeight,
  maxDec : Integer;
begin
  if (Self.Height <= (Parent.ClientHeight div 3) + 3) and (Self.Width <= Parent.ClientWidth)
  then begin
    Self.Top := Parent.ClientHeight - Self.Height;
    Self.Left := (Parent.ClientWidth - Self.Width) div 2;
  end
  else
  begin
    decWidth := Self.Width - Parent.ClientWidth;
    decHeight := Self.Height - (Parent.ClientHeight div 3);
    maxDec := Max(decWidth, decHeight);
    Self.Width := Self.Width - maxDec;
    Self.Height := Self.Height - maxDec;
  end;
  Self.Top := Parent.ClientHeight - Self.Height;
  Self.Left := (Parent.ClientWidth - Self.Width) div 2;
end;

function TframeContextReclame.ReclameExists(CatalogId: Int64): Boolean;
begin
  Result := {FFileList.IndexOf(IntToStr(CatalogId)) >= 0} FReclameIndex < FFileList.Count;
end;

procedure TframeContextReclame.StopReclame;
begin
  tmrStopReclame.Enabled := False;
  if Visible then begin
    Hide;
    FReclameIndex := (FReclameIndex + 1) mod FFileList.Count;
  end;
end;

end.
