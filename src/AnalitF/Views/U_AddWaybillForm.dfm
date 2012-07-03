inherited AddWaybillForm: TAddWaybillForm
  Width = 319
  Height = 246
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbAdd: TGroupBox
    Left = 0
    Top = 0
    Width = 303
    Height = 161
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 8
      Width = 58
      Height = 13
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object Label2: TLabel
      Left = 5
      Top = 56
      Width = 91
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
    end
    object Label3: TLabel
      Left = 5
      Top = 104
      Width = 83
      Height = 13
      Caption = #1044#1072#1090#1072' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
    end
    object eProviderId: TEdit
      Left = 5
      Top = 72
      Width = 285
      Height = 21
      TabOrder = 1
    end
    object dtpDate: TDateTimePicker
      Left = 5
      Top = 117
      Width = 124
      Height = 21
      Date = 36526.000000000000000000
      Time = 36526.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object cbProviders: TComboBox
      Left = 5
      Top = 24
      Width = 285
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object btnOk: TButton
    Left = 8
    Top = 169
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 88
    Top = 169
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object dsProviders: TDataSource
    DataSet = adsProviders
    Left = 152
    Top = 104
  end
  object adsProviders: TMyQuery
    Connection = DM.MyConnection
    SQL.Strings = (
      'select'
      'Providers.FirmCode,'
      'Providers.FullName'
      'from'
      '  Providers'
      'order by Providers.FullName')
    Left = 192
    Top = 104
  end
end
