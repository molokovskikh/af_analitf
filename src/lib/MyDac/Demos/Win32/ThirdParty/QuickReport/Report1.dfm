object qrReport1: TqrReport1
  Left = 0
  Top = 0
  Width = 794
  Height = 1123
  Frame.Color = clBlack
  Frame.DrawTop = False
  Frame.DrawBottom = False
  Frame.DrawLeft = False
  Frame.DrawRight = False
  AfterPrint = QuickRepAfterPreview
  AfterPreview = QuickRepAfterPreview
  BeforePrint = QuickRepBeforePrint
  DataSet = quDept
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  Functions.Strings = (
    'PAGENUMBER'
    'COLUMNNUMBER'
    'REPORTTITLE'
    'QRSTRINGSBAND1')
  Functions.DATA = (
    '0'
    '0'
    #39#39
    #39#39)
  Options = [FirstPageHeader, LastPageFooter]
  Page.Columns = 1
  Page.Orientation = poPortrait
  Page.PaperSize = A4
  Page.Values = (
    100
    2970
    100
    2100
    100
    100
    0)
  PrinterSettings.Copies = 1
  PrinterSettings.Duplex = False
  PrinterSettings.FirstPage = 0
  PrinterSettings.LastPage = 0
  PrinterSettings.OutputBin = Auto
  PrintIfEmpty = True
  SnapToGrid = True
  Units = MM
  Zoom = 100
  object QRBand1: TQRBand
    Left = 38
    Top = 38
    Width = 718
    Height = 75
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    ForceNewColumn = False
    ForceNewPage = False
    Size.Values = (
      198.4375
      1899.70833333333)
    BandType = rbTitle
    object QRLabel1: TQRLabel
      Left = 232
      Top = 13
      Width = 237
      Height = 33
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        87.3125
        613.833333333333
        34.3958333333333
        627.0625)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Employees Report'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -27
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 20
    end
    object QRSysData1: TQRSysData
      Left = 624
      Top = 5
      Width = 56
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1651
        13.2291666666667
        148.166666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      Color = clWhite
      Data = qrsDateTime
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = False
      FontSize = 8
    end
  end
  object QRBand2: TQRBand
    Left = 38
    Top = 113
    Width = 718
    Height = 38
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    ForceNewColumn = False
    ForceNewPage = False
    Size.Values = (
      100.541666666667
      1899.70833333333)
    BandType = rbDetail
    object QRDBText1: TQRDBText
      Left = 256
      Top = 12
      Width = 55
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        677.333333333333
        31.75
        145.520833333333)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quDept
      DataField = 'DEPTNO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText2: TQRDBText
      Left = 96
      Top = 12
      Width = 47
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        254
        31.75
        124.354166666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quDept
      DataField = 'DNAME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText3: TQRDBText
      Left = 384
      Top = 12
      Width = 27
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1016
        31.75
        71.4375)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quDept
      DataField = 'LOC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRShape1: TQRShape
      Left = 8
      Top = 31
      Width = 703
      Height = 5
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        13.2291666666667
        21.1666666666667
        82.0208333333333
        1860.02083333333)
      Pen.Width = 2
      Shape = qrsHorLine
    end
    object QRLabel10: TQRLabel
      Left = 13
      Top = 12
      Width = 75
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        34.3958333333333
        31.75
        198.4375)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Departament'
      Color = clWhite
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel11: TQRLabel
      Left = 229
      Top = 12
      Width = 17
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        605.895833333333
        31.75
        44.9791666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'No'
      Color = clWhite
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel12: TQRLabel
      Left = 325
      Top = 12
      Width = 50
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        859.895833333333
        31.75
        132.291666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Location'
      Color = clWhite
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
  end
  object QRSubDetail1: TQRSubDetail
    Left = 38
    Top = 175
    Width = 718
    Height = 28
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ForceNewColumn = False
    ForceNewPage = False
    ParentFont = False
    Size.Values = (
      74.0833333333333
      1899.70833333333)
    Master = Owner
    DataSet = quEmp
    FooterBand = GroupFooterBand1
    HeaderBand = GroupHeaderBand1
    PrintBefore = False
    PrintIfEmpty = True
    object QRDBText4: TQRDBText
      Left = 16
      Top = 7
      Width = 49
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        42.3333333333333
        18.5208333333333
        129.645833333333)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'EMPNO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText5: TQRDBText
      Left = 72
      Top = 7
      Width = 48
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        190.5
        18.5208333333333
        127)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'ENAME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText7: TQRDBText
      Left = 168
      Top = 7
      Width = 26
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        444.5
        18.5208333333333
        68.7916666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'JOB'
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText8: TQRDBText
      Left = 264
      Top = 7
      Width = 31
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        698.5
        18.5208333333333
        82.0208333333333)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'MGR'
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText9: TQRDBText
      Left = 328
      Top = 7
      Width = 65
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        867.833333333333
        18.5208333333333
        171.979166666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'HIREDATE'
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText10: TQRDBText
      Left = 416
      Top = 7
      Width = 26
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1100.66666666667
        18.5208333333333
        68.7916666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quEmp
      DataField = 'SAL'
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
  end
  object QRBand3: TQRBand
    Left = 38
    Top = 234
    Width = 718
    Height = 30
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    ForceNewColumn = False
    ForceNewPage = False
    Size.Values = (
      79.375
      1899.70833333333)
    BandType = rbSummary
    object QRLabel2: TQRLabel
      Left = 16
      Top = 8
      Width = 33
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        42.3333333333333
        21.1666666666667
        87.3125)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Total'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRExpr2: TQRExpr
      Left = 416
      Top = 7
      Width = 112
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1100.66666666667
        18.5208333333333
        296.333333333333)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Color = clWhite
      Master = QRSubDetail1
      ParentFont = False
      ResetAfterPrint = False
      Transparent = False
      WordWrap = True
      Expression = 'SUM(quEmp.SAL)'
      FontSize = 10
    end
  end
  object GroupFooterBand1: TQRBand
    Left = 38
    Top = 203
    Width = 718
    Height = 31
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    ForceNewColumn = False
    ForceNewPage = False
    Size.Values = (
      82.0208333333333
      1899.70833333333)
    BandType = rbGroupFooter
    object QRLabel9: TQRLabel
      Left = 16
      Top = 9
      Width = 62
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        42.3333333333333
        23.8125
        164.041666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Summary'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRDBText6: TQRDBText
      Left = 88
      Top = 9
      Width = 47
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        232.833333333333
        23.8125
        124.354166666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Color = clWhite
      DataSet = quDept
      DataField = 'DNAME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRExpr1: TQRExpr
      Left = 416
      Top = 9
      Width = 112
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1100.66666666667
        23.8125
        296.333333333333)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Color = clWhite
      Master = QRSubDetail1
      ParentFont = False
      ResetAfterPrint = True
      Transparent = False
      WordWrap = True
      Expression = 'SUM(quEmp.SAL)'
      FontSize = 10
    end
    object QRShape2: TQRShape
      Left = 8
      Top = 2
      Width = 703
      Height = 5
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        13.2291666666667
        21.1666666666667
        5.29166666666667
        1860.02083333333)
      Pen.Width = 2
      Shape = qrsHorLine
    end
  end
  object GroupHeaderBand1: TQRBand
    Left = 38
    Top = 151
    Width = 718
    Height = 24
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    AlignToBottom = False
    Color = clWhite
    ForceNewColumn = False
    ForceNewPage = False
    Size.Values = (
      63.5
      1899.70833333333)
    BandType = rbGroupHeader
    object QRLabel3: TQRLabel
      Left = 16
      Top = 5
      Width = 18
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        42.3333333333333
        13.2291666666667
        47.625)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'No'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel4: TQRLabel
      Left = 72
      Top = 5
      Width = 38
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        190.5
        13.2291666666667
        100.541666666667)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Name'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel5: TQRLabel
      Left = 168
      Top = 5
      Width = 24
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        444.5
        13.2291666666667
        63.5)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Job'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel6: TQRLabel
      Left = 264
      Top = 5
      Width = 57
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        698.5
        13.2291666666667
        150.8125)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Manager'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel7: TQRLabel
      Left = 328
      Top = 5
      Width = 60
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        867.833333333333
        13.2291666666667
        158.75)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Hire Date'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
    object QRLabel8: TQRLabel
      Left = 416
      Top = 5
      Width = 42
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Size.Values = (
        44.9791666666667
        1100.66666666667
        13.2291666666667
        111.125)
      Alignment = taLeftJustify
      AlignToBand = False
      AutoSize = True
      AutoStretch = False
      Caption = 'Salary'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      WordWrap = True
      FontSize = 10
    end
  end
  object quEmp: TMyQuery
    Connection = fmMain.MyConnection
    SQL.Strings = (
      'SELECT * FROM EMP'
      'WHERE DeptNo = :DeptNo')
    MasterSource = DataSource1
    Left = 8
    Top = 48
    ParamData = <
      item
        DataType = ftInteger
        Name = 'DeptNo'
        ParamType = ptUnknown
        Value = 45
      end>
  end
  object quDept: TMyQuery
    Connection = fmMain.MyConnection
    SQL.Strings = (
      'SELECT * FROM DEPT')
    Left = 8
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = quDept
    Left = 40
    Top = 16
  end
end
