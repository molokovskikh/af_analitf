object XMLFrame: TXMLFrame
  Left = 0
  Top = 0
  Width = 358
  Height = 344
  TabOrder = 0
  object tvXML: TTreeView
    Left = 0
    Top = 0
    Width = 217
    Height = 255
    Align = alLeft
    Indent = 19
    TabOrder = 0
    OnClick = tvXMLClick
  end
  object mValue: TMemo
    Left = 0
    Top = 255
    Width = 358
    Height = 89
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object lbAttributes: TListBox
    Left = 217
    Top = 0
    Width = 141
    Height = 255
    Align = alClient
    ItemHeight = 13
    TabOrder = 2
    OnClick = lbAttributesClick
  end
end
