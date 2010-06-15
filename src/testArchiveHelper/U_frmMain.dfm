object frmMain: TfrmMain
  Left = 195
  Top = 240
  Width = 1142
  Height = 656
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbOpen: TSpeedButton
    Left = 16
    Top = 16
    Width = 57
    Height = 22
    OnClick = sbOpenClick
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files|*.*'
    Left = 128
    Top = 24
  end
end
