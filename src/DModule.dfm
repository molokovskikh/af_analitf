object DM: TDM
  OldCreateOrder = True
  OnCreate = DMCreate
  OnDestroy = DataModuleDestroy
  Left = 158
  Top = 337
  Height = 422
  Width = 721
  object MainConnection: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Anali' +
      'tF.mdb;Persist Security Info=False;Jet OLEDB:Registry Path="";Je' +
      't OLEDB:Database Password=commonpas;Jet OLEDB:Engine Type=5;Jet ' +
      'OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=' +
      '2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Pa' +
      'ssword="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encry' +
      'pt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;J' +
      'et OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=Fals' +
      'e'
    IsolationLevel = ilReadCommitted
    KeepConnection = False
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    AfterConnect = MainConnectionAfterConnect
    Left = 32
    Top = 8
  end
  object adtParams: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    AfterOpen = adtParamsAfterOpen
    IndexName = 'PrimaryKey'
    TableName = 'Params'
    Left = 96
    Top = 8
  end
  object adtProvider: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    TableName = 'Provider'
    Left = 152
    Top = 8
  end
  object adcUpdate: TADOCommand
    CommandTimeout = 60
    Connection = MainConnection
    Parameters = <>
    Left = 528
    Top = 8
  end
  object adsSelect: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <
      item
        Name = 'AClientId'
        Size = -1
        Value = Null
      end>
    Left = 592
    Top = 8
  end
  object frReport: TfrReport
    InitialZoom = pzPageWidth
    PreviewButtons = [pbZoom, pbSave, pbPrint, pbFind, pbExit]
    RebuildPrinter = False
    Left = 24
    Top = 264
    ReportForm = {19000000}
  end
  object dsParams: TDataSource
    DataSet = adtParams
    Left = 96
    Top = 56
  end
  object dsAnalit: TDataSource
    DataSet = adtProvider
    Left = 152
    Top = 56
  end
  object dsClients: TDataSource
    DataSet = adtClients
    Left = 288
    Top = 56
  end
  object adtTablesUpdates: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    IndexName = 'PrimaryKey'
    TableDirect = True
    TableName = 'TablesUpdates'
    Left = 360
    Top = 8
  end
  object dsTablesUpdates: TDataSource
    DataSet = adtTablesUpdates
    Left = 360
    Top = 56
  end
  object Ras: TARas
    Left = 24
    Top = 320
  end
  object adsSelect2: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    Parameters = <>
    Left = 648
    Top = 8
  end
  object frOLEObject: TfrOLEObject
    Left = 64
    Top = 264
  end
  object frRichObject: TfrRichObject
    Left = 104
    Top = 264
  end
  object frCheckBoxObject: TfrCheckBoxObject
    Left = 144
    Top = 264
  end
  object frShapeObject: TfrShapeObject
    Left = 184
    Top = 264
  end
  object frChartObject: TfrChartObject
    Left = 224
    Top = 264
  end
  object frRoundRectObject: TfrRoundRectObject
    Left = 264
    Top = 264
  end
  object frTextExport: TfrTextExport
    ShowDialog = False
    ScaleX = 1.000000000000000000
    ScaleY = 1.000000000000000000
    KillEmptyLines = False
    PageBreaks = False
    Left = 344
    Top = 264
  end
  object frDialogControls: TfrDialogControls
    Left = 304
    Top = 264
  end
  object frHTML2Export: TfrHTML2Export
    ShowDialog = False
    Scale = 1.000000000000000000
    AllJPEG = True
    Navigator.Position = []
    Navigator.Font.Charset = DEFAULT_CHARSET
    Navigator.Font.Color = clWindowText
    Navigator.Font.Height = -11
    Navigator.Font.Name = 'MS Sans Serif'
    Navigator.Font.Style = []
    Navigator.InFrame = False
    Navigator.WideInFrame = False
    Left = 384
    Top = 264
  end
  object frOLEExcelExport: TfrOLEExcelExport
    ShowDialog = False
    PageBreaks = False
    Left = 424
    Top = 264
  end
  object frBMPExport: TfrBMPExport
    ShowDialog = False
    Left = 464
    Top = 264
  end
  object frJPEGExport: TfrJPEGExport
    ShowDialog = False
    Left = 504
    Top = 264
  end
  object frTIFFExport: TfrTIFFExport
    ShowDialog = False
    Left = 544
    Top = 264
  end
  object frRtfAdvExport: TfrRtfAdvExport
    ShowDialog = False
    Left = 584
    Top = 264
  end
  object adsOrders: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM OrdersShow'
    Parameters = <
      item
        Name = 'AOrderId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 80
    Top = 144
  end
  object adsSelect3: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 204
    Top = 148
  end
  object adsCore: TADODataSet
    AutoCalcFields = False
    Connection = MainConnection
    CommandText = 'SELECT * FROM CoreShowByFirm'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '928'
      end
      item
        Name = 'RetailForcount'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '0'
      end
      item
        Name = 'APriceCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '31'
      end
      item
        Name = 'ARegionCode'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '1'
      end>
    Prepared = True
    Left = 272
    Top = 148
  end
  object adtReclame: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    TableName = 'Reclame'
    Left = 224
    Top = 8
  end
  object adtClients: TADOTable
    Connection = MainConnection
    CursorType = ctStatic
    AfterOpen = adtClientsAfterOpen
    AfterInsert = adtClientsAfterInsert
    AfterPost = adtClientsAfterPost
    BeforeDelete = adtClientsBeforeDelete
    IndexName = 'PrimaryKey'
    TableName = 'Clients'
    Left = 288
    Top = 8
  end
  object dsReclame: TDataSource
    DataSet = adtReclame
    Left = 224
    Top = 56
  end
  object adtFlags: TADOTable
    Connection = MainConnection
    TableName = 'Flags'
    Left = 448
    Top = 8
  end
  object adsOrdersH: TADODataSet
    Connection = MainConnection
    CursorType = ctStatic
    CommandText = 'SELECT * FROM OrdersHShow WHERE Send=ASend'
    Parameters = <
      item
        Name = 'AClientId'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'TimeZoneBias'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'AClosed'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end
      item
        Name = 'ASend'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    Prepared = True
    Left = 40
    Top = 144
  end
end
