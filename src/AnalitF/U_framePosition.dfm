object framePosition: TframePosition
  Left = 0
  Top = 0
  Width = 891
  Height = 69
  TabOrder = 0
  OnResize = FrameResize
  object gbPosition: TGroupBox
    Left = 0
    Top = 0
    Width = 891
    Height = 69
    Align = alClient
    TabOrder = 0
    object lSynonymName: TLabel
      Left = 8
      Top = 16
      Width = 51
      Height = 13
      Caption = #1042#1099#1073#1088#1072#1085#1086': '
    end
    object lMNN: TLabel
      Left = 8
      Top = 40
      Width = 51
      Height = 13
      Caption = #1042#1099#1073#1088#1072#1085#1086': '
    end
    object dbtSynonymName: TDBText
      Left = 72
      Top = 16
      Width = 65
      Height = 17
    end
    object dbtMNN: TDBText
      Left = 72
      Top = 40
      Width = 65
      Height = 17
    end
    object btnShowDescription: TRxSpeedButton
      Left = 280
      Top = 24
      Width = 81
      Height = 22
      OnClick = btnShowDescriptionClick
    end
    object lVitallyImportant: TLabel
      Left = 424
      Top = 32
      Width = 91
      Height = 13
      Caption = 'lVitallyImportant'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lMandatoryList: TLabel
      Left = 544
      Top = 32
      Width = 83
      Height = 13
      Caption = 'lMandatoryList'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
