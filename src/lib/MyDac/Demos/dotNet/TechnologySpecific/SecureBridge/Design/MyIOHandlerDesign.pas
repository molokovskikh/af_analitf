
//////////////////////////////////////////////////
//  MyDac Components
//  Copyright © 1997-2009 Devart. All right reserved.
//  Design
//////////////////////////////////////////////////

unit MyIOHandlerDesign;

{$I SB.inc}

interface

uses
{$IFDEF CLR}
  Borland.Vcl.Design.DesignEditors, Borland.Vcl.Design.DesignIntf,
{$ELSE}
  {$IFDEF VER6P}DesignIntf, DesignEditors,{$ELSE}DsgnIntf,{$ENDIF}
{$ENDIF}
  SysUtils, Classes;

type
  TCertNamesEditor = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

uses
  MySSLIOHandler;

{ TCertNamesEditor }

function TCertNamesEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TCertNamesEditor.GetValues(Proc: TGetStrProc);
var
  List: TStrings;
  i: integer;
begin
  List := TStringList.Create;
  try
    if GetComponent(0) is TMySSLIOHandler then begin
      if TMySSLIOHandler(GetComponent(0)).Storage <> nil then
        TMySSLIOHandler(GetComponent(0)).Storage.Certificates.GetCertificateNames(List);
    end;

    for i := 0 to List.Count - 1 do
      Proc(List[i]);
  finally
    List.Free;
  end;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string), TMySSLIOHandler, 'CertName', TCertNamesEditor);
  RegisterPropertyEditor(TypeInfo(string), TMySSLIOHandler, 'CACertName', TCertNamesEditor);
end;

end.

