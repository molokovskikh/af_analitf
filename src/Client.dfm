object ClientForm: TClientForm
  Left = 381
  Top = 320
  BorderStyle = bsDialog
  Caption = #1050#1083#1080#1077#1085#1090
  ClientHeight = 143
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 16
    Top = 40
    Width = 108
    Height = 13
    Caption = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072' : '
  end
  object Bevel1: TBevel
    Left = 5
    Top = 6
    Width = 246
    Height = 133
    Shape = bsFrame
  end
  object btnOk: TButton
    Left = 32
    Top = 98
    Width = 73
    Height = 25
    Caption = '&'#1054#1050
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 144
    Top = 98
    Width = 73
    Height = 25
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object dbeForcount: TDBEdit
    Left = 130
    Top = 37
    Width = 97
    Height = 21
    DataField = 'Forcount'
    DataSource = DM.dsClients
    TabOrder = 0
  end
end
