object WaitingForm: TWaitingForm
  Left = 493
  Top = 384
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1040#1085#1072#1083#1080#1090#1060#1040#1056#1052#1040#1062#1048#1071
  ClientHeight = 148
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lInformation: TLabel
    Left = 15
    Top = 18
    Width = 259
    Height = 39
    Caption = 
      #1044#1072#1085#1085#1072#1103' '#1086#1087#1077#1088#1072#1094#1080#1103' '#1076#1086#1089#1090#1091#1087#1085#1072' '#1090#1086#1083#1100#1082#1086' '#1074' '#1084#1086#1085#1086#1087#1086#1083#1100#1085#1086#1084#13#10#1088#1077#1078#1080#1084#1077'. '#1054#1087#1077#1088#1072#1094#1080#1103' ' +
      #1073#1091#1076#1077#1090' '#1087#1088#1086#1076#1086#1083#1078#1077#1085#1072' '#1087#1086#1089#1083#1077#13#10#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1084#1086#1085#1086#1087#1086#1083#1100#1085#1086#1075#1086' '#1076#1086#1089#1090#1091#1087#1072' '#1082' '#1073#1072#1079#1077' '#1076#1072 +
      #1085#1085#1099#1093'.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 91
    Top = 114
    Width = 3
    Height = 13
  end
  object Animate1: TAnimate
    Left = 80
    Top = 86
    Width = 130
    Height = 13
    AutoSize = False
    StopFrame = 14
    Transparent = False
  end
  object Timer: TTimer
    Interval = 3000
    OnTimer = TimerTimer
    Left = 8
    Top = 112
  end
end
