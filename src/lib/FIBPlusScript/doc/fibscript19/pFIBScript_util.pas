{*************************************************}
{                                                 }
{             FIBPlus Script, version 1.9         }
{                                                 }
{     Copyright by Nikolay Trifonov, 2003-2007    }
{                                                 }
{           E-mail: t_nick@mail.ru                }
{                                                 }
{*************************************************}

unit pFIBScript_util;

interface

uses Windows, SysUtils, Classes;

  function  HexStr2IntStr(S: String): String;
  function  HexStr2Int(S: String): Integer;

// -------------------- TMappedMemoryStream -------------------
// based on TMappedFileStream by Sergey Kabikov <kser@elsov.ru>
// and on YaScript by Vladimir A. Bakhvaloff <bakh@sut.ru>
// -------------------- TMappedMemoryStream -------------------
//**
//** begin TMappedMemoryStream
//**

{const} {SCH  есть в  Classes}
{ TStream seek origins }

{  soFromBeginning = 0;
  soFromCurrent = 1;
  soFromEnd = 2;}{SCH}

type
  TMappedMemoryStream = class (TCustomMemoryStream)
  private
    fHandle: DWORD;
    fMapObjHandle: THandle;
    fMemory: pointer;
    fSize: Int64;
    fPosition: Int64;
  protected
    function  GetMapped: boolean;
    procedure SetMapped(Value: boolean);
    procedure SetPosition(Value: Int64);
  public
    EOF: Boolean;
    constructor Create(const FileName: string);
    destructor  Destroy; override;

    function Read(var Buffer; Count: Int64): Int64; reintroduce;
    function ReadString: String;
    function Write(const Buffer; Count: Int64): Int64; reintroduce;
    function Seek(Offset: Int64; Origin: Word): Int64; reintroduce;

    property Size: Int64 read fSize write fSize;
    property Position: Int64 read fPosition write SetPosition;
    property Mapped: boolean read GetMapped write SetMapped;
    property Handle: DWORD read fHandle;
    property Memory : Pointer read fMemory write fMemory;
  end;

implementation

  constructor TMappedMemoryStream.Create;
  var
    SizeHigh: Longint;
  begin
    inherited Create;
    fHandle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
    if fHandle = INVALID_HANDLE_VALUE then begin
      RaiseLastWin32Error;
    end else begin
      Mapped := True;
      fSize := GetFileSize(Handle, @SizeHigh);
      if SizeHigh <> 0 then fSize := fSize + SizeHigh shl 32;
      fPosition := 0;
      EOF := FALSE;
    end;
  end;

  destructor  TMappedMemoryStream.Destroy;
  begin
    EOF := False;
    fPosition := 0;
    fSize := 0;
    Mapped := False;
    CloseHandle(fHandle);
    inherited;
  end;

  function TMappedMemoryStream.Write;
  begin
    Result := fPosition;
  end;

  function TMappedMemoryStream.Read;
  begin
    if (fPosition >= 0) and (Count >= 0) then begin
      Result := fSize - fPosition;
      if Result = 0 then EOF := True;
      if Result > 0 then begin
        if Result > Count then Result := Count;
        Move((PChar(fMemory) + fPosition)^, Buffer, Result);
        Inc(fPosition, Result);
        Exit;
      end;
    end;
    Result := 0;
  end;

{.$DEFINE LEAKED_READ}
  function TMappedMemoryStream.ReadString;
{$IFDEF LEAKED_READ}
  const
    EOStr: String = #13#10;
  var
    S: String;
    OldPos: int64;
    I: int64;
    Leak: int64;
{$ELSE}
  var
    P, Start: PChar;
{$ENDIF}
  begin
    Result := '';
{$IFDEF LEAKED_READ}
    Leak := 1024;
    repeat
      if fSize - fPosition < Leak
        then Leak := fSize - fPosition;
      OldPos := fPosition;
      SetLength(S, Leak);
      if Read(S[1], Leak) = 0
        then EOF := TRUE
        else EOF := FALSE;
      I := Pos(EOStr, S);
      Result := Result + Copy(S, 1, I - 1);
      if I <> 0 then begin
        Seek(OldPos + I + 1, soFromBeginning);
      end else begin
        if EOF then Exit;
        Seek(-2, soFromCurrent);
        SetLength(Result, Length(Result) - 2);
      end;
    until I <> 0;
{$ELSE}
    Start := PChar(fMemory) + fPosition;
    P := Start;
    try
      while not (P^ in [#10, #13]) do Inc(P);
    except
      P := PChar(fMemory) + fSize;
    end;
    SetString(Result, Start, P - Start);
    Inc(fPosition, P - Start);
    if (fPosition < fSize) and (P^ = #13) then begin
      Inc(P);
      Inc(fPosition);
    end;
    if (fPosition < fSize) and (P^ = #10)
      then Inc(fPosition);
    EOF := False;
    if fPosition = fSize
      then EOF := True;
{$ENDIF}
  end;

  function  TMappedMemoryStream.GetMapped: boolean;
  begin
    Result := fMemory <> nil;
  end;

  procedure TMappedMemoryStream.SetMapped;
  begin
    if Value then begin    // Map file
      if Mapped {always done} or (Handle = 0) {no file opened}
        then exit;
      if fMapObjHandle = 0
        then fMapObjHandle := CreateFileMapping(Handle, nil, PAGE_READONLY, 0, 0, nil);
      if fMapObjHandle <> 0
        then fMemory := MapViewOfFile(fMapObjHandle, FILE_MAP_READ, 0, 0, 0);
      if fMemory = nil
        then SetMapped(False);  // failed to map
    end else begin              // UnMap file
      if fMemory <> nil then begin
        UnmapViewOfFile(fMemory);
        fMemory := nil;
      end;
      if fMapObjHandle <> 0 then begin
        CloseHandle(fMapObjHandle);
        fMapObjHandle := 0;
      end;
    end;
  end;

  procedure TMappedMemoryStream.SetPosition;
  begin
    if Value <= fSize then begin
      fPosition := Value;
    end;
  end;

  function TMappedMemoryStream.Seek;
  begin
    case Origin of
      soFromBeginning: fPosition := Offset;
      soFromCurrent: Inc(fPosition, Offset);
      soFromEnd: fPosition := fSize - Offset;
    end;
    Result := fPosition;
  end;

//**
//** end TMappedMemoryStream
//**


  function HexStr2IntStr(S: String): String;
  const
    Hexez: array [0..15] of Char = '0123456789ABCDEF';
  var
    I: Integer;
    J: LongInt;
    K: Integer;
  begin
    K := 0;
    J := 0;
    for I := Length(S) downto 1 do begin
      if J=0 then J := 1 else J := J*16;
      K := K+J*(Pos(UpperCase(S[I]), Hexez)-1);
    end;
    HexStr2IntStr := IntToStr(K);
  end;
  
  function HexStr2Int(S: String): Integer;
  const
    Hexez: array [0..15] of Char = '0123456789ABCDEF';
  var
    I: Integer;
    J: LongInt;
    K: Integer;
  begin
    K := 0;
    J := 0;
    for I := Length(S) downto 1 do begin
      if J = 0 then J := 1 else J := J * 16;
      K := K + J * (Pos(UpperCase(S[I]), Hexez) - 1);
    end;
    HexStr2Int := K;
  end;


end.
