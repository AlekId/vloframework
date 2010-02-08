object frmDefault: TfrmDefault
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Default box and line properties'
  ClientHeight = 323
  ClientWidth = 390
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 20
    Top = 133
    Width = 51
    Height = 13
    Caption = 'Pen width:'
  end
  object Label2: TLabel
    Left = 19
    Top = 156
    Width = 50
    Height = 13
    Caption = 'Box Color:'
  end
  object Label3: TLabel
    Left = 19
    Top = 180
    Width = 51
    Height = 13
    Caption = 'Line Color:'
  end
  object Label4: TLabel
    Left = 19
    Top = 204
    Width = 73
    Height = 13
    Caption = 'Selected Color:'
  end
  object imgBox: TImage
    Left = 20
    Top = 3
    Width = 175
    Height = 121
  end
  object Label1: TLabel
    Left = 208
    Top = 134
    Width = 69
    Height = 13
    Caption = 'Arrow Length:'
  end
  object Label5: TLabel
    Left = 208
    Top = 156
    Width = 51
    Height = 13
    Caption = 'Pen width:'
  end
  object Label7: TLabel
    Left = 208
    Top = 179
    Width = 63
    Height = 13
    Caption = 'Arrow Angle:'
  end
  object Label8: TLabel
    Left = 208
    Top = 203
    Width = 51
    Height = 13
    Caption = 'Line Color:'
  end
  object Label9: TLabel
    Left = 208
    Top = 252
    Width = 44
    Height = 13
    Caption = 'Fill Color:'
  end
  object Label10: TLabel
    Left = 208
    Top = 276
    Width = 73
    Height = 13
    Caption = 'Selected Color:'
  end
  object imgLine: TImage
    Left = 208
    Top = 3
    Width = 179
    Height = 121
  end
  object Image2: TImage
    Left = 0
    Top = 0
    Width = 17
    Height = 323
    Align = alLeft
    ExplicitTop = 32
    ExplicitHeight = 306
  end
  object penWidth: TSpinEdit
    Left = 98
    Top = 130
    Width = 97
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 0
    Value = 1
    OnChange = penWidthChange
  end
  object cbBoxColor: TColorBox
    Left = 98
    Top = 153
    Width = 97
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 1
    OnChange = cbBoxColorChange
  end
  object cbLineColor: TColorBox
    Left = 98
    Top = 177
    Width = 97
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 2
    OnChange = cbBoxColorChange
  end
  object cbSelectedColor: TColorBox
    Left = 98
    Top = 201
    Width = 97
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 3
    OnChange = cbBoxColorChange
  end
  object Button1: TButton
    Left = 231
    Top = 300
    Width = 75
    Height = 20
    Caption = 'Save'
    TabOrder = 4
    OnClick = Button1Click
  end
  object spArrowLength: TSpinEdit
    Left = 287
    Top = 130
    Width = 100
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnChange = penWidthChange
  end
  object spPenWidth: TSpinEdit
    Left = 287
    Top = 153
    Width = 100
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 6
    Value = 1
    OnChange = penWidthChange
  end
  object arrowAngle: TSpinEdit
    Left = 287
    Top = 176
    Width = 100
    Height = 22
    MaxValue = 50
    MinValue = 10
    TabOrder = 7
    Value = 10
    OnChange = penWidthChange
  end
  object ColorBox1: TColorBox
    Left = 287
    Top = 200
    Width = 100
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 8
    OnChange = cbBoxColorChange
  end
  object chkFilled: TCheckBox
    Left = 208
    Top = 228
    Width = 97
    Height = 17
    Caption = 'Filled'
    TabOrder = 9
    OnClick = chkFilledClick
  end
  object cbFillColor: TColorBox
    Left = 287
    Top = 249
    Width = 100
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 10
    OnChange = cbBoxColorChange
  end
  object ColorBox2: TColorBox
    Left = 287
    Top = 273
    Width = 100
    Height = 22
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbCustomColors]
    TabOrder = 11
    OnChange = cbBoxColorChange
  end
  object Button2: TButton
    Left = 312
    Top = 300
    Width = 75
    Height = 20
    Caption = 'Exit'
    TabOrder = 12
    OnClick = Button2Click
  end
end
