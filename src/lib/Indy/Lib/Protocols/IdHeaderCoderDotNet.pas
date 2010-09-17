unit IdHeaderCoderDotNet;

interface

{$i IdCompilerDefines.inc}

uses
  IdGlobal, IdHeaderCoderBase;

type
  TIdHeaderCoderDotNet = class(TIdHeaderCoder)
  public
    class function Decode(const ACharSet, AData: String): String; override;
    class function Encode(const ACharSet, AData: String): String; override;
    class function CanHandle(const ACharSet: String): Boolean; override;
  end;

implementation

uses
  System.Text;

class function TIdHeaderCoderDotNet.Decode(const ACharSet, AData: String): String;
var
  LEncoder: System.Text.Encoding;
  LBytes: TIdBytes;
begin
  Result := '';
  try
    LEncoder := System.Text.Encoding.GetEncoding(ACharSet);
    LBytes := System.Text.Encoding.Convert(
      LEncoder,
      System.Text.Encoding.Unicode,
      LEncoder.GetBytes(AData));
    Result := System.Text.Encoding.Unicode.GetString(LBytes, 0, Length(LBytes));
  except
  end;
end;

class function TIdHeaderCoderDotNet.Encode(const ACharSet, AData: String): String;
var
  LEncoder: System.Text.Encoding;
  LBytes: TIdBytes;
begin
  Result := '';
  try
    LEncoder := System.Text.Encoding.GetEncoding(ACharSet);
    LBytes := System.Text.Encoding.Convert(
      System.Text.Encoding.Unicode,
      LEncoder,
      System.Text.Encoding.Unicode.GetBytes(AData));
    Result := LEncoder.GetString(LBytes, 0, Length(LBytes));
  except
  end;
end;

class function TIdHeaderCoderDotNet.CanHandle(const ACharSet: String): Boolean;
var
  LEncoder: System.Text.Encoding;
begin
  try
    LEncoder := System.Text.Encoding.GetEncoding(ACharSet);
  except
    LEncoder := nil;
  end;
  Result := Assigned(LEncoder);
end;

initialization
  RegisterHeaderCoder(TIdHeaderCoderDotNet);
finalization
  UnregisterHeaderCoder(TIdHeaderCoderDotNet);

end.
