object DM: TDM
  OldCreateOrder = False
  Left = 184
  Top = 103
  Height = 250
  Width = 225
  object Connection: TMyConnection
    AfterConnect = ConnectionAfterConnect
    BeforeConnect = ConnectionBeforeConnect
    AfterDisconnect = ConnectionAfterDisconnect
    OnConnectionLost = ConnectionConnectionLost
    Left = 40
    Top = 24
  end
end
