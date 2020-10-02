unit XSDEditor;

interface

uses  //Xml.Win.msxmldom, Winapi.MSXMLIntf,
  RTTI,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,  System.IOUtils, System.UITypes, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  EditorLink.Base, math, Xml.XMLSchemaTags, Vcl.Menus, Vcl.ComCtrls,
  CsToPas;

const
  // Helper message to decouple node change handling from edit handling.
  WM_STARTEDITING = WM_USER + 778;
  COLL_TREE = 0;
  COLL_VAL  = 1;
  COLL_TYPE = 2;
  COLL_UOM  = 3;
  COLL_COUNT = 4;

type
  TFormXSD = class(TForm, IXMLValidatorCallBack)
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
{$WARNINGS OFF}
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
{$WARNINGS ON}
    procedure TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure TreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure TreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;     var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure EmptyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure TreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
  private
    { Private declarations }
  private
    procedure ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar); safecall;
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
  public
    { Public declarations }
    IgnoreAnnotations: TArray<string>;
    ShowAnnotation: Boolean;
    ParentTypeAnnotation: Boolean;
    AutoGenerateRepeatedElement: Boolean;
    sd: IXmlSchemaSet;
//    doc: IXMLSchemaDoc;
    doc_Exam: IXMLDocument;
    procedure ClearTree;
    procedure TreeUpdate(root: IXmlSchemaElement);
  end;

var
   FormXSD: TFormXSD;

const
   WITS_DIR = 'C:\repositories\witsml\v2.0\xsd_schemas\';
//   WITS_DIR = 'd:\Projects\C#\witsml-studio\ext\witsml\ext\devkit-c\doc\Standards\energyml\data\witsml\v2.0\xsd_schemas\';
   WELBORE ='Wellbore.xsd';
   LOG ='log.xsd';
   TUB ='Tubular.xsd';
   JOB ='StimJob.xsd';
   WELL ='Well.xsd';
   WELL_EXAMPL='C:\repositories\witsml\v2.0\xsd_schemas\Well.xml';
   TEER ='ToolErrorModel.xsd';
   SP ='SurveyProgram.xsd';
   DR ='DrillReport.xsd';
   WG ='WellboreGeometry.xsd';
   WELLC ='WellboreCompletion.xsd';
   WELLB ='WellBore.xsd';

implementation

uses EditorLink.XSD, XSDEditor.Hint, XSDTreeData;

{$R *.dfm}

procedure LogPr(const DebugMessage: string);
begin
  OutputDebugString(PChar(DebugMessage));
end;

procedure TFormXSD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tree.Clear;
end;

procedure TFormXSD.FormCreate(Sender: TObject);
// var
//  err : IXMLDOMParseError;
begin
//  ShowAnnotation := True;
//  Screen.HintFont.Size := 8;
  ParentTypeAnnotation := True;
//  AutoGenerateRepeatedElement := True;
  IgnoreAnnotations := ['AbstractString','AbstractObject', 'TypeEnum'];
  TDirectory.SetCurrentDirectory(WITS_DIR);
  GetXmlSchemaSet(sd);
  sd.AddValidationEventHandler(self);
//  sd.Add(nil, WELL);
  sd.Add(nil, LOG);
  sd.Compile;
  TTreeData.SchemaSet := sd;
  TTreeData.TreeColCount := COLL_COUNT;
  TTreeData.CTree := COLL_TREE;
  TTypedTreeData.CType := COLL_TYPE;
  TTypedTreeData.CValue := COLL_VAL;
  ConnectXSDTreeHintAdapter(Self);
  for var s in XSchemas(sd.Schemas) do
   begin
    for var e in XElements(s.Elements) do
     begin
       TreeUpdate(e);
     end;
    Break;
   end;
end;

procedure TFormXSD.ClearTree;
begin
  Tree.Clear;
end;

procedure TFormXSD.TreeUpdate(root: IXmlSchemaElement);
begin
  Tree.BeginUpdate;
  try
   var epv := AddElement(Tree, nil, root);
   Include(epv.States, vsExpanded);
   var e := TElemData(GetTD(epv));
   if Assigned(e.Complex) then
    begin
     AddComplexType(Tree, epv, e.Complex);
     e.ChildAddToTree := True;
    end;
  // for var e in TXSEnum<IXMLElementDef>.XEnum(root.ElementDefs) do AddElem(nil, e);
  finally
   Tree.EndUpdate;
  end;
end;

//procedure TFormXSD.TST_SaveTmpFile(Fname: string);
//begin
//  sd := doc.SchemaDef;
//  TDirectory.SetCurrentDirectory(TPath.GetLibraryPath);
//  sd.SchemaDoc.SaveToFile(Fname + '.xsd');
//  TDirectory.SetCurrentDirectory(WITS_DIR);
//end;

procedure TFormXSD.ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar);
begin
 raise Exception.Create('=ST: {'+TRttiEnumerationType.GetName(SeverityType) + '} MSG: '+ ErrorMessage +'"');
end;

procedure TFormXSD.TreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(IStdData);
end;

procedure TFormXSD.TreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
 var
  nd: PStdData;
begin
  nd := Tree.GetNodeData(Node);
  Finalize(nd^);
end;

procedure TFormXSD.EmptyClick(Sender: TObject);
begin
  var pv := PVirtualNode(Popup.Tag);
  var tt := GetTD(PVirtualNode(Popup.Tag));
  (tt as TTypedTreeData).Empty(Tree);
  TDocData.New(tree, pv, tt.Annotated);
end;

procedure TFormXSD.TreeGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; const P: TPoint; var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
  AskParent := False;
  if (GetTD(Node) is TTypedTreeData) and (Column = COLL_TREE) then
   begin
    PopupMenu := Popup;
    PopupMenu.Tag := Integer(Node);
   end;
end;

procedure TFormXSD.TreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  GetIVTEditLink(EditLink);
end;

procedure TFormXSD.TreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  if Assigned(GetTD(Node).Columns[Column].EditType) then Allowed := True;
end;

procedure TFormXSD.TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
begin
  var nd := GetTD(Node);
  if nd is TElemData then
   begin
    var e := nd as TElemData;
    if Assigned(e.Complex) and not e.ChildAddToTree then
     begin
      AddComplexType(Tree, Node, e.Complex);
      e.ChildAddToTree := True;
     end;
   end;
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
      if Assigned(GetTD(Node).Columns[Column].EditType) then
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
begin
 if not Assigned(NewNode) then
   begin
    Allowed := False;
    Exit;
   end;
  var nd := GetTD(NewNode);
  Allowed := not (nd is TDocData);
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

procedure TFormXSD.TreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
begin
  GetTD(HitInfo.HitNode).OnClick(Sender, HitInfo);
end;

procedure TFormXSD.TreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  var nd := GetTD(Node);
  if (Column >=0) and (Column < COLL_COUNT) then CellText := nd.columns[Column].Value
  else CellText := '';
end;

procedure TFormXSD.TreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
 var
  nd: IStdData;
begin
  nd := GetTD(Node);
  Node.Align := 12; // Alignment of expand/collapse button nearly at the top of the node.
  if nd is TDocData then Include(InitialStates, ivsMultiline);
end;

procedure TFormXSD.TreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
 Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  // Fill random cells with our own background, but don't touch the currently focused cell.
  if Assigned(Node) and ((Column <> Sender.FocusedColumn) or (Node <> Sender.FocusedNode)) then
  begin
   var nd := GetTD(Node);
   TargetCanvas.Brush.Color := nd.Columns[Column].BrashColor;//  NullDockSite. $E0E0FF;
   TargetCanvas.FillRect(CellRect);
  end;
end;

{$WARNINGS OFF}
procedure TFormXSD.TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  var nd := GetTD(Node);
  if Kind = ikState then
   begin
    if vsExpanded in Node.States then ImageIndex := nd.Columns[Column].StatexpandedImageIndex
    else ImageIndex := nd.Columns[Column].StateImageIndex;
    Ghosted := nd.Columns[Column].StateGosted;
   end
  else if Kind in [ikNormal, ikSelected] then
   begin
    if vsExpanded in Node.States then ImageIndex := nd.Columns[Column].ExpandedImageIndex
    else ImageIndex := nd.Columns[Column].ImageIndex;
    Ghosted := nd.Columns[Column].Gosted;
   end;
end;
{$WARNINGS ON}
procedure TFormXSD.TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  var nd := GetTD(Node);
  TargetCanvas.Font.Style := nd.Columns[Column].FontStyles;
  TargetCanvas.Font.Color := nd.Columns[Column].FontColor;
end;

initialization

end.
