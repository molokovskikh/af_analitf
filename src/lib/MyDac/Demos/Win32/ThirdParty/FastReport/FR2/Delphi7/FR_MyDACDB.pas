
//////////////////////////////////////////////////
//  FastReport v2.7 - MyDAC components
//  Copyright (c) 2004 Devart. All right reserved.
//  Database component
//  Created:
//  Last modified:
//////////////////////////////////////////////////

unit FR_MyDACDB;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, FR_Class, StdCtrls,
  Controls, Forms, Menus, Dialogs, DB, MyAccess, MydacVcl;

type
  TfrMyDACComponents = class(TComponent) // fake component
  end;

  TfrMyDACDatabase = class(TfrNonVisualControl)
  private
    FDatabase: TMyConnection;
  protected
    procedure SetPropValue(Index: String; Value: Variant); override;
    function GetPropValue(Index: String): Variant; override;
    function DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefineProperties; override;
    property Database: TMyConnection read FDatabase;
  end;


implementation

uses FR_Utils, FR_Const, FR_DBLookupCtl, FR_MyDACQuery, FR_MyDACTable
{$IFDEF Delphi6}
, Variants
{$ENDIF};

{$R FR_MyDAC.RES}


{ TfrMyDACDatabase }

constructor TfrMyDACDatabase.Create;
begin
  inherited Create;
  FDatabase := TMyConnection.Create(frDialogForm);
  Component := FDatabase;
  BaseName := 'Connection';
  Bmp.LoadFromResourceName(hInstance, 'FR_MyDACDB');
  Flags := Flags or flDontUndo;
end;

destructor TfrMyDACDatabase.Destroy;
begin
  FDatabase.Free;
  inherited Destroy;
end;

procedure TfrMyDACDatabase.DefineProperties;

  function GetServerNames: String;
  var List: TStringList;
      i: integer;
  begin
    List:=TStringList.Create;
    try
      GetMyServerList(List, False);
      for i := 0 to List.Count - 1 do
        Result := Result + List[i] + ';';
    finally
      List.Free;
    end;

  end;

begin
  inherited DefineProperties;
  AddProperty('Connected', [frdtBoolean], nil);
  AddProperty('LoginPrompt', [frdtBoolean], nil);
  AddEnumProperty('Server', GetServerNames, [Null]);
  AddProperty('Password', [frdtString], nil);
  AddProperty('Database', [frdtString], nil);
  AddProperty('Username', [frdtString], nil);
end;

procedure TfrMyDACDatabase.SetPropValue(Index: String; Value: Variant);
begin
  inherited SetPropValue(Index, Value);
  Index := AnsiUpperCase(Index);
  if Index = 'SERVER' then
    FDatabase.Server := Value
  else if Index = 'CONNECTED' then
    FDatabase.Connected := Value
  else if Index = 'LOGINPROMPT' then
    FDatabase.LoginPrompt := Value
  else if Index = 'PASSWORD' then
    FDatabase.Password := Value
  else if Index = 'USERNAME' then
    FDatabase.Username := Value
  else if Index = 'DATABASE' then
    FDatabase.Database := Value
end;

function TfrMyDACDatabase.GetPropValue(Index: String): Variant;
begin
  Index := AnsiUpperCase(Index);
  Result := inherited GetPropValue(Index);
  if Result <> Null then Exit;
   if Index = 'SERVER' then
    Result := FDatabase.Server
  else if Index = 'CONNECTED' then
    Result := FDatabase.Connected
  else if Index = 'LOGINPROMPT' then
    Result := FDatabase.LoginPrompt
  else if Index = 'PASSWORD' then
    Result := FDatabase.Password
  else if Index = 'USERNAME' then
    Result := FDatabase.Username
  else if Index = 'DATABASE' then
    Result := FDatabase.Database
end;

function TfrMyDACDatabase.DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant;
begin
end;

procedure TfrMyDACDatabase.LoadFromStream(Stream: TStream);
var
  s: String;
begin
  inherited LoadFromStream(Stream);

  s := frReadString(Stream);
  if s <> '' then
    FDatabase.Server := s;

  FDatabase.Username:= frReadString(Stream);
  FDatabase.Database:= frReadString(Stream);

  s := frReadString(Stream);
  if s <> '' then
    FDatabase.Password := s;

  FDatabase.LoginPrompt := frReadBoolean(Stream);
  FDatabase.Connected := frReadBoolean(Stream);
end;

procedure TfrMyDACDatabase.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);

  frWriteString(Stream, FDatabase.Server);
  frWriteString(Stream, FDatabase.Username);
  frWriteString(Stream, FDatabase.Database);
  frWriteString(Stream, FDatabase.Password);

  frWriteBoolean(Stream, FDatabase.LoginPrompt);
  frWriteBoolean(Stream, FDatabase.Connected);
end;

var
  BmpDB, BmpQuery, BmpTable: TBitmap;

initialization
  BmpDB := TBitmap.Create;
  BmpDB.LoadFromResourceName(hInstance, 'FR_MyDACDBCONTROL');
  frRegisterControl(TfrMyDACDatabase, BmpDB, IntToStr(SInsertDB));
  BmpQuery := TBitmap.Create;
  BmpQuery.LoadFromResourceName(hInstance, 'FR_MyDACQUERYCONTROL');
  frRegisterControl(TfrMyDACQuery, BmpQuery, IntToStr(SInsertQuery));
  BmpTable := TBitmap.Create;
  BmpTable.LoadFromResourceName(hInstance, 'FR_MyDACTABLECONTROL');
  frRegisterControl(TfrMyDACTable, BmpTable, IntToStr(SInsertTable));

finalization
  frUnRegisterObject(TfrMyDACDatabase);
  BmpDB.Free;
  frUnRegisterObject(TfrMyDACQuery);
  BmpQuery.Free;
  frUnRegisterObject(TfrMyDACTable);
  BmpTable.Free;

end.
