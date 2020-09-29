unit XSDTreeData;

interface

uses  System.SysUtils, System.UITypes, System.Rtti,
      Vcl.Graphics,
      VirtualTrees,
      EditorLink.Base, CsToPas, CsToPasTools;

   const FONT_TREE_COLOR: array [Boolean, Boolean] of TColor =

         ((clGray, $808060),
          (clBlack, clGreen));

         FONT_TYPE_COLOR: array [XmlSchemaContentType] of TColor =

         (clBlack, clWebOrange, clBlue, clRed);

type
  TIndexColumn = Integer;
  TTreeData = class abstract(TStdData, IXmlSchemaAnnotated, IXmlSchemaObject)
  protected
    FNode: IXmlSchemaAnnotated;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; virtual;
  private
    class var FGlobalShcemaSet: IXmlSchemaSet;
    class var FTreeColCount: Integer;
    class var FCTree: TIndexColumn;
    function GetSchemaObject: IXmlSchemaObject;
  public
    procedure OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo); virtual;
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); virtual;
    function GetAnnotation: string; virtual;
    property Annotated: IXmlSchemaAnnotated read FNode implements IXmlSchemaAnnotated;
    property SchemaObject: IXmlSchemaObject read GetSchemaObject implements IXmlSchemaObject;
    class property SchemaSet: IXmlSchemaSet read FGlobalShcemaSet write FGlobalShcemaSet;
    class property TreeColCount: Integer read FTreeColCount write FTreeColCount;
    class property CTree: TIndexColumn read FCTree write FCTree;
  end;

  TDocData = class(TTreeData)
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  end;

  TTypedTreeData = class abstract(TTreeData, IXmlSchemaType)
  private
    class var FCValue: TIndexColumn;
    class var FCType: TIndexColumn;
    function getTypeName: string;
    function GetIsNoNameType: Boolean;
    function GetItemName: string;
  protected
    FType: IXmlSchemaType;
//    procedure SetTypeTree(Required: Boolean);
    function GetEmpty: Boolean; virtual; abstract;
    function GetTypeAnnotation(): string;
    function GetComplex: IXmlSchemaComplexType;
    function GetSimple: IXmlSchemaSimpleType;
    function GetType: IXmlSchemaType; virtual;
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    procedure Empty(); virtual; abstract;
    function FindValueEditor: TDataEditorClass; virtual;
    property TypeName: string read getTypeName;
    property IsNoNameType: Boolean read GetIsNoNameType;
    property Name: string  read GetItemName;
    property SchemaType: IXmlSchemaType read GetType implements IXmlSchemaType;
    property IsEmpty: Boolean read GetEmpty;
    property Simple: IXmlSchemaSimpleType read GetSimple;
    property Complex: IXmlSchemaComplexType read GetComplex;
    class property CType: TIndexColumn read FCType write FCType;
    class property CValue: TIndexColumn read FCValue write FCValue;
  end;

  TAttrData = class sealed(TTypedTreeData)
  protected
    function GetEmpty: Boolean; override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  private
    function GetAttr: IXmlSchemaAttribute;
    function GetProhibited: boolean;
    function GetRequired: boolean;
    function GetHasDefault: boolean;
    function GetHasFixed: boolean;
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    procedure Empty(); override;
    property Attr: IXmlSchemaAttribute read GetAttr;
    property HasDefault: boolean read GetHasDefault;
    property HasFixed: boolean read GetHasFixed;
    property Required: boolean read GetRequired;
    property Prohibited: boolean read GetProhibited;
//    property Simple;
  end;

  TElemData = class(TTypedTreeData, IXmlSchemaElement, IXmlSchemaParticle)
  protected
   type
    TElems = TArray<TElemData>;
    function GetElem: IXmlSchemaElement; virtual;
    function GetEmpty: Boolean; override;
    function GetManyExistsItems: TElems;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  private
    FChildAddToTree: Boolean;
    function GetPaticle: IXmlSchemaParticle;
    function GetContent: XmlSchemaContentType;
    function GetManyExists: Boolean;
    function GetMastExists: Boolean;
    function GetHasChild: Boolean;
  public
    procedure OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo); override;
    procedure AfterConstruction; override;
    function GetAnnotation: string; override;
    procedure Empty(); override;
    property Elem: IXmlSchemaElement read GetElem implements IXmlSchemaElement;
    property Paticle: IXmlSchemaParticle read GetPaticle implements IXmlSchemaParticle;
    property MastExists: Boolean read GetMastExists;
    property ManyExists: Boolean read GetManyExists;
//    property ManyExistsItems: TArray<TElemData> read GetManyExistsItems;
    property Content: XmlSchemaContentType read GetContent;
    property HasChild: Boolean read GetHasChild;
    property ChildAddToTree: Boolean read FChildAddToTree write FChildAddToTree;
//    property Simple;
//    property Complex;
  end;

  TChoiceElem = class sealed(TElemData, IXmlSchemaChoice)
  private
    FChoice: TArray<IXmlSchemaElement>;
    FCurrent: Integer;
    function GetChoice: IXmlSchemaChoice;
    procedure SetCurrent(const Value: Integer);
    function GetCount: Integer;
  protected
    function GetElem: IXmlSchemaElement; override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    procedure AfterConstruction; override;
    property Choice: IXmlSchemaChoice read GetChoice implements IXmlSchemaChoice;
    property Choices: TArray<IXmlSchemaElement> read FChoice;
    property Current: Integer read FCurrent write SetCurrent;
    property Count: Integer read GetCount;
  end;

  TAbstractElem = class sealed(TElemData)
  protected
    function GetType: IXmlSchemaType; override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  public
    FUserTypes: TArray<IXmlSchemaComplexType>;
    FCurrent: Integer;
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    procedure AfterConstruction; override;
    property BaseAbstract: IXmlSchemaComplexType read GetComplex;
  end;

function GetTD(pv: PVirtualNode): TTreeData; inline;
function AddElement(Tree: TBaseVirtualTree; root: PVirtualNode; e: IXmlSchemaElement; Ins: Boolean = False): PVirtualNode;
procedure AddComplexType(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IXmlSchemaComplexType);

implementation

uses EditorLink.XSD;

function GetTD(pv: PVirtualNode): TTreeData; inline;
begin
  Result := PStdData(pv.GetData)^ as TTreeData;
end;

function AddElement(Tree: TBaseVirtualTree; root: PVirtualNode; e: IXmlSchemaElement; ins: Boolean): PVirtualNode;
 var
  ct: IXmlSchemaComplexType;
begin
    if Supports(e.ElementSchemaType, IXmlSchemaComplexType, ct) and ct.IsAbstract then
       Result := TAbstractElem.New(Tree, root, e, ins)
    else
       Result := TElemData.New(Tree, root, e, ins)
end;

procedure AddComplexType(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IXmlSchemaComplexType);
  procedure AddAny(r: PVirtualNode; sc: IXmlSchemaAny);
  begin
    raise Exception.Create('Error Message procedure AddAny(r: PVirtualNode; sc: IXmlSchemaAny)');
  end;
  procedure AddPaticle(r: PVirtualNode; sc: IXmlSchemaObjectCollection);
   var
    pc: IXmlSchemaChoice;
    pe: IXmlSchemaElement;
    py: IXmlSchemaAny;
  begin
   for var p in XParticles(sc) do
    begin
     if Supports(p, IXmlSchemaChoice, pc) then TChoiceElem.New(Tree, r, pc)
     else if Supports(p, IXmlSchemaElement, pe) then AddElement(Tree, r, pe)
     else if Supports(p, IXmlSchemaAny, py) then AddAny(r, py)
     else raise Exception.Create('Error Message XParticles(sc)');
    end;
  end;
 var
  ps: IXmlSchemaSequence;
  pa: IXmlSchemaAll;
  pc: IXmlSchemaChoice;
begin
  for var a in XAttributes(xml.AttributeUses.Values) do TAttrData.New(Tree, root, a);
  case xml.ContentType of
    scElementOnly:
     begin
      if Supports(xml.ContentTypeParticle, IXmlSchemaSequence, ps) then AddPaticle(root, ps.Items)
      else if Supports(xml.ContentTypeParticle, IXmlSchemaAll, pa) then  AddPaticle(root, pa.Items)
      else if Supports(xml.ContentTypeParticle, IXmlSchemaChoice, pc) then TChoiceElem.New(Tree, root, pc)
      else raise Exception.Create('Error Message xml.ContentTypeParticle ?????');
     end;
    scMixed: raise Exception.Create('Error Message scMixedscMixedscMixed scMixed scMixed scMixed');
  end;
end;

{$REGION 'abstract TTreeData'}

{ TTreeData }

constructor TTreeData.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited Create(AOwner, TreeColCount);
  if Assigned(ANode) then FNode := ANode as IXmlSchemaAnnotated;
end;

function TTreeData.GetAnnotation: string;
begin
  Result := string(FNode.GetAnnotation);
end;

function TTreeData.GetSchemaObject: IXmlSchemaObject;
begin
  Result := FNode as IXmlSchemaObject
end;

class function TTreeData.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean): PVirtualNode;
 var
  nd: PStdData;
begin
  if Ins then Result := Tree.InsertNode(root, amInsertAfter)
  else Result := Tree.AddChild(root);
  nd := Result.GetData;
  nd^ := Create(Result, xml) as IStdData;
//  nd.Columns[COLL_UOM].Value := string((nd^ as IXmlSchemaObject).SourceUri);
  if Self <> TDocData then TDocData.New(Tree, Result, xml);
end;

procedure TTreeData.OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
begin
end;
{$ENDREGION}

{$REGION 'TDocData'}
{ TDocData }

constructor TDocData.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited;
  Columns[CTree].FontColor := TColors.Green;
end;

class function TDocData.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean): PVirtualNode;
 var
  rt: TTreeData;
begin
  Result := nil;
  rt := GetTD(root);
  var doc := rt.GetAnnotation();
  if doc <> '' then
   begin
    Result := inherited;
    var nd := GetTD(Result);
    nd.Columns[CTree].Value := Doc;
   end;
end;
{$ENDREGION}

{$REGION 'abstract TTypedTreeData'}
{ TTypedTreeData }

constructor TTypedTreeData.Create(AOwner: PVirtualNode; ANode: IInterface);
 var
  a: IXmlSchemaAttribute;
  e: IXmlSchemaElement;
begin
  inherited;
  if Supports(FNode, IXmlSchemaAttribute, a) then FType := a.AttributeSchemaType as IXmlSchemaType
  else if Supports(FNode, IXmlSchemaElement, e) then FType := e.ElementSchemaType;
end;

function TTypedTreeData.FindValueEditor: TDataEditorClass;
begin
  Result := GlobalXSDEditLinkClass.GetEditorType(SchemaType)
end;

function TTypedTreeData.GetComplex: IXmlSchemaComplexType;
begin
  Supports(SchemaType, IXmlSchemaComplexType, Result);
end;

function TTypedTreeData.GetIsNoNameType: Boolean;
begin
  Result := string(SchemaType.QualifiedName.Name) = '';
end;

function TTypedTreeData.GetItemName: string;
begin
  if Self is TAttrData then Result := (Self as TAttrData).Attr.QualifiedName.Name
  else Result := (Self as TElemData).Elem.QualifiedName.Name
end;

function TTypedTreeData.GetSimple: IXmlSchemaSimpleType;
begin
  Supports(SchemaType, IXmlSchemaSimpleType, Result);
end;

function TTypedTreeData.GetType: IXmlSchemaType;
begin
  Result := FType;
end;

function TTypedTreeData.GetTypeAnnotation: string;
begin
  Result := string((SchemaType as IXmlSchemaAnnotated).GetAnnotation)
end;
function TTypedTreeData.getTypeName: string;
begin
  Result := string(SchemaType.QualifiedName.Name);
  if Result = '' then Result := 'noname';
end;

//procedure TTypedTreeData.SetTypeTree(Required: Boolean);
//begin
//  var cm := 'simple';
//  if Assigned(Complex) then
//   begin
//    if not Complex.SimpleContentModel then cm := 'complex';
//    cm :=  CtToString(Complex.ContentTypeParticle) + ' ' + cm;
//   end;
//  var s := Format('%s %s  %s%s',[TypeName, TRttiEnumerationType.GetName(FType.TypeCode), cm, DmToString(FType.DerivedBy)]);
//  if Integer(FType.Variety) >= 0 then
//  Columns[CType].Value := Format('%s %s %s',[s, TRttiEnumerationType.GetName(FType.Variety),
//                                               TRttiEnumerationType.GetName(FType.TokenizedType)])
//  else Columns[CType].Value := s;
//  if IsNoNameType then Columns[CType].FontColor := $404080;
//end;

{$ENDREGION}

{$REGION 'TAttrData'}
{ TAttrData }

constructor TAttrData.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited;
  Columns[CTree].Value := string(Attr.QualifiedName.Name);
  Columns[CTree].FontColor := FONT_TREE_COLOR[Required, False];
  Columns[CType].FontColor := Columns[CTree].FontColor;
//  Columns[COLL_UOM].FontColor := Columns[CTree].FontColor;
  Columns[CTree].ImageIndex := 5;
  var s := string(SchemaType.QualifiedName.Name);
  if s ='' then
   begin
    Columns[CType].FontColor := $404080;
    Columns[CType].Value := string(Attr.QualifiedName.Name);
   end
  else Columns[CType].Value := string(SchemaType.QualifiedName.Name);
  if HasDefault then Columns[CValue].Value := string(Attr.DefaultValue)
  else if HasFixed then
   begin
    Columns[CValue].Value := string(Attr.FixedValue);
    Columns[CValue].EditType := nil;
   end
  else if Required then
   begin
    Columns[CValue].BrashColor := $E0E0FF;
    Columns[CTree].FontStyles := [fsBold];
//    Columns[COLL_TYPE].ImageIndex := 5;
   end;
  Columns[CValue].EditType := FindValueEditor;
//  SetTypeTree(False);
end;

procedure TAttrData.Empty;
begin

end;

function TAttrData.GetAttr: IXmlSchemaAttribute;
begin
  Result := FNode as IXmlSchemaAttribute;
end;

function TAttrData.GetEmpty: Boolean;
begin
  Result := Columns[CValue].Value = '';
end;

function TAttrData.GetHasDefault: boolean;
begin
  Result := Attr.DefaultValue <> '';
end;

function TAttrData.GetHasFixed: boolean;
begin
  Result := Attr.FixedValue <> '';
end;

function TAttrData.GetProhibited: boolean;
begin
  Result := Attr.Use = suProhibited;
end;

function TAttrData.GetRequired: boolean;
begin
  Result := Attr.Use = suRequired;
end;

class function TAttrData.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean): PVirtualNode;
begin
  Result := inherited;
end;
{$ENDREGION}

{$REGION 'TElemData'}
{ TElemData }

procedure TElemData.AfterConstruction;
begin
  inherited AfterConstruction;
  Columns[CTree].Value := string(Elem.QualifiedName.Name);
  Columns[CTree].FontStyles := [fsBold];
  Columns[CTree].FontColor := FONT_TREE_COLOR[MastExists, ManyExists];
  if Content = scTextOnly then Columns[CValue].EditType := FindValueEditor;
  if ManyExists then
   begin
    Columns[CTree].ImageIndex := 6;
    Columns[CTree].StateImageIndex := 7;
   end
  else if HasChild  then
   if (Content = scTextOnly) then
    begin
     Columns[CTree].ImageIndex := 9;
     Columns[CTree].ExpandedImageIndex := 10;
    end
   else
    begin
     Columns[CTree].ImageIndex := 1;
     Columns[CTree].ExpandedImageIndex := 2;
    end;

  if MastExists and (Content = scTextOnly) then Columns[CValue].BrashColor := $E0E0FF;

  Columns[CType].Value := TypeName;
//  SetTypeTree(False);
  Columns[CType].FontColor := FONT_TYPE_COLOR[Content];
//  if MastExists then Columns[COLL_TYPE].ImageIndex := 5;
end;

procedure TElemData.Empty;
begin

end;

function TElemData.GetAnnotation: string;
begin
  Result := inherited;
  if Result = '' then Result := GetTypeAnnotation
end;

function TElemData.GetContent: XmlSchemaContentType;
begin
  if Assigned(Simple) then Result := scTextOnly
  else Result := Complex.ContentType;
end;

function TElemData.GetElem: IXmlSchemaElement;
begin
  Result := FNode as IXmlSchemaElement;
end;

function TElemData.GetEmpty: Boolean;
begin
  Result := Columns[CValue].Value = '';
end;

function TElemData.GetHasChild: Boolean;
begin
  Result := (Content = scElementOnly) or (Assigned(Complex) and (Complex.AttributeUses.Count > 0));
end;

function TElemData.GetManyExists: Boolean;
begin
  Result := Paticle.MaxOccurs > 1;
end;

function TElemData.GetManyExistsItems: TElems;
 var
  Res: TElems;
begin
  Res := [self];
  var CheckElem := function(n: PVirtualNode): boolean
  begin
    var nd := GetTD(n);
    if not (nd is TElemData) then Exit(False);
    var e := nd as TElemData;
    if e.Elem = Elem then
     begin
      Res := Res + [e];
      Exit(True);
     end
    else Exit(False);
  end;
  var ps := FOwner.PrevSibling;
  while Assigned(ps) and CheckElem(ps) do ps := ps.PrevSibling;
  var pn := FOwner.NextSibling;
  while Assigned(pn) and CheckElem(pn) do pn := pn.NextSibling;
  Result := Res;
end;

function TElemData.GetMastExists: Boolean;
begin
  Result := Paticle.MinOccurs > 0;
end;

function TElemData.GetPaticle: IXmlSchemaParticle;
begin
  Result := FNode as IXmlSchemaParticle;
end;

class function TElemData.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml:  IInterface; Ins: Boolean): PVirtualNode;
begin
  if Supports(xml, IXmlSchemaElement) then Result := inherited
  else if Supports(xml, IXmlSchemaChoice) then Result := inherited
  else raise Exception.Create('Error Message NOT Supports(xml, IXmlSchemaElement, e)');
end;

procedure TElemData.OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
begin
  if (not ManyExists) or (HitInfo.HitColumn <> CTree) then Exit;
  if hiOnStateIcon in HitInfo.HitPositions then
   begin
    var ae := GetManyExistsItems;
    if Length(ae) > 1 then Sender.DeleteNode(FOwner);
   end
  else if hiOnNormalIcon in HitInfo.HitPositions then AddElement(Sender, FOwner, Elem, True);
end;
{$ENDREGION}

{$REGION 'TChoiceElem'}
{ TChoiceElem }

procedure TChoiceElem.AfterConstruction;
begin
  inherited;
  Columns[CType].FontColor := TColors.Darkmagenta;
//  Columns[COLL_TREE].FontColor := TColors.Darkmagenta;
end;

constructor TChoiceElem.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited;
  FChoice := [];
  for var e in XElements(Choice.Items) do FChoice := FChoice + [e];
  Current := 0;
  Columns[CType].EditType := TChoiceTypeEditor;
end;

function TChoiceElem.GetChoice: IXmlSchemaChoice;
begin
  Result := FNode as IXmlSchemaChoice;
end;

function TChoiceElem.GetCount: Integer;
begin
  Result := Length(FChoice);
end;

function TChoiceElem.GetElem: IXmlSchemaElement;
begin
  Result := FChoice[FCurrent];
end;

class function TChoiceElem.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean): PVirtualNode;
begin
  Result := inherited;
end;

procedure TChoiceElem.SetCurrent(const Value: Integer);
begin
  FCurrent := Value;
  FType := FChoice[FCurrent].ElementSchemaType;
end;
{$ENDREGION}

{$REGION 'TAbstractElem'}
{ TAbstractElem }

procedure TAbstractElem.AfterConstruction;
begin
  inherited;
  Columns[CType].FontColor := clRed;
end;

constructor TAbstractElem.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  FCurrent := -1;
  inherited;
  var ut := SchemaSet.DerivedFrom(BaseAbstract as IXmlSchemaType);
  for var u in XTypes(ut) do
   begin
    var ct: IXmlSchemaComplexType;
    if Supports(u, IXmlSchemaComplexType, ct) then FUserTypes := FUserTypes + [ct]
    else raise Exception.Create('Error Message  constructor TAbstractElem.Create(AOwner: PVirtualNode; ANode: IInterface);');
   end;
  Columns[CType].EditType := TAbstractTypeEditor;
end;


function TAbstractElem.GetType: IXmlSchemaType;
begin
  if FCurrent = -1 then Result := inherited
  else Result := FUserTypes[FCurrent] as IXmlSchemaType;
end;

class function TAbstractElem.New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean): PVirtualNode;
begin
  Result := inherited;
end;
{$ENDREGION}

end.

