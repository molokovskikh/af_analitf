object frmSendLetter: TfrmSendLetter
  Left = 423
  Top = 164
  Width = 346
  Height = 407
  Caption = #1055#1080#1089#1100#1084#1086' '#1074' '#1040#1050' "'#1048#1085#1092#1086#1088#1091#1084'"'
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
  object lBody: TLabel
    Left = 8
    Top = 48
    Width = 74
    Height = 13
    Caption = #1058#1077#1082#1089#1090' '#1087#1080#1089#1100#1084#1072':'
  end
  object leSubject: TLabeledEdit
    Left = 8
    Top = 16
    Width = 321
    Height = 21
    EditLabel.Width = 71
    EditLabel.Height = 13
    EditLabel.Caption = #1058#1077#1084#1072' '#1087#1080#1089#1100#1084#1072':'
    TabOrder = 0
  end
  object mBody: TMemo
    Left = 8
    Top = 64
    Width = 321
    Height = 129
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object cbAddLogs: TCheckBox
    Left = 8
    Top = 200
    Width = 321
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1083#1086#1075'-'#1092#1072#1081#1083#1099
    TabOrder = 2
  end
  object lbFiles: TListBox
    Left = 8
    Top = 224
    Width = 233
    Height = 97
    ItemHeight = 13
    TabOrder = 3
  end
  object btnAddFile: TButton
    Left = 256
    Top = 224
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 4
  end
  object btnDelFile: TButton
    Left = 256
    Top = 264
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
  end
  object btnSend: TButton
    Left = 168
    Top = 344
    Width = 75
    Height = 25
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 256
    Top = 344
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 7
  end
end
