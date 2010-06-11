object NotOrdersForm: TNotOrdersForm
  Left = 426
  Top = 117
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = #1054#1096#1080#1073#1082#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1079#1072#1082#1072#1079#1086#1074
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
    Width = 482
    Height = 26
    Caption = 
      #1044#1072#1085#1085#1099#1077' '#1079#1072#1082#1072#1079#1099' '#1052#1054#1043#1059#1058' '#1041#1067#1058#1068' '#1054#1058#1055#1056#1040#1042#1051#1045#1053#1067' '#1087#1086' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1102' '#1089' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1086 +
      #1084','#13#10#1086#1076#1085#1072#1082#1086' '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '#1084#1077#1085#1100#1096#1077' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086' '#1076#1086#1087#1091#1089#1090#1080#1084#1086#1081' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1086#1084 +
      ':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo: TMemo
    Left = 8
    Top = 40
    Width = 609
    Height = 249
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object btnOK: TButton
    Left = 8
    Top = 296
    Width = 130
    Height = 25
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1079#1072#1082#1072#1079#1099
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 278
    Top = 296
    Width = 130
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1092#1072#1081#1083
    TabOrder = 2
    OnClick = Button1Click
  end
  object btnCancel: TButton
    Left = 143
    Top = 296
    Width = 130
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1086#1090#1087#1088#1072#1074#1082#1091
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
