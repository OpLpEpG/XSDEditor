unit XSDEditorLink;

interface

uses SysUtils, XmlSchema, Vcl.StdCtrls, System.Variants, Mask, System.RegularExpressions, System.UITypes,
     VirtualTrees,
     xsdtools, TreeEditor;


procedure GetIVTEditLink(out VTEditLink: IVTEditLink);
function GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType;
function GetEditorUnionType(e: IXMLTypedSchemaItem): TArray<TEditType>;


implementation

uses XSDEditor;

type
  TXSDEditLink = class(TTreeEditLink)
  protected
    procedure CreatePickStringEditor(); override;
    procedure CreateRegExEditor(); override;
    function ValidateNewData(var Value: Variant): Boolean; override;
    procedure DoCheckValidateNewDataError(); override;
  private
   procedure OnRegexChange(Sender: TObject);
  end;

procedure GetIVTEditLink(out VTEditLink: IVTEditLink);
begin
  VTEditLink := TXSDEditLink.Create;
end;

function GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType;
 var
  Res: TEditType;
  h: THistory;
  abt: TArray<baseXSD>;
begin
  Res := etString;
  h := HistoryHasValue(SimpleTypeElement.DataType);

  abt := GetBuildInTypes(h.BaseSimple);

  if abt[0] in XSDTypeDecimal then Res := etNumber
  else if abt[0] in XSDTimeData then Res := etDate
  else if abt[0] = btBoolean then Res := etBoolean
  else if abt[0] in [btFloat, btDouble] then Res := etNumber;

  WolkHistorySimple(h.BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
  begin
    if st.Enumerations.Count>0 then
     begin
      Result := True;
      Res := etPickString;
     end
    else Result := False;
  end);
  Result := Res;
end;

function GetEditorUnionType(e: IXMLTypedSchemaItem): TArray<TEditType>;
begin
  Result := [etString, etString];
end;

{ TXSDEditLink }

procedure TXSDEditLink.CreateRegExEditor;
 var
  nd: PNodeExData;
  dt: IXMLTypeDef;
begin
  nd := FNode.GetData;
  dt := (nd.node as IXMLTypedSchemaItem).DataType;
  FEdit := TEdit.Create(nil);
  with FEdit as TEdit do
  begin
    Visible := False;
    Parent := FTree;
    OnChange := OnRegexChange;
    Text := nd.Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TXSDEditLink.DoCheckValidateNewDataError;
begin
  if GetValidateError.ErrorString <>'' then raise Exception.Create(GetValidateError.ErrorString);
end;

procedure TXSDEditLink.OnRegexChange(Sender: TObject);
 var
  nd: PNodeExData;
  dt: IXMLTypeDef;
  e: TEdit;
begin
  e := FEdit as TEdit;
  nd := FNode.GetData;
  dt := (nd.node as IXMLTypedSchemaItem).DataType;
  if not TRegEx.Match(e.Text, VarToStr(dt.Pattern)).Success then  e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;

function TXSDEditLink.ValidateNewData(var Value: Variant): Boolean;
begin
  if (FColumn = COLL_VAL) then
   begin
    var nd := PNodeExData(FNode.GetData);
    var s := VarToStr(Value).Trim;
    if s = '' then
     begin
      Value := '';
      nd.Columns[COLL_VAL].Dirty := False;
      Result := not nd.MastExists
     end
    else Result := ValidateData(PNodeExData(FNode.GetData).tip, Value)
   end
  else Result := inherited;
end;

procedure TXSDEditLink.CreatePickStringEditor;
 var
  nd: PNodeExData;
begin
  nd := FNode.GetData;
  FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do
  begin
    Visible := False;
    Parent := FTree;
    Text := nd.Columns[FColumn].Value;
    if Text <> '' then Items.Add(Text);
    case FColumn of
     COLL_VAL:
      begin
       WolkHistorySimple(HistoryHasValue(nd.tip).BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
       begin
         Result := st.Enumerations.Count > 0;
         if Result then for var e in TXSEnum<IXMLEnumeration>.XEnum(st.Enumerations) do Items.Add(e.Value);
       end);
      end;
     COLL_TYPE:
      begin
       if nd.nt = ntChoice then
         for var t in TXSEnum<IXMLElementDef>.XEnum((nd.node as IXMLElementCompositor).ElementDefs) do
            Items.Add(t.DataTypeName)
       else if nd.IsBaseAbstract then
        begin
         var a := FindAbstractChilds((nd.node as IXMLElementDef).DataType as IXMLComplexTypeDef);
         for var t in a do Items.Add(t.Name);
        end;
      end;
    end;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

end.
