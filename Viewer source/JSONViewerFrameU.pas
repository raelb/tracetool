unit JSONViewerFrameU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees,
  Vcl.StdCtrls, Vcl.ExtCtrls, jsondoc, System.JSON, TextEditor, RxStrHlder,
  RzTabs, System.Actions, Vcl.ActnList, SpTBXEditors, Vcl.Buttons, TEDataModU;

type
  TJSONViewerFrame = class(TFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOpen: TButton;
    VST: TVirtualStringTree;
    OpenDialog1: TOpenDialog;
    Splitter1: TSplitter;
    EditorPanel: TPanel;
    Editor: TTextEditor;
    btnPaste: TButton;
    SearchPanel: TPanel;
    SplitterSearch: TSplitter;
    SpeedButtonFindPrevious: TSpeedButton;
    SpeedButtonFindNext: TSpeedButton;
    SpeedButtonSearchDivider1: TSpeedButton;
    SpeedButtonOptions: TSpeedButton;
    SpeedButtonClose: TSpeedButton;
    SpeedButtonCaseSensitive: TSpeedButton;
    SpeedButtonInSelection: TSpeedButton;
    SpeedButtonSearchDivider2: TSpeedButton;
    SpeedButtonSearchEngine: TSpeedButton;
    SpeedButtonFindAll: TSpeedButton;
    edtSearchText: TEdit;
    PanelRight: TPanel;
    LabelSearchResultCount: TLabel;
    ActionList1: TActionList;
    actFind: TAction;
    actFindNext: TAction;
    actFindPrev: TAction;
    actReplace: TAction;
    actShowMiniMap: TAction;
    actDelLine: TAction;
    actDelEOL: TAction;
    actDelWord: TAction;
    actDelWhiteSpace: TAction;
    actCaseSensitive: TAction;
    actInSelection: TAction;
    actCloseSearch: TAction;
    actFindAll: TAction;
    actWordWrap: TAction;
    LeftSpacerPanel: TPanel;
    procedure actCloseSearchExecute(Sender: TObject);
    procedure actFindAllExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPrevExecute(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure edtSearchTextChange(Sender: TObject);
    procedure edtSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButtonCloseClick(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column:
        TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    FTabSheet: TRzTabSheet;
    FVisibleByteSizes: Boolean;
    FVisibleChildrenCounts: Boolean;
    FJSONDocument: TJSONDocument;
    function AddChild(Parent: PVirtualNode; Caption: string): PVirtualNode;
    procedure ClearAll;
    procedure DoLoadJSON;
    procedure DoSearchTextChange;
    procedure ProcessElement(currNode: PVirtualNode; arr: TJSONArray; aIndex:
        integer);
    procedure ProcessPair(currNode: PVirtualNode; obj: TJSONObject; aIndex:
        integer);
    procedure InitEditor;
    procedure SetMatchesFound;
  public
    constructor Create(AOwner: TComponent; TabSheet: TRzTabSheet);
    procedure CreateWnd; override;
    procedure LoadJSON(const JSON: string);
    procedure Init;
    procedure Open(const FileName: string);
    procedure Find;
    procedure FindNext;
    procedure FindPrevious;
  published
    property JSONDocument: TJSONDocument read FJSONDocument;
    property VisibleByteSizes: Boolean read FVisibleByteSizes write
        FVisibleByteSizes;
    property VisibleChildrenCounts: Boolean read FVisibleChildrenCounts write
        FVisibleChildrenCounts;
  end;

const
  TAB_PADDING = '  ';

function FormatJSON(json: String): String;

implementation

uses
  REST.Json, Vcl.Clipbrd, superobject;

{$R *.dfm}

type
  PNodeData = ^TNodeData;
  TNodeData = record
    Caption: string;
  end;

//---------------------------------- Utils -------------------------

function FormatJSON(json: String): String;
var
  tmpJson: TJsonValue;
begin
  Result := '';
  if Length(json) = 0 then
    exit;
  if (json[1] <> '{') and (json[1] <> '[') then
  begin
    Result := json;
    exit;
  end;

  try
    try
      tmpJson := TJSONObject.ParseJSONValue(json);
      Result := TJson.Format(tmpJson);
    except
      Result :=
        '------- Warning: Error parsing JSON -------' + #13#10 +
          Json + #13#10 +
        '------- Warning: Error parsing JSON -------';
    end;
  finally
    FreeAndNil(tmpJson);
  end;
end;

function IsDarkTheme: Boolean;
begin
  Result := True;
end;

{ From SpTBXSkins }
function SpRGBToColor(R, G, B: Integer): TColor;
begin
  if R < 0 then R := 0 else if R > 255 then R := 255;
  if G < 0 then G := 0 else if G > 255 then G := 255;
  if B < 0 then B := 0 else if B > 255 then B := 255;
  Result := TColor(RGB(R, G, B));
end;

function SpLighten(Color: TColor; Amount: Integer): TColor;
var
  R, G, B: Integer;
begin
  Color := ColorToRGB(Color);
  R := GetRValue(Color) + Amount;
  G := GetGValue(Color) + Amount;
  B := GetBValue(Color) + Amount;
  Result := SpRGBToColor(R, G, B);
end;

//------------------------------------------------------------------

function TJSONViewerFrame.AddChild(Parent: PVirtualNode; Caption: string):
    PVirtualNode;
var
  Node: PVirtualNode;
  Data: PNodeData;
begin
  Node := VST.AddChild(Parent);
  Data := VST.GetNodeData(Node);
  Data.Caption := Caption;
  Result := Node;
end;

procedure TJSONViewerFrame.ClearAll;
begin
  VST.Clear;
end;

constructor TJSONViewerFrame.Create(AOwner: TComponent; TabSheet: TRzTabSheet);
begin
  inherited Create(AOwner);
  FTabSheet := TabSheet;
  VST.NodeDataSize := SizeOf(TNodeData);

  FVisibleChildrenCounts := true;
  FVisibleByteSizes := false;

  FJSONDocument := TJSONDocument.Create(Self);
  //InitEditor; -> Too early for a Frame
end;

procedure TJSONViewerFrame.actCloseSearchExecute(Sender: TObject);
begin
//
end;

procedure TJSONViewerFrame.actFindAllExecute(Sender: TObject);
begin
  Editor.FindAll;
end;

procedure TJSONViewerFrame.actFindExecute(Sender: TObject);
begin
  SearchPanel.Visible := True;
  if Editor.SelectionAvailable and (Editor.SelectionBeginPosition.Line = Editor.SelectionEndPosition.Line) then
    Editor.Search.SearchText := Editor.SelectedText
  else
    Editor.Search.SearchText := '';
  edtSearchText.Text := Editor.Search.SearchText;
  edtSearchText.SetFocus;
  Editor.Search.Enabled := True;
  //Editor.Search.Options := Editor.Search.Options -
  //  [{soBeepIfStringNotFound,} soShowSearchMatchNotFound];
  SetMatchesFound;
end;

procedure TJSONViewerFrame.actFindNextExecute(Sender: TObject);
begin
  if Editor.Search.SearchText <> edtSearchText.Text then
    Editor.Search.SearchText := edtSearchText.Text
  else
    Editor.FindNext;
end;

procedure TJSONViewerFrame.actFindPrevExecute(Sender: TObject);
begin
  if Editor.Search.SearchText <> edtSearchText.Text then
    Editor.Search.SearchText := edtSearchText.Text
  else
    Editor.FindPrevious;
end;

procedure TJSONViewerFrame.btnOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Application.ProcessMessages;
    Screen.Cursor := crHourGlass;
    try
      Open(OpenDialog1.FileName);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TJSONViewerFrame.CreateWnd;
begin
  inherited;

end;

procedure TJSONViewerFrame.btnPasteClick(Sender: TObject);
begin
  LoadJSON(Clipboard.AsText);
end;

procedure TJSONViewerFrame.DoLoadJSON;
var
  v: TJSONValue;
  currNode: PVirtualNode;
  i, aCount: integer;
  s: string;
begin
  ClearAll;

  if (JSONDocument <> nil) and JSONDocument.IsActive then
  begin
    v := JSONDocument.RootValue;
    VST.Clear;

    if TJSONDocument.IsSimpleJsonValue(v) then
      AddChild(nil, TJSONDocument.UnQuote(v.Value))

    else
    if v is TJSONObject then
    begin
      aCount := TJSONObject(v).Size;
      s := '{}';
      if VisibleChildrenCounts then
        s := s + ' (' + IntToStr(aCount) + ')';
      if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(v.EstimatedByteSize) + ' bytes)';
      currNode := AddChild(nil, s);
      for i := 0 to aCount - 1 do
        ProcessPair(currNode, TJSONObject(v), i)
    end

    else
    if v is TJSONArray then
    begin
      aCount := TJSONArray(v).Size;
      s := '[]';
      if VisibleChildrenCounts then
        s := s + ' (' + IntToStr(aCount) + ')';
      if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(v.EstimatedByteSize) + ' bytes)';
      currNode := AddChild(nil, s);
      for i := 0 to aCount - 1 do
        ProcessElement(currNode, TJSONArray(v), i)
    end

    else
      raise EUnknownJsonValueDescendant.Create;

    //FullExpand;
  end;
end;

procedure TJSONViewerFrame.DoSearchTextChange;
begin
  if Assigned(Editor) then
    Editor.Search.SearchText := edtSearchText.Text;
  SetMatchesFound;
end;

procedure TJSONViewerFrame.edtSearchTextChange(Sender: TObject);
begin
  DoSearchTextChange;
end;

procedure TJSONViewerFrame.edtSearchTextKeyPress(Sender: TObject; var Key:
    Char);
begin
  if (Key = #13) or (Key = #10) then
  begin
    if Assigned(Editor) then
      if Editor.CanFocus then
        Editor.SetFocus;
    Key := #0;

    DoSearchTextChange;
  end;
end;

procedure TJSONViewerFrame.Find;
begin
  Self.actFindExecute(nil);
end;

procedure TJSONViewerFrame.FindNext;
begin
  Self.actFindNextExecute(nil);
end;

procedure TJSONViewerFrame.FindPrevious;
begin
  Self.actFindPrevExecute(nil);
end;

procedure TJSONViewerFrame.Init;
begin
  InitEditor;
end;

procedure TJSONViewerFrame.InitEditor;
var
  StrStream: TStringStream;
begin
  StrStream := TStringStream.Create(TEDataMod.shJSON.Strings.Text);
  try
    StrStream.Position := 0;
    Editor.Highlighter.LoadFromStream(StrStream);
  finally
    StrStream.Free;
  end;
  StrStream := TStringStream.Create(TEDataMod.shMonokai.Strings.Text);
  try
    StrStream.Position := 0;
    Editor.Highlighter.Colors.LoadFromStream(StrStream);
  finally
    StrStream.Free;
  end;
end;

procedure TJSONViewerFrame.LoadJSON(const JSON: string);
var
  FixedJson: String;
  O: ISuperObject;
  T1: Cardinal;
begin
  O := SO(JSON);
  FixedJson := O.AsJSon(False, False);
  Editor.Lines.Text := FormatJSON(FixedJSON);

  JSONDocument.JsonText := FixedJSON;

  T1 := GetTickCount;
  VST.BeginUpdate;
  try
    DoLoadJSON;
    if VST.GetFirst <> nil then
      VST.Expanded[VST.GetFirst] := True;
  finally
    VST.EndUpdate;
  end;
end;

procedure TJSONViewerFrame.Open(const FileName: string);
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  try
    FTabSheet.Caption := TAB_PADDING +
      ExtractFileName(FileName) + TAB_PADDING;
    StrList.LoadFromFile(FileName {,TEncoding.UTF8});
    LoadJSON(StrList.Text);
  finally
    StrList.Free;
  end;
end;

procedure TJSONViewerFrame.ProcessElement(currNode: PVirtualNode; arr:
    TJSONArray; aIndex: integer);
var
  v: TJSONValue;
  s: string;
  n: PVirtualNode;
  i, aCount: integer;
begin
  v := arr.Get(aIndex);
  s := '[' + IntToStr(aIndex) + '] ';

  if TJSONDocument.IsSimpleJsonValue(v) then
  begin
    AddChild(currNode, s + v.ToString);
    exit;
  end;

  if v is TJSONObject then
  begin
    aCount := TJSONObject(v).Size;
    s := s + ' {}';
    if VisibleChildrenCounts then
      s := s + ' (' + IntToStr(aCount) + ')';
    if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(v.EstimatedByteSize) + ' bytes)';
    n := AddChild(currNode, s);
    for i := 0 to aCount - 1 do
      ProcessPair(n, TJSONObject(v), i);
  end

  else if v is TJSONArray then
  begin
    aCount := TJSONArray(v).Size;
    s := s + ' []';
    n := AddChild(currNode, s);
    if VisibleChildrenCounts then
      s := s + ' (' + IntToStr(aCount) + ')';
    if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(v.EstimatedByteSize) + ' bytes)';
    for i := 0 to aCount - 1 do
      ProcessElement(n, TJSONArray(v), i);
  end
  else
    raise EUnknownJsonValueDescendant.Create;

end;

procedure TJSONViewerFrame.ProcessPair(currNode: PVirtualNode; obj:
    TJSONObject; aIndex: integer);
var
  p: TJSONPair;
  s: string;
  n: PVirtualNode;
  i, aCount: integer;
begin
  p := obj.Get(aIndex);

  s := TJSONDocument.UnQuote(p.JsonString.ToString) + ' : ';

  if TJSONDocument.IsSimpleJsonValue(p.JsonValue) then
  begin
    AddChild(currNode, s + p.JsonValue.ToString);
    exit;
  end;

  if p.JsonValue is TJSONObject then
  begin
    aCount := TJSONObject(p.JsonValue).Size;
    s := s + ' {}';
    if VisibleChildrenCounts then
      s := s + ' (' + IntToStr(aCount) + ')';
    if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(p.EstimatedByteSize) + ' bytes)';
    n := AddChild(currNode, s);
    for i := 0 to aCount - 1 do
      ProcessPair(n, TJSONObject(p.JsonValue), i);
  end

  else if p.JsonValue is TJSONArray then
  begin
    aCount := TJSONArray(p.JsonValue).Size;
    s := s + ' []';
    if VisibleChildrenCounts then
      s := s + ' (' + IntToStr(aCount) + ')';
    if VisibleByteSizes then
        s := s + ' (size: ' + IntToStr(p.EstimatedByteSize) + ' bytes)';
    n := AddChild(currNode, s);
    for i := 0 to aCount - 1 do
      ProcessElement(n, TJSONArray(p.JsonValue), i);
  end
  else
    raise EUnknownJsonValueDescendant.Create;
end;

procedure TJSONViewerFrame.SetMatchesFound;
var
  FontColor: TColor;
  LLabel: string;
  NoMatches: Boolean;
begin
  LLabel := '';
  NoMatches := False;

  if Assigned(Editor) and (Editor.Search.Items.Count > 1) then
    LLabel := 'es';
  if Assigned(Editor) and (Editor.Search.Items.Count > 0) then
    LLabel := Format('%d match%s found', [Editor.Search.Items.Count, LLabel])
  else
  if edtSearchText.Text <> '' then
  begin
    NoMatches := True;
    LLabel := 'No matches found';
  end;

  // Set font color
  if NoMatches then
  begin
    FontColor := clRed;
    if IsDarkTheme then
      FontColor := SpLighten(clRed, 20);
  end
  else
  begin
    FontColor := clBlack;
    if IsDarkTheme then
      FontColor := clYellow;
  end;
  LabelSearchResultCount.Font.Color := FontColor;

  LabelSearchResultCount.Caption := '  ' + LLabel;
end;

procedure TJSONViewerFrame.SpeedButtonCloseClick(Sender: TObject);
begin
  SearchPanel.Visible := False;
  Editor.Search.Enabled := False;
end;

procedure TJSONViewerFrame.VSTFreeNode(Sender: TBaseVirtualTree; Node:
    PVirtualNode);
var
  Data: PNodeData;
begin
  Data := VST.GetNodeData(Node);
  Data.Caption := '';
end;

procedure TJSONViewerFrame.VSTGetText(Sender: TBaseVirtualTree; Node:
    PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
    string);
var
  Data: PNodeData;
begin
  Data := VST.GetNodeData(Node);
  CellText := Data.Caption;
end;

end.
