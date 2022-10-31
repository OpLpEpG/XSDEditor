unit XSDEditor;

interface

uses  //Xml.Win.msxmldom, Winapi.MSXMLIntf,
  RTTI,   IdURI,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,  System.IOUtils, System.UITypes, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, Vcl.StdCtrls, System.ImageList, Vcl.ImgList,
  EditorLink.Base, math, Xml.XMLSchemaTags, Vcl.Menus, Vcl.ComCtrls,
  CsToPas, XSDTreeData,
  JvBaseDlg, JvSelectDirectory, JvAppStorage, JvAppXMLStorage, JvComponentBase, JvFormPlacement, Vcl.ExtDlgs;

const
  // Helper message to decouple node change handling from edit handling.
  WM_STARTEDITING = WM_USER + 778;

type
  TFormXSD = class(TForm, IXmlSchemaValidator)
    Tree: TVirtualStringTree;
    TreeImages: TImageList;
    Popup: TPopupMenu;
    Delete: TMenuItem;
    mm: TMainMenu;
    newfile: TMenuItem;
    menuNew: TMenuItem;
    menuOpen: TMenuItem;
    schema: TMenuItem;
    menuSchOpen: TMenuItem;
    menuSchDir: TMenuItem;
    namespace: TMenuItem;
    menuNameSpace: TMenuItem;
    SelectDir: TJvSelectDirectory;
    Storage: TJvFormStorage;
    XMLFileStorage: TJvAppXMLFileStorage;
    OpenFile: TOpenTextFileDialog;
    N1: TMenuItem;
    save1: TMenuItem;
    sb: TStatusBar;
    menuFileDir: TMenuItem;
    N3: TMenuItem;
    SaveFile: TSaveDialog;
    mmOptions: TMenuItem;
    mmSetup: TMenuItem;
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
    procedure TreeExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure TreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure StorageAfterRestorePlacement(Sender: TObject);
    procedure StorageBeforeSavePlacement(Sender: TObject);
    procedure EmptyClick(Sender: TObject);
    procedure menuNewClick(Sender: TObject);
    procedure menuOpenClick(Sender: TObject);
    procedure menuSchDirClick(Sender: TObject);
    procedure menuSchOpenClick(Sender: TObject);
    procedure menuNameSpaceClick(Sender: TObject);
    procedure menuSaveClick(Sender: TObject);
    procedure menuFileDirClick(Sender: TObject);
    procedure mmSetupClick(Sender: TObject);
  private
    { Private declarations }
    FValidator: IXmlSchemaValidator;
//    procedure ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar); safecall;
    procedure SetNewSchema(const scName: string);
    procedure LoadNewFile(const flName: string);
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
  public
    { Public declarations }
    IgnoreAnnotations: TArray<string>;
    ShowAnnotation: Boolean;
    ParentTypeAnnotation: Boolean;
    AutoGenerateRepeatedElement: Boolean;
    sd: IXmlSchemaSet;
    ns: IXmlNamespaceManager;
//    doc: IXMLSchemaDoc;
    doc_Exam: IXMLDocument;
    property Validator: IXmlSchemaValidator read FValidator implements IXmlSchemaValidator;
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

uses EditorLink.XSD, EditorLink.Eml, XSDEditor.Hint, XSDTreeData.ReadWriteValidate, XSDEditor.Setup;

{$R *.dfm}

procedure LogPr(const DebugMessage: string);
begin
  OutputDebugString(PChar(DebugMessage));
end;

procedure TFormXSD.SetNewSchema(const scName: string);
begin
  GetXmlSchemaSet(sd);
  sd.Add(nil, PChar(scName));
  sd.Compile;
  TTreeData.SchemaSet := sd;

  ns := sd.CreateNamespace();
  DefaultEmlSpace(ns);
  FValidator := sd.Validator(ns);
  Tree.Clear;
  for var s in XSchemas(sd.Schemas) do
   begin
    var d := TIdURI.Create((s as IXmlSchemaObject).SourceUri).Document;
    var de := TPath.GetFileNameWithoutExtension(d);
    if TPath.GetFileName(scName) = d then
     begin
      for var e in XElements(s.Elements) do
        if formSetup.cbClseqElemName.Checked or SameText(e.Name, de) then
         begin
          AddElement(Tree, nil, e);
          Break;
         end;
      Break;
     end;
   end;
end;

procedure TFormXSD.LoadNewFile(const flName: string);
 var
  v: TValidatorLoader;
begin
  v := TValidatorLoader.Create(Tree, sd, ns);
  v.read(flName);
end;

procedure TFormXSD.StorageAfterRestorePlacement(Sender: TObject);
begin
  if Storage.StoredValue['COLL_TREE'] <> 0 then
   begin
    Tree.Header.Columns[COLL_TREE].Width := Storage.StoredValue['COLL_TREE'];
    Tree.Header.Columns[COLL_VAL].Width := Storage.StoredValue['COLL_VAL'];
    Tree.Header.Columns[COLL_TYPE].Width := Storage.StoredValue['COLL_TYPE'];
    Tree.Header.Columns[COLL_UOM].Width := Storage.StoredValue['COLL_UOM'];
   end
  else
   begin
    Storage.StoredValue['SCHEMA_DIR'] := WITS_DIR;
   end;
//  ShowAnnotation := True;
//  Screen.HintFont.Size := 8;
  ParentTypeAnnotation := True;
//  AutoGenerateRepeatedElement := True;
  IgnoreAnnotations := ['AbstractString','AbstractObject', 'TypeEnum'];
  TDirectory.SetCurrentDirectory(Storage.StoredValue['SCHEMA_DIR']);

  Tree.BeginUpdate;
  try
   SetNewSchema(Storage.StoredValue['SCHEMA_FILE']);
   LoadNewFile(Storage.StoredValue['FILE_NAME']);
  finally
   Tree.EndUpdate;
  end;

  ConnectXSDTreeHintAdapter(Self);
end;

procedure TFormXSD.StorageBeforeSavePlacement(Sender: TObject);
begin
  Storage.StoredValue['COLL_TREE'] := Tree.Header.Columns[COLL_TREE].Width;
  Storage.StoredValue['COLL_VAL'] := Tree.Header.Columns[COLL_VAL].Width;
  Storage.StoredValue['COLL_TYPE'] := Tree.Header.Columns[COLL_TYPE].Width;
  Storage.StoredValue['COLL_UOM'] := Tree.Header.Columns[COLL_UOM].Width;
end;

procedure TFormXSD.menuNewClick(Sender: TObject);
begin
  for var r in Tree.ChildNodes(nil) do
   begin
    var d := GetTD(r);
    if d is TTypedTreeData then (d as TTypedTreeData).Empty(Tree);
   end;
end;

procedure TFormXSD.menuOpenClick(Sender: TObject);
begin

  OpenFile.InitialDir := Storage.StoredValue['FILE_DIR'];
  if OpenFile.Execute(Handle) then
   begin
    Storage.StoredValue['FILE_NAME'] := OpenFile.FileName;
    LoadNewFile(OpenFile.FileName);
   end;
end;

procedure TFormXSD.menuSchOpenClick(Sender: TObject);
begin
  OpenFile.InitialDir := Storage.StoredValue['SCHEMA_DIR'];
  if OpenFile.Execute(Handle) then
   begin
    Storage.StoredValue['SCHEMA_FILE'] := OpenFile.FileName;
    SetNewSchema(OpenFile.FileName);
   end;
end;

procedure TFormXSD.mmSetupClick(Sender: TObject);
begin
  FormSetup.Show;
end;

procedure TFormXSD.menuSaveClick(Sender: TObject);
begin
  SaveFile.InitialDir := Storage.StoredValue['FILE_DIR'];
  if SaveFile.Execute(Handle) then
   begin
    // SaveNewFile(SaveFile.FileName);
    Storage.StoredValue['FILE_NAME'] := SaveFile.FileName;
   end;
end;

procedure TFormXSD.menuSchDirClick(Sender: TObject);
begin
  SelectDir.InitialDir := Storage.StoredValue['SCHEMA_DIR'];
  if SelectDir.Execute(Handle) then
   begin
    Storage.StoredValue['SCHEMA_DIR'] := SelectDir.Directory;
    TDirectory.SetCurrentDirectory(SelectDir.Directory);
   end;
end;

procedure TFormXSD.menuFileDirClick(Sender: TObject);
begin
  SelectDir.InitialDir := Storage.StoredValue['FILE_DIR'];
  if SelectDir.Execute(Handle) then
   begin
    Storage.StoredValue['FILE_DIR'] := SelectDir.Directory;
   end;
end;

procedure TFormXSD.menuNameSpaceClick(Sender: TObject);
begin
//
end;

procedure TFormXSD.EmptyClick(Sender: TObject);
begin
  var pv := PVirtualNode(Popup.Tag);
  var tt := GetTD(PVirtualNode(Popup.Tag));
  if tt is TTypedTreeData then
   begin
    (tt as TTypedTreeData).Empty(Tree);
    TDocData.New(tree, pv, (tt as TTypedTreeData).Annotated);
   end;
end;

{$REGION 'VirtualTree events'}
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
  var d := GetTD(HitInfo.HitNode);
  if d is TTreeData then (d as TTreeData).OnClick(Sender, HitInfo);
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
  if Column < 0 then Exit;
  if Assigned(Node) then
  begin
   var nd := GetTD(Node);
   TargetCanvas.Brush.Color := nd.Columns[Column].BrashColor;
   TargetCanvas.FillRect(CellRect);
  end;
end;
{$WARNINGS OFF}
procedure TFormXSD.TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  if Column < 0 then Exit;
  var nd := GetTD(Node);
  if Kind in [ikNormal, ikSelected] then
   begin
    if vsExpanded in Node.States then ImageIndex := nd.Columns[Column].ExpandedImageIndex
    else ImageIndex := nd.Columns[Column].ImageIndex;
    Ghosted := nd.Columns[Column].Gosted;
   end
  else if Kind = ikState then
   begin
    if vsExpanded in Node.States then ImageIndex := nd.Columns[Column].StatexpandedImageIndex
    else ImageIndex := nd.Columns[Column].StateImageIndex;
    Ghosted := nd.Columns[Column].StateGosted;
   end
end;
{$WARNINGS ON}
procedure TFormXSD.TreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  var nd := GetTD(Node);
  TargetCanvas.Font.Style := nd.Columns[Column].FontStyles;
  TargetCanvas.Font.Color := nd.Columns[Column].FontColor;
end;
{$ENDREGION}

end.
