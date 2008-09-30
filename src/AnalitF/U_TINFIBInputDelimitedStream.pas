unit U_TINFIBInputDelimitedStream;

interface

uses
  SysUtils, Classes, RTLConsts, ibase, FIBQuery, FIBMiscellaneous, StrUtil{,
  rc_rndcrypt, LU_Tracer, rc_codecs};

type
  (* TFIBInputDelimitedFile *)
  TINFIBInputDelimitedStream = class(TFIBBatchInputStream)
  protected
    FColDelimiter,
    FRowDelimiter: string;
    FEOF: Boolean;
    FLookAhead: Char;
    FReadBlanksAsNull: Boolean;
    FSkipTitles: Boolean;
    FStream: TStream;
//    FText : TextFile;
  public
    destructor Destroy; override;
    function GetColumn(var Col: string): Integer;
    function ReadParameters: Boolean; override;
    procedure ReadyStream; override;
    property Stream : TStream read FStream write FStream;
    property ColDelimiter: string read FColDelimiter write FColDelimiter;
    property ReadBlanksAsNull: Boolean read FReadBlanksAsNull
      write FReadBlanksAsNull;
    property RowDelimiter: string read FRowDelimiter write FRowDelimiter;
    property SkipTitles: Boolean read FSkipTitles write FSkipTitles;
  end;


implementation

const
  NULL_TERMINATOR = #0;
  TAB = #9;
  CR = #13;
  LF = #10;
  CRLF = #13#10;

{ TINFIBInputDelimitedStream }

destructor TINFIBInputDelimitedStream.Destroy;
begin
  inherited Destroy;
end;

function TINFIBInputDelimitedStream.GetColumn(var Col: string): Integer;
var
  c: Char;
  BytesRead: Integer;

  procedure ReadInput;
  begin
    if FLookAhead <> NULL_TERMINATOR then
    begin
      c := FLookAhead;
      BytesRead := 1;
      FLookAhead := NULL_TERMINATOR;
    end
    else
      BytesRead := FStream.Read(c, 1);
  end;

  procedure CheckCRLF(Delimiter: string);
  begin
    if (c = CR) and (PosCh(LF, Delimiter) > 0) then
    begin
      BytesRead := FStream.Read(c, 1);
      if (BytesRead = 1) and (c <> #10) then
        FLookAhead := c
    end;
  end;

begin
  Col := '';
  Result := 0;
  ReadInput;
  while BytesRead <> 0 do
  begin
    if PosCh(c, FColDelimiter) > 0 then
    begin
      CheckCRLF(FColDelimiter);
      Result := 1;
      break;
    end
    else
      if PosCh(c, FRowDelimiter) > 0 then
      begin
        CheckCRLF(FRowDelimiter);
        Result := 2;
        break;
      end
      else
        Col := Col + c;
    ReadInput;
  end;
end;
function TINFIBInputDelimitedStream.ReadParameters: Boolean;
var
  i, curcol: Integer;
  Col: string;
begin
  Result := False;
  if not FEOF then
  begin
    curcol := 0;
    repeat
      i := GetColumn(Col);
      if (i = 0) then FEOF := True;
      if (curcol < Params.Count) then
      begin
        try
          if (Col = '') then
            case Params[curcol].ServerSQLType of
              SQL_TEXT, SQL_VARYING:
                if ReadBlanksAsNull then
                  Params[curcol].IsNull := True
                else
                  Params[curcol].AsString := '';
            else
              Params[curcol].IsNull := True
            end
          else begin
            if pos('CRYPT', UpperCase(Params[curcol].Name)) > 0 then begin
//              Params[curcol].AsString := rc_Encode(EnCryptString(Col, '12345678'));
              //(Length(Col)>0) and (Length(Params[curcol].AsString) = 0)
//              Writeln(FText, 'Col="', Col, '"   Param="', Params[curcol].AsString, '"  Enc="', rc_Encode(Params[curcol].AsString), '"');
//              Flush(FText);

            end
            else
              Params[curcol].AsString := Col;
          end;
          Inc(curcol);
        except
          on E: Exception do
          begin
            if not (FEOF and (curcol = Params.Count)) then
              raise;
          end;
        end;
      end;
    until (FEOF) or (i = 2);
    Result := ((FEOF) and (curcol = Params.Count)) or (not FEOF);
//    if FEOF then
//      CloseFile(FText);
  end;
end;

procedure TINFIBInputDelimitedStream.ReadyStream;
var
  col: string;
  curcol: Integer;
begin
  if FColDelimiter = '' then FColDelimiter := TAB;
  if FRowDelimiter = '' then FRowDelimiter := CRLF;
  FLookAhead := NULL_TERMINATOR;
  FEOF := False;
  if not Assigned(FStream) then
    raise Exception.CreateRes(@SReadError);
//  AssignFile(FText, ExtractFilePath(ParamStr(0)) + ExtractFileName(FileName));
//  Rewrite(FText);
  if FSkipTitles then
  begin
    curcol := 0;
    while curcol < Params.Count do
    begin
      GetColumn(Col);
      Inc(CurCol)
    end;
  end;
end;

end.
