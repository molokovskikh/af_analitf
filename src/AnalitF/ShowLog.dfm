object frmShowLog: TfrmShowLog
  Left = 197
  Top = 224
  BorderStyle = bsDialog
  Caption = #1046#1091#1088#1085#1072#1083' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1074#1085#1077#1096#1085#1080#1093' '#1079#1072#1082#1072#1079#1086#1074
  ClientHeight = 374
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    750
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object mLog: TMemo
    Left = 8
    Top = 16
    Width = 732
    Height = 299
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 328
    Top = 336
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 1
    TabOrder = 1
  end
end
