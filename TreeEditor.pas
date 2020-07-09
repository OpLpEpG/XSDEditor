unit TreeEditor;

// Utility unit for the advanced Virtual Treeview demo application which contains the implementation of edit link
// interfaces used in other samples of the demo.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualTrees, ExtDlgs, ImgList, Buttons, ExtCtrls, ComCtrls,
  Mask, JvSpin;

type
  // Describes the type of value a property tree node stores in its data property.
  TEditType = (
    etNone,
    etString,
    etPickString,
    etRegexEdit,
    etNumber,
    etFloat,
    etBoolean,
    etMemo,
    etDate,
    etUnion);

//----------------------------------------------------------------------------------------------------------------------
   // Node data record for the the document properties treeview.

  PColumnData = ^TColumnData;
  TColumnData = record
    EditType: TEditType;
    Value: Variant;
    Dirty: Boolean;
    Valid: Boolean;
  end;

  PStdData = ^TStdData;
  TStdData = record
    Columns: TArray<TColumnData>;
  end;

  PEditDataHistory = ^TEditDataHistory;
  TEditDataHistory = record
    Node: PVirtualNode;       // The node being edited.
    Column: Integer;          // The column of the node being edited.
    Value: Variant;
    Dirty: Boolean;
    Valid: Boolean;
  end;

  TCreateEditor = procedure of object;
  TEndEditor = function: string of object;
  TEditorFunction = record
    EditType: TEditType;
    CreateEditor: TCreateEditor;
    EndEditor: TEndEditor;
  end;
  // Our own edit link to implement several different node editors.
  TTreeEditLink = class(TInterfacedObject, IVTEditLink)
  protected
    FEdit: TWinControl;        // One of the property editor classes.
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
    FEditorFunction:TArray<TEditorFunction>;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); virtual; stdcall;
    function ValidateNewData(var Value: Variant): Boolean; virtual;
    procedure CreateMemoEditor(); virtual;
    function  EndMemoEditor(): string; virtual;
    procedure CreateNumberEditor(); virtual;
    function  EndNumberEditor(): string; virtual;
    procedure CreateFloatEditor(); virtual;
    function  EndFloatEditor(): string; virtual;
    procedure CreateStringEditor(); virtual;
    function  EndStringEditor(): string; virtual;
    procedure CreatePickStringEditor(); virtual;
    function  EndPickStringEditor(): string; virtual;
    procedure CreateRegExEditor(); virtual;
    function  EndRegExEditor(): string; virtual;
    procedure CreateBooleanEditor(); virtual;
    function  EndBooleanEditor(): string; virtual;
    procedure CreateDateTimeEditor(); virtual;
    function  EndDateTimeEditor(): string; virtual;
    procedure CreateUnionEditor(); virtual;
    function  EndUnionEditor(): string; virtual;
    procedure DoCheckValidateNewDataError(); virtual;
  public
    procedure RegisterEditor(EditType: TEditType; CreateEditor: TCreateEditor; EndEditor: TEndEditor);
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

//----------------- TPropertyEditLink ----------------------------------------------------------------------------------

// This implementation is used in VST3 to make a connection beween the tree
// and the actual edit window which might be a simple edit, a combobox
// or a memo etc.



destructor TTreeEditLink.Destroy;

begin
  //FEdit.Free; casues issue #357. Fix:
  if Assigned(FEdit) and FEdit.HandleAllocated then
    PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
  inherited;
end;

procedure TTreeEditLink.DoCheckValidateNewDataError;
begin

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  CanAdvance := true;
  case Key of
    VK_ESCAPE:
      begin
        Key := 0;//ESC will be handled in EditKeyUp()
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;
    VK_UP,
    VK_DOWN:
      begin
        // Consider special cases before finishing edit mode.
        CanAdvance := Shift = [];
        if FEdit is TComboBox then
          CanAdvance := CanAdvance and not TComboBox(FEdit).DroppedDown;
        if FEdit is TDateTimePicker then
          CanAdvance :=  CanAdvance and not TDateTimePicker(FEdit).DroppedDown;

        if CanAdvance then
        begin
          // Forward the keypress to the tree. It will asynchronously change the focused node.
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

procedure TTreeEditLink.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;//VK_ESCAPE
  end;//case
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.AfterConstruction;
begin
  inherited;
  RegisterEditor(etString, CreateStringEditor, EndStringEditor);
  RegisterEditor(etPickString, CreatePickStringEditor, EndPickStringEditor);
  RegisterEditor(etRegexEdit, CreateRegexEditor, EndRegexEditor);
  RegisterEditor(etNumber, CreateNumberEditor, EndNumberEditor);
  RegisterEditor(etFloat, CreateFloatEditor, EndFloatEditor);
  RegisterEditor(etBoolean, CreateBooleanEditor, EndBooleanEditor);
  RegisterEditor(etMemo, CreateMemoEditor, EndMemoEditor);
  RegisterEditor(etDate, CreateDateTimeEditor, EndDateTimeEditor);
  RegisterEditor(etUnion, CreateUnionEditor, EndUnionEditor);
end;

function TTreeEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTreeEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTreeEditLink.EndEdit: Boolean;
var
  Data: PStdData;
  Buffer: array[0..1024] of Char;
  S: UnicodeString;
  V: Variant;
begin
  Result := True;

  Data := FNode.GetData();
  for var x in FEditorFunction do
   if Data.Columns[FColumn].EditType = x.EditType then
    begin
     S := x.EndEditor();
     Break;
    end;
  s := s.Trim;
  if not SameStr(S, Data.Columns[FColumn].Value) then
   begin
    V := S;
    Data.Columns[FColumn].Dirty := True;
    Data.Columns[FColumn].Valid := ValidateNewData(V);
    Data.Columns[FColumn].Value := V;
    FTree.InvalidateNode(FNode);
   end;
  FEdit.Hide;
  FTree.SetFocus;
  DoCheckValidateNewDataError();
end;

function TTreeEditLink.EndBooleanEditor: string;
begin
  Result := EndStringEditor;
end;

function TTreeEditLink.EndDateTimeEditor: string;
begin
  if TDateTimePicker(FEdit).Date = 0 then Result := ''
  else Result := DateToStr(TDateTimePicker(FEdit).Date);
end;

function TTreeEditLink.EndFloatEditor: string;
begin
  Result := (FEdit as TJvSpinEdit).Text;
end;

function TTreeEditLink.EndMemoEditor: string;
begin
  Result := EndStringEditor;
end;

function TTreeEditLink.EndNumberEditor: string;
begin
  Result := (FEdit as TJvSpinEdit).Text;
end;

function TTreeEditLink.EndPickStringEditor: string;
begin
  Result := TComboBox(FEdit).Text;
end;

function TTreeEditLink.EndRegExEditor: string;
begin
  Result := EndStringEditor;
end;

function TTreeEditLink.EndStringEditor: string;
var
  Buffer: array[0..1024] of Char;
begin
  GetWindowText(FEdit.Handle, Buffer, 1024);
  Result := Buffer;
end;

function TTreeEditLink.EndUnionEditor: string;
begin
  Result := EndStringEditor;
end;

function TTreeEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;
//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.CreateStringEditor;
begin
  FEdit := TEdit.Create(nil);
  with FEdit as TEdit do
  begin
    Visible := False;
    Parent := FTree;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;


procedure TTreeEditLink.CreateBooleanEditor();
begin
  FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do
  begin
    Visible := False;
    Parent := FTree;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    Items.Add('False');
    Items.Add('True');
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TTreeEditLink.CreateDateTimeEditor;
begin
  FEdit := TDateTimePicker.Create(nil);
  with FEdit as TDateTimePicker do
  begin
    Visible := False;
    Parent := FTree;
    CalColors.MonthBackColor := clWindow;
    CalColors.TextColor := clBlack;
    CalColors.TitleBackColor := clBtnShadow;
    CalColors.TitleTextColor := clBlack;
    CalColors.TrailingTextColor := clBtnFace;
    try
     Date := StrToDate(PStdData(FNode.GetData).Columns[FColumn].Value);
    except
     Date := 0;
    end;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TTreeEditLink.CreateFloatEditor;
begin
  FEdit := TJvSpinEdit.Create(nil);
  with FEdit as TJvSpinEdit do
   begin
    ValueType := vtFloat;
    Decimal := 3;
    Visible := False;
    Parent := FTree;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
   end;
end;

procedure TTreeEditLink.CreateUnionEditor;
begin
  CreateStringEditor();
end;

procedure TTreeEditLink.CreateRegExEditor;
begin
  CreateStringEditor();
end;

procedure TTreeEditLink.CreateMemoEditor;
begin
  FEdit := TMemo.Create(nil);
  with FEdit as TMemo do
  begin
    Visible := False;
    Parent := FTree;
    ScrollBars := ssVertical;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TTreeEditLink.CreateNumberEditor;
begin
  FEdit := TJvSpinEdit.Create(nil);
  with FEdit as TJvSpinEdit do
  begin
    ValueType := vtInteger;
    Visible := False;
    Parent := FTree;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TTreeEditLink.CreatePickStringEditor;
begin
  CreateBooleanEditor;
end;

function TTreeEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: PStdData;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  // determine what edit type actually is needed
  if Assigned(FEdit) then FreeAndNil(FEdit);
  Data := Node.GetData();
  for var x in FEditorFunction do
   if Data.Columns[FColumn].EditType = x.EditType then
    begin
     x.CreateEditor();
     Exit;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TTreeEditLink.RegisterEditor(EditType: TEditType;  CreateEditor: TCreateEditor; EndEditor: TEndEditor);
 var
  d: TEditorFunction;
begin
  for var i := 0 to High(FEditorFunction) do
   if FEditorFunction[i].EditType = EditType then
    begin
     FEditorFunction[i].CreateEditor := CreateEditor;
     FEditorFunction[i].EndEditor := EndEditor;
     Exit;
    end;
  d.EditType := EditType;
  d.CreateEditor := CreateEditor;
  d.EndEditor := EndEditor;
  FEditorFunction := FEditorFunction + [d];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.

  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);

  if FEdit is TMemo then R.Height := R.Height * 4;

  FEdit.BoundsRect := R;
end;

function TTreeEditLink.ValidateNewData(var Value: Variant): Boolean;
begin
  Result := True;
end;

end.
