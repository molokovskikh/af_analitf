inherited CommandFrame: TCommandFrame
  Width = 575
  Height = 374
  Align = alClient
  object Label1: TLabel
    Left = 456
    Top = 48
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 188
    Width = 575
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object ToolBar: TPanel
    Left = 0
    Top = 0
    Width = 575
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 1
      Width = 250
      Height = 24
      BevelOuter = bvNone
      Color = 16591631
      TabOrder = 0
      object btExecute: TSpeedButton
        Left = 1
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Execute'
        Flat = True
        Transparent = False
        OnClick = btExecuteClick
      end
      object btBreakExec: TSpeedButton
        Left = 167
        Top = 1
        Width = 82
        Height = 22
        Caption = 'Break'
        Enabled = False
        Flat = True
        Transparent = False
        OnClick = btBreakExecClick
      end
      object btExecInThread: TSpeedButton
        Left = 84
        Top = 1
        Width = 82
        Height = 22
        Hint = 
          'Assing a long-drawn command to memo (e.g. `SELECT SLEEP(10);`) a' +
          'nd push this button.'
        Caption = 'Exec in thread'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        Transparent = False
        OnClick = btExecInThreadClick
      end
    end
  end
  object meSQL: TMemo
    Left = 0
    Top = 26
    Width = 575
    Height = 162
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'INSERT INTO DEPT VALUES (11,'#39'ACCOUNTING'#39','#39'NEW YORK'#39')')
    ParentFont = False
    TabOrder = 1
  end
  object meResult: TMemo
    Left = 0
    Top = 191
    Width = 575
    Height = 183
    TabStop = False
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpVariable
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
  object MyCommand: TMyCommand
    Connection = MyDACForm.MyConnection
    AfterExecute = MySQLAfterExecute
    Left = 109
    Top = 42
  end
end
