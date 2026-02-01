object FullViewForm: TFullViewForm
  Left = 0
  Top = 0
  Caption = 'Full View'
  ClientHeight = 369
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 328
    Width = 557
    Height = 41
    Align = alBottom
    TabOrder = 0
  end
  object Editor: TTextEditor
    Left = 0
    Top = 0
    Width = 557
    Height = 328
    Align = alClient
    CodeFolding.Hint.Visible = False
    CodeFolding.Visible = True
    LeftMargin.Width = 55
    TabOrder = 1
    WordWrap.Indicator.MaskColor = clFuchsia
  end
  object FormStorage1: TFormStorage
    IniSection = 'FullView'
    StoredValues = <>
    Left = 272
    Top = 192
  end
  object ActionList1: TActionList
    Left = 272
    Top = 136
    object actClose: TAction
      Caption = 'actClose'
      ShortCut = 27
      OnExecute = actCloseExecute
    end
  end
end
