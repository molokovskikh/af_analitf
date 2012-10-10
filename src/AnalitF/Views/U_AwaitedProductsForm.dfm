inherited AwaitedProductsForm: TAwaitedProductsForm
  Left = 330
  Top = 201
  ActiveControl = dbgAwaitedProducts
  Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1087#1086#1079#1080#1094#1080#1080
  ClientHeight = 475
  PixelsPerInch = 96
  TextHeight = 13
  object pButtons: TPanel [0]
    Left = 0
    Top = 0
    Width = 684
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object dbgAwaitedProducts: TToughDBGrid [1]
    Tag = 16
    Left = 0
    Top = 41
    Width = 684
    Height = 434
    Align = alClient
    AutoFitColWidths = True
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
    SearchPosition = spBottom
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Mnn'
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 136
      end>
  end
end
