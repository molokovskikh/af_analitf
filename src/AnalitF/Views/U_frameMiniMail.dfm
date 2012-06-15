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
end
