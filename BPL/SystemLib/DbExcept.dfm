object DbEngineErrorDlg: TDbEngineErrorDlg
  Left = 348
  Top = 103
  ActiveControl = OKBtn
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Database Engine Error'
  ClientHeight = 256
  ClientWidth = 296
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  HelpFile = 'dbexplr3.hlp'
  Icon.Data = {
    0000010002002020100000000000E80200002600000020200200000000003001
    00000E0300002800000020000000400000000100040000000000000200000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000008888888888888888888888888000000
    88888888888888888888888888800030000000000000000000000008888803BB
    BBBBBBBBBBBBBBBBBBBBBB7088883BBBBBBBBBBBBBBBBBBBBBBBBBB708883BBB
    BBBBBBBBBBBBBBBBBBBBBBBB08883BBBBBBBBBBBB7007BBBBBBBBBBB08803BBB
    BBBBBBBBB0000BBBBBBBBBB7088003BBBBBBBBBBB0000BBBBBBBBBB0880003BB
    BBBBBBBBB7007BBBBBBBBB708800003BBBBBBBBBBBBBBBBBBBBBBB088000003B
    BBBBBBBBBB0BBBBBBBBBB70880000003BBBBBBBBB707BBBBBBBBB08800000003
    BBBBBBBBB303BBBBBBBB7088000000003BBBBBBBB000BBBBBBBB088000000000
    3BBBBBBB70007BBBBBB708800000000003BBBBBB30003BBBBBB0880000000000
    03BBBBBB00000BBBBB70880000000000003BBBBB00000BBBBB08800000000000
    003BBBBB00000BBBB7088000000000000003BBBB00000BBBB088000000000000
    0003BBBB00000BBB708800000000000000003BBB70007BBB0880000000000000
    00003BBBBBBBBBB70880000000000000000003BBBBBBBBB08800000000000000
    000003BBBBBBBB7088000000000000000000003BBBBBBB088000000000000000
    0000003BBBBBB708800000000000000000000003BBBBB0880000000000000000
    00000003BBBB70800000000000000000000000003BB700000000000000000000
    0000000003330000000000000000F8000003F0000001C0000000800000000000
    00000000000000000001000000018000000380000003C0000007C0000007E000
    000FE000000FF000001FF000001FF800003FF800003FFC00007FFC00007FFE00
    00FFFE0000FFFF0001FFFF0001FFFF8003FFFF8003FFFFC007FFFFC007FFFFE0
    0FFFFFE01FFFFFF07FFFFFF8FFFF280000002000000040000000010001000000
    0000800000000000000000000000000000000000000000000000FFFFFF000000
    000000000000000000003FFFFFC07FFFFFE07FFFFFF07FFCFFF07FF87FE03FF8
    7FE03FFCFFC01FFFFFC01FFDFF800FFDFF800FFDFF0007F8FF0007F8FE0003F8
    FE0003F07C0001F07C0001F0780000F0780000F070000078F000007FE000003F
    E000003FC000001FC000001F8000000F8000000F00000006000000000000FFFF
    FFFFFFFFFFFFC000001F8000000F000000070000000700000007000000078000
    000F8000000FC000001FC000001FE000003FE000003FF000007FF000007FF800
    00FFF80000FFFC0001FFFC0001FFFE0003FFFE0003FFFF0007FFFF0007FFFF80
    0FFFFF800FFFFFC01FFFFFC01FFFFFE03FFFFFE03FFFFFF07FFFFFF8FFFF}
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BasicPanel: TPanel
    Left = 0
    Top = 0
    Width = 296
    Height = 73
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ErrorText: TLabel
      Left = 49
      Top = 8
      Width = 239
      Height = 65
      Align = alClient
      Caption = 'ErrorText'
      WordWrap = True
    end
    object IconPanel: TPanel
      Left = 0
      Top = 8
      Width = 49
      Height = 65
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object IconImage: TImage
        Left = 6
        Top = 2
        Width = 34
        Height = 34
        Picture.Data = {
          055449636F6E0000010002002020100000000000E80200002600000020200200
          00000000300100000E0300002800000020000000400000000100040000000000
          0002000000000000000000000000000000000000000000000000800000800000
          00808000800000008000800080800000C0C0C000808080000000FF0000FF0000
          00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000008888888888888888888
          8888880000008888888888888888888888888880003000000000000000000000
          0008888803BBBBBBBBBBBBBBBBBBBBBBBB7088883BBBBBBBBBBBBBBBBBBBBBBB
          BBB708883BBBBBBBBBBBBBBBBBBBBBBBBBBB08883BBBBBBBBBBBB7007BBBBBBB
          BBBB08803BBBBBBBBBBBB0000BBBBBBBBBB7088003BBBBBBBBBBB0000BBBBBBB
          BBB0880003BBBBBBBBBBB7007BBBBBBBBB708800003BBBBBBBBBBBBBBBBBBBBB
          BB088000003BBBBBBBBBBB0BBBBBBBBBB70880000003BBBBBBBBB707BBBBBBBB
          B08800000003BBBBBBBBB303BBBBBBBB7088000000003BBBBBBBB000BBBBBBBB
          0880000000003BBBBBBB70007BBBBBB708800000000003BBBBBB30003BBBBBB0
          88000000000003BBBBBB00000BBBBB70880000000000003BBBBB00000BBBBB08
          800000000000003BBBBB00000BBBB7088000000000000003BBBB00000BBBB088
          0000000000000003BBBB00000BBB708800000000000000003BBB70007BBB0880
          00000000000000003BBBBBBBBBB70880000000000000000003BBBBBBBBB08800
          000000000000000003BBBBBBBB7088000000000000000000003BBBBBBB088000
          0000000000000000003BBBBBB708800000000000000000000003BBBBB0880000
          00000000000000000003BBBB70800000000000000000000000003BB700000000
          0000000000000000000003330000000000000000F8000003F0000001C0000000
          80000000000000000000000000000001000000018000000380000003C0000007
          C0000007E000000FE000000FF000001FF000001FF800003FF800003FFC00007F
          FC00007FFE0000FFFE0000FFFF0001FFFF0001FFFF8003FFFF8003FFFFC007FF
          FFC007FFFFE00FFFFFE01FFFFFF07FFFFFF8FFFF280000002000000040000000
          0100010000000000800000000000000000000000000000000000000000000000
          FFFFFF000000000000000000000000003FFFFFC07FFFFFE07FFFFFF07FFCFFF0
          7FF87FE03FF87FE03FFCFFC01FFFFFC01FFDFF800FFDFF800FFDFF0007F8FF00
          07F8FE0003F8FE0003F07C0001F07C0001F0780000F0780000F070000078F000
          007FE000003FE000003FC000001FC000001F8000000F8000000F000000060000
          00000000FFFFFFFFFFFFFFFFC000001F8000000F000000070000000700000007
          000000078000000F8000000FC000001FC000001FE000003FE000003FF000007F
          F000007FF80000FFF80000FFFC0001FFFC0001FFFE0003FFFE0003FFFF0007FF
          FF0007FFFF800FFFFF800FFFFFC01FFFFFC01FFFFFE03FFFFFE03FFFFFF07FFF
          FFF8FFFF}
      end
    end
    object TopPanel: TPanel
      Left = 0
      Top = 0
      Width = 296
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object RightPanel: TPanel
      Left = 288
      Top = 8
      Width = 8
      Height = 65
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object DetailsPanel: TPanel
    Left = 0
    Top = 112
    Width = 296
    Height = 144
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 1
    object BDELabel: TLabel
      Left = 65
      Top = 8
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'BDE Error:'
    end
    object NativeLabel: TLabel
      Left = 56
      Top = 32
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = 'Server Error:'
    end
    object DbMessageText: TMemo
      Left = 8
      Top = 56
      Width = 281
      Height = 49
      TabStop = False
      Color = clBtnFace
      Lines.Strings = (
        'DbMessageText')
      ReadOnly = True
      TabOrder = 0
    end
    object DbResult: TEdit
      Left = 120
      Top = 8
      Width = 79
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 1
      Text = 'DbResult'
    end
    object DbCatSub: TEdit
      Left = 200
      Top = 8
      Width = 89
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
      Text = 'DbCatSub'
    end
    object NativeResult: TEdit
      Left = 120
      Top = 32
      Width = 169
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 3
      Text = 'NativeResult'
    end
    object BackBtn: TButton
      Left = 136
      Top = 112
      Width = 75
      Height = 25
      Caption = '< &Back'
      TabOrder = 4
      OnClick = BackClick
    end
    object NextBtn: TButton
      Left = 216
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Next >'
      Default = True
      TabOrder = 5
      OnClick = NextClick
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 73
    Width = 296
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object DetailsBtn: TButton
      Left = 135
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Details'
      TabOrder = 0
      OnClick = DetailsBtnClick
    end
    object OKBtn: TButton
      Left = 215
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
  end
end
