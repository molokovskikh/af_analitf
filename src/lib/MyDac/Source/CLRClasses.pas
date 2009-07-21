
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright ?1998-2009 Devart. All right reserved.
//  CLRClasses
//////////////////////////////////////////////////

unit CLRClasses;

interface

{$I Dac.inc}

uses
  Classes, SysUtils;

type
  Int    = Integer;
  Int16  = SmallInt;
  Int32  = Integer;
  UInt16 = Word;
  UInt32 = LongWord;
  sbyte  = ShortInt;

  IntPtr = pointer;
  MulticastDelegate = pointer;
{$IFNDEF VER11P}
  TBytes = array of byte;
{$ENDIF}  

  BitConverter = class
  public
    class function GetBytes(value: word): TBytes; overload;
    class function GetBytes(value: cardinal): TBytes; overload;
    class function GetBytes(value: int64): TBytes; overload;
    class function GetBytes(value: double): TBytes; overload;
    class function GetBytes(value: single): TBytes; overload;
    class function Int64BitsToDouble(Value: int64): double;
    class function DoubleToInt64Bits(Value: double): int64;
    class function ToDouble(const value: TBytes; startIndex: integer): Double; overload;
    class function ToDouble(value: PAnsiChar; startIndex: integer): Double; overload;
    class function ToSingle(const value: TBytes; startIndex: integer): Single;
    class function ToInt64(const value: TBytes; startIndex: integer): Int64; overload;
    class function ToInt64(value: PAnsiChar; startIndex: integer): Int64; overload;
    class function ToInt32(const value: TBytes; startIndex: integer): integer; overload;
    class function ToInt32(value: PAnsiChar; startIndex: integer): integer; overload;
    class function ToInt16(const value: TBytes; startIndex: integer): smallint;
    class function ToUInt32(const value: TBytes; startIndex: integer): UInt32;
    class function ToUInt16(const value: TBytes; startIndex: integer): UInt16; overload;
    class function ToUInt16(value: PAnsiChar; startIndex: integer): UInt16; overload;
  end;

  Marshal = class
  public
    class function AllocHGlobal(cb: integer): pointer;
    class function ReallocHGlobal(pv: pointer; cb: pointer): pointer;
    class procedure FreeHGlobal(hglobal: pointer);
    class procedure FreeCoTaskMem(ptr: pointer);

    class function ReadByte(ptr: pointer; ofs: integer = 0): byte;
    class procedure WriteByte(ptr: pointer; val: byte); overload;
    class procedure WriteByte(ptr: pointer; ofs: integer; val: byte); overload;

    class function ReadInt16(ptr: pointer; ofs: integer = 0): smallint;
    class procedure WriteInt16(ptr: pointer; val: smallint); overload;
    class procedure WriteInt16(ptr: pointer; ofs: integer; val: smallint); overload;

    class function ReadInt32(ptr: pointer; ofs: integer = 0): integer;
    class procedure WriteInt32(ptr: pointer; val: integer); overload;
    class procedure WriteInt32(ptr: pointer; ofs, val: integer); overload;

    class function ReadInt64(ptr: pointer; ofs: integer = 0): int64;
    class procedure WriteInt64(ptr: pointer; val: int64); overload;
    class procedure WriteInt64(ptr: pointer; val: double); overload;
    class procedure WriteInt64(ptr: pointer; ofs: integer; val: int64); overload;

    class function ReadIntPtr(ptr: pointer; ofs: integer = 0): pointer;
    class procedure WriteIntPtr(ptr: pointer; val: pointer); overload;
    class procedure WriteIntPtr(ptr: pointer; ofs: integer; val: pointer); overload;

    class function PtrToStringAnsi(ptr: pointer; len: integer = 0): AnsiString;
    class function PtrToStringUni(ptr: pointer; len: integer = 0): WideString;
    class function StringToHGlobalAnsi(const s: AnsiString): pointer;
    class function StringToHGlobalUni(const s: WideString): pointer;

    class procedure Copy(const source: TBytes; startIndex: integer; destination: pointer; length: integer); overload;
    class procedure Copy(source: pointer; var destination: TBytes; startIndex: integer; length: integer); overload;

    class function GetIUnknownForObject(o: TInterfacedObject): IntPtr;
    class function AddRef(pUnk: IntPtr): integer;
    class function Release(pUnk: IntPtr): integer;
  end;

  Encoding = class
  public
    class function Default: Encoding;
    class function Unicode: Encoding;
    class function UTF8: Encoding;
    class function GetEncoding(codepage: integer): Encoding;
    class function Convert(srcEncoding, dstEncoding: Encoding; bytes: TBytes): TBytes; overload;
    class function Convert(srcEncoding, dstEncoding: Encoding; bytes: TBytes; index, count: integer): TBytes; overload;

    function GetBytes(const chars: AnsiString): TBytes; overload; virtual;
    function GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; virtual;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes; overload; virtual;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; virtual;

    function GetString(const bytes: TBytes): AnsiString; overload; virtual;
    function GetString(const bytes: TBytes; index: integer; count: integer): AnsiString; overload; virtual;
    function GetWideString(const bytes: TBytes): WideString; overload; virtual;
    function GetWideString(const bytes: TBytes; index: integer; count: integer): WideString; overload; virtual;

    function GetMaxByteCount(charCount: integer): integer; virtual;
  end;

  UnicodeEncoding = class(Encoding)
  public
    function GetBytes(const chars: AnsiString): TBytes; overload; override;
    function GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;

    function GetString(const bytes: TBytes): AnsiString; overload; override;
    function GetString(const bytes: TBytes; index: integer; count: integer): AnsiString; overload; override;
    function GetWideString(const bytes: TBytes): WideString; overload; override;
    function GetWideString(const bytes: TBytes; index: integer; count: integer): WideString; overload; override;

    function GetMaxByteCount(charCount: integer): integer; override;
  end;

  UTF8Encoding = class(Encoding)
  public
    function GetBytes(const chars: AnsiString): TBytes; overload; override;
    function GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;

    function GetString(const bytes: TBytes): AnsiString; overload; override;
    function GetString(const bytes: TBytes; index: integer; count: integer): AnsiString; overload; override;
    function GetWideString(const bytes: TBytes): WideString; overload; override;
    function GetWideString(const bytes: TBytes; index: integer; count: integer): WideString; overload; override;

    function GetMaxByteCount(charCount: integer): integer; override;
  end;

{$IFDEF WIN32}
  CodePageEncoding = class(Encoding)
  private
    FCodePage: integer;

  public
    constructor Create(CodePage: integer);

    function GetBytes(const chars: AnsiString): TBytes; override;
    function GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes; overload; override;
    function {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int; overload; override;

    function GetString(const bytes: TBytes): AnsiString; overload; override;
    function GetString(const bytes: TBytes; index: integer; count: integer): AnsiString; overload; override;
    function GetWideString(const bytes: TBytes): WideString; overload; override;
    function GetWideString(const bytes: TBytes; index: integer; count: integer): WideString; overload; override;

    function GetMaxByteCount(charCount: integer): integer; override;
  end;
{$ENDIF}

  TAnsiCharArray = array of AnsiChar;

  AnsiStringBuilder = class
  protected
    FString: TAnsiCharArray;
    FActualLength: integer;

    procedure SetActualLength(Value: integer);
  public
    constructor Create(capacity: integer); overload;
    constructor Create(const value: AnsiString; capacity: integer); overload;
    procedure Append(const value: AnsiString); overload;
    procedure Append(const value: AnsiString; const startIndex: integer; const count: integer); overload;
    procedure Append(value: AnsiChar); overload;
    procedure Append(value: AnsiChar; repeatCount: integer); overload;
    procedure Append(value: AnsiStringBuilder); overload;
    procedure Insert(index: integer; const value: AnsiString); overload;
    procedure Replace(const OldValue: AnsiString; const NewValue: AnsiString);
    function ToString: AnsiString; reintroduce;

    property Length: integer read FActualLength write SetActualLength;
  end;

  TWideCharArray = array of WideChar;

{$IFDEF VER12P}
  WString = string;
{$ELSE}
  WString = WideString;
{$ENDIF}

  WideStringBuilder = class
  protected
    FString: TWideCharArray;
    FActualLength: integer;

    procedure SetActualLength(Value: integer);
  public
    constructor Create(capacity: integer); overload;
    constructor Create(const value: WString; capacity: integer); overload;
    procedure Append(const value: WString); overload;
    procedure Append(const value: WString; const startIndex: integer; const count: integer); overload;
    procedure Append(value: WideChar); overload;
    procedure Append(value: WideChar; repeatCount: integer); overload;
    procedure Append(value: WideStringBuilder); overload;
    procedure Insert(index: integer; const value: WString); overload;
    procedure Replace(const OldValue: WString; const NewValue: WString);
    function ToString: WString; {$IFDEF VER12P} override; {$ENDIF}

    property Length: integer read FActualLength write SetActualLength;
  end;

{$IFDEF VER12P}
  StringBuilder = WideStringBuilder;
{$ELSE}
  StringBuilder = AnsiStringBuilder;
{$ENDIF}

  Buffer = class
  public
    class procedure BlockCopy(const src: TBytes; srcOffset: integer; const dst: TBytes; dstOffset: integer; count: integer);
    class function GetByte(const src: Pointer; Index: integer): Byte;
    class procedure SetByte(const src: Pointer; Index: integer; Value: Byte);
  end;

{ MemoryStream }

  MemoryStream = class
  private
    FData: TBytes;
    FPosition: Integer;
    FLength: Integer;

  protected
    procedure SetPosition(const Pos: Integer);

  public
    constructor Create(capacity: int);
    function Seek(Offset: Longint; Origin: Word): Longint;
    function Read(var Buffer: TBytes; Offset: int; Count: int): int; overload;
    function Read(Buffer: PAnsiChar; Offset: int; Count: int): int; overload;
    procedure Write(const Buffer: TBytes; Offset: int; Count: int); overload;
    procedure Write(Buffer: PAnsiChar; Offset: int; Count: int); overload;
    procedure WriteByte(value: Byte);
    function ReadByte: Byte;
    function GetBuffer: PAnsiChar;

    procedure Close;
    procedure SetLength(Value: Integer);

    property Length: Integer read FLength write SetLength;
    property Position: integer read FPosition write SetPosition;
  end;

  ArgumentException = class(Exception)
  public
    constructor Create; overload;
    constructor Create(const Msg: string); overload;
  end;

  NotSupportedException = class(Exception)
  public
    constructor Create; overload;
    constructor Create(const Msg: string); overload;
  end;

{$IFDEF UTF8}
type
  UTF8String = type AnsiString;

function UnicodeToUtf8(Dest: PAnsiChar; Source: PWideChar; MaxBytes: Integer): Integer; overload;
function UnicodeToUtf8(Dest: PAnsiChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal; overload;
function Utf8ToUnicode(Dest: PWideChar; Source: PAnsiChar; MaxChars: Integer): Integer; overload;
function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PAnsiChar; SourceBytes: Cardinal): Cardinal; overload;
function Utf8Encode(const WS: WideString): UTF8String;
function Utf8Decode(const S: UTF8String): WideString;
function AnsiToUtf8(const S: AnsiString): UTF8String;
function Utf8ToAnsi(const S: UTF8String): AnsiString;
{$ENDIF}

implementation
uses
{$IFDEF VER7P}
  StrUtils,
{$ELSE}
  CRParser,
{$ENDIF}
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  Math;

{ BitConverter }

class function BitConverter.GetBytes(value: word): TBytes;
begin
  SetLength(Result, SizeOf(Word));
  Word(Pointer(Result)^) := value;
end;

class function BitConverter.GetBytes(value: cardinal): TBytes;
begin
  SetLength(Result, SizeOf(Cardinal));
  Cardinal(Pointer(Result)^) := value;
end;

class function BitConverter.GetBytes(value: int64): TBytes;
begin
  SetLength(Result, SizeOf(int64));
  Int64(Pointer(Result)^) := value;
end;

class function BitConverter.GetBytes(value: double): TBytes;
begin
  SetLength(Result, SizeOf(Double));
  Double(Pointer(Result)^) := value;
end;

class function BitConverter.GetBytes(value: Single): TBytes;
begin
  SetLength(Result, SizeOf(Single));
  Single(Pointer(Result)^) := value;
end;

class function BitConverter.Int64BitsToDouble(value: int64): double;
begin
  Result := Double(Pointer(@value)^);
end;

class function BitConverter.DoubleToInt64Bits(value: double): int64;
begin
  Result := PInt64(@value)^;
end;

class function BitConverter.ToDouble(const value: TBytes; startIndex: integer): Double;
begin
  Result := Double(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToDouble(value: PAnsiChar; startIndex: integer): Double;
begin
  Result := Double(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToSingle(const value: TBytes; startIndex: integer): Single;
begin
  Result := Single(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToInt64(const value: TBytes; startIndex: integer): Int64;
begin
  Result := Int64(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToInt64(value: PAnsiChar; startIndex: integer): Int64;
begin
  Result := Int64(Pointer(value + startIndex)^);
end;

class function BitConverter.ToInt32(const value: TBytes; startIndex: integer): integer;
begin
  Result := Integer(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToInt32(value: PAnsiChar; startIndex: integer): integer;
begin
  Result := Integer(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToInt16(const value: TBytes; startIndex: integer): smallint;
begin
  Result := SmallInt(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToUInt32(const value: TBytes; startIndex: integer): UInt32;
begin
  Result := UInt32(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToUInt16(const value: TBytes; startIndex: integer): UInt16;
begin
  Result := UInt16(Pointer(PAnsiChar(value) + startIndex)^);
end;

class function BitConverter.ToUInt16(value: PAnsiChar; startIndex: integer): UInt16;
begin
  Result := UInt16(Pointer(PAnsiChar(value) + startIndex)^);
end;


{ Marshal }

class function Marshal.AllocHGlobal(cb: integer): pointer;
begin
  GetMem(Result, cb);
end;

class function Marshal.ReallocHGlobal(pv: pointer; cb: pointer): pointer;
begin
  Result := pv;
  ReallocMem(Result, Integer(cb));
end;

class procedure Marshal.FreeHGlobal(hglobal: pointer);
begin
  FreeMem(hglobal);
end;

class procedure Marshal.FreeCoTaskMem(ptr: pointer);
begin
end;

class function Marshal.ReadByte(ptr: pointer; ofs: integer): byte;
begin
  Result := Byte(Pointer(Integer(ptr) + ofs)^);
end;

class procedure Marshal.WriteByte(ptr: pointer; val: byte);
begin
  Byte(ptr^) := val;
end;

class procedure Marshal.WriteByte(ptr: pointer; ofs: integer; val: byte);
begin
  Byte(Pointer(Integer(ptr) + ofs)^) := val;
end;

class function Marshal.ReadInt16(ptr: pointer; ofs: integer): smallint;
begin
  Result := SmallInt(Pointer(Integer(ptr) + ofs)^);
end;

class procedure Marshal.WriteInt16(ptr: pointer; val: smallint);
begin
  SmallInt(ptr^) := val;
end;

class procedure Marshal.WriteInt16(ptr: pointer; ofs: integer; val: smallint);
begin
  SmallInt(Pointer(Integer(ptr) + ofs)^) := val;
end;

class function Marshal.ReadInt32(ptr: pointer; ofs: integer): integer;
begin
  Result := Integer(Pointer(Integer(ptr) + ofs)^);
end;

class procedure Marshal.WriteInt32(ptr: pointer; val: integer);
begin
  Integer(ptr^) := val;
end;

class procedure Marshal.WriteInt32(ptr: pointer; ofs, val: integer);
begin
  Integer(Pointer(Integer(ptr) + ofs)^) := val;
end;

class function Marshal.ReadInt64(ptr: pointer; ofs: integer): int64;
begin
  Result := Int64(Pointer(Integer(ptr) + ofs)^);
end;

class procedure Marshal.WriteInt64(ptr: pointer; val: int64);
begin
  Int64(ptr^) := val;
end;

class procedure Marshal.WriteInt64(ptr: pointer; val: double);
begin
  Double(ptr^) := val;
end;

class procedure Marshal.WriteInt64(ptr: pointer; ofs: integer; val: int64);
begin
  Int64(Pointer(Integer(ptr) + ofs)^) := val;
end;

class function Marshal.ReadIntPtr(ptr: pointer; ofs: integer): pointer;
begin
  Result := Pointer(Pointer(Integer(ptr) + ofs)^);
end;

class procedure Marshal.WriteIntPtr(ptr, val: pointer);
begin
  Pointer(ptr^) := val;
end;

class procedure Marshal.WriteIntPtr(ptr: pointer; ofs: integer; val: pointer);
begin
  Pointer(Pointer(Integer(ptr) + ofs)^) := val;
end;

class function Marshal.PtrToStringAnsi(ptr: pointer; len: integer = 0): AnsiString;
begin
  if len > 0 then begin
    SetLength(Result, len);
    Move(ptr^, PAnsiChar(Result)^, len);
  end
  else
    Result := PAnsiChar(ptr);
end;

class function Marshal.PtrToStringUni(ptr: pointer; len: integer = 0): WideString;
begin
  if len > 0 then begin
    SetLength(Result, len);
    Move(ptr^, PWideChar(Result)^, len shl 1);
  end
  else
    Result := PWideChar(ptr);
end;

class function Marshal.StringToHGlobalAnsi(const s: AnsiString): pointer;
begin
  Result := PAnsiChar(s);
end;

class function Marshal.StringToHGlobalUni(const s: WideString): pointer;
begin
  Result := PWideChar(s);
end;

class procedure Marshal.Copy(const source: TBytes; startIndex: integer;
  destination: pointer; length: integer);
begin
  if length = 0 then
    Exit;
  Move(Source[StartIndex], destination^, length);
end;

class procedure Marshal.Copy(Source: pointer; var destination: TBytes;
  startIndex, length: integer);
begin
  if length = 0 then
    Exit;
  Move(source^, destination[startIndex], length);
end;

class function Marshal.GetIUnknownForObject(o: TInterfacedObject): IntPtr;
var
  iu: IUnknown;
begin
  iu := IUnknown(o);
  iu._AddRef; 
  Result := IntPtr(iu);
end;

class function Marshal.AddRef(pUnk: IntPtr): integer;
begin
  Result := IUnknown(pUnk)._AddRef;
end;

class function Marshal.Release(pUnk: IntPtr): integer;
begin
  Result := IUnknown(pUnk)._Release;
end;

{ Encoding }

var
  theDefaultEncoding, theUnicodeEncoding, theUTF8Encoding: Encoding;
{$IFDEF WIN32}
  codepageEncodings: array of CodePageEncoding;
{$ENDIF}

class function Encoding.Default: Encoding;
begin
  Result := theDefaultEncoding;
end;

class function Encoding.Unicode: Encoding;
begin
  Result := theUnicodeEncoding;
end;

class function Encoding.UTF8: Encoding;
begin
  Result := theUTF8Encoding;
end;

class function Encoding.GetEncoding(codepage: integer): Encoding;
{$IFDEF WIN32}
var
  i: integer;
{$ENDIF}
begin
  case codepage of
    65001: // CP_UTF8
      Result := theUTF8Encoding;
    1200: // UTF-16
      Result := theUnicodeEncoding;
  else
  {$IFDEF WIN32}
    if codepage = integer(GetACP) then
  {$ENDIF}
      Result := theDefaultEncoding
  {$IFDEF WIN32}
    else begin
      for i := 0 to Length(codepageEncodings) - 1 do
        if codepageEncodings[i].FCodePage = codepage then begin
          Result := codepageEncodings[i];
          exit;
        end;

      Result := CodePageEncoding.Create(codepage);
      SetLength(codepageEncodings, Length(codepageEncodings) + 1);
      codepageEncodings[Length(codepageEncodings) - 1] := CodePageEncoding(Result);
    end;
  {$ENDIF}
  end;
end;

class function Encoding.Convert(srcEncoding, dstEncoding: Encoding; bytes: TBytes): TBytes;
begin
  Result := Convert(srcEncoding, dstEncoding, bytes, 0, Length(bytes));
end;

class function Encoding.Convert(srcEncoding, dstEncoding: Encoding; bytes: TBytes; index, count: integer): TBytes;
var
  ws: WideString;
begin
  if srcEncoding = dstEncoding then
    Result := Copy(bytes, index, count)
  else begin
    ws := srcEncoding.GetWideString(bytes, index, count);
    Result := dstEncoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(ws);
  end;
end;

function Encoding.GetBytes(const chars: AnsiString): TBytes;
begin
  SetLength(Result, Length(chars));
  Move(PAnsiChar(chars)^, Pointer(Result)^, Length(chars));
end;

function Encoding.GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  if charCount > 0 then
    Move((PAnsiChar(chars) + charIndex)^, bytes[byteIndex], charCount);
  Result := charCount;
end;

function Encoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes;
begin
  Result := GetBytes(AnsiString(chars));
end;

function Encoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Result := GetBytes(AnsiString(chars), charIndex, charCount, bytes, byteIndex);
end;

function Encoding.GetString(const bytes: TBytes): AnsiString;
begin
  Result := GetString(bytes, 0, Length(bytes));
end;

function Encoding.GetString(const bytes: TBytes; index: integer; count: integer): AnsiString;
begin
  if count = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(Result, count);
  Move(Pointer(@Bytes[index])^, PAnsiChar(Result)^, Length(Result));
end;

function Encoding.GetWideString(const bytes: TBytes): WideString;
begin
  Result := WideString(GetString(bytes));
end;

function Encoding.GetWideString(const bytes: TBytes; index: integer; count: integer): WideString;
begin
  Result := WideString(GetString(bytes, index, count));
end;

function Encoding.GetMaxByteCount(charCount: integer): integer;
begin
  Result := charCount;
end;

procedure InitEncodings;
begin
  theDefaultEncoding := Encoding.Create;
  theUnicodeEncoding := UnicodeEncoding.Create;
  theUTF8Encoding := UTF8Encoding.Create;
{$IFDEF WIN32}
  codepageEncodings := nil;
{$ENDIF}
end;

procedure FreeEncodings;
{$IFDEF WIN32}
var
  i: integer;
{$ENDIF}
begin
  theDefaultEncoding.Free;
  theUnicodeEncoding.Free;
  theUTF8Encoding.Free;

{$IFDEF WIN32}
  for i := 0 to Length(codepageEncodings) - 1 do
    codepageEncodings[i].Free;

  codepageEncodings := nil;
{$ENDIF}
end;

{ UnicodeEncoding }

function UnicodeEncoding.GetBytes(const chars: AnsiString): TBytes;
begin
  Result := {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(WideString(chars));
end;

function UnicodeEncoding.GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Result := {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(WideString(chars), charIndex, charCount,
    bytes, byteIndex);
end;

function UnicodeEncoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes;
begin
  SetLength(Result, Length(chars) shl 1);
  Move(PWideChar(chars)^, Pointer(Result)^, Length(chars) shl 1);
end;

function UnicodeEncoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Move((PWideChar(chars) + charIndex)^, bytes[byteIndex], charCount shl 1);
  Result := charCount shl 1;
end;

function UnicodeEncoding.GetString(const bytes: TBytes): AnsiString;
begin
  Result := AnsiString(GetWideString(bytes));
end;

function UnicodeEncoding.GetString(const bytes: TBytes; index: integer; count: integer): AnsiString;
begin
  Result := AnsiString(GetWideString(bytes, index, count));
end;

function UnicodeEncoding.GetWideString(const bytes: TBytes): WideString;
begin
  Result := GetWideString(bytes, 0, Length(bytes));
end;

function UnicodeEncoding.GetWideString(const bytes: TBytes; index: integer; count: integer): WideString;
begin
  if count = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(Result, count shr 1);
  Move(Pointer(@bytes[index])^, PWideChar(Result)^, count);
end;

function UnicodeEncoding.GetMaxByteCount(charCount: integer): integer;
begin
  Result := charCount * 2;
end;

{ UTF8Encoding }

{$IFDEF UTF8}

// UnicodeToUTF8(3):
// Scans the source data to find the null terminator, up to MaxBytes
// Dest must have MaxBytes available in Dest.

function UnicodeToUtf8(Dest: PAnsiChar; Source: PWideChar; MaxBytes: Integer): Integer;
var
  len: Cardinal;
begin
  len := 0;
  if Source <> nil then
    while Source[len] <> #0 do
      Inc(len);
  Result := CLRClasses.UnicodeToUtf8(Dest, MaxBytes, Source, len);
end;

// UnicodeToUtf8(4):
// MaxDestBytes includes the null terminator (last char in the buffer will be set to null)
// Function result includes the null terminator.
// Nulls in the source data are not considered terminators - SourceChars must be accurate

function UnicodeToUtf8(Dest: PAnsiChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Cardinal;
begin
  Result := 0;
  if Source = nil then Exit;
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceChars) and (count < MaxDestBytes) do
    begin
      c := Cardinal(Source[i]);
      Inc(i);
      if c <= $7F then
      begin
        Dest[count] := AnsiChar(c);
        Inc(count);
      end
      else if c > $7FF then
      begin
        if count + 3 > MaxDestBytes then
          break;
        Dest[count] := AnsiChar($E0 or (c shr 12));
        Dest[count+1] := AnsiChar($80 or ((c shr 6) and $3F));
        Dest[count+2] := AnsiChar($80 or (c and $3F));
        Inc(count,3);
      end
      else //  $7F < Source[i] <= $7FF
      begin
        if count + 2 > MaxDestBytes then
          break;
        Dest[count] := AnsiChar($C0 or (c shr 6));
        Dest[count+1] := AnsiChar($80 or (c and $3F));
        Inc(count,2);
      end;
    end;
    if count >= MaxDestBytes then count := MaxDestBytes-1;
    Dest[count] := #0;
  end
  else
  begin
    while i < SourceChars do
    begin
      c := Integer(Source[i]);
      Inc(i);
      if c > $7F then
      begin
        if c > $7FF then
          Inc(count);
        Inc(count);
      end;
      Inc(count);
    end;
  end;
  Result := count+1;  // convert zero based index to byte count
end;

function Utf8ToUnicode(Dest: PWideChar; Source: PAnsiChar; MaxChars: Integer): Integer;
var
  len: Cardinal;
begin
  len := 0;
  if Source <> nil then
    while Source[len] <> #0 do
      Inc(len);
  Result := CLRClasses.Utf8ToUnicode(Dest, MaxChars, Source, len);
end;

function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PAnsiChar; SourceBytes: Cardinal): Cardinal;
var
  i, count: Cardinal;
  c: Byte;
  wc: Cardinal;
begin
  if Source = nil then
  begin
    Result := 0;
    Exit;
  end;
  Result := Cardinal(-1);
  count := 0;
  i := 0;
  if Dest <> nil then
  begin
    while (i < SourceBytes) and (count < MaxDestChars) do
    begin
      wc := Cardinal(Source[i]);
      Inc(i);
      if (wc and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        wc := wc and $3F;
        if (wc and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte

        Dest[count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        Dest[count] := WideChar(wc);
      Inc(count);
    end;
    if count >= MaxDestChars then count := MaxDestChars-1;
    Dest[count] := #0;
  end
  else
  begin
    while (i < SourceBytes) do
    begin
      c := Byte(Source[i]);
      Inc(i);
      if (c and $80) <> 0 then
      begin
        if i >= SourceBytes then Exit;          // incomplete multibyte char
        c := c and $3F;
        if (c and $20) <> 0 then
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
          if i >= SourceBytes then Exit;        // incomplete multibyte char
        end;
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then Exit;       // malformed trail byte
      end;
      Inc(count);
    end;
  end;
  Result := count+1;
end;

function Utf8Encode(const WS: WideString): UTF8String;
var
  L: Integer;
  Temp: UTF8String;
begin
  Result := '';
  if WS = '' then Exit;
  SetLength(Temp, Length(WS) * 3); // SetLength includes space for null terminator

  L := CLRClasses.UnicodeToUtf8(PAnsiChar(Temp), Length(Temp)+1, PWideChar(WS), Length(WS));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function Utf8Decode(const S: UTF8String): WideString;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := CLRClasses.Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PAnsiChar(S), Length(S));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := '';
  Result := Temp;
end;

function AnsiToUtf8(const S: AnsiString): UTF8String;
begin
  Result := Utf8Encode(S);
end;

function Utf8ToAnsi(const S: UTF8String): AnsiString;
begin
  Result := Utf8Decode(S);
end;

{$ENDIF}

function UTF8Encoding.GetBytes(const chars: AnsiString): TBytes;
var
  UTF8: AnsiString;
begin
  UTF8 := AnsiToUtf8(string(chars));
  SetLength(Result, Length(UTF8));
  Move(PAnsiChar(UTF8)^, Pointer(Result)^, Length(UTF8));
end;

function UTF8Encoding.GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Assert(False, 'not implemented');
  Result := 0;
end;

function UTF8Encoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes;
var
  UTF8: UTF8String;
begin
  UTF8 := UTF8Encode(chars);
  SetLength(Result, Length(UTF8));
  Move(PAnsiChar(UTF8)^, Pointer(Result)^, Length(UTF8));
end;

function UTF8Encoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Assert(False, 'not implemented');
  Result := 0;
end;

function UTF8Encoding.GetString(const bytes: TBytes): AnsiString;
begin
  Result := GetString(bytes, 0, Length(bytes));
end;

function UTF8Encoding.GetString(const bytes: TBytes; index: integer; count: integer): AnsiString;
var
  UTF8: UTF8String;
begin
  if count = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(UTF8, count);

  Move(Pointer(@bytes[index])^, PAnsiChar(UTF8)^, Length(UTF8));
  Result := AnsiString(Utf8ToAnsi(UTF8));
end;

function UTF8Encoding.GetWideString(const bytes: TBytes): WideString;
begin
  Result := GetWideString(bytes, 0, Length(bytes));
end;

function UTF8Encoding.GetWideString(const bytes: TBytes; index: integer; count: integer): WideString;
var
  UTF8: UTF8String;
begin
  if count = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(UTF8, count);

  Move(Pointer(@bytes[index])^, PAnsiChar(UTF8)^, Length(UTF8));
  Result := UTF8Decode(UTF8);
end;

function UTF8Encoding.GetMaxByteCount(charCount: integer): integer;
begin
  Result := charCount * 3;
end;

{$IFDEF WIN32}
constructor CodePageEncoding.Create(CodePage: integer);
begin
  inherited Create;

  FCodePage := CodePage;
end;

function CodePageEncoding.GetBytes(const chars: AnsiString): TBytes;
begin
  Result := {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(WideString(chars));
end;

function CodePageEncoding.GetBytes(const chars: AnsiString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  Result := {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(WideString(chars),
    charIndex, charCount, bytes, byteIndex);
end;

function CodePageEncoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString): TBytes;
var
  byteCount: integer;
begin
  if chars = '' then
    Result := nil
  else begin
    byteCount := WideCharToMultiByte(FCodePage, 0, PWideChar(chars), Length(chars),
      nil, 0, nil, nil);
    Win32Check(LongBool(byteCount));
    SetLength(Result, byteCount);
    {$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(chars, 0, Length(chars),
      Result, 0);
  end;
end;

function CodePageEncoding.{$IFNDEF VER5}GetBytes{$ELSE}GetBytesWide{$ENDIF}(const chars: WideString; charIndex, charCount: int; var bytes: TBytes; byteIndex: int): int;
begin
  if charCount <= 0 then
    Result := 0
  else begin
    Result := WideCharToMultiByte(FCodePage, 0, PWideChar(chars) + charIndex, charCount,
      PAnsiChar(bytes) + byteIndex, Length(bytes) - byteIndex, nil, nil);
    Win32Check(LongBool(Result));
  end;
end;

function CodePageEncoding.GetString(const bytes: TBytes): AnsiString;
begin
  Result := AnsiString(GetWideString(bytes));
end;

function CodePageEncoding.GetString(const bytes: TBytes; index: integer; count: integer): AnsiString;
begin
  Result := AnsiString(GetWideString(bytes, index, count));
end;

function CodePageEncoding.GetWideString(const bytes: TBytes): WideString;
begin
  Result := GetWideString(bytes, 0, Length(bytes));
end;

function CodePageEncoding.GetWideString(const bytes: TBytes; index: integer; count: integer): WideString;
var
  charCount: integer;
begin
  if count <= 0 then
    Result := ''
  else begin
    charCount := MultiByteToWideChar(FCodePage, 0, PAnsiChar(bytes) + index, count, nil, 0);
    Win32Check(LongBool(charCount));
    SetLength(Result, charCount);
    charCount := MultiByteToWideChar(FCodePage, 0, PAnsiChar(bytes) + index, count,
      PWideChar(Result), charCount);
    Win32Check(LongBool(charCount));
  end;
end;

function CodePageEncoding.GetMaxByteCount(charCount: integer): integer;
begin
  if FCodePage = 1201 then
    Result := charCount * 2
  else
    Result := charCount;
end;

{$ENDIF}

{ AnsiStringBuilder }

constructor AnsiStringBuilder.Create(capacity: integer);
begin
  inherited Create;

  FActualLength := 0;
  SetLength(FString, capacity);
end;

constructor AnsiStringBuilder.Create(const value: AnsiString; capacity: integer);
begin
  Create(capacity);
  Append(value);
end;

procedure AnsiStringBuilder.SetActualLength(Value: integer);
var
  l: integer;
begin
  l := System.Length(FString);
  if l - FActualLength < Value then
    SetLength(FString, FActualLength + Value + l shr 1);
  FActualLength := Value;
end;

procedure AnsiStringBuilder.Append(const value: AnsiString);
var
  l, ls: integer;

begin
  ls := System.Length(value);
  if ls = 0 then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < ls then
    SetLength(FString, FActualLength + ls + l shr 1);
  Move(Pointer(value)^, FString[FActualLength], ls);
  Inc(FActualLength, ls);
end;

procedure AnsiStringBuilder.Append(const value: AnsiString; const startIndex: integer; const count: integer);
var
  l: integer;

begin
  if count = 0 then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < count then
    SetLength(FString, FActualLength + count + l shr 1);
  Move(value[startIndex + 1], FString[FActualLength], count);
  Inc(FActualLength, count);
end;

procedure AnsiStringBuilder.Append(value: AnsiChar);
var
  l: integer;

begin
  l := System.Length(FString);
  if l - FActualLength < 1 then
    SetLength(FString, FActualLength + 1 + l shr 1);
  FString[FActualLength] := value;
  Inc(FActualLength);
end;

procedure AnsiStringBuilder.Append(value: AnsiChar; repeatCount: integer);
var
  s: AnsiString;
begin
  s := StringOfChar(value, repeatCount);
  Append(s);
end;

procedure AnsiStringBuilder.Append(value: AnsiStringBuilder);
var
  l: integer;

begin
  if (value = nil) or (value.Length = 0) then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < value.Length then
    SetLength(FString, FActualLength + value.Length + l shr 1);
  Move(Pointer(value.FString)^, FString[FActualLength], value.Length);
  Inc(FActualLength, value.Length);
end;

procedure AnsiStringBuilder.Insert(index: integer; const value: AnsiString);
var
  l, ls: integer;

begin
  l := System.Length(FString);
  ls := System.Length(value);
  if l - FActualLength < ls then
    SetLength(FString, FActualLength + ls + l shr 1);

  Move(FString[Index], FString[Index + ls], FActualLength - Index);
  Move(Pointer(value)^, FString[Index], ls);

  Inc(FActualLength, ls);
end;

procedure AnsiStringBuilder.Replace(const OldValue: AnsiString; const NewValue: AnsiString);

  function PosEx(const SubStr: AnsiString; const S: TAnsiCharArray; StartPos, EndPos: integer): Integer;
  var
    I,X: Integer;
    LenSubStr: Integer;
  begin
    I := StartPos;
    LenSubStr := System.Length(SubStr);
    EndPos := EndPos - LenSubStr + 1;
    while I <= EndPos do begin
      if S[I] = SubStr[1] then begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := -1;
  end;

  procedure InsertS(index: integer; const value: AnsiString; offset: integer);
  var
    l, ls: integer;
  begin
    l := System.Length(FString);
    ls := System.Length(value) - offset + 1;
    if l - FActualLength < ls then
      SetLength(FString, FActualLength + ls + l shr 1);

    if FActualLength > Index then
      Move(FString[Index], FString[Index + ls], FActualLength - Index);
    Move(value[offset], FString[Index], ls);
  end;

var
  lOld, lNew: integer;
  Index: integer;

begin
  lOld := System.Length(OldValue);
  lNew := System.Length(NewValue);
  Index := PosEx(OldValue, FString, 0, FActualLength - 1);

  while Index >= 0 do begin
    if lOld > lNew then begin
      Move(Pointer(NewValue)^, FString[Index], lNew);
      Move(FString[Index + lOld], FString[Index + lNew],
        FActualLength - Index - lOld + 1);
    end
    else
    if lOld < lNew then begin
      Move(Pointer(NewValue)^, FString[Index], lOld);
      InsertS(Index + lOld, NewValue, lOld + 1);
    end
    else
      Move(Pointer(NewValue)^, FString[Index], lNew);

    Inc(FActualLength, lNew - lOld);
    Index := PosEx(OldValue, FString, Index + lNew, FActualLength - 1);
  end;
end;

function AnsiStringBuilder.ToString: AnsiString;
begin
  SetLength(Result, FActualLength);
  if FActualLength > 0 then
    Move(FString[0], Result[1], FActualLength);
end;

{ WideStringBuilder }

constructor WideStringBuilder.Create(capacity: integer);
begin
  inherited Create;

  FActualLength := 0;
  SetLength(FString, capacity);
end;

constructor WideStringBuilder.Create(const value: WString; capacity: integer);
begin
  Create(capacity);
  Append(value);
end;

procedure WideStringBuilder.SetActualLength(Value: integer);
var
  l: integer;
begin
  l := System.Length(FString);
  if l - FActualLength < Value then
    SetLength(FString, FActualLength + Value + l shr 1);
  FActualLength := Value;
end;

procedure WideStringBuilder.Append(const value: WString);
var
  l, ls: integer;

begin
  ls := System.Length(value);
  if ls = 0 then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < ls then
    SetLength(FString, FActualLength + ls + l shr 1);
  Move(Pointer(value)^, FString[FActualLength], ls * SizeOf(WideChar));
  Inc(FActualLength, ls);
end;

procedure WideStringBuilder.Append(const value: WString; const startIndex: integer; const count: integer);
var
  l: integer;

begin
  if count = 0 then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < count then
    SetLength(FString, FActualLength + count + l shr 1);
  Move(value[startIndex + 1], FString[FActualLength], count * SizeOf(WideChar));
  Inc(FActualLength, count);
end;

procedure WideStringBuilder.Append(value: WideChar);
var
  l: integer;

begin
  l := System.Length(FString);
  if l - FActualLength < 1 then
    SetLength(FString, FActualLength + 1 + l shr 1);
  FString[FActualLength] := value;
  Inc(FActualLength);
end;

procedure WideStringBuilder.Append(value: WideChar; repeatCount: integer);
var
  s: WString;
begin
  s := StringOfChar(value, repeatCount);
  Append(s);
end;

procedure WideStringBuilder.Append(value: WideStringBuilder);
var
  l: integer;

begin
  if (value = nil) or (value.Length = 0) then
    Exit;

  l := System.Length(FString);
  if l - FActualLength < value.Length then
    SetLength(FString, FActualLength + value.Length + l shr 1);
  Move(Pointer(value.FString)^, FString[FActualLength], value.Length * SizeOf(WideChar));
  Inc(FActualLength, value.Length);
end;

procedure WideStringBuilder.Insert(index: integer; const value: WString);
var
  l, ls: integer;

begin
  l := System.Length(FString);
  ls := System.Length(value);
  if l - FActualLength < ls then
    SetLength(FString, FActualLength + ls + l shr 1);

  Move(FString[Index], FString[Index + ls], (FActualLength - Index) * SizeOf(WideChar));
  Move(Pointer(value)^, FString[Index], ls * SizeOf(WideChar));

  Inc(FActualLength, ls);
end;

procedure WideStringBuilder.Replace(const OldValue: WString; const NewValue: WString);

  function PosEx(const SubStr: WideString; const S: TWideCharArray; StartPos, EndPos: integer): Integer;
  var
    I,X: Integer;
    LenSubStr: Integer;
  begin
    I := StartPos;
    LenSubStr := System.Length(SubStr);
    EndPos := EndPos - LenSubStr + 1;
    while I <= EndPos do begin
      if S[I] = SubStr[1] then begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := -1;
  end;

  procedure InsertS(index: integer; const value: WideString; offset: integer);
  var
    l, ls: integer;
  begin
    l := System.Length(FString);
    ls := System.Length(value) - offset + 1;
    if l - FActualLength < ls then
      SetLength(FString, FActualLength + ls + l shr 1);

    if FActualLength > Index then
      Move(FString[Index], FString[Index + ls],
        (FActualLength - Index) * SizeOf(WideChar));
    Move(value[offset], FString[Index], ls * SizeOf(WideChar));
  end;

var
  lOld, lNew: integer;
  Index: integer;

begin
  lOld := System.Length(OldValue);
  lNew := System.Length(NewValue);
  Index := PosEx(OldValue, FString, 0, FActualLength - 1);

  while Index >= 0 do begin
    if lOld > lNew then begin
      Move(Pointer(NewValue)^, FString[Index], lNew * SizeOf(WideChar));
      Move(FString[Index + lOld], FString[Index + lNew],
        (FActualLength - Index - lOld + 1) * SizeOf(WideChar));
    end else
    if lOld < lNew then begin
      Move(Pointer(NewValue)^, FString[Index], lOld * SizeOf(WideChar));
      InsertS(Index + lOld, NewValue, lOld + 1);
    end else
      Move(Pointer(NewValue)^, FString[Index], lNew * SizeOf(WideChar));

    Inc(FActualLength, lNew - lOld);
    Index := PosEx(OldValue, FString, Index + lNew, FActualLength - 1);
  end;
end;

function WideStringBuilder.ToString: WString;
begin
  SetLength(Result, FActualLength);
  if FActualLength > 0 then
    Move(FString[0], Result[1], FActualLength * SizeOf(WideChar));
end;

{ Buffer }

class procedure Buffer.BlockCopy(const src: TBytes; srcOffset: integer; const dst: TBytes; dstOffset: integer; count: integer);
begin
  Move((PAnsiChar(src) + srcOffset)^, (PAnsiChar(dst) + dstOffset)^, count);
end;

class function Buffer.GetByte(const src: Pointer; Index: integer): Byte;
begin
  Result := Byte((PAnsiChar(src) + Index)^);
end;

class procedure Buffer.SetByte(const src: Pointer; Index: integer; Value: Byte);
begin
  Byte((PAnsiChar(src) + Index)^) := Value;
end;

{ MemoryStream }
constructor MemoryStream.Create(capacity: int);
begin
  inherited Create;
  System.SetLength(FData, capacity);
end;

procedure MemoryStream.Close;
begin
  System.SetLength(FData, 0);
end;

procedure MemoryStream.SetLength(Value: Integer);
var
  l: integer;
begin
  l := System.Length(FData); // Performance opt
  if Value > l then
    System.SetLength(FData, Max(Value, l + l div 2));
  FLength := Value;
end;

procedure MemoryStream.SetPosition(const Pos: Integer);
begin
  if Pos > Length then
    Length := Pos;
  FPosition := Pos;
end;

function MemoryStream.Read(var Buffer: TBytes; Offset: int; Count: int): int;
begin
  Result := Read(PAnsiChar(@Buffer[0]), Offset, Count);
end;

function MemoryStream.Read(Buffer: PAnsiChar; Offset: int; Count: int): int;
begin
  Result := System.Length(FData) - FPosition;
  if Result > Count then
    Result := Count;
  Move(PAnsiChar(@FData[FPosition])^, Buffer[Offset], Result);
  Inc(FPosition, Result);
end;

function MemoryStream.ReadByte: Byte;
begin
  Result := FData[FPosition];
  Inc(FPosition);
end;

function MemoryStream.GetBuffer: PAnsiChar;
begin
  Result := @FData[0];
end;

procedure MemoryStream.Write(const Buffer: TBytes; Offset: int; Count: int);
begin
  Write(PAnsiChar(@Buffer[0]), Offset, Count);
end;

procedure MemoryStream.Write(Buffer: PAnsiChar; Offset: int; Count: int);
var
  l: integer;
begin
  l := FPosition + Count;
  if l > Length then
    Length := l;
  Move(Buffer[Offset], PAnsiChar(@FData[FPosition])^, Count);
  Inc(FPosition, Count);
end;

procedure MemoryStream.WriteByte(value: Byte);
var
  l: integer;
begin
  l := FPosition + 1;
  if l > Length then
    Length := l;
  FData[FPosition] := Value;
  Inc(FPosition);
end;

function MemoryStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := System.Length(FData) - Offset;
  end;
  if FPosition > System.Length(FData) then
    FPosition := System.Length(FData)
  else if FPosition < 0 then FPosition := 0;
  Result := FPosition;
end;

{ ArgumentException }
constructor ArgumentException.Create;
begin
  inherited Create('');
end;

constructor ArgumentException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

constructor NotSupportedException.Create;
begin
  inherited Create('');
end;

constructor NotSupportedException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

initialization
  InitEncodings;

finalization
  FreeEncodings;

end.