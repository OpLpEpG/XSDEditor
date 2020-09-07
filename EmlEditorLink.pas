unit EmlEditorLink;

interface

uses SysUtils, StdCtrls, XmlSchema, TreeEditor, XSDEditorLink, xsdtools, System.Variants,
     System.RegularExpressions, System.UITypes, System.Types,
     Vcl.ExtCtrls;

const EML_NS: TArray<string> =
['eml="http://www.energistics.org/energyml/data/commonv2"',
'gco="http://www.isotc211.org/2005/gco"',
'gmd="http://www.isotc211.org/2005/gmd"',
'gsr="http://www.isotc211.org/2005/gsr"',
'gts="http://www.isotc211.org/2005/gts"',
'gml="http://www.opengis.net/gml/3.2"',
'xlink="http://www.w3.org/1999/xlink"',
'xsi="http://www.w3.org/2001/XMLSchema-instance"'];

//'xsi:schemaLocation="http://www.energistics.org/energyml/data/witsmlv2 file:///C:/repositories/witsml/v2.0/xsd_schemas/Well.xsd"


type

 TEmlEditorLink = class (TXSDEditLink)
  protected
    procedure CreateUuidEditor;
    function EndUuidEditor: string;
    procedure OnLeftButton(Sender: TObject);
    procedure OnUuidChange(Sender: TObject);
    procedure SetBounds(R: TRect); override; stdcall;
  public
    procedure AfterConstruction; override;
    class function GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType; override;
 end;

 const
   etGUID = TEditType(100);

implementation

uses XSDEditor;

{ TEmlEditorLink }

procedure TEmlEditorLink.AfterConstruction;
begin
  inherited;
  RegisterEditor(etGUID, CreateUuidEditor, EndUuidEditor);
end;

procedure TEmlEditorLink.CreateUuidEditor;
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
  FEdit := TButtonedEdit.Create(nil);
  with FEdit as TButtonedEdit do
  begin
    Images := FTree.Images;
    LeftButton.ImageIndex := 23;
    LeftButton.Visible := True;
    OnLeftButtonClick := OnLeftButton;
    Visible := False;
    Parent := FTree;
    OnChange := OnUuidChange;
    Text := nd.Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

function TEmlEditorLink.EndUuidEditor: string;
begin
  Result := EndRegExEditor;
end;

class function TEmlEditorLink.GetEditorType(SimpleTypeElement: IXMLTypedSchemaItem): TEditType;
begin
  Result := inherited;
  if FLastHistory.BaseSimple.SimpleType.Name = 'String2000' then Result := etMemo
  else if FLastHistory.BaseSimple.SimpleType.Name = 'UuidString' then Result := etGUID
  else if FLastHistory.BaseSimple.SimpleType.Name = 'TimeStamp' then Result := etDate
end;

procedure TEmlEditorLink.OnLeftButton(Sender: TObject);
begin
  (FEdit as TButtonedEdit).Text := TGuid.NewGuid.ToString.Replace('{','').Replace('}','');
end;

procedure TEmlEditorLink.OnUuidChange(Sender: TObject);
 var
  nd: PNodeExData;
  dt: IXMLTypeDef;
  e: TButtonedEdit;
begin
  e := FEdit as TButtonedEdit;
  nd := FNode.GetData;
  dt := (nd.node as IXMLTypedSchemaItem).DataType;
  if not TRegEx.Match(e.Text, FPattern).Success then  e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;

procedure TEmlEditorLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  if FEdit is TButtonedEdit then
   begin
    R.Right := R.Left + 64 + Ftree.Canvas.TextExtent(TGuid.NewGuid.ToString.Replace('{','').Replace('}','')).cx;
    FEdit.BoundsRect := R;
   end
  else inherited;
end;

initialization

 GlobalXSDEditLinkClass := TEmlEditorLink;

end.
