
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyUpdateSQL Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyUpdateSQLEditor;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,  Buttons, ComCtrls,
{$ELSE}
  QComCtrls, QStdCtrls, QButtons, QGraphics, QControls, QExtCtrls,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, DBAccess, 
  DAUpdateSQLEditor;

type
  TMyUpdateSQLEditorForm = class(TDAUpdateSQLEditorForm)
  protected
    procedure DoInit; override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyUpdateSQLEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

uses
  DAUpdateSQLFrame, DASQLGeneratorFrame, MyAccess;

{ TMyUpdateSQLEditorForm }

procedure TMyUpdateSQLEditorForm.DoInit;
begin
  FUpdateSQLFrame := AddTab(TDAUpdateSQLFrame, shEditSQL) as TDAUpdateSQLFrame;
  FSQLGeneratorFrame := AddTab(TDASQLGeneratorFrame, shGenerator) as TDASQLGeneratorFrame;
  inherited;
end;

{$IFDEF FPC}
initialization
  {$i MyUpdateSQLEditor.lrs}
{$ENDIF}

end.
