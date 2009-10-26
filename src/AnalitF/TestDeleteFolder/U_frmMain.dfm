object frmMain: TfrmMain
  Left = 415
  Top = 260
  Width = 427
  Height = 277
  Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnPrepareOld: TButton
    Left = 16
    Top = 8
    Width = 155
    Height = 25
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1080#1090#1100' '#1087#1086'-'#1089#1090#1072#1088#1086#1084#1091
    TabOrder = 0
    OnClick = btnPrepareOldClick
  end
  object btnPrepareNew: TButton
    Left = 208
    Top = 8
    Width = 155
    Height = 25
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1080#1090#1100' '#1087#1086'-'#1085#1086#1074#1086#1084#1091
    TabOrder = 1
    OnClick = btnPrepareNewClick
  end
  object btnDeleteOld: TButton
    Left = 16
    Top = 56
    Width = 155
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086'-'#1089#1090#1072#1088#1086#1084#1091
    TabOrder = 2
    OnClick = btnDeleteOldClick
  end
  object btnDeleteNew: TButton
    Left = 208
    Top = 56
    Width = 155
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086'-'#1085#1086#1074#1086#1084#1091
    TabOrder = 3
    OnClick = btnDeleteNewClick
  end
  object btnPrepareEmpty: TButton
    Left = 112
    Top = 104
    Width = 153
    Height = 25
    Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1080#1090#1100' '#1087#1091#1089#1090#1099#1077
    TabOrder = 4
    OnClick = btnPrepareEmptyClick
  end
  object btnClear: TButton
    Left = 112
    Top = 152
    Width = 153
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 5
    OnClick = btnClearClick
  end
  object btnTest: TButton
    Left = 112
    Top = 200
    Width = 153
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1090#1077#1089#1090
    TabOrder = 6
    OnClick = btnTestClick
  end
end
