object NewMailMsgForm: TNewMailMsgForm
  Left = 227
  Top = 150
  Width = 694
  Height = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    686
    445)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 32
    Height = 13
    Caption = #1050#1086#1084#1091' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 0
    Top = 40
    Width = 33
    Height = 13
    Caption = #1058#1077#1084#1072' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 0
    Top = 72
    Width = 57
    Height = 13
    Caption = #1042#1083#1086#1078#1077#1085#1080#1103' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 0
    Top = 120
    Width = 36
    Height = 13
    Caption = #1058#1077#1082#1089#1090' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object edSubject: TEdit
    Left = 64
    Top = 40
    Width = 615
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object lbAttachments: TListBox
    Left = 64
    Top = 72
    Width = 615
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
  end
  object meLetterBody: TMemo
    Left = 0
    Top = 144
    Width = 679
    Height = 264
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
  end
  object btnSaveLetter: TButton
    Left = 8
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
    TabOrder = 3
    OnClick = btnSaveLetterClick
  end
  object btnCancel: TButton
    Left = 86
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnDelAtt: TButton
    Left = 606
    Top = 112
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = btnDelAttClick
  end
  object btnAddAttachment: TBitBtn
    Left = 512
    Top = 112
    Width = 91
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100'...'
    TabOrder = 6
    OnClick = btnAddAttachmentClick
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00666666666666
      6666660000006666667000766666660000006666670666076666660000006666
      6066666066666600000066666067076066666600000066666060606066666600
      0000666660606060666666000000666660606060666666000000666660606060
      6666660000006666606060606666660000006666606060606666660000006666
      6060606066666600000066666060606066666600000066666660666066666600
      0000666666606660666666000000666666606660666666000000666666660006
      666666000000666666666666666666000000}
  end
  object cbTo: TComboBox
    Left = 64
    Top = 8
    Width = 617
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 7
    OnExit = cbToExit
  end
  object odAttachments: TOpenDialog
    Options = [ofEnableSizing]
    Title = #1060#1072#1081#1083' '#1074#1083#1086#1078#1077#1085#1080#1103
    Left = 208
    Top = 352
  end
  object Msg: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    ContentType = 'text/plain'
    Encoding = meMIME
    Recipients = <>
    ReplyTo = <>
    Left = 296
    Top = 352
  end
end
