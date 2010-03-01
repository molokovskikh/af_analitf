object frmMain: TfrmMain
  Left = 382
  Top = 275
  Width = 612
  Height = 407
  Caption = 'Main'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnChange: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Change'
    TabOrder = 0
    OnClick = btnChangeClick
  end
  object btnGetNotFoundAdapter: TButton
    Left = 24
    Top = 72
    Width = 153
    Height = 25
    Caption = 'GetNotFoundAdapter'
    TabOrder = 1
    OnClick = btnGetNotFoundAdapterClick
  end
  object btnGetRoute: TButton
    Left = 32
    Top = 120
    Width = 75
    Height = 25
    Caption = 'GetRoute'
    TabOrder = 2
    OnClick = btnGetRouteClick
  end
  object btnNetworkCount: TButton
    Left = 32
    Top = 168
    Width = 145
    Height = 25
    Caption = 'NetworkCount'
    TabOrder = 3
    OnClick = btnNetworkCountClick
  end
  object btnGetPath: TButton
    Left = 240
    Top = 24
    Width = 75
    Height = 25
    Caption = 'GetPath'
    TabOrder = 4
    OnClick = btnGetPathClick
  end
  object btnReadAndWrite: TButton
    Left = 240
    Top = 72
    Width = 113
    Height = 25
    Caption = 'ReadAndWrite'
    TabOrder = 5
    OnClick = btnReadAndWriteClick
  end
  object mLog: TMemo
    Left = 0
    Top = 232
    Width = 604
    Height = 147
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object btnGetActiveRas: TButton
    Left = 240
    Top = 128
    Width = 161
    Height = 25
    Caption = 'GetActiveRas'
    TabOrder = 7
    OnClick = btnGetActiveRasClick
  end
  object btnTestUpdateRASIp: TButton
    Left = 240
    Top = 176
    Width = 169
    Height = 25
    Caption = 'TestUpdateRASIp'
    TabOrder = 8
    OnClick = btnTestUpdateRASIpClick
  end
  object btnUpdateRASIp: TButton
    Left = 440
    Top = 24
    Width = 121
    Height = 25
    Caption = 'UpdateRASIp'
    TabOrder = 9
    OnClick = btnUpdateRASIpClick
  end
end
