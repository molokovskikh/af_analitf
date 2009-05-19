object SQLEditFrame: TSQLEditFrame
  Left = 0
  Top = 0
  Width = 533
  Height = 311
  TabOrder = 0
  TabStop = True
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 311
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 322
      Top = 0
      Width = 6
      Height = 311
      Cursor = crHSplit
      Align = alRight
      ResizeStyle = rsUpdate
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 322
      Height = 311
      Align = alClient
      BevelOuter = bvNone
      BevelWidth = 5
      Caption = 'Panel3'
      TabOrder = 0
      object RichEdit1: TRichEdit
        Left = 0
        Top = 31
        Width = 322
        Height = 280
        Align = alClient
        Lines.Strings = (
          'RichEdit1')
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 322
        Height = 31
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object Button3: TButton
          Left = 4
          Top = 3
          Width = 74
          Height = 25
          Caption = 'Execute'
          TabOrder = 0
        end
        object Check: TButton
          Left = 81
          Top = 3
          Width = 74
          Height = 25
          Caption = 'Check'
          TabOrder = 1
        end
        object Button1: TButton
          Left = 159
          Top = 3
          Width = 74
          Height = 25
          Caption = 'Query plan'
          TabOrder = 2
        end
      end
    end
    object Panel3: TPanel
      Left = 328
      Top = 0
      Width = 205
      Height = 311
      Align = alRight
      BevelOuter = bvNone
      BevelWidth = 5
      BiDiMode = bdLeftToRight
      Caption = 'Panel2'
      ParentBiDiMode = False
      TabOrder = 1
      object gridParams: TDBGridEh
        Left = 0
        Top = 0
        Width = 205
        Height = 311
        Align = alClient
        ColumnDefValues.AlwaysShowEditButton = True
        ContraColCount = 0
        DataSource = dsParams
        Flat = True
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        VTitleMargin = 4
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ParName'
            Footers = <>
            Title.Caption = 'Params|Name'
            Width = 77
          end
          item
            DropDownRows = 37
            EditButtons = <>
            FieldName = 'ParType'
            Footers = <>
            PickList.Strings = (
              'ftUnknown'
              'ftString'
              'ftFixedChar'
              'ftMemo'
              'ftAdt'
              'ftSmallint'
              'ftWord'
              'ftAutoInc'
              'ftInteger'
              'ftTime'
              'ftDate'
              'ftDateTime'
              'ftBCD'
              'ftFMTBCD'
              'ftCurrency'
              'ftFloat'
              'ftTimeStamp'
              'ftBoolean'
              'ftBytes'
              'ftVarBytes'
              'ftBlob'
              'ftGraphic'
              'ftTypedBinary'
              'ftOraBlob'
              'ftOraClob'
              'ftArray'
              'ftDataSet'
              'ftReference'
              'ftCursor')
            Title.Caption = 'Params|Type'
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'ParValue'
            Footers = <>
            Title.Caption = 'Params|Value'
            Width = 38
          end>
      end
    end
  end
  object Panel8: TPanel
    Left = 514
    Top = 1
    Width = 18
    Height = 19
    Anchors = [akTop, akRight]
    Caption = 'Panel8'
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 1
      Top = 1
      Width = 16
      Height = 17
      Anchors = [akLeft, akTop, akRight, akBottom]
      Flat = True
      Glyph.Data = {
        B6000000424DB600000000000000760000002800000010000000080000000100
        0400000000004000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFF0FFFFFF0FFFFFFF00FFFFFF00FFFFF000FFFFFF000FFFF000FFFFFF0
        00FFFFF00FFFFFF00FFFFFFF0FFFFFF0FFFFFFFFFFFFFFFFFFFF}
      NumGlyphs = 2
      Transparent = False
      OnClick = SpeedButton2Click
    end
  end
  object ImageList1: TImageList
    Height = 8
    Width = 8
    Left = 260
    Top = 44
    Bitmap = {
      494C010102000400040008000800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000200000000800000001002000000000000004
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000020000000080000000100010000000000200000000000000000000000
      000000000000000000000000FFFFFF00FFFF0000F7EF0000E7E70000C7E30000
      C7E30000E7E70000F7EF0000FFFF000000000000000000000000000000000000
      000000000000}
  end
  object dsParams: TDataSource
    DataSet = mtParams
    Left = 320
    Top = 61
  end
  object mtParams: TMemTableEh
    CachedUpdates = True
    Params = <>
    Left = 346
    Top = 61
    object mtParamsParName: TStringField
      DisplayWidth = 10
      FieldName = 'ParName'
      Size = 255
    end
    object mtParamsParType: TStringField
      DefaultExpression = 'ftString'
      DisplayWidth = 13
      FieldName = 'ParType'
      Size = 255
    end
    object mtParamsParValue: TStringField
      DisplayWidth = 14
      FieldName = 'ParValue'
      Size = 255
    end
  end
end
