object FormsHistoryForm: TFormsHistoryForm
  Left = 343
  Top = 262
  Width = 428
  Height = 295
  Caption = 'FormsHistoryForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label105: TLabel
    Left = 8
    Top = 8
    Width = 168
    Height = 13
    Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1093' '#1079#1072#1082#1091#1087#1086#1082' '#1087#1086' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object DBText39: TDBText
    Left = 16
    Top = 24
    Width = 331
    Height = 17
    DataField = 'Tovar'
  end
  object DBText40: TDBText
    Left = 56
    Top = 40
    Width = 291
    Height = 17
    DataField = 'Forma'
  end
  object Label104: TLabel
    Left = 144
    Top = 208
    Width = 129
    Height = 13
    Caption = #1057#1088'. '#1094#1077#1085#1072' '#1087#1088#1077#1076#1099#1076'. '#1079#1072#1103#1074#1086#1082':'
  end
  object Label106: TLabel
    Left = 280
    Top = 200
    Width = 49
    Height = 16
    Caption = '100000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBGrid20: TDBGrid
    Left = 8
    Top = 56
    Width = 337
    Height = 139
    Options = [dgTitles, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 's2'
        Title.Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Kol_zakaz'
        Title.Caption = #1050#1086#1083'-'#1074#1086
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'firma'
        Width = 78
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Data'
        Title.Caption = #1044#1072#1090#1072
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Ind1'
        Title.Caption = #1062#1077#1085#1072
        Width = 56
        Visible = True
      end>
  end
  object Button25: TButton
    Left = 16
    Top = 200
    Width = 99
    Height = 22
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 1
  end
end
