inherited MyEmbConParamsEditorForm: TMyEmbConParamsEditorForm
  Left = 294
  Top = 203
  Height = 340
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  Caption = 'TMyEmbConnection.Params Editor'
  Constraints.MinHeight = 332
  Constraints.MinWidth = 512
  Font.Height = -11
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnPanel: TPanel
    Top = 265
    TabOrder = 1
  end
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 505
    Height = 265
    Align = alClient
    TabOrder = 0
    OnChange = MemoChange
  end
end
