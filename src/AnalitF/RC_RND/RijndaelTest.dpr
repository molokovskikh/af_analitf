program RijndaelTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  infver in 'infver.pas',
  infvercls in 'infvercls.pas';

var
  C : TINFCrypt;

  F : TextFile;
  TmpS, S : String;

begin
  SetConsoleCP(1251);
  SetConsoleOutputCP(1251);
  try
{
}
  AssignFile(F, 'C:\1.txt');
  Reset(F);
  ReadLn(F, S);
  CloseFile(F);
//  C := TINFCrypt.Create('proverkaproverka', 200);


{
  C := TINFCrypt.Create('abJfh3qGrZtAHwpN', 200);
  Writeln('Decrypt :', c.DecodeHex('561FCC834CA6FA7AA0B5EB6E62A0A1E3A9E23744BC17DB5784B34004DEED7A23'));
                                 //561FCC834CA6FA7AA0B5EB6E62A0A1E3A9E23744BC17DB5784B34004DEED7A23
  Writeln('Decrypt :', c.DecodeHex('F16502CB0E31FBBC7A849F0F722E9C638D5442ED10C26098AF523956DD16C16EF05536B25D719573107D4DFA1F1E04CC'));
  Writeln('Decrypt :', c.DecodeHex('3B556FDB6FD59BE46B2F105F0B4F421C'));
  //;UoЫoХ%9Bдk/_OB
  Writeln('Decrypt :', c.DecodeMix(';UoЫoХ%9Bдk/_OB'));
  Writeln('Decrypt :', c.DecodeMix(S));

  //АВИА-МОРЕ карамель гомеопат. 10шт/50г (о
  Writeln('Encrypt :', c.EncodeHex('1234567812345678'));
  TmpS := c.Encode('АВИА-МОРЕ карамель гомеопат. 10шт/50г (о');
  Writeln('Encrypt :', TmpS);
  Writeln('Decrypt :', c.Decode(TmpS));
  Writeln('Decrypt :', c.DecodeHex('A332335253F31CFB8DC86215B603092A'));
  if (TmpS = S) then
    WriteLn('Compare');
}

  C := TINFCrypt.Create('O8Dyru2CBLqkHAwO', 200);
  Writeln('Decrypt :', c.DecodeMix(S));
  except
    on E : Exception do begin
      WriteLn('Error : ' + E.Message);
    end;
  end;
  Write('Press any key...');
  ReadLn;
end.
