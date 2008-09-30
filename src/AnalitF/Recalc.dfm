object RecalcForm: TRecalcForm
  Left = 418
  Top = 241
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1089#1095#1077#1090
  ClientHeight = 65
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    Left = 16
    Top = 24
    Width = 369
    Height = 16
    TabOrder = 0
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 32
    Top = 8
  end
  object adsPrices: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 
      'SELECT PriceFor, FirmsId'#13#10'FROM Prices'#13#10'WHERE FormsId=FormId AND ' +
      'ClientsId=ClientId'
    Parameters = <
      item
        Name = 'FormId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0
      end
      item
        Name = 'ClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0
      end>
    Prepared = True
    Left = 176
    Top = 8
  end
  object adcUpdate: TADOCommand
    CommandText = 
      'UPDATE Prices'#13#10'SET PriceMin=APriceMin,'#13#10'LeaderId=ALeaderId'#13#10'WHER' +
      'E ClientsId=ClientId AND WaresId=WareId'
    Connection = DM.MainConnection
    Prepared = True
    Parameters = <
      item
        Name = 'APriceMin'
        Attributes = [paNullable]
        DataType = ftFloat
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0.000000000000000000
      end
      item
        Name = 'ALeaderId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0
      end
      item
        Name = 'ClientId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0
      end
      item
        Name = 'WareId'
        Attributes = [paNullable]
        DataType = ftInteger
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = 0
      end>
    Left = 232
    Top = 8
  end
  object adsForms: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    CommandText = 
      'SELECT Clients.Id AS ClientId, Forms.Id AS FormId'#13#10'FROM Forms, C' +
      'lients'
    Parameters = <>
    Left = 120
    Top = 8
  end
  object adtPrices: TADOTable
    Connection = DM.MainConnection
    CursorType = ctStatic
    AfterOpen = adtPricesAfterOpen
    IndexName = 'ClientForm'
    TableName = 'Prices'
    Left = 72
    Top = 8
  end
end
