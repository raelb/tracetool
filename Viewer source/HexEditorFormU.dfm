object HexEditorForm: THexEditorForm
  Left = 0
  Top = 0
  Caption = 'Hex Editor'
  ClientHeight = 382
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FormStorage1: TFormStorage
    IniSection = 'HexEditor'
    StoredValues = <>
    Left = 288
    Top = 112
  end
end
