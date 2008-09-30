object NotFoundForm: TNotFoundForm
  Left = 198
  Top = 284
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #1053#1077' '#1085#1072#1081#1076#1077#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 329
  ClientWidth = 692
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
    Width = 361
    Height = 13
    Caption = #1055#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' '#1087#1086' '#1076#1072#1085#1085#1099#1084' '#1087#1086#1079#1080#1094#1080#1103#1084' '#1080#1079' '#1079#1072#1082#1072#1079#1072' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1102#1090' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnClose: TButton
    Left = 8
    Top = 296
    Width = 105
    Height = 25
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Memo: TMemo
    Left = 8
    Top = 24
    Width = 676
    Height = 265
    ScrollBars = ssBoth
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object Button1: TButton
    Left = 120
    Top = 296
    Width = 105
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
    TabOrder = 2
    OnClick = Button1Click
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofPathMustExist, ofEnableSizing]
    Left = 224
    Top = 104
  end
end
