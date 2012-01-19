inherited DescriptionForm: TDescriptionForm
  Left = 312
  Top = 242
  Width = 700
  Height = 500
  ActiveControl = RxRichEdit
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  Position = poDesktopCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pButton: TPanel
    Left = 0
    Top = 421
    Width = 684
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOk: TButton
      Left = 308
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object RxRichEdit: TRxRichEdit
    Left = 0
    Top = 0
    Width = 684
    Height = 421
    Align = alClient
    TabOrder = 1
  end
end
