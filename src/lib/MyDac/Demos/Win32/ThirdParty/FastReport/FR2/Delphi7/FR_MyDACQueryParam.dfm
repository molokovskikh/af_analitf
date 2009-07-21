object frMyDACParamsForm: TfrMyDACParamsForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'frMyDACParamsForm'
  ClientHeight = 165
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 397
    Height = 125
    Caption = 'Parameters'
    TabOrder = 0
    object Label2: TLabel
      Tag = 1001
      Left = 148
      Top = 36
      Width = 46
      Height = 13
      Caption = '&Data type'
      FocusControl = TypeCB
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 28
      Height = 13
      Caption = '&Name'
      FocusControl = ParamsLB
    end
    object ParamsLB: TListBox
      Left = 8
      Top = 32
      Width = 129
      Height = 85
      HelpContext = 55
      ItemHeight = 13
      TabOrder = 0
      OnClick = ParamsLBClick
    end
    object TypeCB: TComboBox
      Tag = 1004
      Left = 236
      Top = 32
      Width = 153
      Height = 21
      HelpContext = 138
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = TypeCBChange
    end
    object ValueRB: TRadioButton
      Left = 148
      Top = 66
      Width = 85
      Height = 17
      HelpContext = 157
      Caption = '&Value:'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = ValueRBClick
    end
    object AssignRB: TRadioButton
      Left = 148
      Top = 88
      Width = 241
      Height = 17
      HelpContext = 175
      Caption = 'Assign value from &master dataset'
      TabOrder = 3
      OnClick = AssignRBClick
    end
    object ValueE: TfrComboEdit
      Tag = 1005
      Left = 236
      Top = 64
      Width = 153
      Height = 21
      HelpContext = 147
      Style = csSimple
      ItemHeight = 13
      TabOrder = 4
      OnExit = ValueEExit
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        0400000000006000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00707777777777
        0000770777777777000077087007007700007780778007770000778087700077
        0000777087007807000077780777777700007700000777770000777708777777
        0000777700780777000077777000777700007777777777770000}
      OnButtonClick = VarSBClick
    end
  end
  object Button1: TButton
    Left = 246
    Top = 136
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 326
    Top = 136
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
