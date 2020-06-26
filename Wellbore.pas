
{*****************************************************************************************************************************}
{                                                                                                                             }
{                                                      XML Data Binding                                                       }
{                                                                                                                             }
{         Generated on: 22.05.2020 10:30:23                                                                                   }
{       Generated from: C:\Projects\C#\witsml\ext\devkit-c\doc\Standards\energyml\data\witsml\v2.0\xsd_schemas\Wellbore.xsd   }
{   Settings stored in: C:\XE\Projects\Wellbore                                                                               }
{                                                                                                                             }
{*****************************************************************************************************************************}

unit Wellbore;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLAbstractObject = interface;
  IXMLObjectAlias = interface;
  IXMLObjectAliasList = interface;
  IXMLCitation = interface;
  IXMLCustomData = interface;
  IXMLExtensionNameValue = interface;
  IXMLExtensionNameValueList = interface;
  IXMLStringMeasure = interface;
  IXMLWellbore = interface;
  IXMLMeasuredDepthCoord = interface;
  IXMLWellVerticalDepthCoord = interface;
  IXMLTimeMeasure = interface;
  IXMLDataObjectReference = interface;
  IXMLNameTag = interface;
  IXMLCost = interface;
  IXMLDistanceNorthSouth = interface;
  IXMLDistanceEastWest = interface;
  IXMLReferencePoint = interface;
  IXMLReferencePointList = interface;
  IXMLWellElevationCoord = interface;
  IXMLAbstractWellLocation = interface;
  IXMLAbstractWellLocationList = interface;
  IXMLGeodeticWellLocation = interface;
  IXMLPlaneAngleMeasure = interface;
  IXMLAbstractGeodeticCrs = interface;
  IXMLProjectedWellLocation = interface;
  IXMLAbstractProjectedCrs = interface;
  IXMLWell = interface;
  IXMLDimensionlessMeasure = interface;
  IXMLLengthMeasure = interface;
  IXMLPublicLandSurveySystem = interface;
  IXMLWellDatum = interface;
  IXMLWellDatumList = interface;
  IXMLRefWellbore = interface;
  IXMLRefWellboreRig = interface;
  IXMLAbstractVerticalCrs = interface;
  IXMLString64List = interface;

{ IXMLAbstractObject }

  IXMLAbstractObject = interface(IXMLNode)
    ['{2E30F698-79DF-4369-93D5-0871EAC26BFD}']
    { Property Accessors }
    function Get_ObjectVersion: UnicodeString;
    function Get_SchemaVersion: UnicodeString;
    function Get_Uuid: UnicodeString;
    function Get_ExistenceKind: UnicodeString;
    function Get_Aliases: IXMLObjectAliasList;
    function Get_Citation: IXMLCitation;
    function Get_CustomData: IXMLCustomData;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_ObjectVersion(Value: UnicodeString);
    procedure Set_SchemaVersion(Value: UnicodeString);
    procedure Set_Uuid(Value: UnicodeString);
    procedure Set_ExistenceKind(Value: UnicodeString);
    { Methods & Properties }
    property ObjectVersion: UnicodeString read Get_ObjectVersion write Set_ObjectVersion;
    property SchemaVersion: UnicodeString read Get_SchemaVersion write Set_SchemaVersion;
    property Uuid: UnicodeString read Get_Uuid write Set_Uuid;
    property ExistenceKind: UnicodeString read Get_ExistenceKind write Set_ExistenceKind;
    property Aliases: IXMLObjectAliasList read Get_Aliases;
    property Citation: IXMLCitation read Get_Citation;
    property CustomData: IXMLCustomData read Get_CustomData;
    property ExtensionNameValue: IXMLExtensionNameValueList read Get_ExtensionNameValue;
  end;

{ IXMLObjectAlias }

  IXMLObjectAlias = interface(IXMLNode)
    ['{FBC3242E-A73D-4E99-84B8-4C7350013039}']
    { Property Accessors }
    function Get_Authority: UnicodeString;
    function Get_Identifier: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Authority(Value: UnicodeString);
    procedure Set_Identifier(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Authority: UnicodeString read Get_Authority write Set_Authority;
    property Identifier: UnicodeString read Get_Identifier write Set_Identifier;
    property Description: UnicodeString read Get_Description write Set_Description;
  end;

{ IXMLObjectAliasList }

  IXMLObjectAliasList = interface(IXMLNodeCollection)
    ['{1B4190EF-4A98-4F66-A6BE-B6FE478049DC}']
    { Methods & Properties }
    function Add: IXMLObjectAlias;
    function Insert(const Index: Integer): IXMLObjectAlias;

    function Get_Item(Index: Integer): IXMLObjectAlias;
    property Items[Index: Integer]: IXMLObjectAlias read Get_Item; default;
  end;

{ IXMLCitation }

  IXMLCitation = interface(IXMLNode)
    ['{79619B1B-1FBF-4338-BA86-DA7E79A0DF8A}']
    { Property Accessors }
    function Get_Title: UnicodeString;
    function Get_Originator: UnicodeString;
    function Get_Creation: UnicodeString;
    function Get_Format: UnicodeString;
    function Get_Editor: UnicodeString;
    function Get_LastUpdate: UnicodeString;
    function Get_VersionString: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_DescriptiveKeywords: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Originator(Value: UnicodeString);
    procedure Set_Creation(Value: UnicodeString);
    procedure Set_Format(Value: UnicodeString);
    procedure Set_Editor(Value: UnicodeString);
    procedure Set_LastUpdate(Value: UnicodeString);
    procedure Set_VersionString(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DescriptiveKeywords(Value: UnicodeString);
    { Methods & Properties }
    property Title: UnicodeString read Get_Title write Set_Title;
    property Originator: UnicodeString read Get_Originator write Set_Originator;
    property Creation: UnicodeString read Get_Creation write Set_Creation;
    property Format: UnicodeString read Get_Format write Set_Format;
    property Editor: UnicodeString read Get_Editor write Set_Editor;
    property LastUpdate: UnicodeString read Get_LastUpdate write Set_LastUpdate;
    property VersionString: UnicodeString read Get_VersionString write Set_VersionString;
    property Description: UnicodeString read Get_Description write Set_Description;
    property DescriptiveKeywords: UnicodeString read Get_DescriptiveKeywords write Set_DescriptiveKeywords;
  end;

{ IXMLCustomData }

  IXMLCustomData = interface(IXMLNode)
    ['{2A5769EC-99ED-42B6-A95F-F6E3F283E837}']
  end;

{ IXMLExtensionNameValue }

  IXMLExtensionNameValue = interface(IXMLNode)
    ['{297242A8-20BD-40DA-9322-1F235A82DEF9}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Value: IXMLStringMeasure;
    function Get_MeasureClass: UnicodeString;
    function Get_DTim: UnicodeString;
    function Get_Index: Integer;
    function Get_Description: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_MeasureClass(Value: UnicodeString);
    procedure Set_DTim(Value: UnicodeString);
    procedure Set_Index(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Value: IXMLStringMeasure read Get_Value;
    property MeasureClass: UnicodeString read Get_MeasureClass write Set_MeasureClass;
    property DTim: UnicodeString read Get_DTim write Set_DTim;
    property Index: Integer read Get_Index write Set_Index;
    property Description: UnicodeString read Get_Description write Set_Description;
  end;

{ IXMLExtensionNameValueList }

  IXMLExtensionNameValueList = interface(IXMLNodeCollection)
    ['{24B64928-0303-447F-8035-2464077A7FB2}']
    { Methods & Properties }
    function Add: IXMLExtensionNameValue;
    function Insert(const Index: Integer): IXMLExtensionNameValue;

    function Get_Item(Index: Integer): IXMLExtensionNameValue;
    property Items[Index: Integer]: IXMLExtensionNameValue read Get_Item; default;
  end;

{ IXMLStringMeasure }

  IXMLStringMeasure = interface(IXMLNode)
    ['{876CDFE6-7196-446A-B9D2-64244CA5C5EC}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
  end;

{ IXMLWellbore }

  IXMLWellbore = interface(IXMLAbstractObject)
    ['{7008462B-9E5F-49BA-8D74-DBCA1548D09C}']
    { Property Accessors }
    function Get_Number: UnicodeString;
    function Get_SuffixAPI: UnicodeString;
    function Get_NumGovt: UnicodeString;
    function Get_StatusWellbore: UnicodeString;
    function Get_IsActive: Boolean;
    function Get_PurposeWellbore: UnicodeString;
    function Get_TypeWellbore: UnicodeString;
    function Get_Shape: UnicodeString;
    function Get_DTimKickoff: UnicodeString;
    function Get_AchievedTD: Boolean;
    function Get_Md: IXMLMeasuredDepthCoord;
    function Get_Tvd: IXMLWellVerticalDepthCoord;
    function Get_MdBit: IXMLMeasuredDepthCoord;
    function Get_TvdBit: IXMLWellVerticalDepthCoord;
    function Get_MdKickoff: IXMLMeasuredDepthCoord;
    function Get_TvdKickoff: IXMLWellVerticalDepthCoord;
    function Get_MdPlanned: IXMLMeasuredDepthCoord;
    function Get_TvdPlanned: IXMLWellVerticalDepthCoord;
    function Get_MdSubSeaPlanned: IXMLMeasuredDepthCoord;
    function Get_TvdSubSeaPlanned: IXMLWellVerticalDepthCoord;
    function Get_DayTarget: IXMLTimeMeasure;
    function Get_Well: IXMLDataObjectReference;
    function Get_ParentWellbore: IXMLDataObjectReference;
    procedure Set_Number(Value: UnicodeString);
    procedure Set_SuffixAPI(Value: UnicodeString);
    procedure Set_NumGovt(Value: UnicodeString);
    procedure Set_StatusWellbore(Value: UnicodeString);
    procedure Set_IsActive(Value: Boolean);
    procedure Set_PurposeWellbore(Value: UnicodeString);
    procedure Set_TypeWellbore(Value: UnicodeString);
    procedure Set_Shape(Value: UnicodeString);
    procedure Set_DTimKickoff(Value: UnicodeString);
    procedure Set_AchievedTD(Value: Boolean);
    { Methods & Properties }
    property Number: UnicodeString read Get_Number write Set_Number;
    property SuffixAPI: UnicodeString read Get_SuffixAPI write Set_SuffixAPI;
    property NumGovt: UnicodeString read Get_NumGovt write Set_NumGovt;
    property StatusWellbore: UnicodeString read Get_StatusWellbore write Set_StatusWellbore;
    property IsActive: Boolean read Get_IsActive write Set_IsActive;
    property PurposeWellbore: UnicodeString read Get_PurposeWellbore write Set_PurposeWellbore;
    property TypeWellbore: UnicodeString read Get_TypeWellbore write Set_TypeWellbore;
    property Shape: UnicodeString read Get_Shape write Set_Shape;
    property DTimKickoff: UnicodeString read Get_DTimKickoff write Set_DTimKickoff;
    property AchievedTD: Boolean read Get_AchievedTD write Set_AchievedTD;
    property Md: IXMLMeasuredDepthCoord read Get_Md;
    property Tvd: IXMLWellVerticalDepthCoord read Get_Tvd;
    property MdBit: IXMLMeasuredDepthCoord read Get_MdBit;
    property TvdBit: IXMLWellVerticalDepthCoord read Get_TvdBit;
    property MdKickoff: IXMLMeasuredDepthCoord read Get_MdKickoff;
    property TvdKickoff: IXMLWellVerticalDepthCoord read Get_TvdKickoff;
    property MdPlanned: IXMLMeasuredDepthCoord read Get_MdPlanned;
    property TvdPlanned: IXMLWellVerticalDepthCoord read Get_TvdPlanned;
    property MdSubSeaPlanned: IXMLMeasuredDepthCoord read Get_MdSubSeaPlanned;
    property TvdSubSeaPlanned: IXMLWellVerticalDepthCoord read Get_TvdSubSeaPlanned;
    property DayTarget: IXMLTimeMeasure read Get_DayTarget;
    property Well: IXMLDataObjectReference read Get_Well;
    property ParentWellbore: IXMLDataObjectReference read Get_ParentWellbore;
  end;

{ IXMLMeasuredDepthCoord }

  IXMLMeasuredDepthCoord = interface(IXMLNode)
    ['{0E65A3B3-42E0-42C4-8C3F-02D1C35BA874}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property Datum: UnicodeString read Get_Datum write Set_Datum;
  end;

{ IXMLWellVerticalDepthCoord }

  IXMLWellVerticalDepthCoord = interface(IXMLNode)
    ['{CCF903C2-898D-41F7-8579-41A3906BF7F5}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property Datum: UnicodeString read Get_Datum write Set_Datum;
  end;

{ IXMLTimeMeasure }

  IXMLTimeMeasure = interface(IXMLNode)
    ['{F9FDDCBE-B589-4572-9A0E-0A1017FEC01D}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
  end;

{ IXMLDataObjectReference }

  IXMLDataObjectReference = interface(IXMLNode)
    ['{A1040E84-E8D7-4584-AB04-1371C17609ED}']
    { Property Accessors }
    function Get_ContentType: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Uuid: UnicodeString;
    function Get_UuidAuthority: UnicodeString;
    function Get_Uri: UnicodeString;
    function Get_VersionString: UnicodeString;
    procedure Set_ContentType(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Uuid(Value: UnicodeString);
    procedure Set_UuidAuthority(Value: UnicodeString);
    procedure Set_Uri(Value: UnicodeString);
    procedure Set_VersionString(Value: UnicodeString);
    { Methods & Properties }
    property ContentType: UnicodeString read Get_ContentType write Set_ContentType;
    property Title: UnicodeString read Get_Title write Set_Title;
    property Uuid: UnicodeString read Get_Uuid write Set_Uuid;
    property UuidAuthority: UnicodeString read Get_UuidAuthority write Set_UuidAuthority;
    property Uri: UnicodeString read Get_Uri write Set_Uri;
    property VersionString: UnicodeString read Get_VersionString write Set_VersionString;
  end;

{ IXMLNameTag }

  IXMLNameTag = interface(IXMLNode)
    ['{84C760C1-122A-4459-8450-46CBC843CBD8}']
    { Property Accessors }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_NumberingScheme: UnicodeString;
    function Get_Technology: UnicodeString;
    function Get_Location: UnicodeString;
    function Get_InstallationDate: UnicodeString;
    function Get_InstallationCompany: UnicodeString;
    function Get_MountingCode: UnicodeString;
    function Get_Comment: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_NumberingScheme(Value: UnicodeString);
    procedure Set_Technology(Value: UnicodeString);
    procedure Set_Location(Value: UnicodeString);
    procedure Set_InstallationDate(Value: UnicodeString);
    procedure Set_InstallationCompany(Value: UnicodeString);
    procedure Set_MountingCode(Value: UnicodeString);
    procedure Set_Comment(Value: UnicodeString);
    { Methods & Properties }
    property Uid: UnicodeString read Get_Uid write Set_Uid;
    property Name: UnicodeString read Get_Name write Set_Name;
    property NumberingScheme: UnicodeString read Get_NumberingScheme write Set_NumberingScheme;
    property Technology: UnicodeString read Get_Technology write Set_Technology;
    property Location: UnicodeString read Get_Location write Set_Location;
    property InstallationDate: UnicodeString read Get_InstallationDate write Set_InstallationDate;
    property InstallationCompany: UnicodeString read Get_InstallationCompany write Set_InstallationCompany;
    property MountingCode: UnicodeString read Get_MountingCode write Set_MountingCode;
    property Comment: UnicodeString read Get_Comment write Set_Comment;
    property ExtensionNameValue: IXMLExtensionNameValueList read Get_ExtensionNameValue;
  end;

{ IXMLCost }

  IXMLCost = interface(IXMLNode)
    ['{81573A12-C267-42AF-8E0F-6D2FE7109326}']
    { Property Accessors }
    function Get_Currency: UnicodeString;
    procedure Set_Currency(Value: UnicodeString);
    { Methods & Properties }
    property Currency: UnicodeString read Get_Currency write Set_Currency;
  end;

{ IXMLDistanceNorthSouth }

  IXMLDistanceNorthSouth = interface(IXMLNode)
    ['{AB9A160E-BCF2-4541-A3E6-842A8AD3B7BD}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    function Get_Reference: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Reference(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property Reference: UnicodeString read Get_Reference write Set_Reference;
  end;

{ IXMLDistanceEastWest }

  IXMLDistanceEastWest = interface(IXMLNode)
    ['{A6C43BE1-AAD6-4445-BA1F-0379BB475783}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    function Get_Reference: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Reference(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property Reference: UnicodeString read Get_Reference write Set_Reference;
  end;

{ IXMLReferencePoint }

  IXMLReferencePoint = interface(IXMLNode)
    ['{C9F8A8A0-6D83-4CE1-8E1E-11CC709E565A}']
    { Property Accessors }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_MeasuredDepth: IXMLMeasuredDepthCoord;
    function Get_Description: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    function Get_Elevation: IXMLWellElevationCoord;
    function Get_Location: IXMLAbstractWellLocationList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Uid: UnicodeString read Get_Uid write Set_Uid;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property MeasuredDepth: IXMLMeasuredDepthCoord read Get_MeasuredDepth;
    property Description: UnicodeString read Get_Description write Set_Description;
    property ExtensionNameValue: IXMLExtensionNameValueList read Get_ExtensionNameValue;
    property Elevation: IXMLWellElevationCoord read Get_Elevation;
    property Location: IXMLAbstractWellLocationList read Get_Location;
  end;

{ IXMLReferencePointList }

  IXMLReferencePointList = interface(IXMLNodeCollection)
    ['{DDEDB9D1-8FEA-4E3A-B3B1-EBE8777142E9}']
    { Methods & Properties }
    function Add: IXMLReferencePoint;
    function Insert(const Index: Integer): IXMLReferencePoint;

    function Get_Item(Index: Integer): IXMLReferencePoint;
    property Items[Index: Integer]: IXMLReferencePoint read Get_Item; default;
  end;

{ IXMLWellElevationCoord }

  IXMLWellElevationCoord = interface(IXMLNode)
    ['{392BEECD-E623-46B0-8BB3-3E73462A4A73}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property Datum: UnicodeString read Get_Datum write Set_Datum;
  end;

{ IXMLAbstractWellLocation }

  IXMLAbstractWellLocation = interface(IXMLNode)
    ['{220BE78A-BBAC-4EF2-A2E6-D09045B76693}']
    { Property Accessors }
    function Get_Uid: UnicodeString;
    function Get_Original: Boolean;
    function Get_Description: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Original(Value: Boolean);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Uid: UnicodeString read Get_Uid write Set_Uid;
    property Original: Boolean read Get_Original write Set_Original;
    property Description: UnicodeString read Get_Description write Set_Description;
    property ExtensionNameValue: IXMLExtensionNameValueList read Get_ExtensionNameValue;
  end;

{ IXMLAbstractWellLocationList }

  IXMLAbstractWellLocationList = interface(IXMLNodeCollection)
    ['{9552FCF6-B250-4FB7-A70A-230A3241196C}']
    { Methods & Properties }
    function Add: IXMLAbstractWellLocation;
    function Insert(const Index: Integer): IXMLAbstractWellLocation;

    function Get_Item(Index: Integer): IXMLAbstractWellLocation;
    property Items[Index: Integer]: IXMLAbstractWellLocation read Get_Item; default;
  end;

{ IXMLGeodeticWellLocation }

  IXMLGeodeticWellLocation = interface(IXMLAbstractWellLocation)
    ['{443F9ECB-4791-4364-8DDC-C29254936571}']
    { Property Accessors }
    function Get_Latitude: IXMLPlaneAngleMeasure;
    function Get_Longitude: IXMLPlaneAngleMeasure;
    function Get_Crs: IXMLAbstractGeodeticCrs;
    { Methods & Properties }
    property Latitude: IXMLPlaneAngleMeasure read Get_Latitude;
    property Longitude: IXMLPlaneAngleMeasure read Get_Longitude;
    property Crs: IXMLAbstractGeodeticCrs read Get_Crs;
  end;

{ IXMLPlaneAngleMeasure }

  IXMLPlaneAngleMeasure = interface(IXMLNode)
    ['{54A57218-428D-4031-9885-75A3C095102F}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
  end;

{ IXMLAbstractGeodeticCrs }

  IXMLAbstractGeodeticCrs = interface(IXMLNode)
    ['{AF623B45-B53B-4A86-8D51-E14CF9CB9F45}']
  end;

{ IXMLProjectedWellLocation }

  IXMLProjectedWellLocation = interface(IXMLAbstractWellLocation)
    ['{0B1FE6EF-1556-4EC9-97F4-046EBE96EA93}']
    { Property Accessors }
    function Get_Coordinate1: Double;
    function Get_Coordinate2: Double;
    function Get_Crs: IXMLAbstractProjectedCrs;
    procedure Set_Coordinate1(Value: Double);
    procedure Set_Coordinate2(Value: Double);
    { Methods & Properties }
    property Coordinate1: Double read Get_Coordinate1 write Set_Coordinate1;
    property Coordinate2: Double read Get_Coordinate2 write Set_Coordinate2;
    property Crs: IXMLAbstractProjectedCrs read Get_Crs;
  end;

{ IXMLAbstractProjectedCrs }

  IXMLAbstractProjectedCrs = interface(IXMLNode)
    ['{A41E619B-A76F-48B3-B7B8-4FDB1D091091}']
  end;

{ IXMLWell }

  IXMLWell = interface(IXMLAbstractObject)
    ['{E09E8D33-FFE5-4A1C-A7EE-FAFA84EE8935}']
    { Property Accessors }
    function Get_NameLegal: UnicodeString;
    function Get_NumLicense: UnicodeString;
    function Get_NumGovt: UnicodeString;
    function Get_DTimLicense: UnicodeString;
    function Get_Field: UnicodeString;
    function Get_Country: UnicodeString;
    function Get_State: UnicodeString;
    function Get_County: UnicodeString;
    function Get_Region: UnicodeString;
    function Get_District: UnicodeString;
    function Get_Block: UnicodeString;
    function Get_TimeZone: UnicodeString;
    function Get_Operator_: UnicodeString;
    function Get_OperatorDiv: UnicodeString;
    function Get_OriginalOperator: UnicodeString;
    function Get_PcInterest: IXMLDimensionlessMeasure;
    function Get_NumAPI: UnicodeString;
    function Get_StatusWell: UnicodeString;
    function Get_PurposeWell: UnicodeString;
    function Get_FluidWell: UnicodeString;
    function Get_DirectionWell: UnicodeString;
    function Get_DTimSpud: UnicodeString;
    function Get_DTimPa: UnicodeString;
    function Get_WaterDepth: IXMLLengthMeasure;
    function Get_GeographicLocationWGS84: IXMLGeodeticWellLocation;
    function Get_WellLocation: IXMLAbstractWellLocationList;
    function Get_WellPublicLandSurveySystemLocation: IXMLPublicLandSurveySystem;
    function Get_ReferencePoint: IXMLReferencePointList;
    function Get_WellheadElevation: IXMLWellElevationCoord;
    function Get_WellDatum: IXMLWellDatumList;
    function Get_GroundElevation: IXMLWellElevationCoord;
    procedure Set_NameLegal(Value: UnicodeString);
    procedure Set_NumLicense(Value: UnicodeString);
    procedure Set_NumGovt(Value: UnicodeString);
    procedure Set_DTimLicense(Value: UnicodeString);
    procedure Set_Field(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    procedure Set_State(Value: UnicodeString);
    procedure Set_County(Value: UnicodeString);
    procedure Set_Region(Value: UnicodeString);
    procedure Set_District(Value: UnicodeString);
    procedure Set_Block(Value: UnicodeString);
    procedure Set_TimeZone(Value: UnicodeString);
    procedure Set_Operator_(Value: UnicodeString);
    procedure Set_OperatorDiv(Value: UnicodeString);
    procedure Set_OriginalOperator(Value: UnicodeString);
    procedure Set_NumAPI(Value: UnicodeString);
    procedure Set_StatusWell(Value: UnicodeString);
    procedure Set_PurposeWell(Value: UnicodeString);
    procedure Set_FluidWell(Value: UnicodeString);
    procedure Set_DirectionWell(Value: UnicodeString);
    procedure Set_DTimSpud(Value: UnicodeString);
    procedure Set_DTimPa(Value: UnicodeString);
    { Methods & Properties }
    property NameLegal: UnicodeString read Get_NameLegal write Set_NameLegal;
    property NumLicense: UnicodeString read Get_NumLicense write Set_NumLicense;
    property NumGovt: UnicodeString read Get_NumGovt write Set_NumGovt;
    property DTimLicense: UnicodeString read Get_DTimLicense write Set_DTimLicense;
    property Field: UnicodeString read Get_Field write Set_Field;
    property Country: UnicodeString read Get_Country write Set_Country;
    property State: UnicodeString read Get_State write Set_State;
    property County: UnicodeString read Get_County write Set_County;
    property Region: UnicodeString read Get_Region write Set_Region;
    property District: UnicodeString read Get_District write Set_District;
    property Block: UnicodeString read Get_Block write Set_Block;
    property TimeZone: UnicodeString read Get_TimeZone write Set_TimeZone;
    property Operator_: UnicodeString read Get_Operator_ write Set_Operator_;
    property OperatorDiv: UnicodeString read Get_OperatorDiv write Set_OperatorDiv;
    property OriginalOperator: UnicodeString read Get_OriginalOperator write Set_OriginalOperator;
    property PcInterest: IXMLDimensionlessMeasure read Get_PcInterest;
    property NumAPI: UnicodeString read Get_NumAPI write Set_NumAPI;
    property StatusWell: UnicodeString read Get_StatusWell write Set_StatusWell;
    property PurposeWell: UnicodeString read Get_PurposeWell write Set_PurposeWell;
    property FluidWell: UnicodeString read Get_FluidWell write Set_FluidWell;
    property DirectionWell: UnicodeString read Get_DirectionWell write Set_DirectionWell;
    property DTimSpud: UnicodeString read Get_DTimSpud write Set_DTimSpud;
    property DTimPa: UnicodeString read Get_DTimPa write Set_DTimPa;
    property WaterDepth: IXMLLengthMeasure read Get_WaterDepth;
    property GeographicLocationWGS84: IXMLGeodeticWellLocation read Get_GeographicLocationWGS84;
    property WellLocation: IXMLAbstractWellLocationList read Get_WellLocation;
    property WellPublicLandSurveySystemLocation: IXMLPublicLandSurveySystem read Get_WellPublicLandSurveySystemLocation;
    property ReferencePoint: IXMLReferencePointList read Get_ReferencePoint;
    property WellheadElevation: IXMLWellElevationCoord read Get_WellheadElevation;
    property WellDatum: IXMLWellDatumList read Get_WellDatum;
    property GroundElevation: IXMLWellElevationCoord read Get_GroundElevation;
  end;

{ IXMLDimensionlessMeasure }

  IXMLDimensionlessMeasure = interface(IXMLNode)
    ['{FC6FC9C7-CAFB-4BE8-B382-9B9F9EF6DC37}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
  end;

{ IXMLLengthMeasure }

  IXMLLengthMeasure = interface(IXMLNode)
    ['{AA8D0688-EC71-442F-BD17-0B26FC21E0F5}']
    { Property Accessors }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    { Methods & Properties }
    property Uom: UnicodeString read Get_Uom write Set_Uom;
  end;

{ IXMLPublicLandSurveySystem }

  IXMLPublicLandSurveySystem = interface(IXMLNode)
    ['{6129EC2A-6E48-4122-82BA-00A46A291E03}']
    { Property Accessors }
    function Get_PrincipalMeridian: UnicodeString;
    function Get_Range: Integer;
    function Get_RangeDir: UnicodeString;
    function Get_Township: Integer;
    function Get_TownshipDir: UnicodeString;
    function Get_Section: UnicodeString;
    function Get_QuarterSection: UnicodeString;
    function Get_QuarterTownship: UnicodeString;
    function Get_FootageNS: IXMLDistanceNorthSouth;
    function Get_FootageEW: IXMLDistanceEastWest;
    procedure Set_PrincipalMeridian(Value: UnicodeString);
    procedure Set_Range(Value: Integer);
    procedure Set_RangeDir(Value: UnicodeString);
    procedure Set_Township(Value: Integer);
    procedure Set_TownshipDir(Value: UnicodeString);
    procedure Set_Section(Value: UnicodeString);
    procedure Set_QuarterSection(Value: UnicodeString);
    procedure Set_QuarterTownship(Value: UnicodeString);
    { Methods & Properties }
    property PrincipalMeridian: UnicodeString read Get_PrincipalMeridian write Set_PrincipalMeridian;
    property Range: Integer read Get_Range write Set_Range;
    property RangeDir: UnicodeString read Get_RangeDir write Set_RangeDir;
    property Township: Integer read Get_Township write Set_Township;
    property TownshipDir: UnicodeString read Get_TownshipDir write Set_TownshipDir;
    property Section: UnicodeString read Get_Section write Set_Section;
    property QuarterSection: UnicodeString read Get_QuarterSection write Set_QuarterSection;
    property QuarterTownship: UnicodeString read Get_QuarterTownship write Set_QuarterTownship;
    property FootageNS: IXMLDistanceNorthSouth read Get_FootageNS;
    property FootageEW: IXMLDistanceEastWest read Get_FootageEW;
  end;

{ IXMLWellDatum }

  IXMLWellDatum = interface(IXMLNode)
    ['{82953D08-7134-4D1F-B1C3-9E5219014C80}']
    { Property Accessors }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_Kind: IXMLString64List;
    function Get_MeasuredDepth: IXMLMeasuredDepthCoord;
    function Get_Comment: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    function Get_Wellbore: IXMLRefWellbore;
    function Get_Rig: IXMLRefWellboreRig;
    function Get_Elevation: IXMLWellElevationCoord;
    function Get_HorizontalLocation: IXMLAbstractWellLocation;
    function Get_Crs: IXMLAbstractVerticalCrs;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    procedure Set_Comment(Value: UnicodeString);
    { Methods & Properties }
    property Uid: UnicodeString read Get_Uid write Set_Uid;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Code: UnicodeString read Get_Code write Set_Code;
    property Kind: IXMLString64List read Get_Kind;
    property MeasuredDepth: IXMLMeasuredDepthCoord read Get_MeasuredDepth;
    property Comment: UnicodeString read Get_Comment write Set_Comment;
    property ExtensionNameValue: IXMLExtensionNameValueList read Get_ExtensionNameValue;
    property Wellbore: IXMLRefWellbore read Get_Wellbore;
    property Rig: IXMLRefWellboreRig read Get_Rig;
    property Elevation: IXMLWellElevationCoord read Get_Elevation;
    property HorizontalLocation: IXMLAbstractWellLocation read Get_HorizontalLocation;
    property Crs: IXMLAbstractVerticalCrs read Get_Crs;
  end;

{ IXMLWellDatumList }

  IXMLWellDatumList = interface(IXMLNodeCollection)
    ['{29F2C262-7AF9-4F0B-894E-47F6FE05AC08}']
    { Methods & Properties }
    function Add: IXMLWellDatum;
    function Insert(const Index: Integer): IXMLWellDatum;

    function Get_Item(Index: Integer): IXMLWellDatum;
    property Items[Index: Integer]: IXMLWellDatum read Get_Item; default;
  end;

{ IXMLRefWellbore }

  IXMLRefWellbore = interface(IXMLNode)
    ['{D7AF834E-B0B4-4752-AE66-9FBA4ED72D61}']
    { Property Accessors }
    function Get_WellboreReference: UnicodeString;
    function Get_WellParent: UnicodeString;
    procedure Set_WellboreReference(Value: UnicodeString);
    procedure Set_WellParent(Value: UnicodeString);
    { Methods & Properties }
    property WellboreReference: UnicodeString read Get_WellboreReference write Set_WellboreReference;
    property WellParent: UnicodeString read Get_WellParent write Set_WellParent;
  end;

{ IXMLRefWellboreRig }

  IXMLRefWellboreRig = interface(IXMLNode)
    ['{52A294C5-B5FA-4F45-B100-F8B6470D035F}']
    { Property Accessors }
    function Get_RigReference: UnicodeString;
    function Get_WellboreParent: UnicodeString;
    function Get_WellParent: UnicodeString;
    procedure Set_RigReference(Value: UnicodeString);
    procedure Set_WellboreParent(Value: UnicodeString);
    procedure Set_WellParent(Value: UnicodeString);
    { Methods & Properties }
    property RigReference: UnicodeString read Get_RigReference write Set_RigReference;
    property WellboreParent: UnicodeString read Get_WellboreParent write Set_WellboreParent;
    property WellParent: UnicodeString read Get_WellParent write Set_WellParent;
  end;

{ IXMLAbstractVerticalCrs }

  IXMLAbstractVerticalCrs = interface(IXMLNode)
    ['{A6E287A9-BDD1-4CA8-A836-F0E923020DAF}']
  end;

{ IXMLString64List }

  IXMLString64List = interface(IXMLNodeCollection)
    ['{F72A9F11-B657-4D79-81A3-413C3C1FA69F}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLAbstractObject = class;
  TXMLObjectAlias = class;
  TXMLObjectAliasList = class;
  TXMLCitation = class;
  TXMLCustomData = class;
  TXMLExtensionNameValue = class;
  TXMLExtensionNameValueList = class;
  TXMLStringMeasure = class;
  TXMLWellbore = class;
  TXMLMeasuredDepthCoord = class;
  TXMLWellVerticalDepthCoord = class;
  TXMLTimeMeasure = class;
  TXMLDataObjectReference = class;
  TXMLNameTag = class;
  TXMLCost = class;
  TXMLDistanceNorthSouth = class;
  TXMLDistanceEastWest = class;
  TXMLReferencePoint = class;
  TXMLReferencePointList = class;
  TXMLWellElevationCoord = class;
  TXMLAbstractWellLocation = class;
  TXMLAbstractWellLocationList = class;
  TXMLGeodeticWellLocation = class;
  TXMLPlaneAngleMeasure = class;
  TXMLAbstractGeodeticCrs = class;
  TXMLProjectedWellLocation = class;
  TXMLAbstractProjectedCrs = class;
  TXMLWell = class;
  TXMLDimensionlessMeasure = class;
  TXMLLengthMeasure = class;
  TXMLPublicLandSurveySystem = class;
  TXMLWellDatum = class;
  TXMLWellDatumList = class;
  TXMLRefWellbore = class;
  TXMLRefWellboreRig = class;
  TXMLAbstractVerticalCrs = class;
  TXMLString64List = class;

{ TXMLAbstractObject }

  TXMLAbstractObject = class(TXMLNode, IXMLAbstractObject)
  private
    FAliases: IXMLObjectAliasList;
    FExtensionNameValue: IXMLExtensionNameValueList;
  protected
    { IXMLAbstractObject }
    function Get_ObjectVersion: UnicodeString;
    function Get_SchemaVersion: UnicodeString;
    function Get_Uuid: UnicodeString;
    function Get_ExistenceKind: UnicodeString;
    function Get_Aliases: IXMLObjectAliasList;
    function Get_Citation: IXMLCitation;
    function Get_CustomData: IXMLCustomData;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_ObjectVersion(Value: UnicodeString);
    procedure Set_SchemaVersion(Value: UnicodeString);
    procedure Set_Uuid(Value: UnicodeString);
    procedure Set_ExistenceKind(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLObjectAlias }

  TXMLObjectAlias = class(TXMLNode, IXMLObjectAlias)
  protected
    { IXMLObjectAlias }
    function Get_Authority: UnicodeString;
    function Get_Identifier: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Authority(Value: UnicodeString);
    procedure Set_Identifier(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
  end;

{ TXMLObjectAliasList }

  TXMLObjectAliasList = class(TXMLNodeCollection, IXMLObjectAliasList)
  protected
    { IXMLObjectAliasList }
    function Add: IXMLObjectAlias;
    function Insert(const Index: Integer): IXMLObjectAlias;

    function Get_Item(Index: Integer): IXMLObjectAlias;
  end;

{ TXMLCitation }

  TXMLCitation = class(TXMLNode, IXMLCitation)
  protected
    { IXMLCitation }
    function Get_Title: UnicodeString;
    function Get_Originator: UnicodeString;
    function Get_Creation: UnicodeString;
    function Get_Format: UnicodeString;
    function Get_Editor: UnicodeString;
    function Get_LastUpdate: UnicodeString;
    function Get_VersionString: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_DescriptiveKeywords: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Originator(Value: UnicodeString);
    procedure Set_Creation(Value: UnicodeString);
    procedure Set_Format(Value: UnicodeString);
    procedure Set_Editor(Value: UnicodeString);
    procedure Set_LastUpdate(Value: UnicodeString);
    procedure Set_VersionString(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DescriptiveKeywords(Value: UnicodeString);
  end;

{ TXMLCustomData }

  TXMLCustomData = class(TXMLNode, IXMLCustomData)
  protected
    { IXMLCustomData }
  end;

{ TXMLExtensionNameValue }

  TXMLExtensionNameValue = class(TXMLNode, IXMLExtensionNameValue)
  protected
    { IXMLExtensionNameValue }
    function Get_Name: UnicodeString;
    function Get_Value: IXMLStringMeasure;
    function Get_MeasureClass: UnicodeString;
    function Get_DTim: UnicodeString;
    function Get_Index: Integer;
    function Get_Description: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_MeasureClass(Value: UnicodeString);
    procedure Set_DTim(Value: UnicodeString);
    procedure Set_Index(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLExtensionNameValueList }

  TXMLExtensionNameValueList = class(TXMLNodeCollection, IXMLExtensionNameValueList)
  protected
    { IXMLExtensionNameValueList }
    function Add: IXMLExtensionNameValue;
    function Insert(const Index: Integer): IXMLExtensionNameValue;

    function Get_Item(Index: Integer): IXMLExtensionNameValue;
  end;

{ TXMLStringMeasure }

  TXMLStringMeasure = class(TXMLNode, IXMLStringMeasure)
  protected
    { IXMLStringMeasure }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
  end;

{ TXMLWellbore }

  TXMLWellbore = class(TXMLAbstractObject, IXMLWellbore)
  protected
    { IXMLWellbore }
    function Get_Number: UnicodeString;
    function Get_SuffixAPI: UnicodeString;
    function Get_NumGovt: UnicodeString;
    function Get_StatusWellbore: UnicodeString;
    function Get_IsActive: Boolean;
    function Get_PurposeWellbore: UnicodeString;
    function Get_TypeWellbore: UnicodeString;
    function Get_Shape: UnicodeString;
    function Get_DTimKickoff: UnicodeString;
    function Get_AchievedTD: Boolean;
    function Get_Md: IXMLMeasuredDepthCoord;
    function Get_Tvd: IXMLWellVerticalDepthCoord;
    function Get_MdBit: IXMLMeasuredDepthCoord;
    function Get_TvdBit: IXMLWellVerticalDepthCoord;
    function Get_MdKickoff: IXMLMeasuredDepthCoord;
    function Get_TvdKickoff: IXMLWellVerticalDepthCoord;
    function Get_MdPlanned: IXMLMeasuredDepthCoord;
    function Get_TvdPlanned: IXMLWellVerticalDepthCoord;
    function Get_MdSubSeaPlanned: IXMLMeasuredDepthCoord;
    function Get_TvdSubSeaPlanned: IXMLWellVerticalDepthCoord;
    function Get_DayTarget: IXMLTimeMeasure;
    function Get_Well: IXMLDataObjectReference;
    function Get_ParentWellbore: IXMLDataObjectReference;
    procedure Set_Number(Value: UnicodeString);
    procedure Set_SuffixAPI(Value: UnicodeString);
    procedure Set_NumGovt(Value: UnicodeString);
    procedure Set_StatusWellbore(Value: UnicodeString);
    procedure Set_IsActive(Value: Boolean);
    procedure Set_PurposeWellbore(Value: UnicodeString);
    procedure Set_TypeWellbore(Value: UnicodeString);
    procedure Set_Shape(Value: UnicodeString);
    procedure Set_DTimKickoff(Value: UnicodeString);
    procedure Set_AchievedTD(Value: Boolean);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMeasuredDepthCoord }

  TXMLMeasuredDepthCoord = class(TXMLNode, IXMLMeasuredDepthCoord)
  protected
    { IXMLMeasuredDepthCoord }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
  end;

{ TXMLWellVerticalDepthCoord }

  TXMLWellVerticalDepthCoord = class(TXMLNode, IXMLWellVerticalDepthCoord)
  protected
    { IXMLWellVerticalDepthCoord }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
  end;

{ TXMLTimeMeasure }

  TXMLTimeMeasure = class(TXMLNode, IXMLTimeMeasure)
  protected
    { IXMLTimeMeasure }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
  end;

{ TXMLDataObjectReference }

  TXMLDataObjectReference = class(TXMLNode, IXMLDataObjectReference)
  protected
    { IXMLDataObjectReference }
    function Get_ContentType: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Uuid: UnicodeString;
    function Get_UuidAuthority: UnicodeString;
    function Get_Uri: UnicodeString;
    function Get_VersionString: UnicodeString;
    procedure Set_ContentType(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Uuid(Value: UnicodeString);
    procedure Set_UuidAuthority(Value: UnicodeString);
    procedure Set_Uri(Value: UnicodeString);
    procedure Set_VersionString(Value: UnicodeString);
  end;

{ TXMLNameTag }

  TXMLNameTag = class(TXMLNode, IXMLNameTag)
  private
    FExtensionNameValue: IXMLExtensionNameValueList;
  protected
    { IXMLNameTag }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_NumberingScheme: UnicodeString;
    function Get_Technology: UnicodeString;
    function Get_Location: UnicodeString;
    function Get_InstallationDate: UnicodeString;
    function Get_InstallationCompany: UnicodeString;
    function Get_MountingCode: UnicodeString;
    function Get_Comment: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_NumberingScheme(Value: UnicodeString);
    procedure Set_Technology(Value: UnicodeString);
    procedure Set_Location(Value: UnicodeString);
    procedure Set_InstallationDate(Value: UnicodeString);
    procedure Set_InstallationCompany(Value: UnicodeString);
    procedure Set_MountingCode(Value: UnicodeString);
    procedure Set_Comment(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCost }

  TXMLCost = class(TXMLNode, IXMLCost)
  protected
    { IXMLCost }
    function Get_Currency: UnicodeString;
    procedure Set_Currency(Value: UnicodeString);
  end;

{ TXMLDistanceNorthSouth }

  TXMLDistanceNorthSouth = class(TXMLNode, IXMLDistanceNorthSouth)
  protected
    { IXMLDistanceNorthSouth }
    function Get_Uom: UnicodeString;
    function Get_Reference: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Reference(Value: UnicodeString);
  end;

{ TXMLDistanceEastWest }

  TXMLDistanceEastWest = class(TXMLNode, IXMLDistanceEastWest)
  protected
    { IXMLDistanceEastWest }
    function Get_Uom: UnicodeString;
    function Get_Reference: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Reference(Value: UnicodeString);
  end;

{ TXMLReferencePoint }

  TXMLReferencePoint = class(TXMLNode, IXMLReferencePoint)
  private
    FExtensionNameValue: IXMLExtensionNameValueList;
    FLocation: IXMLAbstractWellLocationList;
  protected
    { IXMLReferencePoint }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_MeasuredDepth: IXMLMeasuredDepthCoord;
    function Get_Description: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    function Get_Elevation: IXMLWellElevationCoord;
    function Get_Location: IXMLAbstractWellLocationList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLReferencePointList }

  TXMLReferencePointList = class(TXMLNodeCollection, IXMLReferencePointList)
  protected
    { IXMLReferencePointList }
    function Add: IXMLReferencePoint;
    function Insert(const Index: Integer): IXMLReferencePoint;

    function Get_Item(Index: Integer): IXMLReferencePoint;
  end;

{ TXMLWellElevationCoord }

  TXMLWellElevationCoord = class(TXMLNode, IXMLWellElevationCoord)
  protected
    { IXMLWellElevationCoord }
    function Get_Uom: UnicodeString;
    function Get_Datum: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_Datum(Value: UnicodeString);
  end;

{ TXMLAbstractWellLocation }

  TXMLAbstractWellLocation = class(TXMLNode, IXMLAbstractWellLocation)
  private
    FExtensionNameValue: IXMLExtensionNameValueList;
  protected
    { IXMLAbstractWellLocation }
    function Get_Uid: UnicodeString;
    function Get_Original: Boolean;
    function Get_Description: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Original(Value: Boolean);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractWellLocationList }

  TXMLAbstractWellLocationList = class(TXMLNodeCollection, IXMLAbstractWellLocationList)
  protected
    { IXMLAbstractWellLocationList }
    function Add: IXMLAbstractWellLocation;
    function Insert(const Index: Integer): IXMLAbstractWellLocation;

    function Get_Item(Index: Integer): IXMLAbstractWellLocation;
  end;

{ TXMLGeodeticWellLocation }

  TXMLGeodeticWellLocation = class(TXMLAbstractWellLocation, IXMLGeodeticWellLocation)
  protected
    { IXMLGeodeticWellLocation }
    function Get_Latitude: IXMLPlaneAngleMeasure;
    function Get_Longitude: IXMLPlaneAngleMeasure;
    function Get_Crs: IXMLAbstractGeodeticCrs;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPlaneAngleMeasure }

  TXMLPlaneAngleMeasure = class(TXMLNode, IXMLPlaneAngleMeasure)
  protected
    { IXMLPlaneAngleMeasure }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
  end;

{ TXMLAbstractGeodeticCrs }

  TXMLAbstractGeodeticCrs = class(TXMLNode, IXMLAbstractGeodeticCrs)
  protected
    { IXMLAbstractGeodeticCrs }
  end;

{ TXMLProjectedWellLocation }

  TXMLProjectedWellLocation = class(TXMLAbstractWellLocation, IXMLProjectedWellLocation)
  protected
    { IXMLProjectedWellLocation }
    function Get_Coordinate1: Double;
    function Get_Coordinate2: Double;
    function Get_Crs: IXMLAbstractProjectedCrs;
    procedure Set_Coordinate1(Value: Double);
    procedure Set_Coordinate2(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractProjectedCrs }

  TXMLAbstractProjectedCrs = class(TXMLNode, IXMLAbstractProjectedCrs)
  protected
    { IXMLAbstractProjectedCrs }
  end;

{ TXMLWell }

  TXMLWell = class(TXMLAbstractObject, IXMLWell)
  private
    FWellLocation: IXMLAbstractWellLocationList;
    FReferencePoint: IXMLReferencePointList;
    FWellDatum: IXMLWellDatumList;
  protected
    { IXMLWell }
    function Get_NameLegal: UnicodeString;
    function Get_NumLicense: UnicodeString;
    function Get_NumGovt: UnicodeString;
    function Get_DTimLicense: UnicodeString;
    function Get_Field: UnicodeString;
    function Get_Country: UnicodeString;
    function Get_State: UnicodeString;
    function Get_County: UnicodeString;
    function Get_Region: UnicodeString;
    function Get_District: UnicodeString;
    function Get_Block: UnicodeString;
    function Get_TimeZone: UnicodeString;
    function Get_Operator_: UnicodeString;
    function Get_OperatorDiv: UnicodeString;
    function Get_OriginalOperator: UnicodeString;
    function Get_PcInterest: IXMLDimensionlessMeasure;
    function Get_NumAPI: UnicodeString;
    function Get_StatusWell: UnicodeString;
    function Get_PurposeWell: UnicodeString;
    function Get_FluidWell: UnicodeString;
    function Get_DirectionWell: UnicodeString;
    function Get_DTimSpud: UnicodeString;
    function Get_DTimPa: UnicodeString;
    function Get_WaterDepth: IXMLLengthMeasure;
    function Get_GeographicLocationWGS84: IXMLGeodeticWellLocation;
    function Get_WellLocation: IXMLAbstractWellLocationList;
    function Get_WellPublicLandSurveySystemLocation: IXMLPublicLandSurveySystem;
    function Get_ReferencePoint: IXMLReferencePointList;
    function Get_WellheadElevation: IXMLWellElevationCoord;
    function Get_WellDatum: IXMLWellDatumList;
    function Get_GroundElevation: IXMLWellElevationCoord;
    procedure Set_NameLegal(Value: UnicodeString);
    procedure Set_NumLicense(Value: UnicodeString);
    procedure Set_NumGovt(Value: UnicodeString);
    procedure Set_DTimLicense(Value: UnicodeString);
    procedure Set_Field(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    procedure Set_State(Value: UnicodeString);
    procedure Set_County(Value: UnicodeString);
    procedure Set_Region(Value: UnicodeString);
    procedure Set_District(Value: UnicodeString);
    procedure Set_Block(Value: UnicodeString);
    procedure Set_TimeZone(Value: UnicodeString);
    procedure Set_Operator_(Value: UnicodeString);
    procedure Set_OperatorDiv(Value: UnicodeString);
    procedure Set_OriginalOperator(Value: UnicodeString);
    procedure Set_NumAPI(Value: UnicodeString);
    procedure Set_StatusWell(Value: UnicodeString);
    procedure Set_PurposeWell(Value: UnicodeString);
    procedure Set_FluidWell(Value: UnicodeString);
    procedure Set_DirectionWell(Value: UnicodeString);
    procedure Set_DTimSpud(Value: UnicodeString);
    procedure Set_DTimPa(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDimensionlessMeasure }

  TXMLDimensionlessMeasure = class(TXMLNode, IXMLDimensionlessMeasure)
  protected
    { IXMLDimensionlessMeasure }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
  end;

{ TXMLLengthMeasure }

  TXMLLengthMeasure = class(TXMLNode, IXMLLengthMeasure)
  protected
    { IXMLLengthMeasure }
    function Get_Uom: UnicodeString;
    procedure Set_Uom(Value: UnicodeString);
  end;

{ TXMLPublicLandSurveySystem }

  TXMLPublicLandSurveySystem = class(TXMLNode, IXMLPublicLandSurveySystem)
  protected
    { IXMLPublicLandSurveySystem }
    function Get_PrincipalMeridian: UnicodeString;
    function Get_Range: Integer;
    function Get_RangeDir: UnicodeString;
    function Get_Township: Integer;
    function Get_TownshipDir: UnicodeString;
    function Get_Section: UnicodeString;
    function Get_QuarterSection: UnicodeString;
    function Get_QuarterTownship: UnicodeString;
    function Get_FootageNS: IXMLDistanceNorthSouth;
    function Get_FootageEW: IXMLDistanceEastWest;
    procedure Set_PrincipalMeridian(Value: UnicodeString);
    procedure Set_Range(Value: Integer);
    procedure Set_RangeDir(Value: UnicodeString);
    procedure Set_Township(Value: Integer);
    procedure Set_TownshipDir(Value: UnicodeString);
    procedure Set_Section(Value: UnicodeString);
    procedure Set_QuarterSection(Value: UnicodeString);
    procedure Set_QuarterTownship(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWellDatum }

  TXMLWellDatum = class(TXMLNode, IXMLWellDatum)
  private
    FKind: IXMLString64List;
    FExtensionNameValue: IXMLExtensionNameValueList;
  protected
    { IXMLWellDatum }
    function Get_Uid: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_Kind: IXMLString64List;
    function Get_MeasuredDepth: IXMLMeasuredDepthCoord;
    function Get_Comment: UnicodeString;
    function Get_ExtensionNameValue: IXMLExtensionNameValueList;
    function Get_Wellbore: IXMLRefWellbore;
    function Get_Rig: IXMLRefWellboreRig;
    function Get_Elevation: IXMLWellElevationCoord;
    function Get_HorizontalLocation: IXMLAbstractWellLocation;
    function Get_Crs: IXMLAbstractVerticalCrs;
    procedure Set_Uid(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    procedure Set_Comment(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWellDatumList }

  TXMLWellDatumList = class(TXMLNodeCollection, IXMLWellDatumList)
  protected
    { IXMLWellDatumList }
    function Add: IXMLWellDatum;
    function Insert(const Index: Integer): IXMLWellDatum;

    function Get_Item(Index: Integer): IXMLWellDatum;
  end;

{ TXMLRefWellbore }

  TXMLRefWellbore = class(TXMLNode, IXMLRefWellbore)
  protected
    { IXMLRefWellbore }
    function Get_WellboreReference: UnicodeString;
    function Get_WellParent: UnicodeString;
    procedure Set_WellboreReference(Value: UnicodeString);
    procedure Set_WellParent(Value: UnicodeString);
  end;

{ TXMLRefWellboreRig }

  TXMLRefWellboreRig = class(TXMLNode, IXMLRefWellboreRig)
  protected
    { IXMLRefWellboreRig }
    function Get_RigReference: UnicodeString;
    function Get_WellboreParent: UnicodeString;
    function Get_WellParent: UnicodeString;
    procedure Set_RigReference(Value: UnicodeString);
    procedure Set_WellboreParent(Value: UnicodeString);
    procedure Set_WellParent(Value: UnicodeString);
  end;

{ TXMLAbstractVerticalCrs }

  TXMLAbstractVerticalCrs = class(TXMLNode, IXMLAbstractVerticalCrs)
  protected
    { IXMLAbstractVerticalCrs }
  end;

{ TXMLString64List }

  TXMLString64List = class(TXMLNodeCollection, IXMLString64List)
  protected
    { IXMLString64List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetWellbore(Doc: IXMLDocument): IXMLWellbore;
function LoadWellbore(const FileName: string): IXMLWellbore;
function NewWellbore: IXMLWellbore;

const
  TargetNamespace = 'http://www.energistics.org/energyml/data/witsmlv2';

implementation

uses Xml.xmlutil;

{ Global Functions }

function GetWellbore(Doc: IXMLDocument): IXMLWellbore;
begin
  Result := Doc.GetDocBinding('Wellbore', TXMLWellbore, TargetNamespace) as IXMLWellbore;
end;

function LoadWellbore(const FileName: string): IXMLWellbore;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Wellbore', TXMLWellbore, TargetNamespace) as IXMLWellbore;
end;

function NewWellbore: IXMLWellbore;
begin
  Result := NewXMLDocument.GetDocBinding('Wellbore', TXMLWellbore, TargetNamespace) as IXMLWellbore;
end;

{ TXMLAbstractObject }

procedure TXMLAbstractObject.AfterConstruction;
begin
  RegisterChildNode('Aliases', TXMLObjectAlias);
  RegisterChildNode('Citation', TXMLCitation);
  RegisterChildNode('CustomData', TXMLCustomData);
  RegisterChildNode('ExtensionNameValue', TXMLExtensionNameValue);
  FAliases := CreateCollection(TXMLObjectAliasList, IXMLObjectAlias, 'Aliases') as IXMLObjectAliasList;
  FExtensionNameValue := CreateCollection(TXMLExtensionNameValueList, IXMLExtensionNameValue, 'ExtensionNameValue') as IXMLExtensionNameValueList;
  inherited;
end;

function TXMLAbstractObject.Get_ObjectVersion: UnicodeString;
begin
  Result := AttributeNodes['objectVersion'].Text;
end;

procedure TXMLAbstractObject.Set_ObjectVersion(Value: UnicodeString);
begin
  SetAttribute('objectVersion', Value);
end;

function TXMLAbstractObject.Get_SchemaVersion: UnicodeString;
begin
  Result := AttributeNodes['schemaVersion'].Text;
end;

procedure TXMLAbstractObject.Set_SchemaVersion(Value: UnicodeString);
begin
  SetAttribute('schemaVersion', Value);
end;

function TXMLAbstractObject.Get_Uuid: UnicodeString;
begin
  Result := AttributeNodes['uuid'].Text;
end;

procedure TXMLAbstractObject.Set_Uuid(Value: UnicodeString);
begin
  SetAttribute('uuid', Value);
end;

function TXMLAbstractObject.Get_ExistenceKind: UnicodeString;
begin
  Result := AttributeNodes['existenceKind'].Text;
end;

procedure TXMLAbstractObject.Set_ExistenceKind(Value: UnicodeString);
begin
  SetAttribute('existenceKind', Value);
end;

function TXMLAbstractObject.Get_Aliases: IXMLObjectAliasList;
begin
  Result := FAliases;
end;

function TXMLAbstractObject.Get_Citation: IXMLCitation;
begin
  Result := ChildNodes['Citation'] as IXMLCitation;
end;

function TXMLAbstractObject.Get_CustomData: IXMLCustomData;
begin
  Result := ChildNodes['CustomData'] as IXMLCustomData;
end;

function TXMLAbstractObject.Get_ExtensionNameValue: IXMLExtensionNameValueList;
begin
  Result := FExtensionNameValue;
end;

{ TXMLObjectAlias }

function TXMLObjectAlias.Get_Authority: UnicodeString;
begin
  Result := AttributeNodes['authority'].Text;
end;

procedure TXMLObjectAlias.Set_Authority(Value: UnicodeString);
begin
  SetAttribute('authority', Value);
end;

function TXMLObjectAlias.Get_Identifier: UnicodeString;
begin
  Result := ChildNodes['Identifier'].Text;
end;

procedure TXMLObjectAlias.Set_Identifier(Value: UnicodeString);
begin
  ChildNodes['Identifier'].NodeValue := Value;
end;

function TXMLObjectAlias.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLObjectAlias.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

{ TXMLObjectAliasList }

function TXMLObjectAliasList.Add: IXMLObjectAlias;
begin
  Result := AddItem(-1) as IXMLObjectAlias;
end;

function TXMLObjectAliasList.Insert(const Index: Integer): IXMLObjectAlias;
begin
  Result := AddItem(Index) as IXMLObjectAlias;
end;

function TXMLObjectAliasList.Get_Item(Index: Integer): IXMLObjectAlias;
begin
  Result := List[Index] as IXMLObjectAlias;
end;

{ TXMLCitation }

function TXMLCitation.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLCitation.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLCitation.Get_Originator: UnicodeString;
begin
  Result := ChildNodes['Originator'].Text;
end;

procedure TXMLCitation.Set_Originator(Value: UnicodeString);
begin
  ChildNodes['Originator'].NodeValue := Value;
end;

function TXMLCitation.Get_Creation: UnicodeString;
begin
  Result := ChildNodes['Creation'].Text;
end;

procedure TXMLCitation.Set_Creation(Value: UnicodeString);
begin
  ChildNodes['Creation'].NodeValue := Value;
end;

function TXMLCitation.Get_Format: UnicodeString;
begin
  Result := ChildNodes['Format'].Text;
end;

procedure TXMLCitation.Set_Format(Value: UnicodeString);
begin
  ChildNodes['Format'].NodeValue := Value;
end;

function TXMLCitation.Get_Editor: UnicodeString;
begin
  Result := ChildNodes['Editor'].Text;
end;

procedure TXMLCitation.Set_Editor(Value: UnicodeString);
begin
  ChildNodes['Editor'].NodeValue := Value;
end;

function TXMLCitation.Get_LastUpdate: UnicodeString;
begin
  Result := ChildNodes['LastUpdate'].Text;
end;

procedure TXMLCitation.Set_LastUpdate(Value: UnicodeString);
begin
  ChildNodes['LastUpdate'].NodeValue := Value;
end;

function TXMLCitation.Get_VersionString: UnicodeString;
begin
  Result := ChildNodes['VersionString'].Text;
end;

procedure TXMLCitation.Set_VersionString(Value: UnicodeString);
begin
  ChildNodes['VersionString'].NodeValue := Value;
end;

function TXMLCitation.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLCitation.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

function TXMLCitation.Get_DescriptiveKeywords: UnicodeString;
begin
  Result := ChildNodes['DescriptiveKeywords'].Text;
end;

procedure TXMLCitation.Set_DescriptiveKeywords(Value: UnicodeString);
begin
  ChildNodes['DescriptiveKeywords'].NodeValue := Value;
end;

{ TXMLCustomData }

{ TXMLExtensionNameValue }

procedure TXMLExtensionNameValue.AfterConstruction;
begin
  RegisterChildNode('Value', TXMLStringMeasure);
  inherited;
end;

function TXMLExtensionNameValue.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLExtensionNameValue.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLExtensionNameValue.Get_Value: IXMLStringMeasure;
begin
  Result := ChildNodes['Value'] as IXMLStringMeasure;
end;

function TXMLExtensionNameValue.Get_MeasureClass: UnicodeString;
begin
  Result := ChildNodes['MeasureClass'].Text;
end;

procedure TXMLExtensionNameValue.Set_MeasureClass(Value: UnicodeString);
begin
  ChildNodes['MeasureClass'].NodeValue := Value;
end;

function TXMLExtensionNameValue.Get_DTim: UnicodeString;
begin
  Result := ChildNodes['DTim'].Text;
end;

procedure TXMLExtensionNameValue.Set_DTim(Value: UnicodeString);
begin
  ChildNodes['DTim'].NodeValue := Value;
end;

function TXMLExtensionNameValue.Get_Index: Integer;
begin
  Result := ChildNodes['Index'].NodeValue;
end;

procedure TXMLExtensionNameValue.Set_Index(Value: Integer);
begin
  ChildNodes['Index'].NodeValue := Value;
end;

function TXMLExtensionNameValue.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLExtensionNameValue.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

{ TXMLExtensionNameValueList }

function TXMLExtensionNameValueList.Add: IXMLExtensionNameValue;
begin
  Result := AddItem(-1) as IXMLExtensionNameValue;
end;

function TXMLExtensionNameValueList.Insert(const Index: Integer): IXMLExtensionNameValue;
begin
  Result := AddItem(Index) as IXMLExtensionNameValue;
end;

function TXMLExtensionNameValueList.Get_Item(Index: Integer): IXMLExtensionNameValue;
begin
  Result := List[Index] as IXMLExtensionNameValue;
end;

{ TXMLStringMeasure }

function TXMLStringMeasure.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLStringMeasure.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

{ TXMLWellbore }

procedure TXMLWellbore.AfterConstruction;
begin
  RegisterChildNode('Md', TXMLMeasuredDepthCoord);
  RegisterChildNode('Tvd', TXMLWellVerticalDepthCoord);
  RegisterChildNode('MdBit', TXMLMeasuredDepthCoord);
  RegisterChildNode('TvdBit', TXMLWellVerticalDepthCoord);
  RegisterChildNode('MdKickoff', TXMLMeasuredDepthCoord);
  RegisterChildNode('TvdKickoff', TXMLWellVerticalDepthCoord);
  RegisterChildNode('MdPlanned', TXMLMeasuredDepthCoord);
  RegisterChildNode('TvdPlanned', TXMLWellVerticalDepthCoord);
  RegisterChildNode('MdSubSeaPlanned', TXMLMeasuredDepthCoord);
  RegisterChildNode('TvdSubSeaPlanned', TXMLWellVerticalDepthCoord);
  RegisterChildNode('DayTarget', TXMLTimeMeasure);
  RegisterChildNode('Well', TXMLDataObjectReference);
  RegisterChildNode('ParentWellbore', TXMLDataObjectReference);
  inherited;
end;

function TXMLWellbore.Get_Number: UnicodeString;
begin
  Result := ChildNodes['Number'].Text;
end;

procedure TXMLWellbore.Set_Number(Value: UnicodeString);
begin
  ChildNodes['Number'].NodeValue := Value;
end;

function TXMLWellbore.Get_SuffixAPI: UnicodeString;
begin
  Result := ChildNodes['SuffixAPI'].Text;
end;

procedure TXMLWellbore.Set_SuffixAPI(Value: UnicodeString);
begin
  ChildNodes['SuffixAPI'].NodeValue := Value;
end;

function TXMLWellbore.Get_NumGovt: UnicodeString;
begin
  Result := ChildNodes['NumGovt'].Text;
end;

procedure TXMLWellbore.Set_NumGovt(Value: UnicodeString);
begin
  ChildNodes['NumGovt'].NodeValue := Value;
end;

function TXMLWellbore.Get_StatusWellbore: UnicodeString;
begin
  Result := ChildNodes['StatusWellbore'].Text;
end;

procedure TXMLWellbore.Set_StatusWellbore(Value: UnicodeString);
begin
  ChildNodes['StatusWellbore'].NodeValue := Value;
end;

function TXMLWellbore.Get_IsActive: Boolean;
begin
  Result := ChildNodes['IsActive'].NodeValue;
end;

procedure TXMLWellbore.Set_IsActive(Value: Boolean);
begin
  ChildNodes['IsActive'].NodeValue := Value;
end;

function TXMLWellbore.Get_PurposeWellbore: UnicodeString;
begin
  Result := ChildNodes['PurposeWellbore'].Text;
end;

procedure TXMLWellbore.Set_PurposeWellbore(Value: UnicodeString);
begin
  ChildNodes['PurposeWellbore'].NodeValue := Value;
end;

function TXMLWellbore.Get_TypeWellbore: UnicodeString;
begin
  Result := ChildNodes['TypeWellbore'].Text;
end;

procedure TXMLWellbore.Set_TypeWellbore(Value: UnicodeString);
begin
  ChildNodes['TypeWellbore'].NodeValue := Value;
end;

function TXMLWellbore.Get_Shape: UnicodeString;
begin
  Result := ChildNodes['Shape'].Text;
end;

procedure TXMLWellbore.Set_Shape(Value: UnicodeString);
begin
  ChildNodes['Shape'].NodeValue := Value;
end;

function TXMLWellbore.Get_DTimKickoff: UnicodeString;
begin
  Result := ChildNodes['DTimKickoff'].Text;
end;

procedure TXMLWellbore.Set_DTimKickoff(Value: UnicodeString);
begin
  ChildNodes['DTimKickoff'].NodeValue := Value;
end;

function TXMLWellbore.Get_AchievedTD: Boolean;
begin
  Result := ChildNodes['AchievedTD'].NodeValue;
end;

procedure TXMLWellbore.Set_AchievedTD(Value: Boolean);
begin
  ChildNodes['AchievedTD'].NodeValue := Value;
end;

function TXMLWellbore.Get_Md: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['Md'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellbore.Get_Tvd: IXMLWellVerticalDepthCoord;
begin
  Result := ChildNodes['Tvd'] as IXMLWellVerticalDepthCoord;
end;

function TXMLWellbore.Get_MdBit: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MdBit'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellbore.Get_TvdBit: IXMLWellVerticalDepthCoord;
begin
  Result := ChildNodes['TvdBit'] as IXMLWellVerticalDepthCoord;
end;

function TXMLWellbore.Get_MdKickoff: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MdKickoff'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellbore.Get_TvdKickoff: IXMLWellVerticalDepthCoord;
begin
  Result := ChildNodes['TvdKickoff'] as IXMLWellVerticalDepthCoord;
end;

function TXMLWellbore.Get_MdPlanned: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MdPlanned'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellbore.Get_TvdPlanned: IXMLWellVerticalDepthCoord;
begin
  Result := ChildNodes['TvdPlanned'] as IXMLWellVerticalDepthCoord;
end;

function TXMLWellbore.Get_MdSubSeaPlanned: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MdSubSeaPlanned'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellbore.Get_TvdSubSeaPlanned: IXMLWellVerticalDepthCoord;
begin
  Result := ChildNodes['TvdSubSeaPlanned'] as IXMLWellVerticalDepthCoord;
end;

function TXMLWellbore.Get_DayTarget: IXMLTimeMeasure;
begin
  Result := ChildNodes['DayTarget'] as IXMLTimeMeasure;
end;

function TXMLWellbore.Get_Well: IXMLDataObjectReference;
begin
  Result := ChildNodes['Well'] as IXMLDataObjectReference;
end;

function TXMLWellbore.Get_ParentWellbore: IXMLDataObjectReference;
begin
  Result := ChildNodes['ParentWellbore'] as IXMLDataObjectReference;
end;

{ TXMLMeasuredDepthCoord }

function TXMLMeasuredDepthCoord.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLMeasuredDepthCoord.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLMeasuredDepthCoord.Get_Datum: UnicodeString;
begin
  Result := AttributeNodes['datum'].Text;
end;

procedure TXMLMeasuredDepthCoord.Set_Datum(Value: UnicodeString);
begin
  SetAttribute('datum', Value);
end;

{ TXMLWellVerticalDepthCoord }

function TXMLWellVerticalDepthCoord.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLWellVerticalDepthCoord.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLWellVerticalDepthCoord.Get_Datum: UnicodeString;
begin
  Result := AttributeNodes['datum'].Text;
end;

procedure TXMLWellVerticalDepthCoord.Set_Datum(Value: UnicodeString);
begin
  SetAttribute('datum', Value);
end;

{ TXMLTimeMeasure }

function TXMLTimeMeasure.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLTimeMeasure.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

{ TXMLDataObjectReference }

function TXMLDataObjectReference.Get_ContentType: UnicodeString;
begin
  Result := ChildNodes['ContentType'].Text;
end;

procedure TXMLDataObjectReference.Set_ContentType(Value: UnicodeString);
begin
  ChildNodes['ContentType'].NodeValue := Value;
end;

function TXMLDataObjectReference.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLDataObjectReference.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLDataObjectReference.Get_Uuid: UnicodeString;
begin
  Result := ChildNodes['Uuid'].Text;
end;

procedure TXMLDataObjectReference.Set_Uuid(Value: UnicodeString);
begin
  ChildNodes['Uuid'].NodeValue := Value;
end;

function TXMLDataObjectReference.Get_UuidAuthority: UnicodeString;
begin
  Result := ChildNodes['UuidAuthority'].Text;
end;

procedure TXMLDataObjectReference.Set_UuidAuthority(Value: UnicodeString);
begin
  ChildNodes['UuidAuthority'].NodeValue := Value;
end;

function TXMLDataObjectReference.Get_Uri: UnicodeString;
begin
  Result := ChildNodes['Uri'].Text;
end;

procedure TXMLDataObjectReference.Set_Uri(Value: UnicodeString);
begin
  ChildNodes['Uri'].NodeValue := Value;
end;

function TXMLDataObjectReference.Get_VersionString: UnicodeString;
begin
  Result := ChildNodes['VersionString'].Text;
end;

procedure TXMLDataObjectReference.Set_VersionString(Value: UnicodeString);
begin
  ChildNodes['VersionString'].NodeValue := Value;
end;

{ TXMLNameTag }

procedure TXMLNameTag.AfterConstruction;
begin
  RegisterChildNode('ExtensionNameValue', TXMLExtensionNameValue);
  FExtensionNameValue := CreateCollection(TXMLExtensionNameValueList, IXMLExtensionNameValue, 'ExtensionNameValue') as IXMLExtensionNameValueList;
  inherited;
end;

function TXMLNameTag.Get_Uid: UnicodeString;
begin
  Result := AttributeNodes['uid'].Text;
end;

procedure TXMLNameTag.Set_Uid(Value: UnicodeString);
begin
  SetAttribute('uid', Value);
end;

function TXMLNameTag.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLNameTag.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLNameTag.Get_NumberingScheme: UnicodeString;
begin
  Result := ChildNodes['NumberingScheme'].Text;
end;

procedure TXMLNameTag.Set_NumberingScheme(Value: UnicodeString);
begin
  ChildNodes['NumberingScheme'].NodeValue := Value;
end;

function TXMLNameTag.Get_Technology: UnicodeString;
begin
  Result := ChildNodes['Technology'].Text;
end;

procedure TXMLNameTag.Set_Technology(Value: UnicodeString);
begin
  ChildNodes['Technology'].NodeValue := Value;
end;

function TXMLNameTag.Get_Location: UnicodeString;
begin
  Result := ChildNodes['Location'].Text;
end;

procedure TXMLNameTag.Set_Location(Value: UnicodeString);
begin
  ChildNodes['Location'].NodeValue := Value;
end;

function TXMLNameTag.Get_InstallationDate: UnicodeString;
begin
  Result := ChildNodes['InstallationDate'].Text;
end;

procedure TXMLNameTag.Set_InstallationDate(Value: UnicodeString);
begin
  ChildNodes['InstallationDate'].NodeValue := Value;
end;

function TXMLNameTag.Get_InstallationCompany: UnicodeString;
begin
  Result := ChildNodes['InstallationCompany'].Text;
end;

procedure TXMLNameTag.Set_InstallationCompany(Value: UnicodeString);
begin
  ChildNodes['InstallationCompany'].NodeValue := Value;
end;

function TXMLNameTag.Get_MountingCode: UnicodeString;
begin
  Result := ChildNodes['MountingCode'].Text;
end;

procedure TXMLNameTag.Set_MountingCode(Value: UnicodeString);
begin
  ChildNodes['MountingCode'].NodeValue := Value;
end;

function TXMLNameTag.Get_Comment: UnicodeString;
begin
  Result := ChildNodes['Comment'].Text;
end;

procedure TXMLNameTag.Set_Comment(Value: UnicodeString);
begin
  ChildNodes['Comment'].NodeValue := Value;
end;

function TXMLNameTag.Get_ExtensionNameValue: IXMLExtensionNameValueList;
begin
  Result := FExtensionNameValue;
end;

{ TXMLCost }

function TXMLCost.Get_Currency: UnicodeString;
begin
  Result := AttributeNodes['currency'].Text;
end;

procedure TXMLCost.Set_Currency(Value: UnicodeString);
begin
  SetAttribute('currency', Value);
end;

{ TXMLDistanceNorthSouth }

function TXMLDistanceNorthSouth.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLDistanceNorthSouth.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLDistanceNorthSouth.Get_Reference: UnicodeString;
begin
  Result := AttributeNodes['reference'].Text;
end;

procedure TXMLDistanceNorthSouth.Set_Reference(Value: UnicodeString);
begin
  SetAttribute('reference', Value);
end;

{ TXMLDistanceEastWest }

function TXMLDistanceEastWest.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLDistanceEastWest.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLDistanceEastWest.Get_Reference: UnicodeString;
begin
  Result := AttributeNodes['reference'].Text;
end;

procedure TXMLDistanceEastWest.Set_Reference(Value: UnicodeString);
begin
  SetAttribute('reference', Value);
end;

{ TXMLReferencePoint }

procedure TXMLReferencePoint.AfterConstruction;
begin
  RegisterChildNode('MeasuredDepth', TXMLMeasuredDepthCoord);
  RegisterChildNode('ExtensionNameValue', TXMLExtensionNameValue);
  RegisterChildNode('Elevation', TXMLWellElevationCoord);
  RegisterChildNode('Location', TXMLAbstractWellLocation);
  FExtensionNameValue := CreateCollection(TXMLExtensionNameValueList, IXMLExtensionNameValue, 'ExtensionNameValue') as IXMLExtensionNameValueList;
  FLocation := CreateCollection(TXMLAbstractWellLocationList, IXMLAbstractWellLocation, 'Location') as IXMLAbstractWellLocationList;
  inherited;
end;

function TXMLReferencePoint.Get_Uid: UnicodeString;
begin
  Result := AttributeNodes['uid'].Text;
end;

procedure TXMLReferencePoint.Set_Uid(Value: UnicodeString);
begin
  SetAttribute('uid', Value);
end;

function TXMLReferencePoint.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLReferencePoint.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLReferencePoint.Get_Type_: UnicodeString;
begin
  Result := ChildNodes['Type'].Text;
end;

procedure TXMLReferencePoint.Set_Type_(Value: UnicodeString);
begin
  ChildNodes['Type'].NodeValue := Value;
end;

function TXMLReferencePoint.Get_MeasuredDepth: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MeasuredDepth'] as IXMLMeasuredDepthCoord;
end;

function TXMLReferencePoint.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLReferencePoint.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

function TXMLReferencePoint.Get_ExtensionNameValue: IXMLExtensionNameValueList;
begin
  Result := FExtensionNameValue;
end;

function TXMLReferencePoint.Get_Elevation: IXMLWellElevationCoord;
begin
  Result := ChildNodes['Elevation'] as IXMLWellElevationCoord;
end;

function TXMLReferencePoint.Get_Location: IXMLAbstractWellLocationList;
begin
  Result := FLocation;
end;

{ TXMLReferencePointList }

function TXMLReferencePointList.Add: IXMLReferencePoint;
begin
  Result := AddItem(-1) as IXMLReferencePoint;
end;

function TXMLReferencePointList.Insert(const Index: Integer): IXMLReferencePoint;
begin
  Result := AddItem(Index) as IXMLReferencePoint;
end;

function TXMLReferencePointList.Get_Item(Index: Integer): IXMLReferencePoint;
begin
  Result := List[Index] as IXMLReferencePoint;
end;

{ TXMLWellElevationCoord }

function TXMLWellElevationCoord.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLWellElevationCoord.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLWellElevationCoord.Get_Datum: UnicodeString;
begin
  Result := AttributeNodes['datum'].Text;
end;

procedure TXMLWellElevationCoord.Set_Datum(Value: UnicodeString);
begin
  SetAttribute('datum', Value);
end;

{ TXMLAbstractWellLocation }

procedure TXMLAbstractWellLocation.AfterConstruction;
begin
  RegisterChildNode('ExtensionNameValue', TXMLExtensionNameValue);
  FExtensionNameValue := CreateCollection(TXMLExtensionNameValueList, IXMLExtensionNameValue, 'ExtensionNameValue') as IXMLExtensionNameValueList;
  inherited;
end;

function TXMLAbstractWellLocation.Get_Uid: UnicodeString;
begin
  Result := AttributeNodes['uid'].Text;
end;

procedure TXMLAbstractWellLocation.Set_Uid(Value: UnicodeString);
begin
  SetAttribute('uid', Value);
end;

function TXMLAbstractWellLocation.Get_Original: Boolean;
begin
  Result := ChildNodes['Original'].NodeValue;
end;

procedure TXMLAbstractWellLocation.Set_Original(Value: Boolean);
begin
  ChildNodes['Original'].NodeValue := Value;
end;

function TXMLAbstractWellLocation.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLAbstractWellLocation.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

function TXMLAbstractWellLocation.Get_ExtensionNameValue: IXMLExtensionNameValueList;
begin
  Result := FExtensionNameValue;
end;

{ TXMLAbstractWellLocationList }

function TXMLAbstractWellLocationList.Add: IXMLAbstractWellLocation;
begin
  Result := AddItem(-1) as IXMLAbstractWellLocation;
end;

function TXMLAbstractWellLocationList.Insert(const Index: Integer): IXMLAbstractWellLocation;
begin
  Result := AddItem(Index) as IXMLAbstractWellLocation;
end;

function TXMLAbstractWellLocationList.Get_Item(Index: Integer): IXMLAbstractWellLocation;
begin
  Result := List[Index] as IXMLAbstractWellLocation;
end;

{ TXMLGeodeticWellLocation }

procedure TXMLGeodeticWellLocation.AfterConstruction;
begin
  RegisterChildNode('Latitude', TXMLPlaneAngleMeasure);
  RegisterChildNode('Longitude', TXMLPlaneAngleMeasure);
  RegisterChildNode('Crs', TXMLAbstractGeodeticCrs);
  inherited;
end;

function TXMLGeodeticWellLocation.Get_Latitude: IXMLPlaneAngleMeasure;
begin
  Result := ChildNodes['Latitude'] as IXMLPlaneAngleMeasure;
end;

function TXMLGeodeticWellLocation.Get_Longitude: IXMLPlaneAngleMeasure;
begin
  Result := ChildNodes['Longitude'] as IXMLPlaneAngleMeasure;
end;

function TXMLGeodeticWellLocation.Get_Crs: IXMLAbstractGeodeticCrs;
begin
  Result := ChildNodes['Crs'] as IXMLAbstractGeodeticCrs;
end;

{ TXMLPlaneAngleMeasure }

function TXMLPlaneAngleMeasure.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLPlaneAngleMeasure.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

{ TXMLAbstractGeodeticCrs }

{ TXMLProjectedWellLocation }

procedure TXMLProjectedWellLocation.AfterConstruction;
begin
  RegisterChildNode('Crs', TXMLAbstractProjectedCrs);
  inherited;
end;

function TXMLProjectedWellLocation.Get_Coordinate1: Double;
begin
  Result := XmlStrToFloatExt(ChildNodes['Coordinate1'].Text);
end;

procedure TXMLProjectedWellLocation.Set_Coordinate1(Value: Double);
begin
  ChildNodes['Coordinate1'].NodeValue := Value;
end;

function TXMLProjectedWellLocation.Get_Coordinate2: Double;
begin
  Result := XmlStrToFloatExt(ChildNodes['Coordinate2'].Text);
end;

procedure TXMLProjectedWellLocation.Set_Coordinate2(Value: Double);
begin
  ChildNodes['Coordinate2'].NodeValue := Value;
end;

function TXMLProjectedWellLocation.Get_Crs: IXMLAbstractProjectedCrs;
begin
  Result := ChildNodes['Crs'] as IXMLAbstractProjectedCrs;
end;

{ TXMLAbstractProjectedCrs }

{ TXMLWell }

procedure TXMLWell.AfterConstruction;
begin
  RegisterChildNode('PcInterest', TXMLDimensionlessMeasure);
  RegisterChildNode('WaterDepth', TXMLLengthMeasure);
  RegisterChildNode('GeographicLocationWGS84', TXMLGeodeticWellLocation);
  RegisterChildNode('WellLocation', TXMLAbstractWellLocation);
  RegisterChildNode('WellPublicLandSurveySystemLocation', TXMLPublicLandSurveySystem);
  RegisterChildNode('ReferencePoint', TXMLReferencePoint);
  RegisterChildNode('WellheadElevation', TXMLWellElevationCoord);
  RegisterChildNode('WellDatum', TXMLWellDatum);
  RegisterChildNode('GroundElevation', TXMLWellElevationCoord);
  FWellLocation := CreateCollection(TXMLAbstractWellLocationList, IXMLAbstractWellLocation, 'WellLocation') as IXMLAbstractWellLocationList;
  FReferencePoint := CreateCollection(TXMLReferencePointList, IXMLReferencePoint, 'ReferencePoint') as IXMLReferencePointList;
  FWellDatum := CreateCollection(TXMLWellDatumList, IXMLWellDatum, 'WellDatum') as IXMLWellDatumList;
  inherited;
end;

function TXMLWell.Get_NameLegal: UnicodeString;
begin
  Result := ChildNodes['NameLegal'].Text;
end;

procedure TXMLWell.Set_NameLegal(Value: UnicodeString);
begin
  ChildNodes['NameLegal'].NodeValue := Value;
end;

function TXMLWell.Get_NumLicense: UnicodeString;
begin
  Result := ChildNodes['NumLicense'].Text;
end;

procedure TXMLWell.Set_NumLicense(Value: UnicodeString);
begin
  ChildNodes['NumLicense'].NodeValue := Value;
end;

function TXMLWell.Get_NumGovt: UnicodeString;
begin
  Result := ChildNodes['NumGovt'].Text;
end;

procedure TXMLWell.Set_NumGovt(Value: UnicodeString);
begin
  ChildNodes['NumGovt'].NodeValue := Value;
end;

function TXMLWell.Get_DTimLicense: UnicodeString;
begin
  Result := ChildNodes['DTimLicense'].Text;
end;

procedure TXMLWell.Set_DTimLicense(Value: UnicodeString);
begin
  ChildNodes['DTimLicense'].NodeValue := Value;
end;

function TXMLWell.Get_Field: UnicodeString;
begin
  Result := ChildNodes['Field'].Text;
end;

procedure TXMLWell.Set_Field(Value: UnicodeString);
begin
  ChildNodes['Field'].NodeValue := Value;
end;

function TXMLWell.Get_Country: UnicodeString;
begin
  Result := ChildNodes['Country'].Text;
end;

procedure TXMLWell.Set_Country(Value: UnicodeString);
begin
  ChildNodes['Country'].NodeValue := Value;
end;

function TXMLWell.Get_State: UnicodeString;
begin
  Result := ChildNodes['State'].Text;
end;

procedure TXMLWell.Set_State(Value: UnicodeString);
begin
  ChildNodes['State'].NodeValue := Value;
end;

function TXMLWell.Get_County: UnicodeString;
begin
  Result := ChildNodes['County'].Text;
end;

procedure TXMLWell.Set_County(Value: UnicodeString);
begin
  ChildNodes['County'].NodeValue := Value;
end;

function TXMLWell.Get_Region: UnicodeString;
begin
  Result := ChildNodes['Region'].Text;
end;

procedure TXMLWell.Set_Region(Value: UnicodeString);
begin
  ChildNodes['Region'].NodeValue := Value;
end;

function TXMLWell.Get_District: UnicodeString;
begin
  Result := ChildNodes['District'].Text;
end;

procedure TXMLWell.Set_District(Value: UnicodeString);
begin
  ChildNodes['District'].NodeValue := Value;
end;

function TXMLWell.Get_Block: UnicodeString;
begin
  Result := ChildNodes['Block'].Text;
end;

procedure TXMLWell.Set_Block(Value: UnicodeString);
begin
  ChildNodes['Block'].NodeValue := Value;
end;

function TXMLWell.Get_TimeZone: UnicodeString;
begin
  Result := ChildNodes['TimeZone'].Text;
end;

procedure TXMLWell.Set_TimeZone(Value: UnicodeString);
begin
  ChildNodes['TimeZone'].NodeValue := Value;
end;

function TXMLWell.Get_Operator_: UnicodeString;
begin
  Result := ChildNodes['Operator'].Text;
end;

procedure TXMLWell.Set_Operator_(Value: UnicodeString);
begin
  ChildNodes['Operator'].NodeValue := Value;
end;

function TXMLWell.Get_OperatorDiv: UnicodeString;
begin
  Result := ChildNodes['OperatorDiv'].Text;
end;

procedure TXMLWell.Set_OperatorDiv(Value: UnicodeString);
begin
  ChildNodes['OperatorDiv'].NodeValue := Value;
end;

function TXMLWell.Get_OriginalOperator: UnicodeString;
begin
  Result := ChildNodes['OriginalOperator'].Text;
end;

procedure TXMLWell.Set_OriginalOperator(Value: UnicodeString);
begin
  ChildNodes['OriginalOperator'].NodeValue := Value;
end;

function TXMLWell.Get_PcInterest: IXMLDimensionlessMeasure;
begin
  Result := ChildNodes['PcInterest'] as IXMLDimensionlessMeasure;
end;

function TXMLWell.Get_NumAPI: UnicodeString;
begin
  Result := ChildNodes['NumAPI'].Text;
end;

procedure TXMLWell.Set_NumAPI(Value: UnicodeString);
begin
  ChildNodes['NumAPI'].NodeValue := Value;
end;

function TXMLWell.Get_StatusWell: UnicodeString;
begin
  Result := ChildNodes['StatusWell'].Text;
end;

procedure TXMLWell.Set_StatusWell(Value: UnicodeString);
begin
  ChildNodes['StatusWell'].NodeValue := Value;
end;

function TXMLWell.Get_PurposeWell: UnicodeString;
begin
  Result := ChildNodes['PurposeWell'].Text;
end;

procedure TXMLWell.Set_PurposeWell(Value: UnicodeString);
begin
  ChildNodes['PurposeWell'].NodeValue := Value;
end;

function TXMLWell.Get_FluidWell: UnicodeString;
begin
  Result := ChildNodes['FluidWell'].Text;
end;

procedure TXMLWell.Set_FluidWell(Value: UnicodeString);
begin
  ChildNodes['FluidWell'].NodeValue := Value;
end;

function TXMLWell.Get_DirectionWell: UnicodeString;
begin
  Result := ChildNodes['DirectionWell'].Text;
end;

procedure TXMLWell.Set_DirectionWell(Value: UnicodeString);
begin
  ChildNodes['DirectionWell'].NodeValue := Value;
end;

function TXMLWell.Get_DTimSpud: UnicodeString;
begin
  Result := ChildNodes['DTimSpud'].Text;
end;

procedure TXMLWell.Set_DTimSpud(Value: UnicodeString);
begin
  ChildNodes['DTimSpud'].NodeValue := Value;
end;

function TXMLWell.Get_DTimPa: UnicodeString;
begin
  Result := ChildNodes['DTimPa'].Text;
end;

procedure TXMLWell.Set_DTimPa(Value: UnicodeString);
begin
  ChildNodes['DTimPa'].NodeValue := Value;
end;

function TXMLWell.Get_WaterDepth: IXMLLengthMeasure;
begin
  Result := ChildNodes['WaterDepth'] as IXMLLengthMeasure;
end;

function TXMLWell.Get_GeographicLocationWGS84: IXMLGeodeticWellLocation;
begin
  Result := ChildNodes['GeographicLocationWGS84'] as IXMLGeodeticWellLocation;
end;

function TXMLWell.Get_WellLocation: IXMLAbstractWellLocationList;
begin
  Result := FWellLocation;
end;

function TXMLWell.Get_WellPublicLandSurveySystemLocation: IXMLPublicLandSurveySystem;
begin
  Result := ChildNodes['WellPublicLandSurveySystemLocation'] as IXMLPublicLandSurveySystem;
end;

function TXMLWell.Get_ReferencePoint: IXMLReferencePointList;
begin
  Result := FReferencePoint;
end;

function TXMLWell.Get_WellheadElevation: IXMLWellElevationCoord;
begin
  Result := ChildNodes['WellheadElevation'] as IXMLWellElevationCoord;
end;

function TXMLWell.Get_WellDatum: IXMLWellDatumList;
begin
  Result := FWellDatum;
end;

function TXMLWell.Get_GroundElevation: IXMLWellElevationCoord;
begin
  Result := ChildNodes['GroundElevation'] as IXMLWellElevationCoord;
end;

{ TXMLDimensionlessMeasure }

function TXMLDimensionlessMeasure.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLDimensionlessMeasure.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

{ TXMLLengthMeasure }

function TXMLLengthMeasure.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLLengthMeasure.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

{ TXMLPublicLandSurveySystem }

procedure TXMLPublicLandSurveySystem.AfterConstruction;
begin
  RegisterChildNode('FootageNS', TXMLDistanceNorthSouth);
  RegisterChildNode('FootageEW', TXMLDistanceEastWest);
  inherited;
end;

function TXMLPublicLandSurveySystem.Get_PrincipalMeridian: UnicodeString;
begin
  Result := ChildNodes['PrincipalMeridian'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_PrincipalMeridian(Value: UnicodeString);
begin
  ChildNodes['PrincipalMeridian'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_Range: Integer;
begin
  Result := ChildNodes['Range'].NodeValue;
end;

procedure TXMLPublicLandSurveySystem.Set_Range(Value: Integer);
begin
  ChildNodes['Range'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_RangeDir: UnicodeString;
begin
  Result := ChildNodes['RangeDir'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_RangeDir(Value: UnicodeString);
begin
  ChildNodes['RangeDir'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_Township: Integer;
begin
  Result := ChildNodes['Township'].NodeValue;
end;

procedure TXMLPublicLandSurveySystem.Set_Township(Value: Integer);
begin
  ChildNodes['Township'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_TownshipDir: UnicodeString;
begin
  Result := ChildNodes['TownshipDir'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_TownshipDir(Value: UnicodeString);
begin
  ChildNodes['TownshipDir'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_Section: UnicodeString;
begin
  Result := ChildNodes['Section'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_Section(Value: UnicodeString);
begin
  ChildNodes['Section'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_QuarterSection: UnicodeString;
begin
  Result := ChildNodes['QuarterSection'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_QuarterSection(Value: UnicodeString);
begin
  ChildNodes['QuarterSection'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_QuarterTownship: UnicodeString;
begin
  Result := ChildNodes['QuarterTownship'].Text;
end;

procedure TXMLPublicLandSurveySystem.Set_QuarterTownship(Value: UnicodeString);
begin
  ChildNodes['QuarterTownship'].NodeValue := Value;
end;

function TXMLPublicLandSurveySystem.Get_FootageNS: IXMLDistanceNorthSouth;
begin
  Result := ChildNodes['FootageNS'] as IXMLDistanceNorthSouth;
end;

function TXMLPublicLandSurveySystem.Get_FootageEW: IXMLDistanceEastWest;
begin
  Result := ChildNodes['FootageEW'] as IXMLDistanceEastWest;
end;

{ TXMLWellDatum }

procedure TXMLWellDatum.AfterConstruction;
begin
  RegisterChildNode('MeasuredDepth', TXMLMeasuredDepthCoord);
  RegisterChildNode('ExtensionNameValue', TXMLExtensionNameValue);
  RegisterChildNode('Wellbore', TXMLRefWellbore);
  RegisterChildNode('Rig', TXMLRefWellboreRig);
  RegisterChildNode('Elevation', TXMLWellElevationCoord);
  RegisterChildNode('HorizontalLocation', TXMLAbstractWellLocation);
  RegisterChildNode('Crs', TXMLAbstractVerticalCrs);
  FKind := CreateCollection(TXMLString64List, IXMLNode, 'Kind') as IXMLString64List;
  FExtensionNameValue := CreateCollection(TXMLExtensionNameValueList, IXMLExtensionNameValue, 'ExtensionNameValue') as IXMLExtensionNameValueList;
  inherited;
end;

function TXMLWellDatum.Get_Uid: UnicodeString;
begin
  Result := AttributeNodes['uid'].Text;
end;

procedure TXMLWellDatum.Set_Uid(Value: UnicodeString);
begin
  SetAttribute('uid', Value);
end;

function TXMLWellDatum.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLWellDatum.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLWellDatum.Get_Code: UnicodeString;
begin
  Result := ChildNodes['Code'].Text;
end;

procedure TXMLWellDatum.Set_Code(Value: UnicodeString);
begin
  ChildNodes['Code'].NodeValue := Value;
end;

function TXMLWellDatum.Get_Kind: IXMLString64List;
begin
  Result := FKind;
end;

function TXMLWellDatum.Get_MeasuredDepth: IXMLMeasuredDepthCoord;
begin
  Result := ChildNodes['MeasuredDepth'] as IXMLMeasuredDepthCoord;
end;

function TXMLWellDatum.Get_Comment: UnicodeString;
begin
  Result := ChildNodes['Comment'].Text;
end;

procedure TXMLWellDatum.Set_Comment(Value: UnicodeString);
begin
  ChildNodes['Comment'].NodeValue := Value;
end;

function TXMLWellDatum.Get_ExtensionNameValue: IXMLExtensionNameValueList;
begin
  Result := FExtensionNameValue;
end;

function TXMLWellDatum.Get_Wellbore: IXMLRefWellbore;
begin
  Result := ChildNodes['Wellbore'] as IXMLRefWellbore;
end;

function TXMLWellDatum.Get_Rig: IXMLRefWellboreRig;
begin
  Result := ChildNodes['Rig'] as IXMLRefWellboreRig;
end;

function TXMLWellDatum.Get_Elevation: IXMLWellElevationCoord;
begin
  Result := ChildNodes['Elevation'] as IXMLWellElevationCoord;
end;

function TXMLWellDatum.Get_HorizontalLocation: IXMLAbstractWellLocation;
begin
  Result := ChildNodes['HorizontalLocation'] as IXMLAbstractWellLocation;
end;

function TXMLWellDatum.Get_Crs: IXMLAbstractVerticalCrs;
begin
  Result := ChildNodes['Crs'] as IXMLAbstractVerticalCrs;
end;

{ TXMLWellDatumList }

function TXMLWellDatumList.Add: IXMLWellDatum;
begin
  Result := AddItem(-1) as IXMLWellDatum;
end;

function TXMLWellDatumList.Insert(const Index: Integer): IXMLWellDatum;
begin
  Result := AddItem(Index) as IXMLWellDatum;
end;

function TXMLWellDatumList.Get_Item(Index: Integer): IXMLWellDatum;
begin
  Result := List[Index] as IXMLWellDatum;
end;

{ TXMLRefWellbore }

function TXMLRefWellbore.Get_WellboreReference: UnicodeString;
begin
  Result := ChildNodes['WellboreReference'].Text;
end;

procedure TXMLRefWellbore.Set_WellboreReference(Value: UnicodeString);
begin
  ChildNodes['WellboreReference'].NodeValue := Value;
end;

function TXMLRefWellbore.Get_WellParent: UnicodeString;
begin
  Result := ChildNodes['WellParent'].Text;
end;

procedure TXMLRefWellbore.Set_WellParent(Value: UnicodeString);
begin
  ChildNodes['WellParent'].NodeValue := Value;
end;

{ TXMLRefWellboreRig }

function TXMLRefWellboreRig.Get_RigReference: UnicodeString;
begin
  Result := ChildNodes['RigReference'].Text;
end;

procedure TXMLRefWellboreRig.Set_RigReference(Value: UnicodeString);
begin
  ChildNodes['RigReference'].NodeValue := Value;
end;

function TXMLRefWellboreRig.Get_WellboreParent: UnicodeString;
begin
  Result := ChildNodes['WellboreParent'].Text;
end;

procedure TXMLRefWellboreRig.Set_WellboreParent(Value: UnicodeString);
begin
  ChildNodes['WellboreParent'].NodeValue := Value;
end;

function TXMLRefWellboreRig.Get_WellParent: UnicodeString;
begin
  Result := ChildNodes['WellParent'].Text;
end;

procedure TXMLRefWellboreRig.Set_WellParent(Value: UnicodeString);
begin
  ChildNodes['WellParent'].NodeValue := Value;
end;

{ TXMLAbstractVerticalCrs }

{ TXMLString64List }

function TXMLString64List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString64List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString64List.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.