object GetMailForm: TGetMailForm
  Left = 254
  Top = 195
  Width = 689
  Height = 458
  Caption = 'Доставка почты'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 109
    Height = 13
    Caption = 'Полученные письма :'
  end
  object Label2: TLabel
    Left = 0
    Top = 200
    Width = 110
    Height = 13
    Caption = 'Содержание письма :'
  end
  object chbLetters: TRxCheckListBox
    Left = 0
    Top = 16
    Width = 681
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnClick = chbLettersClick
    InternalVersion = 202
  end
  object reLetter: TRxRichEdit
    Left = 0
    Top = 216
    Width = 681
    Height = 193
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
  object btnGetMail: TButton
    Left = 568
    Top = 168
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Доставить почту'
    TabOrder = 2
    OnClick = btnGetMailClick
  end
  object chbDeleteLetters: TCheckBox
    Left = 8
    Top = 168
    Width = 249
    Height = 17
    Caption = 'Удалять письма с сервера при получении'
    TabOrder = 3
  end
  object sbMailInfo: TStatusBar
    Left = 0
    Top = 412
    Width = 681
    Height = 19
    Panels = <>
    SimplePanel = False
  end
end
