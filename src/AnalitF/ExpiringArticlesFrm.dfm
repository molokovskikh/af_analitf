inherited ExpiringArticlesForm: TExpiringArticlesForm
  Left = 230
  Top = 241
  Caption = ''
  ClientHeight = 445
  ClientWidth = 677
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dbgExpiringArticles: TADBGrid
    Left = 0
    Top = 0
    Width = 677
    Height = 445
    Align = alClient
    DataSource = dsExpriringArticles
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    IniStorage = fpExpiringArticles
    InputColumnName = 'Order'
    FindColumnName = 's1'
    Columns = <
      item
        Expanded = False
        FieldName = 'WaresId'
        Title.Caption = #1050#1086#1076
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 's1'
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1086' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Width = 227
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Width = 79
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'comments'
        Title.Caption = #1055#1088#1080#1084'.'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ExpDate'
        Title.Caption = #1057#1088#1086#1082
        Width = 49
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FullName'
        Title.Caption = #1060#1080#1088#1084#1072'-'#1087#1086#1089#1090#1072#1074#1097#1080#1082
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PriceDate'
        Title.Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089#1072
        Width = 72
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PriceFor'
        Title.Caption = #1062#1077#1085#1072
        Width = 43
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PriceRet'
        Title.Caption = #1056#1086#1079#1085#1080#1094#1072
        Width = 51
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Quantity'
        Title.Caption = #1050#1086#1083'.'
        Width = 29
        Visible = True
      end
      item
        Color = $00FFF8EE
        Expanded = False
        FieldName = 'Order'
        Title.Caption = #1047#1072#1082#1072#1079
        Width = 39
        Visible = True
      end
      item
        Color = $00FFF8EE
        Expanded = False
        FieldName = 'SumOrder'
        Title.Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
        Visible = True
      end>
  end
  object adsExpiringArticles: TADODataSet
    Connection = DM.MainConnection
    OnCalcFields = adsExpiringArticlesCalcFields
    CommandText = 
      'SELECT'#13#10'Wares.Id, Wares.FirmsId, Wares.FirmId, Wares.s1, s2.name' +
      ', Wares.comments, wares.ExpDate, Firms.FullName, Firms.PriceDate' +
      ', Wares.Price, Prices.PriceFor, Wares.Quantity, Prices.ClientsId' +
      ', Prices.WaresId, Prices.Order'#13#10'FROM Wares, s2, Firms, Prices'#13#10'W' +
      'HERE (s2.Id=Wares.s2Id)AND'#13#10'(Firms.Id=Wares.FirmsId)AND'#13#10'(Prices' +
      '.WaresId=Wares.Id)AND'#13#10'(Prices.ClientsId=ClientId)AND'#13#10'(Wares.Ex' +
      'piring=True)'
    Parameters = <
      item
        Name = 'ClientId'
        DataType = ftInteger
        Value = 0
      end>
    Prepared = True
    Left = 624
    Top = 368
    object adsExpiringArticlesFirmId: TWideStringField
      FieldName = 'FirmId'
      Size = 10
    end
    object adsExpiringArticless1: TWideStringField
      FieldName = 's1'
      Size = 60
    end
    object adsExpiringArticlesname: TWideStringField
      FieldName = 'name'
      Size = 30
    end
    object adsExpiringArticlescomments: TWideStringField
      FieldName = 'comments'
      Size = 30
    end
    object adsExpiringArticlesExpDate: TDateTimeField
      FieldName = 'ExpDate'
    end
    object adsExpiringArticlesFullName: TWideStringField
      FieldName = 'FullName'
      Size = 40
    end
    object adsExpiringArticlesPriceDate: TDateTimeField
      FieldName = 'PriceDate'
    end
    object adsExpiringArticlesPriceFor: TBCDField
      FieldName = 'PriceFor'
      Precision = 19
    end
    object adsExpiringArticlesPriceRet: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PriceRet'
      Calculated = True
    end
    object adsExpiringArticlesQuantity: TWideStringField
      FieldName = 'Quantity'
      Size = 8
    end
    object adsExpiringArticlesOrder: TIntegerField
      FieldName = 'Order'
    end
    object adsExpiringArticlesSumOrder: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'SumOrder'
      Calculated = True
    end
    object adsExpiringArticlesFirmsId: TSmallintField
      FieldName = 'FirmsId'
    end
    object adsExpiringArticlesPrice: TBCDField
      FieldName = 'Price'
      Precision = 19
    end
    object adsExpiringArticlesId: TAutoIncField
      FieldName = 'Id'
      ReadOnly = True
    end
    object adsExpiringArticlesClientsId: TSmallintField
      FieldName = 'ClientsId'
    end
    object adsExpiringArticlesWaresId: TIntegerField
      FieldName = 'WaresId'
    end
  end
  object dsExpriringArticles: TDataSource
    DataSet = adsExpiringArticles
    Left = 624
    Top = 320
  end
  object fpExpiringArticles: TFormPlacement
    Options = []
    Left = 448
    Top = 384
  end
end
