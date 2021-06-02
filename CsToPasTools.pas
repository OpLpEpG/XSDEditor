unit CsToPasTools;

interface

uses System.SysUtils, CsToPas;

const
 XS_INST_LOC = 'schemaLocation';
 XS_INST_NOLOC = 'noNamespaceSchemaLocation';
 XS_INST = 'http://www.w3.org/2001/XMLSchema-instance';
 XS_NS = 'http://www.w3.org/2000/xmlns/';

 XSTimeData = [
        tcDuration,
        tcDateTime,
        tcTime,
        tcDate,
        tcGYearMonth,
        tcGYear,
        tcGMonthDay,
        tcGDay,
        tcGMonth,

        tcYearMonthDuration,
        tcDayTimeDuration
        ];

  XSTypeDecimal = [
        tcDecimal,
        tcInteger,
        tcNonPositiveInteger,
        tcNegativeInteger,
        tcLong,
        tcInt,
        tcShort,
        tcByte,
        tcNonNegativeInteger,
        tcUnsignedLong,
        tcUnsignedInt,
        tcUnsignedShort,
        tcUnsignedByte,
        tcPositiveInteger
    ];

  XSTypeString = [
        tcString,
        tcNormalizedString,
        tcToken,
        tcLanguage,
        tctcNmToken,
        tcName,
        tcNCName,
        tcId,
        tcIdref,
        tcEntity];

  XSTypeMisc = [
        tcBoolean,
        tcFloat,
        tcDouble,
        tcHexBinary,
        tcBase64Binary,
        tcAnyUri,
        tcQName,
        tcNotation];

function DmToString(idm: TXmlSchemaDerivationMethod): string;
function CtToString(p: IXmlSchemaParticle): string;
function CmToString(c: IXmlSchemaComplexType): string;
function FacetToString(f: XmlSchemaFacets): string;

implementation

function FacetToString(f: XmlSchemaFacets): string;
begin
 case f of
   sfPattern:  Result := 'Pattern';
   sfLength:  Result := 'Length';
   sfMinLength:  Result := 'MinLength';
   sfMaxLength:  Result := 'MaxLength';
   sfMinInclusive:  Result := 'MinInclusive';
   sfEnumeration:  Result := 'Enumeration';
   sfMaxInclusive:  Result := 'MaxInclusive';
   sfMaxExclusive:  Result := 'MaxExclusive';
   sfTotalDigits:  Result := 'TotalDigits';
   sfMinExclusive:   Result := 'MinExclusive';
   sfFractionDigits:   Result := 'FractionDigits';
   sfWhiteSpace:   Result := 'WhiteSpace';
   else Result := 'ERROR';
 end;
end;

function DmToString(idm: TXmlSchemaDerivationMethod): string;
 var
  dm: XmlSchemaDerivationMethod;
begin
  dm := XmlSchemaDerivationMethod(idm);
  case dm of
    dmEmpty: Result := 'Empty';
    dmSubstitution: Result := 'Substitution';
    dmExtension: Result := 'Extension';
    dmRestriction: Result := 'Restriction';
    dmList: Result := 'List';
    dmUnion: Result := 'Union';
    dmAll: Result := 'All';
    dmNone: Result := 'None';
    else Result := '- ERR DerivationMethod - '
  end;
end;


function CtToString(p: IXmlSchemaParticle): string;
begin
  if Supports(p, IXmlSchemaChoice) then Exit('Choice')
  else if Supports(p, IXmlSchemaSequence) then Exit('Sequence')
  else if Supports(p, IXmlSchemaAll) then Exit('All')
  else if Supports(p, IXmlSchemaGroupRef) then Exit('GroupRef')
  else if Supports(p, IXmlSchemaAny) then Exit('Any')
  else Exit('Empty')
end;

function CmToString(c: IXmlSchemaComplexType): string;
begin
  if not c.SimpleContentModel then Result := 'complex'
  else Result := 'simple';
  Result := Result + DmToString((c as IXmlSchemaType).DerivedBy);
end;

function XFindElement(sd: IXmlSchemaSet; const Name: string; out e: IXmlSchemaElement): Boolean;
begin
  Result := False;
  for var s in XSchemas(sd.Schemas) do
   for var se in XElements(s.Elements) do
    if SameText(e.Name, Name) then
     begin
      e := se;
      Exit(True);
     end;
end;

end.
