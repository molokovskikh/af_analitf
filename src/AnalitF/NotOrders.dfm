object NotOrdersForm: TNotOrdersForm
  Left = 426
  Top = 117
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #1053#1077#1082#1086#1088#1088#1077#1082#1090#1085#1099#1077' '#1079#1072#1082#1072#1079#1099
  ClientHeight = 329
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 350
    Height = 13
    Caption = #1057#1091#1084#1084#1072' '#1076#1072#1085#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074' '#1084#1077#1085#1100#1096#1077' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086' '#1076#1086#1087#1091#1089#1090#1080#1084#1086#1081' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo: TMemo
    Left = 8
    Top = 24
    Width = 609
    Height = 265
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object btnOK: TButton
    Left = 8
    Top = 296
    Width = 105
    Height = 25
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 232
    Top = 296
    Width = 105
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
    TabOrder = 2
    OnClick = Button1Click
  end
  object btnCancel: TButton
    Left = 120
    Top = 296
    Width = 105
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Left = 224
    Top = 104
  end
end
