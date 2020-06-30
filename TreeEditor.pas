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
    etBoolean,
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
    Valid: Boolean;
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
    function ValidateNewData(var Value: Variant): Boolean; virtual;
    procedure CreateMemoEditor(); virtual;
    procedure CreateNumberEditor(); virtual;
    procedure CreateStringEditor(); virtual;
    procedure CreatePickStringEditor(); virtual;
    procedure CreateRegExEditor(); virtual;
    procedure CreateBooleanEditor(); virtual;
    procedure CreateDateTimeEditor(); virtual;
    procedure CreateUnionEditor(); virtual;
    procedure DoCheckValidateNewDataError(); virtual;
  public
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
  s := s.Trim;
  if not SameStr(S, Data.Columns[FColumn].Value) then
   begin
    V := S;
    Data.Columns[FColumn].Dirty := True;
    Result := ValidateNewData(V);
    Data.Columns[FColumn].Valid := Result;
    Data.Columns[FColumn].Value := V;
    FTree.InvalidateNode(FNode);
   end;
  FEdit.Hide;
  FTree.SetFocus;
  if not Result then DoCheckValidateNewDataError();
end;

//----------------------------------------------------------------------------------------------------------------------

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
  CreateStringEditor();
end;

procedure TTreeEditLink.CreateNumberEditor;
begin
  CreateStringEditor();
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
  case Data.Columns[FColumn].EditType of
    etString: CreateStringEditor();
    etPickString: CreatePickStringEditor();
    etRegexEdit: CreateRegExEditor();
    etNumber: CreateNumberEditor();
    etBoolean: CreateBooleanEditor();
    etMemo: CreateMemoEditor();
    etDate: CreateDateTimeEditor;
    etUnion: CreateUnionEditor;
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

function TTreeEditLink.ValidateNewData(var Value: Variant): Boolean;
begin
  Result := True;
end;

end.
