unit EditorLink.Base;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, VirtualTrees, ComCtrls, JvSpin;

type
  TColumnData = class;
  TTreeEditLink = class;
  TDataEditor = class abstract(TInterfacedObject)
  private
   procedure SetEdit(const Value: TWinControl);
   function GetEdit: TWinControl;
   function GetTree: TVirtualStringTree;
  public
   FValue: TColumnData;
   FNewValue: string;
   FOwner: TTreeEditLink;
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); virtual;
   procedure UpdateNewValue(); virtual;
   procedure SetBounds(var R: TRect); virtual;
   property NewValue: string read FNewValue;
   property Edit: TWinControl read GetEdit write SetEdit;
   property Tree: TVirtualStringTree read GetTree;
   property Link: TTreeEditLink read FOwner;
  end;
  TDataEditorClass = class of TDataEditor;

  TStringEditor = class(TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
  end;
  TBooleanEditor = class(TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
  end;
  TDateTimeEditor = class(TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure UpdateNewValue(); override;
  end;
  TMemoEditor = class(TDataEditor)
   constructor Create(AOwner: TTreeEditLink; Value: TColumnData); override;
   procedure SetBounds(var R: TRect); override;
  end;
  TjvNumEditEditor = class(TDataEditor)
   procedure UpdateNewValue(); override;
  end;
  TNumberEditor = class(TjvNumEditEditor)
   constructor Create(AOwner: TTreeEditLink; Val: TColumnData); override;
  end;
  TFloatEditor = class(TjvNumEditEditor)
   constructor Create(AOwner: TTreeEditLink; Val: TColumnData); override;
  end;

  TColumnDataValidator = class abstract(TInterfacedObject)
  public
   FEditor: TDataEditor;
   FData: TColumnData;
   constructor Create(AEditor: TDataEditor; AData: TColumnData); virtual;
   function CheckValid: Boolean; virtual; abstract;
  end;
  TValidatorClass = class of TColumnDataValidator;

  TUpdateViewData = procedure (Tree: TBaseVirtualTree; ColumnData: TColumnData) of object;
  TColumnData = class sealed (TInterfacedObject)
  private
    procedure SetImageIndex(const Value: Integer);
    procedure SetStateImageIndex(const Value: Integer);
  public
    Owner: PVirtualNode;
    Index: Integer;
    EditType: TDataEditorClass;
    Value: string;
    IsValid: Boolean;
    FontStyles: TFontStyles;
    FontColor: TColor;
    BrashColor: TColor;
    Gosted: Boolean;
    FImageIndex: Integer;
    ExpandedImageIndex: Integer;
    StateGosted: Boolean;
    FStateImageIndex: Integer;
    StatexpandedImageIndex: Integer;
    Validator: TValidatorClass;
    UpdateViewDataFunc: TUpdateViewData;
    constructor Create(AOwner: PVirtualNode; AIndex: Integer);
    destructor Destroy; override;
    procedure UpdateViewData(Tree: TBaseVirtualTree);
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property StateImageIndex: Integer read FStateImageIndex write SetStateImageIndex;
  end;

  IStdData = interface
  ['{492AF294-EBF8-4B46-B5D2-7215A8C7B7E8}']
    function GetColumn(Index: Integer): TColumnData;
    property Columns[Index: Integer]: TColumnData read GetColumn;
  end;
  PStdData = ^IStdData;
  TStdData = class abstract(TInterfacedObject, IStdData)
  private
    FColumns: TArray<IInterface>;
  protected
    FOwner: PVirtualNode;
  public
    constructor Create(AOwner: PVirtualNode; ColCount: Integer);
    destructor Destroy; override;
    function GetColumn(Index: Integer): TColumnData;
    property Columns[Index: Integer]: TColumnData read GetColumn;
  end;

  // Our own edit link to implement several different node editors.
  TTreeEditLink = class(TInterfacedObject, IVTEditLink)
  public
    FDataEdit: TDataEditor;
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
    destructor Destroy; override;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

{$REGION 'TPropertyEditLink'}
//----------------- TPropertyEditLink ----------------------------------------------------------------------------------

// This implementation is used in VST3 to make a connection beween the tree
// and the actual edit window which might be a simple edit, a combobox
// or a memo etc.
destructor TTreeEditLink.Destroy;

begin
  //FEdit.Free; casues issue #357. Fix:
  if Assigned(FEdit) and FEdit.HandleAllocated then
    PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
  FDataEdit.Free;
  inherited;
end;

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

function TTreeEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: PStdData;
  cd: TColumnData;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
  // determine what edit type actually is needed
  if Assigned(FEdit) then FreeAndNil(FEdit);
  Data := Node.GetData;
  cd := Data^.Columns[FColumn];
  FDataEdit := cd.EditType.Create(Self, cd);
end;

procedure TTreeEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TTreeEditLink.SetBounds(R: TRect);
 var
  Dummy: Integer;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.

  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FDataEdit.SetBounds(R);
  FEdit.BoundsRect := R;
end;

function TTreeEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TTreeEditLink.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

function TTreeEditLink.EndEdit: Boolean;
 var
  ColData: TColumnData;
  Validator: TColumnDataValidator;
begin
  Result := True;
  ColData := PStdData(FNode.GetData()).Columns[FColumn];
  FDataEdit.UpdateNewValue();
  ColData.Value := FDataEdit.FNewValue;
  if Assigned(ColData.Validator) then
   begin
    Validator := ColData.Validator.Create(FDataEdit, ColData);
    ColData.IsValid := Validator.CheckValid;
   end;
  ColData.UpdateViewData(FTree);
//  FTree.InvalidateNode(FNode);
  FEdit.Hide;
  FTree.SetFocus;
end;

function TTreeEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;
{$ENDREGION}

{$REGION 'Editors'}
{ TStringEditor }

constructor TStringEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
    Edit := TEdit.Create(nil);
    with Edit as TEdit do
    begin
      Visible := False;
      Parent := Tree;
      Text := Value.Value;
      OnKeyDown := Link.EditKeyDown;
      OnKeyUp := Link.EditKeyUp;
    end;
end;

{ TBooleanEditor }

constructor TBooleanEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  Edit := TComboBox.Create(nil);
  with Edit as TComboBox do
  begin
    Visible := False;
    Parent := Tree;
    Text := Value.Value;
    Items.Add('False');
    Items.Add('True');
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
  end;
end;

{ TDateTimeEditor }

constructor TDateTimeEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  Edit := TDateTimePicker.Create(nil);
  with Edit as TDateTimePicker do
  begin
    Visible := False;
    Parent := Tree;
    CalColors.MonthBackColor := clWindow;
    CalColors.TextColor := clBlack;
    CalColors.TitleBackColor := clBtnShadow;
    CalColors.TitleTextColor := clBlack;
    CalColors.TrailingTextColor := clBtnFace;
    try
     Date := StrToDate(Value.Value);
    except
     Date := 0;
    end;
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
  end;
end;

{ TMemoEditor }

constructor TMemoEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  inherited;
  Edit := TMemo.Create(nil);
  with Edit as TMemo do
  begin
    Visible := False;
    Parent := Tree;
    Text := Value.Value;
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
  end;
end;

procedure TMemoEditor.SetBounds(var R: TRect);
begin
  R.Height := R.Height * 4;
end;

{ TNumberEditor }

constructor TNumberEditor.Create(AOwner: TTreeEditLink; Val: TColumnData);
begin
  inherited;
    Edit := TJvSpinEdit.Create(nil);
    with Edit as TJvSpinEdit do
    begin
      ValueType := vtInteger;
      Visible := False;
      Parent := Tree;
      Text := Val.Value;
      OnKeyDown := Link.EditKeyDown;
      OnKeyUp := Link.EditKeyUp;
    end;
end;

procedure TjvNumEditEditor.UpdateNewValue;
begin
  FNewValue := string((FOwner.FEdit as TJvSpinEdit).Text).Trim;
  if (FNewValue = '0') or (FNewValue = '0.0') or (FNewValue = '0.00') or (FNewValue = '0.000') then
     FNewValue := '';
end;

{ TFloatEditor }

constructor TFloatEditor.Create(AOwner: TTreeEditLink; Val: TColumnData);
begin
  inherited;
  Edit := TJvSpinEdit.Create(nil);
  with Edit as TJvSpinEdit do
   begin
    ValueType := vtFloat;
    Decimal := 3;
    Visible := False;
    Parent := Tree;
    Text := Val.Value;
    OnKeyDown := Link.EditKeyDown;
    OnKeyUp := Link.EditKeyUp;
   end;
end;

procedure TDateTimeEditor.UpdateNewValue;
begin
  if TDateTimePicker(FOwner.FEdit).Date = 0 then FNewValue := ''
  else FNewValue := DateToStr(TDateTimePicker(FOwner.FEdit).Date);
end;

{ TDataEditor }

constructor TDataEditor.Create(AOwner: TTreeEditLink; Value: TColumnData);
begin
  FOwner := AOwner;
  FValue := Value;
end;

function TDataEditor.GetEdit: TWinControl;
begin
  Result := FOwner.FEdit;
end;
procedure TDataEditor.SetEdit(const Value: TWinControl);
begin
  FOwner.FEdit := Value;
end;

procedure TDataEditor.UpdateNewValue;
var
  Buffer: array[0..1024] of Char;
begin
  GetWindowText(Edit.Handle, Buffer, 1024);
  FNewValue := string(Buffer).Trim;
end;

function TDataEditor.GetTree: TVirtualStringTree;
begin
  Result := FOwner.FTree;
end;

procedure TDataEditor.SetBounds(var R: TRect);
begin
end;

{$ENDREGION}

{ TColumnData }

constructor TColumnData.Create(AOwner: PVirtualNode; AIndex: Integer);
begin
  Owner := AOwner;
  Index := AIndex;
  Value := '';
  IsValid := True;
  FontStyles := [];
  FontColor := clBlack;
  BrashColor := clWhite;
  ImageIndex := -1;
  StateImageIndex := -1;
end;

destructor TColumnData.Destroy;
begin
  inherited;
end;

procedure TColumnData.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  ExpandedImageIndex := Value;
end;

procedure TColumnData.SetStateImageIndex(const Value: Integer);
begin
  FStateImageIndex := Value;
  StatexpandedImageIndex := Value;
end;

procedure TColumnData.UpdateViewData(Tree: TBaseVirtualTree);
begin
  if Assigned(UpdateViewDataFunc) then UpdateViewDataFunc(Tree, Self);
end;

{ TStdData }

constructor TStdData.Create(AOwner: PVirtualNode; ColCount: Integer);
begin
  FOwner := AOwner;
  SetLength(FColumns, ColCount);
  for var i := 0 to High(FColumns) do FColumns[i] := TColumnData.Create(AOwner, i);
end;

destructor TStdData.Destroy;
begin
  inherited;
end;

function TStdData.GetColumn(Index: Integer): TColumnData;
begin
  Result := FColumns[Index] as TColumnData;
end;

{ TValidator }

constructor TColumnDataValidator.Create(AEditor: TDataEditor; AData: TColumnData);
begin
  FEditor := AEditor;
  FData := AData;
end;

end.
