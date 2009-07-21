inherited MyServerControlEditorForm: TMyServerControlEditorForm
  Left = 366
  Top = 221
  Caption = 'MyServerControl Editor'
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    ActivePage = shTables
    object shTables: TTabSheet
      Caption = 'Tables'
      object DBGridTables: TDBGrid
        Left = 0
        Top = 137
        Width = 481
        Height = 92
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Pitch = fpVariable
        TitleFont.Style = []
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 137
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 20
          Width = 63
          Height = 13
          Caption = 'Table Names'
        end
        object Shape1: TShape
          Left = 91
          Top = 49
          Width = 1
          Height = 80
        end
        object Shape2: TShape
          Left = 265
          Top = 49
          Width = 1
          Height = 80
        end
        object cbTableNames: TComboBox
          Left = 80
          Top = 16
          Width = 393
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 16
          ItemHeight = 13
          TabOrder = 0
          OnDropDown = cbTableNamesDropDown
          OnExit = cbTableNamesExit
        end
        object btAnalyze: TBitBtn
          Left = 8
          Top = 48
          Width = 75
          Height = 25
          Caption = 'Analyze'
          TabOrder = 1
          OnClick = btAnalyzeClick
        end
        object btOptimize: TBitBtn
          Left = 8
          Top = 80
          Width = 75
          Height = 25
          Caption = 'Optimize'
          TabOrder = 2
          OnClick = btOptimizeClick
        end
        object btCheck: TBitBtn
          Left = 182
          Top = 48
          Width = 75
          Height = 25
          Caption = 'Check'
          TabOrder = 8
          OnClick = btCheckClick
        end
        object cbQuick: TCheckBox
          Left = 273
          Top = 48
          Width = 75
          Height = 17
          Caption = 'Quick'
          TabOrder = 9
        end
        object cbUseFrm: TCheckBox
          Left = 273
          Top = 80
          Width = 75
          Height = 17
          Caption = 'Use Frm'
          TabOrder = 11
        end
        object cbExtended: TCheckBox
          Left = 273
          Top = 64
          Width = 75
          Height = 17
          Caption = 'Extended'
          TabOrder = 10
        end
        object btRepair: TBitBtn
          Left = 356
          Top = 48
          Width = 75
          Height = 25
          Caption = 'Repair'
          TabOrder = 12
          OnClick = btRepairClick
        end
        object cbCheckQuick: TCheckBox
          Left = 99
          Top = 48
          Width = 75
          Height = 17
          Caption = 'Quick'
          TabOrder = 3
        end
        object cbCheckFast: TCheckBox
          Left = 99
          Top = 64
          Width = 75
          Height = 17
          Caption = 'Fast'
          TabOrder = 4
        end
        object cbCheckChanged: TCheckBox
          Left = 99
          Top = 80
          Width = 75
          Height = 17
          Caption = 'Changed'
          TabOrder = 5
        end
        object cbCheckMedium: TCheckBox
          Left = 99
          Top = 96
          Width = 75
          Height = 17
          Caption = 'Medium'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object cbCheckExtended: TCheckBox
          Left = 99
          Top = 112
          Width = 75
          Height = 17
          Caption = 'Extended'
          TabOrder = 7
        end
      end
    end
    object shStatus: TTabSheet
      Caption = 'Server Status'
      ImageIndex = 1
      object DBGridStatus: TDBGrid
        Left = 0
        Top = 41
        Width = 481
        Height = 188
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Pitch = fpVariable
        TitleFont.Style = []
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btRefreshStatus: TBitBtn
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = btRefreshPLClick
        end
      end
    end
    object shVariables: TTabSheet
      Caption = 'Server Variables'
      ImageIndex = 2
      object DBGridVariables: TDBGrid
        Left = 0
        Top = 41
        Width = 481
        Height = 188
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Pitch = fpVariable
        TitleFont.Style = []
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btRefreshVar: TBitBtn
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = btRefreshPLClick
        end
      end
    end
    object shProcessList: TTabSheet
      Caption = 'Process List'
      ImageIndex = 3
      object DBGridProcessList: TDBGrid
        Left = 0
        Top = 41
        Width = 481
        Height = 188
        Align = alClient
        DataSource = DataSource
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Pitch = fpVariable
        TitleFont.Style = []
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object cbFullProcessList: TCheckBox
          Left = 91
          Top = 12
          Width = 75
          Height = 17
          Caption = 'Full'
          TabOrder = 1
          OnClick = cbFullProcessListClick
        end
        object btKill: TBitBtn
          Left = 396
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Kill'
          TabOrder = 2
          OnClick = btKillClick
        end
        object btRefreshPL: TBitBtn
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = btRefreshPLClick
        end
      end
    end
  end
  object DataSource: TDataSource
    Left = 320
    Top = 8
  end
end
