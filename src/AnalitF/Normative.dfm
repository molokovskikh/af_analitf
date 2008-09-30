object NormativeForm: TNormativeForm
  Left = 253
  Top = 207
  Width = 641
  Height = 476
  ActiveControl = RichEdit
  Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit: TRichEdit
    Left = 0
    Top = 0
    Width = 633
    Height = 442
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnKeyPress = FormKeyPress
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 272
    Top = 128
  end
  object PopupMenu: TPopupMenu
    Left = 192
    Top = 128
    object itmFont: TMenuItem
      Caption = #1064#1088#1080#1092#1090
      Default = True
      OnClick = itmFontClick
    end
  end
end
