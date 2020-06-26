unit TreeEditor;

// Utility unit for the advanced Virtual Treeview demo application which contains the implementation of edit link
// interfaces used in other samples of the demo.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualTrees, ExtDlgs, ImgList, Buttons, ExtCtrls, ComCtrls,
  Mask;
//, Xml.XMLSchemaTags, XmlSchema;

type
  // Describes the type of value a property tree node stores in its data property.
  TEditType = (
    etNone,
    etString,
    etPickString,
    etRegexEdit,
    etNumber,
    etPickNumber,
    etMemo,
    etDate,
    etUnion);

//----------------------------------------------------------------------------------------------------------------------
   // Node data record for the the document properties treeview.

  PColumnData = ^TColumnData;
  TColumnData = record
    EditType: TEditType;
    Value: variant;
    Dirty: Boolean;
  end;

  PStdData = ^TStdData;
  TStdData = record
    Columns: TArray<TColumnData>;
  end;

  PEditDataHistory = ^TEditDataHistory;
  TEditDataHistory = record
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
    Value: variant;
    Dirty: Boolean;
  end;

  // Our own edit link to implement several different node editors.
  TTreeEditLink = class(TInterfacedObject, IVTEditLink)
  protected
    FEdit: TWinControl;        // One of the property editor classes.
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
    procedure CreatePickStringEditor(); virtual;
    procedure CreateRegExEditor(); virtual;
  public
    destructor Destroy; override;
  end;

//----------------------------------------------------------------------------------------------------------------------

type
  TPropertyTextKind = (
    ptkText,
    ptkHint
  );

// The following constants provide the property tree with default data.

const
  // Types of editors to use for a certain node in VST3.
  ValueTypes: array[0..1, 0..12] of TEditType = (
    (
      etString,     // Title
      etString,     // Theme
      etPickString, // Category
      etMemo,       // Keywords
      etNone,       // Template
      etNone,       // Page count
      etNone,       // Word count
      etNone,       // Character count
      etNone,       // Lines
      etNone,       // Paragraphs
      etNone,       // Scaled
      etNone,       // Links to update
      etMemo),      // Comments
    (
      etString,     // Author
      etNone,       // Most recently saved by
      etNumber,     // Revision number
      etPickString, // Primary application
      etString,     // Company name
      etNone,       // Creation date
      etDate,       // Most recently saved at
      etNone,       // Last print
      etNone,
      etNone,
      etNone,
      etNone,
      etNone)
  );

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

begin
  Result := True;

  Data := FNode.GetData();
  if FEdit is TComboBox then
    S := TComboBox(FEdit).Text
  else if FEdit is TDateTimePicker then
   begin
    if TDateTimePicker(FEdit).Date = 0 then S := ''
    else S := DateToStr(TDateTimePicker(FEdit).Date);
   end
  else
  begin
    GetWindowText(FEdit.Handle, Buffer, 1024);
    S := Buffer;
  end;

  if S <> Data.Columns[FColumn].Value then
  begin
    Data.Columns[FColumn].Dirty := True;
    Data.Columns[FColumn].Value := S;
    FTree.InvalidateNode(FNode);
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTreeEditLink.GetBounds: TRect;

begin
  Result := FEdit.BoundsRect;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.CreateRegExEditor;
begin
  FEdit := TMaskEdit.Create(nil);
  with FEdit as TMaskEdit do
  begin
    Visible := False;
    Parent := FTree;
    EditMask := '9999';
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
end;

procedure TTreeEditLink.CreatePickStringEditor;
begin
  FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do
  begin
    Visible := False;
    Parent := FTree;
    Text := PStdData(FNode.GetData).Columns[FColumn].Value;
    Items.Add(Text);
    Items.Add('Standard');
    Items.Add('Additional');
    Items.Add('Win32');
    OnKeyDown := EditKeyDown;
    OnKeyUp := EditKeyUp;
  end;
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
  case Data.Columns[FColumn].EditType of
    etString:
      begin
        FEdit := TEdit.Create(nil);
        with FEdit as TEdit do
        begin
          Visible := False;
          Parent := Tree;
          Text := Data.Columns[FColumn].Value;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
        end;
      end;
    etPickString: CreatePickStringEditor();
    etRegexEdit: CreateRegExEditor();
    etNumber:
      begin
        FEdit := TMaskEdit.Create(nil);
        with FEdit as TMaskEdit do
        begin
          Visible := False;
          Parent := Tree;
          EditMask := '9999';
          Text := Data.Columns[FColumn].Value;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
        end;
      end;
    etPickNumber:
      begin
        FEdit := TComboBox.Create(nil);
        with FEdit as TComboBox do
        begin
          Visible := False;
          Parent := Tree;
          Text := Data.Columns[FColumn].Value;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
        end;
      end;
    etMemo:
      begin
        FEdit := TComboBox.Create(nil);
        // In reality this should be a drop down memo but this requires
        // a special control.
        with FEdit as TComboBox do
        begin
          Visible := False;
          Parent := Tree;
          Text := Data.Columns[FColumn].Value;
          Items.Add(Data.Columns[FColumn].Value);
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
        end;
      end;
    etDate:
      begin
        FEdit := TDateTimePicker.Create(nil);
        with FEdit as TDateTimePicker do
        begin
          Visible := False;
          Parent := Tree;
          CalColors.MonthBackColor := clWindow;
          CalColors.TextColor := clBlack;
          CalColors.TitleBackColor := clBtnShadow;
          CalColors.TitleTextColor := clBlack;
          CalColors.TrailingTextColor := clBtnFace;
          try
           Date := StrToDate(Data.Columns[FColumn].Value);
          except
           Date := 0;
          end;
          OnKeyDown := EditKeyDown;
          OnKeyUp := EditKeyUp;
        end;
      end;
  else
    Result := False;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.ProcessMessage(var Message: TMessage);

begin
  FEdit.WindowProc(Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTreeEditLink.SetBounds(R: TRect);

var
  Dummy: Integer;

begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

end.
