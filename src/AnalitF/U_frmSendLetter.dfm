object frmSendLetter: TfrmSendLetter
  Left = 423
  Top = 164
  Width = 373
  Height = 432
  Caption = #1055#1080#1089#1100#1084#1086' '#1074' '#1040#1050' "'#1048#1085#1092#1086#1088#1091#1084'"'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    357
    396)
  PixelsPerInch = 96
  TextHeight = 13
  object cbAddLogs: TCheckBox
    Left = 8
    Top = 215
    Width = 348
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1072#1081#1083#1099' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object btnSend: TButton
    Left = 187
    Top = 363
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 275
    Top = 363
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    ModalResult = 2
    TabOrder = 4
  end
  object gbMessage: TGroupBox
    Left = 0
    Top = 0
    Width = 365
    Height = 211
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' '#1057#1086#1086#1073#1097#1077#1085#1080#1077' '
    TabOrder = 0
    DesignSize = (
      365
      211)
    object lBody: TLabel
      Left = 8
      Top = 56
      Width = 74
      Height = 13
      Caption = #1058#1077#1082#1089#1090' '#1087#1080#1089#1100#1084#1072':'
    end
    object leSubject: TLabeledEdit
      Left = 8
      Top = 32
      Width = 348
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 71
      EditLabel.Height = 13
      EditLabel.Caption = #1058#1077#1084#1072' '#1087#1080#1089#1100#1084#1072':'
      TabOrder = 0
    end
    object mBody: TMemo
      Left = 8
      Top = 72
      Width = 348
      Height = 134
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object gbAttach: TGroupBox
    Left = 0
    Top = 231
    Width = 365
    Height = 121
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' '#1042#1083#1086#1078#1077#1085#1085#1099#1077' '#1092#1072#1081#1083#1099' '
    TabOrder = 2
    DesignSize = (
      365
      121)
    object lbFiles: TListBox
      Left = 8
      Top = 16
      Width = 255
      Height = 97
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnAddFile: TButton
      Left = 275
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = btnAddFileClick
    end
    object btnDelFile: TButton
      Left = 275
      Top = 56
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDelFileClick
    end
  end
  object odAttach: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    InitialDir = '.'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing, ofForceShowHidden]
    Left = 8
    Top = 376
  end
end
