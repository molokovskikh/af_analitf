object frameRejectedPosition: TframeRejectedPosition
  Left = 0
  Top = 0
  Width = 578
  Height = 83
  TabOrder = 0
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 83
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      578
      83)
    object dbtLetterDate: TDBText
      Left = 283
      Top = 22
      Width = 79
      Height = 13
      AutoSize = True
      DataField = 'LetterDate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtSeries: TDBText
      Left = 108
      Top = 6
      Width = 54
      Height = 13
      AutoSize = True
      DataField = 'Series'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtLetterNumber: TDBText
      Left = 108
      Top = 22
      Width = 94
      Height = 13
      DataField = 'LetterNumber'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 256
      Top = 22
      Width = 18
      Height = 13
      Caption = #1086#1090' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 22
      Width = 96
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1087#1080#1089#1100#1084#1072' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 58
      Top = 12
      Width = 45
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1057#1077#1088#1080#1103' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbmReason: TDBMemo
      Left = 8
      Top = 40
      Width = 564
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      DataField = 'REASON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
