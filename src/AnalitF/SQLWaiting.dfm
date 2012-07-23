object frmSQLWaiting: TfrmSQLWaiting
  Left = 344
  Top = 168
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1054#1078#1080#1076#1072#1085#1080#1077
  ClientHeight = 72
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    272
    72)
  PixelsPerInch = 96
  TextHeight = 13
  object lWait: TLabel
    Left = 70
    Top = 46
    Width = 132
    Height = 13
    Caption = #1055#1086#1076#1086#1078#1076#1080#1090#1077', '#1087#1086#1078#1072#1083#1091#1081#1089#1090#1072'...'
  end
  object lCaption: TLabel
    Left = 10
    Top = 16
    Width = 257
    Height = 13
    Alignment = taCenter
    Anchors = [akLeft, akRight]
    AutoSize = False
  end
  object tmFill: TTimer
    OnTimer = tmFillTimer
    Left = 8
    Top = 8
  end
end
