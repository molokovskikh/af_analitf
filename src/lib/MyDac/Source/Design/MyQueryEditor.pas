
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyQuery Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyQueryEditor;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, DBCtrls,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DASQLComponentEditor, DASQLFrame, DAParamsFrame, DAMacrosFrame, DASPCallFrame,
  MyAccess, MyClasses, MyCall, Db, DBAccess, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  MyParamsFrame, DAQueryEditor;

type
  TMyQueryEditorForm = class(TDAQueryEditorForm)
  protected
    procedure DoInit; override;
    procedure DoError(E: Exception); override;

  public
    property Query;

  end;

implementation

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyQueryEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

uses
  MyCommandEditor, DAUpdateSQLFrame, DASQLGeneratorFrame;

procedure TMyQueryEditorForm.DoInit;
begin
  FSQLFrame := AddTab(TDASQLFrame, shSQL) as TDASQLFrame;
  FParamsFrame := AddTab(TMyParamsFrame, shParameters) as TDAParamsFrame;
  FMacrosFrame := AddTab(TDAMacrosFrame, shMacros) as TDAMacrosFrame;
  FSPCallFrame := AddTab(TDASPCallFrame, shGeneratorSPC) as TDASPCallFrame;
  FUpdateSQLFrame := AddTab(TDAUpdateSQLFrame, shEditSQL) as TDAUpdateSQLFrame;
  FSQLGeneratorFrame := AddTab(TDASQLGeneratorFrame, shGenerator) as TDASQLGeneratorFrame;

  inherited;
end;

procedure TMyQueryEditorForm.DoError(E: Exception);
begin
  if E is EMyError then
    MyCommandEditor.DoError(Self, EMyError(E))
  else
    inherited;
end;

{$IFDEF FPC}
initialization
  {$i MyQueryEditor.lrs}
{$ENDIF}

end.
