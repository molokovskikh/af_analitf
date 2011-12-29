inherited MiniMailForm: TMiniMailForm
  Caption = #1052#1080#1085#1080'-'#1087#1086#1095#1090#1072
  KeyPreview = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 255
    Width = 635
    Height = 41
    Align = alBottom
    TabOrder = 0
    object spbClose: TSpeedButton
      Left = 16
      Top = 8
      Width = 81
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = spbCloseClick
    end
  end
end
