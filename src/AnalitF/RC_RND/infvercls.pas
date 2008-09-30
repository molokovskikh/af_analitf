unit infvercls;

interface

uses
  SysUtils, Classes, infver;

const
  INFKeyBits = 128;
  INFDataLen = 16;

  FDBColDelimiter : Byte = 159;
  FDBRowDelimiter : Byte = 161;

type
  TINFCrypt = class
   private
    ekEnc,
    ekDec : ExpandedKey;
    nrEnc,
    nrDec : LongInt;
    InBuff,
    OutBuff : PByteArray;
    IntBuffLen : Integer;
    cipherkey : array[0..15] of byte;
    procedure Resize(ANewSize : Integer);
    function IntEncode(ADataStr : String) : Integer;
    procedure IntDecode(ACipLen : Integer);
    function BinToHexMix(Buffer, Text: PChar; BufSize: Integer) : Integer;
    function HexToBinMix(Text, Buffer: PChar; TextSize: Integer) : Integer;
   public
    constructor Create(AKey : String; ABuffLen : Integer);
    destructor Destroy; override;
    function Encode(ADataStr : String) : String;
    function EncodeHex(ADataStr : String) : String;
    function EncodeMix(ADataStr : String) : String;
    function Decode(ACipStr : String) : String;
    function DecodeHex(ACipStr : String) : String;
    function DecodeMix(ACipStr : String) : String;
    procedure UpdateKey(AKey : String);
  end;

implementation

{ TINFCrypt }

function TINFCrypt.BinToHexMix(Buffer, Text: PChar;
  BufSize: Integer): Integer;
const
  Convert: array[0..15] of Char = '0123456789ABCDEF';
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to BufSize - 1 do
  begin
    if (Byte(Buffer[I]) = 0) or (Byte(Buffer[I]) = Ord('%')) or
       (Byte(Buffer[I]) = FDBColDelimiter) or (Byte(Buffer[I]) = FDBRowDelimiter)
    then begin
      Text[0] := '%';
      Text[1] := Convert[Byte(Buffer[I]) shr 4];
      Text[2] := Convert[Byte(Buffer[I]) and $F];
      Inc(Text, 3);
      Inc(Result, 3);
    end
    else begin
      Text[0] := Buffer[I];
      Inc(Text, 1);
      Inc(Result, 1);
    end;
  end;
end;

constructor TINFCrypt.Create(AKey: String; ABuffLen: Integer);
begin
  UpdateKey(AKey);
  IntBuffLen := 0;
  InBuff := nil;
  OutBuff := nil;
  Resize(ABuffLen);
end;

function TINFCrypt.Decode(ACipStr: String): String;
var
  CipLen : Integer;
begin
  CipLen := Length(ACipStr);
  Resize(CipLen);
  Move(PChar(ACipStr)^, InBuff^, CipLen);
  IntDecode(CipLen);
  if CipLen > 0 then
    SetString(Result, PChar(OutBuff), CipLen - (OutBuff^[CipLen-1]))
  else
    Result := '';
end;

function TINFCrypt.DecodeHex(ACipStr: String): String;
var
  CipLen : Integer;
begin
  CipLen := Length(ACipStr) div 2;
  Resize(CipLen);
  HexToBin(PChar(ACipStr), PChar(InBuff), CipLen);
  IntDecode(CipLen);
  if CipLen > 0 then
    SetString(Result, PChar(OutBuff), CipLen - (OutBuff^[CipLen-1]))
  else
    Result := '';
end;

function TINFCrypt.DecodeMix(ACipStr: String): String;
var
  CipLen : Integer;
begin
  CipLen := Length(ACipStr);
  Resize(CipLen);
  CipLen := HexToBinMix(PChar(ACipStr), PChar(InBuff), CipLen);
  IntDecode(CipLen);
  if CipLen > 0 then
    SetString(Result, PChar(OutBuff), CipLen - (OutBuff^[CipLen-1]))
  else
    Result := '';
end;

destructor TINFCrypt.Destroy;
begin
  Resize(0);
  inherited;
end;

function TINFCrypt.Encode(ADataStr: String): String;
var
  NewLen : Integer;
begin
  NewLen := IntEncode(ADataStr);
  SetString(Result, PChar(OutBuff), NewLen);
end;

function TINFCrypt.EncodeHex(ADataStr: String): String;
var
  NewLen : Integer;
  NewStr : PByteArray;
begin
  NewLen := IntEncode(ADataStr);
  NewStr := nil;
  GetMem(NewStr, NewLen*2 + 1);
  BinToHex(PChar(OutBuff), PChar(NewStr), NewLen);
  SetString(Result, PChar(NewStr), NewLen*2);
  FreeMem(NewStr, NewLen*2 + 1);
end;

function TINFCrypt.EncodeMix(ADataStr: String): String;
var
  NewLen,
  ResLen : Integer;
  NewStr : PByteArray;
begin
  NewLen := IntEncode(ADataStr);
  NewStr := nil;
  GetMem(NewStr, NewLen*3 + 1);
  ResLen := BinToHexMix(PChar(OutBuff), PChar(NewStr), NewLen);
  SetString(Result, PChar(NewStr), ResLen);
  FreeMem(NewStr, NewLen*3 + 1);
end;

function TINFCrypt.HexToBinMix(Text, Buffer: PChar;
  TextSize: Integer): Integer;
const
  Convert: array['0'..'f'] of SmallInt =
    ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15);
var
  I: Integer;
begin
  I := 0;
  Result := 0;
  while I < TextSize do
  begin
    if (Text[0] = '%') then begin
      Buffer[0] := Char((Convert[Text[1]] shl 4) + Convert[Text[2]]);
      Inc(Buffer);
      Inc(Text, 3);
      Inc(I, 3);
    end
    else begin
      Buffer[0] := Text[0];
      Inc(Buffer);
      Inc(Text, 1);
      Inc(I);
    end;
    Inc(Result);
  end;
end;

procedure TINFCrypt.IntDecode(ACipLen : Integer);
var
  I : Integer;
begin
  if (ACipLen mod INFDataLen = 0) then begin
    for I := 0 to (ACipLen div INFDataLen)-1 do
      infver.Decrypt(ekDec, nrDec, InBuff^, i*INFDataLen, OutBuff^, i*INFDataLen);
  end
  else
    raise Exception.Create('Wrong message length.');
end;

function TINFCrypt.IntEncode(ADataStr: String): Integer;
var
  DataLen : Integer;
  NumBlock : Integer;
  PadLen : Byte;
  I : Integer;
begin
  DataLen := Length(ADataStr);
  Move(PChar(ADataStr)^, InBuff^, DataLen);
  Resize(DataLen);
  NumBlock := DataLen div INFDataLen;
  for I := 0 to NumBlock-1 do
    infver.Encrypt(ekEnc, nrEnc, InBuff^, i*INFDataLen, OutBuff^, i*INFDataLen);
  PadLen := Byte(INFDataLen - (DataLen - INFDataLen*NumBlock));
  FillChar((PChar(InBuff) + INFDataLen*NumBlock + (INFDataLen - PadLen))^, PadLen, PadLen);
  infver.Encrypt(ekEnc, nrEnc, InBuff^, NumBlock*INFDataLen, OutBuff^, NumBlock*INFDataLen);
  Result := INFDataLen*(NumBlock + 1);
end;

procedure TINFCrypt.Resize(ANewSize : Integer);
begin
  if (ANewSize > IntBuffLen) then begin
    FreeMem(InBuff, IntBuffLen);
    FreeMem(OutBuff, IntBuffLen);
    InBuff := nil;
    OutBuff := nil;
    IntBuffLen := INFDataLen*(trunc(ANewSize/INFDataLen)+1);
    GetMem(InBuff, IntBuffLen);
    GetMem(OutBuff, IntBuffLen);
  end;
end;

procedure TINFCrypt.UpdateKey(AKey: String);
begin
  Move(PChar(Akey)^, cipherkey, INFDataLen);
  nrEnc := KeySetupEnc(ekEnc, cipherkey, INFKeyBits);
  nrDec := KeySetupDec(ekDec, cipherkey, INFKeyBits);
end;

end.
