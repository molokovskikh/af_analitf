
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2009 Devart. All right reserved.
//  MySQL Params Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyParamsFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
{$ELSE}
  QStdCtrls, QControls, QExtCtrls,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, DB,
  CRFrame, CRTabEditor, DAParamsFrame, DBAccess;

type
  TMyParamsFrame = class(TDAParamsFrame)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF IDE}                                               
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyParamsFrame.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

uses
  MyAccess;

{ TMyParamsFrame }

constructor TMyParamsFrame.Create(AOwner: TComponent);
begin
  inherited;

  AddDataType('Unknown',    ftUnknown,    True,  False, False, '');
  AddDataType('String',     ftString,     False, True,  True,  '');
  AddDataType('WideString', ftWideString, False, True,  True,  '');
  AddDataType('Smallint',   ftSmallint,   True,  True,  False, '0');
  AddDataType('Integer',    ftInteger,    True,  True,  False, '0');
  AddDataType('Word',       ftWord,       True,  True,  False, '0');
  AddDataType('LargeInt',   ftLargeInt,   True,  True,  False, '0');
  AddDataType('Float',      ftFloat,      True,  True,  False, '0');
  AddDataType('BCD',        ftBCD,        True,  True,  False, '0');
  AddDataType('DateTime',   ftDateTime,   True,  True,  False, '');
  AddDataType('Date',       ftDate,       True,  True,  False, '');
  AddDataType('Time',       ftTime,       True,  True,  False, '');
  AddDataType('FixedChar',  ftFixedChar,  False, True,  True,  '');
  AddDataType('Memo',       ftMemo,       False, True,  False, '');
{$IFDEF VER10P}
  AddDataType('WideMemo',   ftWideMemo,   False, True,  False, '');
{$ENDIF}
  AddDataType('Blob',       ftBlob,       False, False, False, '');
  AddDataType('Boolean',    ftBoolean,    True,  True,  False, '');
  AddDataType('Bytes',      ftBytes,      False, False, True,  '');
  AddDataType('VarBytes',   ftVarBytes,   False, False, True,  '');

{  AddParamType('Unknown', ptUnknown);}
  AddParamType('IN', ptInput);
  AddParamType('OUT', ptOutput);
  AddParamType('IN/OUT', ptInputOutput);
  AddParamType('RESULT', ptResult);
end;

{$IFDEF FPC}
initialization
  {$i MyParamsFrame.lrs}
{$ENDIF}

end.
