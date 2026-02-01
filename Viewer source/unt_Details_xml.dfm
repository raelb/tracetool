inherited Frame_XML: TFrame_XML
  object Panel1: TPanel
    Left = 0
    Top = 208
    Width = 320
    Height = 32
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      320
      32)
    object btnFormat: TSpeedButton
      Left = 0
      Top = 5
      Width = 57
      Height = 22
      Caption = 'Format'
      Flat = True
      OnClick = btnFormatClick
    end
    object btnFullView: TSpeedButton
      Left = 64
      Top = 5
      Width = 57
      Height = 22
      Caption = 'Full View'
      Flat = True
      OnClick = btnFullViewClick
    end
    object SizeLabel: TLabel
      Left = 278
      Top = 8
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Label'
    end
    object btnNotepad: TSpeedButton
      Left = 124
      Top = 5
      Width = 45
      Height = 22
      Caption = 'NP++'
      Flat = True
      OnClick = btnNotepadClick
    end
    object btnHex: TSpeedButton
      Left = 172
      Top = 5
      Width = 37
      Height = 22
      Caption = 'Hex'
      Flat = True
      OnClick = btnHexClick
    end
    object btnFull: TSpeedButton
      Left = 212
      Top = 5
      Width = 37
      Height = 22
      Caption = 'Full'
      Flat = True
      OnClick = btnFullClick
    end
  end
  object Editor: TTextEditor
    Left = 0
    Top = 0
    Width = 320
    Height = 208
    Align = alClient
    CodeFolding.Hint.Visible = False
    CodeFolding.Visible = True
    LeftMargin.Width = 55
    TabOrder = 1
    WordWrap.Indicator.MaskColor = clFuchsia
  end
  object XMLDoc: TXMLDocument
    Active = True
    Left = 168
    Top = 120
    DOMVendorDesc = 'MSXML'
  end
end
