{* rijndael-alg-ref.c   v2.0   August '99 *}
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                ---------------------------------                *
 *                            DELPHI                               *
 *                Rijndael algorithm implementation                *
 *                ---------------------------------                *
 *                                                   December 2000 *
 *                                                                 *
 * Authors: Paulo Barreto                                          *
 *          Vincent Rijmen                                         *
 *                                                                 *
 * Delphi translation by Sergey Kirichenko (ksv@cheerful.com)      *
 * Home Page: http://rcolonel.tripod.com                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

unit inforoomalg;

interface

const
  MAXBC     = (256 div 32);
  MAXKC     = (256 div 32);
  MAXROUNDS = 14;

type
  word8  = byte;        // unsigned 8-bit
  word16 = word;        // unsigned 16-bit
  word32 = longword;    // unsigned 32-bit

  TArrayK  = array [0..4-1, 0..MAXKC-1] of word8;
  PArrayK = ^TArrayK;
  TArrayRK = array [0..MAXROUNDS+1-1, 0..4-1, 0..MAXBC-1] of word8;
  TArrayBox= array [0..256-1] of word8;


{ Calculate the necessary round keys
  The number of calculations depends on keyBits and blockBits }
function rijndaelKeySched(k: TArrayK; keyBits, blockBits: integer;
                          var W: TArrayRK): integer;

{ Encryption of one block. }
function rijndaelEncrypt(var a: TArrayK; keyBits, blockBits: integer; rk: TArrayRK): integer;

{ Encrypt only a certain number of rounds.
  Only used in the Intermediate Value Known Answer Test. }
function rijndaelEncryptRound(var a: TArrayK; keyBits, blockBits: integer;
		              rk: TArrayRK; var irounds: integer): integer;

{ Decryption of one block. }
function rijndaelDecrypt(var a: TArrayK; keyBits, blockBits: integer; rk: TArrayRK): integer;

{ Decrypt only a certain number of rounds.
  Only used in the Intermediate Value Known Answer Test.
  Operations rearranged such that the intermediate values
  of decryption correspond with the intermediate values
  of encryption. }
function rijndaelDecryptRound(var a: TArrayK; keyBits, blockBits: integer;
	                      rk: TArrayRK; var irounds: integer): integer;


implementation


{$include 'boxestabledat.pas'} // Tables that are needed by the reference implementation.

const
  shifts: array [0..3-1, 0..4-1, 0..2-1] of word8 = (
    ((0, 0),(1, 3),(2, 2),(3, 1)),
    ((0, 0),(1, 5),(2, 4),(3, 3)),
    ((0, 0),(1, 7),(3, 5),(4, 4)));

function iif(bExpression: boolean; iResTrue,iResFalse: integer): integer;
begin
  if bExpression then
    result:= iResTrue
  else
    result:= iResFalse;
end;

function mul(a, b: word8): word8;
{ multiply two elements of GF(2^m)
  needed for MixColumn and InvMixColumn }
begin
  if (a<>0) and (b<>0) then
    result:= Alogtable[(Logtable[a] + Logtable[b]) mod 255]
  else
    result:= 0;
end;

procedure KeyAddition(var a: TArrayK; rk: PArrayK; BC:word8);
{ Exor corresponding text input and round key input bytes }
var
  i, j: integer;
begin
  for i:= 0 to 4-1 do
    for j:= 0 to BC-1 do
      a[i][j]:= a[i][j] xor rk[i][j];
end;

procedure ShiftRow(var a: TArrayK; d, BC: word8);
{ Row 0 remains unchanged
  The other three rows are shifted a variable amount }
var
  tmp: array [0..MAXBC-1] of word8;
  i, j: integer;
begin
  for i:= 1 to 4-1 do
    begin
      for j:= 0 to BC-1 do
        tmp[j]:= a[i][(j + shifts[((BC - 4) shr 1)][i][d]) mod BC];
      for j:= 0 to BC-1 do
        a[i][j]:= tmp[j];
    end;
end;

procedure Substitution(var a: TArrayK; const box: TArrayBox; BC: word8);
{ Replace every byte of the input by the byte at that place
 in the nonlinear S-box }
var
  i, j: integer;
begin
  for i:= 0 to 4-1 do
    for j:= 0 to BC-1 do
      a[i][j]:= box[a[i][j]];
end;

procedure MixColumn(var a: TArrayK; BC: word8);
{ Mix the four bytes of every column in a linear way }
var
  b: TArrayK;
  i, j: integer;
begin
  for j:= 0 to BC-1 do
    for i:= 0 to 4-1 do
      b[i][j]:= mul(2,a[i][j])
                 xor mul(3,a[(i + 1) mod 4][j])
                 xor a[(i + 2) mod 4][j]
                 xor a[(i + 3) mod 4][j];
  for i:= 0 to 4-1 do
    for j:= 0 to BC-1 do
      a[i][j]:= b[i][j];
end;

procedure InvMixColumn(var a: TArrayK; BC: word8);
{ Mix the four bytes of every column in a linear way
  This is the opposite operation of Mixcolumn }
var
  b: TArrayK;
  i, j: integer;
begin
  for j:= 0 to BC-1 do
    for i:= 0 to 4-1 do
      b[i][j]:= mul($e,a[i][j])
                 xor mul($b,a[(i + 1) mod 4][j])
                 xor mul($d,a[(i + 2) mod 4][j])
                 xor mul($9,a[(i + 3) mod 4][j]);
  for i:= 0 to 4-1 do
    for j:= 0 to BC-1 do
      a[i][j]:= b[i][j];
end;

function rijndaelKeySched(k: TArrayK; keyBits, blockBits: integer;
		          var W: TArrayRK): integer;
{ Calculate the necessary round keys
  The number of calculations depends on keyBits and blockBits }
var
  KC, BC, ROUNDS: integer;
  i, j, t, rconpointer: integer;
  tk: array [0..4-1, 0..MAXKC-1] of word8;
begin
  rconpointer:= 0;
  case (keyBits) of
    128: KC:= 4;
    192: KC:= 6;
    256: KC:= 8;
  else
    begin
      result:= -1;
      exit;
    end;
  end;

  case (blockBits) of
    128: BC:= 4;
    192: BC:= 6;
    256: BC:= 8;
  else
    begin
      result:= -2;
      exit;
    end;
  end;

  case iif(keyBits >= blockBits, keyBits, blockBits) of
    128: ROUNDS:= 10;
    192: ROUNDS:= 12;
    256: ROUNDS:= 14;
  else
    begin
      result:= -3;  {* this cannot happen *}
      exit;
    end;
  end;

  for j:= 0 to KC-1 do
    for i:= 0 to 4-1 do
      tk[i][j]:= k[i][j];

  { copy values into round key array }
  t:= 0;
  j:= 0;
  while ((j < KC) and (t < (ROUNDS+1)*BC)) do
    begin
      for i:= 0 to 4-1 do
        W[t div BC][i][t mod BC]:= tk[i][j];
      inc(j);
      inc(t);
    end;

  while (t < (ROUNDS+1)*BC) do { while not enough round key material calculated }
    begin
      { calculate new values }
      for i:= 0 to 4-1 do
        tk[i][0]:= tk[i][0] xor S[tk[(i+1) mod 4][KC-1]];
      tk[0][0]:= tk[0][0] xor rcon[rconpointer];
      inc(rconpointer);
      if (KC <> 8) then
        begin
          for j:= 1 to KC-1 do
            for i:= 0 to 4-1 do
              tk[i][j]:= tk[i][j] xor tk[i][j-1];
        end
      else
        begin
          j:= 1;
          while j < KC/2 do
            begin
              for i:= 0 to 4-1 do
                tk[i][j]:= tk[i][j] xor tk[i][j-1];
              inc(j);
            end;
          for i:= 0 to 4-1 do
            tk[i][KC div 2]:= tk[i][KC div 2] xor S[tk[i][(KC div 2) - 1]];
          j:= (KC div 2) + 1;
          while j < KC do
            begin
              for i:= 0 to 4-1 do
                tk[i][j]:= tk[i][j] xor tk[i][j-1];
              inc(j);
            end;
	      end;

      { copy values into round key array }
      j:= 0;
      while ((j < KC) and (t < (ROUNDS+1)*BC)) do
        begin
          for i:= 0 to 4-1 do
            W[t div BC][i][t mod BC]:= tk[i][j];
          inc(j);
          inc(t);
        end;
    end;
  result:= 0;
end;

function rijndaelEncrypt(var a: TArrayK; keyBits, blockBits: integer; rk: TArrayRK): integer;
{ Encryption of one block. }
var
  r, BC, ROUNDS: integer;
begin
  case (blockBits) of
    128: BC:= 4;
    192: BC:= 6;
    256: BC:= 8;
  else
    begin
      result:= -2;
      exit;
    end;
  end;

  case iif(keyBits >= blockBits, keyBits, blockBits) of
    128: ROUNDS:= 10;
    192: ROUNDS:= 12;
    256: ROUNDS:= 14;
  else
    begin
      result:= -3; { this cannot happen }
      exit;
    end;
  end;

  { begin with a key addition }
  KeyAddition(a,addr(rk[0]),BC);

  { ROUNDS-1 ordinary rounds }
  for r:= 1 to ROUNDS-1 do
    begin
      Substitution(a,S,BC);
      ShiftRow(a,0,BC);
      MixColumn(a,BC);
      KeyAddition(a,addr(rk[r]),BC);
    end;

  { Last round is special: there is no MixColumn }
  Substitution(a,S,BC);
  ShiftRow(a,0,BC);
  KeyAddition(a,addr(rk[ROUNDS]),BC);
  result:= 0;
end;

function rijndaelEncryptRound(var a: TArrayK; keyBits, blockBits: integer;
		              rk: TArrayRK; var irounds: integer): integer;
{ Encrypt only a certain number of rounds.
  Only used in the Intermediate Value Known Answer Test. }
var
  r, BC, ROUNDS: integer;
begin
  case (blockBits) of
    128: BC:= 4;
    192: BC:= 6;
    256: BC:= 8;
   else
     begin
       result:= -2;
       exit;
     end;
   end;

   case iif(keyBits >= blockBits, keyBits, blockBits) of
     128: ROUNDS:= 10;
     192: ROUNDS:= 12;
     256: ROUNDS:= 14;
   else
     begin
       result:= -3; { this cannot happen }
       exit;
     end;
   end;

  { make number of rounds sane }
  if (irounds > ROUNDS) then
    irounds:= ROUNDS;

  { begin with a key addition }
  KeyAddition(a,addr(rk[0]),BC);

  { at most ROUNDS-1 ordinary rounds }
  r:= 1;
  while (r <= irounds) and (r < ROUNDS) do
    begin
      Substitution(a,S,BC);
      ShiftRow(a,0,BC);
      MixColumn(a,BC);
      KeyAddition(a,addr(rk[r]),BC);
      inc(r);
    end;

  { if necessary, do the last, special, round: }
  if (irounds = ROUNDS) then
    begin
      Substitution(a,S,BC);
      ShiftRow(a,0,BC);
      KeyAddition(a,addr(rk[ROUNDS]),BC);
    end;

  result:= 0;
end;

function rijndaelDecrypt(var a: TArrayK; keyBits, blockBits: integer; rk: TArrayRK): integer;
var
  r, BC, ROUNDS: integer;
begin

  case (blockBits) of
    128: BC:= 4;
    192: BC:= 6;
    256: BC:= 8;
  else
    begin
      result:= -2;
      exit;
    end;
  end;

  case iif(keyBits >= blockBits, keyBits, blockBits) of
    128: ROUNDS:= 10;
    192: ROUNDS:= 12;
    256: ROUNDS:= 14;
  else
    begin
      result:= -3; { this cannot happen }
      exit;
    end;
  end;

  { To decrypt: apply the inverse operations of the encrypt routine,
    in opposite order

    (KeyAddition is an involution: it 's equal to its inverse)
    (the inverse of Substitution with table S is Substitution with the inverse table of S)
    (the inverse of Shiftrow is Shiftrow over a suitable distance) }

  { First the special round:
    without InvMixColumn
    with extra KeyAddition }
  KeyAddition(a,addr(rk[ROUNDS]),BC);
  Substitution(a,Si,BC);
  ShiftRow(a,1,BC);

  { ROUNDS-1 ordinary rounds }
  for r:= ROUNDS-1 downto 0+1 do
    begin
      KeyAddition(a,addr(rk[r]),BC);
      InvMixColumn(a,BC);
      Substitution(a,Si,BC);
      ShiftRow(a,1,BC);
    end;

  { End with the extra key addition }

  KeyAddition(a,addr(rk[0]),BC);
  result:= 0;
end;

function rijndaelDecryptRound(var a: TArrayK; keyBits, blockBits: integer;
	                      rk: TArrayRK; var irounds: integer): integer;
{ Decrypt only a certain number of rounds.
  Only used in the Intermediate Value Known Answer Test.
  Operations rearranged such that the intermediate values
  of decryption correspond with the intermediate values
  of encryption. }
var
  r, BC, ROUNDS: integer;
begin
  case (blockBits) of
    128: BC:= 4;
    192: BC:= 6;
    256: BC:= 8;
  else
    begin
      result:= -2;
      exit;
    end;
  end;

  case iif(keyBits >= blockBits, keyBits, blockBits) of
    128: ROUNDS:= 10;
    192: ROUNDS:= 12;
    256: ROUNDS:= 14;
  else
    begin
      result:= -3; { this cannot happen }
      exit;
    end;
  end;

  { make number of rounds sane }
  if (irounds > ROUNDS) then
    irounds:= ROUNDS;

  { First the special round:
    without InvMixColumn
    with extra KeyAddition }

  KeyAddition(a,addr(rk[ROUNDS]),BC);
  Substitution(a,Si,BC);
  ShiftRow(a,1,BC);

  { ROUNDS-1 ordinary rounds }
  for r:= ROUNDS-1 downto irounds+1 do
    begin
      KeyAddition(a,addr(rk[r]),BC);
      InvMixColumn(a,BC);
      Substitution(a,Si,BC);
      ShiftRow(a,1,BC);
    end;

  if (irounds = 0) then
    { End with the extra key addition }
    KeyAddition(a,addr(rk[0]),BC);

  result:= 0;
end;

end.
