unit CsToPas;

interface

uses SysUtils;

type
    TXmlSchemaDerivationMethod = Integer;
    ///
    /// Сводка:
    ///     Предоставляет различные методы для предотвращения создания производных типов.
    XmlSchemaDerivationMethod = set of
    (
       ///
       /// Сводка:
       ///     Переопределите метод создания производных по умолчанию для разрешения любого
       ///     вывода.
        dmEmpty = 0,
        ///
        /// Сводка:
        ///     Ссылается на выводы посредством Substitution.
        dmSubstitution = 1,
        ///
        /// Сводка:
        ///     Ссылается на выводы посредством Extension.
        dmExtension = 2,
        ///
        /// Сводка:
        ///     Ссылается на выводы посредством Restriction.
        dmRestriction = 4,
        ///
        /// Сводка:
        ///     Ссылается на выводы посредством List.
        dmList = 8,
        ///
        /// Сводка:
        ///     Ссылается на выводы посредством Union.
        dmUnion = 16,
        ///
        /// Сводка:
        ///     #all. Ссылается на все методы вывода.
        dmAll = 255
        ///
        /// Сводка:
        ///     Принимает метод создания производных по умолчанию.
     //   dmNone = 256
    );
    TXmlTokenizedType = Integer;
    ///
    /// Сводка:
    ///     Представляет тип XML для строки. Это позволяет читать как тип XML, например тип
    ///     раздела CDATA строку.
    XmlTokenizedType =
    (
        ///
        /// Сводка:
        ///     Тип CDATA.
        ttCDATA = 0,
        ///
        /// Сводка:
        ///     Тип идентификатора.
        ttID = 1,
        ///
        /// Сводка:
        ///     Тип IDREF.
        ttIDREF = 2,
        ///
        /// Сводка:
        ///     Тип IDREFS.
        ttIDREFS = 3,
        ///
        /// Сводка:
        ///     Тип СУЩНОСТИ.
        ttENTITY = 4,
        ///
        /// Сводка:
        ///     Тип СУЩНОСТИ.
        ttENTITIES = 5,
        ///
        /// Сводка:
        ///     Тип NMTOKEN.
        ttNMTOKEN = 6,
        ///
        /// Сводка:
        ///     Тип NMTOKENS.
        ttNMTOKENS = 7,
        ///
        /// Сводка:
        ///     Тип NOTATION.
        ttNOTATION = 8,
        ///
        /// Сводка:
        ///     Тип ПЕРЕЧИСЛЕНИЯ.
        ttENUMERATION = 9,
        ///
        /// Сводка:
        ///     Тип QName.
        ttQName = 10,
        ///
        /// Сводка:
        ///     Тип имени NCName.
        ttNCName = 11,
        ///
        /// Сводка:
        ///     Не является типом.
        ttNone = 12
    );
    TXmlSchemaDatatypeVariety = Integer;
    ///
    /// Сводка:
    ///     Указывает тип разновидность типа данных схемы W3C XML.
    XmlSchemaDatatypeVariety =
    (
        ///
        /// Сводка:
        ///     Atomic тип схемы W3C XML.
        dvAtomic = 0,
        ///
        /// Сводка:
        ///     Тип списка схемы W3C XML.
        dvList = 1,
        ///
        /// Сводка:
        ///     Объединение тип схемы W3C XML.
        dvUnion = 2
    );
    TXmlTypeCode = Integer;
    ///
    /// Сводка:
    ///     Представляет типы схемы W3C схемы языка определения XML (XSD).
    XmlTypeCode =
    (
        ///
        /// Сводка:
        ///     Нет информации о типе.
        tcNone = 0,
        ///
        /// Сводка:
        ///     Например, узел или атомарное значение элемента.
        tcItem = 1,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcNode = 2,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcDocument = 3,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcElement = 4,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcAttribute = 5,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcNamespace = 6,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcProcessingInstruction = 7,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcComment = 8,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcText = 9,
        ///
        /// Сводка:
        ///     Любое атомарное значение объединения.
        tcAnyAtomicType = 10,
        ///
        /// Сводка:
        ///     Нетипизированное атомное значение.
        tcUntypedAtomic = 11,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:string типа.
        tctcString = 12,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:boolean типа.
        tcBoolean = 13,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:decimal типа.
        tcDecimal = 14,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:float типа.
        tcFloat = 15,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:double типа.
        tcDouble = 16,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:Duration типа.
        tcDuration = 17,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:dateTime типа.
        tcDateTime = 18,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:time типа.
        tcTime = 19,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:date типа.
        tcDate = 20,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:gYearMonth типа.
        tcGYearMonth = 21,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:gYear типа.
        tcGYear = 22,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:gMonthDay типа.
        tcGMonthDay = 23,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:gDay типа.
        tcGDay = 24,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:gMonth типа.
        tcGMonth = 25,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:hexBinary типа.
        tcHexBinary = 26,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:base64Binary типа.
        tcBase64Binary = 27,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:anyURI типа.
        tcAnyUri = 28,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:QName типа.
        tcQName = 29,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:NOTATION типа.
        tcNotation = 30,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:normalizedString типа.
        tcNormalizedString = 31,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:token типа.
        tcToken = 32,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:language типа.
        tcLanguage = 33,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:NMTOKEN типа.
        tctcNmToken = 34,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:Name типа.
        tcName = 35,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:NCName типа.
        tcNCName = 36,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:ID типа.
        tcId = 37,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:IDREF типа.
        tcIdref = 38,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:ENTITY типа.
        tcEntity = 39,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:integer типа.
        tcInteger = 40,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:nonPositiveInteger типа.
        NonPositiveInteger = 41,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:negativeInteger типа.
        tcNegativeInteger = 42,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:long типа.
        tcLong = 43,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:int типа.
        tcInt = 44,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:short типа.
        tcShort = 45,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:byte типа.
        tcByte = 46,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:nonNegativeInteger типа.
        tcNonNegativeInteger = 47,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:unsignedLong типа.
        tcUnsignedLong = 48,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:unsignedInt типа.
        tcUnsignedInt = 49,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:unsignedShort типа.
        tcUnsignedShort = 50,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:unsignedByte типа.
        tcUnsignedByte = 51,
        ///
        /// Сводка:
        ///     Схемы W3C XML xs:positiveInteger типа.
        tcPositiveInteger = 52,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcYearMonthDuration = 53,
        ///
        /// Сводка:
        ///     Это значение поддерживает инфраструктуру .NET Framework и не предназначен для
        ///     непосредственного использования в коде.
        tcDayTimeDuration = 54
    );

    TXmlSchemaForm = Integer;
    ///
    /// Сводка:
    ///     Указывает, должны ли атрибуты или элементы получать префикс пространства имен.
    XmlSchemaForm =
    (
        ///
        /// Сводка:
        ///     Форма элемента и атрибута не указан в схеме.
        sfNone = 0,
        ///
        /// Сводка:
        ///     Элементы и атрибуты должны быть дополнены префиксом пространства имен.
        sfQualified = 1,
        ///
        /// Сводка:
        ///     Элементы и атрибуты не требуются в соответствии с префиксом пространства имен.
        sfUnqualified = 2
    );

    TXmlSchemaContentType = Integer;
    ///
    /// Сводка:
    ///     Перечисления для модели содержимого сложного типа. Представляет содержимое в
    ///     наборе сведений после проверки схемы (infoset).
    XmlSchemaContentType =
    (
        ///
        /// Сводка:
        ///     Только текстовое содержимое.
        scTextOnly = 0,
        ///
        /// Сводка:
        ///     Пустое содержимое.
        scEmpty = 1,
        ///
        /// Сводка:
        ///     Только содержимое элемента.
        scElementOnly = 2,
        ///
        /// Сводка:
        ///     Смешанное содержимое.
        scMixed = 3
    );

    TXmlSchemaUse = Integer;
    ///
    /// Сводка:
    ///     Указывает, как используется атрибут.
    XmlSchemaUse =
    (
        ///
        /// Сводка:
        ///     Использование атрибута не указано.
        suNone = 0,
        ///
        /// Сводка:
        ///     Атрибут является необязательным.
        suOptional = 1,
        ///
        /// Сводка:
        ///     Атрибут нельзя использовать.
        suProhibited = 2,
        ///
        /// Сводка:
        ///     Атрибут должен отобразиться один раз.
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
        /// Сводка:
        ///     Возвращает или задает исходное расположение для файла, загрузившего данную схему.
        ///
        /// Возврат:
        ///     Исходное расположение (URI) для файла.
   function SourceUri(): PChar; safecall;
        ///
        /// Сводка:
        ///     Возвращает или задает родительский элемент объекта System.Xml.Schema.XmlSchemaObject.
        ///
        /// Возврат:
        ///     Родительский System.Xml.Schema.XmlSchemaObject данного System.Xml.Schema.XmlSchemaObject.
   function Parent(): IXmlSchemaObject; safecall;
        ///
        /// Сводка:
        ///     Возвращает или задает System.Xml.Serialization.XmlSerializerNamespaces для использования
        ///     с этим объектом схемы.
        ///
        /// Возврат:
        ///     System.Xml.Serialization.XmlSerializerNamespaces Свойство для объекта схемы.
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
    /// Сводка:
    ///     Gets the post-schema-compilation value of all schema types in the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectCollection of all schema types in the schema.
    function SchemaTypes(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets the post-schema-compilation value for all notations in the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all notations in the
    ///     schema.
    function Notations(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets the collection of schema elements in the schema and is used to add new element
    ///     types at the schema element level.
    ///
    /// Возврат:
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
    /// Сводка:
    ///     Gets the collection of included and imported schemas.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectCollection of the included and imported schemas.
    function Includes(): IXmlSchemaObjectCollection; safecall;
    function Id(): PChar; safecall;
    ///
    /// Сводка:
    ///     Gets the post-schema-compilation value of all the groups in the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the groups in the
    ///     schema.
    function Groups(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets or sets the finalDefault attribute which sets the default value of the final
    ///     attribute on elements and complex types in the target namespace of the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaDerivationMethod value representing the different
    ///     methods for preventing derivation. The default value is XmlSchemaDerivationMethod.None.
    ///[DefaultValue(XmlSchemaDerivationMethod.None)]
    ///[XmlAttribute("finalDefault")]
    function FinalDefault(): TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
    ///
    /// Сводка:
    ///     Gets the post-schema-compilation value for all the elements in the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the elements in the
    ///     schema.
    function Elements(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets or sets the form for elements declared in the target namespace of the schema.
    ///
    /// Возврат:
    ///     The System.Xml.Schema.XmlSchemaForm value that indicates if elements from the
    ///     target namespace are required to be qualified with the namespace prefix. The
    ///     default is System.Xml.Schema.XmlSchemaForm.None.
    ///[DefaultValue(XmlSchemaForm.None)]
    ///[XmlAttribute("elementFormDefault")]
    function ElementFormDefault(): TXmlSchemaForm; safecall; //XmlSchemaForm
    ///
    /// Сводка:
    ///     Gets or sets the blockDefault attribute which sets the default value of the block
    ///     attribute on element and complex types in the targetNamespace of the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaDerivationMethod value representing the different
    ///     methods for preventing derivation. The default value is XmlSchemaDerivationMethod.None.
    ///[DefaultValue(XmlSchemaDerivationMethod.None)]
    ///[XmlAttribute("blockDefault")]
    function BlockDefault(): TXmlSchemaDerivationMethod;safecall; //XmlSchemaDerivationMethod
    ///
    /// Сводка:
    ///     Gets the post-schema-compilation value for all the attributes in the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the attributes in
    ///     the schema.
    function Attributes(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets the post-schema-compilation value of all the global attribute groups in
    ///     the schema.
    ///
    /// Возврат:
    ///     An System.Xml.Schema.XmlSchemaObjectTable collection of all the global attribute
    ///     groups in the schema.
    function AttributeGroups(): IXmlSchemaObjectTable; safecall;
    ///
    /// Сводка:
    ///     Gets or sets the form for attributes declared in the target namespace of the
    ///     schema.
    ///
    /// Возврат:
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
        /// Сводка:
        ///     Получает один из System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll,
        ///     или System.Xml.Schema.XmlSchemaSequence классы, которые содержит значение после
        ///     компиляции Particle свойство.
        ///
        /// Возврат:
        ///     Значение после компиляции Particle свойство, которое является одним из System.Xml.Schema.XmlSchemaChoice,
        ///     System.Xml.Schema.XmlSchemaAll, или System.Xml.Schema.XmlSchemaSequence классы.
        function Particle(): IXmlSchemaParticle; safecall;
  end;
  IXmlSchemaAny = interface
  // IXmlSchemaParticle IXmlSchemaAnnotated IXmlSchemaObject
  ['{BE994973-F9BA-4B4B-AC4B-B704313EA5D5}']
        ///
        /// Сводка:
        ///     Возвращает или задает пространство имен, содержащее элементы, которые можно использовать.
        ///
        /// Возврат:
        ///     Пространства имен для элементов, доступных для использования. Значение по умолчанию
        ///     — ##any. Необязательно.
        /// [XmlAttribute("namespace")]
    function Namespace():PChar; safecall;
        ///
        /// Сводка:
        ///     Возвращает или задает сведения о том, как приложение или процессор XML должен
        ///     осуществлять проверку документов XML на предмет наличия элементов, определенных
        ///     any элемента.
        ///
        /// Возврат:
        ///     Одно из значений System.Xml.Schema.XmlSchemaContentProcessing. Если не processContents
        ///     атрибут указан, значение по умолчанию — Strict.
        /// [DefaultValue(XmlSchemaContentProcessing.None)]
        /// [XmlAttribute("processContents")]
    function ProcessContents(): Integer; safecall; //XmlSchemaContentProcessing
  end;

 IXmlSchemaComplexType = interface
 //  IXmlSchemaType IXmlSchemaAnnotated IXmlSchemaObject
 ['{C54F1BA1-804E-4617-B57D-F003702632B6}']
  function IsAbstract(): Boolean; safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает block атрибута.
  ///
  /// Возврат:
  ///     block Атрибут для предотвращения сложного типа в указанном типе наследования.
  ///     Значение по умолчанию — XmlSchemaDerivationMethod.None. Необязательно.
  function Block(): Integer;safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает сведения, определяющие, имеет ли сложный тип модель смешанного
  ///     содержимого (разметка в рамках содержимого).
  ///
  /// Возврат:
  ///     true, если символьные данные могут появляться между дочерними элементами данного
  ///     сложного типа; в противном случае — false. Значение по умолчанию — false. Необязательно.
  function IsMixed(): Boolean; safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает после компиляции System.Xml.Schema.XmlSchemaContentModel
  ///     этого сложного типа.
  ///
  /// Возврат:
  ///     Тип модели содержимого, который является одним из System.Xml.Schema.XmlSchemaSimpleContent
  ///     или System.Xml.Schema.XmlSchemaComplexContent классы.
  ///[XmlElement("complexContent", typeof(XmlSchemaComplexContent))]
  ///[XmlElement("simpleContent", typeof(XmlSchemaSimpleContent))]
  function SimpleContentModel(): Boolean; safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает тип компоновщика как один из System.Xml.Schema.XmlSchemaGroupRef,
  ///     System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll, или System.Xml.Schema.XmlSchemaSequence
  ///     классы.
  ///
  /// Возврат:
  ///     Тип компоновщика.
  /// [XmlElement("choice", typeof(XmlSchemaChoice))]
  /// [XmlElement("sequence", typeof(XmlSchemaSequence))]
  /// [XmlElement("group", typeof(XmlSchemaGroupRef))]
  /// [XmlElement("all", typeof(XmlSchemaAll))]
//  function Particle(): IXmlSchemaParticle; safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает значение для System.Xml.Schema.XmlSchemaAnyAttribute компонент
  ///     сложного типа.
  ///
  /// Возврат:
  ///     System.Xml.Schema.XmlSchemaAnyAttribute Компонент сложного типа.
  ///[XmlElement("anyAttribute")]
  ///public XmlSchemaAnyAttribute AnyAttribute { get; set; }

  ///
  /// Сводка:
  ///     Возвращает модель содержимого сложного типа, которая содержит значение после
  ///     компиляции.
  ///
  /// Возврат:
  ///     Значение модели содержимого для сложного типа после компиляции.
  function  ContentType():TXmlSchemaContentType; safecall; //XmlSchemaContentType
  ///
  /// Сводка:
  ///     Возвращает фрагмент, который содержит значение после компиляции для System.Xml.Schema.XmlSchemaComplexType.ContentType
  ///     примитивов.
  ///
  /// Возврат:
  ///     Примитив для типа содержимого. Значение после компиляции System.Xml.Schema.XmlSchemaComplexType.ContentType
  ///     примитивов.
  function ContentTypeParticle(): IXmlSchemaParticle; safecall;
  ///
  /// Сводка:
  ///     Возвращает значение после компиляции типа в информационный набор после проверки
  ///     схемы. Это значение указывает, каким образом обеспечивается соответствие типов
  ///     при xsi:type используется в экземпляре документа.
  ///
  /// Возврат:
  ///     Значение информационного набора после проверки схемы. Значение по умолчанию —
  ///     BlockDefault значение на schema элемент.
  function BlockResolved():TXmlSchemaDerivationMethod; safecall; // XmlSchemaDerivationMethod;
  ///
  /// Сводка:
  ///     Возвращает коллекцию всех соответствующих атрибутов данного сложного типа и его
  ///     базовых типов.
  ///
  /// Возврат:
  ///     Коллекция всех атрибутов из данного сложного типа и его базовых типов. Значение
  ///     после компиляции AttributeUses свойство.
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
        /// Сводка:
        ///     Gets or sets the type of the element. This can either be a complex type or a
        ///     simple type.
        ///
        /// Возврат:
        ///     The type of the element.
        ///[XmlElement("complexType", typeof(XmlSchemaComplexType))]
        ///[XmlElement("simpleType", typeof(XmlSchemaSimpleType))]
//   function SchemaType(): IXmlSchemaType; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the reference name of an element declared in this schema (or another
        ///     schema indicated by the specified namespace).
        ///
        /// Возврат:
        ///     The reference name of the element.
        ///[XmlAttribute("ref")]
   function RefName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets the actual qualified name for the given element.
        ///
        /// Возврат:
        ///     The qualified name of the element. The post-compilation value of the QualifiedName
        ///     property.
        /// [XmlIgnore]
   function QualifiedName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the name of the element.
        ///
        /// Возврат:
        ///     The name of the element. The default is String.Empty.
        ///[DefaultValue("")]
        ///[XmlAttribute("name")]
   function Name():PChar; safecall;
        ///
        /// Сводка:
        ///     Gets or sets information that indicates if xsi:nil can occur in the instance
        ///     data. Indicates if an explicit nil value can be assigned to the element.
        ///
        /// Возврат:
        ///     If nillable is true, this enables an instance of the element to have the nil
        ///     attribute set to true. The nil attribute is defined as part of the XML Schema
        ///     namespace for instances. The default is false. Optional.
        ///[DefaultValue(false)]
        ///[XmlAttribute("nillable")]
   function IsNillable(): Boolean; safecall;
        ///
        /// Сводка:
        ///     Gets or sets information to indicate if the element can be used in an instance
        ///     document.
        ///
        /// Возврат:
        ///     If true, the element cannot appear in the instance document. The default is false.
        ///     Optional.
        ///[DefaultValue(false)]
        ///[XmlAttribute("abstract")]
   function IsAbstract(): Boolean; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the form for the element.
        ///
        /// Возврат:
        ///     The form for the element. The default is the System.Xml.Schema.XmlSchema.ElementFormDefault
        ///     value. Optional.
        ///[DefaultValue(XmlSchemaForm.None)]
        ///[XmlAttribute("form")]
   function Form():TXmlSchemaForm; safecall; //XmlSchemaForm
        ///
        /// Сводка:
        ///     Gets or sets the name of a built-in data type defined in this schema or another
        ///     schema indicated by the specified namespace.
        ///
        /// Возврат:
        ///     The name of the built-in data type.
        /// [XmlAttribute("type")]
   function SchemaTypeName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the fixed value.
        ///
        /// Возврат:
        ///     The fixed value that is predetermined and unchangeable. The default is a null
        ///     reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("fixed")]
   function FixedValue(): PChar; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the Final property to indicate that no further derivations are allowed.
        ///
        /// Возврат:
        ///     The Final property. The default is XmlSchemaDerivationMethod.None. Optional.
        ///[DefaultValue(XmlSchemaDerivationMethod.None)]
        ///[XmlAttribute("final")]
   function Final():TXmlSchemaDerivationMethod; safecall; //XmlSchemaDerivationMethod
        ///
        /// Сводка:
        ///     Gets an System.Xml.Schema.XmlSchemaType object representing the type of the element
        ///     based on the System.Xml.Schema.XmlSchemaElement.SchemaType or
        /// System.Xml.Schema.XmlSchemaElement.SchemaTypeName
        ///     values of the element.
        ///
        /// Возврат:
        ///     An System.Xml.Schema.XmlSchemaType object.
   function ElementSchemaType(): IXmlSchemaType; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the default value of the element if its content is a simple type
        ///     or content of the element is textOnly.
        ///
        /// Возврат:
        ///     The default value for the element. The default is a null reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("default")]
   function DefaultValue(): PChar; safecall;
        ///
        /// Сводка:
        ///     Gets the collection of constraints on the element.
        ///
        /// Возврат:
        ///     The collection of constraints.
        ///[XmlElement("key", typeof(XmlSchemaKey))]
        ///[XmlElement("keyref", typeof(XmlSchemaKeyref))]
        ///[XmlElement("unique", typeof(XmlSchemaUnique))]
        ///public XmlSchemaObjectCollection Constraints { get; }
        ///
        /// Сводка:
        ///     Gets the post-compilation value of the Block property.
        ///
        /// Возврат:
        ///     The post-compilation value of the Block property. The default is the BlockDefault
        ///     value on the schema element.
   function BlockResolved(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// Сводка:
        ///     Gets or sets a Block derivation.
        ///
        /// Возврат:
        ///     The attribute used to block a type derivation. Default value is XmlSchemaDerivationMethod.None.
        ///     Optional.
        ///[DefaultValue(XmlSchemaDerivationMethod.None)]
        ///[XmlAttribute("block")]
   function Block(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// Сводка:
        ///     Gets the post-compilation value of the Final property.
        ///
        /// Возврат:
        ///     The post-compilation value of the Final property. Default value is the FinalDefault
        ///     value on the schema element.
        /// [XmlIgnore]
   function FinalResolved(): TXmlSchemaDerivationMethod; safecall;// XmlSchemaDerivationMethod
        ///
        /// Сводка:
        ///     Gets or sets the name of an element that is being substituted by this element.
        ///
        /// Возврат:
        ///     The qualified name of an element that is being substituted by this element. Optional.
        /// [XmlAttribute("substitutionGroup")]
   function SubstitutionGroup(): IXmlQualifiedName; safecall;
 end;

 IXmlSchemaAttribute = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{CD35A56F-09F2-4071-B739-2C115DB7D58F}']
        ///
        /// Сводка:
        ///     Gets an System.Xml.Schema.XmlSchemaSimpleType object representing the type of
        ///     the attribute based on the System.Xml.Schema.XmlSchemaAttribute.SchemaType or
        ///     System.Xml.Schema.XmlSchemaAttribute.SchemaTypeName of the attribute.
        ///
        /// Возврат:
        ///     An System.Xml.Schema.XmlSchemaSimpleType object.
   function AttributeSchemaType: IXmlSchemaSimpleType; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the default value for the attribute.
        ///
        /// Возврат:
        ///     The default value for the attribute. The default is a null reference. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("default")]
   function DefaultValue(): PChar; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the fixed value for the attribute.
        ///
        /// Возврат:
        ///     The fixed value for the attribute. The default is null. Optional.
        ///[DefaultValue(null)]
        ///[XmlAttribute("fixed")]
   function FixedValue(): PChar; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the form for the attribute.
        ///
        /// Возврат:
        ///     One of the System.Xml.Schema.XmlSchemaForm values. The default is the value of
        ///     the System.Xml.Schema.XmlSchema.AttributeFormDefault of the schema element containing
        ///     the attribute. Optional.
        ///[DefaultValue(XmlSchemaForm.None)]
        ///[XmlAttribute("form")]
   function  Form(): TXmlSchemaForm; safecall; //XmlSchemaForm
        ///
        /// Сводка:
        ///     Gets or sets the name of the attribute.
        ///
        /// Возврат:
        ///     The name of the attribute.
        ///[XmlAttribute("name")]
   function Name(): PChar; safecall;
        ///
        /// Сводка:
        ///     Gets the qualified name for the attribute.
        ///
        /// Возврат:
        ///     The post-compilation value of the QualifiedName property.
   function QualifiedName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the name of an attribute declared in this schema (or another schema
        ///     indicated by the specified namespace).
        ///
        /// Возврат:
        ///     The name of the attribute declared.
        ///[XmlAttribute("ref")]
   function RefName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the attribute type to a simple type.
        ///
        /// Возврат:
        ///     The simple type defined in this schema.
        ///[XmlElement("simpleType")]
   function SchemaType: IXmlSchemaSimpleType; safecall;
        ///
        /// Сводка:
        ///     Gets or sets the name of the simple type defined in this schema (or another schema
        ///     indicated by the specified namespace).
        ///
        /// Возврат:
        ///     The name of the simple type.
        ///[XmlAttribute("type")]
   function SchemaTypeName(): IXmlQualifiedName; safecall;
        ///
        /// Сводка:
        ///     Gets or sets information about how the attribute is used.
        ///
        /// Возврат:
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
        /// Сводка:
        ///     Возвращает универсальный код ресурса (URI) для пространства имен по умолчанию.
        ///
        /// Возврат:
        ///     Возвращает URI для пространства имен по умолчанию или String.Empty, если пространство
        ///     имен по умолчанию отсутствует.
   function DefaultNamespace():PChar; safecall;
        ///
        /// Сводка:
        ///     Возвращает значение, указывающее, определено ли пространство имен для указанного
        ///     префикса в текущей области видимости, занесенной в стек.
        ///
        /// Параметры:
        ///   prefix:
        ///     Префикс пространства имен, которое требуется найти.
        ///
        /// Возврат:
        ///     trueЕсли имеется определенное пространство имен; в противном случае false.
   function HasNamespace(prefix: PChar): Boolean; safecall;
        ///
        /// Сводка:
        ///     Возвращает URI пространства имен для указанного префикса.
        ///
        /// Параметры:
        ///   prefix:
        ///     Префикс, для которого требуется разрешить URI пространства имен. Чтобы сопоставить
        ///     пространство имен по умолчанию, необходимо передать String.Empty.
        ///
        /// Возврат:
        ///     Возвращает URI пространства имен для prefix или null Если соответствующее пространство
        ///     имен отсутствует. Возвращаемая строка является атомизированной. Дополнительные
        ///     сведения о разъединенных строках см. в разделе System.Xml.XmlNameTable класса.
  function LookupNamespace(prefix: PChar):PChar; safecall;
        ///
        /// Сводка:
        ///     Находит префикс, объявленный для заданного URI пространства имен.
        ///
        /// Параметры:
        ///   uri:
        ///     Пространство имен, чтобы разрешить для получения префикса.
        ///
        /// Возврат:
        ///     Соответствующий префикс. Если нет сопоставленного префикса, данный метод возвращает
        ///     String.Empty. Если указано значение null, затем null возвращается.
  function LookupPrefix(uri: PChar):PChar; safecall;
 end;

 IXmlSchemaSet = interface
  ['{CEAD7A91-2DAC-44E1-8425-F32E1A23DCE3}']
  function Namespace(): IXmlNamespaceManager; safecall;
        ///
        /// Сводка:
        ///     Получает все глобальные атрибуты в определении схемы XML схем языка XSD в System.Xml.Schema.XmlSchemaSet.
        ///
        /// Возврат:
        ///     Коллекция глобальных атрибутов.
  function GlobalAttributes(): IXmlSchemaObjectTable; safecall;
        ///
        /// Сводка:
        ///     Получает все глобальные элементы в определении схемы XML схем языка XSD в System.Xml.Schema.XmlSchemaSet.
        ///
        /// Возврат:
        ///     Коллекция глобальных элементов.
  function GlobalElements(): IXmlSchemaObjectTable; safecall;
        ///
        /// Сводка:
        ///     Получает все глобальные простые и сложные типы в определении схемы XML схем языка
        ///     XSD в System.Xml.Schema.XmlSchemaSet.
        ///
        /// Возврат:
        ///     Коллекция глобальных простых и сложных типов.
  function GlobalTypes(): IXmlSchemaObjectTable; safecall;
  procedure Add(nameSpase, FileName: PChar); safecall;
  procedure Compile(); safecall;
        ///
        /// Сводка:
        ///     Возвращает значение, указывающее, является ли схемами языка определения схемы
        ///     XML в System.Xml.Schema.XmlSchemaSet были скомпилированы.
        ///
        /// Возврат:
        ///     true Если схемы в System.Xml.Schema.XmlSchemaSet были скомпилированы с момента
        ///     последнего схемы был добавлен или удален из System.Xml.Schema.XmlSchemaSet; в
        ///     противном случае — false.
  function IsCompiled(): Boolean; safecall;
        ///
        /// Сводка:
        ///     Указывает обработчик событий, получающий сведения об ошибках проверки схем языка
        ///     определения схем XML (XSD).
  procedure AddValidationEventHandler(v: IXMLValidatorCallBack); safecall;
        ///
        /// Сводка:
        ///     Повторная обработка схему языка XSD определения схемы XML, который уже существует
        ///     в System.Xml.Schema.XmlSchemaSet.
        ///
        /// Параметры:
        ///   schema:
        ///     Схема, которую необходимо обработать повторно.
        ///
        /// Возврат:
        ///     System.Xml.Schema.XmlSchema Объекта, если схема является допустимой схемой. Если
        ///     схема не является допустимым и System.Xml.Schema.ValidationEventHandler указан,
        ///     null возвращается и возникает соответствующее событие проверки. В противном случае
        ///     — System.Xml.Schema.XmlSchemaException возникает исключение.
        ///
        /// Исключения:
        ///   T:System.Xml.Schema.XmlSchemaException:
        ///     Недопустимая схема.
        ///
        ///   T:System.ArgumentNullException:
        ///     System.Xml.Schema.XmlSchema Объект, передаваемый как параметр — null.
        ///
        ///   T:System.ArgumentException:
        ///     System.Xml.Schema.XmlSchema Объект, передаваемый как параметр еще не существует
        ///     в System.Xml.Schema.XmlSchemaSet.
  function Reprocess(schema: IXmlSchema): IXmlSchema; safecall;
        ///
        /// Сводка:
        ///     Возвращает коллекцию всех определения схемы XML схем языка XSD в System.Xml.Schema.XmlSchemaSet.
        ///
        /// Возврат:
        ///     System.Collections.ICollection Объект, содержащий все схемы, которые были добавлены
        ///     в System.Xml.Schema.XmlSchemaSet. Если схемы не были добавлены в System.Xml.Schema.XmlSchemaSet,
        ///     пустой System.Collections.ICollection возвращается объект.
  function Schemas(): IXMLEnumerable; safecall; overload;
        ///
        /// Сводка:
        ///     Возвращает коллекцию всех определения схемы XML схем языка XSD в System.Xml.Schema.XmlSchemaSet
        ///     относящихся к данному пространству имен.
        ///
        /// Параметры:
        ///   targetNamespace:
        ///     Схема targetNamespace свойство.
        ///
        /// Возврат:
        ///     System.Collections.ICollection Объект, содержащий все схемы, которые были добавлены
        ///     в System.Xml.Schema.XmlSchemaSet относящихся к данному пространству имен. Если
        ///     схемы не были добавлены в System.Xml.Schema.XmlSchemaSet, пустой System.Collections.ICollection
        ///     возвращается объект.
  function Schemas(targetNamespace: PChar): IXMLEnumerable; safecall; overload;
  procedure Validate(FileName: PChar); safecall;
 end;

 IXmlSchemaGroup = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{D969D90F-16C4-4463-848B-1E8B255286B2}']
         ///
        /// Сводка:
        ///     Возвращает или задает имя группы схем.
        ///
        /// Возврат:
        ///     Имя группы схем.
        /// [XmlAttribute("name")]
   function Name(): PChar; safecall;
        ///
        /// Сводка:
        ///     Возвращает или задает один из System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll,
        ///     или System.Xml.Schema.XmlSchemaSequence классы.
        ///
        /// Возврат:
        ///     Один из System.Xml.Schema.XmlSchemaChoice, System.Xml.Schema.XmlSchemaAll, или
        ///     System.Xml.Schema.XmlSchemaSequence классы.
        ///[XmlElement("sequence", typeof(XmlSchemaSequence))]
        ///[XmlElement("choice", typeof(XmlSchemaChoice))]
        ///[XmlElement("all", typeof(XmlSchemaAll))]
   function Particle(): IXmlSchemaParticle; safecall;
        ///
        /// Сводка:
        ///     Возвращает полное имя группы схем.
        ///
        /// Возврат:
        ///     System.Xml.XmlQualifiedName Объект, представляющий полное имя группы схем.
        ///[XmlIgnore]
   function QualifiedName(): IXmlQualifiedName; safecall;
end;

 IXmlSchemaAttributeGroup = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{1E47DBD5-7750-4B49-A8FE-980BD5683D9F}']
    ///
    /// Сводка:
    ///     Возвращает или задает имя группы атрибутов.
    ///
    /// Возврат:
    ///     Имя группы атрибутов.
    ///[XmlAttribute("name")]
    function Name(): PChar; safecall;
    ///
    /// Сводка:
    ///     Возвращает коллекцию атрибутов для группы атрибутов. Содержит XmlSchemaAttribute
    ///     и XmlSchemaAttributeGroupRef элементы.
    ///
    /// Возврат:
    ///     Коллекция атрибутов для группы атрибутов.
    ///[XmlElement("attributeGroup", typeof(XmlSchemaAttributeGroupRef))]
    ///[XmlElement("attribute", typeof(XmlSchemaAttribute))]
    function Attributes(): IXmlSchemaObjectCollection; safecall;
    ///
    /// Сводка:
    ///     Возвращает или задает System.Xml.Schema.XmlSchemaAnyAttribute компонент группы
    ///     атрибутов.
    ///
    /// Возврат:
    ///     World Wide Web Consortium (W3C) anyAttribute элемента.
    ///[XmlElement("anyAttribute")]
    /// public XmlSchemaAnyAttribute AnyAttribute { get; set; }
    ///
    /// Сводка:
    ///     Возвращает полное имя группы атрибутов.
    ///
    /// Возврат:
    ///     Полное имя группы атрибутов.
    ///[XmlIgnore]
    function QualifiedName(): IXmlQualifiedName; safecall;
    ///
    /// Сводка:
    ///     Возвращает переопределенное свойство группы атрибутов из схемы XML.
    ///
    /// Возврат:
    ///     Переопределенное свойство группы атрибутов.
    ///[XmlIgnore]
    function RedefinedAttributeGroup(): IXmlSchemaAttributeGroup; safecall;
 end;

 IXmlSchemaNotation = interface
  // IXmlSchemaAnnotated IXmlSchemaObject
 ['{04599C1A-F064-4661-90C4-326264600E79}']
    ///
    /// Сводка:
    ///     Возвращает или задает имя нотации.
    ///
    /// Возврат:
    ///     Имя нотации.
    ///[XmlAttribute("name")]
    function Name(): PChar; safecall;
    ///
    /// Сводка:
    ///     Возвращает или задает public идентификатор.
    ///
    /// Возврат:
    ///     public Идентификатор. Значение должно быть действительным идентификатором URI.
    ///[XmlAttribute("public")]
    function Public(): PChar; safecall;
    ///
    /// Сводка:
    ///     Возвращает или задает system идентификатор.
    ///
    /// Возврат:
    ///     system Идентификатор. Значение должно быть действительным универсальным кодом
    ///     ресурса (URI).
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
    /// Сводка:
    ///     Возвращает или задает расположение универсальный код ресурса (URI) для схемы,
    ///     сообщающий процессору схемы, где физическое расположение.
    ///
    /// Возврат:
    ///     Расположение URI для схемы. Необязательно для импортированной схемы.
    ///[XmlAttribute("schemaLocation", DataType = "anyURI")]
    function SchemaLocation(): PChar; safecall;
    ///
    /// Сводка:
    ///     Возвращает или задает XmlSchema для указанной схемы.
    ///
    /// Возврат:
    ///     XmlSchema Для указанной схемы.
    /// [XmlIgnore]
    function Schema(): IXmlSchema; safecall;
    ///
    /// Сводка:
    ///     Возвращает или задает идентификатор строки.
    ///
    /// Возврат:
    ///     Идентификатор строки. Значение по умолчанию — String.Empty. Необязательно.
    /// [XmlAttribute("id", DataType = "ID")]
    function Id(): PChar; safecall;
 end;

 IXmlSchemaImport = interface
 // IXmlSchemaExternal IXmlSchemaObject
 ['{12AF0716-D648-42EC-8921-4A88FA2B0300}']
  /// Сводка:
  ///     Возвращает или задает целевое пространство имен для импортированной схемы в виде
  ///     ссылки URI.
  ///
  /// Возврат:
  ///     Целевое пространство имен для импортированной схемы в виде ссылки URI. Необязательно.
  /// [XmlAttribute("namespace", DataType = "anyURI")]
  function Namespace(): PChar; safecall;
  ///
  /// Сводка:
  ///     Возвращает или задает свойство annotation.
  ///
  /// Возврат:
  ///     Примечание.
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
