inherited AwaitedProductsForm: TAwaitedProductsForm
  Left = 330
  Top = 201
  ActiveControl = dbgAwaitedProducts
  Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 475
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object pButtons: TPanel [0]
    Left = 0
    Top = 0
    Width = 684
    Height = 41
    Align = alTop
    TabOrder = 0
    object sbAdd: TSpeedButton
      Left = 8
      Top = 8
      Width = 105
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    end
    object sbTest: TSpeedButton
      Left = 320
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Test'
      OnClick = sbTestClick
    end
    object sbDelete: TSpeedButton
      Left = 136
      Top = 8
      Width = 105
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = sbDeleteClick
    end
  end
  object dbgAwaitedProducts: TToughDBGrid [1]
    Tag = 16
    Left = 0
    Top = 41
    Width = 684
    Height = 434
    Align = alClient
    AutoFitColWidths = True
    DataSource = dsAwaitedProducts
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight]
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnKeyDown = dbgAwaitedProductsKeyDown
    SearchPosition = spBottom
    Columns = <
      item
        EditButtons = <>
        FieldName = 'CatalogName'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 459
      end
      item
        EditButtons = <>
        FieldName = 'ProducerName'
        Footers = <>
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Width = 200
      end>
  end
  object adsAwaitedProducts: TMyQuery
    SQLDelete.Strings = (
      'delete from awaitedproducts where Id = :OLD_id')
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      '  AwaitedProducts.Id,'
      '  AwaitedProducts.CatalogId,'
      '  AwaitedProducts.ProducerId,'
      '  concat(catalogs.name, '#39' '#39', catalogs.form) as CatalogName,'
      '  Producers.Name as ProducerName'
      'from'
      '  AwaitedProducts'
      '  inner join CATALOGS on '
      '    CATALOGS.FullCode = AwaitedProducts.CatalogId'
      '  left join Producers on '
      '    Producers.Id = AwaitedProducts.ProducerId'
      'order by CatalogName, ProducerName')
    Left = 80
    Top = 104
    object adsAwaitedProductsId: TLargeintField
      FieldName = 'Id'
    end
    object adsAwaitedProductsCatalogId: TLargeintField
      FieldName = 'CatalogId'
    end
    object adsAwaitedProductsProducerId: TLargeintField
      FieldName = 'ProducerId'
    end
    object adsAwaitedProductsCatalogName: TStringField
      FieldName = 'CatalogName'
      Size = 255
    end
    object adsAwaitedProductsProducerName: TStringField
      FieldName = 'ProducerName'
      Size = 255
    end
  end
  object dsAwaitedProducts: TDataSource
    DataSet = adsAwaitedProducts
    Left = 128
    Top = 104
  end
end
