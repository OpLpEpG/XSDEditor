program ProjectXSDEditor;

uses
  Vcl.Forms,
  XSDEditor in 'XSDEditor.pas' {FormXSD},
  TreeEditor in 'TreeEditor.pas',
  xsdtools in 'xsdtools.pas',
  XSDEditorLink in 'XSDEditorLink.pas',
  XSDEditorHint in 'XSDEditorHint.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormXSD, FormXSD);
  Application.Run;
end.
