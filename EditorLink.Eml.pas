unit EditorLink.Eml;

interface

uses  CsToPas,
      SysUtils, StdCtrls, XmlSchema, EditorLink.Base, EditorLink.XSD, System.Variants,
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
  public
    class function GetEditorType(SchemaType: IXmlSchemaType): TDataEditorClass; override;
 end;

   TUuidEditor = class(TRegExEditor)
   procedure OnRegexChange(Sender: TObject);
    procedure OnLeftButton(Sender: TObject);
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure SetBounds(var R: TRect); override;
  end;

implementation

uses XSDEditor;

{ TEmlEditorLink }

class function TEmlEditorLink.GetEditorType(SchemaType: IXmlSchemaType): TDataEditorClass;
begin
  if SchemaType.QualifiedName.Name = 'String2000' then Result := TMemoEditor
  else if SchemaType.QualifiedName.Name = 'UuidString' then Result := TUuidEditor
  else if SchemaType.QualifiedName.Name = 'TimeStamp' then Result := TXSDateTimeEditor
  else Result := inherited;
end;

{ TUuidEditor }

constructor TUuidEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  FreeAndNil(FOwner.FEdit);
  Edit := TButtonedEdit.Create(nil);
  with Edit as TButtonedEdit do
   begin
    Images := Tree.Images;
    LeftButton.ImageIndex := 46;
    LeftButton.Visible := True;
    OnLeftButtonClick := OnLeftButton;
    Visible := False;
    Parent := Tree;
    OnChange := OnRegexChange;
    Text := Value.Value;
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
   end;
end;

procedure TUuidEditor.OnLeftButton(Sender: TObject);
begin
  (Edit as TButtonedEdit).Text := TGuid.NewGuid.ToString.Replace('{','').Replace('}','');
end;

procedure TUuidEditor.OnRegexChange(Sender: TObject);
begin
  var e := Edit as TButtonedEdit;
  if not TRegEx.Match(e.Text, FPattern).Success then e.Font.Color := Tcolors.Red
  else e.Font.Color := Tcolors.Black;
end;

procedure TUuidEditor.SetBounds(var R: TRect);
var
  Dummy: Integer;
begin
  if Edit is TButtonedEdit then
   begin
    R.Right := R.Left + 64 + tree.Canvas.TextExtent(TGuid.NewGuid.ToString.Replace('{','').Replace('}','')).cx;
    Edit.BoundsRect := R;
   end
  else inherited;
end;

initialization

 GlobalXSDEditLinkClass := TEmlEditorLink;

end.
