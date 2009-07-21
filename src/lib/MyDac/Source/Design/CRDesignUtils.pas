
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I Dac.inc}

unit CRDesignUtils;
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  TCRDesignUtilsAlias = class
  public
    {$IFNDEF VER8}class{$ENDIF} function GetProjectName: string; virtual; // Returns ProjectName = ('DataEditor', 'ODAC', 'SDAC', 'MyDAC', ...)

  { Component }
    {$IFNDEF VER8}class{$ENDIF} function GetDesignCreate(Obj: TComponent): boolean; virtual;
    {$IFNDEF VER8}class{$ENDIF} procedure SetDesignCreate(Obj: TComponent; Value: boolean); virtual;

  {$IFDEF USE_SYNEDIT}
    {$IFNDEF VER8}class{$ENDIF} function SQLDialect: integer ; virtual; // SynHighlighterSQL TSQLDialect = (sqlStandard, sqlInterbase6, sqlMSSQL7, sqlMySQL, sqlOracle, sqlSybase, sqlIngres, sqlMSSQL2K);
  {$ENDIF}

    class function DBToolsAvailable: boolean; virtual;
  end;

{$IFDEF VER8}
  TCRDesignUtilsClass = TCRDesignUtilsAlias;

var
  TCRDesignUtils: TCRDesignUtilsAlias;
{$ELSE}
  TCRDesignUtils = TCRDesignUtilsAlias;
  TCRDesignUtilsClass = class of TCRDesignUtils;
{$ENDIF}

implementation

{ TCRDesignUtilsAlias }

{$IFNDEF VER8}class{$ENDIF} function TCRDesignUtilsAlias.GetProjectName: string;
begin
 Result := 'DAC';
end;

{$IFNDEF VER8}class{$ENDIF} function TCRDesignUtilsAlias.GetDesignCreate(Obj: TComponent): boolean;
begin
  Result := False;
  Assert(Obj <> nil);
  Assert(False, Obj.ClassName);
end;

{$IFNDEF VER8}class{$ENDIF} procedure TCRDesignUtilsAlias.SetDesignCreate(Obj: TComponent; Value: boolean);
begin
  Assert(Obj <> nil);
  Assert(False, Obj.ClassName);
end;

{$IFDEF USE_SYNEDIT}
{$IFNDEF VER8}class{$ENDIF} function TCRDesignUtilsAlias.SQLDialect: integer;
begin
  Result := 0; // sqlStandard
end;
{$ENDIF}

class function TCRDesignUtilsAlias.DBToolsAvailable: boolean;
begin
  Result := False;
end;

initialization
{$IFDEF VER8}
  TCRDesignUtils := TCRDesignUtilsAlias.Create;
{$ENDIF}

finalization
{$IFDEF VER8}
  TCRDesignUtils.Free;
{$ENDIF}


end.
