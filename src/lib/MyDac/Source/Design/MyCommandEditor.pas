
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyCommand Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyCommandEditor;
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
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DASQLComponentEditor, DASQLFrame, DAParamsFrame, DAMacrosFrame, DASPCallFrame,
  MyAccess, MyClasses, MyCall, Db, DBAccess, MemUtils, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  MyParamsFrame;

type
  TMyCommandEditorForm = class(TDASQLEditorForm)
  protected
    procedure DoInit; override;
    procedure DoError(E: Exception); override;

  public
    property SQL;

  end;

procedure DoError(Sender: TDASQLEditorForm; E: EMyError); 

implementation

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFDEF MSWINDOWS}
{$R MyCommandEditor.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

uses
  CREditor;

procedure TMyCommandEditorForm.DoInit;
begin
  FSQLFrame := AddTab(TDASQLFrame, shSQL) as TDASQLFrame;
  FParamsFrame := AddTab(TMyParamsFrame, shParameters) as TDAParamsFrame;
  FMacrosFrame := AddTab(TDAMacrosFrame, shMacros) as TDAMacrosFrame;
  FSPCallFrame := AddTab(TDASPCallFrame, shGeneratorSPC) as TDASPCallFrame;

  inherited;
end;

procedure TMyCommandEditorForm.DoError(E: Exception);
begin
  if E is EMyError then
    {$IFDEF CLR}Devart.MyDac.Design.{$ENDIF}MyCommandEditor.DoError(Self, EMyError(E))
  else
    inherited;
end;

procedure DoError(Sender: TDASQLEditorForm; E: EMyError);
var
  Msg, s: string;
  LinePos, i, j: integer;
  SQL: _TStrings;
  IsIdentifierError, IsParseError: boolean;
begin
  IsIdentifierError := False;
  IsParseError := False;
  case E.ErrorCode of
    ER_BAD_FIELD_ERROR, ER_NO_SUCH_TABLE, ER_TRG_DOES_NOT_EXIST:
      IsIdentifierError := True;
    ER_PARSE_ERROR:
      IsParseError := True;
  end;

  if IsIdentifierError or IsParseError then begin
    Sender.ActivateFrame(Sender.SQLFrame);// Sender.shSQL;
  {$IFDEF DBTOOLS}
    if DBTools.HasDACSqlEditorFrame(Sender.SQLFrame.meSQL) then
      Sender.ActiveControl := DBTools.GetDACSqlEditorFrame(Sender.SQLFrame.meSQL)
    else
  {$ENDIF}
      Sender.ActiveControl := Sender.SQLFrame.meSQL;
  end;

  if IsParseError then
    try
      Msg := E.Message;
      i := Length(Msg);
      //j := 0;
      while i >= 1 do begin
        if (Msg[i] >= '0') and (Msg[i] <= '0') then begin
          // search Line
          Dec(i);
          while (i >= 1) and (Msg[i] >= '0') and (Msg[i] <= '0') do
            Dec(i);

          // search Pos
          while (i >= 1) and (Msg[i] <> '''') do
            Dec(i);

          if i > 1 then begin // must be always True
            Dec(i);
            j := i;
            while (i >= 1) and (Msg[i] <> '''') do
              Dec(i);
            s := Copy(Msg, i + 1, j - i);
            j := Pos(#$D, s);
            if j > 3 then // trunc #$D#$A
              s := Copy(s, 1, j - 1);

            SQL := Sender.DADesignUtilsClass.GetSQL(Sender.LocalComponent);
            j := 0;
            for i := 0 to E.LineNumber - 1{current line} - 1{numeration from 0} do
              Inc(j, Length(SQL[i]) + 2{#$D#$A});

            LinePos := Pos(LowerCase(s), LowerCase(SQL[E.LineNumber - 1]));
            if LinePos > 0 then begin // Found
              j := j + LinePos - 1;
              SetSelStart(Sender.SQLFrame.meSQL, j);
              SetSelLength(Sender.SQLFrame.meSQL, Length(s));
            end
            else
            begin // Not found
              SetSelStart(Sender.SQLFrame.meSQL, j);
              SetSelLength(Sender.SQLFrame.meSQL, Length(SQL[E.LineNumber - 1]));
            end;
          end;

          Break;
        end;
        Dec(i);
      end;
    except
      // Silent exception handling
    end;
end;

{$IFDEF FPC}
initialization
  {$i MyCommandEditor.lrs}
{$ENDIF}

end.
