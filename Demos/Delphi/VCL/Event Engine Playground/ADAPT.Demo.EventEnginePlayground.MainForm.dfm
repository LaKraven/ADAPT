object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Event Engine Playground'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 635
    Height = 81
    Align = alTop
    Caption = 'Dispatch Test Event:'
    TabOrder = 0
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 625
      Height = 21
      Align = alTop
      TabOrder = 0
      Text = 'Enter a Message Here'
      ExplicitLeft = 256
      ExplicitTop = 40
      ExplicitWidth = 121
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 5
      Top = 45
      Width = 625
      Height = 25
      Align = alTop
      Caption = 'Dispatch Test Event'
      TabOrder = 1
      OnClick = Button1Click
      ExplicitLeft = 280
      ExplicitTop = 40
      ExplicitWidth = 75
    end
  end
end
