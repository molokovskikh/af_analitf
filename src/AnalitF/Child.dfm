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
  object tmrOverCostHide: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrOverCostHideTimer
    Left = 168
    Top = 56
  end
  object sh2BlockTemplate: TStrHolder
    Capacity = 12
    Macros = <
      item
        Name = 'fileName'
      end>
    Left = 216
    Top = 55
    InternalVer = 1
    StrData = (
      ''
      
        '3c21444f43545950452048544d4c205055424c494320222d2f2f5733432f2f44' +
        '54442048544d4c20342e3031205472616e736974696f6e616c2f2f454e223e'
      '3c68746d6c3e'
      '3c686561643e'
      '3c7469746c653e556e7469746c656420446f63756d656e743c2f7469746c653e'
      
        '3c6d65746120687474702d65717569763d22436f6e74656e742d547970652220' +
        '636f6e74656e743d22746578742f68746d6c3b20636861727365743d4b4f4938' +
        '2d52223e'
      '3c2f686561643e'
      ''
      
        '3c626f6479207374796c653d2270616464696e673a303b6d617267696e3a303b' +
        '223e'
      
        '3c64697620616c69676e3d2263656e74657222207374796c653d227061646469' +
        '6e673a303b6d617267696e3a303b666f6e742d73697a653a303b223e3c696d67' +
        '207372633d2566696c654e616d652077696474683d2234383122206865696768' +
        '743d22313235223e203c2f6469763e'
      '3c2f626f64793e'
      '3c2f68746d6c3e')
  end
end
