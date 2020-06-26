program ProjectXSDEditor;

uses
  Vcl.Forms,
  XSDEditor in 'XSDEditor.pas' {FormXSD},
  TreeEditor in 'TreeEditor.pas',
  xsdtools in 'xsdtools.pas',
  XSDEditorLink in 'XSDEditorLink.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormXSD, FormXSD);
  Application.Run;
end.
