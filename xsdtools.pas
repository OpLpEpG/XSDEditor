unit xsdtools;

interface

uses SysUtils, System.typinfo, Xml.XMLSchemaTags, XmlSchema,Xml.XMLIntf, Xml.XMLDoc, Xml.xmldom,
     Winapi.MSXMLIntf, Winapi.msxml,Winapi.ActiveX, System.Win.ComObj,
     System.Variants,
     System.RegularExpressions;

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

  XSDTypeDecimal = [btDecimal, // base
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
 'cmChoice',  // support
 'cmSequence', // full support !!!
 'cmGroupRef', // full support !!!
 'cmEmpty'); // full support !!!
 SCT: array[TCompositorType] of string = ('ctAll', 'ctChoice', 'ctSequence');
 SDM: array[TDerivationMethod] of string = (
 'dmNone', // нет базового типа
 'dmComplexExtension', // наследование от базового типа
 'dmComplexRestriction', // ограничение базового типа (пример: необяз. элэм на обязат.)
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

function GetAnnotation(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False;
                       const IgnoreItems: TArray<string> = [];
                       const DocDelim: string = #$D+#$A+' '+ #$D+#$A+' '): string;
function GetAnnotationEx(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False;
                         const IgnoreItems: TArray<string> = []): TArray<string>;

function GetUnionSimpleTypes(u: IXMLSimpleTypeUnion): TArray<IXMLSimpleTypeDef>;
// история наследования типов
function PatchGetBaseType(Tip: IXMLTypeDef): IXMLTypeDef;
function HistorySimple(SimpleType: IXMLSimpleTypeDef): TSimpleHistory;
function HistoryComplex(ComplexType: IXMLTypeDef): TComplexHistory;
function HistoryHasValue(SimpleType: IXMLTypeDef): THistory;
type
  TWolkHistorySimpleFunc = reference to function (Simple: IXMLSimpleTypeDef): Boolean;
procedure WolkHistorySimple(Root: TSimpleHistory; func: TWolkHistorySimpleFunc);
function GetBuildInTypes(Hist: TSimpleHistory): TArray<baseXSD>;
// энумерация с документацией элементов
// SimpleType - простой элемнт или комплексн. простой
procedure PatchAnnotatedEnumeration(SimpleType: IXMLTypeDef);
function TypeHasValue(e: IXMLTypeDef): Boolean;
// поиск потомков абстрастного класса
function FindAbstractChilds(AbstractType: IXMLComplexTypeDef):TArray<IXMLComplexTypeDef>;

function GetGlobalName(Schema: IXMLSchemaDef; const LocalName: string): string;
function IsRepeatingValue(elem: IXMLElementCompositor): Boolean; overload;
function IsRepeatingValue(elem: IXMLElementDef): Boolean; overload;
//function CloneElement(elemToClone: IXMLElementDef): IXMLElementDef;

function ValidateData(data: IXMLTypeDef; var Value: Variant): Boolean;

procedure ValidateXMLDoc(aXmlDoc: IXMLDocument);
function ValidXML2(const xmlFile, nS, xmlSchemaFile: String; out err: IXMLDOMParseError): Boolean;


type
 TCheckError=(
    cherLength,
    cherMinLength,
    cherMaxLength,
    cherPattern,
    cherWhitespace,
    cherMaxInclusive,
    cherMaxExclusive,
    cherMinInclusive,
    cherMinExclusive,
    cherTotalDigits,
    cherFractionalDigits,
    cherEnumeration,
    cherFloat,
    cherInt);

  TValidateErrorData = record
    TypeName: string;
    CheckError: TCheckError;
    FacetData: Variant;
    FacetErrorData: Variant;
    Value: Variant;
    ErrorString: string;
  end;

const
 CHECK_ERR: array[TCheckError] of string = (
    'Length',
    'MinLength',
    'MaxLength',
    'Pattern',
    'Whitespace',
    'MaxInclusive',
    'MaxExclusive',
    'MinInclusive',
    'MinExclusive',
    'TotalDigits',
    'FractionalDigits',
    'Enumeration',
    'Float',
    'Int');

function GetValidateError: TValidateErrorData;
function SetValidateError(const TypeName: string;
                          CheckError: TCheckError;
                          FacetData: Variant;
                          FacetErrorData: Variant;
                          Value: Variant;
                          const ErrString: string): Boolean;
type TCheckUserType = function(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
function CheckUserTypes(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
procedure RegisterCheckUserType(const TypeName: string; func: TCheckUserType);
procedure RegisterCheckBuildInType(const TypeName: string; func: TCheckUserType);

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

uses WinAPI.Windows;

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

{$REGION 'ValidateData'}
 var
  LastValidateErrorData: TValidateErrorData;
function GetValidateError: TValidateErrorData;
begin
  Result := LastValidateErrorData;
end;

function SetValidateError(const TypeName: string;
                          CheckError: TCheckError;
                          FacetData: Variant;
                          FacetErrorData: Variant;
                          Value: Variant;
                          const ErrString: string): Boolean;
begin
  Result := False;
  LastValidateErrorData.TypeName :=  TypeName;
  LastValidateErrorData.CheckError := CheckError;
  LastValidateErrorData.FacetData := FacetData;
  LastValidateErrorData.FacetErrorData := FacetErrorData;
  LastValidateErrorData.Value := Value;
  LastValidateErrorData.ErrorString := ErrString;
end;

type
 TUserTypeData=record
   Name: string;
   func: TCheckUserType;
 end;

var
 GlobalUserTypeData: TArray<TUserTypeData>;
 GlobalBuildTypeData: TArray<TUserTypeData>;

procedure RegisterCheckUserType(const TypeName: string; func: TCheckUserType);
 var
  d: TUserTypeData;
begin
  for var i := 0 to High(GlobalUserTypeData) do
   if SameText(GlobalUserTypeData[i].Name, TypeName) then
    begin
     GlobalUserTypeData[i].func := func;
     Exit;
    end;
  d.Name := TypeName;
  d.func := func;
  GlobalUserTypeData := GlobalUserTypeData + [d];
end;

procedure RegisterCheckBuildInType(const TypeName: string; func: TCheckUserType);
 var
  d: TUserTypeData;
begin
  for var i := 0 to High(GlobalBuildTypeData) do
   if SameText(GlobalBuildTypeData[i].Name, TypeName) then
    begin
     GlobalBuildTypeData[i].func := func;
     Exit;
    end;
  d.Name := TypeName;
  d.func := func;
  GlobalBuildTypeData := GlobalBuildTypeData + [d];
end;

function CheckUserTypes(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  for var utd in GlobalUserTypeData do
     if SameText(utd.Name, st.Name) then
       if not utd.func(st, val) then Exit(False);
end;

function CheckBuildInTypes(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  for var utd in GlobalBuildTypeData do
     if SameText(utd.Name, st.Name) then
       if not utd.func(st, val) then Exit(False);
end;

const
  E_LENGTH    = 'error %s Length %d <> %d %s';
  E_MINLENGTH = 'error %s MinLength %d > %d %s';
  E_MAXLENGTH = 'error %s MaxLength %d < %d %s';
  E_PATTERN =   'error %s Pattern [%s] not match %s';
  E_MAXI = 'error %s MaxInclusive=%s < %s';
  E_MAXE = 'error %s MaxExclusive=%s <= %s';
  E_MINI = 'error %s MinInclusive=%s > %s';
  E_MINE = 'error %s MinExclusive=%s >= %s';
  E_ENUM = 'error %s Enumeration(%d) not have %s';
function CheckFacets(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
 var
  s, name: string;
begin
  Result := True;
  s := VarToStr(val);
  if st.IsAnonymous then name := 'anonimus' else name := st.Name;
  if not VarIsNull(st.Length) then
   begin
    if st.Length <> s.Length then
       Exit(SetValidateError(name, cherLength, st.Length, s.Length, val,
                             Format(E_LENGTH,[name, Integer(st.Length), s.Length, Val])));
   end
  else if not VarIsNull(st.MinLength) then
   begin
    if st.MinLength > s.Length then
       Exit(SetValidateError(name, cherMinLength, st.MinLength, s.Length, val,
                             Format(E_MINLENGTH,[name, Integer(st.MinLength), s.Length, Val])));
   end
  else if not VarIsNull(st.MaxLength) then
   begin
    if st.MaxLength < s.Length then
        Exit(SetValidateError(name, cherMaxLength, st.MaxLength, s.Length, val,
                              Format(E_MAXLENGTH,[name, Integer(st.MaxLength), s.Length, Val])));
   end
  else if not VarIsNull(st.Pattern) then
   begin
    if not TRegEx.Match(val, VarToStr(st.Pattern)).Success then
      Exit(SetValidateError(name, cherPattern, st.Pattern, '', val,
                            Format(E_PATTERN,[name, st.Pattern, Val])));
   end
  else if not VarIsNull(st.Whitespace) then
   begin
    if st.Whitespace = 'replace' then val := TRegEx.Replace(S, '\s', ' ')
    else if st.Whitespace = 'collapse' then val := TRegEx.Replace(S, '\s+', ' ');
   end
  else if not VarIsNull(st.MaxInclusive) then
   begin
    if st.MaxInclusive <= StrToFloat(VarToStr(val)) then
      Exit(SetValidateError(name, cherMaxInclusive, st.MaxInclusive, '', val,
                            Format(E_MAXI,[name, st.MaxInclusive, val])));
   end
  else if not VarIsNull(st.MaxExclusive) then
   begin
    if st.MaxExclusive < StrToFloat(VarToStr(val)) then
      Exit(SetValidateError(name, cherMaxExclusive, st.MaxExclusive, '', val,
                            Format(E_MAXE,[name, st.MaxExclusive, val])));
   end
  else if not VarIsNull(st.MinInclusive) then
   begin
    if st.MinInclusive >= StrToFloat(VarToStr(val)) then
      Exit(SetValidateError(name, cherMinInclusive, st.MinInclusive, '', val,
                            Format(E_MINI,[name, st.MinInclusive, val])));
   end
  else if not VarIsNull(st.MinExclusive) then
   begin
    if st.MinExclusive > StrToFloat(VarToStr(val)) then
      Exit(SetValidateError(name, cherMinExclusive, st.MinExclusive, '', val,
                            Format(E_MINE,[name, st.MinExclusive, val])));
   end
  else if st.Enumerations.Count > 0 then
   begin
    for var e in TXSEnum<IXMLEnumeration>.XEnum(st.Enumerations) do if SameStr(e.Value, val) then Exit;
    Exit(SetValidateError(name, cherEnumeration, st.Enumerations.Count, '', val,
                          Format(E_ENUM,[name, st.Enumerations.Count, val])));
   end
  else if not VarIsNull(st.TotalDigits) then
     begin
      var fd := 0;
      if not VarIsNull(st.FractionalDigits) then fd := st.FractionalDigits;
      val := FloatToStrF(val, ffGeneral, st.TotalDigits, fd);
    end;
end;

function CheckSimpleData(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  if st.IsBuiltInType then Exit(CheckBuildInTypes(st, val));
  if not CheckUserTypes(st, val) then Exit(False);
  if not CheckFacets(st, val) then Exit(False);
end;

procedure LogPr(const DebugMessage: string);
begin
  OutputDebugString(PChar(DebugMessage));
end;

function ValidateData(data: IXMLTypeDef; var Value: Variant): Boolean;
  function Check(item: TSimpleHistory): boolean;
  begin
    Result := True;
    if item.SimpleType.DerivationMethod = sdmUnion then
     begin
      for var t in item.BaseArray do if Check(t) then Exit;
//      LogPr('not check union ' + item.SimpleType.Name);
      Result := False;
     end
    else
     begin
      if not CheckSimpleData(item.SimpleType, Value) then Exit(False);
      for var t in item.BaseArray do if not Check(t) then Exit(False);
     end;
  end;
begin
  LastValidateErrorData.ErrorString := '';
  Result := Check(HistoryHasValue(data).BaseSimple);
end;

function CheckFloat(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  try
   Val := VarAsType(val, varDouble);
  except
   on E: Exception do Result := SetValidateError(st.Name, cherFloat, '', '', val,
                      Format('err name: %s not float (%s) - %s', [st.Name, val, e.Message]));
  end;
end;

function CheckInt(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  try
   Val := VarAsType(val, varInteger);
  except
   on E: Exception do Result := SetValidateError(st.Name, cherInt, '', '', val,
                      Format('err name: %s not Integer (%s) - %s', [st.Name, val, e.Message]));
  end;
end;

const
 ANYURI_PARRERN ='^([a-z][a-z0-9\*\-\.]*):\/\/(?:(?:(?:[\w\.\-\+!$&''\(\)*\+,;=]|%[0-9a-f]{2})+:)'+
 '*(?:[\w\.\-\+%!$&''\(\)*\+,;=]|%[0-9a-f]{2})+@)?(?:(?:[a-z0-9\-\.]|%[0-9a-f]{2})+|(?:\[(?:[0-9a-f]'+
 '{0,4}:)*(?:[0-9a-f]{0,4})\]))(?::[0-9]+)?(?:[\/|\?](?:[\w#!:\.\?\+=&@!$''~*,;\/\(\)\[\]\-]|%[0-9a-f]{2})*)?$';
function CheckAnyURI(st: IXMLSimpleTypeDef; var val: Variant): Boolean;
begin
  Result := True;
  if not TRegEx.Match(val, ANYURI_PARRERN).Success then
      Exit(SetValidateError(st.Name, cherPattern, ANYURI_PARRERN, '', val,
                            Format(E_PATTERN,[st.Name, 'ANYURI_PARRERN', Val])));
end;
{$ENDREGION 'ValidateData'}

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

function GetAnnotationEx(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False;
                       const IgnoreItems: TArray<string> = []): TArray<string>;
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
  if e.HasAnnotation and not IsIgnore(e) then
   begin
    Result := [TRegEx.Replace(GetDocumentation(e), '\s+', ' ').Trim]
   end
  else Result := [];

  if Supports(e, IXMLTypedSchemaItem, et) then
   begin
    var Dt := Et.DataType;
    while Assigned(Dt) do
     begin
      if dt.HasAnnotation and not IsIgnore(dt) then
        Result := Result + [TRegEx.Replace(Dt.Name+' : '+GetDocumentation(dt), '\s+', ' ').Trim];
      if ParentTypeAnnotation then Dt := Dt.BaseType else Dt := nil;
     end;
   end
   else if Supports(e, IXMLElementGroup, eg) then
    begin
     if  Eg.Ref.HasAnnotation then
       Result := Result + [TRegEx.Replace(Eg.Ref.Name +' : '+ GetDocumentation(Eg.Ref), '\s+', ' ').Trim];
    end;
end;

function GetAnnotation(e: IXMLAnnotatedItem; ParentTypeAnnotation: Boolean = False;
            const IgnoreItems: TArray<string> = [];
            const DocDelim: string = #$D+#$A+' '+ #$D+#$A+' '): string;
begin
  Result := '';
  var d := GetAnnotationEx(e, ParentTypeAnnotation, IgnoreItems);
  for var s in d do Result := Result + s + DocDelim;
  Result := Result.Trim;
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

{$REGION 'History'}
function GetBuildInTypes(Hist: TSimpleHistory): TArray<baseXSD>;
 var
  Res: TArray<baseXSD>;
begin
  Res := [];
  WolkHistorySimple(Hist, function (st: IXMLSimpleTypeDef): Boolean
  begin
    Result := False;
    if st.IsBuiltInType then
     for var bt := btString to btCentury do
      if SameStr(st.Name, baseXSDstring[bt]) then
       begin
        for var r in Res do if r = bt then Exit;
        Res := Res + [bt];
       end;
  end);
  Result := Res;
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
{$ENDREGION}


procedure ValidateXMLDoc(aXmlDoc: IXMLDocument);
var
  validateDoc: IXMLDocument;
begin
  validateDoc := TXMLDocument.Create(nil);
  validateDoc.ParseOptions := [poResolveExternals, poValidateOnParse];
  validateDoc.XML := aXmlDoc.XML;
  validateDoc.Active := true;
end;

function ValidXML2(const xmlFile, nS, xmlSchemaFile: String; out err: IXMLDOMParseError): Boolean;
 var
  xml, xsd: IXMLDOMDocument2;
  cache: IXMLDOMSchemaCollection;
begin
  xsd := CoDOMDocument60.Create; // MSXMLDOMDocumentFactory.CreateDOMDocument as IXMLDOMDocument2;
  xsd.Async := False;
  xsd.resolveExternals := True;
  xsd.load(xmlSchemaFile);

  cache := CoXMLSchemaCache60.Create;
  cache.add(ns, xsd);

  xml := CoDOMDocument60.Create; // MSXMLDOMDocumentFactory.CreateDOMDocument as IXMLDOMDocument2;
  xml.Async := False;
  xml.schemas := cache;
  xml.validateOnParse := True;
  Result := xml.load(xmlFile);
  err := xml.parseError;
end;

initialization

RegisterCheckBuildInType(xsdDouble, CheckFloat);
RegisterCheckBuildInType(xsdFloat, CheckFloat);
for var d in XSDTypeDecimal do RegisterCheckBuildInType(baseXSDstring[d], CheckInt);
RegisterCheckBuildInType(xsdAnyUri, CheckAnyURI);


finalization

end.
