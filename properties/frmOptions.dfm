object fOptions: TfOptions
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Application Options'
  ClientHeight = 214
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 265
    Height = 185
    Caption = 'Options'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 68
      Width = 99
      Height = 13
      Caption = 'Movement Precision:'
    end
    object Label2: TLabel
      Left = 183
      Top = 68
      Width = 27
      Height = 13
      Caption = 'Pixels'
    end
    object Label3: TLabel
      Left = 8
      Top = 99
      Width = 45
      Height = 13
      Caption = 'Grid Size:'
    end
    object Label4: TLabel
      Left = 183
      Top = 99
      Width = 27
      Height = 13
      Caption = 'Pixels'
    end
    object Label5: TLabel
      Left = 8
      Top = 129
      Width = 88
      Height = 13
      Caption = 'Background Color:'
    end
    object Label6: TLabel
      Left = 8
      Top = 154
      Width = 51
      Height = 13
      Caption = 'Grid Color:'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 145
      Height = 17
      Caption = 'Show Grid on Startup'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 41
      Width = 145
      Height = 17
      Caption = 'Snap to Grid on Startup'
      TabOrder = 1
    end
    object spnPrecision: TSpinEdit
      Left = 114
      Top = 65
      Width = 63
      Height = 22
      Color = clWhite
      MaxValue = 20
      MinValue = 1
      TabOrder = 2
      Value = 10
    end
    object spnGridSize: TSpinEdit
      Left = 114
      Top = 96
      Width = 63
      Height = 22
      MaxValue = 20
      MinValue = 3
      TabOrder = 3
      Value = 10
    end
    object cbBackColor: TColorBox
      Left = 99
      Top = 126
      Width = 111
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
      TabOrder = 4
    end
    object cbGridColor: TColorBox
      Left = 99
      Top = 151
      Width = 111
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
      TabOrder = 5
    end
  end
  object Button1: TButton
    Left = 109
    Top = 191
    Width = 75
    Height = 20
    Caption = 'Save'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 190
    Top = 191
    Width = 75
    Height = 20
    Caption = 'Exit'
    TabOrder = 2
    OnClick = Button2Click
  end
end
