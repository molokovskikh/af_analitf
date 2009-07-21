
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyEmbConnection.Params Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyEmbConParamsEditor;
{$ENDIF}

interface
uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls, QComCtrls, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  CREditor, DB, MyAccess, MyEmbConnection;

type
  TMyEmbConParamsEditorForm = class(TCREditorForm)
    Memo: TMemo;

    procedure MemoChange(Sender: TObject);

  protected
    FConnection: TMyEmbConnection;

    procedure DoActivate; override;
    procedure DoSave; override;

    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;

  public
    property Connection: TMyEmbConnection read FConnection write FConnection;

  end;

implementation
uses
  MemData, CRParser
  {$IFDEF VER6P}
  , Variants
  {$ENDIF}
  ;

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyEmbConParamsEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

function TMyEmbConParamsEditorForm.GetComponent: TComponent;
begin
  Result := FConnection;
end;

procedure TMyEmbConParamsEditorForm.SetComponent(Value: TComponent);
begin
  FConnection := Value as TMyEmbConnection;
end;

procedure TMyEmbConParamsEditorForm.DoActivate;
begin
  inherited;
  Memo.Lines := Connection.Params;
  Modified := False;
end;

procedure TMyEmbConParamsEditorForm.DoSave;
begin
  Connection.Params := Memo.Lines;
  inherited;
end;

procedure TMyEmbConParamsEditorForm.MemoChange(Sender: TObject);
begin
  inherited;
  Modified := True;
end;

{$IFDEF FPC}
initialization
  {$i MyEmbConParamsEditor.lrs}
{$ENDIF}

end.
