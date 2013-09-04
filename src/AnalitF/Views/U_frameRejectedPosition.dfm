object frameRejectedPosition: TframeRejectedPosition
  Left = 0
  Top = 0
  Width = 578
  Height = 110
  TabOrder = 0
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 110
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      578
      110)
    object dbtLetterDate: TDBText
      Left = 283
      Top = 60
      Width = 79
      Height = 13
      AutoSize = True
      DataField = 'LetterDate'
      DataSource = dsDefectives
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
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtLetterNumber: TDBText
      Left = 108
      Top = 60
      Width = 94
      Height = 13
      DataField = 'LetterNumber'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 256
      Top = 60
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
      Top = 60
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
      Top = 6
      Width = 45
      Height = 13
      Caption = #1057#1077#1088#1080#1103' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 524
      Top = 8
      Width = 47
      Height = 13
      Cursor = crHandPoint
      Caption = #1057#1074#1077#1088#1085#1091#1090#1100
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      OnClick = Label1Click
    end
    object Label5: TLabel
      Left = 58
      Top = 24
      Width = 45
      Height = 13
      Caption = #1058#1086#1074#1072#1088' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtName: TDBText
      Left = 108
      Top = 24
      Width = 51
      Height = 13
      AutoSize = True
      DataField = 'Name'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 11
      Top = 42
      Width = 92
      Height = 13
      Caption = #1048#1079#1075#1086#1090#1086#1074#1080#1090#1077#1083#1100' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbtProducer: TDBText
      Left = 108
      Top = 42
      Width = 70
      Height = 13
      AutoSize = True
      DataField = 'Producer'
      DataSource = dsDefectives
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dbmReason: TDBMemo
      Left = 8
      Top = 78
      Width = 564
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      DataField = 'REASON'
      DataSource = dsDefectives
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
  object dsDefectives: TDataSource
    DataSet = adsDefectives
    Left = 307
    Top = 13
  end
  object adsDefectives: TMyQuery
    SQLUpdate.Strings = (
      'UPDATE Rejects'
      'SET '
      '    CHECKPRINT = :CHECKPRINT'
      'WHERE'
      '    ID = :OLD_ID')
    SQLRefresh.Strings = (
      'SELECT '
      '  Rejects.Id,'
      '  Rejects.Name,'
      '  Rejects.Producer,'
      '  Rejects.Series,'
      '  Rejects.LETTERNUMBER,'
      '  Rejects.LETTERDATE,'
      '  Rejects.REASON,'
      '  Rejects.CHECKPRINT '
      'FROM Rejects'
      'WHERE'
      '(Rejects.ID = :OLD_ID)')
    Connection = DM.MyConnection
    SQL.Strings = (
      'SELECT '
      '  Rejects.Id,'
      '  Rejects.Name,'
      '  Rejects.Producer,'
      '  Rejects.Series,'
      '  Rejects.LETTERNUMBER,'
      '  Rejects.LETTERDATE,'
      '  Rejects.REASON,'
      '  Rejects.CHECKPRINT'
      'FROM Rejects'
      'WHERE '
      'Rejects.Id = :RejectId')
    RefreshOptions = [roAfterUpdate]
    Left = 269
    Top = 10
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'RejectId'
      end>
  end
end
