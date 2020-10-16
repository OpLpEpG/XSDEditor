unit XSDTreeData;

interface

uses  System.SysUtils, System.UITypes, System.Rtti, Classes,  System.Generics.Collections,
      Vcl.Graphics,
      VirtualTrees,
      Winapi.Windows,

      EditorLink.Base, CsToPas, CsToPasTools;


const
 /// <remarks>
 ///  первая колонка древо с именами
 /// </remarks>
 COLL_TREE = 0;
 COLL_VAL  = 1;
 COLL_TYPE = 2;
 COLL_UOM  = 3;
 COLL_COUNT = 4;

 CL_BRER = $E0E0FF;
                       // req    manyExisis
 FONT_TREE_COLOR: array [Boolean, Boolean] of TColor =
          // req    manyExisis
         ((clGray, $808060),
          (clBlack, clGreen));
                     //  req      empty    valid
 BRUSH_VAL_COLOR: array [Boolean, Boolean, Boolean] of TColor =

         (// No valid  Yes
          ((CL_BRER, clCream),   // no req  no empty
           (clWhite, clWhite)),  // no req  empty

          ((CL_BRER, clCream),  // req    no empty
           (CL_BRER, CL_BRER))   // req   empty
          );

 FONT_TYPE_COLOR: array [XmlSchemaContentType] of TColor =

         (clBlack, clWebOrange, clBlue, clRed);

                       // req    empty
 FONT_TREE_STYLE: array [Boolean, Boolean] of TFontStyles =
          // req    empty
         (([fsBold], []),
          ([fsBold], [fsBold, fsUnderline]));
type
  TIndexColumn = Integer;
  /// <remarks>
  ///   базовый класс данных VirtualTree (элемента XML схеммы)
  /// </remarks>
  TTreeData = class abstract(TStdData, IXmlSchemaAnnotated, IXmlSchemaObject)
  protected
    FNode: IXmlSchemaAnnotated;
    function GetSchemaObject: IXmlSchemaObject; virtual;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; virtual;
  private
    class var FGlobalShcemaSet: IXmlSchemaSet;
  public
    procedure OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo); virtual;
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); virtual;
    function GetAnnotation: string; virtual;
    property Annotated: IXmlSchemaAnnotated read FNode implements IXmlSchemaAnnotated;
    property SchemaObject: IXmlSchemaObject read GetSchemaObject implements IXmlSchemaObject;
    class property SchemaSet: IXmlSchemaSet read FGlobalShcemaSet write FGlobalShcemaSet;
  end;
  /// <remarks>
  ///  документация элемента, атрибута
  /// </remarks>
  TDocData = class(TTreeData)
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  end;

  TTypedTreeData = class;
  TElemData = class;
  TTypedDataValidator = class(TColumnDataValidator, IXMLValidatorCallBack)
  private
    schemaInfo: IXmlSchemaInfo;
    this: TXMLValidatorCallBack;
    function Getdata: TTypedTreeData; inline;
    function GetValidat: IXmlSchemaValidator; inline;
    procedure ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar); safecall;
    function GetSelf(): TXMLValidatorCallBack; safecall;
    procedure SetSelf(s: TXMLValidatorCallBack); safecall;
  protected
    procedure ValidateTextElem(e: TElemData);
  public
   procedure Validate; override;
   property data: TTypedTreeData read Getdata;
   property Validator: IXmlSchemaValidator read GetValidat;
  end;
  /// <remarks>
  ///  элементы или атрибуты XML схеммы базовый класс
  /// </remarks>
  TTypedTreeData = class abstract(TTreeData, IXmlSchemaType)
  private
    function getTypeName: string;
    function GetIsNoNameType: Boolean;
    function GetItemName: string;
    function GetNameSpace: string;
  protected
    FType: IXmlSchemaType;
    procedure UpdateTreeColumn; virtual;
    procedure UpdateValueColumn; virtual;
    procedure UpdateTypeColumn; virtual;
    procedure TST_SetTypeTree(Required: Boolean);
    function GetContent: XmlSchemaContentType;
    /// <remarks>
    ///  Valid := self Valid and not (Empty and Required)
    /// </remarks>
    function GetValid: Boolean; virtual;
    function GetHasChild: Boolean; virtual;
    function GetManyExists: Boolean; virtual;
    function GetRequired: boolean; virtual; abstract;
    function GetEmpty: Boolean; virtual;
    function GetHasDefault: Boolean; virtual; abstract;
    function GetHasFixed: Boolean; virtual; abstract;
    function GetDefaultValue():string; virtual; abstract;
    function GetFixedValue():string; virtual; abstract;
    function GetTypeAnnotation(): string;
    function GetType: IXmlSchemaType; virtual;
    procedure UpdateValueView; virtual;
    function GetComplex: IXmlSchemaComplexType;
    function GetSimple: IXmlSchemaSimpleType;
  public
    constructor Create(AOwner: PVirtualNode; ANode: IInterface); override;
    procedure AfterConstruction; override;
    function GetAnnotation: string; override;
    procedure Empty(Tree: TBaseVirtualTree); virtual;
    function FindValueEditor: TDataEditorClass; virtual;
    property TypeName: string read getTypeName;
    property IsNoNameType: Boolean read GetIsNoNameType;
    property Name: string read GetItemName;
    property NameSpace: string read GetNameSpace;
    property SchemaType: IXmlSchemaType read GetType implements IXmlSchemaType;
    property DefaultValue: string read GetDefaultValue;
    property FixedValue: string read GetFixedValue;
    property HasDefault: boolean read GetHasDefault;
    property HasFixed: boolean read GetHasFixed;
    property IsEmpty: Boolean read GetEmpty;
    property IsValid: Boolean read GetValid;
    property IsRequired: boolean read GetRequired;
    property ManyExists: Boolean read GetManyExists;
    property HasChild: Boolean read GetHasChild;
    property Content: XmlSchemaContentType read GetContent;
    property Simple: IXmlSchemaSimpleType read GetSimple;
    property Complex: IXmlSchemaComplexType read GetComplex;
  end;

  TAttrData = class sealed(TTypedTreeData, IXmlSchemaAttribute)
  protected
    function GetDefaultValue():string; override;
    function GetFixedValue():string; override;
    function GetHasDefault: boolean; override;
    function GetHasFixed: boolean; override;
    function GetRequired: boolean; override;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  private
    function GetAttr: IXmlSchemaAttribute;
    function GetProhibited: boolean;
    function GetOwnerElem: TElemData;
  public
    procedure AfterConstruction; override;
    property OwnerElem: TElemData read GetOwnerElem;
    property Attr: IXmlSchemaAttribute read GetAttr implements IXmlSchemaAttribute;
    property Prohibited: boolean read GetProhibited;
  end;
  TElemData = class(TTypedTreeData, IXmlSchemaElement, IXmlSchemaParticle)
  protected
   type
    TElems = TArray<TElemData>;
    TInerEnum<T: TTreeData> = class(TInterfacedObject)
    private
      FCurent: PVirtualNode;
      First: Boolean;
      function DoGetCurrent: T; inline;
    public
      property Current: T read DoGetCurrent;
      function MoveNext: Boolean; inline;
      function GetEnumerator: TInerEnum<T>;
      constructor Create(root: TElemData);
    end;
    function GetDefaultValue():string; override;
    function GetFixedValue():string; override;
    function GetHasDefault: boolean; override;
    function GetHasFixed: boolean; override;
    /// <remarks>
    /// Empty = (Self Empty) and (child empty)
    /// </remarks>
    function GetEmpty: Boolean; override;
    /// <remarks>
    /// Required = (Self Required) or not Empty
    /// </remarks>
    function GetRequired: boolean; override;
    /// <remarks>
    /// Valid = not Required or ((Self Valid) and (child Valid))
    /// </remarks>
    function GetValid: Boolean; override;
    function GetManyExists: Boolean; override;
    function GetHasChild: Boolean; override;
    function GetChildEmpty: Boolean;
    function GetChildValid: Boolean;
    function GetElem: IXmlSchemaElement; virtual;
    function GetManyExistsItems: TElems;
    class function New(Tree: TBaseVirtualTree; root: PVirtualNode; xml: IInterface; Ins: Boolean = False): PVirtualNode; override;
  private
    FChildAddToTree: Boolean;
    function GetPaticle: IXmlSchemaParticle;
    function GetAttributes: TInerEnum<TAttrData>;
    function GetChildElems: TInerEnum<TElemData>;
  public
    procedure OnClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo); override;
    procedure AfterConstruction; override;
    property Attributes: TInerEnum<TAttrData> read GetAttributes;
    property Childs: TInerEnum<TElemData> read GetChildElems;
    procedure Empty(Tree: TBaseVirtualTree); override;
    property Elem: IXmlSchemaElement read GetElem implements IXmlSchemaElement;
    property Paticle: IXmlSchemaParticle read GetPaticle implements IXmlSchemaParticle;
    property ChildAddToTree: Boolean read FChildAddToTree write FChildAddToTree;
  end;

  TChoiceElem = class sealed(TElemData, IXmlSchemaChoice)
  private
    FChoice: TArray<IXmlSchemaElement>;
    FCurrent: Integer;
    function GetChoice: IXmlSchemaChoice;
    procedure SetCurrent(const Value: Integer);
    function GetCount: Integer;
  protected
    procedure UpdateViewType;
    function GetSchemaObject: IXmlSchemaObject; override;
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

{$REGION 'TTypedDataValidator'}

{ TTypedDataValidator }

procedure TTypedDataValidator.ValidateTextElem(e: TElemData);
 var
  ErrElem: string;
  procedure AddErrorMsg;
  begin
    if ErrElem = '' then ErrElem := FValidateErrorMsg
    else if FValidateErrorMsg <> '' then ErrElem := ErrElem + #$D#$A#$D#$A +  FValidateErrorMsg;
    FValidateErrorMsg := '';
  end;
begin
  with Validator do
   begin
    Initialize(e.SchemaObject);
    var ce := e.Columns[COLL_VAL];
    ValidateElement(PChar(e.Name), PChar(e.NameSpace), schemaInfo);
    AddErrorMsg;
    if e.HasChild then
     for var a in e.Attributes do
       if not a.IsEmpty then
        begin
         var cv := a.Columns[COLL_VAL];
         ValidateAttribute(PChar(a.Name), PChar(a.NameSpace), PChar(cv.Value), schemaInfo);
         cv.IsValid := schemaInfo.Validity = svValid;
         cv.ValidateErrorMsg := FValidateErrorMsg;
         AddErrorMsg;
        end
       else a.Columns[COLL_VAL].IsValid := True;
    ValidateEndOfAttributes(schemaInfo);
    AddErrorMsg;
    ValidateText(PChar(ce.Value));
    AddErrorMsg;
    ValidateEndElement(schemaInfo);
    AddErrorMsg;
    ce.IsValid := schemaInfo.Validity = svValid;
    ce.ValidateErrorMsg := ErrElem;
   end;
end;

procedure TTypedDataValidator.Validate;
begin
  Validator.AddValidationEventHandler(self);
  with Validator do
  try
    if (data is TAttrData) then
     begin
      var e := (data as TAttrData).OwnerElem;
      if e.Content <> scTextOnly then
       begin
        Initialize(e.SchemaObject);
        ValidateElement(PChar(e.Name), PChar(e.NameSpace), schemaInfo);
        if not data.IsEmpty then
         begin
          ValidateAttribute(PChar(data.Name), PChar(data.NameSpace), PChar(FColumnData.Value), schemaInfo);
          FColumnData.IsValid := schemaInfo.Validity = svValid;
          FColumnData.ValidateErrorMsg := FValidateErrorMsg;
         end
        else FColumnData.IsValid := True;
        SkipToEndElement(schemaInfo);
       end
      else ValidateTextElem(e);
     end
    else if data.Content = scTextOnly then ValidateTextElem(data as TElemData);
  finally
    DelValidationEventHandler(self);
    EndValidation;
  end;
end;

function TTypedDataValidator.Getdata: TTypedTreeData;
begin
  Result := GetTD(FColumnData.Owner) as TTypedTreeData;
end;

function TTypedDataValidator.GetSelf: TXMLValidatorCallBack;
begin
  Result := this;
end;

function TTypedDataValidator.GetValidat: IXmlSchemaValidator;
begin
  Result := (FEditor.Link as TXSDEditLink).Validator;
end;

procedure TTypedDataValidator.SetSelf(s: TXMLValidatorCallBack);
begin
  this := s;
end;

procedure TTypedDataValidator.ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar);
begin
  if FValidateErrorMsg = '' then FValidateErrorMsg := ErrorMessage
  else FValidateErrorMsg := FValidateErrorMsg + #$D#$A#$D#$A + ErrorMessage
end;
{$ENDREGION}

{$REGION 'abstract TTreeData'}

{ TTreeData }

constructor TTreeData.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited Create(AOwner, COLL_COUNT);
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
  Columns[COLL_TREE].FontColor := TColors.Green;
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
    nd.Columns[COLL_TREE].Value := Doc;
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

procedure TTypedTreeData.AfterConstruction;
begin
  inherited;

  if HasDefault then Columns[COLL_VAL].Value := DefaultValue
  else if HasFixed then Columns[COLL_VAL].Value := FixedValue;

  if (Content = scTextOnly) and not HasFixed then Columns[COLL_VAL].EditType := FindValueEditor;

  Columns[COLL_VAL].UpdateViewDataFunc := UpdateValueView;
  Columns[COLL_VAL].Validator := TTypedDataValidator;

  UpdateTreeColumn;
  UpdateValueColumn;
  UpdateTypeColumn;
end;

procedure TTypedTreeData.UpdateTreeColumn;
begin
  Columns[COLL_TREE].Value := Name;
  Columns[COLL_TREE].FontColor := FONT_TREE_COLOR[IsRequired, ManyExists];
  Columns[COLL_TREE].FontStyles := FONT_TREE_STYLE[IsRequired, IsEmpty];
end;

procedure TTypedTreeData.UpdateTypeColumn;
begin
  Columns[COLL_TYPE].Value := TypeName;
  Columns[COLL_TYPE].FontColor := FONT_TYPE_COLOR[Content];
end;

procedure TTypedTreeData.UpdateValueColumn;
begin
  Columns[COLL_VAL].BrashColor := BRUSH_VAL_COLOR[IsRequired, IsEmpty, IsValid];
end;

procedure TTypedTreeData.UpdateValueView({Tree: TBaseVirtualTree; ColumnData: TColumnData});
begin
  UpdateValueColumn;
  UpdateTreeColumn;
end;

procedure TTypedTreeData.Empty(Tree: TBaseVirtualTree);
begin
  if not HasFixed then
   if HasDefault then Columns[COLL_VAL].Value := DefaultValue
   else Columns[COLL_VAL].Value := '';
  Columns[COLL_VAL].IsValid := True;
  Columns[COLL_VAL].ValidateErrorMsg := '';
  Columns[COLL_VAL].UpdateViewData(Tree);
end;

function TTypedTreeData.FindValueEditor: TDataEditorClass;
begin
  Result := GlobalXSDEditLinkClass.GetEditorType(SchemaType)
end;

function TTypedTreeData.GetComplex: IXmlSchemaComplexType;
begin
  Supports(SchemaType, IXmlSchemaComplexType, Result);
end;

function TTypedTreeData.GetContent: XmlSchemaContentType;
begin
  if Assigned(Simple) then Result := scTextOnly
  else Result := Complex.ContentType;
end;

function TTypedTreeData.GetEmpty: Boolean;
begin
  if HasFixed then Exit(True)
  else if HasDefault then Exit(SameStr(string(Columns[COLL_VAL].Value), DefaultValue))
       else Exit(SameStr(string(Columns[COLL_VAL].Value).Trim, ''));
end;

function TTypedTreeData.GetHasChild: Boolean;
begin
  Result := False;
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

function TTypedTreeData.GetManyExists: Boolean;
begin
  Result := False;
end;

function TTypedTreeData.GetNameSpace: string;
begin
  if Self is TAttrData then Result := (Self as TAttrData).Attr.QualifiedName.Namespace
  else Result := (Self as TElemData).Elem.QualifiedName.Namespace
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

function TTypedTreeData.GetValid: Boolean;
begin
  Result := Columns[COLL_VAL].IsValid and not (IsEmpty and IsRequired)
end;

function TTypedTreeData.GetAnnotation: string;
begin
  Result := inherited;
  if Result = '' then Result := GetTypeAnnotation
end;

procedure TTypedTreeData.TST_SetTypeTree(Required: Boolean);
begin
  var cm := 'simple';
  if Assigned(Complex) then
   begin
    if not Complex.SimpleContentModel then cm := 'complex';
    cm :=  CtToString(Complex.ContentTypeParticle) + ' ' + cm;
   end;
  var s := Format('%s %s  %s%s',[TypeName, TRttiEnumerationType.GetName(FType.TypeCode), cm, DmToString(FType.DerivedBy)]);
  if Integer(FType.Variety) >= 0 then
  Columns[COLL_UOM].Value := Format('%s %s %s',[s, TRttiEnumerationType.GetName(FType.Variety),
                                               TRttiEnumerationType.GetName(FType.TokenizedType)])
  else Columns[COLL_UOM].Value := s;
  if IsNoNameType then Columns[COLL_UOM].FontColor := $404080;
end;
{$ENDREGION}

{$REGION 'TAttrData'}
{ TAttrData }

procedure TAttrData.AfterConstruction;
begin
  inherited;
  Columns[COLL_TREE].ImageIndex := 5;
  if IsNoNameType then Columns[COLL_TYPE].FontColor := $404080;
  TST_SetTypeTree(False);
end;

function TAttrData.GetFixedValue: string;
begin
  Result := string(Attr.FixedValue);
end;

function TAttrData.GetAttr: IXmlSchemaAttribute;
begin
  Result := FNode as IXmlSchemaAttribute;
end;

function TAttrData.GetDefaultValue: string;
begin
  Result := string(Attr.DefaultValue);
end;

function TAttrData.GetHasDefault: boolean;
begin
  Result := Attr.DefaultValue <> '';
end;

function TAttrData.GetHasFixed: boolean;
begin
  Result := Attr.FixedValue <> '';
end;

function TAttrData.GetOwnerElem: TElemData;
begin
  Result := GetTD(FOwner.Parent) as TElemData;
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
  if ManyExists then
   begin
    Columns[COLL_TREE].ImageIndex := 6;
    Columns[COLL_TREE].StateImageIndex := 7;
   end
  else if HasChild  then
   if (Content = scTextOnly) then
    begin
     Columns[COLL_TREE].ImageIndex := 9;
     Columns[COLL_TREE].ExpandedImageIndex := 10;
    end
   else
    begin
     Columns[COLL_TREE].ImageIndex := 1;
     Columns[COLL_TREE].ExpandedImageIndex := 2;
    end;
  TST_SetTypeTree(False);
end;

procedure TElemData.Empty(Tree: TBaseVirtualTree);
begin
  Tree.DeleteChildren(FOwner);
  ChildAddToTree := False;
  inherited;
end;

function TElemData.GetChildValid: Boolean;
begin
  var c := FOwner.FirstChild;
  Result := True;
  while Result and Assigned(c) do
   begin
    var d := GetTD(c);
    if d is TTypedTreeData then Result := Result and (d as TTypedTreeData).IsValid;
    c := c.NextSibling;
   end;
end;

{ TElemData.TInerEnum<T> }

constructor TElemData.TInerEnum<T>.Create(root: TElemData);
begin
  FCurent := root.FOwner.FirstChild;
  First := True;
end;

function TElemData.TInerEnum<T>.DoGetCurrent: T;
begin
  Result := GetTD(FCurent) as T;
end;

function TElemData.TInerEnum<T>.GetEnumerator: TInerEnum<T>;
begin
  Result := Self;
end;

function TElemData.TInerEnum<T>.MoveNext: Boolean;
begin
  Result := False;
  if First then First := False
  else FCurent := FCurent.NextSibling;
  while Assigned(FCurent) do
   if  GetTD(FCurent) is T then Exit(True)
   else FCurent := FCurent.NextSibling;
end;

function TElemData.GetAttributes: TInerEnum<TAttrData>;
begin
  Result := TInerEnum<TAttrData>.Create(Self);
end;

function TElemData.GetChildElems: TInerEnum<TElemData>;
begin
  Result := TInerEnum<TElemData>.Create(Self);
end;

function TElemData.GetChildEmpty: Boolean;
begin
  var c := FOwner.FirstChild;
  Result := True;
  while Result and Assigned(c) do
   begin
    var d := GetTD(c);
    if d is TTypedTreeData then Result := Result and (d as TTypedTreeData).IsEmpty;
    c := c.NextSibling;
   end;
end;

function TElemData.GetDefaultValue: string;
begin
  Result := string(Elem.DefaultValue)
end;

function TElemData.GetElem: IXmlSchemaElement;
begin
  Result := FNode as IXmlSchemaElement;
end;

function TElemData.GetEmpty: Boolean;
begin
  Result := inherited;
  if HasChild and Result then Result := GetChildEmpty;
end;

function TElemData.GetFixedValue: string;
begin
  Result := string(Elem.FixedValue)
end;

function TElemData.GetHasChild: Boolean;
begin
  Result := (Content = scElementOnly) or (Assigned(Complex) and (Complex.AttributeUses.Count > 0));
end;

function TElemData.GetHasDefault: boolean;
begin
  Result := Assigned(Elem.DefaultValue)
end;

function TElemData.GetHasFixed: boolean;
begin
  Result := Assigned(Elem.FixedValue)
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

function TElemData.GetRequired: Boolean;
begin
  Result := (Paticle.MinOccurs > 0) or not IsEmpty;
end;

function TElemData.GetValid: Boolean;
begin
  Result := not IsRequired or (inherited and GetChildValid);
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
  if (not ManyExists) or (HitInfo.HitColumn <> COLL_TREE) then Exit;
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
  Columns[COLL_TYPE].FontColor := TColors.Darkmagenta;
end;

constructor TChoiceElem.Create(AOwner: PVirtualNode; ANode: IInterface);
begin
  inherited;
  FChoice := [];
  for var e in XElements(Choice.Items) do FChoice := FChoice + [e];
  Current := 0;
  Columns[COLL_TYPE].EditType := TChoiceTypeEditor;
  Columns[COLL_TYPE].UpdateViewDataFunc := UpdateViewType;
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

function TChoiceElem.GetSchemaObject: IXmlSchemaObject;
begin
  Result := Elem as IXmlSchemaObject;
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
procedure TChoiceElem.UpdateViewType;
begin
  UpdateTreeColumn;
  if Content = scTextOnly then Columns[COLL_VAL].EditType := FindValueEditor;
  UpdateValueColumn;
end;

{$ENDREGION}

{$REGION 'TAbstractElem'}
{ TAbstractElem }

procedure TAbstractElem.AfterConstruction;
begin
  inherited;
  Columns[COLL_TYPE].FontColor := clRed;
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
  Columns[COLL_TYPE].EditType := TAbstractTypeEditor;
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

