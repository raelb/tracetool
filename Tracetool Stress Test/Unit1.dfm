object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 213
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object btnSendStr: TButton
    Left = 144
    Top = 112
    Width = 85
    Height = 25
    Caption = 'Send s'
    TabOrder = 2
    OnClick = btnSendStrClick
  end
  object btnTraceObjects: TButton
    Left = 32
    Top = 112
    Width = 85
    Height = 25
    Caption = 'Trace Objects'
    TabOrder = 4
    OnClick = btnTraceObjectsClick
  end
  object btnSendStrList: TButton
    Left = 144
    Top = 72
    Width = 85
    Height = 25
    Caption = 'Send strlist'
    TabOrder = 1
    OnClick = btnSendStrListClick
  end
  object Button4: TButton
    Left = 32
    Top = 40
    Width = 85
    Height = 25
    Caption = 'Single trace'
    TabOrder = 3
    OnClick = Button4Click
  end
  object btnSimpleTrace: TButton
    Left = 144
    Top = 40
    Width = 85
    Height = 25
    Caption = 'Simple Trace'
    TabOrder = 0
    OnClick = btnSimpleTraceClick
  end
  object seObjects: TRzSpinEdit
    Left = 32
    Top = 144
    Width = 65
    Height = 23
    AllowKeyEdit = True
    Max = 1000.000000000000000000
    Value = 200.000000000000000000
    TabOrder = 5
  end
  object seCount: TRzSpinEdit
    Left = 32
    Top = 72
    Width = 65
    Height = 23
    AllowKeyEdit = True
    Max = 10000.000000000000000000
    Value = 200.000000000000000000
    TabOrder = 6
  end
  object seString: TRzSpinEdit
    Left = 144
    Top = 144
    Width = 73
    Height = 23
    AllowKeyEdit = True
    Max = 20000.000000000000000000
    Value = 1000.000000000000000000
    TabOrder = 7
  end
  object btnODS: TButton
    Left = 256
    Top = 40
    Width = 75
    Height = 25
    Caption = 'ODS'
    TabOrder = 8
    OnClick = btnODSClick
  end
  object FormStorage1: TFormStorage
    StoredProps.Strings = (
      'seCount.Value'
      'seObjects.Value'
      'seString.Value')
    StoredValues = <>
    Left = 280
    Top = 72
  end
end
