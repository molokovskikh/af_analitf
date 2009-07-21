inherited fmInheritedConnect: TfmInheritedConnect
  Left = 359
  Top = 212
  Caption = 'Inherited Connect'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel
    BevelOuter = bvNone
    inherited lbUsername: TLabel
      Width = 80
      Font.Color = clNavy
      Font.Style = [fsBold]
      ParentFont = False
    end
    inherited lbPassword: TLabel
      Width = 55
      Font.Color = clNavy
      Font.Style = [fsBold]
      ParentFont = False
    end
    inherited lbServer: TLabel
      Width = 38
      Font.Color = clNavy
      Font.Style = [fsBold]
      ParentFont = False
    end
    inherited lbPort: TLabel
      Font.Color = clNavy
      Font.Style = [fsBold]
      ParentFont = False
    end
    inherited lbDatabase: TLabel
      Font.Color = clNavy
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  inherited btConnect: TButton
    Left = 98
    Width = 82
    Height = 22
  end
  inherited btCancel: TButton
    Left = 193
    Width = 82
    Height = 22
  end
end
