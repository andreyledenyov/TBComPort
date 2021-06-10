object TableForm: TTableForm
  Left = 192
  Top = 109
  BorderStyle = bsToolWindow
  Caption = 'ASCII Table'
  ClientHeight = 649
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SG: TStringGrid
    Left = 0
    Top = 0
    Width = 559
    Height = 649
    Align = alClient
    Color = clWhite
    ColCount = 18
    DefaultColWidth = 30
    DefaultRowHeight = 35
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 18
    FixedRows = 0
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDblClick = SGDblClick
    OnDrawCell = SGDrawCell
    OnMouseMove = SGMouseMove
  end
end
