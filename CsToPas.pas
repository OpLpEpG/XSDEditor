unit CsToPas;

interface

uses SysUtils;

type
    TXmlSchemaDerivationMethod = Integer;
    ///
    /// ������:
    ///     ������������� ��������� ������ ��� �������������� �������� ����������� �����.
    XmlSchemaDerivationMethod = set of
    (
       ///
       /// ������:
       ///     �������������� ����� �������� ����������� �� ��������� ��� ���������� ������
       ///     ������.
        dmEmpty = 0,
        ///
        /// ������:
        ///     ��������� �� ������ ����������� Substitution.
        dmSubstitution = 1,
        ///
        /// ������:
        ///     ��������� �� ������ ����������� Extension.
        dmExtension = 2,
        ///
        /// ������:
        ///     ��������� �� ������ ����������� Restriction.
        dmRestriction = 4,
        ///
        /// ������:
        ///     ��������� �� ������ ����������� List.
        dmList = 8,
        ///
        /// ������:
        ///     ��������� �� ������ ����������� Union.
        dmUnion = 16,
        ///
        /// ������:
        ///     #all. ��������� �� ��� ������ ������.
        dmAll = 255
        ///
        /// ������:
        ///     ��������� ����� �������� ����������� �� ���������.
     //   dmNone = 256
    );
    TXmlTokenizedType = Integer;
    ///
    /// ������:
    ///     ������������ ��� XML ��� ������. ��� ��������� ������ ��� ��� XML, �������� ���
    ///     ������� CDATA ������.
    XmlTokenizedType =
    (
        ///
        /// ������:
        ///     ��� CDATA.
        ttCDATA = 0,
        ///
        /// ������:
        ///     ��� ��������������.
        ttID = 1,
        ///
        /// ������:
        ///     ��� IDREF.
        ttIDREF = 2,
        ///
        /// ������:
        ///     ��� IDREFS.
        ttIDREFS = 3,
        ///
        /// ������:
        ///     ��� ��������.
        ttENTITY = 4,
        ///
        /// ������:
        ///     ��� ��������.
        ttENTITIES = 5,
        ///
        /// ������:
        ///     ��� NMTOKEN.
        ttNMTOKEN = 6,
        ///
        /// ������:
        ///     ��� NMTOKENS.
        ttNMTOKENS = 7,
        ///
        /// ������:
        ///     ��� NOTATION.
        ttNOTATION = 8,
        ///
        /// ������:
        ///     ��� ������������.
        ttENUMERATION = 9,
        ///
        /// ������:
        ///     ��� QName.
        ttQName = 10,
        ///
        /// ������:
        ///     ��� ����� NCName.
        ttNCName = 11,
        ///
        /// ������:
        ///     �� �������� �����.
        ttNone = 12
    );
    TXmlSchemaDatatypeVariety = Integer;
    ///
    /// ������:
    ///     ��������� ��� ������������� ���� ������ ����� W3C XML.
    XmlSchemaDatatypeVariety =
    (
        ///
        /// ������:
        ///     Atomic ��� ����� W3C XML.
        dvAtomic = 0,
        ///
        /// ������:
        ///     ��� ������ ����� W3C XML.
        dvList = 1,
        ///
        /// ������:
        ///     ����������� ��� ����� W3C XML.
        dvUnion = 2
    );
    TXmlTypeCode = Integer;
    ///
    /// ������:
    ///     ������������ ���� ����� W3C ����� ����� ����������� XML (XSD).
    XmlTypeCode =
    (
        ///
        /// ������:
        ///     ��� ���������� � ����.
        tcNone = 0,
        ///
        /// ������:
        ///     ��������, ���� ��� ��������� �������� ��������.
        tcItem = 1,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcNode = 2,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcDocument = 3,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcElement = 4,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcAttribute = 5,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcNamespace = 6,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcProcessingInstruction = 7,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcComment = 8,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcText = 9,
        ///
        /// ������:
        ///     ����� ��������� �������� �����������.
        tcAnyAtomicType = 10,
        ///
        /// ������:
        ///     ���������������� ������� ��������.
        tcUntypedAtomic = 11,
        ///
        /// ������:
        ///     ����� W3C XML xs:string ����.
        tctcString = 12,
        ///
        /// ������:
        ///     ����� W3C XML xs:boolean ����.
        tcBoolean = 13,
        ///
        /// ������:
        ///     ����� W3C XML xs:decimal ����.
        tcDecimal = 14,
        ///
        /// ������:
        ///     ����� W3C XML xs:float ����.
        tcFloat = 15,
        ///
        /// ������:
        ///     ����� W3C XML xs:double ����.
        tcDouble = 16,
        ///
        /// ������:
        ///     ����� W3C XML xs:Duration ����.
        tcDuration = 17,
        ///
        /// ������:
        ///     ����� W3C XML xs:dateTime ����.
        tcDateTime = 18,
        ///
        /// ������:
        ///     ����� W3C XML xs:time ����.
        tcTime = 19,
        ///
        /// ������:
        ///     ����� W3C XML xs:date ����.
        tcDate = 20,
        ///
        /// ������:
        ///     ����� W3C XML xs:gYearMonth ����.
        tcGYearMonth = 21,
        ///
        /// ������:
        ///     ����� W3C XML xs:gYear ����.
        tcGYear = 22,
        ///
        /// ������:
        ///     ����� W3C XML xs:gMonthDay ����.
        tcGMonthDay = 23,
        ///
        /// ������:
        ///     ����� W3C XML xs:gDay ����.
        tcGDay = 24,
        ///
        /// ������:
        ///     ����� W3C XML xs:gMonth ����.
        tcGMonth = 25,
        ///
        /// ������:
        ///     ����� W3C XML xs:hexBinary ����.
        tcHexBinary = 26,
        ///
        /// ������:
        ///     ����� W3C XML xs:base64Binary ����.
        tcBase64Binary = 27,
        ///
        /// ������:
        ///     ����� W3C XML xs:anyURI ����.
        tcAnyUri = 28,
        ///
        /// ������:
        ///     ����� W3C XML xs:QName ����.
        tcQName = 29,
        ///
        /// ������:
        ///     ����� W3C XML xs:NOTATION ����.
        tcNotation = 30,
        ///
        /// ������:
        ///     ����� W3C XML xs:normalizedString ����.
        tcNormalizedString = 31,
        ///
        /// ������:
        ///     ����� W3C XML xs:token ����.
        tcToken = 32,
        ///
        /// ������:
        ///     ����� W3C XML xs:language ����.
        tcLanguage = 33,
        ///
        /// ������:
        ///     ����� W3C XML xs:NMTOKEN ����.
        tctcNmToken = 34,
        ///
        /// ������:
        ///     ����� W3C XML xs:Name ����.
        tcName = 35,
        ///
        /// ������:
        ///     ����� W3C XML xs:NCName ����.
        tcNCName = 36,
        ///
        /// ������:
        ///     ����� W3C XML xs:ID ����.
        tcId = 37,
        ///
        /// ������:
        ///     ����� W3C XML xs:IDREF ����.
        tcIdref = 38,
        ///
        /// ������:
        ///     ����� W3C XML xs:ENTITY ����.
        tcEntity = 39,
        ///
        /// ������:
        ///     ����� W3C XML xs:integer ����.
        tcInteger = 40,
        ///
        /// ������:
        ///     ����� W3C XML xs:nonPositiveInteger ����.
        NonPositiveInteger = 41,
        ///
        /// ������:
        ///     ����� W3C XML xs:negativeInteger ����.
        tcNegativeInteger = 42,
        ///
        /// ������:
        ///     ����� W3C XML xs:long ����.
        tcLong = 43,
        ///
        /// ������:
        ///     ����� W3C XML xs:int ����.
        tcInt = 44,
        ///
        /// ������:
        ///     ����� W3C XML xs:short ����.
        tcShort = 45,
        ///
        /// ������:
        ///     ����� W3C XML xs:byte ����.
        tcByte = 46,
        ///
        /// ������:
        ///     ����� W3C XML xs:nonNegativeInteger ����.
        tcNonNegativeInteger = 47,
        ///
        /// ������:
        ///     ����� W3C XML xs:unsignedLong ����.
        tcUnsignedLong = 48,
        ///
        /// ������:
        ///     ����� W3C XML xs:unsignedInt ����.
        tcUnsignedInt = 49,
        ///
        /// ������:
        ///     ����� W3C XML xs:unsignedShort ����.
        tcUnsignedShort = 50,
        ///
        /// ������:
        ///     ����� W3C XML xs:unsignedByte ����.
        tcUnsignedByte = 51,
        ///
        /// ������:
        ///     ����� W3C XML xs:positiveInteger ����.
        tcPositiveInteger = 52,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcYearMonthDuration = 53,
        ///
        /// ������:
        ///     ��� �������� ������������ �������������� .NET Framework � �� ������������ ���
        ///     ����������������� ������������� � ����.
        tcDayTimeDuration = 54
    );

    TXmlSchemaForm = Integer;
    ///
    /// ������:
    ///     ���������, ������ �� �������� ��� �������� �������� ������� ������������ ����.
    XmlSchemaForm =
    (
        ///
        /// ������:
        ///     ����� �������� � �������� �� ������ � �����.
        sfNone = 0,
        ///
        /// ������:
        ///     �������� � �������� ������ ���� ��������� ��������� ������������ ����.
        sfQualified = 1,
        ///
        /// ������:
        ///     �������� � �������� �� ��������� � ������������ � ��������� ������������ ����.
        sfUnqualified = 2
    );

    TXmlSchemaContentType = Integer;
    ///
    /// ������:
    ///     ������������ ��� ������ ����������� �������� ����. ������������ ���������� �
    ///     ������ �������� ����� �������� ����� (infoset).
    XmlSchemaContentType =
    (
        ///
        /// ������:
        ///     ������ ��������� ����������.
        scTextOnly = 0,
        ///
        /// ������:
        ///     ������ ����������.
        scEmpty = 1,
        ///
        /// ������:
        ///     ������ ���������� ��������.
        scElementOnly = 2,
        ///
        /// ������:
        ///     ��������� ����������.
        scMixed = 3
    );

    TXmlSchemaUse = Integer;
    ///
    /// ������:
    ///     ���������, ��� ������������ �������.
    XmlSchemaUse =
    (
        ///
        /// ������:
        ///     ������������� �������� �� �������.
        suNone = 0,
        ///
        /// ������:
        ///     ������� �������� ��������������.
        suOptional = 1,
        ///
        /// ������:
        ///     ������� ������ ������������.
        suProhibited = 2,
        ///
        /// ������:
        ///     ������� ������ ������������ ���� ���.
        suRequired = 3
    );

 TCSharp = Pointer;
 PCsArray = ^TCsArray;
 TCsArray = array[0..5000] of TCSharp;

 IXmlSchemaObject = interface // abstract
 ['{AF1853D2-C560-4E24-A15B-5518F030F4FC}']
   function XmlObject() : TCSharp; safecall;
   function LineNumber(): Integer; safecall;
   function LinePosition(): Integer; safecall;
        ///
        /// ������:
        ///     ���������� ��� ������ �������� ������������ ��� �����, ������������ ������ �����.
        ///
        /// �������:
        ///     �������� ������������ (URI) ��� �����.
   function SourceUri(): PChar; safecall;
        ///
        /// ������:
        ///     ���������� ��� ������ ������������ ������� ������� System.Xml.Schema.XmlSchemaObject.
        ///
        /// �������:
        ///     ������������ System.Xml.Schema.XmlSchemaObject ������� System.Xml.Schema.XmlSchemaObject.
   function Parent(): IXmlSchemaObject; safecall;
        ///
        /// ������:
        ///     ���������� ��� ������ System.Xml.Serialization.XmlSerializerNamespaces ��� �������������
        ///     � ���� �������� �����.
        ///
        /// �������:
        ///     System.Xml.Serialization.XmlSerializerNamespaces �������� ��� ������� �����.
        ///
        ///XmlSerializerNamespaces Namespaces { get; set; }
   procedure GetNamespaces(out Namespaces: PCsArray; out Count: Integer); safecall;
 end;

 IXmlSchemaAnnotated = interface // abstract IXmlSchemaObject
 ['{41A3E555-6A86-4F71-A211-3674292D0B4F}']
   function GetAnnotation(): PChar; safecall;
 end;

 IXmlQualifiedName = interface
 ['{4B538C5E-DC77-437C-893B-97488A82E509}']
   function IsEmpty(): Boolean; safecall;
   function Name(): PChar; safecall;
   function Namespace(): PChar; safecall;
   function ToString(): PChar; safecall;
   function XmlObject() : TCSharp; safecall;
 end;

 IXMLEnumeraror = interface
 ['{BA1CE72D-2BA7-4F27-9C8A-CCBB43D20102}']
   function GetCurrent(): TCSharp; safecall;
   function MoveNext(): Boolean;safecall;
   procedure Reset(); safecall;
   property Current: TCSharp read GetCurrent;
 end;

 IXMLEnumerable = interface
 ['{33E5C30E-F668-4F17-B697-9ACF882ECA94}']
   function GetEnumerator: IXMLEnumeraror; safecall;
 end;

 TGetXml<T: IInterface> = procedure (obj: TCSharp; out intf: T); stdcall;
 TXEnum<T: IInterface> = class(TInterfacedObject)
  private
    FEnum: IXMLEnumeraror;
    FFunc: TGetXml<T>;
    function DoGetCurrent: T;
  public
    property Current: T read DoGetCurrent;
    function MoveNext: Boolean;
    function GetEnumerator: TXEnum<T>;
    constructor Create(Enum: IXMLEnumerable; func: TGetXml<T>);
  end;

  IXmlSchemaObjectTable = interface
  ['{8CE6A050-4442-4EDD-986A-F3F5897040DE}']
    function GetItem(QName: TCSharp): TCSharp; safecall;
    function Count(): Integer; safecall;
    function Names(): IXMLEnumerable; safecall;
    function Values(): IXMLEnumerable; safecall;
    function Contains(name: TCSharp): Boolean; safecall;
  end;

  IXmlSchemaObjectCollection = interface
  ['{29854D89-BD09-4627-B8E7-C648DA4131A9}']
    function Count(): Integer; safecall;
    function GetItem(index: Integer): TCSharp; safecall;
  end;

  IXmlSchema = interface //IXmlSchemaObject
  ['{28C0864D-D3E0-4C44-8912-05161629BCA2}']
    function TargetNamespace():PChar;  safecall;
    ///
    /// ������:
    ///     Gets the post-schema-compilation value of all schema types in the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectCollection of all schema types in the schema.
    function SchemaTypes(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets the post-schema-compilation value for all notations in the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all notations in the
    ///     schema.
    function Notations(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets the collection of schema elements in the schema and is used to add new element
    ///     types at the schema element level.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectCollection of schema elements in the schema.
    ///[XmlElement("annotation", typeof(XmlSchemaAnnotation))]
    ///[XmlElement("attribute", typeof(XmlSchemaAttribute))]
    ///[XmlElement("attributeGroup", typeof(XmlSchemaAttributeGroup))]
    ///[XmlElement("complexType", typeof(XmlSchemaComplexType))]
    ///[XmlElement("element", typeof(XmlSchemaElement))]
    ///[XmlElement("group", typeof(XmlSchemaGroup))]
    ///[XmlElement("notation", typeof(XmlSchemaNotation))]
    ///[XmlElement("simpleType", typeof(XmlSchemaSimpleType))]
    function Items(): IXmlSchemaObjectCollection; safecall;
    function IsCompiled():Boolean; safecall;
    ///
    /// ������:
    ///     Gets the collection of included and imported schemas.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectCollection of the included and imported schemas.
    function Includes(): IXmlSchemaObjectCollection; safecall;
    function Id(): PChar; safecall;
    ///
    /// ������:
    ///     Gets the post-schema-compilation value of all the groups in the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the groups in the
    ///     schema.
    function Groups(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets or sets the finalDefault attribute which sets the default value of the final
    ///     attribute on elements and complex types in the target namespace of the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaDerivationMethod value representing the different
    ///     methods for preventing derivation. The default value is XmlSchemaDerivationMethod.None.
    ///[DefaultValue(XmlSchemaDerivationMethod.None)]
    ///[XmlAttribute("finalDefault")]
    function FinalDefault(): TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
    ///
    /// ������:
    ///     Gets the post-schema-compilation value for all the elements in the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the elements in the
    ///     schema.
    function Elements(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets or sets the form for elements declared in the target namespace of the schema.
    ///
    /// �������:
    ///     The System.Xml.Schema.XmlSchemaForm value that indicates if elements from the
    ///     target namespace are required to be qualified with the namespace prefix. The
    ///     default is System.Xml.Schema.XmlSchemaForm.None.
    ///[DefaultValue(XmlSchemaForm.None)]
    ///[XmlAttribute("elementFormDefault")]
    function ElementFormDefault(): TXmlSchemaForm; safecall; //XmlSchemaForm
    ///
    /// ������:
    ///     Gets or sets the blockDefault attribute which sets the default value of the block
    ///     attribute on element and complex types in the targetNamespace of the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaDerivationMethod value representing the different
    ///     methods for preventing derivation. The default value is XmlSchemaDerivationMethod.None.
    ///[DefaultValue(XmlSchemaDerivationMethod.None)]
    ///[XmlAttribute("blockDefault")]
    function BlockDefault(): TXmlSchemaDerivationMethod;safecall; //XmlSchemaDerivationMethod
    ///
    /// ������:
    ///     Gets the post-schema-compilation value for all the attributes in the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the attributes in
    ///     the schema.
    function Attributes(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets the post-schema-compilation value of all the global attribute groups in
    ///     the schema.
    ///
    /// �������:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the global attribute
    ///     groups in the schema.
    function AttributeGroups(): IXmlSchemaObjectTable; safecall;
    ///
    /// ������:
    ///     Gets or sets the form for attributes declared in the target namespace of the
    ///     schema.
    ///
    /// �������:
    ///     The System.Xml.Schema.XmlSchemaForm value that indicates if attributes from the
    ///     target namespace are required to be qualified with the namespace prefix. The
    ///     default is System.Xml.Schema.XmlSchemaForm.None.
    ///[DefaultValue(XmlSchemaForm.None)]
    ///[XmlAttribute("attributeFormDefault")]
    function AttributeFormDefault(): TXmlSchemaForm;safecall; // XmlSchemaForm
  end;

  IXmlSchemaType = interface // abstract IXmlSchemaAnnotated IXmlSchemaObject
  ['{0AC541BF-F7D6-4770-9D7A-21C9599D7A36}']
    function BaseXmlSchemaType(): IXmlSchemaType; safecall;
    function TokenizedType(): TXmlTokenizedType; safecall;
    function Variety(): TXmlSchemaDatatypeVariety; safecall; //XmlSchemaDatatypeVariety
    function DerivedBy(): TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
    function Final(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
    function FinalResolved(): TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
    function IsMixed():Boolean; safecall;
    function Name():PChar; safecall;
    function QualifiedName(): IXmlQualifiedName; safecall;
    function TypeCode(): TXmlTypeCode; safecall; //XmlTypeCode
  end;

  IXmlSchemaParticle = interface // abstract IXmlSchemaAnnotated IXmlSchemaObject
  ['{878FCB24-B379-4D1C-97E6-C16283EACADA}']
    function MinOccurs(): Integer; safecall;
    function MaxOccurs(): Integer; safecall;
  end;
  //XmlSchemaGroupBase = interface(IXmlSchemaParticle)
  IXmlSchemaChoice = interface
  // XmlSchemaGroupBase IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{13E48227-9074-4A5D-9BD2-7247278C55F3}']
    function Items(): IXmlSchemaObjectCollection; safecall;
  end;
  IXmlSchemaSequence = interface
  // XmlSchemaGroupBase IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{1C471A5B-F299-4C56-9150-D7EE6A131433}']
    function Items(): IXmlSchemaObjectCollection; safecall;
  end;
  IXmlSchemaAll = interface
  // XmlSchemaGroupBase IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{90021AF2-A4DC-43C4-8E32-7C85CAEC877C}']
    function Items(): IXmlSchemaObjectCollection; safecall;
  end;
  IXmlSchemaGroupRef = interface
  // IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{AD8CFD50-221C-4A23-9561-DEAD635D8606}']
        function RefName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     �������� ���� �� System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll,
        ///     ��� System.Xml.Schema.XmlSchemaSequence ������, ������� �������� �������� �����
        ///     ���������� Particle ��������.
        ///
        /// �������:
        ///     �������� ����� ���������� Particle ��������, ������� �������� ����� �� System.Xml.Schema.XmlSchemaChoice,
        ///     System.Xml.Schema.XmlSchemaAll, ��� System.Xml.Schema.XmlSchemaSequence ������.
        function Particle(): IXmlSchemaParticle; safecall;
  end;
  IXmlSchemaAny = interface
  // IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{BE994973-F9BA-4B4B-AC4B-B704313EA5D5}']
        ///
        /// ������:
        ///     ���������� ��� ������ ������������ ����, ���������� ��������, ������� ����� ������������.
        ///
        /// �������:
        ///     ������������ ���� ��� ���������, ��������� ��� �������������. �������� �� ���������
        ///     � ##any. �������������.
        /// [XmlAttribute("namespace")]
    function Namespace():PChar; safecall;
        ///
        /// ������:
        ///     ���������� ��� ������ �������� � ���, ��� ���������� ��� ��������� XML ������
        ///     ������������ �������� ���������� XML �� ������� ������� ���������, ������������
        ///     any ��������.
        ///
        /// �������:
        ///     ���� �� �������� System.Xml.Schema.XmlSchemaContentProcessing. ���� �� processContents
        ///     ������� ������, �������� �� ��������� � Strict.
        /// [DefaultValue(XmlSchemaContentProcessing.None)]
        /// [XmlAttribute("processContents")]
    function ProcessContents(): Integer; safecall; //XmlSchemaContentProcessing
  end;

 IXmlSchemaComplexType = interface
 //  IXmlSchemaType IXmlSchemaAnnotated IXmlSchemaObject
 ['{C54F1BA1-804E-4617-B57D-F003702632B6}']
  function IsAbstract(): Boolean; safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ block ��������.
  ///
  /// �������:
  ///     block ������� ��� �������������� �������� ���� � ��������� ���� ������������.
  ///     �������� �� ��������� � XmlSchemaDerivationMethod.None. �������������.
  function Block(): Integer;safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ ��������, ������������, ����� �� ������� ��� ������ ����������
  ///     ����������� (�������� � ������ �����������).
  ///
  /// �������:
  ///     true, ���� ���������� ������ ����� ���������� ����� ��������� ���������� �������
  ///     �������� ����; � ��������� ������ � false. �������� �� ��������� � false. �������������.
  function IsMixed(): Boolean; safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ ����� ���������� System.Xml.Schema.XmlSchemaContentModel
  ///     ����� �������� ����.
  ///
  /// �������:
  ///     ��� ������ �����������, ������� �������� ����� �� System.Xml.Schema.XmlSchemaSimpleContent
  ///     ��� System.Xml.Schema.XmlSchemaComplexContent ������.
  ///[XmlElement("complexContent", typeof(XmlSchemaComplexContent))]
  ///[XmlElement("simpleContent", typeof(XmlSchemaSimpleContent))]
  function SimpleContentModel(): Boolean; safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ ��� ������������ ��� ���� �� System.Xml.Schema.XmlSchemaGroupRef,
  ///     System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll, ��� System.Xml.Schema.XmlSchemaSequence
  ///     ������.
  ///
  /// �������:
  ///     ��� ������������.
  /// [XmlElement("choice", typeof(XmlSchemaChoice))]
  /// [XmlElement("sequence", typeof(XmlSchemaSequence))]
  /// [XmlElement("group", typeof(XmlSchemaGroupRef))]
  /// [XmlElement("all", typeof(XmlSchemaAll))]
//  function Particle(): IXmlSchemaParticle; safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ �������� ��� System.Xml.Schema.XmlSchemaAnyAttribute ���������
  ///     �������� ����.
  ///
  /// �������:
  ///     System.Xml.Schema.XmlSchemaAnyAttribute ��������� �������� ����.
  ///[XmlElement("anyAttribute")]
  ///public XmlSchemaAnyAttribute AnyAttribute { get; set; }

  ///
  /// ������:
  ///     ���������� ������ ����������� �������� ����, ������� �������� �������� �����
  ///     ����������.
  ///
  /// �������:
  ///     �������� ������ ����������� ��� �������� ���� ����� ����������.
  function  ContentType():TXmlSchemaContentType; safecall; //XmlSchemaContentType
  ///
  /// ������:
  ///     ���������� ��������, ������� �������� �������� ����� ���������� ��� System.Xml.Schema.XmlSchemaComplexType.ContentType
  ///     ����������.
  ///
  /// �������:
  ///     �������� ��� ���� �����������. �������� ����� ���������� System.Xml.Schema.XmlSchemaComplexType.ContentType
  ///     ����������.
  function ContentTypeParticle(): IXmlSchemaParticle; safecall;
  ///
  /// ������:
  ///     ���������� �������� ����� ���������� ���� � �������������� ����� ����� ��������
  ///     �����. ��� �������� ���������, ����� ������� �������������� ������������ �����
  ///     ��� xsi:type ������������ � ���������� ���������.
  ///
  /// �������:
  ///     �������� ��������������� ������ ����� �������� �����. �������� �� ��������� �
  ///     BlockDefault �������� �� schema �������.
  function BlockResolved():TXmlSchemaDerivationMethod; safecall; // XmlSchemaDerivationMethod;
  ///
  /// ������:
  ///     ���������� ��������� ���� ��������������� ��������� ������� �������� ���� � ���
  ///     ������� �����.
  ///
  /// �������:
  ///     ��������� ���� ��������� �� ������� �������� ���� � ��� ������� �����. ��������
  ///     ����� ���������� AttributeUses ��������.
  function AttributeUses(): IXmlSchemaObjectTable; safecall;
 end;

 IXmlSchemaSimpleTypeContent = interface // abstract IXmlSchemaAnnotated IXmlSchemaObject
 ['{53BB52C5-0D13-4BD8-A500-4B73D3384B3A}']
 end;
 IXmlSchemaSimpleType = interface
 //  IXmlSchemaType IXmlSchemaAnnotated IXmlSchemaObject
 ['{1AD7CCFB-0F43-4524-87BF-443A1A4BF36F}']
   function Content(): IXmlSchemaSimpleTypeContent; safecall;
 end;

 IXmlSchemaSimpleTypeUnion = interface
 // IXmlSchemaSimpleTypeContent  IXmlSchemaAnnotated IXmlSchemaObject
 ['{848EB345-57C8-49E3-A1CC-FB8788DDB1FD}']
   function Count(): Integer;safecall;
   function Item(Index: Integer): IXmlSchemaSimpleType; safecall;
 end;

 IXmlSchemaFacet = interface  //IXmlSchemaAnnotated IXmlSchemaObject
 ['{4C823B54-2055-4542-B763-C8628F3033D3}']
   function Value(): PChar; safecall;
   function IsFixed(): Boolean; safecall;
   function  FacetType():Integer; safecall;
 end;
 IXmlSchemaSimpleTypeRestriction = interface
 // IXmlSchemaSimpleTypeContent  IXmlSchemaAnnotated IXmlSchemaObject
 ['{F421BE69-C385-4B48-B83C-6AE3B81F986C}']
   function BaseTypeName(): IXmlQualifiedName; safecall;
   function BaseType: IXmlSchemaSimpleType; safecall;
   function Facets(): IXmlSchemaObjectCollection; safecall;
 end;

 IXmlSchemaSimpleTypeList =interface
 // IXmlSchemaSimpleTypeContent  IXmlSchemaAnnotated IXmlSchemaObject
 ['{BFF8FD7F-14BE-4351-8882-0A5B47FAFA84}']
   function BaseItemType: IXmlSchemaSimpleType; safecall;
 end;

 IXmlSchemaElement = interface
  // IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
 ['{62FA146A-6681-4A24-9413-AA8BF4B21B43}']
        ///
        /// ������:
        ///     Gets or sets the type of the element. This can either be a complex type or a
        ///     simple type.
        ///
        /// �������:
        ///     The type of the element.
        ///[XmlElement("complexType", typeof(XmlSchemaComplexType))]
        ///[XmlElement("simpleType", typeof(XmlSchemaSimpleType))]
//   function SchemaType(): IXmlSchemaType; safecall;
        ///
        /// ������:
        ///     Gets or sets the reference name of an element declared in this schema (or another
        ///     schema indicated by the specified namespace).
        ///
        /// �������:
        ///     The reference name of the element.
        ///[XmlAttribute("ref")]
   function RefName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets the actual qualified name for the given element.
        ///
        /// �������:
        ///     The qualified name of the element. The post-compilation value of the QualifiedName
        ///     property.
        /// [XmlIgnore]
   function QualifiedName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets or sets the name of the element.
        ///
        /// �������:
        ///     The name of the element. The default is String.Empty.
        ///[DefaultValue("")]
        ///[XmlAttribute("name")]
   function Name():PChar; safecall;
        ///
        /// ������:
        ///     Gets or sets information that indicates if xsi:nil can occur in the instance
        ///     data. Indicates if an explicit nil value can be assigned to the element.
        ///
        /// �������:
        ///     If nillable is true, this enables an instance of the element to have the nil
        ///     attribute set to true. The nil attribute is defined as part of the XML Schema
        ///     namespace for instances. The default is false. Optional.
        ///[DefaultValue(false)]
        ///[XmlAttribute("nillable")]
   function IsNillable(): Boolean; safecall;
        ///
        /// ������:
        ///     Gets or sets information to indicate if the element can be used in an instance
        ///     document.
        ///
        /// �������:
        ///     If true, the element cannot appear in the instance document. The default is false.
        ///     Optional.
        ///[DefaultValue(false)]
        ///[XmlAttribute("abstract")]
   function IsAbstract(): Boolean; safecall;
        ///
        /// ������:
        ///     Gets or sets the form for the element.
        ///
        /// �������:
        ///     The form for the element. The default is the System.Xml.Schema.XmlSchema.ElementFormDefault
        ///     value. Optional.
        ///[DefaultValue(XmlSchemaForm.None)]
        ///[XmlAttribute("form")]
   function Form():TXmlSchemaForm; safecall; //XmlSchemaForm
        ///
        /// ������:
        ///     Gets or sets the name of a built-in data type defined in this schema or another
        ///     schema indicated by the specified namespace.
        ///
        /// �������:
        ///     The name of the built-in data type.
        /// [XmlAttribute("type")]
   function SchemaTypeName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets or sets the fixed value.
        ///
        /// �������:
        ///     The fixed value that is predetermined and unchangeable. The default is a null
        ///     reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("fixed")]
   function FixedValue(): PChar; safecall;
        ///
        /// ������:
        ///     Gets or sets the Final property to indicate that no further derivations are allowed.
        ///
        /// �������:
        ///     The Final property. The default is XmlSchemaDerivationMethod.None. Optional.
        ///[DefaultValue(XmlSchemaDerivationMethod.None)]
        ///[XmlAttribute("final")]
   function Final():TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
        ///
        /// ������:
        ///     Gets an System.Xml.Schema.XmlSchemaType object representing the type of the element
        ///     based on the System.Xml.Schema.XmlSchemaElement.SchemaType or
        /// System.Xml.Schema.XmlSchemaElement.SchemaTypeName
        ///     values of the element.
        ///
        /// �������:
        ///     An System.Xml.Schema.XmlSchemaType object.
   function ElementSchemaType(): IXmlSchemaType; safecall;
        ///
        /// ������:
        ///     Gets or sets the default value of the element if its content is a simple type
        ///     or content of the element is textOnly.
        ///
        /// �������:
        ///     The default value for the element. The default is a null reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("default")]
   function DefaultValue(): PChar; safecall;
        ///
        /// ������:
        ///     Gets the collection of constraints on the element.
        ///
        /// �������:
        ///     The collection of constraints.
        ///[XmlElement("key", typeof(XmlSchemaKey))]
        ///[XmlElement("keyref", typeof(XmlSchemaKeyref))]
        ///[XmlElement("unique", typeof(XmlSchemaUnique))]
        ///public XmlSchemaObjectCollection Constraints { get; }
        ///
        /// ������:
        ///     Gets the post-compilation value of the Block property.
        ///
        /// �������:
        ///     The post-compilation value of the Block property. The default is the BlockDefault
        ///     value on the schema element.
   function BlockResolved(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// ������:
        ///     Gets or sets a Block derivation.
        ///
        /// �������:
        ///     The attribute used to block a type derivation. Default value is XmlSchemaDerivationMethod.None.
        ///     Optional.
        ///[DefaultValue(XmlSchemaDerivationMethod.None)]
        ///[XmlAttribute("block")]
   function Block(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// ������:
        ///     Gets the post-compilation value of the Final property.
        ///
        /// �������:
        ///     The post-compilation value of the Final property. Default value is the FinalDefault
        ///     value on the schema element.
        /// [XmlIgnore]
   function FinalResolved(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// ������:
        ///     Gets or sets the name of an element that is being substituted by this element.
        ///
        /// �������:
        ///     The qualified name of an element that is being substituted by this element. Optional.
        /// [XmlAttribute("substitutionGroup")]
   function SubstitutionGroup(): IXmlQualifiedName; safecall;
 end;

 IXmlSchemaAttribute = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{CD35A56F-09F2-4071-B739-2C115DB7D58F}']
        ///
        /// ������:
        ///     Gets an System.Xml.Schema.XmlSchemaSimpleType object representing the type of
        ///     the attribute based on the System.Xml.Schema.XmlSchemaAttribute.SchemaType or
        ///     System.Xml.Schema.XmlSchemaAttribute.SchemaTypeName of the attribute.
        ///
        /// �������:
        ///     An System.Xml.Schema.XmlSchemaSimpleType object.
   function AttributeSchemaType: IXmlSchemaSimpleType; safecall;
        ///
        /// ������:
        ///     Gets or sets the default value for the attribute.
        ///
        /// �������:
        ///     The default value for the attribute. The default is a null reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("default")]
   function DefaultValue(): PChar; safecall;
        ///
        /// ������:
        ///     Gets or sets the fixed value for the attribute.
        ///
        /// �������:
        ///     The fixed value for the attribute. The default is null. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("fixed")]
   function FixedValue(): PChar; safecall;
        ///
        /// ������:
        ///     Gets or sets the form for the attribute.
        ///
        /// �������:
        ///     One of the System.Xml.Schema.XmlSchemaForm values. The default is the value of
        ///     the System.Xml.Schema.XmlSchema.AttributeFormDefault of the schema element containing
        ///     the attribute. Optional.
        ///[DefaultValue(XmlSchemaForm.None)]
        ///[XmlAttribute("form")]
   function  Form(): TXmlSchemaForm; safecall; //XmlSchemaForm
        ///
        /// ������:
        ///     Gets or sets the name of the attribute.
        ///
        /// �������:
        ///     The name of the attribute.
        ///[XmlAttribute("name")]
   function Name(): PChar; safecall;
        ///
        /// ������:
        ///     Gets the qualified name for the attribute.
        ///
        /// �������:
        ///     The post-compilation value of the QualifiedName property.
   function QualifiedName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets or sets the name of an attribute declared in this schema (or another schema
        ///     indicated by the specified namespace).
        ///
        /// �������:
        ///     The name of the attribute declared.
        ///[XmlAttribute("ref")]
   function RefName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets or sets the attribute type to a simple type.
        ///
        /// �������:
        ///     The simple type defined in this schema.
        ///[XmlElement("simpleType")]
   function SchemaType: IXmlSchemaSimpleType; safecall;
        ///
        /// ������:
        ///     Gets or sets the name of the simple type defined in this schema (or another schema
        ///     indicated by the specified namespace).
        ///
        /// �������:
        ///     The name of the simple type.
        ///[XmlAttribute("type")]
   function SchemaTypeName(): IXmlQualifiedName; safecall;
        ///
        /// ������:
        ///     Gets or sets information about how the attribute is used.
        ///
        /// �������:
        ///     One of the following values: None, Prohibited, Optional, or Required. The default
        ///     is Optional. Optional.
        ///[DefaultValue(XmlSchemaUse.None)]
        /// [XmlAttribute("use")]
   function  Use(): TXmlSchemaUse; safecall;
 end;

 IXMLValidatorCallBack = interface
  ['{AE7AF832-8353-48DC-966D-E6FE7737F171}']
  procedure ValidationCallback(SeverityType: integer; ErrorMessage: PChar); safecall;
 end;

 IXmlNamespaceManager= interface
 ['{79CED196-FC1C-4032-8CB8-A6CD1E6C305C}']
        ///
        /// ������:
        ///     ���������� ������������� ��� ������� (URI) ��� ������������ ���� �� ���������.
        ///
        /// �������:
        ///     ���������� URI ��� ������������ ���� �� ��������� ��� String.Empty, ���� ������������
        ///     ���� �� ��������� �����������.
   function DefaultNamespace():PChar; safecall;
        ///
        /// ������:
        ///     ���������� ��������, �����������, ���������� �� ������������ ���� ��� ����������
        ///     �������� � ������� ������� ���������, ���������� � ����.
        ///
        /// ���������:
        ///   prefix:
        ///     ������� ������������ ����, ������� ��������� �����.
        ///
        /// �������:
        ///     true���� ������� ������������ ������������ ����; � ��������� ������ false.
   function HasNamespace(prefix: PChar): Boolean; safecall;
        ///
        /// ������:
        ///     ���������� URI ������������ ���� ��� ���������� ��������.
        ///
        /// ���������:
        ///   prefix:
        ///     �������, ��� �������� ��������� ��������� URI ������������ ����. ����� �����������
        ///     ������������ ���� �� ���������, ���������� �������� String.Empty.
        ///
        /// �������:
        ///     ���������� URI ������������ ���� ��� prefix ��� null ���� ��������������� ������������
        ///     ���� �����������. ������������ ������ �������� ���������������. ��������������
        ///     �������� � ������������� ������� ��. � ������� System.Xml.XmlNameTable ������.
  function LookupNamespace(prefix: PChar):PChar; safecall;
        ///
        /// ������:
        ///     ������� �������, ����������� ��� ��������� URI ������������ ����.
        ///
        /// ���������:
        ///   uri:
        ///     ������������ ����, ����� ��������� ��� ��������� ��������.
        ///
        /// �������:
        ///     ��������������� �������. ���� ��� ��������������� ��������, ������ ����� ����������
        ///     String.Empty. ���� ������� �������� null, ����� null ������������.
  function LookupPrefix(uri: PChar):PChar; safecall;
 end;

 IXmlSchemaSet = interface
  ['{CEAD7A91-2DAC-44E1-8425-F32E1A23DCE3}']
  function Namespace(): IXmlNamespaceManager; safecall;
        ///
        /// ������:
        ///     �������� ��� ���������� �������� � ����������� ����� XML ���� ����� XSD � System.Xml.Schema.XmlSchemaSet.
        ///
        /// �������:
        ///     ��������� ���������� ���������.
  function GlobalAttributes(): IXmlSchemaObjectTable; safecall;
        ///
        /// ������:
        ///     �������� ��� ���������� �������� � ����������� ����� XML ���� ����� XSD � System.Xml.Schema.XmlSchemaSet.
        ///
        /// �������:
        ///     ��������� ���������� ���������.
  function GlobalElements(): IXmlSchemaObjectTable; safecall;
        ///
        /// ������:
        ///     �������� ��� ���������� ������� � ������� ���� � ����������� ����� XML ���� �����
        ///     XSD � System.Xml.Schema.XmlSchemaSet.
        ///
        /// �������:
        ///     ��������� ���������� ������� � ������� �����.
  function GlobalTypes(): IXmlSchemaObjectTable; safecall;
  procedure Add(nameSpase, FileName: PChar); safecall;
  procedure Compile(); safecall;
        ///
        /// ������:
        ///     ���������� ��������, �����������, �������� �� ������� ����� ����������� �����
        ///     XML � System.Xml.Schema.XmlSchemaSet ���� ��������������.
        ///
        /// �������:
        ///     true ���� ����� � System.Xml.Schema.XmlSchemaSet ���� �������������� � �������
        ///     ���������� ����� ��� �������� ��� ������ �� System.Xml.Schema.XmlSchemaSet; �
        ///     ��������� ������ � false.
  function IsCompiled(): Boolean; safecall;
        ///
        /// ������:
        ///     ��������� ���������� �������, ���������� �������� �� ������� �������� ���� �����
        ///     ����������� ���� XML (XSD).
  procedure AddValidationEventHandler(v: IXMLValidatorCallBack); safecall;
        ///
        /// ������:
        ///     ��������� ��������� ����� ����� XSD ����������� ����� XML, ������� ��� ����������
        ///     � System.Xml.Schema.XmlSchemaSet.
        ///
        /// ���������:
        ///   schema:
        ///     �����, ������� ���������� ���������� ��������.
        ///
        /// �������:
        ///     System.Xml.Schema.XmlSchema �������, ���� ����� �������� ���������� ������. ����
        ///     ����� �� �������� ���������� � System.Xml.Schema.ValidationEventHandler ������,
        ///     null ������������ � ��������� ��������������� ������� ��������. � ��������� ������
        ///     � System.Xml.Schema.XmlSchemaException ��������� ����������.
        ///
        /// ����������:
        ///   T:System.Xml.Schema.XmlSchemaException:
        ///     ������������ �����.
        ///
        ///   T:System.ArgumentNullException:
        ///     System.Xml.Schema.XmlSchema ������, ������������ ��� �������� � null.
        ///
        ///   T:System.ArgumentException:
        ///     System.Xml.Schema.XmlSchema ������, ������������ ��� �������� ��� �� ����������
        ///     � System.Xml.Schema.XmlSchemaSet.
  function Reprocess(schema: IXmlSchema): IXmlSchema; safecall;
        ///
        /// ������:
        ///     ���������� ��������� ���� ����������� ����� XML ���� ����� XSD � System.Xml.Schema.XmlSchemaSet.
        ///
        /// �������:
        ///     System.Collections.ICollection ������, ���������� ��� �����, ������� ���� ���������
        ///     � System.Xml.Schema.XmlSchemaSet. ���� ����� �� ���� ��������� � System.Xml.Schema.XmlSchemaSet,
        ///     ������ System.Collections.ICollection ������������ ������.
  function Schemas(): IXMLEnumerable; safecall; overload;
        ///
        /// ������:
        ///     ���������� ��������� ���� ����������� ����� XML ���� ����� XSD � System.Xml.Schema.XmlSchemaSet
        ///     ����������� � ������� ������������ ����.
        ///
        /// ���������:
        ///   targetNamespace:
        ///     ����� targetNamespace ��������.
        ///
        /// �������:
        ///     System.Collections.ICollection ������, ���������� ��� �����, ������� ���� ���������
        ///     � System.Xml.Schema.XmlSchemaSet ����������� � ������� ������������ ����. ����
        ///     ����� �� ���� ��������� � System.Xml.Schema.XmlSchemaSet, ������ System.Collections.ICollection
        ///     ������������ ������.
  function Schemas(targetNamespace: PChar): IXMLEnumerable; safecall; overload;
  procedure Validate(FileName: PChar); safecall;
 end;

 IXmlSchemaGroup = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{D969D90F-16C4-4463-848B-1E8B255286B2}']
         ///
        /// ������:
        ///     ���������� ��� ������ ��� ������ ����.
        ///
        /// �������:
        ///     ��� ������ ����.
        /// [XmlAttribute("name")]
   function Name(): PChar; safecall;
        ///
        /// ������:
        ///     ���������� ��� ������ ���� �� System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll,
        ///     ��� System.Xml.Schema.XmlSchemaSequence ������.
        ///
        /// �������:
        ///     ���� �� System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll, ���
        ///     System.Xml.Schema.XmlSchemaSequence ������.
        ///[XmlElement("sequence", typeof(XmlSchemaSequence))]
        ///[XmlElement("choice", typeof(XmlSchemaChoice))]
        ///[XmlElement("all", typeof(XmlSchemaAll))]
   function Particle(): IXmlSchemaParticle; safecall;
        ///
        /// ������:
        ///     ���������� ������ ��� ������ ����.
        ///
        /// �������:
        ///     System.Xml.XmlQualifiedName ������, �������������� ������ ��� ������ ����.
        ///[XmlIgnore]
   function QualifiedName(): IXmlQualifiedName; safecall;
end;

 IXmlSchemaAttributeGroup = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{1E47DBD5-7750-4B49-A8FE-980BD5683D9F}']
    ///
    /// ������:
    ///     ���������� ��� ������ ��� ������ ���������.
    ///
    /// �������:
    ///     ��� ������ ���������.
    ///[XmlAttribute("name")]
    function Name(): PChar; safecall;
    ///
    /// ������:
    ///     ���������� ��������� ��������� ��� ������ ���������. �������� XmlSchemaAttribute
    ///     � XmlSchemaAttributeGroupRef ��������.
    ///
    /// �������:
    ///     ��������� ��������� ��� ������ ���������.
    ///[XmlElement("attributeGroup", typeof(XmlSchemaAttributeGroupRef))]
    ///[XmlElement("attribute", typeof(XmlSchemaAttribute))]
    function Attributes(): IXmlSchemaObjectCollection; safecall;
    ///
    /// ������:
    ///     ���������� ��� ������ System.Xml.Schema.XmlSchemaAnyAttribute ��������� ������
    ///     ���������.
    ///
    /// �������:
    ///     World Wide Web Consortium (W3C) anyAttribute ��������.
    ///[XmlElement("anyAttribute")]
    /// public XmlSchemaAnyAttribute AnyAttribute { get; set; }
    ///
    /// ������:
    ///     ���������� ������ ��� ������ ���������.
    ///
    /// �������:
    ///     ������ ��� ������ ���������.
    ///[XmlIgnore]
    function QualifiedName(): IXmlQualifiedName; safecall;
    ///
    /// ������:
    ///     ���������� ���������������� �������� ������ ��������� �� ����� XML.
    ///
    /// �������:
    ///     ���������������� �������� ������ ���������.
    ///[XmlIgnore]
    function RedefinedAttributeGroup(): IXmlSchemaAttributeGroup; safecall;
 end;

 IXmlSchemaNotation = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{04599C1A-F064-4661-90C4-326264600E79}']
    ///
    /// ������:
    ///     ���������� ��� ������ ��� �������.
    ///
    /// �������:
    ///     ��� �������.
    ///[XmlAttribute("name")]
    function Name(): PChar; safecall;
    ///
    /// ������:
    ///     ���������� ��� ������ public �������������.
    ///
    /// �������:
    ///     public �������������. �������� ������ ���� �������������� ��������������� URI.
    ///[XmlAttribute("public")]
    function Public(): PChar; safecall;
    ///
    /// ������:
    ///     ���������� ��� ������ system �������������.
    ///
    /// �������:
    ///     system �������������. �������� ������ ���� �������������� ������������� �����
    ///     ������� (URI).
    /// [XmlAttribute("system")]
    function System(): PChar; safecall;
 end;

 IXmlSchemaAnnotation = interface  // IXmlSchemaObject
 ['{C2BD2AFC-2ACB-458E-8D30-3417E15C2998}']
   function GetAnnotation(): PChar; safecall;
 end;

 IXmlSchemaExternal = interface // abstract IXmlSchemaObject
 ['{FF2F3F61-DC24-4069-A6CF-87C709956EB5}']
    ///
    /// ������:
    ///     ���������� ��� ������ ������������ ������������� ��� ������� (URI) ��� �����,
    ///     ���������� ���������� �����, ��� ���������� ������������.
    ///
    /// �������:
    ///     ������������ URI ��� �����. ������������� ��� ��������������� �����.
    ///[XmlAttribute("schemaLocation", DataType = "anyURI")]
    function SchemaLocation(): PChar; safecall;
    ///
    /// ������:
    ///     ���������� ��� ������ XmlSchema ��� ��������� �����.
    ///
    /// �������:
    ///     XmlSchema ��� ��������� �����.
    /// [XmlIgnore]
    function Schema(): IXmlSchema; safecall;
    ///
    /// ������:
    ///     ���������� ��� ������ ������������� ������.
    ///
    /// �������:
    ///     ������������� ������. �������� �� ��������� � String.Empty. �������������.
    /// [XmlAttribute("id", DataType = "ID")]
    function Id(): PChar; safecall;
 end;

 IXmlSchemaImport = interface
 // IXmlSchemaExternal IXmlSchemaObject
 ['{12AF0716-D648-42EC-8921-4A88FA2B0300}']
  /// ������:
  ///     ���������� ��� ������ ������� ������������ ���� ��� ��������������� ����� � ����
  ///     ������ URI.
  ///
  /// �������:
  ///     ������� ������������ ���� ��� ��������������� ����� � ���� ������ URI. �������������.
  /// [XmlAttribute("namespace", DataType = "anyURI")]
  function Namespace(): PChar; safecall;
  ///
  /// ������:
  ///     ���������� ��� ������ �������� annotation.
  ///
  /// �������:
  ///     ����������.
  /// [XmlElement("annotation", typeof(XmlSchemaAnnotation))]
  function GetAnnotation(): PChar; safecall;
 end;

 IXmlSchemaInclude =interface
 // IXmlSchemaExternal IXmlSchemaObject
 ['{9468FBB5-BD0C-4F8B-BFB3-D865E2489C2A}']
  function GetAnnotation(): PChar; safecall;
 end;

procedure GetXmlSchemaSet(out XmlSchemaSet: IXmlSchemaSet); stdcall; external 'cstopas.dll';
procedure GetXmlQualifiedName(obj: TCSharp;
                                out intf: IXmlQualifiedName); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaObject(obj: TCSharp;
                                out intf: IXmlSchemaObject); stdcall; external 'cstopas.dll';
procedure GetXmlSchema(obj: TCSharp;
                                out intf: IXmlSchema); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaAttribute(obj: TCSharp;
                                out intf: IXmlSchemaAttribute); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaElement(obj: TCSharp;
                                out intf: IXmlSchemaElement); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaType(obj: TCSharp;
                                out intf: IXmlSchemaType); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaGroup(obj: TCSharp;
                                out intf: IXmlSchemaGroup); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaAttributeGroup(obj: TCSharp;
                                out intf: IXmlSchemaAttributeGroup); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaNotation(obj: TCSharp;
                                out intf: IXmlSchemaNotation); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaAnnotation(obj: TCSharp;
                                out intf: IXmlSchemaAnnotation); stdcall; external 'cstopas.dll';
procedure GetXmlSchemaExternal(obj: TCSharp;
                                out intf: IXmlSchemaExternal); stdcall; external 'cstopas.dll';

function XObjects(Enum: IInterface): TXEnum<IXmlSchemaObject>;
function XIncludes(Enum: IInterface): TXEnum<IXmlSchemaExternal>;
function XNames(Enum: IInterface): TXEnum<IXmlQualifiedName>;
function XAttributes(Enum: IInterface): TXEnum<IXmlSchemaAttribute>;
function XElements(Enum: IInterface): TXEnum<IXmlSchemaElement>;
function XTypes(Enum: IInterface): TXEnum<IXmlSchemaType>;
function XSchemas(Enum: IInterface): TXEnum<IXmlSchema>;
function XGroups(Enum: IInterface): TXEnum<IXmlSchemaGroup>;
function XAttributeGroups(Enum: IInterface): TXEnum<IXmlSchemaAttributeGroup>;
function XNotations(Enum: IInterface): TXEnum<IXmlSchemaNotation>;


implementation

function XIncludes(Enum: IInterface): TXEnum<IXmlSchemaExternal>;
begin
  Result := TXEnum<IXmlSchemaExternal>.Create(Enum as IXMLEnumerable, GetXmlSchemaExternal);
end;
function XObjects(Enum: IInterface): TXEnum<IXmlSchemaObject>;
begin
  Result := TXEnum<IXmlSchemaObject>.Create(Enum as IXMLEnumerable, GetXmlSchemaObject);
end;
function XNotations(Enum: IInterface): TXEnum<IXmlSchemaNotation>;
begin
  Result := TXEnum<IXmlSchemaNotation>.Create(Enum as IXMLEnumerable, GetXmlSchemaNotation);
end;
function XGroups(Enum: IInterface): TXEnum<IXmlSchemaGroup>;
begin
  Result := TXEnum<IXmlSchemaGroup>.Create(Enum as IXMLEnumerable, GetXmlSchemaGroup);
end;
function XAttributeGroups(Enum: IInterface): TXEnum<IXmlSchemaAttributeGroup>;
begin
  Result := TXEnum<IXmlSchemaAttributeGroup>.Create(Enum as IXMLEnumerable, GetXmlSchemaAttributeGroup);
end;
function XSchemas(Enum: IInterface): TXEnum<IXmlSchema>;
begin
  Result := TXEnum<IXmlSchema>.Create(Enum as IXMLEnumerable, GetXmlSchema);
end;
function XTypes(Enum: IInterface): TXEnum<IXmlSchemaType>;
begin
  Result := TXEnum<IXmlSchemaType>.Create(Enum as IXMLEnumerable, GetXmlSchemaType);
end;
function XElements(Enum: IInterface): TXEnum<IXmlSchemaElement>;
begin
  Result := TXEnum<IXmlSchemaElement>.Create(Enum as IXMLEnumerable, GetXmlSchemaElement);
end;
function XNames(Enum: IInterface): TXEnum<IXmlQualifiedName>;
begin
  Result := TXEnum<IXmlQualifiedName>.Create(Enum as IXMLEnumerable, GetXmlQualifiedName);
end;
function XAttributes(Enum: IInterface): TXEnum<IXmlSchemaAttribute>;
begin
  Result := TXEnum<IXmlSchemaAttribute>.Create(Enum as IXMLEnumerable, GetXmlSchemaAttribute);
end;

{ TXEnum<T> }

constructor TXEnum<T>.Create(Enum: IXMLEnumerable; func: TGetXml<T>);
begin
  FEnum := Enum.GetEnumerator;
  FFunc := func;
end;

function TXEnum<T>.DoGetCurrent: T;
begin
  FFunc(FEnum.Current, Result);
end;

function TXEnum<T>.GetEnumerator: TXEnum<T>;
begin
  Result := Self;
end;

function TXEnum<T>.MoveNext: Boolean;
begin
  Result := FEnum.MoveNext;
end;

end.
