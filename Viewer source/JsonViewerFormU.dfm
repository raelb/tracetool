object JsonViewerForm: TJsonViewerForm
  Left = 0
  Top = 0
  Caption = 'JSON Viewer'
  ClientHeight = 368
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FormStorage1: TFormStorage
    IniSection = 'JsonViewer'
    StoredValues = <>
    Left = 296
    Top = 192
  end
  object ActionList1: TActionList
    Left = 256
    Top = 96
    object actNewPage: TAction
      Caption = 'New Page'
      ShortCut = 16462
    end
    object actOpen: TAction
      Caption = 'Open'
      ShortCut = 16463
      OnExecute = actOpenExecute
    end
    object actFind: TAction
      Caption = 'Find'
      ShortCut = 16454
      OnExecute = actFindExecute
    end
    object actFindNext: TAction
      Caption = 'Find Next'
      ShortCut = 114
      OnExecute = actFindNextExecute
    end
    object actFindPrevious: TAction
      Caption = 'Find Previous'
      ShortCut = 8306
      OnExecute = actFindPreviousExecute
    end
    object actClose: TAction
      Caption = 'Close'
      ShortCut = 27
      OnExecute = actCloseExecute
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 328
    Top = 96
  end
end
