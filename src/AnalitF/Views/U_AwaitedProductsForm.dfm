inherited AwaitedProductsForm: TAwaitedProductsForm
  Left = 330
  Top = 201
  ActiveControl = dbgAwaitedProducts
  Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 475
  OnHide = FormHide
  OnResize = FormResize
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
      OnClick = sbAddClick
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
  object pBottom: TPanel [1]
    Left = 0
    Top = 280
    Width = 684
    Height = 195
    Align = alBottom
    TabOrder = 1
    object pPreviousOrders: TPanel
      Left = 1
      Top = 80
      Width = 682
      Height = 114
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object gbPrevOrders: TGroupBox
        Left = 0
        Top = 0
        Width = 480
        Height = 114
        Align = alLeft
        Caption = ' '#1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1079#1072#1082#1072#1079#1099' '
        Constraints.MinWidth = 480
        TabOrder = 0
        DesignSize = (
          480
          114)
        object dbgHistory: TToughDBGrid
          Left = 8
          Top = 16
          Width = 463
          Height = 87
          Anchors = [akLeft, akTop, akRight]
          AutoFitColWidths = True
          DataSource = dsPreviosOrders
          Flat = True
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          SearchPosition = spBottom
          Columns = <
            item
              EditButtons = <>
              FieldName = 'PriceName'
              Footers = <>
              Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
              Width = 110
            end
            item
              EditButtons = <>
              FieldName = 'SynonymFirm'
              Footers = <>
              Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
              Width = 102
            end
            item
              EditButtons = <>
              FieldName = 'Period'
              Footers = <>
              Title.Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'.'
            end
            item
              EditButtons = <>
              FieldName = 'OrderCount'
              Footers = <>
              Title.Caption = #1047#1072#1082#1072#1079
              Width = 38
            end
            item
              EditButtons = <>
              FieldName = 'Price'
              Footers = <>
              Title.Caption = #1062#1077#1085#1072
              Width = 49
            end
            item
              Alignment = taCenter
              DisplayFormat = 'dd.mm.yyyy'
              EditButtons = <>
              FieldName = 'OrderDate'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072
              Width = 68
            end>
        end
      end
      object gbFirmInfo: TGroupBox
        Left = 480
        Top = 0
        Width = 202
        Height = 114
        Align = alClient
        Caption = ' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1077' '
        TabOrder = 1
        DesignSize = (
          202
          114)
        object lblSupportPhone: TLabel
          Left = 6
          Top = 16
          Width = 61
          Height = 13
          Caption = #1058#1077#1083#1077#1092#1086#1085' :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbtSupportPhone: TDBText
          Left = 73
          Top = 16
          Width = 99
          Height = 13
          AutoSize = True
          DataField = 'SupportPhone'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbmContactInfo: TDBMemo
          Left = 6
          Top = 32
          Width = 215
          Height = 93
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          DataField = 'OperativeInfo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object pCore: TPanel
      Left = 1
      Top = 1
      Width = 682
      Height = 79
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object dbgCore: TToughDBGrid
        Tag = 16384
        Left = 0
        Top = 0
        Width = 682
        Height = 79
        Align = alClient
        AutoFitColWidths = True
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight]
        ParentShowHint = False
        ReadOnly = True
        ShowHint = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEnter = dbgCoreEnter
        OnExit = dbgCoreExit
        OnGetCellParams = dbgCoreGetCellParams
        OnKeyDown = dbgCoreKeyDown
        InputField = 'OrderCount'
        SearchPosition = spTop
        OnCanInput = dbgCoreCanInput
      end
    end
  end
  object pGrid: TPanel [2]
    Left = 0
    Top = 41
    Width = 684
    Height = 239
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object dbgAwaitedProducts: TToughDBGrid
      Tag = -1
      Left = 0
      Top = 0
      Width = 684
      Height = 239
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
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnEnter = dbgAwaitedProductsEnter
      OnExit = dbgAwaitedProductsExit
      OnGetCellParams = dbgAwaitedProductsGetCellParams
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
      '  ifnull(Producers.Name, '#39#1042#1089#1077' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080#39') as ProducerName,'
      '  CATALOGS.CoreExists,'
      '  CATALOGS.FullCode,'
      '  CATALOGS.DescriptionId,'
      '  catalogs.VitallyImportant as CatalogVitallyImportant,'
      '  catalogs.MandatoryList as CatalogMandatoryList,'
      '  Catalogs.MnnId'
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
    object adsAwaitedProductsCoreExists: TBooleanField
      FieldName = 'CoreExists'
    end
    object adsAwaitedProductsDescriptionId: TLargeintField
      FieldName = 'DescriptionId'
    end
    object adsAwaitedProductsMnnId: TLargeintField
      FieldName = 'MnnId'
    end
    object adsAwaitedProductsCatalogVitallyImportant: TBooleanField
      FieldName = 'CatalogVitallyImportant'
    end
    object adsAwaitedProductsCatalogMandatoryList: TBooleanField
      FieldName = 'CatalogMandatoryList'
    end
    object adsAwaitedProductsFullCode: TLargeintField
      FieldName = 'FullCode'
    end
  end
  object dsAwaitedProducts: TDataSource
    DataSet = adsAwaitedProducts
    Left = 128
    Top = 104
  end
  object shCore: TStrHolder
    Capacity = 118
    Macros = <>
    Left = 192
    Top = 80
    InternalVer = 1
    StrData = (
      ''
      '53454c45435420'
      '20202020436f72652e436f726549642c'
      '20202020436f72652e5072696365436f64652c'
      '20202020436f72652e526567696f6e436f64652c'
      '20202020436f72652e70726f6475637469642c'
      '20202020636174616c6f67732e66756c6c636f64652c'
      '20202020636174616c6f67732e73686f7274636f64652c'
      '20202020636174616c6f67732e4465736372697074696f6e49642c'
      
        '20202020636174616c6f67732e566974616c6c79496d706f7274616e74206173' +
        '20436174616c6f67566974616c6c79496d706f7274616e742c'
      '20202020636174616c6f67732e4d61726b75702c'
      '20202020436f72652e52657461696c566974616c6c79496d706f7274616e742c'
      
        '20202020636174616c6f67732e4d616e6461746f72794c697374206173204361' +
        '74616c6f674d616e6461746f72794c6973742c'
      
        '20202020636174616c6f67732e4e616d6550726f6d6f74696f6e73436f756e74' +
        '2c'
      '20202020436f72652e436f64654669726d43722c'
      '20202020436f72652e53796e6f6e796d436f64652c'
      '20202020436f72652e53796e6f6e796d4669726d4372436f64652c'
      '20202020436f72652e436f64652c'
      '20202020436f72652e436f646543722c'
      '20202020436f72652e506572696f642c'
      '20202020436f72652e566f6c756d652c'
      '20202020436f72652e4e6f74652c'
      '20202020436f72652e436f7374206173205265616c436f73742c'
      '2020696628646f702e4f7468657244656c6179206973206e756c6c2c'
      '202020202020436f72652e436f73742c'
      
        '202020202020696628436f72652e566974616c6c79496d706f7274616e74207c' +
        '7c2069666e756c6c28636174616c6f67732e566974616c6c79496d706f727461' +
        '6e742c2030292c'
      
        '202020202020202020206361737428436f72652e436f7374202a202831202b20' +
        '646f702e566974616c6c79496d706f7274616e7444656c61792f313030292061' +
        '7320646563696d616c2831382c203229292c'
      
        '202020202020202020206361737428436f72652e436f7374202a202831202b20' +
        '646f702e4f7468657244656c61792f3130302920617320646563696d616c2831' +
        '382c20322929'
      '2020202020202029'
      '202029'
      '202020202020617320436f73742c'
      '20202020436f72652e5175616e746974792c'
      '20202020436f72652e41776169742c'
      '20202020436f72652e4a756e6b2c'
      '20202020436f72652e646f632c'
      '20202020436f72652e7265676973747279636f73742c'
      '20202020436f72652e766974616c6c79696d706f7274616e742c'
      '20202020436f72652e72657175657374726174696f2c'
      '20202020636f72652e6f72646572636f73742c'
      '20202020636f72652e6d696e6f72646572636f756e742c'
      '20202020436f72652e50726f6475636572436f73742c'
      '20202020436f72652e4e44532c'
      '20202020636f72652e537570706c69657250726963654d61726b75702c'
      '20202020636f72652e427579696e674d6174726978547970652c'
      
        '2020202069666e756c6c2853796e6f6e796d732e53796e6f6e796d4e616d652c' +
        '20636f6e63617428636174616c6f67732e6e616d652c202720272c2063617461' +
        '6c6f67732e666f726d29292061732053796e6f6e796d4e616d652c'
      
        '2020202053796e6f6e796d4669726d43722e53796e6f6e796d4e616d65204153' +
        '2053796e6f6e796d4669726d2c'
      
        '20202020696628507269636573446174612e446174655072696365204953204e' +
        '4f54204e554c4c2c20507269636573446174612e446174655072696365202b20' +
        '696e74657276616c202d3a74696d657a6f6e6562696173206d696e7574652c20' +
        '6e756c6c29204153204461746550726963652c'
      '20202020507269636573446174612e50726963654e616d652c'
      '202020205052442e456e61626c6564204153205072696365456e61626c65642c'
      
        '2020202050726f7669646572732e4669726d436f6465204153204669726d436f' +
        '64652c'
      '202020205052442e53746f726167652c'
      '20202020526567696f6e732e526567696f6e4e616d652c'
      '202020206f7362632e4964206173204f726465724c69737449642c'
      '202020206f7362632e436f72654964204153204f7264657273436f726549642c'
      
        '202020206f7362632e4f726465724964204153204f72646572734f7264657249' +
        '642c'
      
        '202020206f7362632e436c69656e744964204153204f7264657273436c69656e' +
        '7449642c'
      
        '20202020636174616c6f67732e66756c6c636f6465204153204f726465727346' +
        '756c6c436f64652c'
      
        '202020206f7362632e436f64654669726d4372204153204f7264657273436f64' +
        '654669726d43722c'
      
        '202020206f7362632e53796e6f6e796d436f6465204153204f72646572735379' +
        '6e6f6e796d436f64652c'
      
        '202020206f7362632e53796e6f6e796d4669726d4372436f6465204153204f72' +
        '6465727353796e6f6e796d4669726d4372436f64652c'
      '202020206f7362632e436f6465204153204f7264657273436f64652c'
      '202020206f7362632e436f64654372204153204f7264657273436f646543722c'
      '202020206f7362632e4f72646572436f756e742c'
      
        '202020206f7362632e53796e6f6e796d4e616d65204153204f72646572735379' +
        '6e6f6e796d2c'
      
        '202020206f7362632e53796e6f6e796d4669726d204153204f72646572735379' +
        '6e6f6e796d4669726d2c'
      '202020206f7362632e5072696365204153204f726465727350726963652c'
      
        '202020206f7362632e50726963652a6f7362632e4f72646572436f756e742041' +
        '532053756d4f726465722c'
      '202020206f7362632e4a756e6b204153204f72646572734a756e6b2c'
      '202020206f7362632e4177616974204153204f726465727341776169742c'
      
        '2020202043757272656e744f7264657248656164732e4f726465724964204153' +
        '204f7264657273484f7264657249642c'
      
        '2020202043757272656e744f7264657248656164732e436c69656e7449642041' +
        '53204f726465727348436c69656e7449642c'
      
        '2020202043757272656e744f7264657248656164732e5072696365436f646520' +
        '4153204f7264657273485072696365436f64652c'
      
        '2020202043757272656e744f7264657248656164732e526567696f6e436f6465' +
        '204153204f726465727348526567696f6e436f64652c'
      
        '2020202043757272656e744f7264657248656164732e50726963654e616d6520' +
        '4153204f72646572734850726963654e616d652c'
      
        '2020202043757272656e744f7264657248656164732e526567696f6e4e616d65' +
        '204153204f726465727348526567696f6e4e616d652c'
      '202020204d6e6e2e4964206173204d6e6e49642c'
      '202020204d6e6e2e4d6e6e2c'
      
        '2020202047726f75704d617850726f6475636572436f7374732e4d617850726f' +
        '6475636572436f73742c'
      
        '2020202050726f6475636572732e4e616d652061732050726f64756365724e61' +
        '6d652c'
      '20202020526567696f6e616c446174612e537570706f727450686f6e652c20'
      '20202020526567696f6e616c446174612e4f7065726174697665496e666f'
      '46524f4d'
      '2020202070726f6475637473'
      
        '20202020696e6e6572206a6f696e20436174616c6f6773206f6e20636174616c' +
        '6f67732e66756c6c636f6465203d2070726f64756374732e636174616c6f6769' +
        '64'
      
        '202020206c656674204a4f494e20436f7265204f4e20436f72652e70726f6475' +
        '63746964203d2070726f64756374732e70726f647563746964'
      
        '202020206c656674206a6f696e2050726f647563657273206f6e2050726f6475' +
        '636572732e4964203d20436f72652e436f64654669726d4372'
      
        '202020206c656674206a6f696e204d6e6e206f6e206d6e6e2e4964203d204361' +
        '74616c6f67732e4d6e6e4964'
      
        '202020206c656674206a6f696e2047726f75704d617850726f6475636572436f' +
        '737473206f6e20'
      
        '2020202020202847726f75704d617850726f6475636572436f7374732e50726f' +
        '647563744964203d20436f72652e70726f6475637469642920'
      
        '202020202020616e642028436f72652e436f64654669726d4372203d2047726f' +
        '75704d617850726f6475636572436f7374732e50726f6475636572496429'
      
        '202020206c656674206a6f696e2053796e6f6e796d73206f6e20436f72652e53' +
        '796e6f6e796d436f64653d53796e6f6e796d732e53796e6f6e796d436f6465'
      
        '202020204c454654204a4f494e2053796e6f6e796d4669726d4372204f4e2043' +
        '6f72652e53796e6f6e796d4669726d4372436f64653d53796e6f6e796d466972' +
        '6d43722e53796e6f6e796d4669726d4372436f6465'
      
        '202020204c454654204a4f494e2050726963657344617461204f4e20436f7265' +
        '2e5072696365436f64653d507269636573446174612e5072696365436f6465'
      
        '202020204c454654204a4f494e20507269636573526567696f6e616c44617461' +
        '20505244204f4e2028436f72652e526567696f6e436f64653d5052442e526567' +
        '696f6e436f646529'
      
        '2020202020202020414e442028436f72652e5072696365436f64653d5052442e' +
        '5072696365436f646529'
      
        '202020204c454654204a4f494e2050726f766964657273204f4e205072696365' +
        '73446174612e4669726d436f64653d50726f7669646572732e4669726d436f64' +
        '65'
      
        '202020204c454654204a4f494e20526567696f6e73204f4e20436f72652e5265' +
        '67696f6e436f64653d526567696f6e732e526567696f6e436f6465'
      '202020206c656674206a6f696e20526567696f6e616c44617461206f6e20'
      
        '202020202020202020526567696f6e616c446174612e4669726d436f6465203d' +
        '2050726f7669646572732e4669726d436f6465'
      
        '202020202020202020616e6420526567696f6e616c446174612e526567696f6e' +
        '436f6465203d20526567696f6e732e526567696f6e436f6465'
      
        '202020204c454654204a4f494e2043757272656e744f726465724c6973747320' +
        '6f736263204f4e206f7362632e636c69656e746964203d203a636c69656e7469' +
        '6420616e64206f7362632e436f72654964203d20436f72652e436f72654964'
      
        '202020206c656674206a6f696e2044656c61794f665061796d656e747320646f' +
        '70206f6e2028646f702e5072696365436f6465203d2050726963657344617461' +
        '2e5072696365436f64652920616e642028646f702e4461794f665765656b203d' +
        '203a4461794f665765656b2920'
      
        '202020204c454654204a4f494e2043757272656e744f72646572486561647320' +
        '4f4e2043757272656e744f7264657248656164732e4f726465724964203d206f' +
        '7362632e4f7264657249642020616e642043757272656e744f72646572486561' +
        '64732e46726f7a656e203d2030'
      '574845524520'
      
        '202020202870726f64756374732e436174616c6f674964203d203a436174616c' +
        '6f67496429'
      '616e642028436f72652e636f72656964206973206e6f74206e756c6c29'
      '616e642028436f72652e53796e6f6e796d436f6465203e203029'
      '6f7264657220627920436f7374')
  end
  object shCoreUpdate: TStrHolder
    Capacity = 12
    Macros = <>
    Left = 208
    Top = 112
    InternalVer = 1
    StrData = (
      ''
      '757064617465'
      '202043757272656e744f726465724c69737473'
      '736574'
      '20204f72646572436f756e74203d203a4f52444552434f554e542c'
      
        '202044726f70526561736f6e203d206966283a4f52444552434f554e54203d20' +
        '302c206e756c6c2c2044726f70526561736f6e292c'
      
        '2020536572766572436f7374203d206966283a4f52444552434f554e54203d20' +
        '302c206e756c6c2c20536572766572436f7374292c'
      
        '20205365727665725175616e74697479203d206966283a4f52444552434f554e' +
        '54203d20302c206e756c6c2c205365727665725175616e7469747929'
      '7768657265'
      '202020204f726465724964203d203a4f52444552534f524445524944'
      '616e6420436f7265496420203d203a4f4c445f434f52454944')
  end
  object shCoreRefresh: TStrHolder
    Capacity = 118
    Macros = <>
    Left = 208
    Top = 152
    InternalVer = 1
    StrData = (
      ''
      '53454c45435420'
      '20202020436f72652e436f726549642c'
      '20202020436f72652e5072696365436f64652c'
      '20202020436f72652e526567696f6e436f64652c'
      '20202020436f72652e70726f6475637469642c'
      '20202020636174616c6f67732e66756c6c636f64652c'
      '20202020636174616c6f67732e73686f7274636f64652c'
      '20202020636174616c6f67732e4465736372697074696f6e49642c'
      
        '20202020636174616c6f67732e566974616c6c79496d706f7274616e74206173' +
        '20436174616c6f67566974616c6c79496d706f7274616e742c'
      '20202020636174616c6f67732e4d61726b75702c'
      '20202020436f72652e52657461696c566974616c6c79496d706f7274616e742c'
      
        '20202020636174616c6f67732e4d616e6461746f72794c697374206173204361' +
        '74616c6f674d616e6461746f72794c6973742c'
      
        '20202020636174616c6f67732e4e616d6550726f6d6f74696f6e73436f756e74' +
        '2c'
      '20202020436f72652e436f64654669726d43722c'
      '20202020436f72652e53796e6f6e796d436f64652c'
      '20202020436f72652e53796e6f6e796d4669726d4372436f64652c'
      '20202020436f72652e436f64652c'
      '20202020436f72652e436f646543722c'
      '20202020436f72652e506572696f642c'
      '20202020436f72652e566f6c756d652c'
      '20202020436f72652e4e6f74652c'
      '20202020436f72652e436f7374206173205265616c436f73742c'
      '2020696628646f702e4f7468657244656c6179206973206e756c6c2c'
      '202020202020436f72652e436f73742c'
      
        '202020202020696628436f72652e566974616c6c79496d706f7274616e74207c' +
        '7c2069666e756c6c28636174616c6f67732e566974616c6c79496d706f727461' +
        '6e742c2030292c'
      
        '202020202020202020206361737428436f72652e436f7374202a202831202b20' +
        '646f702e566974616c6c79496d706f7274616e7444656c61792f313030292061' +
        '7320646563696d616c2831382c203229292c'
      
        '202020202020202020206361737428436f72652e436f7374202a202831202b20' +
        '646f702e4f7468657244656c61792f3130302920617320646563696d616c2831' +
        '382c20322929'
      '2020202020202029'
      '202029'
      '202020202020617320436f73742c'
      '20202020436f72652e5175616e746974792c'
      '20202020436f72652e41776169742c'
      '20202020436f72652e4a756e6b2c'
      '20202020436f72652e646f632c'
      '20202020436f72652e7265676973747279636f73742c'
      '20202020436f72652e766974616c6c79696d706f7274616e742c'
      '20202020436f72652e72657175657374726174696f2c'
      '20202020636f72652e6f72646572636f73742c'
      '20202020636f72652e6d696e6f72646572636f756e742c'
      '20202020436f72652e50726f6475636572436f73742c'
      '20202020436f72652e4e44532c'
      '20202020636f72652e537570706c69657250726963654d61726b75702c'
      '20202020636f72652e427579696e674d6174726978547970652c'
      
        '2020202069666e756c6c2853796e6f6e796d732e53796e6f6e796d4e616d652c' +
        '20636f6e63617428636174616c6f67732e6e616d652c202720272c2063617461' +
        '6c6f67732e666f726d29292061732053796e6f6e796d4e616d652c'
      
        '2020202053796e6f6e796d4669726d43722e53796e6f6e796d4e616d65204153' +
        '2053796e6f6e796d4669726d2c'
      
        '20202020696628507269636573446174612e446174655072696365204953204e' +
        '4f54204e554c4c2c20507269636573446174612e446174655072696365202b20' +
        '696e74657276616c202d3a74696d657a6f6e6562696173206d696e7574652c20' +
        '6e756c6c29204153204461746550726963652c'
      '20202020507269636573446174612e50726963654e616d652c'
      '202020205052442e456e61626c6564204153205072696365456e61626c65642c'
      
        '2020202050726f7669646572732e4669726d436f6465204153204669726d436f' +
        '64652c'
      '202020205052442e53746f726167652c'
      '20202020526567696f6e732e526567696f6e4e616d652c'
      '202020206f7362632e4964206173204f726465724c69737449642c'
      '202020206f7362632e436f72654964204153204f7264657273436f726549642c'
      
        '202020206f7362632e4f726465724964204153204f72646572734f7264657249' +
        '642c'
      
        '202020206f7362632e436c69656e744964204153204f7264657273436c69656e' +
        '7449642c'
      
        '20202020636174616c6f67732e66756c6c636f6465204153204f726465727346' +
        '756c6c436f64652c'
      
        '202020206f7362632e436f64654669726d4372204153204f7264657273436f64' +
        '654669726d43722c'
      
        '202020206f7362632e53796e6f6e796d436f6465204153204f72646572735379' +
        '6e6f6e796d436f64652c'
      
        '202020206f7362632e53796e6f6e796d4669726d4372436f6465204153204f72' +
        '6465727353796e6f6e796d4669726d4372436f64652c'
      '202020206f7362632e436f6465204153204f7264657273436f64652c'
      '202020206f7362632e436f64654372204153204f7264657273436f646543722c'
      '202020206f7362632e4f72646572436f756e742c'
      
        '202020206f7362632e53796e6f6e796d4e616d65204153204f72646572735379' +
        '6e6f6e796d2c'
      
        '202020206f7362632e53796e6f6e796d4669726d204153204f72646572735379' +
        '6e6f6e796d4669726d2c'
      '202020206f7362632e5072696365204153204f726465727350726963652c'
      
        '202020206f7362632e50726963652a6f7362632e4f72646572436f756e742041' +
        '532053756d4f726465722c'
      '202020206f7362632e4a756e6b204153204f72646572734a756e6b2c'
      '202020206f7362632e4177616974204153204f726465727341776169742c'
      
        '2020202043757272656e744f7264657248656164732e4f726465724964204153' +
        '204f7264657273484f7264657249642c'
      
        '2020202043757272656e744f7264657248656164732e436c69656e7449642041' +
        '53204f726465727348436c69656e7449642c'
      
        '2020202043757272656e744f7264657248656164732e5072696365436f646520' +
        '4153204f7264657273485072696365436f64652c'
      
        '2020202043757272656e744f7264657248656164732e526567696f6e436f6465' +
        '204153204f726465727348526567696f6e436f64652c'
      
        '2020202043757272656e744f7264657248656164732e50726963654e616d6520' +
        '4153204f72646572734850726963654e616d652c'
      
        '2020202043757272656e744f7264657248656164732e526567696f6e4e616d65' +
        '204153204f726465727348526567696f6e4e616d652c'
      '202020204d6e6e2e4964206173204d6e6e49642c'
      '202020204d6e6e2e4d6e6e2c'
      
        '2020202047726f75704d617850726f6475636572436f7374732e4d617850726f' +
        '6475636572436f73742c'
      
        '2020202050726f6475636572732e4e616d652061732050726f64756365724e61' +
        '6d652c'
      '20202020526567696f6e616c446174612e537570706f727450686f6e652c20'
      '20202020526567696f6e616c446174612e4f7065726174697665496e666f'
      '46524f4d'
      '2020202070726f6475637473'
      
        '20202020696e6e6572206a6f696e20436174616c6f6773206f6e20636174616c' +
        '6f67732e66756c6c636f6465203d2070726f64756374732e636174616c6f6769' +
        '64'
      
        '202020206c656674204a4f494e20436f7265204f4e20436f72652e70726f6475' +
        '63746964203d2070726f64756374732e70726f647563746964'
      
        '202020206c656674206a6f696e2050726f647563657273206f6e2050726f6475' +
        '636572732e4964203d20436f72652e436f64654669726d4372'
      
        '202020206c656674206a6f696e204d6e6e206f6e206d6e6e2e4964203d204361' +
        '74616c6f67732e4d6e6e4964'
      
        '202020206c656674206a6f696e2047726f75704d617850726f6475636572436f' +
        '737473206f6e20'
      
        '2020202020202847726f75704d617850726f6475636572436f7374732e50726f' +
        '647563744964203d20436f72652e70726f6475637469642920'
      
        '202020202020616e642028436f72652e436f64654669726d4372203d2047726f' +
        '75704d617850726f6475636572436f7374732e50726f6475636572496429'
      
        '202020206c656674206a6f696e2053796e6f6e796d73206f6e20436f72652e53' +
        '796e6f6e796d436f64653d53796e6f6e796d732e53796e6f6e796d436f6465'
      
        '202020204c454654204a4f494e2053796e6f6e796d4669726d4372204f4e2043' +
        '6f72652e53796e6f6e796d4669726d4372436f64653d53796e6f6e796d466972' +
        '6d43722e53796e6f6e796d4669726d4372436f6465'
      
        '202020204c454654204a4f494e2050726963657344617461204f4e20436f7265' +
        '2e5072696365436f64653d507269636573446174612e5072696365436f6465'
      
        '202020204c454654204a4f494e20507269636573526567696f6e616c44617461' +
        '20505244204f4e2028436f72652e526567696f6e436f64653d5052442e526567' +
        '696f6e436f646529'
      
        '2020202020202020414e442028436f72652e5072696365436f64653d5052442e' +
        '5072696365436f646529'
      
        '202020204c454654204a4f494e2050726f766964657273204f4e205072696365' +
        '73446174612e4669726d436f64653d50726f7669646572732e4669726d436f64' +
        '65'
      
        '202020204c454654204a4f494e20526567696f6e73204f4e20436f72652e5265' +
        '67696f6e436f64653d526567696f6e732e526567696f6e436f6465'
      '202020206c656674206a6f696e20526567696f6e616c44617461206f6e20'
      
        '202020202020202020526567696f6e616c446174612e4669726d436f6465203d' +
        '2050726f7669646572732e4669726d436f6465'
      
        '202020202020202020616e6420526567696f6e616c446174612e526567696f6e' +
        '436f6465203d20526567696f6e732e526567696f6e436f6465'
      
        '202020204c454654204a4f494e2043757272656e744f726465724c6973747320' +
        '6f736263204f4e206f7362632e636c69656e746964203d203a636c69656e7469' +
        '6420616e64206f7362632e436f72654964203d20436f72652e436f72654964'
      
        '202020206c656674206a6f696e2044656c61794f665061796d656e747320646f' +
        '70206f6e2028646f702e5072696365436f6465203d2050726963657344617461' +
        '2e5072696365436f64652920616e642028646f702e4461794f665765656b203d' +
        '203a4461794f665765656b2920'
      
        '202020204c454654204a4f494e2043757272656e744f72646572486561647320' +
        '4f4e2043757272656e744f7264657248656164732e4f726465724964203d206f' +
        '7362632e4f7264657249642020616e642043757272656e744f72646572486561' +
        '64732e46726f7a656e203d2030'
      '574845524520'
      '2020436f72652e436f72654964203d203a436f72654964'
      '')
  end
  object tmrUpdateOffers: TTimer
    Enabled = False
    Interval = 350
    OnTimer = tmrUpdateOffersTimer
    Left = 280
    Top = 69
  end
  object ActionList: TActionList
    Left = 368
    Top = 145
  end
  object dsPreviosOrders: TDataSource
    DataSet = adsPreviosOrders
    Left = 152
    Top = 408
  end
  object adsPreviosOrders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      '#ORDERSSHOWBYFORM'
      'SELECT '
      '    products.catalogid as FullCode,'
      '    osbc.Code,'
      '    osbc.CodeCR,'
      '    osbc.SynonymName,'
      '    osbc.SynonymFirm,'
      '    osbc.OrderCount,'
      '    osbc.Price,'
      '    PostedOrderHeads.SendDate as OrderDate,'
      '    PostedOrderHeads.PriceName,'
      '    PostedOrderHeads.RegionName,'
      '    osbc.Await,'
      '    osbc.Junk,'
      '    osbc.Period'
      'FROM'
      '  PostedOrderLists osbc'
      '  inner join products on products.productid = osbc.productid'
      
        '  INNER JOIN PostedOrderHeads ON osbc.OrderId=PostedOrderHeads.O' +
        'rderId'
      'WHERE'
      '    (osbc.clientid = :ClientID)'
      'and (osbc.OrderCount > 0)'
      
        'and (((:GroupByProducts = 0) and (products.catalogid = :FullCode' +
        ')) or ((:GroupByProducts = 1) and (osbc.productid = :productid))' +
        ')'
      'And (PostedOrderHeads.Closed = 1)'
      'ORDER BY PostedOrderHeads.SendDate DESC'
      'limit 20')
    Left = 208
    Top = 389
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ClientID'
      end
      item
        DataType = ftUnknown
        Name = 'GroupByProducts'
      end
      item
        DataType = ftUnknown
        Name = 'FULLCODE'
      end
      item
        DataType = ftUnknown
        Name = 'GroupByProducts'
      end
      item
        DataType = ftUnknown
        Name = 'productid'
      end>
    object adsPreviosOrdersFullCode: TLargeintField
      FieldName = 'FullCode'
    end
    object adsPreviosOrdersCode: TStringField
      FieldName = 'Code'
      Size = 84
    end
    object adsPreviosOrdersCodeCR: TStringField
      FieldName = 'CodeCR'
      Size = 84
    end
    object adsPreviosOrdersSynonymName: TStringField
      FieldName = 'SynonymName'
      Size = 250
    end
    object adsPreviosOrdersSynonymFirm: TStringField
      FieldName = 'SynonymFirm'
      Size = 250
    end
    object adsPreviosOrdersOrderCount: TIntegerField
      FieldName = 'OrderCount'
    end
    object adsPreviosOrdersOrderDate: TDateTimeField
      FieldName = 'OrderDate'
    end
    object adsPreviosOrdersPriceName: TStringField
      FieldName = 'PriceName'
      Size = 70
    end
    object adsPreviosOrdersRegionName: TStringField
      FieldName = 'RegionName'
      Size = 25
    end
    object adsPreviosOrdersPrice: TFloatField
      FieldName = 'Price'
    end
    object adsPreviosOrdersAwait: TBooleanField
      FieldName = 'Await'
    end
    object adsPreviosOrdersJunk: TBooleanField
      FieldName = 'Junk'
    end
    object adsPreviosOrdersPeriod: TStringField
      FieldName = 'Period'
    end
  end
end
