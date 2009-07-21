object fmCustomConnect: TfmCustomConnect
  Left = 281
  Top = 127
  Width = 296
  Height = 263
  HorzScrollBar.Range = 203
  VertScrollBar.Range = 170
  ActiveControl = edUsername
  AutoScroll = False
  Caption = 'My Connect'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 11
  Font.Name = 'Tahoma'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 6
    Top = 6
    Width = 273
    Height = 220
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Bevel1: TBevel
      Left = 1
      Top = 173
      Width = 270
      Height = 5
      Shape = bsBottomLine
    end
    object lbUsername: TLabel
      Left = 16
      Top = 20
      Width = 54
      Height = 13
      Caption = 'Username'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = 8
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object lbPassword: TLabel
      Left = 16
      Top = 54
      Width = 52
      Height = 13
      Caption = 'Password'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = 8
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object lbServer: TLabel
      Left = 16
      Top = 88
      Width = 37
      Height = 13
      Caption = 'Server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = 8
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object lbDatabase: TLabel
      Left = 16
      Top = 156
      Width = 52
      Height = 13
      Caption = 'Database'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = 8
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object lbPort: TLabel
      Left = 16
      Top = 122
      Width = 25
      Height = 13
      Caption = 'Port'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = 8
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object edUsername: TEdit
      Left = 104
      Top = 16
      Width = 153
      Height = 21
      TabOrder = 0
    end
    object edServer: TComboBox
      Left = 104
      Top = 84
      Width = 153
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
    object edPort: TEdit
      Left = 104
      Top = 118
      Width = 153
      Height = 21
      TabOrder = 2
    end
    object btConnect: TBitBtn
      Left = 82
      Top = 185
      Width = 82
      Height = 24
      Caption = 'OK'
      Default = True
      TabOrder = 4
      OnClick = btConnectClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object btCancel: TBitBtn
      Left = 175
      Top = 185
      Width = 82
      Height = 24
      TabOrder = 5
      Kind = bkCancel
    end
    object edDatabase: TEdit
      Left = 104
      Top = 152
      Width = 153
      Height = 21
      TabOrder = 3
    end
    object edPassword: TMaskEdit
      Left = 104
      Top = 50
      Width = 153
      Height = 21
      PasswordChar = '*'
      TabOrder = 6
    end
  end
end
