unit AnnotatedStringEditor;

interface

uses SysUtils, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Controls, Vcl.Graphics;

type
  TPickStringEditor = class(TComboBox)
  private
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    FoldWidth: Integer;
    FWidth: Integer;
    FmaxItemWidth: Integer;
    FmaxItemAnnotWidth: Integer;
    FAnnotations: TArray<string>;
    procedure AdjustDropDown; override;
    procedure CloseUp; override;
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    procedure AddAnnotatedItem(const ItemName: string; const Annotation: string);
    procedure AdjustWidth(MaxWidth: Integer);
  end;

implementation

uses math;

const
  SPASE_ITEM_ANN = 2+16;
  SPASE_END = 16+8;

{ TPickStringEditor }

procedure TPickStringEditor.CloseUp;
begin
  Style := csDropDown;
  inherited;
  SetWindowPos(FDropHandle, 0, 0, 0, FoldWidth, ItemHeight+ Height + 2, SWP_NOMOVE
  or SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
end;

procedure TPickStringEditor.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  TControlCanvas(Canvas).UpdateTextFlags;
  Canvas.FillRect(Rect);
  while ItemCount > Length(FAnnotations) do FAnnotations := FAnnotations + ['bad'] ;

  if (Index >= 0) and (Index < ItemCount) then
   if odComboBoxEdit in State then
        Canvas.TextOut(Rect.Left + 1, Rect.Top + 1, Items[Index]) //Visual state of the text in the edit control
   else
      begin
       //Visual state of the text(items) in the deployed list
        Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
        if FAnnotations[Index] <> '' then
         begin
          var R :=  Rect;
          R.Left := R.Left+ FmaxItemWidth + SPASE_ITEM_ANN;
          Canvas.Font.Color := $208020;
          Canvas.TextRect(R, FAnnotations[Index], [tfEndEllipsis, tfWordBreak]);
         end;
      end
end;

procedure TPickStringEditor.MeasureItem(Index: Integer; var Height: Integer);
 var
  nlines, ost: Integer;
begin
  if Index < 0 then Exit;
  var annwi := FWidth -FmaxItemWidth - SPASE_ITEM_ANN - SPASE_END;
  if annwi <= (SPASE_ITEM_ANN + SPASE_END) then Exit;
  nlines := Canvas.TextWidth(FAnnotations[Index]) div annwi;
  ost := Canvas.TextWidth(FAnnotations[Index]) mod annwi;
  if ost > 0 then Inc(nlines);
  if nlines = 0 then Exit;
  Height := Height * nlines;
end;

procedure TPickStringEditor.WMLButtonDown(var Message: TWMLButtonDown);
begin
  Style := csOwnerDrawVariable;
  inherited;
end;

procedure TPickStringEditor.AdjustWidth(MaxWidth: Integer);
 var
  mv: Integer;
begin
  FWidth := MaxWidth;
  mv := 0;
  FmaxItemWidth := 0;
  for var i := 0 to ItemCount-1 do FmaxItemWidth := max(FmaxItemWidth, Canvas.TextWidth(Items[i]));
  FmaxItemAnnotWidth := 0;
  for var i := 0 to ItemCount-1 do FmaxItemAnnotWidth := max(FmaxItemAnnotWidth, Canvas.TextWidth(FAnnotations[i]));
  if (FmaxItemWidth + FmaxItemAnnotWidth) < MaxWidth then FWidth := FmaxItemWidth + FmaxItemAnnotWidth;
  Inc(FWidth, SPASE_ITEM_ANN + SPASE_END);
  if FWidth < Width then FWidth := Width;
end;

procedure TPickStringEditor.AddAnnotatedItem(const ItemName, Annotation: string);
begin
  Items.Add(ItemName);
  FAnnotations := FAnnotations + [Annotation];
end;

procedure TPickStringEditor.AdjustDropDown;
var
  Count: Integer;
begin
  Count := ItemCount;
  if Count > DropDownCount then Count := DropDownCount;
  if Count < 1 then Count := 1;
  FDroppingDown := True;
  try
    FoldWidth := Width;
    SetWindowPos(FDropHandle, 0, 0, 0, FWidth, ItemHeight * Count +
      Height + 2, SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_NOREDRAW or
      SWP_HIDEWINDOW);
  finally
    FDroppingDown := False;
  end;
  SetWindowPos(FDropHandle, 0, 0, 0, FoldWidth, 0, SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or
  SWP_SHOWWINDOW);
end;

end.

