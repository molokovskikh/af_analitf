object frameAutoComment: TframeAutoComment
  Left = 0
  Top = 0
  Width = 168
  Height = 61
  TabOrder = 0
  OnResize = FrameResize
  object gbAutoComment: TGroupBox
    Left = 0
    Top = 0
    Width = 168
    Height = 61
    Align = alClient
    Caption = ' '#1040#1074#1090#1086#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
    TabOrder = 0
    DesignSize = (
      168
      61)
    object eAutoComment: TEdit
      Left = 16
      Top = 24
      Width = 137
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = eAutoCommentChange
      OnKeyDown = eAutoCommentKeyDown
    end
  end
end