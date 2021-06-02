 unit XSDEditor.Setup;

interface

uses  System.IOUtils, JvFormPlacement,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtCtrls, JvBaseDlg,
  JvSelectDirectory, Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.Components;

type
  TFormSetup = class(TForm)
    Label3: TLabel;
    cbUseUserPath: TCheckBox;
    edFileSch: TJvFilenameEdit;
    edDirSch: TJvDirectoryEdit;
    edDirXML: TJvDirectoryEdit;
    BindingsList: TBindingsList;
    LinkControlToPropertyEnabled: TLinkControlToProperty;
    cbUserSchema: TCheckBox;
    LinkControlToPropertyEnabled2: TLinkControlToProperty;
    procedure edDirXMLChange(Sender: TObject);
    procedure edDirSchChange(Sender: TObject);
    procedure edFileSchChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function GetStorage: TJvFormStorage;
    { Private declarations }
  public
    property Storage: TJvFormStorage read GetStorage;
  end;

var
  FormSetup: TFormSetup;

implementation

uses
  XSDEditor;

{$R *.dfm}

function TFormSetup.GetStorage: TJvFormStorage;
begin
  Result := FormXSD.Storage;
end;

procedure TFormSetup.FormShow(Sender: TObject);
begin
  edDirSch.Directory := Storage.StoredValue['SCHEMA_DIR'];
  edDirXML.Directory := Storage.StoredValue['FILE_DIR'];
  edFileSch.FileName := Storage.StoredValue['SCHEMA_FILE'];
  //edFile.FileName := Storage.StoredValue['FILE_NAME'];
end;

procedure TFormSetup.edDirSchChange(Sender: TObject);
begin
  if TDirectory.Exists(edDirSch.Directory) then
   begin
    Storage.StoredValue['SCHEMA_DIR'] := edDirSch.Directory;
   end;
end;

procedure TFormSetup.edDirXMLChange(Sender: TObject);
begin
  if TDirectory.Exists(edDirXML.Directory) then
   begin
    Storage.StoredValue['FILE_DIR'] := edDirXML.Directory;
   end;
end;

procedure TFormSetup.edFileSchChange(Sender: TObject);
begin
  if TFile.Exists(edFileSch.FileName) then
   begin
    Storage.StoredValue['SCHEMA_FILE'] := edFileSch.FileName;
   end;
end;

end.
