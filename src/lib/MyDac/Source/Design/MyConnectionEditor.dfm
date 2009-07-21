inherited MyConnectionEditorForm: TMyConnectionEditorForm
  ClientHeight = 344
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TPageControl
    Height = 295
    OnChanging = PageControlChanging
    inherited shConnect: TTabSheet
      inherited shRed: TShape
        Top = 238
      end
      inherited shYellow: TShape
        Top = 238
      end
      inherited shGreen: TShape
        Top = 238
      end
      object lbExisting: TLabel [3]
        Left = 24
        Top = 13
        Width = 36
        Height = 13
        Caption = 'Existing'
      end
      inherited Panel: TPanel
        Top = 41
        Height = 180
        object lbDatabase: TLabel [3]
          Left = 16
          Top = 118
          Width = 46
          Height = 13
          Caption = 'Database'
        end
        object lbPort: TLabel [4]
          Left = 16
          Top = 149
          Width = 19
          Height = 13
          Caption = 'Port'
        end
        object edDatabase: TComboBox
          Left = 104
          Top = 114
          Width = 153
          Height = 21
          ItemHeight = 13
          TabOrder = 3
          OnDropDown = edDatabaseDropDown
          OnExit = edDatabaseExit
        end
        object edPort: TEdit
          Left = 104
          Top = 145
          Width = 153
          Height = 21
          TabOrder = 4
          Text = '3306'
          OnChange = edPortChange
          OnExit = edPortExit
        end
      end
      inherited btConnect: TButton
        Top = 233
        TabOrder = 4
      end
      inherited btDisconnect: TButton
        Top = 233
        TabOrder = 5
      end
      inherited cbLoginPrompt: TCheckBox
        Top = 41
      end
      object cbDirect: TCheckBox
        Left = 300
        Top = 65
        Width = 121
        Height = 17
        Caption = 'Direct'
        TabOrder = 2
        OnClick = cbDirectClick
      end
      object cbEmbedded: TCheckBox
        Left = 300
        Top = 89
        Width = 121
        Height = 17
        Caption = 'Embedded'
        TabOrder = 3
        OnClick = cbEmbeddedClick
      end
      object cbExisting: TComboBox
        Left = 80
        Top = 9
        Width = 233
        Height = 21
        ItemHeight = 13
        Style = csDropDownList
        TabOrder = 6
        OnChange = cbExistingChange
      end
    end
    object shEmbParams: TTabSheet [1]
      Caption = 'Params'
      ImageIndex = 3
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 89
        Height = 13
        Hint = 'The path to the MySQL installation directory (--basedir )'
        AutoSize = False
        Caption = 'MySQL base path'
      end
      object Label7: TLabel
        Left = 8
        Top = 32
        Width = 89
        Height = 13
        Hint = 'The path to the data directory (--datadir )'
        AutoSize = False
        Caption = 'Path to data'
      end
      object Label8: TLabel
        Left = 8
        Top = 56
        Width = 89
        Height = 13
        Hint = 
          'The path of the directory to use for creating temporary files (-' +
          '-tmpdir)'
        AutoSize = False
        Caption = 'Path to temp'
      end
      object Label9: TLabel
        Left = 8
        Top = 80
        Width = 89
        Height = 13
        Hint = 
          'The directory where character sets are installed (--character-se' +
          'ts-dir)'
        AutoSize = False
        Caption = 'Path to charsets'
      end
      object Label10: TLabel
        Left = 8
        Top = 104
        Width = 89
        Height = 13
        Hint = 'Client error messages in given language (--language)'
        AutoSize = False
        Caption = 'Language'
      end
      object Label12: TLabel
        Left = 227
        Top = 128
        Width = 49
        Height = 13
        Hint = 'The index file for binary log filenames (--log-bin-index)'
        AutoSize = False
        Caption = 'index'
      end
      object Label11: TLabel
        Left = 8
        Top = 128
        Width = 49
        Height = 13
        Hint = 'The binary log file (--log-bin)'
        AutoSize = False
        Caption = 'Binary log'
      end
      object edBaseDir: TEdit
        Left = 104
        Top = 8
        Width = 313
        Height = 21
        TabOrder = 0
        Text = 'edBaseDir'
      end
      object edDataDir: TEdit
        Left = 104
        Top = 32
        Width = 313
        Height = 21
        TabOrder = 3
        Text = 'edDataDir'
      end
      object edTempDir: TEdit
        Left = 104
        Top = 56
        Width = 313
        Height = 21
        TabOrder = 4
        Text = 'edTempDir'
      end
      object edCharsetsDir: TEdit
        Left = 104
        Top = 80
        Width = 313
        Height = 21
        TabOrder = 7
        Text = 'edCharsetsDir'
      end
      object edLanguage: TEdit
        Left = 104
        Top = 104
        Width = 313
        Height = 21
        TabOrder = 8
        Text = 'edLanguage'
      end
      object btBinaryLogIndex: TBitBtn
        Left = 397
        Top = 128
        Width = 17
        Height = 21
        TabOrder = 10
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object edBinaryLogIndex: TEdit
        Left = 264
        Top = 128
        Width = 153
        Height = 21
        TabOrder = 11
        Text = 'edBinaryLogIndex'
      end
      object btBinaryLog: TBitBtn
        Left = 197
        Top = 128
        Width = 17
        Height = 21
        TabOrder = 12
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object edBinaryLog: TEdit
        Left = 64
        Top = 128
        Width = 153
        Height = 21
        TabOrder = 13
        Text = 'edBinaryLog'
      end
      object cbInnoDBSafeBinLog: TCheckBox
        Left = 8
        Top = 152
        Width = 313
        Height = 17
        Hint = 
          'Adds consistency guarantees between the content of InnoDB tables' +
          ' and the binary log (--innodb-safe-binlog)'
        Caption = 'More safe InnoDB storage'
        TabOrder = 14
      end
      object cbFlush: TCheckBox
        Left = 8
        Top = 168
        Width = 313
        Height = 17
        Hint = 'Flush all changes to disk after each SQL statement (--flush)'
        Caption = 'Flush all changes to disk after each SQL statement'
        TabOrder = 15
      end
      object cbSkipInnoDB: TCheckBox
        Left = 8
        Top = 184
        Width = 313
        Height = 17
        Hint = 
          'This saves memory and disk space and might speed up some operati' +
          'ons. Do not use this option if you require InnoDB tables (--skip' +
          '-innodb)'
        Caption = 'Disable the InnoDB storage engine'
        TabOrder = 16
      end
      object cbSkipGrantTables: TCheckBox
        Left = 8
        Top = 200
        Width = 313
        Height = 17
        Hint = 
          'This option causes the server not to use the privilege system at' +
          ' all (--skip-grant-tables)'
        Caption = 'Skip using the privilege system'
        TabOrder = 17
      end
      object cbLogShortFormat: TCheckBox
        Left = 8
        Top = 216
        Width = 313
        Height = 17
        Hint = 
          'Log less information to the log files (update log, binary update' +
          ' log, and slow queries log, whatever log has been activated) (--' +
          'log-short-format)'
        Caption = 'Log less information to the log files'
        TabOrder = 18
      end
      object btAdvanced: TButton
        Left = 336
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Advanced'
        TabOrder = 19
        OnClick = btAdvancedClick
      end
      object btLanguage: TBitBtn
        Left = 398
        Top = 104
        Width = 17
        Height = 21
        TabOrder = 9
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object btCharsetsDir: TBitBtn
        Left = 398
        Top = 80
        Width = 17
        Height = 21
        TabOrder = 6
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object btTempDir: TBitBtn
        Left = 398
        Top = 56
        Width = 17
        Height = 21
        TabOrder = 5
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object btDataDir: TBitBtn
        Left = 398
        Top = 32
        Width = 17
        Height = 21
        TabOrder = 2
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
      object btBaseDir: TBitBtn
        Left = 398
        Top = 8
        Width = 17
        Height = 21
        TabOrder = 1
        Visible = False
        Glyph.Data = {
          FE000000424DFE0000000000000076000000280000000D000000110000000100
          0400000000008800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFF0FF0FF0FF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFF
          F000}
      end
    end
    inherited shInfo: TTabSheet
      inherited meInfo: TMemo
        Height = 251
        Font.Height = -11
        Font.Name = 'Courier New'
        ParentFont = False
        ScrollBars = ssBoth
        WordWrap = False
      end
    end
    inherited shAbout: TTabSheet
      inherited Label1: TLabel
        Width = 345
        Caption = 'Data Access Components for MySQL'
      end
      inherited lbWeb: TLabel
        Width = 109
        Caption = 'www.devart.com/mydac'
      end
      inherited lbMail: TLabel
        Width = 88
        Caption = 'mydac@devart.com'
      end
    end
  end
  inherited btClose: TButton
    Top = 312
  end
end
