unit XSDEditorLink;

interface

uses SysUtils, XmlSchema, Vcl.StdCtrls, System.Variants, Mask, System.RegularExpressions, System.UITypes, Types,
     VirtualTrees, Soap.XSBuiltIns,  Vcl.ComCtrls, System.DateUtils,
     xsdtools, TreeEditor;

{The time zone in which the well is located.
It is the deviation in hours and minutes from UTC.
This should be the normal time zone at the well and not a seasonally-adjusted value,
such as daylight savings time.
[Z]|([\-+](([01][0-9])|(2[0-3])):[0-5][0-9])   }

//YYYY-MM-DDThh:mm:ssZ[+/-]hh:mm
type
  TXSDEditLink = class(TTreeEditLink)
  protected
    FPattern: string;
    procedure CreatePickStringEditor(); override;
    function  EndPickStringEditor(): string; override;
    procedure CreateRegExEditor(); override;
    procedure SetBounds(R: TRect); override; stdcall;
    function ValidateNewData(var Value: Variant): Boolean; override;
    procedure DoCheckValidateNewDataError(); override;
    procedure CreateDateTimeEditor(); override;
    function  EndDateTimeEditor(): string; override;
    class var FLastHistory: THistory;
    class var FLastBuildInTypes: TArray<baseXSD>;
    procedure OnRegexChange(Sender: TObject);
  public
    class function GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType; virtual;
  end;
  TXSDEditLinkClass = class of TXSDEditLink;

procedure GetIVTEditLink(out VTEditLink: IVTEditLink);
//function GetEditorUnionType(e: IXMLTypedSchemaItem): TArray<TEditType>;

var
  GlobalXSDEditLinkClass: TXSDEditLinkClass = TXSDEditLink;

implementation

uses XSDEditor, Winapi.CommCtrl, Vcl.Controls, AnnotatedStringEditor;

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


procedure GetIVTEditLink(out VTEditLink: IVTEditLink);
begin
  VTEditLink := GlobalXSDEditLinkClass.Create;
end;


//function GetEditorUnionType(e: IXMLTypedSchemaItem): TArray<TEditType>;
//begin
//  Result := [etString, etString];
//end;

{ TXSDEditLink }

procedure TXSDEditLink.CreateRegExEditor;
 var
  nd: PNodeExData;
  dt: IXMLTypeDef;
begin
  nd := FNode.GetData;
  dt := (nd.node as IXMLTypedSchemaItem).DataType;
  WolkHistorySimple(HistoryHasValue(dt).BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
  begin
    if not VarIsNull(st.Pattern) then FPattern := st.Pattern;
    Result := False;
  end);
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
//  if GetValidateError.ErrorString <>'' then raise Exception.Create(GetValidateError.ErrorString);
end;

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

class function TXSDEditLink.GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType;
 var
  Res: TEditType;
begin
  Res := etString;
  FLastHistory := HistoryHasValue(SimpleTypeElement.DataType);
  FLastBuildInTypes := GetBuildInTypes(FLastHistory.BaseSimple);

  if FLastBuildInTypes[0] in XSDTypeDecimal then Res := etNumber
  else if FLastBuildInTypes[0] in XSDTimeData then Res := etDate
  else if FLastBuildInTypes[0] = btBoolean then Res := etBoolean
  else if FLastBuildInTypes[0] in [btFloat, btDouble] then Res := etFloat;

  var pattern := '';
  WolkHistorySimple(FLastHistory.BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
  begin
    if not VarIsNull(st.Pattern) then pattern := st.Pattern;

    if st.Enumerations.Count>0 then
     begin
      Result := True;
      Res := etPickString;
     end
    else Result := False;
  end);
  if (Res = etString) and (pattern <> '') then Result := etRegexEdit
  else Result := Res;
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
  if not TRegEx.Match(e.Text, FPattern).Success then  e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;

procedure TXSDEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  if FEdit is TMemo then
   begin
    FTree.Header.Columns.GetColumnBounds(0, Dummy, R.Left);
    FTree.Header.Columns.GetColumnBounds(COLL_COUNT-1, R.Right, Dummy);
    R.Height := R.Height*4;
    FEdit.BoundsRect := R;
   end
  else inherited;
end;

function TXSDEditLink.ValidateNewData(var Value: Variant): Boolean;
begin
  Result := True;
  var nd := PNodeExData(FNode.GetData);
  if (FColumn = COLL_VAL) then
   begin
    var s := VarToStr(Value).Trim;
    if (s = '') or (s = '0') or (s = '0.00') or (s = '0.0') or (s = '0.000') then
     begin
      Value := '';
      nd.Columns[COLL_VAL].Dirty := False;
      Result := not nd.MastExists
     end
    else Result := ValidateData(PNodeExData(FNode.GetData).tip, Value)
   end
  else if (FColumn = COLL_TYPE) and (Value =  '') then Value := nd.Columns[COLL_TYPE].Value
  else Result := inherited;
end;


procedure TXSDEditLink.CreateDateTimeEditor;
 var
  nd: PNodeExData;
begin
  nd := FNode.GetData;
  FEdit := TMyDateTimePicker.Create(nil);
  with FEdit as TMyDateTimePicker do
  begin
    Visible := False;
    Parent := FTree;
    Format := 'yyyy-MM-dd HH:mm:ss';
    try
     if nd.Columns[FColumn].Value = '' then DateTime := 0
     else DateTime := XMLTimeToDateTime(nd.Columns[FColumn].Value);
    except
     Date := 0;
    end;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

function TXSDEditLink.EndDateTimeEditor: string;
begin
  if TMyDateTimePicker(FEdit).Date = 0 then Result := ''
  else Result := DateTimeToISOTime(TMyDateTimePicker(FEdit).DateTime);
end;


function TXSDEditLink.EndPickStringEditor: string;
begin
  var pse := FEdit as TPickStringEditor;
  Result := pse.Text;
end;

  function _GetAnn(ann: IXMLSchemaNode): string;
  begin
    Result := GetDocumentation(ann as IXMLSchemaItem);
    Result := TRegEx.Replace(Result, '\s+', ' ').Trim;
  end;
procedure TXSDEditLink.CreatePickStringEditor;
 var
  nd: PNodeExData;
begin
  nd := FNode.GetData;
  FEdit := TPickStringEditor.Create(nil);
  with FEdit as TPickStringEditor do
  begin
    Visible := False;
    Parent := FTree;
    Text := nd.Columns[FColumn].Value;
//    if Text <> '' then Items.Add(Text);
    case FColumn of
     COLL_VAL:
      begin
       WolkHistorySimple(HistoryHasValue(nd.tip).BaseSimple, function (st: IXMLSimpleTypeDef): Boolean
       begin
         Result := st.Enumerations.Count > 0;
         if Result then
           for var e in TXSEnum<IXMLEnumeration>.XEnum(st.Enumerations) do
               AddAnnotatedItem(e.Value, _GetAnn(e));
         AdjustWidth(FTree.ClientWidth);
       end);
      end;
     COLL_TYPE:
      begin
       if nd.nt = ntChoice then
        begin
         for var t in TXSEnum<IXMLElementDef>.XEnum((nd.node as IXMLElementCompositor).ElementDefs) do
             AddAnnotatedItem(t.DataTypeName, _GetAnn(t));
        end
       else if nd.IsBaseAbstract then
        begin
         var a := FindAbstractChilds((nd.node as IXMLElementDef).DataType as IXMLComplexTypeDef);
         if Length(a) = 0 then AddAnnotatedItem(text, _GetAnn((nd.node as IXMLElementDef).DataType))
         else for var t in a do AddAnnotatedItem(t.Name, _GetAnn(t));
        end;
       AdjustWidth(FTree.ClientWidth);
      end;
    end;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

end.
