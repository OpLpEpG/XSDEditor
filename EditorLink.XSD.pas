unit EditorLink.XSD;

interface

uses SysUtils, XmlSchema, Vcl.StdCtrls, System.Variants, Mask, Timespan,
     System.RegularExpressions, System.UITypes, Types,
     VirtualTrees, Soap.XSBuiltIns,  Vcl.ComCtrls, System.DateUtils, Vcl.Graphics,
     EditorLink.Base, XSDTreeData, CsToPas, CsToPasTools;

{The time zone in which the well is located.
It is the deviation in hours and minutes from UTC.
This should be the normal time zone at the well and not a seasonally-adjusted value,
such as daylight savings time.
[Z]|([\-+](([01][0-9])|(2[0-3])):[0-5][0-9])   }

//YYYY-MM-DDThh:mm:ssZ[+/-]hh:mm
type
  TXSDEditLink = class(TTreeEditLink)
  protected
//    FPattern: string;
//    procedure CreatePickStringEditor(); override;
//    function  EndPickStringEditor(): string; override;
//    procedure CreateRegExEditor(); override;
//    procedure SetBounds(R: TRect); override; stdcall;
//    function ValidateNewData(var Value: Variant): Boolean; override;
//    procedure DoCheckValidateNewDataError(); override;
//    procedure CreateDateTimeEditor(); override;
//    function  EndDateTimeEditor(): string; override;
//    class var FLastHistory: THistory;
//    class var FLastBuildInTypes: TArray<baseXSD>;
//    procedure OnRegexChange(Sender: TObject);
  public
    class function GetEditorType(SchemaType: IXmlSchemaType): TDataEditorClass; virtual;
  end;
  TXSDEditLinkClass = class of TXSDEditLink;

  TRegExEditor = class(TDataEditor)
   FPattern: string;
   procedure OnRegexChange(Sender: TObject);
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
  end;

  TXSDateTimeEditor = class(TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure GetNewData(); override;
  end;

  TPickStringEditorBase = class abstract (TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure GetNewData(); override;
  end;

  TAbstractTypeEditor = class(TPickStringEditorBase)
    FAbsElem: TAbstractElem;
    constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
    procedure GetNewData(); override;
  end;

  TChoiceTypeEditor = class(TPickStringEditorBase)
    FcElem: TChoiceElem;
    constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
    procedure GetNewData(); override;
  end;

  TFacetEnumEditor = class (TPickStringEditorBase)
    Fenum: TTypedTreeData;
    constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
  end;

  TUnionEditor = class(TStringEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure GetNewData(); override;
  end;

procedure GetIVTEditLink(out VTEditLink: IVTEditLink);

var
  GlobalXSDEditLinkClass: TXSDEditLinkClass = TXSDEditLink;

implementation

uses Winapi.CommCtrl, Vcl.Controls, AnnotatedStringEditor;

type
  TMyDateTimePicker = class(TDateTimePicker)
  private
   FChange: Boolean;
   procedure CNNotify(var Message: TWMNotifyDT); message CN_NOTIFY;
  end;

{ TMyDateTimePicker }

procedure TMyDateTimePicker.CNNotify(var Message: TWMNotifyDT);
begin
  with Message, NMHdr{$IFNDEF CLR}^{$ENDIF}, NMDateTimeChange{$IFNDEF CLR}^{$ENDIF} do
   begin
    Result := 0;
    if (code = DTN_DATETIMECHANGE) and not DroppedDown and (dwFlags = GDT_VALID) and not FChange then
     begin
      FChange := True;
      var dt := SystemTimeToDateTime(st);
      if dt <> DateTime then DateTime := dt;
      FChange := False;
     end
    else inherited;
  end;
end;

function CheckFacetEnum(st: IXmlSchemaSimpleType): Boolean;
 var
  r: IXmlSchemaSimpleTypeRestriction;
begin
  Result :=  Supports(st.Content, IXmlSchemaSimpleTypeRestriction, r) and (r.Facets.Count > 1);
end;

function FacetPattern(st: IXmlSchemaSimpleType): string;
 var
  r: IXmlSchemaSimpleTypeRestriction;
begin
  Result := '';
  if Supports(st.Content, IXmlSchemaSimpleTypeRestriction, r) and (r.Facets.Count = 1) then
   for var f in XFacets(r.Facets) do
     if f.FacetType = sfPattern then Exit(f.Value)
end;

procedure GetIVTEditLink(out VTEditLink: IVTEditLink);
begin
  VTEditLink := GlobalXSDEditLinkClass.Create;
end;

{ TXSDEditLink }

//procedure TXSDEditLink.CreateRegExEditor;
// var
//  nd: PNodeExData;
//  dt: IXMLTypeDef;
//begin
//  nd := FNode.GetData;
//  dt := (nd.node as IXMLTypedSchemaItem).DataType;
//  WolkHistorySimple(HistoryHasValue(dt).BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
//  begin
//    if not VarIsNull(st.Pattern) then FPattern := st.Pattern;
//    Result := False;
//  end);
//  FEdit := TEdit.Create(nil);
//  with FEdit as TEdit do
//  begin
//    Visible := False;
//    Parent := FTree;
//    OnChange := OnRegexChange;
//    Text := nd.Columns[FColumn].Value;
//    OnKeyDown := EditKeyDown;
//    OnKeyUp := EditKeyUp;
//  end;
//end;

//procedure TXSDEditLink.DoCheckValidateNewDataError;
//begin
//  if GetValidateError.ErrorString <>'' then raise Exception.Create(GetValidateError.ErrorString);
//end;

function DateTimeToISOTime(Value: TDateTime; ApplyLocalBias: Boolean = True): string;
const
  Neg: array[Boolean] of string=  ('+', '-');
var
  Bias: Integer;
  tz:TTimeZone;
begin
  Result := FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss', Value); { Do not localize }
  tz := TTimeZone.Local;
  Bias := Trunc(tz.GetUTCOffset(Value).Negate.TotalMinutes);
  if (Bias <> 0) and ApplyLocalBias then
  begin
    Result := Format('%s%s%.2d:%.2d', [Result, Neg[Bias > 0],                         { Do not localize }
                                       Abs(Bias) div MinsPerHour,
                                       Abs(Bias) mod MinsPerHour]);
  end else
    Result := Result + 'Z'; { Do not localize }
end;

class function TXSDEditLink.GetEditorType(SchemaType: IXmlSchemaType): TDataEditorClass;
 var
  Res: TDataEditorClass;
  st: IXmlSchemaSimpleType;
begin
  Res := nil;
  while not Supports(SchemaType, IXmlSchemaSimpleType,  st) do SchemaType := SchemaType.BaseXmlSchemaType;
  if not Assigned(st.Content) then raise Exception.Create('Error Message');
  if SchemaType.TypeCode in XSTypeDecimal then Res := TNumberEditor
  else if SchemaType.TypeCode in XSTimeData then Res := TXSDateTimeEditor //TDateTimeEditor
  else if SchemaType.TypeCode = tcBoolean then Res := TBooleanEditor
  else if SchemaType.TypeCode in [tcFloat, tcDouble] then Res := TFloatEditor
  else if SchemaType.TypeCode = tcAnyUri then  Res := TStringEditor
  else if CheckFacetEnum(st) then Res := TFacetEnumEditor
  else if FacetPattern(st) <> '' then Res := TRegExEditor
  else if SchemaType.TypeCode = tcAnyAtomicType then Res := TUnionEditor
  else if SchemaType.TypeCode in XSTypeString then Res := TStringEditor;
  Result := Res;
end;

{procedure TXSDEditLink.OnRegexChange(Sender: TObject);
 var
  nd: PNodeExData;
  dt: IXMLTypeDef;
  e: TEdit;
begin
  e := FEdit as TEdit;
  nd := FNode.GetData;
  dt := (nd.node as IXMLTypedSchemaItem).DataType;
  if not TRegEx.Match(e.Text, FPattern).Success then  e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;}

//procedure TXSDEditLink.SetBounds(R: TRect);
//var
//  Dummy: Integer;
//begin
//  if FEdit is TMemo then
//   begin
//    FTree.Header.Columns.GetColumnBounds(0, Dummy, R.Left);
//    FTree.Header.Columns.GetColumnBounds(COLL_COUNT-1, R.Right, Dummy);
//    R.Height := R.Height*4;
//    FEdit.BoundsRect := R;
//   end
//  else inherited;
//end;

//function TXSDEditLink.ValidateNewData(var Value: Variant): Boolean;
//begin
//  Result := True;
//  var nd := PNodeExData(FNode.GetData);
//  if (FColumn = COLL_VAL) then
//   begin
//    var s := VarToStr(Value).Trim;
//    if (s = '') or (s = '0') or (s = '0.00') or (s = '0.0') or (s = '0.000') then
//     begin
//      Value := '';
//      nd.Columns[COLL_VAL].Dirty := False;
//      Result := not nd.MastExists
//     end
//    else Result := ValidateData(PNodeExData(FNode.GetData).tip, Value)
//   end
//  else if (FColumn = COLL_TYPE) and (Value =  '') then Value := nd.Columns[COLL_TYPE].Value
//  else Result := inherited;
//end;


{ TPickStringEditorBase }

constructor TPickStringEditorBase.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
    Edit := TPickStringEditor.Create(nil);
    with Edit as TPickStringEditor do
    begin
     Visible := False;
     Parent := Tree;
     Text := Value.Value;
     OnKeyDown := Link.EditKeyDown;
     OnKeyUp := Link.EditKeyUp;
    end;
end;

procedure TPickStringEditorBase.GetNewData;
begin
  var pse := Edit as TPickStringEditor;
  FNewValue := pse.Text;
end;

constructor TAbstractTypeEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  FAbsElem := GetTD(FOwner.FNode) as TAbstractElem;
  with Edit as TPickStringEditor do
   begin
    for var ct in FAbsElem.FUserTypes do
        AddAnnotatedItem((ct as IXmlSchemaType).QualifiedName.Name, (ct as IXmlSchemaAnnotated).GetAnnotation);
    AdjustWidth(Tree.ClientWidth);
    ItemIndex := FAbsElem.FCurrent;
   end;
end;

procedure TAbstractTypeEditor.GetNewData;
begin
  var pse := FOwner.FEdit as TPickStringEditor;
  FAbsElem.FCurrent := pse.ItemIndex;
  if pse.ItemIndex < 0 then
   begin
    FNewValue := string(FAbsElem.SchemaType.QualifiedName.Name);
    FValue.FontColor := clRed;
   end
  else
   begin
    FNewValue := pse.Text;
    FValue.FontColor := clGreen;
   end;
  if FNewValue <> FValue.Value then
   begin
    FOwner.FTree.DeleteChildren(FOwner.FNode);
    FAbsElem.ChildAddToTree := False;
   end;
end;

{ TChoiceTypeEditor }

constructor TChoiceTypeEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  FcElem := GetTD(FOwner.FNode) as TChoiceElem;
  with Edit as TPickStringEditor do
   begin
    for var ce in XElements(FcElem.Choice.Items) do
        AddAnnotatedItem(ce.ElementSchemaType.QualifiedName.Name, (ce.ElementSchemaType as IXmlSchemaAnnotated).GetAnnotation);
    AdjustWidth(Tree.ClientWidth);
    ItemIndex := FcElem.Current;
   end;
end;

procedure TChoiceTypeEditor.GetNewData;
begin
  var pse := Edit as TPickStringEditor;
  if pse.ItemIndex < 0 then pse.ItemIndex := 0;
  FcElem.Current := pse.ItemIndex;
  FNewValue := pse.Text;
  if FNewValue <> FValue.Value then with FcElem do
   begin
    Tree.DeleteChildren(FOwner.FNode);
    ChildAddToTree := False;
    FValue.Value := string(Elem.QualifiedName.Name);
   end;
end;

{ TFacetEnumEditor }

constructor TFacetEnumEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
 var
  r: IXmlSchemaSimpleTypeRestriction;
begin
  inherited;
  Fenum := GetTD(FOwner.FNode) as TTypedTreeData;
  Supports(Fenum.Simple.Content, IXmlSchemaSimpleTypeRestriction, r);
  with Edit as TPickStringEditor do
   begin
     for var f in XFacets(r.Facets) do
        AddAnnotatedItem(f.Value, (f as IXmlSchemaAnnotated).GetAnnotation);
    AdjustWidth(FOwner.FTree.ClientWidth);
   end;
end;

{ TXSDateTimeEditor }

constructor TXSDateTimeEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
    Edit := TMyDateTimePicker.Create(nil);
    with Edit as TMyDateTimePicker do
    begin
      Visible := False;
      Parent := Tree;
      Format := 'yyyy-MM-dd HH:mm:ss';
      try
       if Value.Value = '' then DateTime := 0
       else DateTime := XMLTimeToDateTime(Value.Value);
      except
       Date := 0;
      end;
      OnKeyDown := Link.EditKeyDown;
      OnKeyUp := Link.EditKeyUp;
   end;
end;

procedure TXSDateTimeEditor.GetNewData;
begin
  if TMyDateTimePicker(FOwner.FEdit).Date = 0 then FNewValue := ''
  else FNewValue := DateTimeToISOTime(TMyDateTimePicker(FOwner.FEdit).DateTime);
end;

{ TUnionEditor }

constructor TUnionEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
 var
  u: IXmlSchemaSimpleTypeUnion;
  r: IXmlSchemaSimpleTypeRestriction;
begin
  inherited;
  var d := GetTD(FOwner.FNode) as TTypedTreeData;
  Supports(d.Simple.Content, IXmlSchemaSimpleTypeUnion, u);
  for var i := 0 to u.Count-1 do if CheckFacetEnum(u[i]) then
   begin
    Edit.Free;
    Edit := TPickStringEditor.Create(nil);
    with Edit as TPickStringEditor do
    begin
     Visible := False;
     Parent := Tree;
     Text := Value.Value;
     Supports(u[i].Content, IXmlSchemaSimpleTypeRestriction, r);
     for var f in XFacets(r.Facets) do
        AddAnnotatedItem(f.Value, (f as IXmlSchemaAnnotated).GetAnnotation);
     AdjustWidth(Tree.ClientWidth);
     OnKeyDown := Link.EditKeyDown;
     OnKeyUp :=  Link.EditKeyUp;
    end;
    Exit;
   end;
end;

procedure TUnionEditor.GetNewData;
begin
  if Edit is TPickStringEditor then
   begin
    var pse := Edit as TPickStringEditor;
    FNewValue := pse.Text;
   end
  else inherited;
end;

{ TRegExEditor }

constructor TRegExEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  var d := GetTD(Link.FNode) as TTypedTreeData;
  FPattern := FacetPattern(d.Simple);
  if FPattern = '' then raise Exception.Create('Error Message');
  Edit := TEdit.Create(nil);
  with Edit as TEdit do
   begin
    Visible := False;
    Parent := Tree;
    OnChange := OnRegexChange;
    Text := Value.Value;
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
   end;
end;

procedure TRegExEditor.OnRegexChange(Sender: TObject);
begin
  var e := Edit as TEdit;
  if not TRegEx.Match(e.Text, FPattern).Success then e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;

end.
