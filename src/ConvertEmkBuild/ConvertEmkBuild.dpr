program ConvertEmkBuild;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  IdHashMessageDigest,
  hlpcodecs in '..\AnalitF\RC_RND\hlpcodecs.pas',
  incrt in '..\AnalitF\RC_RND\incrt.pas',
  INFHelpers in '..\AnalitF\RC_RND\INFHelpers.pas',
  inforoomalg in '..\AnalitF\RC_RND\inforoomalg.pas',
  inforoomapi in '..\AnalitF\RC_RND\inforoomapi.pas',
  infver in '..\AnalitF\RC_RND\infver.pas',
  infvercls in '..\AnalitF\RC_RND\infvercls.pas';

const
  buildsDir = '..\..\EMKBuilds';
  libmysqldFile = 'libmysqld.dll';
  encodedLibmysqldFile = 'appdbhlp.dll';
  decodedLibmysqldFile = 'libmysqld.dec';

  procedure CryptEMKBuild;
  var
    inFile : TFileStream;
    cryptFile : TFileStream;
    decodeFile : TFileStream;
    leftStream, rightStream : TMemoryStream;
  begin
    //Кодировка
    inFile := TFileStream.Create(buildsDir + '\' + libmysqldFile, fmOpenRead or fmShareDenyWrite);
    try
      cryptFile := TFileStream.Create(buildsDir + '\' + encodedLibmysqldFile, fmCreate);
      try
        EncodeStream(inFile, cryptFile);
      finally
        cryptFile.Free;
      end;
    finally
      inFile.Free;
    end;

    Sleep(1000);

    //Раскодировка
    cryptFile := TFileStream.Create(buildsDir + '\' + encodedLibmysqldFile, fmOpenRead or fmShareDenyWrite);
    try
      decodeFile := TFileStream.Create(buildsDir + '\' + decodedLibmysqldFile, fmCreate);
      try
        DecodeStream(cryptFile, decodeFile);
      finally
        decodeFile.Free;
      end;
    finally
      cryptFile.Free;
    end;

    Sleep(1000);

    //Сравнение раскодированного файла
    leftStream := TMemoryStream.Create;
    try
      rightStream := TMemoryStream.Create;
      try
        leftStream.LoadFromFile(buildsDir + '\' + libmysqldFile);
        rightStream.LoadFromFile(buildsDir + '\' + decodedLibmysqldFile);
        if leftStream.Size <> rightStream.Size then
          raise Exception.Create('Stream differs on size')
        else
          if not CompareMem(leftStream.Memory, rightStream.memory, leftStream.Size)
          then
            raise Exception.Create('Stream differs on content');
      finally
        rightStream.Free;
      end;
    finally
      leftStream.Free;
    end;

  end;

  function GetFileHash(AFileName: String): String;
  var
    md5 : TIdHashMessageDigest5;
    fs : TFileStream;
  begin
    try
      md5 := TIdHashMessageDigest5.Create;
      try

        fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
        try
          Result := md5.HashStreamAsHex( fs );
        finally
          fs.Free;
        end;

      finally
        md5.Free;
      end;
    except
      Result := '';
    end;
  end;

begin
  try
    if not DirectoryExists(buildsDir) then
      raise Exception.Create('not found folder: ' + buildsDir);

    if not FileExists(buildsDir + '\' + libmysqldFile) then
      raise Exception.Create('not found file: ' + libmysqldFile);

    if FileExists(buildsDir + '\' + encodedLibmysqldFile) then
      if not DeleteFile(buildsDir + '\' + encodedLibmysqldFile) then
        RaiseLastOSError;

    if FileExists(buildsDir + '\' + decodedLibmysqldFile) then
      if not DeleteFile(buildsDir + '\' + decodedLibmysqldFile) then
        RaiseLastOSError;

    CryptEMKBuild;

    DeleteFile(buildsDir + '\' + decodedLibmysqldFile);

    WriteLn('Ok');
    WriteLn('Hash: ' + GetFileHash(buildsDir + '\' + encodedLibmysqldFile));
  except
    on E : Exception do
      WriteLn('Error : ' + E.Message);
  end;
end.
