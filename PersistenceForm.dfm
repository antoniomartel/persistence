object Form1: TForm1
  Left = 202
  Top = 147
  Width = 689
  Height = 468
  Caption = 'Form1'
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 249
    Height = 217
    Caption = 'Customer 1'
    TabOrder = 0
    object Label9: TLabel
      Left = 16
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label10: TLabel
      Left = 16
      Top = 64
      Width = 31
      Height = 13
      Caption = 'Phone'
    end
    object Label11: TLabel
      Left = 16
      Top = 104
      Width = 59
      Height = 13
      Caption = 'Organisation'
    end
    object Label12: TLabel
      Left = 16
      Top = 144
      Width = 59
      Height = 13
      Caption = 'Last contact'
    end
    object Label17: TLabel
      Left = 16
      Top = 184
      Width = 39
      Height = 13
      Caption = 'Balance'
    end
    object EditName1: TEdit
      Left = 104
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'John Smith'
    end
    object EditPhone1: TEdit
      Left = 104
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '01202 899 123'
    end
    object EditOrganisation1: TEdit
      Left = 104
      Top = 104
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Smith Inc.'
    end
    object EditLastContact1: TEdit
      Left = 104
      Top = 144
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '02/02/2002'
    end
    object EditBalance1: TEdit
      Left = 104
      Top = 184
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '560'
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 216
    Width = 249
    Height = 217
    Caption = 'Address 1'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 40
      Width = 28
      Height = 13
      Caption = 'Street'
    end
    object Label2: TLabel
      Left = 16
      Top = 80
      Width = 17
      Height = 13
      Caption = 'City'
    end
    object Label3: TLabel
      Left = 16
      Top = 120
      Width = 46
      Height = 13
      Caption = 'PostCode'
    end
    object Label4: TLabel
      Left = 16
      Top = 160
      Width = 36
      Height = 13
      Caption = 'Country'
    end
    object EditStreet1: TEdit
      Left = 72
      Top = 40
      Width = 161
      Height = 21
      TabOrder = 0
      Text = '142 Holdenhurst Road'
    end
    object EditCity1: TEdit
      Left = 72
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Bournemouth'
    end
    object EditPostCode1: TEdit
      Left = 72
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'BH8 8AS'
    end
    object EditCountry1: TEdit
      Left = 72
      Top = 160
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'England'
    end
  end
  object GroupBox3: TGroupBox
    Left = 432
    Top = 0
    Width = 249
    Height = 217
    Caption = 'Customer 2'
    TabOrder = 2
    object Label13: TLabel
      Left = 16
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label14: TLabel
      Left = 16
      Top = 64
      Width = 31
      Height = 13
      Caption = 'Phone'
    end
    object Label15: TLabel
      Left = 16
      Top = 104
      Width = 59
      Height = 13
      Caption = 'Organisation'
    end
    object Label16: TLabel
      Left = 16
      Top = 144
      Width = 59
      Height = 13
      Caption = 'Last contact'
    end
    object Label18: TLabel
      Left = 16
      Top = 184
      Width = 39
      Height = 13
      Caption = 'Balance'
    end
    object EditName2: TEdit
      Left = 104
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Marvin Curtis'
    end
    object EditPhone2: TEdit
      Left = 104
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '01202 777 321'
    end
    object EditOrganisation2: TEdit
      Left = 104
      Top = 104
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Curtis & Son Ltd.'
    end
    object EditLastContact2: TEdit
      Left = 104
      Top = 144
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '16/01/2002'
    end
    object EditBalance2: TEdit
      Left = 104
      Top = 184
      Width = 121
      Height = 21
      TabOrder = 4
      Text = '0'
    end
  end
  object GroupBox4: TGroupBox
    Left = 432
    Top = 216
    Width = 249
    Height = 217
    Caption = 'Address 2'
    TabOrder = 3
    object Label5: TLabel
      Left = 16
      Top = 40
      Width = 28
      Height = 13
      Caption = 'Street'
    end
    object Label6: TLabel
      Left = 16
      Top = 80
      Width = 17
      Height = 13
      Caption = 'City'
    end
    object Label7: TLabel
      Left = 16
      Top = 120
      Width = 46
      Height = 13
      Caption = 'PostCode'
    end
    object Label8: TLabel
      Left = 16
      Top = 160
      Width = 36
      Height = 13
      Caption = 'Country'
    end
    object EditStreet2: TEdit
      Left = 72
      Top = 40
      Width = 161
      Height = 21
      TabOrder = 0
      Text = '2 Highwood Road'
    end
    object EditCity2: TEdit
      Left = 72
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Poole'
    end
    object EditPostCode2: TEdit
      Left = 72
      Top = 120
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'BP8 8AP'
    end
    object EditCountry2: TEdit
      Left = 72
      Top = 160
      Width = 121
      Height = 21
      TabOrder = 3
      Text = 'England'
    end
  end
  object bClose: TButton
    Left = 304
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = bCloseClick
  end
  object bOpen: TButton
    Left = 304
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 5
    OnClick = bOpenClick
  end
  object bSave: TButton
    Left = 304
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 6
    OnClick = bSaveClick
  end
  object GroupBox5: TGroupBox
    Left = 280
    Top = 16
    Width = 121
    Height = 73
    Caption = 'Object'
    TabOrder = 7
    object RadioButton1: TRadioButton
      Left = 16
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Customer 1'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 16
      Top = 48
      Width = 89
      Height = 17
      Caption = 'Customer 2'
      TabOrder = 1
    end
  end
  object bCopy: TButton
    Left = 304
    Top = 176
    Width = 75
    Height = 25
    Caption = '>> Copy >>'
    TabOrder = 8
    OnClick = bCopyClick
  end
  object Query: TIBQuery
    Database = dbPersistence
    Transaction = IBTransaction
    CachedUpdates = False
    Left = 344
    Top = 288
  end
  object IBTransaction: TIBTransaction
    Active = False
    DefaultDatabase = dbPersistence
    Left = 304
    Top = 288
  end
  object dbPersistence: TIBDatabase
    DatabaseName = 'Persistence.gdb'
    Params.Strings = (
      'USER "SYSDBA"'
      'PASSWORD "masterkey"')
    LoginPrompt = False
    DefaultTransaction = IBTransaction
    IdleTimer = 0
    SQLDialect = 1
    TraceFlags = []
    Left = 264
    Top = 288
  end
  object StoredProcNextId: TIBStoredProc
    Database = dbPersistence
    Transaction = IBTransaction
    Params = <>
    Left = 384
    Top = 288
  end
end
