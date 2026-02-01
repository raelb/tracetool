object JSONViewerFrame: TJSONViewerFrame
  Left = 0
  Top = 0
  Width = 823
  Height = 414
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 281
    Top = 0
    Width = 6
    Height = 414
    ExplicitLeft = 241
    ExplicitHeight = 385
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 281
    Height = 414
    Align = alLeft
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 279
      Height = 36
      Align = alTop
      TabOrder = 0
      object btnOpen: TButton
        Left = 8
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Open'
        TabOrder = 0
        OnClick = btnOpenClick
      end
      object btnPaste: TButton
        Left = 88
        Top = 5
        Width = 75
        Height = 25
        Caption = 'Paste'
        TabOrder = 1
        OnClick = btnPasteClick
      end
    end
    object VST: TVirtualStringTree
      Left = 1
      Top = 37
      Width = 279
      Height = 376
      Align = alClient
      BorderStyle = bsNone
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      HintMode = hmTooltip
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnFreeNode = VSTFreeNode
      OnGetText = VSTGetText
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <>
    end
  end
  object EditorPanel: TPanel
    Left = 287
    Top = 0
    Width = 536
    Height = 414
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Editor: TTextEditor
      Left = 0
      Top = 0
      Width = 536
      Height = 384
      Align = alClient
      CodeFolding.Hint.Visible = False
      CodeFolding.Visible = True
      LeftMargin.Width = 55
      TabOrder = 0
      WordWrap.Indicator.MaskColor = clFuchsia
    end
    object SearchPanel: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 384
      Width = 536
      Height = 30
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alBottom
      BevelOuter = bvNone
      Padding.Top = 3
      Padding.Bottom = 3
      ParentBackground = False
      TabOrder = 1
      Visible = False
      object SplitterSearch: TSplitter
        Left = 257
        Top = 3
        Height = 24
        ExplicitLeft = 227
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonFindPrevious: TSpeedButton
        Left = 260
        Top = 3
        Width = 21
        Height = 24
        Hint = 'Find Previous|Continues the search backwards'
        Align = alLeft
        Caption = '<'
        Flat = True
        OnClick = actFindPrevExecute
        ExplicitLeft = 230
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonFindNext: TSpeedButton
        Left = 281
        Top = 3
        Width = 21
        Height = 24
        Hint = 'Find Next|Continues the last search'
        Align = alLeft
        Caption = '>'
        Flat = True
        OnClick = actFindNextExecute
        ExplicitLeft = 251
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonSearchDivider1: TSpeedButton
        AlignWithMargins = True
        Left = 323
        Top = 4
        Width = 10
        Height = 22
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alLeft
        Flat = True
        ExplicitLeft = 293
        ExplicitTop = 1
        ExplicitHeight = 19
      end
      object SpeedButtonOptions: TSpeedButton
        Left = 385
        Top = 3
        Width = 21
        Height = 24
        Align = alLeft
        Caption = 'Opt'
        Flat = True
        Visible = False
        ExplicitLeft = 355
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonClose: TSpeedButton
        Left = 504
        Top = 3
        Width = 32
        Height = 24
        Hint = 'Close search'
        Align = alRight
        Caption = 'X'
        Flat = True
        NumGlyphs = 2
        OnClick = SpeedButtonCloseClick
      end
      object SpeedButtonCaseSensitive: TSpeedButton
        Left = 333
        Top = 3
        Width = 21
        Height = 24
        Hint = 'Case sensitive search'
        Align = alLeft
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'CS'
        Flat = True
        Visible = False
        ExplicitLeft = 303
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonInSelection: TSpeedButton
        Left = 354
        Top = 3
        Width = 21
        Height = 24
        Hint = 'Search in selection'
        Align = alLeft
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'IS'
        Flat = True
        Visible = False
        ExplicitLeft = 324
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object SpeedButtonSearchDivider2: TSpeedButton
        AlignWithMargins = True
        Left = 375
        Top = 4
        Width = 10
        Height = 22
        Margins.Left = 0
        Margins.Top = 1
        Margins.Right = 0
        Margins.Bottom = 1
        Align = alLeft
        Flat = True
        Visible = False
        ExplicitLeft = 345
        ExplicitTop = 1
        ExplicitHeight = 19
      end
      object SpeedButtonSearchEngine: TSpeedButton
        AlignWithMargins = True
        Left = 0
        Top = 3
        Width = 17
        Height = 24
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 6
        Margins.Bottom = 0
        Align = alLeft
        Flat = True
        Visible = False
      end
      object SpeedButtonFindAll: TSpeedButton
        Left = 302
        Top = 3
        Width = 21
        Height = 24
        Hint = 'Find All'
        Align = alLeft
        Caption = 'FA'
        Flat = True
        Visible = False
        OnClick = actFindAllExecute
        ExplicitLeft = 272
        ExplicitTop = 0
        ExplicitHeight = 21
      end
      object edtSearchText: TEdit
        Left = 57
        Top = 3
        Width = 200
        Height = 24
        Hint = 'Search text'
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = edtSearchTextChange
        OnKeyPress = edtSearchTextKeyPress
        ExplicitHeight = 22
      end
      object PanelRight: TPanel
        Left = 406
        Top = 3
        Width = 98
        Height = 24
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        object LabelSearchResultCount: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 6
          Width = 3
          Height = 15
          Margins.Left = 0
          Margins.Top = 6
          Align = alLeft
          Layout = tlCenter
          StyleElements = [seClient, seBorder]
          ExplicitHeight = 13
        end
      end
      object LeftSpacerPanel: TPanel
        Left = 23
        Top = 3
        Width = 34
        Height = 24
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 96
  end
  object ActionList1: TActionList
    Left = 424
    Top = 96
    object actFind: TAction
      Category = 'Search'
      Caption = '&Find...'
      Hint = 'Find|Find the specified text in the document'
      ImageIndex = 15
      OnExecute = actFindExecute
    end
    object actFindNext: TAction
      Category = 'Search'
      Caption = 'Find &Next'
      Hint = 'Find Next|Continues the last search'
      ImageIndex = 16
      OnExecute = actFindNextExecute
    end
    object actFindPrev: TAction
      Category = 'Search'
      Caption = 'Find &Previous'
      Hint = 'Find Previous|Continues the search backwards'
      OnExecute = actFindPrevExecute
    end
    object actReplace: TAction
      Category = 'Search'
      Caption = '&Replace...'
      Hint = 'Replace|Finds and replaces specified text in the document'
      ImageIndex = 17
    end
    object actShowMiniMap: TAction
      Category = 'Functions'
      Caption = 'Toggle Show &MiniMap'
      ImageIndex = 163
    end
    object actDelLine: TAction
      Category = 'Edit'
      Caption = 'Delete &Line'
    end
    object actDelEOL: TAction
      Category = 'Edit'
      Caption = 'Delete &End of Line'
    end
    object actDelWord: TAction
      Category = 'Edit'
      Caption = 'Delete &Word'
    end
    object actDelWhiteSpace: TAction
      Category = 'Edit'
      Caption = 'Delete W&hitespace'
    end
    object actCaseSensitive: TAction
      Category = 'Search'
      Caption = 'Case Sensitive'
      Hint = 'Case sensitive search'
    end
    object actInSelection: TAction
      Category = 'Search'
      Caption = 'In Selection'
      Hint = 'Search in selection'
    end
    object actCloseSearch: TAction
      Category = 'Search'
      Caption = 'Close Search'
      Hint = 'Close search'
      OnExecute = actCloseSearchExecute
    end
    object actFindAll: TAction
      Category = 'Search'
      Caption = 'Find &All'
      Hint = 'Find All'
      OnExecute = actFindAllExecute
    end
    object actWordWrap: TAction
      Category = 'Functions'
      Caption = '&Word Wrap'
      ImageIndex = 56
    end
  end
end
