unit XSDTreeData.ReadWriteValidate;

interface

uses  System.SysUtils, System.Variants,
      Xml.XMLIntf, Xml.XMLDoc,
      VirtualTrees,
      XSDTreeData, CsToPas, CsToPasTools;

type
 /// <remarks>
 ///   заполняет VirtualTree при чтении XML файла+
 /// </remarks>
 TValidatorLoader = class(TInterfacedObject, IXMLValidatorCallBack)
 private
  Fthis: TXMLValidatorCallBack;
  procedure ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar); safecall;
  function GetSelf(): TXMLValidatorCallBack; safecall;
  procedure SetSelf(s: TXMLValidatorCallBack); safecall;
  function ToPC(s: Variant): PChar; inline;
  procedure AddErrorMsg(var Err: string);
  procedure SetText(tt: TTypedTreeData; const Val: string; sv: XmlSchemaValidity; const ErrMsg: string);
  procedure UpdateErrorMsg(const Err: string; var Res: string); inline;
  procedure Validate(e: IXMLNode);
 protected
  Fdoc: IXMLDocument;
  Froot: IXMLNode;
  FValidateErrorMsg: string;
  Tree: TBaseVirtualTree;
  Schema: IXmlSchemaSet;
  NameSpace: IXmlNamespaceManager;
  Validator: IXmlSchemaValidator;
  function GetIXmlSchemaSet(root: IXMLNode): IXmlSchemaSet;
  procedure UpdateNS(e: IXMLNode);
  procedure InitObjects;
  /// <remarks>
  ///  заполняет атрибуты данными
  ///  возвращает сообщение об ошибках заполнения атрибутов
  /// </remarks>
  function LoadAttributes(pv: PVirtualNode; node: IXMLNode): string;
  /// <remarks>
  ///  заполняет елементы данными
  ///  выбирает не абстрактный тип
  ///  создает множественные елементы
  ///  выбирает choice
  ///  запускает LoadElement; (рекурсия)
  ///  возвращает сообщение об ошибках заполнения
  /// </remarks>
  function LoadPaticles(pv: PVirtualNode; n: IXMLNode): string;
  /// <remarks>
  ///  происходит валидация методами IXmlSchemaValidator
  ///  визуальный объект TElemData создан, найден и выбран xsi:type
  ///  создаются и загружаются дочерние атрибуты if exists
  ///  проверяется, записывается значение or
  ///  елементы если комплексный тип (рекурсия LoadPaticles)
  /// </remarks>
  function LoadElement(e: TElemData; n: IXMLNode; const xsiType: string): string;
  function FindChild(root: PVirtualNode; n: IXMLNode): TTypedTreeData;
  procedure FindNS(const ns: string; var name: string; var Space: string);
  function FindUserType(n: IXMLNode): string; overload;
 public
  constructor Create(ATree: TBaseVirtualTree; ASchema: IXmlSchemaSet = nil; ANameSpace: IXmlNamespaceManager = nil);
  procedure Read(const FileName: string);
  property this: TXMLValidatorCallBack read GetSelf write SetSelf;
//   class procedure write(const FileName: string; Tree: TBaseVirtualTree; Schema: IXmlSchema = nil; NameSpace: IXmlNamespaceManager = nil);
//   class procedure validate(const FileName: string; Tree: TBaseVirtualTree; Schema: IXmlSchema = nil; NameSpace: IXmlNamespaceManager = nil);
 end;


implementation

uses EditorLink.Base;

{ TValidatorLoader }

constructor TValidatorLoader.Create(ATree: TBaseVirtualTree; ASchema: IXmlSchemaSet; ANameSpace: IXmlNamespaceManager);
begin
  Tree := ATree;
  Schema := ASchema;
  NameSpace := ANameSpace;
  Fdoc := NewXMLDocument();
  Fdoc.ParseOptions := [];//poResolveExternals, poValidateOnParse];
end;

procedure TValidatorLoader.Validate(e: IXMLNode);
 var
  xsiType: PChar;
  si: IXmlSchemaInfo;
begin
  NameSpace.PushScope;
  xsiType := nil;
  for var i := 0 to e.AttributeNodes.Count-1 do
    begin
     var a := e.AttributeNodes[i];
     var v := Pchar(string(a.NodeValue));
     var n := PChar(a.LocalName);
     var s := PChar(a.NamespaceURI);
     if s = XS_NS then
      if n = 'xmlns' then NameSpace.AddNamespace('', v)
      else NameSpace.AddNamespace(n, v)
     else if (s = XS_INST) and (n = 'type') then xsiType := v;
    end;
  var nm := PChar(e.LocalName);
  var sp := PChar(e.NamespaceURI);
  Validator.ValidateElement(nm,sp,si,xsiType,nil,nil,nil);
  // TODO: find correct curren Tree and fill empty child Tree
  for var i := 0 to e.AttributeNodes.Count-1 do
   begin
     var a := e.AttributeNodes[i];
     var v := Pchar(string(a.NodeValue));
     var n := PChar(a.LocalName);
     var s := PChar(a.NamespaceURI);
     if (s = XS_NS) or (s = XS_INST) then Continue;
     Validator.ValidateAttribute(n,s,v,si);
  // TODO: find and fill value to Tree
   end;
  Validator.ValidateEndOfAttributes(si);
  if e.IsTextElement then
   begin
    Validator.ValidateText(PChar(string(e.NodeValue)))
  // TODO:  fill value to Tree
   end
  else for var i := 0 to e.ChildNodes.Count-1 do
   begin
    Validate(e.ChildNodes[i]); // recur
   end;
  Validator.ValidateEndElement(si);
  // TODO:  fill value to Tree
  NameSpace.PopScope;
end;

procedure TValidatorLoader.AddErrorMsg(var Err: string);
begin
  UpdateErrorMsg(FValidateErrorMsg, Err);
  FValidateErrorMsg := '';
end;

procedure TValidatorLoader.UpdateErrorMsg(const Err: string; var Res: string);
begin
  if Err <> '' then
   if Res = '' then Res := Err
   else Res := Res + #$D#$A#$D#$A + Err;
end;

function TValidatorLoader.FindChild(root: PVirtualNode; n: IXMLNode): TTypedTreeData;
 var
  ns, s: string;
begin
  Result := nil;
  ns := n.NamespaceURI;
  s := n.LocalName;
  for var pv in Tree.ChildNodes(root) do
   begin
    var t := GetTD(pv);
    if t is TTypedTreeData then
     begin
      var tt := t as TTypedTreeData;
      if tt is TChoiceElem then
       begin
        for var e in (tt as TChoiceElem).Choices do
         if SameText(e.QualifiedName.Namespace, ns) and SameText(e.QualifiedName.Name, s) then Exit(tt);
       end
      else if (tt.NameSpace = ns) and (tt.Name = s) then Exit(tt);
     end;
   end;
end;

function TValidatorLoader.FindUserType(n: IXMLNode): string;
begin
  var a := n.AttributeNodes.FindNode('type', XS_INST);
  if Assigned(a) then Result := a.NodeValue
  else Result := '';
end;

procedure TValidatorLoader.FindNS(const ns: string; var name: string; var Space: string);
begin
  var qn := ns.Split([':'], TStringSplitOptions.ExcludeEmpty);
  if Length(qn) = 2 then
   begin
    Space := string(NameSpace.LookupNamespace(PChar(qn[0])));
    Name := qn[1];
   end
  else
   begin
    Name := qn[0];
    Space := string(NameSpace.LookupNamespace(''));
   end;
end;

function TValidatorLoader.GetIXmlSchemaSet(root: IXMLNode): IXmlSchemaSet;
 var
  a: TArray<Pchar>;
  inst, ninst: IXMLNode;
begin
  inst := root.AttributeNodes.FindNode(XS_INST_LOC, XS_INST);
  ninst := root.AttributeNodes.FindNode(XS_INST_NOLOC, XS_INST);
  SetLength(a,2);
  if Assigned(inst) then
   begin
    var s := string(inst.NodeValue).Split([' ', #$D#$A], TStringSplitOptions.ExcludeEmpty);
    a[0] := PChar(s[0]);
    a[1] := PChar(s[1]);
   end
  else if Assigned(ninst) then a[1] := PChar(string(ninst.NodeValue))
  else raise Exception.Create('Error schemaLocation noNamespaceSchemaLocation not found');
  GetXmlSchemaSet(Result);
  Result.AddValidationEventHandler(Self);
  Result.Add(a[0], a[1]);
  Result.Compile;
  if FValidateErrorMsg <> '' then raise Exception.Create(FValidateErrorMsg);
end;

function TValidatorLoader.GetSelf: TXMLValidatorCallBack;
begin
  Result := Fthis;
end;

procedure TValidatorLoader.InitObjects;
begin
  // check Schema
  if not Assigned(Schema) then
   begin
    Schema := GetIXmlSchemaSet(Froot);
    TTreeData.SchemaSet := Schema;
   end;
  // check namespace
  if not Assigned(NameSpace) then NameSpace := Schema.CreateNamespace();
  //  add validator
  if Assigned(Validator) then Validator.DelValidationEventHandler(self);  
  Validator := Schema.Validator(NameSpace);
  Validator.AddValidationEventHandler(Self);
end;

function TValidatorLoader.LoadAttributes(pv: PVirtualNode; node: IXMLNode): string;
 var
  si: IXmlSchemaInfo;
begin
  Result := '';
  for var i := 0 to node.AttributeNodes.Count-1 do
   begin
    var a := node.AttributeNodes[i];
    var v := Pchar(string(a.NodeValue));
    var n := PChar(a.LocalName);
    var s := PChar(a.NamespaceURI);
    if (s = XS_NS) or (s = XS_INST) then Continue;
    Validator.ValidateAttribute(n,s,v,si);
    var tt := FindChild(pv, a);
    if Assigned(tt) then SetText(tt, v, si.Validity, FValidateErrorMsg);
    AddErrorMsg(Result);
   end;
end;

function TValidatorLoader.LoadPaticles(pv: PVirtualNode; n: IXMLNode): string;
 var
  lastData: TElemData;
begin
  Result := '';
  lastData := nil;
  for var i := 0 to n.ChildNodes.Count-1 do
   begin
    var e := n.ChildNodes[i];
    var tt := FindChild(pv, e) as TElemData;

    // create second and next ManyExists update lastData
    if Assigned(tt) then
      if (tt = lastData) then
       begin
        var npv: PVirtualNode;
        if tt is TChoiceElem then npv := TChoiceElem.New(Tree, tt.Owner, (tt as TChoiceElem).Choice, True)
        else npv := AddElement(Tree, tt.Owner, tt.Elem, True);
        tt := GetTD(npv) as TElemData;
       end
       else lastData := tt;

    // select xsi:Type  TChoiceElem, TAbstractElem update Tree
    var ut :=  FindUserType(e);
    if (ut <> '') and Assigned(tt) and (tt is TUserSelectElem) then
     begin
      var Name, Space: string;
      FindNS(ut, Name, Space);
      (tt as TUserSelectElem).SetUserType(Name, Space);
      tt[COLL_TYPE].Value := Name;
      tt[COLL_TYPE].UpdateViewData(Tree, false);
     end;
    if not Assigned(tt) then
     begin
      var bpv := pv;
      if Assigned(lastData) then bpv := lastData.Owner;
      var bv := 'BAD ELEMENT';
      if e.IsTextElement then bv := e.NodeValue;
      var dm := TBadData.Create(Tree,bpv, Assigned(lastData),e.LocalName, bv) as IStdData;
     end;
    // validate with xsi:Type
    NameSpace.PushScope;
    UpdateNS(e);
    UpdateErrorMsg(LoadElement(tt, e, ut), Result);
    NameSpace.PopScope;
   end;
end;

procedure TValidatorLoader.SetSelf(s: TXMLValidatorCallBack);
begin
  Fthis := s;
end;

procedure TValidatorLoader.SetText(tt: TTypedTreeData; const Val: string; sv: XmlSchemaValidity; const ErrMsg: string);
begin
  with tt[COLL_VAL] do
   begin
    Value := Val;
    IsValid := sv <> svInvalid;
    ValidateErrorMsg := ErrMsg;
    UpdateViewData(Tree, False);
   end;
end;

function TValidatorLoader.ToPC(s: Variant): PChar;
begin
  Result := PChar(string(s).Trim);
end;

procedure TValidatorLoader.UpdateNS(e: IXMLNode);
begin
  for var i := 0 to e.AttributeNodes.Count-1 do
   begin
    var a := e.AttributeNodes[i];
    if a.LocalName = 'xmlns' then NameSpace.AddNamespace('', ToPC(a.NodeValue))
    else if a.NamespaceURI = XS_NS then NameSpace.AddNamespace(ToPC(a.LocalName), ToPC(a.NodeValue));
   end;
end;

function TValidatorLoader.LoadElement(e: TElemData; n: IXMLNode; const xsiType: string): string;
 var
  info: IXmlSchemaInfo;
  val: string;
begin
  Result := '';
  val := '';
  var ns := PChar(n.NamespaceURI);
  var ln := PChar(n.LocalName);
  if xsiType = '' then Validator.ValidateElement(ln, ns, info, nil, nil,nil,nil)
  else Validator.ValidateElement(ln, ns, info, PChar(xsiType), nil,nil,nil);
  AddErrorMsg(Result);
  if Assigned(e) then
   begin
    e.ChildAddToTree := True;
    if Assigned(e.Complex) then
     begin
      // Add all avalable Attributes from schema
      AddAttributes(Tree, e.Owner, e.Complex);
      // fill any existing Attr
      UpdateErrorMsg(LoadAttributes(e.Owner, n), Result);
     end;
     Validator.ValidateEndOfAttributes(info);
     AddErrorMsg(Result);
    if e.Content = scTextOnly then
     begin
      if VarIsNull(n.NodeValue) then val := ''
      else val := n.NodeValue;
      Validator.ValidateText(PChar(val));
      AddErrorMsg(Result);
     end
    else
     begin
      // Add all avalable Paticles from schema
      AddPaticles(Tree, e.Owner, e.Complex);
      // load Part
      UpdateErrorMsg(LoadPaticles(e.Owner, n), Result);
     end;
   end;
  Validator.ValidateEndElement(info);
  AddErrorMsg(Result);
  if Assigned(e) then SetText(e, val, info.Validity, Result);
end;

procedure TValidatorLoader.ValidationCallback(SeverityType: XmlSeverityType; ErrorMessage: PChar);
begin
  UpdateErrorMsg(ErrorMessage, FValidateErrorMsg);
end;

procedure TValidatorLoader.Read(const FileName: string);
 var
  info: IXmlSchemaInfo;
  err: string;
begin
  Fdoc.LoadFromFile(FileName);
  Froot := Fdoc.DocumentElement;
  InitObjects;
  err := '';
  Tree.Clear;

  Validator.Initialize;

  NameSpace.PushScope;
  UpdateNS(Froot);
  Validator.ValidateElement(ToPC(Froot.LocalName), ToPC(Froot.NamespaceURI), info);
  AddErrorMsg(err);
  if info.Validity <> svInvalid then
   begin
    var pv := AddElement(Tree, nil, info.SchemaElement);
    var e := GetTD(pv) as TElemData;
    // Add all avalable Attributes from schema
    AddAttributes(Tree, pv, e.Complex);
    // fill any existing Attr
    UpdateErrorMsg(LoadAttributes(pv, Froot), err);
    Validator.ValidateEndOfAttributes(info);
    AddErrorMsg(err);
    // Add all avalable Paticles from schema
    AddPaticles(Tree, pv, e.Complex);
    e.ChildAddToTree := True;
    // load Part
    UpdateErrorMsg(LoadPaticles(pv, Froot), err);
    Validator.ValidateEndElement(info);
    AddErrorMsg(err);
    SetText(e, '', info.Validity, err);
   end
   else Validator.SkipToEndElement(info);
  NameSpace.PopScope;
  Validator.EndValidation;
 // if err <> '' then raise Exception.Create(err);
end;

end.
