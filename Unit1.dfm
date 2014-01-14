object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 566
  ClientWidth = 717
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
  object Label1: TLabel
    Left = 8
    Top = 78
    Width = 55
    Height = 13
    Caption = 'Role Name:'
  end
  object btnDeleteRole: TButton
    Left = 304
    Top = 63
    Width = 75
    Height = 25
    Caption = 'Delete Role'
    TabOrder = 0
    OnClick = btnDeleteRoleClick
  end
  object btnUpdate: TButton
    Left = 304
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Update Role'
    TabOrder = 1
    OnClick = btnUpdateClick
  end
  object btnGetRole: TButton
    Left = 151
    Top = 92
    Width = 75
    Height = 25
    Caption = 'Get Role'
    TabOrder = 2
    OnClick = btnGetRoleClick
  end
  object edtRoleName: TEdit
    Left = 8
    Top = 94
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 8
    Top = 269
    Width = 202
    Height = 184
    TabOrder = 4
  end
  object cmbRoleType: TComboBox
    Left = 481
    Top = 12
    Width = 121
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    Items.Strings = (
      'User'
      'System')
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 156
    Height = 21
    TabOrder = 6
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
  object Button1: TButton
    Left = 400
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 7
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 400
    Top = 39
    Width = 161
    Height = 239
    ItemHeight = 13
    TabOrder = 8
    OnClick = ListBox1Click
  end
  object Button2: TButton
    Left = 496
    Top = 430
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 9
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 360
    Top = 432
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 51
    Width = 121
    Height = 21
    TabOrder = 11
    Text = 'Edit2'
  end
  object Button3: TButton
    Left = 151
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 12
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 151
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 13
    OnClick = Button4Click
  end
end
