
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  My Parser
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$IFNDEF UNIDACPRO}
{$I MyDac.inc}
unit MyParser;
{$ENDIF}
{$ENDIF}

interface
uses
  MemUtils, CRParser;

const
  lxAND      = 7 {MySymbolCount} + 1;
  lxAS       = lxAND + 1;
  lxBY       = lxAS + 1;
  lxCHARSET  = lxBY + 1;
  lxCOLUMNS  = lxCHARSET + 1;
  lxCREATE   = lxCOLUMNS + 1;
  lxCROSS    = lxCREATE + 1;
  lxDELETE   = lxCROSS + 1;
  lxDELIMITER = lxDELETE + 1;
  lxDESC     = lxDELIMITER + 1;
  lxDESCRIBE = lxDESC + 1;
  lxEXPLAIN  = lxDESCRIBE + 1;
  lxFOR      = lxEXPLAIN + 1;
  lxFORCE    = lxFOR + 1;
  lxFROM     = lxFORCE + 1;
  lxFUNCTION = lxFROM + 1;
  lxGROUP    = lxFUNCTION + 1;
  lxHAVING   = lxGROUP + 1;
  lxIGNORE   = lxHAVING + 1;
  lxINNER    = lxIGNORE + 1;
  lxINSERT   = lxINNER + 1;
  lxINTO     = lxINSERT + 1;
  lxIS       = lxINTO + 1;
  lxJOIN     = lxIS + 1;
  lxLEFT     = lxJOIN + 1;
  lxLIMIT    = lxLEFT + 1;
  lxLOCK     = lxLIMIT + 1;
  lxNATURAL  = lxLOCK + 1;
  lxOR       = lxNATURAL + 1;
  lxORDER    = lxOR + 1;
  lxPRIVILEGES = lxORDER + 1;
  lxPROCEDURE  = lxPRIVILEGES + 1;
  lxREPLACE  = lxPROCEDURE + 1;
  lxRIGHT    = lxREPLACE + 1;
  lxSELECT   = lxRIGHT + 1;
  lxSHOW     = lxSELECT + 1;
  lxSLAVE    = lxSHOW + 1;
  lxSTATUS   = lxSLAVE + 1;
  lxSTRAIGHT_JOIN = lxSTATUS + 1;
  lxTRIGGER  = lxSTRAIGHT_JOIN + 1;
  lxUPDATE   = lxTRIGGER + 1;
  lxUSE      = lxUPDATE + 1;
  lxWHERE    = lxUSE + 1;
  lxHANDLER  = lxWHERE + 1;
  lxSET      = lxHANDLER + 1;
  lxDISTINCT = lxSET + 1;
  lxDISTINCTROW = lxDISTINCT + 1;
  lxENGINES  = lxDISTINCTROW + 1;
  lxPROCESSLIST  = lxENGINES + 1;

type
  TMyParser = class (TSQLParser)
  protected
    function IsAlpha(Ch: _char): boolean; override;
    function IsStringQuote(Ch: _char): boolean; override;
    procedure ToRightQuote(RightQuote: _char); override;
 {$IFNDEF CLR}
 {$IFNDEF IS_UNICODE}
    procedure ToRightQuoteA(RightQuote: AnsiChar); override;
 {$ENDIF}
 {$ENDIF}
    function IsIdentQuote(Ch: _char): boolean; override;
    function IsInlineComment(Pos: integer): boolean; override;

    procedure InitParser; override;
  public
    function IsSemicolon(Code: integer): boolean; override;

    function LexemCodeSelect: integer; override;
    function LexemCodeFrom: integer; override;
    function LexemCodeWhere: integer; override;
    function LexemCodeOrder: integer; override;
    function LexemCodeBy: integer; override;
  end;

implementation

uses
  Classes, SysUtils;

var
  MySymbolLexems, MyKeywordLexems: _TStringList;

{ TMyParser }

procedure TMyParser.InitParser;
begin
  inherited;

  FSymbolLexems := MySymbolLexems;
  FKeywordLexems := MyKeywordLexems;

  CommentBegin := '/*';
  CommentEnd := '*/';

(*
SELECT
    [ALL | DISTINCT | DISTINCTROW ]
      [HIGH_PRIORITY]
      [STRAIGHT_JOIN]
      [SQL_SMALL_RESULT] [SQL_BIG_RESULT] [SQL_BUFFER_RESULT]
      [SQL_CACHE | SQL_NO_CACHE] [SQL_CALC_FOUND_ROWS]
    select_expr, ...
    [INTO OUTFILE 'file_name' export_options
      | INTO DUMPFILE 'file_name']
    [FROM table_references
      [WHERE where_definition]
      [GROUP BY {col_name | expr | position}
        [ASC | DESC], ... [WITH ROLLUP]]
      [HAVING where_definition]
      [ORDER BY {col_name | expr | position}
        [ASC | DESC] , ...]
      [LIMIT {[offset,] row_count | row_count OFFSET offset}]
      [PROCEDURE procedure_name(argument_list)]
      [FOR UPDATE | LOCK IN SHARE MODE]]
*)

  SetLength(FClauses, 8);
  FClauses[0] := lxWHERE;
  FClauses[1] := lxGROUP;
  FClauses[2] := lxHAVING;
  FClauses[3] := lxORDER;
  FClauses[4] := lxLIMIT;
  FClauses[5] := lxPROCEDURE;
  FClauses[6] := lxFOR;
  FClauses[7] := lxLOCK;
end;

function TMyParser.IsAlpha(Ch: _char): boolean;
begin
  Result := not (Ch = '#') and inherited IsAlpha(Ch);
end;

function TMyParser.IsStringQuote(Ch: _char): boolean;
begin
  Result := (Ch = '''')
    or (Ch = '"' {WAR if not MySQL ANSI mode});
end;

{$IFNDEF CLR}
{$IFNDEF IS_UNICODE}
procedure TMyParser.ToRightQuoteA(RightQuote: AnsiChar);
var
  i: integer;
  Ready: boolean;
begin
  repeat

    i := TextLength - Pos + 1 {Pos is counted from 1} + 1 {#0};
    asm
      PUSHAD

      MOV EAX, Self
      MOV EDI, EAX

      ADD EAX, Pos
      MOV EAX, [EAX] // EAX := Pos

      ADD EDI, FCurrentBlock
      MOV EDI, [EDI]
      ADD EDI, EAX
      DEC EDI // EDI := PChar(Text) + Pos {Pos is counted from 1};

      MOV ECX, i
      MOV AL, RightQuote
      REPNE   SCASB
      MOV i, ECX
      POPAD
    end;
    Pos := TextLength - i + 1;
    // Assert(Text[Pos] <> #0);

    Ready := True;
    i := Pos;
    while i > 2 do begin
      Dec(i);
      if Text[i] <> '\' then begin
        // ???.'
        Ready := True;
        Break;
      end;

      // ???\'
      Dec(i);
      if Text[i] <> '\' then begin
        // ??.\'
        Ready := False; // Continue scanning
        Break;
      end;

      // ??\\'
    end;
    if not Ready then
      Inc(Pos);
  until Ready;
end;
{$ENDIF}
{$ENDIF}

procedure TMyParser.ToRightQuote(RightQuote: _char);
var
  c: _char;
begin
{$IFNDEF CLR}
{$IFNDEF IS_UNICODE}
  if not FAdvancedStringParsing and (FStream = nil) then begin
    ToRightQuoteA(RightQuote);
    Exit;
  end;
{$ENDIF}
{$ENDIF}

  while Pos <= TextLength do begin
    c := Text[Pos];
    if (c = #13) or (c = #10) then begin
      if (Pos < TextLength) and (Text[Pos + 1] = #10) then
        Inc(Pos);
      Inc(FCurrLine);
      FCurrBegLine := Pos + 1;
    end
    else
    if c = '\' then // Escape character
      Inc(Pos)
    else
    if c = RightQuote then
      Break;
    Inc(Pos);
  end;
end;

function TMyParser.IsIdentQuote(Ch: _char): boolean;
begin
  case Ch of
    '`' {, '"' WAR if MySQL ANSI mode}:
      Result := True;
    else
      Result := False;
  end;
end;

function TMyParser.IsInlineComment(Pos: integer): boolean;
var
  c: _char;
begin
  c := Text[Pos];
  Result := c = '#';

  if not Result then
    Result := (TextLength >= Pos + 3) and (c = '-') and (Text[Pos + 1] = '-') and (Text[Pos + 2] = ' ');
    // Must be '-- ', see http://dev.mysql.com/doc/mysql/en/ansi-diff-comments.html for details
end;

function TMyParser.IsSemicolon(Code: integer): boolean;
begin
  Result := Code = 7; // ';'
end;

function TMyParser.LexemCodeSelect: integer;
begin
  Result := lxSELECT;
end;

function TMyParser.LexemCodeFrom: integer;
begin
  Result := lxFROM;
end;

function TMyParser.LexemCodeWhere: integer;
begin
  Result := lxWHERE;
end;

function TMyParser.LexemCodeOrder: integer;
begin
  Result := lxORDER;
end;

function TMyParser.LexemCodeBy: integer;
begin
  Result := lxBY;
end;

initialization
  MySymbolLexems := _TStringList.Create;
  MyKeywordLexems := _TStringList.Create;

  MySymbolLexems.AddObject('*', TObject(Integer(1)));
  MySymbolLexems.AddObject('=', TObject(Integer(2)));
  MySymbolLexems.AddObject(':', TObject(Integer(3)));
  MySymbolLexems.AddObject(',', TObject(Integer(4)));
  MySymbolLexems.AddObject('.', TObject(Integer(5)));
  MySymbolLexems.AddObject('/', TObject(Integer(6)));
  MySymbolLexems.AddObject(';', TObject(Integer(7)));
  MySymbolLexems.CustomSort(CRCmpStrings);

  MyKeywordLexems.AddObject('SELECT', TObject(Integer(lxSELECT)));
  MyKeywordLexems.AddObject('SHOW', TObject(Integer(lxSHOW)));
  MyKeywordLexems.AddObject('SLAVE', TObject(Integer(lxSLAVE)));
  MyKeywordLexems.AddObject('STATUS', TObject(Integer(lxSTATUS)));
  MyKeywordLexems.AddObject('FROM', TObject(Integer(lxFROM)));
  MyKeywordLexems.AddObject('WHERE', TObject(Integer(lxWHERE)));
  MyKeywordLexems.AddObject('ORDER', TObject(Integer(lxORDER)));
  MyKeywordLexems.AddObject('BY', TObject(Integer(lxBY)));
  MyKeywordLexems.AddObject('CHARSET', TObject(Integer(lxCHARSET)));
  MyKeywordLexems.AddObject('COLUMNS', TObject(Integer(lxCOLUMNS)));
  MyKeywordLexems.AddObject('GROUP', TObject(Integer(lxGROUP)));
  MyKeywordLexems.AddObject('PRIVILEGES', TObject(Integer(lxPRIVILEGES)));
  MyKeywordLexems.AddObject('PROCEDURE', TObject(Integer(lxPROCEDURE)));
  MyKeywordLexems.AddObject('FUNCTION', TObject(Integer(lxFUNCTION)));
  MyKeywordLexems.AddObject('IS', TObject(Integer(lxIS)));
  MyKeywordLexems.AddObject('AS', TObject(Integer(lxAS)));
  MyKeywordLexems.AddObject('AND', TObject(Integer(lxAND)));
  MyKeywordLexems.AddObject('OR', TObject(Integer(lxOR)));
  MyKeywordLexems.AddObject('CREATE', TObject(Integer(lxCREATE)));
  MyKeywordLexems.AddObject('REPLACE', TObject(Integer(lxREPLACE)));
  MyKeywordLexems.AddObject('INTO', TObject(Integer(lxINTO)));
  MyKeywordLexems.AddObject('UPDATE', TObject(Integer(lxUPDATE)));
  MyKeywordLexems.AddObject('DELETE', TObject(Integer(lxDELETE)));
  MyKeywordLexems.AddObject('DELIMITER', TObject(Integer(lxDELIMITER)));
  MyKeywordLexems.AddObject('INSERT', TObject(Integer(lxINSERT)));
  MyKeywordLexems.AddObject('HAVING', TObject(Integer(lxHAVING)));
  MyKeywordLexems.AddObject('LIMIT', TObject(Integer(lxLIMIT)));
  MyKeywordLexems.AddObject('LOCK', TObject(Integer(lxLOCK)));
  MyKeywordLexems.AddObject('FOR', TObject(Integer(lxFOR)));
  MyKeywordLexems.AddObject('DESC', TObject(Integer(lxDESC)));
  MyKeywordLexems.AddObject('DESCRIBE', TObject(Integer(lxDESCRIBE)));
  MyKeywordLexems.AddObject('EXPLAIN', TObject(Integer(lxEXPLAIN)));
  MyKeywordLexems.AddObject('USE', TObject(Integer(lxUSE)));
  MyKeywordLexems.AddObject('IGNORE', TObject(Integer(lxIGNORE)));
  MyKeywordLexems.AddObject('FORCE', TObject(Integer(lxFORCE)));
  MyKeywordLexems.AddObject('CROSS', TObject(Integer(lxCROSS)));
  MyKeywordLexems.AddObject('JOIN', TObject(Integer(lxJOIN)));
  MyKeywordLexems.AddObject('INNER', TObject(Integer(lxINNER)));
  MyKeywordLexems.AddObject('STRAIGHT_JOIN', TObject(Integer(lxSTRAIGHT_JOIN)));
  MyKeywordLexems.AddObject('TRIGGER', TObject(Integer(lxTRIGGER)));
  MyKeywordLexems.AddObject('LEFT', TObject(Integer(lxLEFT)));
  MyKeywordLexems.AddObject('NATURAL', TObject(Integer(lxNATURAL)));
  MyKeywordLexems.AddObject('RIGHT', TObject(Integer(lxRIGHT)));
  MyKeywordLexems.AddObject('HANDLER', TObject(Integer(lxHANDLER)));
  MyKeywordLexems.AddObject('SET', TObject(Integer(lxSET)));
  MyKeywordLexems.AddObject('DISTINCT', TObject(Integer(lxDISTINCT)));
  MyKeywordLexems.AddObject('DISTINCTROW', TObject(Integer(lxDISTINCTROW)));
  MyKeywordLexems.AddObject('ENGINES', TObject(Integer(lxENGINES)));
  MyKeywordLexems.AddObject('PROCESSLIST', TObject(Integer(lxPROCESSLIST)));

  MyKeywordLexems.CustomSort(CRCmpStrings);

finalization
  MySymbolLexems.Free;
  MySymbolLexems := nil;
  MyKeywordLexems.Free;
  MyKeywordLexems := nil;

end.
