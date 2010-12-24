unit LU_TDataExportAsXls;

interface

uses
  SysUtils,
  Classes;

type
  TDataExportAsXls = class
  private
    FCol, FRow: Word;

    FFileName : String;
    FStream : TStream;

    procedure WriteBlankCell;
    procedure WriteIntegerCell(const AValue: Integer);
    procedure WriteFloatCell(const AValue: Double);
    procedure WriteStringCell(const AValue: String);
    procedure IncColRow;
    procedure IncRow;
  protected
    procedure StartExport;
    procedure EndExport;
  public
    procedure WriteBlankRow;
    procedure WriteRow(Values: array of string);

    constructor Create(AFileName : String); overload;
    constructor Create(AStream : TStream); overload;
    destructor Destroy; override;
  end;

implementation

procedure StreamWriteWordArray(Stream: TStream; wr: array of Word);
var
  i: Integer;
begin
  for i := 0 to Length(wr)-1 do
    Stream.Write(wr[i], SizeOf(wr[i]));
end;

procedure StreamWriteAnsiString(Stream: TStream; S: String);
begin
  Stream.Write(PChar(S)^, Length(S));
end;

var
  CXlsBof: array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
  CXlsEof: array[0..1] of Word = ($0A, 00);
  CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  CXlsRk: array[0..4] of Word = ($27E, 10, 0, 0, 0);
  CXlsBlank: array[0..4] of Word = ($201, 6, 0, 0, $17);

{ TDataExportAsXls }

constructor TDataExportAsXls.Create(AFileName: String);
begin
  FFileName := AFileName;
  FStream := TFileStream.Create(FFileName, fmCreate);
  StartExport;
end;

constructor TDataExportAsXls.Create(AStream: TStream);
begin
  FFileName := '';
  FStream := AStream;
  StartExport;
end;

destructor TDataExportAsXls.Destroy;
begin
  EndExport;
  if Length(FFileName) > 0 then
    FStream.Free;
  inherited;
end;

procedure TDataExportAsXls.EndExport;
begin
  StreamWriteWordArray(FStream, CXlsEof);
end;

procedure TDataExportAsXls.IncColRow;
begin
  Inc(FCol);
{
  if FCol = ExpCols.Count - 1 then
  begin
    Inc(FRow);
    FCol := 0;
  end else
    Inc(FCol);
}    
end;

procedure TDataExportAsXls.IncRow;
begin
  Inc(FRow);
end;

procedure TDataExportAsXls.StartExport;
begin
  FCol := 0;
  FRow := 0;
  StreamWriteWordArray(FStream, CXlsBof);
end;

procedure TDataExportAsXls.WriteBlankCell;
begin
  CXlsBlank[2] := FRow;
  CXlsBlank[3] := FCol;
  StreamWriteWordArray(FStream, CXlsBlank);
//  Stream.WriteBuffer(CXlsBlank, SizeOf(CXlsBlank));
  IncColRow;
end;

procedure TDataExportAsXls.WriteBlankRow;
begin
  FCol := 0;
  WriteBlankCell;
  IncRow;
end;

procedure TDataExportAsXls.WriteFloatCell(const AValue: Double);
begin
  CXlsNumber[2] := FRow;
  CXlsNumber[3] := FCol;
  StreamWriteWordArray(FStream, CXlsNumber);
  FStream.WriteBuffer(AValue, 8);
  IncColRow;
end;

procedure TDataExportAsXls.WriteIntegerCell(const AValue: Integer);
var
  V: Integer;
begin
  CXlsRk[2] := FRow;
  CXlsRk[3] := FCol;
  StreamWriteWordArray(FStream, CXlsRk);
//  Stream.WriteBuffer(CXlsRk, SizeOf(CXlsRk));
  V := (AValue shl 2) or 2;
  FStream.WriteBuffer(V, 4);
  IncColRow;
end;

procedure TDataExportAsXls.WriteRow(Values: array of string);
var
  I : Integer;
begin
  FCol := 0;
  for I := Low(Values) to High(Values) do
    if Length(Values[i]) > 0 then
      WriteStringCell(Values[i])
    else
      WriteBlankCell;
  Inc(FRow);
end;

procedure TDataExportAsXls.WriteStringCell(const AValue: String);
var
  L: Word;
begin
  L := Length(AValue);
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := FRow;
  CXlsLabel[3] := FCol;
  CXlsLabel[5] := L;
  StreamWriteWordArray(FStream, CXlsLabel);
//  Stream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  StreamWriteAnsiString(FStream, AValue);
//  Stream.WriteBuffer(Pointer(AValue)^, L);
  IncColRow;
end;

end.
