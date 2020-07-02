unit XSDEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,  System.IOUtils, System.UITypes, Xml.xmldom,
  XmlSchema, Xml.XMLIntf, Xml.XMLDoc, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  TreeEditor, math, xsdtools, Xml.XMLSchemaTags, Vcl.Menus;

const
  // Helper message to decouple node change handling from edit handling.
  WM_STARTEDITING = WM_USER + 778;
  COLL_TREE = 0;
  COLL_VAL  = 1;
  COLL_TYPE = 2;
  COLL_UOM  = 3;
  COLL_COUNT = 4;

type
  TNodeType = (ntElemRoot, ntElemEditable, ntChoice, ntRepeater, ntChoiceRepeater, ntAttr, ntDoc, ntGroup);
  PNodeExData = ^TTreeData;
  TTreeData = record
    Columns: TArray<TColumnData>;
    nt: TNodeType;
    node: IXMLAnnotatedItem;
    nodeType: IXMLTypeDef;
    procedure StdInit(NodeType: TNodeType; SchemaItem: IXMLAnnotatedItem);
    class procedure Attr(n: PNodeExData; e: IXMLAttributeDef); static;
    class procedure Elem(n: PNodeExData; e: IXMLElementDef); static;
    class procedure Choice(n: PNodeExData; comp: IXMLElementCompositor); static;
    class procedure ChoiceRepeater(n: PNodeExData; comp: IXMLElementCompositor); static;
    class procedure Repeater(n: PNodeExData; e: IXMLElementDef); static;
    class procedure Doc(n: PNodeExData; e: IXMLAnnotatedItem; const docText: string); static;
    class procedure Group(n: PNodeExData; e: IXMLElementGroup); static;
    function SelectChoiseType(const TypeName: string): IXMLElementDef;
    function GetChoiceElem: IXMLElementDef;
    function tip: IXMLTypeDef;
    function ComplexHistory: TComplexHistory;
    function IsElem: boolean;
    function MastExists: boolean;
    function ManyExistsItem: boolean;
    function IsBaseAbstract: boolean;
    function IsAbstract: boolean;
  end;

  TFormXSD = class(TForm)
    Tree: TVirtualStringTree;
    TreeImages: TImageList;
    Popup: TPopupMenu;
    Delete: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure TreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure TreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;var NodeHeight: Integer);
    procedure TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
    procedure TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure TreeChecking(Sender: TBaseVirtualTree; Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;     var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure DeleteClick(Sender: TObject);
    procedure TreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
    procedure AddAnnotation(Node: PVirtualNode; e: IXMLAnnotatedItem);
    procedure AddAttributes(Node: PVirtualNode; Attributes: IXMLAttributeDefList);
    procedure RestrictAttributes(Node: PVirtualNode; Attributes: IXMLAttributeDefList);
    procedure AddComplexcontent(Node: PVirtualNode; comp: IXMLElementCompositor);
    procedure RestrictComplexcontent(Node: PVirtualNode; comp: IXMLElementCompositor);
    procedure AddElem(Node: PVirtualNode; e: IXMLElementDef);
    function  AddChoice(Node: PVirtualNode; comp: IXMLElementCompositor): PVirtualNode;
    procedure AddRepeaterElem(Node: PVirtualNode; e: IXMLElementDef);
    procedure InsertRepeatedElem(Repeater: PVirtualNode);
    procedure ElementSetNewType(Node: PVirtualNode; NewTypeName: string);
    procedure ChoiceSetNewType(Node: PVirtualNode; NewTypeName: string);
    function  AddSingleElem(Node: PVirtualNode; e: IXMLElementDef): PVirtualNode;
    procedure AddComplexHistory(root: PVirtualNode);
    procedure AddElemGroup(Node: PVirtualNode; group: IXMLElementGroup);
    procedure TST_SaveTmpFile(Fname: string);
    // исправление ошибки в положении элементов <xs:group ref = "..."> в проследовательности <xs:sequence
    procedure PatchGroupSeqPosition(group: PVirtualNode);
    // вспомогательная функция для PatchGroupSeqPosition и др..
    function FindTreeNode(root: PVirtualNode; const columnTree: string; FindInGroup: Boolean = False): PVirtualNode;
    function FindRepeaterNode(elem: PVirtualNode): PVirtualNode;
  private
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
  public
    { Public declarations }
    IgnoreAnnotations: TArray<string>;
    ShowAnnotation: Boolean;
    ParentTypeAnnotation: Boolean;
    AutoGenerateRepeatedElement: Boolean;
    sd: IXMLSchemaDef;
    doc: IXMLSchemaDoc;
    procedure ClearTree;
    procedure TreeUpdate(root: IXMLSchemaDef);
  end;

var
   FormXSD: TFormXSD;

const
//   WITS_DIR = 'C:\Projects\C#\witsml\ext\devkit-c\doc\Standards\energyml\data\witsml\v2.0\xsd_schemas\';
   WITS_DIR = 'd:\Projects\C#\witsml-studio\ext\witsml\ext\devkit-c\doc\Standards\energyml\data\witsml\v2.0\xsd_schemas\';
   WELBORE ='Wellbore.xsd';
   LOG ='log.xsd';
   TUB ='Tubular.xsd';
   JOB ='StimJob.xsd';
   WELL ='Well.xsd';
   SP ='SurveyProgram.xsd';
   WG ='WellboreGeometry.xsd';
   WELLC ='WellboreCompletion.xsd';
   WELLB ='WellBore.xsd';

implementation

uses XSDEditorLink;

{$R *.dfm}

procedure LogPr(const DebugMessage: string);
begin
  OutputDebugString(PChar(DebugMessage));
end;

procedure GetXSDTypeInfo(TypeDef: IXMLTypeDef; ss: TStrings);
  procedure AddFacet(f: Variant; const name: string);
  begin
    if not VarIsNull(f) then ss.Add(name + '=' + f);
  end;
  procedure AddAtomic(tip: IXMLTypeDef);
  begin
   // ss.Add('-----------Main Facets------------');
    AddFacet(tip.Ordered, 'Ordered');
    AddFacet(tip.Bounded,'Bounded');
    AddFacet(tip.Cardinality,'Cardinality');
    AddFacet(tip.Numeric,'Numeric');
   // ss.Add('-----------Facets------------');
    AddFacet(tip.Length,'Length');
    AddFacet(tip.MinLength,'MinLength');
    AddFacet(tip.MaxLength,'MaxLength');
    AddFacet(tip.Pattern,'Pattern');
    AddFacet(tip.Whitespace,'Whitespace');
    AddFacet(tip.MaxInclusive,'MaxInclusive');
    AddFacet(tip.MaxExclusive,'MaxExclusive');
    AddFacet(tip.MinInclusive,'MinInclusive');
    AddFacet(tip.MinExclusive,'MinExclusive');
    AddFacet(tip.TotalDigits,'TotalDigits');
    AddFacet(tip.FractionalDigits,'FractionalDigits');
    var s :='';
    for var i := 0 to tip.Enumerations.Count-1 do
     begin
      s := s + tip.Enumerations[i].Value;
      if (tip.Enumerations[i] as IXMLAnnotatedItem).HasAnnotation then
        s := s + '['+ GetDocumentation(tip.Enumerations[i] as IXMLSchemaItem)+']';

      if i < 4 then s := s +','
      else
       begin
        s := s +'...';
        break;
       end;

     end;
    if s <> '' then ss.Add('enum' + '=' + s);
  end;
  procedure AddComplexAtomic(tip: IXMLTypeDef);
  begin
    var ct := Tip as IXMLComplexTypeDef;
    ss.Add(Tip.Name + '-complex: '+ SCM[ct.ContentModel] + ' ' + SDM[ct.DerivationMethod]);
    if ct.AbstractType then ss.Add('---Abstract Type----');

    AddAtomic(Tip);
  end;
  procedure AddSimpleAtomic(tip: IXMLTypeDef);
  begin
    var st := tip as IXMLSimpleTypeDef;
    ss.Add(tip.Name + '-simple:'+ ST_IS_BUILD[st.IsBuiltInType] +' ' + SSDM[st.DerivationMethod]);
    AddAtomic(Tip);
  end;
begin
  if TypeDef.IsComplex then
    AddComplexAtomic(TypeDef)
  else
   begin
    var st := TypeDef as IXMLSimpleTypeDef;
    if st.DerivationMethod = sdmUnion then
     begin
      ss.Add(TypeDef.Name + '-simple:'+ ST_IS_BUILD[st.IsBuiltInType] +' ' + SSDM[st.DerivationMethod]);
      var a := GetUnionSimpleTypes(st.ContentNode as IXMLSimpleTypeUnion);
      for var e in a do
         AddSimpleAtomic(e);
     end
    else AddSimpleAtomic(TypeDef);
   end;
end;

function TEST_GetSimple(t: IXMLTypeDef): string;
begin
  var res := '';
  var h := HistoryHasValue(t);
  for var c in h.ComplexTypes do
   begin
    var at := '';
    if c.AbstractType then at := 'A';
    Res := Res + '('+ c.Name + '-C ' + at + ' '+ SCM[c.ContentModel] + ' ' + SDM[c.DerivationMethod]+')';
   end;
  WolkHistorySimple(h.BaseSimple, function (a: IXMLSimpleTypeDef): Boolean
  begin
    Result := False;
    var sname := '';
    if a.IsAnonymous then sname := 'Anonymous'
    else sname := a.Name;
    if sname = 'AbstractString' then Exit;
    Res := Res +'('+ sname + '['+ ST_IS_BUILD[a.IsBuiltInType] +']' + SSDM[a.DerivationMethod]+')';
  end);
  Result := Res;
end;

function TEST_GetComplex(t: IXMLTypeDef): string;
begin
  var res := '';
  for var c in HistoryComplex(t) do
   begin
    var at := '';
    if c.AbstractType then at := 'A';
    Res := Res + '('+ c.Name + ' ' + at + ' '+ SCM[c.ContentModel] + ' ' + SDM[c.DerivationMethod]+')';
   end;
  Result := Res;
end;

{$REGION 'TTreeData'}
{ TTreeData }

procedure TTreeData.StdInit(NodeType: TNodeType; SchemaItem: IXMLAnnotatedItem);
begin
  SetLength(Columns, COLL_COUNT);
  nt := NodeType;
  node := SchemaItem;
  for var I := 0 to High(Columns) do
   begin
    Columns[i].Value := '';
    Columns[i].Valid := True;
   end;
end;

function TTreeData.tip: IXMLTypeDef;
 var
  e: IXMLTypedSchemaItem;
begin
  Result := nil;
  if Assigned(nodeType) then Exit(nodeType);
  if Supports(node, IXMLTypedSchemaItem, e) then Result := e.DataType;
end;

function TTreeData.GetChoiceElem: IXMLElementDef;
begin
  Result := (node as IXMLElementCompositor).ElementDefs.Find(columns[COLL_TREE].Value);
end;

function TTreeData.SelectChoiseType(const TypeName: string): IXMLElementDef;
begin
  var comp := node as IXMLElementCompositor;
  for var e in TXSEnum<IXMLElementDef>.XEnum(comp.ElementDefs) do
   if e.DataTypeName = TypeName then
    begin
     Result := e;
     Break;
    end;
  nodeType := Result.DataType;
  columns[COLL_TREE].Value := Result.Name;
  columns[COLL_TYPE].Value := Result.DataTypeName;
  Columns[COLL_VAL].Value := '';
  if TypeHasValue(nodeType) then
   begin
    Columns[COLL_VAL].EditType := GetEditorType(Result);
    columns[COLL_UOM].Value := TEST_GetSimple(nodeType);
   end
  else
   begin
    var ct := nodeType as IXMLComplexTypeDef;
    columns[COLL_UOM].Value := TEST_GetComplex(ct);
   end;
end;


class procedure TTreeData.Choice(n: PNodeExData; comp: IXMLElementCompositor);
begin
  n.StdInit(ntChoice, comp);
  for var e in TXSEnum<IXMLElementDef>.XEnum(comp.ElementDefs) do
   if TypeHasValue(e.DataType) then PatchAnnotatedEnumeration(e.DataType);
  n.Columns[COLL_TYPE].EditType := etPickString;
  n.SelectChoiseType(comp.ElementDefs[0].DataTypeName);
end;


class procedure TTreeData.Elem(n: PNodeExData; e: IXMLElementDef);
begin
  n.StdInit(ntElemEditable, e);
  n.nodeType := e.DataType;
  n.columns[COLL_TREE].Value := e.Name;
  n.columns[COLL_TYPE].Value := e.DataTypeName;  //e.DataTypeName='CodeWithAuthorityType'
  if TypeHasValue(n.nodeType) then
   begin
    n.nt := ntElemEditable;
    PatchAnnotatedEnumeration(e.DataType);
    n.Columns[COLL_VAL].EditType := GetEditorType(e);
    if e.DataType.IsComplex then
     begin
      var ct := e.DataType as IXMLComplexTypeDef;
      if ct.AttributeDefs.IndexOfItem('uom') >= 0 then
       begin
        n.columns[COLL_UOM].Value := '?';
       end;
     end;
    if n.MastExists then n.Columns[COLL_VAL].Valid := False;
    n.columns[COLL_UOM].Value := TEST_GetSimple(e.DataType);
   end
  else
   begin
    var ct := e.DataType as IXMLComplexTypeDef;
    n.nt := ntElemRoot;
    if ct.AbstractType then
      n.Columns[COLL_TYPE].EditType := etPickString;
    n.columns[COLL_UOM].Value := TEST_GetComplex(ct);// SCM[ct.ContentModel]+ ' ' + SDM[ct.DerivationMethod];
   end;
end;

class procedure TTreeData.Attr(n: PNodeExData; e: IXMLAttributeDef);
begin
  n.StdInit(ntAttr, e);
  n.nodeType := e.DataType;
  PatchAnnotatedEnumeration(e.DataType);
  n.columns[COLL_TREE].Value := e.Name;
  n.columns[COLL_TYPE].Value := e.DataTypeName;
  n.Columns[COLL_VAL].EditType := GetEditorType(e);
  if n.MastExists then n.Columns[COLL_VAL].Valid := False;
  n.columns[COLL_UOM].Value := TEST_GetSimple(e.DataType);
end;

class procedure TTreeData.ChoiceRepeater(n: PNodeExData; comp: IXMLElementCompositor);
begin

end;

function TTreeData.ComplexHistory: TComplexHistory;
begin
  SetLength(Result, 0);
  if nt = ntElemRoot then
   Result := HistoryComplex(nodeType)
  else if nt = ntElemEditable then
    Result := HistoryHasValue(nodeType).ComplexTypes
  else if nt = ntChoice then
   if TypeHasValue(nodeType) then Result := HistoryHasValue(nodeType).ComplexTypes
   else Result := HistoryComplex(nodeType)
end;

class procedure TTreeData.Doc(n: PNodeExData; e: IXMLAnnotatedItem; const docText: string);
begin
  n.StdInit(ntDoc, e);
  n.columns[COLL_TREE].Value := docText;
end;

class procedure TTreeData.Group(n: PNodeExData; e: IXMLElementGroup);
begin
  n.StdInit(ntGroup, e);
  n.columns[COLL_TREE].Value := e.Name;
  n.columns[COLL_UOM].Value := e.RefName;
end;

class procedure TTreeData.Repeater(n: PNodeExData; e: IXMLElementDef);
begin
  n.StdInit(ntRepeater, e);
  n.nodeType := e.DataType;
  n.columns[COLL_TREE].Value := e.Name;
  n.columns[COLL_VAL].Value := 0;
  n.columns[COLL_TYPE].Value := e.DataTypeName;
end;

function TTreeData.IsBaseAbstract: boolean;
 var
  et: IXMLTypedSchemaItem;
begin
  Result := Supports(node, IXMLTypedSchemaItem, et) and
            et.DataType.IsComplex and (et.DataType as IXMLComplexTypeDef).AbstractType;
end;

function TTreeData.IsAbstract: boolean;
begin
  Result := (nt < ntDoc) and (tip.IsComplex and (tip as IXMLComplexTypeDef).AbstractType);
end;

function TTreeData.IsElem: boolean;
begin
  Result := nt <= ntElemEditable
end;

function TTreeData.ManyExistsItem: boolean;
begin
 // if nt = ntChoice then Exit(IsRepeatingValue((node as IXMLElementCompositor).MinOccurs > 0);
  if not IsElem then Exit(False);
  Result := IsRepeatingValue(node as IXMLElementDef);
end;

function TTreeData.MastExists: Boolean;
begin
  if nt = ntChoice then Exit((node as IXMLElementCompositor).MinOccurs > 0);
  Result := ManyExistsItem or ((nt = ntAttr) and ((node as IXMLAttributeDef).Use = 'required'))
            or (((nt = ntRepeater) or IsElem) and ((node as IXMLElementDef).MinOccurs > 0));
end;
{$ENDREGION TTreeData}

procedure TFormXSD.FormCreate(Sender: TObject);
begin
//  ShowAnnotation := True;
  ParentTypeAnnotation := True;
//  AutoGenerateRepeatedElement := True;
  IgnoreAnnotations := ['AbstractString', 'TypeEnum'];
  TDirectory.SetCurrentDirectory(WITS_DIR);
  doc := LoadXMLSchema(WELL);
//  doc := LoadXMLSchema(LOG);
//  doc := LoadXMLSchema(TUB);
//  doc := LoadXMLSchema(JOB);
//  doc.WasImported
  sd := doc.SchemaDef;
//  TDirectory.SetCurrentDirectory(TPath.GetLibraryPath);
//  sd.SchemaDoc.SaveToFile('well.xsd');
  TreeUpdate(sd);
end;

procedure TFormXSD.ClearTree;
// var
 // pv: PVirtualNode;
begin
 // for pv in Tree.Nodes do PNodeExData(Tree.GetNodeData(pv)).Node := nil;
  Tree.Clear;
end;

procedure TFormXSD.TreeUpdate(root: IXMLSchemaDef);
begin
  Tree.BeginUpdate;
  try
   for var e in TXSEnum<IXMLElementDef>.XEnum(root.ElementDefs) do AddElem(nil, e);
  finally
   Tree.EndUpdate;
  end;
end;

procedure TFormXSD.TST_SaveTmpFile(Fname: string);
begin
  sd := doc.SchemaDef;
  TDirectory.SetCurrentDirectory(TPath.GetLibraryPath);
  sd.SchemaDoc.SaveToFile(Fname + '.xsd');
  TDirectory.SetCurrentDirectory(WITS_DIR);
end;

{$REGION 'Load Scemma'}
procedure TFormXSD.AddAnnotation(Node: PVirtualNode; e: IXMLAnnotatedItem);
begin
  var s := GetAnnotation(e, ParentTypeAnnotation, IgnoreAnnotations);
  if s <> '' then
   begin
    var pdoc := Tree.AddChild(Node);
    if not ShowAnnotation then Tree.IsVisible[pdoc]:= False;
    var dd := PNodeExData(Tree.GetNodeData(pdoc));
    TTreeData.Doc(dd, e, s);
   end;
end;

procedure TFormXSD.AddAttributes(Node: PVirtualNode; Attributes: IXMLAttributeDefList);
begin
  for var a in Attributes as IInterfaceListEx do
   begin
    var pa := Tree.AddChild(Node);
    if (a as IXMLAttributeDef).Use = 'required' then Include(pa.States, vsExpanded);
    var da := PNodeExData(Tree.GetNodeData(pa));
    TTreeData.Attr(da, a as IXMLAttributeDef);
    if da.MastExists then Include(pa.States, vsExpanded);
    AddAnnotation(pa, a as IXMLAttributeDef);
   end;
end;

procedure TFormXSD.RestrictAttributes(Node: PVirtualNode; Attributes: IXMLAttributeDefList);
begin
  for var ii in Attributes as IInterfaceListEx do
   begin
    var a := ii as IXMLAttributeDef;
    var n := FindTreeNode(Node, a.Name);
    var nd := PnodeExData(n.GetData);
    nd.node := a;
    nd.nodeType := a.DataType;
    if a.Use = 'required' then
     begin
      Include(n.States, vsExpanded);
      nd.Columns[COLL_VAL].Valid := False;
     end;

    Tree.InvalidateNode(n);
   end;
end;

procedure TFormXSD.AddRepeaterElem(Node: PVirtualNode; e: IXMLElementDef);
begin
  var pv := Tree.AddChild(Node);
  var nd := PNodeExData(Tree.GetNodeData(pv));
  TTreeData.Repeater(nd, e);
  Include(pv.States, vsExpanded);
  pv.CheckState := csUncheckedPressed;
  pv.CheckType := ctButton;
  AddAnnotation(pv, e);
  if AutoGenerateRepeatedElement then for var i := 1 to Integer(e.MinOccurs) do InsertRepeatedElem(pv);
end;

procedure TFormXSD.AddComplexHistory(root: PVirtualNode);
 var
  ndRoot: PNodeExData;
  Hist: TComplexHistory;
begin
  ndRoot := root.GetData();
  Hist := ndRoot.ComplexHistory;
  for var t in Hist do
   if t.DerivationMethod in [dmComplexRestriction, dmSimpleRestriction] then
      RestrictAttributes(root, t.AttributeDefList)
    else AddAttributes(root, t.AttributeDefList);
  for var t in Hist do
   if t.DerivationMethod in [dmComplexRestriction, dmSimpleRestriction] then
      RestrictComplexcontent(root, t.CompositorNode)
   else AddComplexcontent(root, t.CompositorNode);
end;

procedure TFormXSD.InsertRepeatedElem(Repeater: PVirtualNode);
begin
  Tree.BeginUpdate;
  try
    var pv := Tree.InsertNode(Repeater, amInsertAfter);
    var nd := PNodeExData(Tree.GetNodeData(pv));
    var rd := PNodeExData(Tree.GetNodeData(Repeater));
    TTreeData.Elem(nd, rd.node as IXMLElementDef);

    rd.Columns[COLL_VAL].Value := StrToInt(rd.Columns[COLL_VAL].Value) + 1;
    rd.Columns[COLL_VAL].Dirty := True;

    AddComplexHistory(pv);
  finally
   Tree.EndUpdate;
  end;
 // TST_SaveTmpFile('newWell');
end;

procedure TFormXSD.ChoiceSetNewType(Node: PVirtualNode; NewTypeName: string);
begin
  Tree.BeginUpdate;
  try
    var nd := PNodeExData(Tree.GetNodeData(Node));
    if nd.tip.Name <> NewTypeName then
     begin
      Tree.DeleteChildren(Node);
      var e := nd.SelectChoiseType(NewTypeName);

      AddAnnotation(Node, e);

      AddComplexHistory(Node);
     end;
  finally
   Tree.EndUpdate;
  end;
end;


procedure TFormXSD.ElementSetNewType(Node: PVirtualNode; NewTypeName: string);
begin
  Tree.BeginUpdate;
  try
    var nd := PNodeExData(Tree.GetNodeData(Node));
    var e := nd.node as IXMLAnnotatedItem;

    if nd.tip.Name <> NewTypeName then
     begin
      Tree.DeleteChildren(Node);
      if e.SchemaDef.SchemaDoc.FileName <> nd.tip.SchemaDef.SchemaDoc.FileName then
         NewTypeName := GetGlobalName(nd.tip.SchemaDef, NewTypeName);
      nd.nodeType := nd.tip.SchemaDef.ComplexTypes.Find(NewTypeName);

      AddAnnotation(Node, e);

      AddComplexHistory(Node);
     end;
  finally
   Tree.EndUpdate;
  end;
 // TST_SaveTmpFile('newWell');
end;

function TFormXSD.AddSingleElem(Node: PVirtualNode; e: IXMLElementDef): PVirtualNode;
begin
  Result := Tree.AddChild(Node);
  var nd := PNodeExData(Result.GetData);

  TTreeData.Elem(nd, e);
  if nd.MastExists then Include(Result.States, vsExpanded);

  AddAnnotation(Result, e);

  AddComplexHistory(Result);
end;

procedure TFormXSD.AddElem(Node: PVirtualNode; e: IXMLElementDef);
begin
  if IsRepeatingValue(e) then AddRepeaterElem(Node, e)
  else AddSingleElem(Node, e);
end;

function TFormXSD.AddChoice(Node: PVirtualNode; comp: IXMLElementCompositor): PVirtualNode;
begin
  if IsRepeatingValue(comp) then
   begin
    raise Exception.Create('Error Message: choise repeated TODO: ');
   end
  else
   begin
    Result := Tree.AddChild(Node);
    var nd := PNodeExData(Result.GetData);

    TTreeData.Choice(nd, comp);
    if nd.MastExists then Include(Result.States, vsExpanded);

    AddAnnotation(Result, comp);

    AddComplexHistory(Result);
   end;
end;

procedure TFormXSD.AddComplexcontent(Node: PVirtualNode; comp: IXMLElementCompositor);
begin
  if comp.CompositorType = ctChoice then AddChoice(Node, comp)
  else
   begin
    for var e in TXSEnum<IXMLElementCompositor>.XEnum(comp.Compositors) do AddComplexcontent(node, e);
    for var e in TXSEnum<IXMLElementDef>.XEnum(comp.ElementDefs) do AddElem(node, e);
    for var e in TXSEnum<IXMLElementGroup>.XEnum(comp.ElementGroups) do AddElemGroup(node, e);
   end;
end;

procedure TFormXSD.RestrictComplexcontent(Node: PVirtualNode; comp: IXMLElementCompositor);
begin
  for var e in TXSEnum<IXMLElementDef>.XEnum(comp.ElementDefs) do
   begin
    var n := FindTreeNode(Node, e.Name, True);
    var nd := PnodeExData(n.GetData);
    nd.node := e;
    nd.nodeType := e.DataType;
    if nd.MastExists then
     begin
      Include(n.States, vsExpanded);
      nd.Columns[COLL_VAL].Valid := False;
     end;
    Tree.InvalidateNode(n);
   end;
end;

function TFormXSD.FindRepeaterNode(elem: PVirtualNode): PVirtualNode;
begin
  while Assigned(elem) and (PnodeExData(elem.GetData).nt <> ntRepeater) do elem := elem.PrevSibling;
  Result := elem;
end;

function TFormXSD.FindTreeNode(root: PVirtualNode; const columnTree: string; FindInGroup: Boolean = False): PVirtualNode;
begin
  var sib := root.FirstChild;
  Result := nil;
  while Assigned(sib) do
   begin
    var nd := PnodeExData(sib.GetData);
    if FindInGroup and (nd.nt = ntGroup) then
     begin
      Result := FindTreeNode(sib, columnTree);
      if Assigned(Result) then Exit;
     end;
    if nd.columns[COLL_TREE].Value = columnTree then Exit(sib);
    sib := sib.NextSibling;
   end;
end;

procedure TFormXSD.PatchGroupSeqPosition(group: PVirtualNode);
begin
  var gd := PnodeExData(group.GetData);
  var pd := PnodeExData(group.Parent.GetData);
  var cc := (pd.tip as IXMLComplexTypeDef).CompositorNode;
  for var i := 0 to cc.ChildNodes.Count-1 do
   begin
//    LogPr(cc.ChildNodes[i].LocalName);
    if cc.ChildNodes[i].LocalName = 'group' then
    if ExtractLocalName(cc.ChildNodes[i].Attributes['ref']) = gd.columns[COLL_TREE].Value then
     begin
      var fName := cc.ChildNodes[i+1-2*sign(I)].Attributes['name']; // i=0 [i+1]   i>0 [i-1]
      const II = [amInsertBefore, amInsertAfter];
      Tree.MoveTo(group, FindTreeNode(group.Parent, fName), II[sign(I)], False);      
      Exit;
     end;
   end;
end;

procedure TFormXSD.AddElemGroup(Node: PVirtualNode; group: IXMLElementGroup);
begin
  var pv := Tree.AddChild(Node);
  var nd := PNodeExData(Tree.GetNodeData(pv));
  TTreeData.Group(nd, group);
  Include(pv.States, vsExpanded);

  AddAnnotation(pv, group);

  AddComplexcontent(pv, group.CompositorNode);
  PatchGroupSeqPosition(pv);
end;

{$ENDREGION}

procedure TFormXSD.TreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
 var
  nd: PNodeExData;
  ss: TStrings;
begin
  nd := Tree.GetNodeData(Node);
  if nd.nt > ntAttr then Exit;
  ss := TStringList.Create;
  try
   GetXSDTypeInfo(nd.tip, ss);
   ss.Text := ss.Text + GetAnnotation(nd.node, true, IgnoreAnnotations);
   LineBreakStyle := hlbForceMultiLine;
   HintText := ss.Text;
  finally
   ss.Free;
  end;
//
end;

procedure TFormXSD.TreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeData);
end;

procedure TFormXSD.TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
 var
  nd: PNodeExData;
begin
  nd := Tree.GetNodeData(Node);
  Finalize(nd^);
end;

procedure TFormXSD.DeleteClick(Sender: TObject);
 var
  pv: PVirtualNode;
begin
  pv := PVirtualNode(Popup.Tag);
  var rp := PnodeExData(FindRepeaterNode(pv).GetData);
  Tree.DeleteNode(pv);
  rp.Columns[COLL_VAL].Value := Integer(rp.Columns[COLL_VAL].Value) - 1;
end;

procedure TFormXSD.TreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
 var
  nd: PNodeExData;
begin
  AskParent := False;
  nd := Tree.GetNodeData(Node);
  if nd.ManyExistsItem then
   begin
    var rp := PnodeExData(FindRepeaterNode(Node).GetData);
    if Integer(rp.Columns[COLL_VAL].Value) > StrToInt((nd.node as IXMLElementDef).MinOccurs) then
     begin
      PopupMenu := Popup;
      PopupMenu.Tag := Integer(Node);
     end;
   end;
end;

procedure TFormXSD.TreeChecking(Sender: TBaseVirtualTree; Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
begin
  if PnodeExData(Node.GetData).nt = ntRepeater then InsertRepeatedElem(Node);
end;

procedure TFormXSD.TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  GetIVTEditLink(EditLink);
end;

procedure TFormXSD.TreeEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  var nd := PNodeExData(Node.GetData);
  if Column = COLL_TYPE then
   if nd.nt = ntChoice then ChoiceSetNewType(Node,  nd.Columns[Column].Value)
   else ElementSetNewType(Node,  nd.Columns[Column].Value);
end;

procedure TFormXSD.TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  if PnodeExData(Node.GetData).Columns[Column].EditType <> etNone then Allowed := True;
end;

procedure TFormXSD.TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  with Sender do
  begin
    // Start immediate editing as soon as another node gets focused.
    if Assigned(Node) and (Sender.NodeParent[Node] <> nil) and not (tsIncrementalSearching in TreeStates) then
    begin
      // We want to start editing the currently selected node. However it might well happen that this change event
      // here is caused by the node editor if another node is currently being edited. It causes trouble
      // to start a new edit operation if the last one is still in progress. So we post us a special message and
      // in the message handler we then can start editing the new node. This works because the posted message
      // is first executed *after* this event and the message, which triggered it is finished.
      if PnodeExData(Node.GetData).Columns[Column].EditType <> etNone then
         PostMessage(Self.Handle, WM_STARTEDITING, WPARAM(Node), Column);
    end;
  end;
end;

procedure TFormXSD.WMStartEditing(var Message: TMessage);
begin
  // Note: the test whether a node can really be edited is done in the OnEditing event.
  Tree.EditNode(Pointer(Message.WParam), Message.LParam);
end;

procedure TFormXSD.TreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn,
  NewColumn: TColumnIndex; var Allowed: Boolean);
 var
  nd: PNodeExData;
begin
  if not Assigned(NewNode) then
   begin
    Allowed := False;
    Exit;
   end;
  nd := Tree.GetNodeData(NewNode);
  Allowed := nd.nt <> ntDoc;
  if not Allowed then
  if Tree.GetPrevious(NewNode) = OldNode then  Tree.FocusedNode := Tree.GetNext(NewNode)
  else if Tree.GetNext(NewNode) = OldNode then  Tree.FocusedNode := Tree.GetPrevious(NewNode)
 end;

procedure TFormXSD.TreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if Sender.MultiLine[Node] then
  begin
    TargetCanvas.Font := Sender.Font;
    NodeHeight := Max(Tree.ComputeNodeHeight(TargetCanvas, Node, COLL_TREE),
                      Tree.ComputeNodeHeight(TargetCanvas, Node, COLL_UOM)) + 10;
  end;
  // ...else use what's set by default.
end;

procedure TFormXSD.TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
 var
  nd: PNodeExData;
begin
  nd := Tree.GetNodeData(Node);
  if (Column >=0) and (Column < Length(nd.columns)) then CellText := nd.columns[Column].Value
  else CellText := '';
end;

procedure TFormXSD.TreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
 var
  nd: PNodeExData;
begin
  nd := Tree.GetNodeData(Node);
  Node.Align := 12; // Alignment of expand/collapse button nearly at the top of the node.
  if nd.nt = ntDoc then Include(InitialStates, ivsMultiline);
end;

procedure TFormXSD.TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
 Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  // Fill random cells with our own background, but don't touch the currently focused cell.
  if Assigned(Node) and ((Column <> Sender.FocusedColumn) or (Node <> Sender.FocusedNode)) then
  begin
    var nd := PnodeExData(Node.GetData);
    if (nd.nt in [ntElemEditable, ntAttr]) and (Column = COLL_VAL)
       and not nd.Columns[Column].Valid then
     begin
      TargetCanvas.Brush.Color := $E0E0FF;
      TargetCanvas.FillRect(CellRect);
     end
    else if nd.Columns[Column].Dirty then
     begin
      TargetCanvas.Brush.Color := $E0FFFF;
      TargetCanvas.FillRect(CellRect);
     end;
  end;
end;

procedure TFormXSD.TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
 var
  nd: PNodeExData;
begin
  if not (Kind in [ikNormal, ikSelected]) then Exit;
  nd := Tree.GetNodeData(Node);
  if (Column = COLL_TREE) then
   begin
    if nd.nt in [ntElemRoot, ntGroup] then
      if vsExpanded in Node.States then ImageIndex := 2
      else ImageIndex := 1
    else if nd.MastExists then ImageIndex := 5;
   end;
  if (Column = COLL_TYPE) then
   begin
    if nd.MastExists then ImageIndex := 5;
   end;
end;

procedure TFormXSD.TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
 var
  nd: PNodeExData;
begin
  nd := Tree.GetNodeData(Node);
  if nd.nt = ntDoc then
    begin
      TargetCanvas.Font.Color := TColors.green;
    end
  else if Column = COLL_TREE then
   begin
    TargetCanvas.Font.Style := [fsBold];
    case nd.nt of
     ntAttr: TargetCanvas.Font.Color := clBlue;
     ntGroup: TargetCanvas.Font.Color := TColors.Darkgoldenrod;
     ntRepeater:
       if nd.MastExists then TargetCanvas.Font.Color := TColors.Darkred
       else TargetCanvas.Font.Color := clTeal;
     else
       if nd.MastExists then TargetCanvas.Font.Color := clNavy;
    end;
   end
  else if Column = COLL_TYPE then
   begin
     if nd.nt = ntElemRoot then TargetCanvas.Font.Color := clBlue;
     if nd.IsAbstract then TargetCanvas.Font.Color := clRed;
     if nd.nt in [ntChoice, ntChoiceRepeater] then  TargetCanvas.Font.Color := TColors.Darkmagenta;
   end
  else if Column = COLL_VAL then
   begin
    // if nd.columns[COLL_VAL].Value = '_empty_' then TargetCanvas.Font.Color := clRed;
   end
  else if Column = COLL_UOM then
   begin
     if nd.nt = ntElemRoot then TargetCanvas.Font.Color := clBlue;
   end;
end;

end.
