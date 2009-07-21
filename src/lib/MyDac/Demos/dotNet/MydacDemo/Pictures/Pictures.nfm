inherited PicturesFrame: TPicturesFrame
  Width = 443
  Height = 277
  Align = alClient
  object Splitter1: TSplitter
    Left = 0
    Top = 153
    Width = 443
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 181
    Width = 443
    Height = 96
    Align = alClient
    TabOrder = 3
    object DBImage: TDBImage
      Left = 0
      Top = 0
      Width = 439
      Height = 92
      Align = alClient
      Center = False
      DataField = 'Picture'
      DataSource = dsPictures
      TabOrder = 0
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 26
    Width = 443
    Height = 127
    Align = alTop
    DataSource = dsPictures
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete]
    TabOrder = 0
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
    TabOrder = 1
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 388
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
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
      object Panel3: TPanel
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
          DataSource = dsPictures
          Flat = True
          TabOrder = 0
        end
      end
    end
  end
  object ToolBar1: TPanel
    Left = 0
    Top = 155
    Width = 443
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Panel2: TPanel
      Left = 2
      Top = 1
      Width = 250
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btClear: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Clear'
        Flat = True
        Transparent = False
        OnClick = btClearClick
      end
      object btSave: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Save to file ...'
        Flat = True
        Transparent = False
        OnClick = btSaveClick
      end
      object btLoad: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Load from file ...'
        Flat = True
        Transparent = False
        OnClick = btLoadClick
      end
    end
  end
  object dsPictures: TDataSource
    DataSet = quPictures
    OnStateChange = dsPicturesStateChange
    Left = 361
    Top = 28
  end
  object quPictures: TMyQuery
    SQLInsert.Strings = (
      'INSERT INTO MYDAC_Pictures'
      '  (MYDAC_Pictures.Name, MYDAC_Pictures.Picture)'
      'VALUES'
      '  (:Name, :Picture)')
    SQLDelete.Strings = (
      'DELETE FROM MYDAC_Pictures'
      'WHERE'
      '  UID = :Old_UID')
    SQLUpdate.Strings = (
      'UPDATE MYDAC_Pictures'
      'SET'
      '  Name = :Name, Picture = :Picture'
      'WHERE'
      '  UID = :Old_UID')
    SQLRefresh.Strings = (
      
        'SELECT MYDAC_Pictures.Name, MYDAC_Pictures.Picture FROM MYDAC_Pi' +
        'ctures'
      'WHERE'
      '  MYDAC_Pictures.UID = :Old_UID')
    Connection = MyDACForm.MyConnection
    SQL.Strings = (
      'SELECT * FROM MYDAC_Pictures')
    FetchRows = 1
    Left = 329
    Top = 28
  end
end
