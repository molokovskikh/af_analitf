inherited AddAwaitedProducts: TAddAwaitedProducts
  Width = 459
  Height = 203
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1086#1078#1080#1076#1072#1077#1084#1086#1081' '#1087#1086#1079#1080#1094#1080#1080
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbAdd: TGroupBox
    Left = 0
    Top = 0
    Width = 443
    Height = 113
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 8
      Width = 76
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
    end
    object Label2: TLabel
      Left = 5
      Top = 56
      Width = 79
      Height = 13
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
    end
    object cbCatalogs: TComboBox
      Left = 3
      Top = 24
      Width = 432
      Height = 21
      AutoDropDown = True
      ItemHeight = 13
      TabOrder = 0
      OnKeyPress = cbCatalogsKeyPress
    end
    object cbProducers: TComboBox
      Left = 3
      Top = 72
      Width = 432
      Height = 21
      AutoDropDown = True
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = #1042#1089#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      OnKeyPress = cbProducersKeyPress
      Items.Strings = (
        #1042#1089#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080)
    end
  end
  object btnOk: TButton
    Left = 8
    Top = 129
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 88
    Top = 129
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object adsCatalogs: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'Catalogs.FullCode,'
      'concat(catalogs.name, '#39' '#39', catalogs.form) as CatalogName'
      'from'
      '  Catalogs'
      'where'
      '  concat(catalogs.name, '#39' '#39', catalogs.form) like :LikeParam'
      'order by CatalogName')
    Left = 168
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end>
  end
  object tmrUpdateCatalog: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tmrUpdateCatalogTimer
    Left = 200
    Top = 128
  end
  object adsProducers: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'Producers.Id,'
      'Producers.Name'
      'from'
      '  Producers'
      'where'
      '  Name like :LikeParam'
      'order by Name')
    Left = 208
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LikeParam'
      end>
  end
  object tmrUpdateProducers: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tmrUpdateProducersTimer
    Left = 240
    Top = 128
  end
end
