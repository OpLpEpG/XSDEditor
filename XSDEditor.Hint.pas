unit XSDEditor.Hint;

interface

uses System.SysUtils, System.Classes, System.Types, System.Variants, Vcl.Graphics, VirtualTrees, System.Rtti,
     Vcl.Forms,Vcl.Themes, Vcl.GraphUtil, System.RegularExpressions;

procedure ConnectXSDTreeHintAdapter(form: TForm);

implementation

uses XSDEditor, CsToPas, CsToPasTools, XSDTreeData, EditorLink.Base;

{$REGION 'AnyStyleText'}
type
 TAnyStyleText = record
  cx,cy: Integer;
  Styles: TFontStyles;
  Color: TColor;
  text: string;
 end;

 TAnyStyleLine = record
  Level: Integer;
  Items: TArray<TAnyStyleText>;
  cx,cy: Integer;
  procedure UpdateWidth(canvas: TCanvas; tabLen: Integer = 16);
  procedure Paint(canvas: TCanvas; left, top: Integer; tabLen: Integer = 16);
  procedure Add(const text: string; Color: TColor = clBlack; Styles: TFontStyles =[]);
 end;

{ TAnyStyleLine }

procedure TAnyStyleLine.Add(const text: string; Color: TColor; Styles: TFontStyles);
 var
  st: TAnyStyleText;
begin
  st.Styles := Styles;
  st.Color := Color;
  st.text := text + ' ';
  st.cx := 0;
  st.cy := 0;
  Items := Items + [st];
end;

procedure TAnyStyleLine.Paint(canvas: TCanvas; left, top: Integer; tabLen: Integer);
begin
  var x := left + tabLen*level;
  for var st in Items do
   begin
    canvas.Font.Style := st.Styles;
    canvas.Font.Color := st.Color;
    canvas.TextOut(x, top, st.text);
    x := x + st.cx;
   end;
end;

procedure TAnyStyleLine.UpdateWidth(canvas: TCanvas; tabLen: Integer);
begin
  cx := tabLen*level;
  cy := 0;
  for var i := 0 to High(Items) do
   begin
    canvas.Font.Style := Items[i].Styles;
    canvas.Font.Color := Items[i].Color;
    var tmp := canvas.TextExtent(Items[i].text);
    Items[i].cx := tmp.cx;
    Items[i].cy := tmp.cy;
    cx := cx + Items[i].cx;
    if Items[i].cy > cy then cy := Items[i].cy;
   end;
end;

{$ENDREGION}

type
 THintAdapter = class(TComponent)
 private
  Tree: TVirtualStringTree;
  Form: TFormXSD;
  outText: string;
  typeText: TArray<TAnyStyleLine>;
  procedure GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
  procedure DrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
  procedure GetHintKind(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
  procedure GetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
end;

{ THintAdapter }

function GetAnnotationEx(e: TTypedTreeData; ParentTypeAnnotation: Boolean = False;
         const IgnoreItems: TArray<string> = []): TArray<string>;
  procedure AddDocumentation(SchemaItem: IXmlSchemaAnnotated; const Pre: string = '');
  begin
    var s := string(SchemaItem.GetAnnotation);
     if s <> '' then Result :=  Result + [Pre + TRegEx.Replace(s, '\s+', ' ').Trim]
  end;
  function IsIgnore(ann: IXmlSchemaType): Boolean;
  begin
    for var s in IgnoreItems do if SameStr(ann.QualifiedName.Name, s) then Exit(True);
    Result := False;
  end;
begin
  Result := [];
  if not IsIgnore(e.SchemaType) then AddDocumentation(e.Annotated);
  var Dt := e.SchemaType;
  while Assigned(Dt) do
   begin
    if not IsIgnore(dt) then AddDocumentation(Dt as IXmlSchemaAnnotated, string(Dt.QualifiedName.Name)+' : ');
    if ParentTypeAnnotation then Dt := Dt.BaseXmlSchemaType else Dt := nil;
   end;
end;


procedure THintAdapter.DrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
 var
  top :Integer;
begin
  if not (Column in [COLL_TREE, COLL_VAL, COLL_TYPE]) then Exit;
  //
  InflateRect(R, -1, -1); // Fixes missing border when VCL styles are used
  if Column = COLL_VAL then
       GradientFillCanvas(HintCanvas, clWebLightPink, GetHighLightColor(clWebLightPink), R, gdVertical)
  else GradientFillCanvas(HintCanvas, clInfoBk, GetHighLightColor(clInfoBk), R, gdVertical);
  InflateRect(R, -4, -4); // Fixes missing border when VCL styles are used
  top := R.Top;
  if Column <> COLL_TYPE then
       HintCanvas.TextRect(R, outText, [tfWordBreak])
  else for var s in typeText do
   begin
    s.Paint(HintCanvas, r.Left, top);
    top := top + s.cy;
   end;
end;

procedure THintAdapter.GetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
begin
  HintText := ' '
end;

procedure THintAdapter.GetHintKind(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
begin
  Kind := vhkOwnerDraw;
end;

type
  TLevelHistorySimpleFunc = reference to procedure (level: Integer; Simple: IXmlSchemaSimpleType);

procedure WolkHistoryLevel(level: Integer; Root: IXmlSchemaSimpleType; func: TLevelHistorySimpleFunc);
 procedure Recur(lvl: Integer; st: IXmlSchemaSimpleType);
  var
   u: IXmlSchemaSimpleTypeUnion;
   t: IXmlSchemaType;
 begin
   t := st as IXmlSchemaType;
   func(lvl, st);
   inc(lvl);
   if Supports(st.Content, IXmlSchemaSimpleTypeUnion, u) then
     for var i := 0 to u.Count-1 do Recur(lvl, u[i])
   else
     if Assigned(t.BaseXmlSchemaType) then Recur(lvl, t.BaseXmlSchemaType as IXmlSchemaSimpleType);
 end;
begin
  Recur(level, Root);
end;

procedure THintAdapter.GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
 var
  nd: TTypedTreeData;
begin
  if not (Column in [COLL_TREE, COLL_VAL, COLL_TYPE]) then Exit;
  var MAXCLIENTW := Form.Width div 2 - 10;
  if GetTD(Node) is TTypedTreeData then  nd := GetTD(Node) as TTypedTreeData
  else Exit;
  Form.Canvas.Font := Screen.HintFont;
  case Column of
    COLL_TREE:
     begin
      outText := '';
      var tmpWidth := 0;
      for var ann in GetAnnotationEx(nd, true, Form.IgnoreAnnotations) do
       begin
        var w := Form.Canvas.TextWidth(ann);
        if W > tmpWidth then
         if W > MAXCLIENTW then tmpWidth := MAXCLIENTW
         else tmpWidth := W;
        outText := outText + ann + #$D#$A#$D#$A;
       end;
      outText := outText.Trim;
      if outText = '' then R := R.Empty
      else
       begin
        R.Width := tmpWidth;
        R.Height := -Screen.HintFont.Height;
        Form.Canvas.TextRect(R, outText, [tfWordBreak, tfCalcRect]);
        InflateRect(R, 5, 5);
       end;
     end;
    COLL_VAL:
    begin
     outText := nd.Columns[COLL_VAL].ValidateErrorMsg;
      if outText = '' then R := R.Empty
      else
       begin
        R.Width := Form.Canvas.TextWidth(outText);
        if R.Width > MAXCLIENTW then R.Width := MAXCLIENTW;
        R.Height := -Screen.HintFont.Height;
        Form.Canvas.TextRect(R, outText, [tfWordBreak, tfCalcRect]);
        InflateRect(R, 5, 5);
       end;
    end;
    COLL_TYPE:
     begin
      typeText := [];
      var level := 0;
      var tmpZ := Tsize.Create(0,0);

      var AddComplexHictory := function(c: IXmlSchemaComplexType): IXmlSchemaSimpleType
      begin
        Result := nil;
        var t := c as IXmlSchemaType;
        while Assigned(c) do
         begin
          var l: TAnyStyleLine;
          l.Level := level;
          inc(level);
          if c.IsAbstract then l.Add(t.QualifiedName.Name, clRed) else
          if Supports(t.BaseXmlSchemaType, IXmlSchemaSimpleType, Result) then
               l.Add(t.QualifiedName.Name, clBlue, [fsBold])
          else l.Add(t.QualifiedName.Name, clBlue);
          l.Add(CtToString(c.ContentTypeParticle), clMaroon, [fsItalic]);
          l.Add(CmToString(c), clMaroon, [fsItalic]);
          l.UpdateWidth(Form.Canvas);
          if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
          tmpZ.cy := tmpZ.cy + l.cy;
          typeText :=  typeText + [l];
          t := t.BaseXmlSchemaType;
          Supports(t, IXmlSchemaComplexType, c);
         end;
      end;

      var AddAtomic := procedure(nda: TTypedTreeData)
      begin
        if (Assigned(nda.Complex) and (nda.Complex.ContentType = scTextOnly)) or Assigned(nda.Simple)  then
         begin
          var s := nda.Simple;
          if not Assigned(s) then s := AddComplexHictory(nda.Complex);
          WolkHistoryLevel(level, s, procedure (lvl: Integer; a: IXmlSchemaSimpleType)
            procedure AddFacet(const name, value: string);
            begin
              var l: TAnyStyleLine;
              l.Level := lvl;
              l.Add(name, clOlive, [fsBold]);
              l.Add('=', clBlack, [fsBold]);
              l.Add(value, clRed, [fsBold]);
  //              ss.Add(name + '=' + f);
              l.UpdateWidth(Form.Canvas);
              if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
              tmpZ.cy := tmpZ.cy + l.cy;
              typeText :=  typeText + [l];
            end;
            procedure AddAtomic(fs: IXmlSchemaObjectCollection);
            begin
              if fs.Count > 1 then AddFacet('Enumeration:Count', fs.Count.ToString)
              else for var f in XFacets(fs) do AddFacet(FacetToString(f.FacetType), f.Value)
            end;
          begin
            var l: TAnyStyleLine;
            l.Level := lvl;
            var t := a as IXmlSchemaType;
            var sname := t.QualifiedName.Name;
            if sname = '' then sname := 'anonymous';
            var fs: TFontStyles := [];
            if lvl = 0 then fs := [fsBold];
            if not Assigned(t.BaseXmlSchemaType) then l.Add(sname, clGreen, fs)
            else if t.Variety = dvUnion then l.Add(sname, clFuchsia, fs)
            else if sname = 'anonymous' then l.Add(sname, clRed, fs)
            else l.Add(sname, clblack, fs);
            l.Add(DmToString(t.DerivedBy), clMaroon, [fsItalic]);

            l.UpdateWidth(Form.Canvas);
            if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
            tmpZ.cy := tmpZ.cy + l.cy;
            typeText :=  typeText + [l];

            var rs: IXmlSchemaSimpleTypeRestriction;
            if Supports(a.Content, IXmlSchemaSimpleTypeRestriction, rs) then AddAtomic(rs.Facets);
          end);
         end
        else
         begin
          AddComplexHictory(nda.Complex);
         end;
       end;

      if nd is TChoiceElem then
       begin
         var ce := nd as TChoiceElem;
         var savec := ce.Current;
         for var i := 0 to ce.Count-1 do
          begin
           ce.Current := i;
           level := 0;
           AddAtomic(nd);
          end;
         ce.Current := savec;
       end
      else AddAtomic(nd);
      R.Size := tmpZ;
      InflateRect(R, 5, 5);
     end;
  end;  //}
end;

procedure ConnectXSDTreeHintAdapter(form: TForm);
begin
  var h := THintAdapter.Create(form);
  h.Form := form as TFormXSD;
  h.Tree := h.Form.Tree;
  h.Tree.OnGetHintKind := h.GetHintKind;
  h.Tree.OnGetHintSize := h.GetHintSize;
  h.Tree.OnDrawHint := h.DrawHint;
  h.Tree.OnGetHint := h.GetHint;
end;

end.
