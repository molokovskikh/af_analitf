object NormativesForm: TNormativesForm
  Left = 236
  Top = 174
  ActiveControl = dbgNormatives
  Align = alClient
  BorderStyle = bsNone
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099', '#1088#1077#1075#1083#1072#1084#1077#1085#1090#1080#1088#1091#1102#1097#1080#1077' '#1092#1072#1088#1084'. '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1100
  ClientHeight = 449
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    633
    449)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 37
    Height = 13
    Caption = #1056#1072#1079#1076#1077#1083
  end
  object Label2: TLabel
    Left = 0
    Top = 400
    Width = 489
    Height = 26
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 
      #1047#1076#1077#1089#1100' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085#1072' '#1083#1080#1096#1100' '#1095#1072#1089#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074', '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1099#1093' '#1042#1072#1084' '#1074' '#1087#1086#1074#1089 +
      #1077#1076#1085#1077#1074#1085#1086#1081' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080'.'#13#10#1057#1086#1086#1073#1097#1080#1090#1077' '#1085#1072#1084', '#1082#1072#1082#1080#1077' '#1077#1097#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1042#1099' '#1093#1086#1090 +
      #1080#1090#1077' '#1079#1076#1077#1089#1100' '#1091#1074#1080#1076#1077#1090#1100'.'
    WordWrap = True
  end
  object lblRecordCount: TLabel
    Left = 520
    Top = 16
    Width = 107
    Height = 13
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1086#1074': 0'
  end
  object dbgNormatives: TADBGrid
    Left = 0
    Top = 40
    Width = 633
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsNormatives
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    FindColumnName = 'Name'
    FindFont.Charset = DEFAULT_CHARSET
    FindFont.Color = clWindowText
    FindFont.Height = -11
    FindFont.Name = 'MS Sans Serif'
    FindFont.Style = [fsBold]
    FindPosition = fpTop
    OnCanFocusNext = dbgNormativesCanFocusNext
    Columns = <
      item
        Expanded = False
        FieldName = 'Name'
        Title.Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 505
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Date'
        Title.Caption = #1044#1072#1090#1072
        Width = 65
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'Updated'
        PickList.Strings = (
          #1044#1072
          #1053#1077#1090)
        Title.Caption = #1053#1086#1074#1099#1081
        Width = 40
        Visible = True
      end>
  end
  object dbreTitle: TDBRichEdit
    Left = 0
    Top = 248
    Width = 633
    Height = 145
    Anchors = [akLeft, akRight, akBottom]
    DataField = 'Title'
    DataSource = dsNormatives
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object cbPartitions: TComboBox
    Left = 0
    Top = 16
    Width = 513
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = '['#1042#1089#1077' '#1088#1072#1079#1076#1077#1083#1099']'
    OnClick = cbPartitionsClick
    Items.Strings = (
      '['#1042#1089#1077' '#1088#1072#1079#1076#1077#1083#1099']')
  end
  object txtTablesUpdates: TStaticText
    Left = 0
    Top = 432
    Width = 633
    Height = 17
    Align = alBottom
    AutoSize = False
    BevelInner = bvNone
    BevelKind = bkSoft
    Caption = 'txtTablesUpdates'
    TabOrder = 3
  end
  object dsNormatives: TDataSource
    DataSet = adsNormatives
    Left = 112
    Top = 120
  end
  object adsNormatives: TADODataSet
    Connection = DM.MainConnection
    CursorType = ctStatic
    LockType = ltReadOnly
    CommandText = 'SELECT * FROM NormativesShow'
    MasterFields = 'APartition'
    Parameters = <
      item
        Name = 'APartition'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 30
        Value = ''
      end
      item
        Name = 'ShowAll'
        Attributes = [paNullable]
        DataType = ftBoolean
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = True
      end>
    Prepared = True
    Left = 112
    Top = 72
    object adsNormativesId: TIntegerField
      FieldName = 'Id'
    end
    object adsNormativesPartition: TWideStringField
      FieldName = 'Partition'
      Size = 30
    end
    object adsNormativesName: TWideStringField
      FieldName = 'Name'
      Size = 40
    end
    object adsNormativesUpdated: TBooleanField
      FieldName = 'Updated'
      DisplayValues = '+;'
    end
    object adsNormativesFileName: TWideStringField
      FieldName = 'FileName'
      Size = 8
    end
    object adsNormativesTitle: TMemoField
      FieldName = 'Title'
      BlobType = ftMemo
    end
    object adsNormativesDate: TDateTimeField
      FieldName = 'Date'
    end
  end
end
