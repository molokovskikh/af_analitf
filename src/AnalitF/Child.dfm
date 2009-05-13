object ChildForm: TChildForm
  Left = 380
  Top = 296
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'ChildForm'
  ClientHeight = 449
  ClientWidth = 684
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object tCheckVolume: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tCheckVolumeTimer
    Left = 112
    Top = 56
  end
end
