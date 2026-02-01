object Frm_ODS: TFrm_ODS
  Left = 358
  Top = 200
  Caption = 'ODS'
  ClientHeight = 293
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelOds: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 293
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object VSplitter: TSplitter
      Left = 260
      Top = 22
      Height = 271
      Align = alRight
      Visible = False
      ExplicitLeft = 176
      ExplicitHeight = 264
    end
    object VstDebugString: TVirtualStringTree
      Left = 12
      Top = 22
      Width = 248
      Height = 271
      Align = alClient
      BevelInner = bvNone
      Colors.BorderColor = clWindowText
      Colors.HotColor = clBlack
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DragOperations = []
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Header.AutoSizeIndex = -1
      Header.DefaultHeight = 17
      Header.Height = 21
      Header.MainColumn = 1
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
      HintMode = hmTooltip
      Images = Frm_Tool.ImageList1
      Indent = 15
      Margin = 0
      ParentFont = False
      ParentShowHint = False
      PopupMenu = PopupTree
      ScrollBarOptions.AlwaysVisible = True
      ScrollBarOptions.HorizontalIncrement = 100
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
      OnAfterCellPaint = VstDebugStringAfterCellPaint
      OnAfterPaint = VstDebugStringAfterPaint
      OnBeforeCellPaint = VstDebugStringBeforeCellPaint
      OnChange = VstDebugStringChange
      OnCompareNodes = VstDebugStringCompareNodes
      OnCreateEditor = VstDebugStringCreateEditor
      OnDblClick = VstDebugStringDblClick
      OnEditCancelled = VstDebugStringEditCancelled
      OnEdited = VstDebugStringEdited
      OnEditing = VstDebugStringEditing
      OnFreeNode = VstDebugStringFreeNode
      OnGetText = VstDebugStringGetText
      OnPaintText = VstDebugStringPaintText
      OnHeaderDragged = VstDebugStringHeaderDragged
      OnKeyAction = VstDebugStringKeyAction
      OnMeasureItem = VstDebugStringMeasureItem
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <
        item
          Position = 0
          Text = 'Time'
          Width = 75
        end
        item
          Position = 1
          Text = 'Process Name'
          Width = 120
        end
        item
          Color = 16705515
          MinWidth = 3000
          Options = [coAllowClick, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
          Position = 2
          Text = 'Lines'
          Width = 3000
        end>
    end
    object PanelTraceInfo: TPanel
      Left = 263
      Top = 22
      Width = 389
      Height = 271
      Align = alRight
      BevelInner = bvLowered
      ParentBackground = False
      ParentColor = True
      TabOrder = 1
      Visible = False
      object VstDetail: TVirtualStringTree
        Left = 2
        Top = 2
        Width = 385
        Height = 267
        Align = alClient
        BevelOuter = bvNone
        Color = 16117479
        Colors.BorderColor = clWindowText
        Colors.HotColor = clBlack
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Header.AutoSizeIndex = -1
        Header.DefaultHeight = 17
        Header.Height = 17
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        HintMode = hmTooltip
        Indent = 15
        Margin = 0
        NodeAlignment = naFromTop
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupDetail
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 0
        TreeOptions.AnimationOptions = [toAnimatedToggle]
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.SelectionOptions = [toExtendedFocus]
        OnBeforeCellPaint = VstDetailBeforeCellPaint
        OnChange = VstDetailChange
        OnCreateEditor = VstDetailCreateEditor
        OnDblClick = VstDetailDblClick
        OnEditing = VstDetailEditing
        OnFreeNode = VstDetailFreeNode
        OnGetText = VstDetailGetText
        OnPaintText = VstDetailPaintText
        OnMeasureItem = VstDetailMeasureItem
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <
          item
            Color = 16117479
            MinWidth = 80
            Options = [coAllowClick, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible, coAllowFocus]
            Position = 0
            Width = 150
          end
          item
            MinWidth = 300
            Position = 1
            Width = 300
          end>
      end
    end
    object PanelTop: TPanel
      Left = 0
      Top = 0
      Width = 652
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      Color = clCream
      ParentBackground = False
      TabOrder = 2
      DesignSize = (
        652
        22)
      object TracesInfo: TLabel
        Left = 3
        Top = 5
        Width = 53
        Height = 15
        Caption = 'TracesInfo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object butClose: TBitBtn
        Left = 629
        Top = 0
        Width = 22
        Height = 20
        Anchors = [akTop, akRight]
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FF000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF
          00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF000000000000000000000000FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
          0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF000000000000000000000000FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF
          00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FF000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        TabOrder = 0
        OnClick = butCloseClick
      end
    end
    object PanelGutter: TPanel
      Left = 0
      Top = 22
      Width = 12
      Height = 271
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 3
      OnDblClick = PanelGutterDblClick
    end
  end
  object PopupTree: TPopupMenu
    Images = Frm_Tool.ilActions
    Left = 24
    Top = 46
    object Cut1: TMenuItem
      Action = FrmPageContainer.actCut
    end
    object Copy1: TMenuItem
      Action = FrmPageContainer.actCopy
    end
    object Copycurrentcell1: TMenuItem
      Action = FrmPageContainer.actCopyCurrentCell
    end
    object Delete1: TMenuItem
      Action = FrmPageContainer.actDelete
    end
    object mnuTogglebookmark: TMenuItem
      Action = FrmPageContainer.actToggleBookmark
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelectAll1: TMenuItem
      Action = FrmPageContainer.actSelectAll
    end
  end
  object PopupDetail: TPopupMenu
    Images = Frm_Tool.ilActions
    Left = 384
    Top = 62
    object MenuItem2: TMenuItem
      Action = FrmPageContainer.actCopy
    end
    object MenuItem3: TMenuItem
      Action = FrmPageContainer.actCopyCurrentCell
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItem1: TMenuItem
      Action = FrmPageContainer.actSelectAll
    end
  end
end
