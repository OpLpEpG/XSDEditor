program ProjectXSDEditor;

uses
  Vcl.Forms,
  XSDEditor in 'XSDEditor.pas' {FormXSD},
  EditorLink.Base in 'EditorLink.Base.pas',
  EditorLink.XSD in 'EditorLink.XSD.pas',
  XSDEditor.Hint in 'XSDEditor.Hint.pas',
  EditorLink.Eml in 'EditorLink.Eml.pas',
  AnnotatedStringEditor in 'AnnotatedStringEditor.pas',
  XSDTreeData in 'XSDTreeData.pas',
  CsToPasTools in 'CsToPasTools.pas',
  CsToPas in 'CsToPas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormXSD, FormXSD);
  Application.Run;
end.
