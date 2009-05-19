object frmColumns: TfrmColumns
  Left = 565
  Top = 194
  ActiveControl = clbColumns
  BorderStyle = bsDialog
  Caption = #1057#1090#1086#1083#1073#1094#1099
  ClientHeight = 288
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 11
    Width = 302
    Height = 39
    Caption = 
      #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1086#1083#1073#1094#1099', '#1082#1086#1090#1086#1088#1099#1077' '#1073#1099' '#1074#1099' '#1093#1086#1090#1077#1083#1080' '#1074#1080#1076#1077#1090#1100' '#1074#13#10#1076#1072#1085#1085#1086#1084' '#1087#1088#1077#1076#1089#1090#1072#1074 +
      #1083#1077#1085#1080#1080'. '#1050#1085#1086#1087#1082#1072#1084#1080' "'#1042#1085#1080#1079'" '#1080' "'#1042#1074#1077#1088#1093'" '#1084#1086#1078#1085#1086#13#10#1079#1072#1076#1072#1090#1100' '#1087#1086#1088#1103#1076#1086#1082' '#1089#1083#1077#1076#1086#1074#1072#1085#1080 +
      #1103' '#1089#1090#1086#1083#1073#1094#1086#1074
  end
  object Bevel1: TBevel
    Left = 12
    Top = 239
    Width = 299
    Height = 2
    Shape = bsBottomLine
  end
  object Label2: TLabel
    Left = 12
    Top = 213
    Width = 156
    Height = 13
    Caption = #1064#1080#1088#1080#1085#1072' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1075#1086' '#1089#1090#1086#1083#1073#1094#1072':'
  end
  object Label3: TLabel
    Left = 226
    Top = 213
    Width = 27
    Height = 13
    Caption = #1087#1080#1082#1089'.'
  end
  object clbColumns: TCheckListBox
    Left = 11
    Top = 62
    Width = 219
    Height = 133
    ItemHeight = 13
    TabOrder = 0
    OnClick = clbColumnsClick
    OnEnter = clbColumnsEnter
  end
  object btnOK: TButton
    Left = 153
    Top = 252
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 252
    Width = 75
    Height = 23
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnUp: TButton
    Left = 240
    Top = 62
    Width = 75
    Height = 23
    Caption = #1042#1074#1077#1088#1093
    TabOrder = 3
    OnClick = btnUpClick
  end
  object BtnDown: TButton
    Left = 240
    Top = 89
    Width = 75
    Height = 23
    Caption = #1042#1085#1080#1079
    TabOrder = 4
    OnClick = BtnDownClick
  end
  object btnShow: TButton
    Left = 241
    Top = 117
    Width = 75
    Height = 23
    Caption = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100
    TabOrder = 5
    OnClick = btnShowClick
  end
  object btnHide: TButton
    Left = 241
    Top = 144
    Width = 75
    Height = 23
    Caption = #1057#1082#1088#1099#1090#1100
    TabOrder = 6
    OnClick = btnHideClick
  end
  object edWidth: TEdit
    Left = 174
    Top = 208
    Width = 46
    Height = 24
    AutoSize = False
    TabOrder = 7
    Text = 'edWidth'
    OnExit = edWidthExit
  end
end
