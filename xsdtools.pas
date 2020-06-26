unit xsdtools;

interface

uses SysUtils, System.typinfo, Xml.XMLSchemaTags, XmlSchema,Xml.XMLIntf, Xml.XMLDoc, System.Variants;

 type
  baseXSD = (
{ Built-in Data Types (Primitive) }
    btString,
    btBoolean,
    btDecimal,
    btFloat,
    btDouble,
    btDuration,
    btDateTime,
    btTime,
    btDate,
    btGYearMonth,
    btGYear,
    btGMonthDay,
    btGDay,
    btGMonth,
    btHexBinary,
    btBase64Binary,
    btAnyUri,
    btQName,
    btNOTATION,

{ Built-in Data Types (Derived) }

    btNormalizedString,
    btToken,
    btLanguage,
    btIDREFS,
    btENTITIES,
    btNMTOKEN,
    btNMTOKENS,
    btName,
    btNCName,
    btID,
    btIDREF,
    btENTITY,
    btInteger,
    btNonPositiveInteger,
    btNegativeInteger,
    btLong,
    btInt,
    btShort,
    btByte,
    btNonNegativeInteger,
    btUnsignedLong,
    btUnsignedInt,
    btUnsignedShort,
    btUnsignedByte,
    btPositiveInteger,

{ Legacy Built-in Data Types (pre 2001) }

    btTimeDuration,             { duration }
    btBinary,                   { hexBinary }
    btUriReference,             { anyURI }
    btTimeInstant,              { dateTime }
    btRecurringDate,            { gMonthDay }
    btRecurringDay,             { gDay }
    btMonth,                    { gMonth }
    btYear,                     { gYear }
    btTimePeriod,               { removed }
    btRecurringDuration,        { removed }
    btCentury);                 { removed }

const
  XSDTimeData = [btDuration,
    btDateTime,
    btTime,
    btDate,
    btGYearMonth,
    btGYear,
    btGMonthDay,
    btGDay,
    btGMonth,

    btTimeDuration,             { duration }
    btTimeInstant,              { dateTime }
    btRecurringDate,            { gMonthDay }
    btRecurringDay,             { gDay }
    btMonth,                    { gMonth }
    btYear,                     { gYear }
    btTimePeriod,               { removed }
    btRecurringDuration,        { removed }
    btCentury];

  XSDTypeDecinal = [btDecimal, // base
    btInteger, // from btDecimal base
    btNonPositiveInteger,
    btNegativeInteger,
    btLong,
    btInt,
    btShort,
    btByte,
    btNonNegativeInteger,
    btUnsignedLong,
    btUnsignedInt,
    btUnsignedShort,
    btUnsignedByte,
    btPositiveInteger];

  XSDTypeString = [
    btString, //bsse
    btNormalizedString,
    btToken,
    btLanguage,
    btIDREFS,
    btENTITIES,
    btNMTOKEN,
    btNMTOKENS,
    btName,
    btNCName,
    btID,
    btIDREF,
    btENTITY];

  XSDTypeMisc = [
    btBoolean,  // boolean
    btFloat,    //single
    btDouble,   //Double
    btHexBinary,    //string
    btBase64Binary, //string
    btAnyUri,    //string
    btQName,     //string
    btNOTATION,  //string attributes only

    btBinary,          { hexBinary }
    btUriReference     { anyURI } ];

  baseXSDstring: array [baseXSD] of string = (xsdString, xsdBoolean,
    xsdDecimal, xsdFloat, xsdDouble, xsdDuration, xsdDateTime, xsdTime,
    xsdDate, xsdGYearMonth, xsdGYear, xsdGMonthDay, xsdGDay, xsdGMonth,
    xsdHexBinary, xsdBase64Binary, xsdAnyUri, xsdQName, xsdNOTATION,
    xsdNormalizedString, xsdToken, xsdLanguage, xsdIDREFS, xsdENTITIES,
    xsdNMTOKEN, xsdNMTOKENS, xsdName, xsdNCName, xsdID, xsdIDREF, xsdENTITY,
    xsdInteger, xsdNonPositiveInteger, xsdNegativeInteger, xsdLong, xsdInt,
    xsdShort, xsdByte, xsdNonNegativeInteger, xsdUnsignedLong, xsdUnsignedInt,
    xsdUnsignedShort, xsdUnsignedByte, xsdPositiveInteger,xsdTimeDuration, xsdBinary,
    xsdUriReference, xsdTimeInstant, xsdRecurringDate, xsdRecurringDay, xsdMonth,
    xsdYear, xsdTimePeriod, xsdRecurringDuration, xsdCentury);

const
 SCM: array[TContentModel] of string = ('cmALL',  // support As cmSequence
 'cmChoice',  { TODO : need }
 'cmSequence', // support
 'cmGroupRef', // full support !!!
 'cmEmpty'); // support dmSimpleExtension
 SCT: array[TCompositorType] of string = ('ctAll', 'ctChoice', 'ctSequence');
 SDM: array[TDerivationMethod] of string = (
 'dmNone', // нет базового типа
 'dmComplexExtension', // наследование от базового типа
 'dmComplexRestriction', // ????  базового типа
 'dmSimpleExtension',  // добавление атрибутов к простому типу базового типа
 'dmSimpleRestriction'); // ограничение + добавление атрибутов к простому типу базового типа

 SSDM: array[TSimpleDerivationMethod] of string =  ('sdmNone', 'sdmRestriction', 'sdmList', 'sdmUnion');
 ST_IS_BUILD: array [Boolean] of string = ('D','IB');

 COMPLEX_ROOT_ELEMENT = [dmNone, dmComplexExtension, dmComplexRestriction];
 COMPLEX_SIMPLE_ELEMENT = [dmSimpleExtension, dmSimpleRestriction];

//----------------------------------------------------------------------------------------------------------------------

type
 TSimpleHistory = record
   SimpleType: IXMLSimpleTypeDef;
   BaseArray: TArray<TSimpleHistory>;
 end;
 TComplexHistory = TArray<IXMLComplexTypeDef>;
// Has Value
 THistory = record
   ComplexTypes: TComplexHistory;
   BaseSimple: TSimpleHistory;
 end;

function GetAnnotation(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False; const IgnoreItems: TArray<string> = []): string;
function GetUnionSimpleTypes(u: IXMLSimpleTypeUnion): TArray<IXMLSimpleTypeDef>;
// история наследования типов
function PatchGetBaseType(Tip: IXMLTypeDef): IXMLTypeDef;
function HistorySimple(SimpleType: IXMLSimpleTypeDef): TSimpleHistory;
function HistoryComplex(ComplexType: IXMLTypeDef): TComplexHistory;
function HistoryHasValue(SimpleType: IXMLTypeDef): THistory;
type
  TWolkHistorySimpleFunc = reference to function (Simple: IXMLSimpleTypeDef): Boolean;
procedure WolkHistorySimple(Root: TSimpleHistory; func: TWolkHistorySimpleFunc);
// энумерация с документацией элементов
// SimpleType - простой элемнт или комплексн. простой
procedure PatchAnnotatedEnumeration(SimpleType: IXMLTypeDef);
function TypeHasValue(e: IXMLTypeDef): Boolean;
// поиск потомков абстрастного класса
function FindAbstractChilds(AbstractType: IXMLComplexTypeDef):TArray<IXMLComplexTypeDef>;

function GetGlobalName(Schema: IXMLSchemaDef; const LocalName: string): string;
function IsRepeatingValue(elem: IXMLElementCompositor): Boolean;overload;
function IsRepeatingValue(elem: IXMLElementDef): Boolean;overload;
//function CloneElement(elemToClone: IXMLElementDef): IXMLElementDef;

type
  TXSEnum<T: IXMLSchemaNode> = record
  private
    i: Integer;
    FRoot: IXMLNodeCollection;
    Fguid: TGUID;
    function DoGetCurrent: T;
  public
    property Current: T read DoGetCurrent;
    function MoveNext: Boolean;
    function GetEnumerator: TXSEnum<T>;
    class function XEnum(ANode: IXMLNodeCollection): TXSEnum<T>;static;
  end;

  TXMLAnnotatedEnumeration = class(TXMLSchemaItem, IXMLEnumeration)
  protected
    { IXMLEnumeration interface }
    function GetValue: Variant;
    procedure SetValue(const Value: Variant);
  end;

implementation

{$REGION 'TXMLSchemaEnumerator<T>'}
{ TXMLSchemaEnumerator<T> }

function TXSEnum<T>.DoGetCurrent: T;
begin
 if not Supports(FRoot[i], Fguid, Result) then raise Exception.Create('Error Message not Supports(FRoot[i], Fguid, Result)');
end;

function TXSEnum<T>.GetEnumerator: TXSEnum<T>;
begin
  Result := Self;
end;

function TXSEnum<T>.MoveNext: Boolean;
begin
  Inc(i);
  Result := i < FRoot.Count;
end;

class function TXSEnum<T>.XEnum(ANode: IXMLNodeCollection): TXSEnum<T>;
begin
  Result.Fguid := GetTypeData(TypeInfo(T)).GUID;
  Result.i := -1;
  Result.FRoot := ANode;
end;
{$ENDREGION XENUM}


function TXMLAnnotatedEnumeration.GetValue: Variant;
begin
  Result := GetAttribute(SValue);
end;

procedure TXMLAnnotatedEnumeration.SetValue(const Value: Variant);
begin
  SetAttribute(SValue, Value);
end;

function IsRepeatingValue(elem: IXMLElementCompositor): Boolean;overload;
var
  S: string;
begin
  S := VarToStr(elem.MaxOccurs);
  Result := not ((S = '0') or (S = '1'));
end;

function IsRepeatingValue(elem: IXMLElementDef): Boolean;overload;
var
  S: string;
begin
  S := VarToStr(elem.MaxOccurs);
  Result := not ((S = '0') or (S = '1'));
end;

//function CloneElement(elemToClone: IXMLElementDef): IXMLElementDef;
//begin
//  var parent := elemToClone.ParentNode;
//  var i := parent.ChildNodes.IndexOf(elemToClone);
//  Result := elemToClone.CloneNode(True) as IXMLElementDef;
//  parent.ChildNodes.Insert(i, Result);
//end;

function GetGlobalName(Schema: IXMLSchemaDef; const LocalName: string): string;
begin
  Result := Schema.FindNamespaceDecl(Schema.TargetNamespace).LocalName + ':' + LocalName.Trim;
end;

function FindAbstractChilds(AbstractType: IXMLComplexTypeDef):TArray<IXMLComplexTypeDef>;
begin
  SetLength(Result, 0);
  for var e in TXSEnum<IXMLComplexTypeDef>.XEnum(AbstractType.SchemaDef.ComplexTypes) do
   begin
    var bt := e.BaseType;
    while Assigned(bt) and (bt.Name <> AbstractType.Name) do bt := bt.BaseType;
    if Assigned(bt) then Result := Result + [e];
   end;
end;

function TypeHasValue(e: IXMLTypeDef): Boolean;
begin
  Result := not (e.IsComplex and ((e as IXMLComplexTypeDef).DerivationMethod in COMPLEX_ROOT_ELEMENT))
end;

procedure WolkHistorySimple(Root: TSimpleHistory; func: TWolkHistorySimpleFunc);
 function Recur(r: TSimpleHistory): Boolean;
 begin
   Result := False;
   if func(r.SimpleType) then Exit(True);
   for var bt in r.BaseArray do if Recur(bt) then Exit(True);
 end;
begin
  Recur(Root);
end;

function PatchAnnotatedEnumerationItem(st: IXMLSimpleTypeDef): boolean;
 var
  str: IXMLSimpleTypeRestriction;
begin
  Result := False;
  if Supports(st.ContentNode, IXMLSimpleTypeRestriction, str) then
    (str as IXMLNodeAccess).RegisterChildNode(xsfEnumeration, TXMLAnnotatedEnumeration);
end;

procedure PatchAnnotatedEnumeration(SimpleType: IXMLTypeDef);
begin
  WolkHistorySimple(HistoryHasValue(SimpleType).BaseSimple, PatchAnnotatedEnumerationItem);
end;

function GetAnnotation(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False; const IgnoreItems: TArray<string> = []): string;
 var
  Et : IXMLTypedSchemaItem;
  Eg: IXMLElementGroup;
  function GetDocumentationText(const Documentation: IXMLDocumentation): String;
  var
    Child: IXMLNode;
    I: Integer;
  begin
    if Documentation.IsTextElement then
      Result := Documentation.Text
    else
    begin
      for I := 0 to Documentation.ChildNodes.Count - 1 do
      begin
        Child := Documentation.ChildNodes[I];
        if Child.NodeType = ntText then
          Result := Result + Child.Text
      end;
    end;
  end;
  function GetDocumentation(SchemaItem: IXMLAnnotatedItem; AllEntries: Boolean = True): string;
  var
    I: Integer;
  begin
    Result := '';
    if SchemaItem.HasAnnotation then
      for I := 0 to SchemaItem.Documentation.Count - 1 do
      begin
        Result := Result + GetDocumentationText(SchemaItem.Documentation[I]);
        if not AllEntries then Break;
      end;
  end;
  function IsIgnore(ann: IXMLAnnotatedItem): Boolean;
   var
    item: IXMLSchemaItem;
  begin
    if Supports(ann, IXMLSchemaItem, item) then
      for var s in IgnoreItems do if SameStr(item.Name, s) then Exit(True);
    Result := False;
  end;
begin
  Result := '';
  if e.HasAnnotation and not IsIgnore(e) then
    Result := {e.Name +': '+} GetDocumentation(e)+ #$D+#$A+' '+ #$D+#$A+' ';

  if Supports(e, IXMLTypedSchemaItem, et) then
   begin
    var Dt := Et.DataType;
    while Assigned(Dt) do
     begin
      if dt.HasAnnotation and not IsIgnore(dt) then
        Result := Result +Dt.Name+': '+GetDocumentation(dt)+ #$D+#$A+' '+ #$D+#$A+' ';
      if ParentTypeAnnotation then Dt := Dt.BaseType else Dt := nil;
     end;
   end
   else if Supports(e, IXMLElementGroup, eg) then
    begin
     if  Eg.Ref.HasAnnotation then
       Result := Eg.Ref.Name +': '+ GetDocumentation(Eg.Ref)+ #$D+#$A+' '+ #$D+#$A+' ';
    end;
   Result := Result.Trim();
end;

function GetUnionSimpleTypes(u: IXMLSimpleTypeUnion): TArray<IXMLSimpleTypeDef>;
begin
  SetLength(Result, 0);
  (u as IXMLNodeAccess).RegisterChildNode(SSimpleType, TXMLSimpleTypeDef);
  var a := u.MemberTypes.Split([' '], TStringSplitOptions.ExcludeEmpty);
  if Length(a) = 0 then
   begin
    if u.SimpleTypes.Count = 0 then raise Exception.Create('Error Message : u.SimpleTypes.Count = 0 !!!');
    for var I in TXSEnum<IXMLSimpleTypeDef>.XEnum(u.SimpleTypes) do Result := [I] + Result;
   end
  else for var s in a  do
   begin
    var st := u.SchemaDef.SimpleTypes.Find(s);
    if not Assigned(st) then raise Exception.CreateFmt('Error Message cant find %s',[s]);
    Result := [st] + Result;
   end;
end;

function HistorySimple(SimpleType: IXMLSimpleTypeDef): TSimpleHistory;
 var
  BaseSimpleType: TArray<IXMLSimpleTypeDef>;
begin
  SetLength(BaseSimpleType, 0);
  Result.SimpleType := SimpleType;
  if SimpleType.DerivationMethod = sdmUnion then
    BaseSimpleType := GetUnionSimpleTypes(SimpleType.ContentNode as IXMLSimpleTypeUnion)
  else if Assigned(SimpleType.BaseType) then
    BaseSimpleType := [SimpleType.BaseType as IXMLSimpleTypeDef];
  SetLength(Result.BaseArray, Length(BaseSimpleType));
  for var i := 0 to High(BaseSimpleType) do Result.BaseArray[i] := HistorySimple(BaseSimpleType[i]);
end;

function HistoryComplex(ComplexType: IXMLTypeDef): TComplexHistory;
begin
  SetLength(Result, 0);
  while Assigned(ComplexType) and ComplexType.IsComplex do
   begin
    Result := [ComplexType as IXMLComplexTypeDef] + Result;
    ComplexType := PatchGetBaseType(ComplexType);
   end;
  if (Length(Result) = 0) or Assigned(ComplexType) then raise Exception.Create('Error Message (Length(Result) = 0) or Assigned(ComplexType)');
end;

function HistoryHasValue(SimpleType: IXMLTypeDef): THistory;
begin
  SetLength(Result.ComplexTypes, 0);
  while SimpleType.IsComplex do
   begin
    Result.ComplexTypes := [SimpleType as IXMLComplexTypeDef] + Result.ComplexTypes;
    SimpleType := PatchGetBaseType(SimpleType);
   end;
  if not Assigned(SimpleType) then raise Exception.Create('Error Message: [HistoryHasValue] not Assigned(SimpleType)');
  Result.BaseSimple := HistorySimple(SimpleType as IXMLSimpleTypeDef);
end;

function PatchGetBaseType(Tip: IXMLTypeDef): IXMLTypeDef;
var
  BaseName: String;
begin
  Result := nil;
  if not Assigned(Tip) then Exit;
  if not Tip.IsComplex then Exit(tip.BaseType);
  var ct :=  Tip as IXMLComplexTypeDef;
  if ct.DerivationMethod in [dmSimpleRestriction, dmSimpleExtension] then
    begin
      BaseName := VarToStr((ct as TXMLComplexTypeDef).ContentNode.GetAttribute(SBase));
      if (BaseName <> '') then
       begin
        Result := ct.SchemaDef.ComplexTypes.Find(BaseName);
        if not Assigned(Result) then Result := ct.SchemaDef.SimpleTypes.Find(BaseName);
       end;
    end
  else Result := ct.BaseType;
end;

end.
