object FormSetup: TFormSetup
  Left = 0
  Top = 0
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080
  ClientHeight = 224
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  DesignSize = (
    360
    224)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 132
    Width = 122
    Height = 13
    Caption = #1090#1077#1082#1091#1097#1080#1081' '#1087#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1072#1084
  end
  object cbUseUserPath: TCheckBox
    Left = 16
    Top = 8
    Width = 336
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = #1048#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1080#1081' '#1087#1091#1090#1100' '#1082' '#1089#1093#1077#1084#1072#1084
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object edFileSch: TJvFilenameEdit
    Left = 16
    Top = 81
    Width = 336
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = ''
    OnChange = edFileSchChange
  end
  object edDirSch: TJvDirectoryEdit
    Left = 16
    Top = 31
    Width = 336
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = ''
    OnChange = edDirSchChange
  end
  object edDirXML: TJvDirectoryEdit
    Left = 16
    Top = 151
    Width = 336
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = ''
    OnChange = edDirXMLChange
  end
  object cbUserSchema: TCheckBox
    Left = 16
    Top = 58
    Width = 336
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = #1048#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1091#1102' '#1089#1093#1077#1084#1091
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object BindingsList: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 28
    Top = 173
    object LinkControlToPropertyEnabled: TLinkControlToProperty
      Category = 'Quick Bindings'
      Control = cbUseUserPath
      Track = True
      Component = edDirSch
      ComponentProperty = 'Enabled'
    end
    object LinkControlToPropertyEnabled2: TLinkControlToProperty
      Category = 'Quick Bindings'
      Control = cbUserSchema
      Track = True
      Component = edFileSch
      ComponentProperty = 'Enabled'
    end
  end
end
