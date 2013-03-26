object frameMiniMail: TframeMiniMail
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  OnResize = FrameResize
  object tmrSearch: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmrSearchTimer
    Left = 58
    Top = 53
  end
  object tmrRunRequestAttachments: TTimer
    Enabled = False
    Interval = 350
    OnTimer = tmrRunRequestAttachmentsTimer
    Left = 104
    Top = 48
  end
  object tmrUpdateStatus: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrUpdateStatusTimer
    Left = 144
    Top = 40
  end
end
