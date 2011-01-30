object WaitForm: TWaitForm
  Left = 199
  Top = 182
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1054#1078#1080#1076#1072#1085#1080#1077
  ClientHeight = 148
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 18
    Width = 262
    Height = 42
    AutoSize = False
    Caption = 
      #1050#1086#1087#1080#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1085#1072' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1077' %s'#13#10#1079#1072#1087#1088#1072#1096#1080#1074#1072#1077#1090' '#1084#1086#1085#1086#1087#1086#1083#1100#1085#1099#1081' '#1076#1086#1089#1090#1091#1087 +
      ' '#1082' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093'.'#13#10#1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1073#1091#1076#1077#1090' '#1079#1072#1082#1088#1099#1090#1072' '#1095#1077#1088#1077#1079' %d '#1089#1077#1082#1091#1085#1076'.'
    WordWrap = True
  end
  object Animate1: TAnimate
    Left = 80
    Top = 79
    Width = 130
    Height = 13
    AutoSize = False
    StopFrame = 14
    Transparent = False
  end
  object btnExit: TButton
    Left = 107
    Top = 110
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    Default = True
    TabOrder = 1
    OnClick = btnExitClick
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 8
    Top = 112
  end
end
