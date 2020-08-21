unit XSDEditorHint;

interface

uses System.SysUtils, System.Classes, System.Types, System.Variants, Vcl.Graphics, VirtualTrees, xsdtools,
     Xml.XmlSchema, Vcl.Forms,Vcl.Themes, Vcl.GraphUtil;

procedure ConnectXSDTreeHintAdapter(form: TForm);

implementation

uses XSDEditor;

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
//  procedure GetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
  procedure GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
  procedure DrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
  procedure GetHintKind(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
end;

{ THintAdapter }

procedure THintAdapter.DrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
 var
  top :Integer;
begin
  if not (Column in [COLL_TREE, COLL_TYPE]) then Exit;
  //
  InflateRect(R, -1, -1); // Fixes missing border when VCL styles are used
  GradientFillCanvas(HintCanvas, clInfoBk, GetHighLightColor(clInfoBk), R, gdVertical);
  InflateRect(R, -4, -4); // Fixes missing border when VCL styles are used
  top := R.Top;
  if Column = COLL_TREE then
       HintCanvas.TextRect(R, outText, [tfWordBreak])
  else for var s in typeText do
   begin
    s.Paint(HintCanvas, r.Left, top);
    top := top + s.cy;
   end;
end;

procedure THintAdapter.GetHintKind(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
begin
  Kind := vhkOwnerDraw;
end;

type
  TLevelHistorySimpleFunc = reference to procedure (level: Integer; Simple: IXMLSimpleTypeDef);

procedure WolkHistoryLevel(level: Integer; Root: TSimpleHistory; func: TLevelHistorySimpleFunc);
 procedure Recur(lvl: Integer; r: TSimpleHistory);
 begin
   func(lvl, r.SimpleType);
   inc(lvl);
   for var bt in r.BaseArray do Recur(lvl, bt);
 end;
begin
  Recur(level, Root);
end;

procedure THintAdapter.GetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
 var
  nd: PNodeExData;
begin
  if not (Column in [COLL_TREE, COLL_TYPE]) then Exit;
  var MAXCLIENTW := Form.Width div 2 - 10;
  nd := Tree.GetNodeData(Node);
  Form.Canvas.Font := Screen.HintFont;
  case Column of
    COLL_TREE:
     begin
      outText := '';
      var tmpWidth := 0;
      for var ann in GetAnnotationEx(nd.node, true, Form.IgnoreAnnotations) do
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
    COLL_TYPE:
     begin
      if nd.nt > ntAttr then Exit;
      typeText := [];
      var level := 0;
      var tmpZ := Tsize.Create(0,0);

      var AddComplexHictory := procedure(h : TComplexHistory)
      begin
        for var i:= High(h) downto 0 do
         begin
          var c := h[i];
          var l: TAnyStyleLine;
          l.Level := level;
          inc(level);
          if c.AbstractType then l.Add(c.Name, clRed) else
          if i = High(h) then l.Add(c.Name, clBlue, [fsBold])
          else l.Add(c.Name, clBlue);
          l.Add(SCM[c.ContentModel], clMaroon, [fsItalic]);
          l.Add(SDM[c.DerivationMethod], clMaroon, [fsItalic]);
          l.UpdateWidth(Form.Canvas);
          if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
          tmpZ.cy := tmpZ.cy + l.cy;
          typeText :=  typeText + [l];
         end;
      end;

      if TypeHasValue(nd.tip) then
       begin
        var h := HistoryHasValue(nd.tip);
        AddComplexHictory(h.ComplexTypes);
        WolkHistoryLevel(level, h.BaseSimple, procedure (lvl: Integer; a: IXMLSimpleTypeDef)
          procedure AddFacet(f: Variant; const name: string);
          begin
            if not VarIsNull(f) then
             begin
              var l: TAnyStyleLine;
              l.Level := lvl;
              l.Add(name, clOlive, [fsBold]);
              l.Add('=', clBlack, [fsBold]);
              l.Add(f, clRed, [fsBold]);
//              ss.Add(name + '=' + f);
              l.UpdateWidth(Form.Canvas);
              if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
              tmpZ.cy := tmpZ.cy + l.cy;
              typeText :=  typeText + [l];
             end;
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
            if tip.Enumerations.Count > 0 then AddFacet(tip.Enumerations.Count,'Enumeration:Count');

          end;
        begin
          var l: TAnyStyleLine;
          l.Level := lvl;
          var sname := '';
          if a.IsAnonymous then sname := 'anonymous'
          else sname := a.Name;
          var fs: TFontStyles := [];
          if lvl = 0 then fs := [fsBold];
          if a.IsBuiltInType then l.Add(sname, clGreen, fs)
          else if a.DerivationMethod = sdmUnion then l.Add(sname, clFuchsia, fs)
          else if sname = 'anonymous' then l.Add(sname, clRed, fs)                         
          else l.Add(sname, clblack, fs); 
          l.Add(SSDM[a.DerivationMethod], clMaroon, [fsItalic]);
               
          l.UpdateWidth(Form.Canvas);
          if tmpZ.cx < l.cx then tmpZ.cx := l.cx;
          tmpZ.cy := tmpZ.cy + l.cy;
          typeText :=  typeText + [l];

          AddAtomic(a);
        end);
       end
      else AddComplexHictory(HistoryComplex(nd.tip));

      R.Size := tmpZ;
      InflateRect(R, 5, 5);
     end;
  end;
end;

procedure ConnectXSDTreeHintAdapter(form: TForm);
begin
  var h := THintAdapter.Create(form);
  h.Form := form as TFormXSD;
  h.Tree := h.Form.Tree;
  h.Tree.OnGetHintKind := h.GetHintKind;
  h.Tree.OnGetHintSize := h.GetHintSize;
  h.Tree.OnDrawHint := h.DrawHint;
//  h.Tree.OnGetHint := h.GetHint;
end;

end.
