
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2004 Devart. All right reserved.
//  InfoPower compatible components
//  This module contains classes for Woll2Woll InfoPower compatibility
//////////////////////////////////////////////////

unit MyIP;

interface

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  DB,
  dialogs,
  wwFilter,
  wwStr,
  wwSystem,
  wwTable,
  wwTypes,
  MyAccess;

type

{ TwwMyQuery }

  TwwMyQuery = class (TMyQuery)
  private
    FControlType: TStrings;
    FPictureMasks: TStrings;
    FUsePictureMask: boolean;
    FOnInvalidValue: TwwInvalidValueEvent;

    function GetControlType: TStrings;
    procedure SetControlType(Sel: TStrings);
    function GetPictureMasks: TStrings;
    procedure SetPictureMasks(Sel: TStrings);

  protected
    procedure DoBeforePost; override; { For picture support }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ControlType: TStrings read GetControlType write SetControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

{ TwwMyTable }

  TwwMyTable = class (TMyTable)
  private
    FControlType: TStrings;
    FPictureMasks: TStrings;
    FUsePictureMask: boolean;
    FOnInvalidValue: TwwInvalidValueEvent;

    function GetControlType: TStrings;
    procedure SetControlType(Sel: TStrings);
    function GetPictureMasks: TStrings;
    procedure SetPictureMasks(Sel: TStrings);

  protected
    procedure DoBeforePost; override; { For picture support }

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property ControlType: TStrings read GetControlType write SetControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

procedure Register;

implementation
uses
  wwCommon,
  dbConsts;

{ TwwMyQuery }

constructor TwwMyQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FControlType := TStringList.Create;
  FPictureMasks := TStringList.Create;
  FUsePictureMask := True;
end;

destructor TwwMyQuery.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks := nil;

  inherited Destroy;
end;

function TwwMyQuery.GetControlType: TStrings;
begin
  Result := FControlType;
end;

procedure TwwMyQuery.SetControlType(Sel: TStrings);
begin
  FControlType.Assign(Sel);
end;

function TwwMyQuery.GetPictureMasks: TStrings;
begin
  Result := FPictureMasks
end;

procedure TwwMyQuery.SetPictureMasks(Sel: TStrings);
begin
  FPictureMasks.Assign(Sel);
end;

procedure TwwMyQuery.DoBeforePost;
begin
  inherited DoBeforePost;

  if FUsePictureMask then
    wwValidatePictureFields(Self, FOnInvalidValue);
end;

{ TwwMyTable }

constructor TwwMyTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FControlType := TStringList.Create;
  FPictureMasks := TStringList.Create;
  FUsePictureMask := True;
end;

destructor TwwMyTable.Destroy;
begin
  FControlType.Free;
  FPictureMasks.Free;
  FPictureMasks := nil;

  inherited Destroy;
end;

function TwwMyTable.GetControlType: TStrings;
begin
  Result := FControlType;
end;

procedure TwwMyTable.SetControlType(Sel: TStrings);
begin
  FControlType.Assign(Sel);
end;

function TwwMyTable.GetPictureMasks: TStrings;
begin
  Result := FPictureMasks
end;

procedure TwwMyTable.SetPictureMasks(Sel: TStrings);
begin
  FPictureMasks.Assign(Sel);
end;

procedure TwwMyTable.DoBeforePost;
begin
  inherited DoBeforePost;

  if FUsePictureMask then
    wwValidatePictureFields(Self, FOnInvalidValue);
end;

procedure Register;
begin
  RegisterComponents('MySQL Access', [TwwMyQuery]);
  RegisterComponents('MySQL Access', [TwwMyTable]);
end;

end.