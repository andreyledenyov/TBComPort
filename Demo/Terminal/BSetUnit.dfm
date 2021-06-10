object SetForm: TSetForm
  Left = 794
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 144
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbCustom: TLabel
    Left = 12
    Top = 8
    Width = 83
    Height = 13
    Caption = 'CustomBaudRate'
  end
  object lbByteSize: TLabel
    Left = 112
    Top = 8
    Width = 41
    Height = 13
    Caption = 'ByteSize'
  end
  object lbParity: TLabel
    Left = 12
    Top = 56
    Width = 26
    Height = 13
    Caption = 'Parity'
  end
  object lbStopBits: TLabel
    Left = 112
    Top = 56
    Width = 39
    Height = 13
    Caption = 'StopBits'
  end
  object btnOK: TButton
    Left = 12
    Top = 108
    Width = 85
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 112
    Top = 108
    Width = 85
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object edCustom: TEdit
    Left = 12
    Top = 24
    Width = 85
    Height = 21
    MaxLength = 10
    TabOrder = 2
    Text = '38400'
    OnKeyPress = edCustomKeyPress
  end
  object cbByteSize: TComboBox
    Left = 112
    Top = 24
    Width = 85
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      '5'
      '6'
      '7'
      '8')
  end
  object cbParity: TComboBox
    Left = 12
    Top = 72
    Width = 85
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'None'
      'Odd'
      'Even'
      'Mark'
      'Space')
  end
  object cbStopBits: TComboBox
    Left = 112
    Top = 72
    Width = 85
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      '1'
      '1.5'
      '2')
  end
end
