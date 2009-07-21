inherited MasterDetailFrame: TMasterDetailFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 170
    Width = 443
    Height = 1
    Cursor = crVSplit
    Align = alTop
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 26
    Width = 443
    Height = 120
    Align = alTop
    DataSource = dsMaster
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 530
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btClose: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Close'
        Flat = True
        Transparent = False
        OnClick = btCloseClick
      end
      object btOpen: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Open'
        Flat = True
        Transparent = False
        OnClick = btOpenClick
      end
      object Panel5: TPanel
        Left = 167
        Top = 1
        Width = 220
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator: TDBNavigator
          Left = 0
          Top = 0
          Width = 220
          Height = 22
          DataSource = dsMaster
          Flat = True
          TabOrder = 0
        end
      end
      object Panel4: TPanel
        Left = 388
        Top = 1
        Width = 141
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object cbLocalMasterDetail: TCheckBox
          Left = 5
          Top = 3
          Width = 132
          Height = 17
          Caption = 'Use LocaMasterDetail'
          TabOrder = 0
          OnClick = cbLocalMasterDetailClick
        end
      end
    end
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 146
    Width = 443
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 650
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object Panel7: TPanel
        Left = 1
        Top = 1
        Width = 240
        Height = 22
        BevelOuter = bvNone
        TabOrder = 0
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 240
          Height = 22
          DataSource = dsDetail
          Flat = True
          TabOrder = 0
        end
      end
      object Panel3: TPanel
        Left = 242
        Top = 1
        Width = 289
        Height = 22
        BevelOuter = bvNone
        TabOrder = 1
        object rbSQL: TRadioButton
          Left = 5
          Top = 4
          Width = 63
          Height = 17
          Caption = 'SQL link'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbClick
        end
        object rbSimpleFields: TRadioButton
          Left = 75
          Top = 4
          Width = 97
          Height = 17
          Caption = 'Simple field link'
          TabOrder = 1
          OnClick = rbClick
        end
        object rbCalcFields: TRadioButton
          Left = 175
          Top = 4
          Width = 113
          Height = 17
          Caption = 'Calculated field link'
          TabOrder = 2
          OnClick = rbClick
        end
      end
      object Panel6: TPanel
        Left = 532
        Top = 1
        Width = 117
        Height = 22
        BevelOuter = bvNone
        TabOrder = 2
        object cbCacheCalcFields: TCheckBox
          Left = 5
          Top = 3
          Width = 108
          Height = 17
          Caption = 'CacheCalcFields'
          Enabled = False
          TabOrder = 0
          OnClick = cbCacheCalcFieldsClick
        end
      end
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 171
    Width = 443
    Height = 106
    Align = alClient
    DataSource = dsDetail
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object quMaster: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM DEPT')
    OnCalcFields = quCalcFields
    Left = 96
    Top = 24
    object quMasterDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
    end
    object quMasterDNAME: TStringField
      FieldName = 'DNAME'
      Size = 14
    end
    object quMasterLOC: TStringField
      FieldName = 'LOC'
      Size = 13
    end
    object quMasterDEPTNO_CALCULATE: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'DEPTNO_CALCULATED'
      Calculated = True
    end
  end
  object quDetail: TMyQuery
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM EMP'
      'WHERE DEPTNO = :DEPTNO')
    OnCalcFields = quCalcFields
    MasterSource = dsMaster
    Left = 96
    Top = 208
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DEPTNO'
      end>
    object quDetailEMPNO: TIntegerField
      FieldName = 'EMPNO'
    end
    object quDetailENAME: TStringField
      FieldName = 'ENAME'
      Size = 10
    end
    object quDetailJOB: TStringField
      FieldName = 'JOB'
      Size = 9
    end
    object quDetailMGR: TIntegerField
      FieldName = 'MGR'
    end
    object quDetailHIREDATE: TDateTimeField
      FieldName = 'HIREDATE'
    end
    object quDetailSAL: TFloatField
      FieldName = 'SAL'
    end
    object quDetailCOMM: TFloatField
      FieldName = 'COMM'
    end
    object quDetailDEPTNO: TIntegerField
      FieldName = 'DEPTNO'
    end
    object quDetailDEPTNO_CALCULATED: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'DEPTNO_CALCULATED'
      Calculated = True
    end
  end
  object dsDetail: TDataSource
    DataSet = quDetail
    Left = 128
    Top = 208
  end
  object dsMaster: TDataSource
    DataSet = quMaster
    Left = 128
    Top = 24
  end
end
