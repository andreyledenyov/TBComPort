object MainForm: TMainForm
  Left = 192
  Top = 108
  Width = 600
  Height = 450
  Caption = 'BComPort_Terminal'
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object lbPort: TLabel
      Left = 152
      Top = 4
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object lbBaud: TLabel
      Left = 224
      Top = 4
      Width = 48
      Height = 13
      Caption = 'BaudRate'
    end
    object Bevel1: TBevel
      Left = 8
      Top = 44
      Width = 576
      Height = 5
      Align = alBottom
      Shape = bsBottomLine
    end
    object cbPort: TComboBox
      Left = 152
      Top = 18
      Width = 61
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbPortChange
    end
    object cbBaud: TComboBox
      Left = 224
      Top = 18
      Width = 69
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 3
      OnChange = cbBaudChange
      Items.Strings = (
        'Custom'
        '110'
        '300'
        '600'
        '1200'
        '2400'
        '4800'
        '9600'
        '14400'
        '19200'
        '38400'
        '56000'
        '57600'
        '115200'
        '128000'
        '230400'
        '256000'
        '460800'
        '500000'
        '576000'
        '921600'
        '1000000'
        '1152000'
        '1500000'
        '2000000'
        '2500000'
        '3000000'
        '3500000'
        '4000000')
    end
    object btnSettings: TButton
      Left = 304
      Top = 9
      Width = 57
      Height = 30
      Caption = 'Settings'
      TabOrder = 4
      OnClick = btnSettingsClick
    end
    object btnOpen: TButton
      Left = 8
      Top = 9
      Width = 61
      Height = 30
      Caption = 'Open'
      TabOrder = 0
      OnClick = btnOpenClick
    end
    object btnClose: TButton
      Left = 80
      Top = 9
      Width = 61
      Height = 30
      Caption = 'Close'
      Enabled = False
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object cbDTR: TCheckBox
      Left = 372
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Set_DTR'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbDTRClick
    end
    object cbRTS: TCheckBox
      Left = 444
      Top = 16
      Width = 65
      Height = 16
      Caption = 'Set_RTS'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = cbRTSClick
    end
    object cbBreak: TCheckBox
      Left = 516
      Top = 16
      Width = 72
      Height = 16
      Caption = 'Set_Break'
      TabOrder = 7
      OnClick = cbBreakClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 386
    Width = 592
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object cbSend: TComboBox
      Left = 8
      Top = 3
      Width = 409
      Height = 24
      DropDownCount = 12
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 1
      OnKeyDown = cbSendKeyDown
      OnKeyPress = cbSendKeyPress
      OnKeyUp = cbSendKeyUp
    end
    object cbHx: TCheckBox
      Left = 428
      Top = 7
      Width = 41
      Height = 17
      Caption = 'Hex'
      TabOrder = 2
    end
    object btnSend: TButton
      Left = 472
      Top = 3
      Width = 45
      Height = 25
      Caption = 'Send'
      TabOrder = 0
      OnClick = btnSendClick
    end
    object btnSF: TButton
      Left = 527
      Top = 3
      Width = 57
      Height = 25
      Caption = 'Send_File'
      TabOrder = 3
      OnClick = btnSFClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 85
    Width = 592
    Height = 301
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 2
    object Memo: TMemo
      Left = 8
      Top = 8
      Width = 576
      Height = 285
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 57
    Width = 592
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lbCTS: TLabel
      Left = 372
      Top = 2
      Width = 34
      Height = 22
      Caption = 'CTS'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentFont = False
    end
    object lbDSR: TLabel
      Left = 436
      Top = 2
      Width = 35
      Height = 22
      Caption = 'DSR'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentFont = False
    end
    object lbRI: TLabel
      Left = 496
      Top = 2
      Width = 18
      Height = 22
      Caption = 'RI'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentFont = False
    end
    object lbRLSD: TLabel
      Left = 540
      Top = 2
      Width = 45
      Height = 22
      Caption = 'RLSD'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -15
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentFont = False
    end
    object btnClear: TButton
      Left = 8
      Top = 1
      Width = 61
      Height = 25
      Caption = 'Clear'
      TabOrder = 0
      OnClick = btnClearClick
    end
    object btnSave: TButton
      Left = 80
      Top = 1
      Width = 61
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object cbHex: TCheckBox
      Left = 152
      Top = 5
      Width = 69
      Height = 17
      Caption = 'Hex_view'
      TabOrder = 2
    end
    object btnTable: TButton
      Left = 256
      Top = 1
      Width = 75
      Height = 25
      Caption = 'ASCII Table'
      TabOrder = 3
      OnClick = btnTableClick
    end
  end
  object CP: TBComPort
    BaudRate = br38400
    ByteSize = bs8
    CustomBaudRate = 38400
    DataPacket.Enabled = False
    DataPacket.IncludeStrings = True
    DataPacket.MaxBufferSize = 1024
    DataPacket.PacketSize = 0
    InBufSize = 4096
    OutBufSize = 4096
    Parity = paNone
    Port = 'COM1'
    StopBits = sb1
    SyncMethod = smThreadSync
    ThreadPriority = tpHighest
    Timeouts.ReadInterval = 1
    Timeouts.ReadTotalMultiplier = 0
    Timeouts.ReadTotalConstant = 10
    Timeouts.WriteTotalMultiplier = 1
    Timeouts.WriteTotalConstant = 100
    OnCTSChange = CPCTSChange
    OnDSRChange = CPCTSChange
    OnRing = CPRing
    OnRLSDChange = CPCTSChange
    OnRxChar = CPRxChar
    Left = 20
    Top = 105
  end
end
