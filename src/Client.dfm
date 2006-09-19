object ClientForm: TClientForm
  Left = 381
  Top = 320
  BorderStyle = bsDialog
  Caption = #1050#1083#1080#1077#1085#1090
  ClientHeight = 179
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    274
    179)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 16
    Top = 40
    Width = 108
    Height = 13
    Caption = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072' : '
    Visible = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 274
    Height = 179
    Align = alClient
    Shape = bsFrame
  end
  object btnOk: TButton
    Left = 16
    Top = 138
    Width = 73
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&'#1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 112
    Top = 138
    Width = 73
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1054'&'#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object ToughDBGrid1: TToughDBGrid
    Left = 8
    Top = 8
    Width = 258
    Height = 114
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoFitColWidths = True
    DataSource = DM.dsRetailMargins
    Flat = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    SearchPosition = spBottom
    Columns = <
      item
        DisplayFormat = '0.00;;'
        EditButtons = <>
        FieldName = 'LEFTLIMIT'
        Footers = <>
        Title.Caption = #1051#1077#1074#1072#1103' '#1075#1088#1072#1085#1080#1094#1072
        Width = 80
      end
      item
        DisplayFormat = '0.00;;'
        EditButtons = <>
        FieldName = 'RIGHTLIMIT'
        Footers = <>
        Title.Caption = #1055#1088#1072#1074#1072#1103' '#1075#1088#1072#1085#1080#1094#1072
        Width = 80
      end
      item
        EditButtons = <>
        FieldName = 'RETAIL'
        Footers = <>
        Title.Caption = #1053#1072#1094#1077#1085#1082#1072' (%)'
        Width = 70
      end>
  end
end
