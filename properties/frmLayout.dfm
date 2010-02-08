object fLayout: TfLayout
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Layout properties'
  ClientHeight = 222
  ClientWidth = 459
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
    Left = 1
    Top = 0
    Width = 264
    Height = 95
    Caption = 'Repulsive Force:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Top = 17
      Width = 67
      Height = 13
      Caption = 'Epsilon Force:'
    end
    object Label3: TLabel
      Left = 6
      Top = 42
      Width = 124
      Height = 13
      Caption = 'Epsilon lying nodes Force:'
    end
    object Label4: TLabel
      Left = 6
      Top = 68
      Width = 156
      Height = 13
      Caption = 'Epsilon lying nodes offset Force:'
    end
    object repEpsilon: TEdit
      Left = 179
      Top = 14
      Width = 78
      Height = 21
      TabOrder = 0
      Text = '100'
    end
    object repLyEpsilon: TEdit
      Left = 179
      Top = 39
      Width = 78
      Height = 21
      TabOrder = 1
      Text = '100'
    end
    object repLyOffset: TEdit
      Left = 179
      Top = 65
      Width = 78
      Height = 21
      TabOrder = 2
      Text = '100'
    end
  end
  object GroupBox2: TGroupBox
    Left = 1
    Top = 98
    Width = 264
    Height = 95
    Caption = 'Attractive Force:'
    TabOrder = 1
    object Label2: TLabel
      Left = 6
      Top = 17
      Width = 67
      Height = 13
      Caption = 'Epsilon Force:'
    end
    object Label5: TLabel
      Left = 6
      Top = 44
      Width = 124
      Height = 13
      Caption = 'Epsilon lying nodes Force:'
    end
    object Label6: TLabel
      Left = 6
      Top = 71
      Width = 156
      Height = 13
      Caption = 'Epsilon lying nodes offset Force:'
    end
    object attEpsilon: TEdit
      Left = 179
      Top = 14
      Width = 78
      Height = 21
      TabOrder = 0
      Text = '100'
    end
    object attlyEpsilon: TEdit
      Left = 179
      Top = 41
      Width = 78
      Height = 21
      TabOrder = 1
      Text = '100'
    end
    object attLyOffset: TEdit
      Left = 179
      Top = 68
      Width = 78
      Height = 21
      TabOrder = 2
      Text = '100'
    end
  end
  object GroupBox3: TGroupBox
    Left = 271
    Top = 0
    Width = 186
    Height = 193
    Caption = 'Algorithm:'
    TabOrder = 2
    object Label7: TLabel
      Left = 7
      Top = 17
      Width = 65
      Height = 13
      Caption = 'speed offset:'
    end
    object Label8: TLabel
      Left = 7
      Top = 42
      Width = 37
      Height = 13
      Caption = 'friction:'
    end
    object Label9: TLabel
      Left = 7
      Top = 68
      Width = 97
      Height = 13
      Caption = 'Energy change limit:'
    end
    object Label10: TLabel
      Left = 7
      Top = 93
      Width = 80
      Height = 13
      Caption = 'Maximum speed:'
    end
    object Label11: TLabel
      Left = 7
      Top = 121
      Width = 90
      Height = 13
      Caption = 'Max steps to stop:'
    end
    object speed: TEdit
      Left = 107
      Top = 14
      Width = 70
      Height = 21
      TabOrder = 0
      Text = '100'
    end
    object friction: TEdit
      Left = 107
      Top = 39
      Width = 70
      Height = 21
      TabOrder = 1
      Text = '100'
    end
    object changelimit: TEdit
      Left = 107
      Top = 65
      Width = 70
      Height = 21
      TabOrder = 2
      Text = '100'
    end
    object maxSpeed: TEdit
      Left = 107
      Top = 90
      Width = 70
      Height = 21
      TabOrder = 3
      Text = '100'
    end
    object MaxSteps: TEdit
      Left = 107
      Top = 118
      Width = 70
      Height = 21
      TabOrder = 4
      Text = '100'
    end
    object chkStop: TCheckBox
      Left = 7
      Top = 141
      Width = 170
      Height = 17
      Caption = 'Show every step'
      TabOrder = 5
    end
    object chkEnergy: TCheckBox
      Left = 7
      Top = 156
      Width = 170
      Height = 17
      Caption = 'Show Energy calculations'
      TabOrder = 6
    end
    object chkCenter: TCheckBox
      Left = 7
      Top = 172
      Width = 170
      Height = 17
      Caption = 'Centre Graph after finishing'
      TabOrder = 7
    end
  end
  object Button1: TButton
    Left = 301
    Top = 199
    Width = 75
    Height = 20
    Caption = 'Save'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 382
    Top = 199
    Width = 75
    Height = 20
    Caption = 'Exit'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 1
    Top = 199
    Width = 88
    Height = 20
    Caption = 'Default Values'
    TabOrder = 5
    OnClick = Button3Click
  end
end
