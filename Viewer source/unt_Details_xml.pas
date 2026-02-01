unit unt_Details_xml;

interface

uses
  system.Contnrs,Windows, Messages, SysUtils, Variants, System.Classes, Graphics, Controls, Forms,
  Dialogs, unt_Details_base, unt_TraceWin, ExtCtrls, StdCtrls, unt_tool,
  xmldom, XMLIntf, msxmldom, XMLDoc, Vcl.Buttons, TextEditor, RxStrHlder,
  TEDataModU;

type
  TFrame_XML = class(Tframe_BaseDetails)
    XMLDoc: TXMLDocument;
    Panel1: TPanel;
    btnFormat: TSpeedButton;
    btnFullView: TSpeedButton;
    SizeLabel: TLabel;
    btnNotepad: TSpeedButton;
    btnHex: TSpeedButton;
    btnFull: TSpeedButton;
    Editor: TTextEditor;
    procedure btnFormatClick(Sender: TObject);
    procedure btnFullClick(Sender: TObject);
    procedure btnFullViewClick(Sender: TObject);
    procedure btnHexClick(Sender: TObject);
    procedure btnNotepadClick(Sender: TObject);
  private
    FLastHighlighter: TTEHighlighter;
    procedure InitEditor;
    procedure UpdateLabel(Size: Integer);
    function GetHighlighter(const S: string): TTEHighlighter;
    procedure LoadHighlighter(Highlighter: TTEHighlighter);
    procedure LoadTheme(Theme: TTeTheme);
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    Procedure AddDetails(TreeRec: PTreeRec; RootMember : TMember); override;
    procedure AddComment(const s: string);
    function HasFocus : boolean ; override;
    procedure SelectAll() ; override;
    procedure copySelected() ; override;
    procedure ApplyTheme(); override;
  end;

var
  Frame_XML: TFrame_XML;

implementation

uses
  Unt_receiver, superobject, JsonViewerFormU, JSONViewerFrameU, unt_Utils,
  Winapi.ShellAPI, HexEditorFormU, FullViewFormU, unt_TraceConfig, Vcl.Themes,
  LoggerProConfig,
  unt_Format, System.UITypes;

{$R *.dfm}

function GetAppFolder: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function AutoFileSizeStr(Int: Int64): String;
begin
  if Int < 1024 then
    Result := IntToStr(Int) + ' bytes'
  else if Int < 1024 * 1024 then
    Result := Format('%.n', [0.0+Int/1024]) + ' KB'
  else
    Result := Format('%.n', [0.0+Int/(1024*1024)]) + ' MB'
end;

{ TFrame_XML }
procedure TFrame_XML.AddComment(const s: string);
var
  Highlighter: TTEHighlighter;
begin
  TFrm_Trace(Owner).CurrentViewers.add(self) ;
  Editor.Lines.Text := s;
  Editor.LeftMargin.Visible := True;
  if Editor.Lines.Count = 1 then
  begin
    Editor.WordWrap.Active := True;
    Editor.LeftMargin.Visible := False;
  end;

  Highlighter := GetHighlighter(S);
  Log.Info('AddComment: ' + CopyStr(S, 19, 20), Ord(Highlighter).ToString);
  LoadHighlighter(Highlighter);
  //Log.Info(CopyStr('After LoadHighlighter', 32, 32), Ord(Self.FLastHighlighter).ToString);

  UpdateLabel(Length(s));
end;

function TFrame_XML.GetHighlighter(const S: string): TTEHighlighter;
begin
  Result := tehText;
  if IsXML(S) then
    Result := tehXML
  else
  if IsJSON(S) then
    Result := tehJSON
  else
  if IsSQL(S) then
    Result := tehSQL;
end;

procedure TFrame_XML.AddDetails(TreeRec: PTreeRec; RootMember: TMember);
  var
     //target : TStringList ;
     CurrentLine : string ;
  Highlighter: TTEHighlighter;
     SubMember: TMember;
  I: Integer;
  Procedure AddNode(SourceNode: IXMLNode{; DestNode: IXMLNode}; level : integer);
  Var
    //NewNode: IXMLNode;
    I: Integer;
    NodeName : string ;
    indent : string ;
    AttribName : string ;
    AttribValue : OleVariant ;
  Begin
    indent := '' ;
    for i := 0 to level-1 do
       indent := indent + '   ' ;
    NodeName := SourceNode.NodeName ;
    if SourceNode.NodeType = ntText Then Begin
      //If DestNode <> nil Then
      //  DestNode.Text := SourceNode.Text ;
      Editor.Lines.Add(indent + SourceNode.Text) ;
    end else begin
       //If DestNode = nil Then
       //  NewNode := XMLDoc2.AddChild(NodeName)
       //Else
       //  NewNode := DestNode.AddChild(NodeName);
       CurrentLine := indent + '<' + NodeName;
       // add attributes
       For I := 0 to SourceNode.AttributeNodes.Count - 1 do begin
          AttribName := SourceNode.AttributeNodes[I].NodeName ;
          AttribValue := SourceNode.AttributeNodes[I].NodeValue ;
          if AttribValue = null then
             AttribValue := '' ;
         CurrentLine := CurrentLine + ' ' + AttribName + '="' + AttribValue + '"' ;
         //NewNode.SetAttribute(SourceNode.AttributeNodes[I].NodeName, SourceNode.AttributeNodes[I].NodeValue);
       end ;
       if SourceNode.ChildNodes.Count = 0 then begin
          Editor.Lines.Add(CurrentLine + '/>') ;
       end else if (SourceNode.ChildNodes.Count = 1) and (SourceNode.ChildNodes[0].NodeType = ntText) then begin
          // single text sub node : add to the same line
          Editor.Lines.Add(CurrentLine + '>' + SourceNode.ChildNodes[0].Text + '</' + NodeName + '>') ;
       end else begin
          Editor.Lines.Add(CurrentLine + '>') ;
          For I := 0 to SourceNode.ChildNodes.Count - 1 do
            AddNode(SourceNode.ChildNodes[I]{, NewNode},level+1);
          Editor.Lines.Add(indent +'</' + NodeName + '>') ;
       end ;
    end ;
  End;
begin
   inherited;
   TFrm_Trace(Owner).CurrentViewers.add(self) ;
   //TFrm_Trace(Owner).XmlVisible := true ;   // viewer will be visible
   //inc (TFrm_Trace(Owner).ViewerCount) ;    // need to know the number of viewer to display

   Editor.Lines.Clear ;
   Editor.WordWrap.Active := False;
   //Editor.Highlighter := SynXMLSyn1;

   // ----- new code -----
   if RootMember.ViewerKind = CST_VIEWER_TXT then
   begin
     for I := 0 to RootMember.SubMembers.Count - 1 do
     begin
       SubMember := TMember(RootMember.SubMembers.Items[I]);
       Editor.Lines.Add(SubMember.Col2);
     end;
     Editor.LeftMargin.Visible := True;
     UpdateLabel(Length(Editor.Lines.Text))
   end
   else
   begin
     Editor.Lines.Text := RootMember.Col1;
     Editor.LeftMargin.Visible := False;
     //if (Length(RootMember.Col1) > 0) and (RootMember.col1[1] = '{') then
     // Editor.Highlighter := Self.SynJSONSyn1;
     UpdateLabel(Length(RootMember.Col1));
   end;

   Highlighter := GetHighlighter(Editor.Lines.Text);
   Log.Info('AddDetails: ' + CopyStr(Editor.Lines.Text, 19, 20),
     Ord(Highlighter).ToString);
   LoadHighlighter(Highlighter);
   exit;


   XMLDoc.Active   := False;
   XMLDoc.XML.Text := RootMember.col1;
   try
      XMLDoc.Active   := True;
      AddNode(XMLDoc.DocumentElement{, XMLDoc2.DocumentElement},0);
   except
      on e : exception do
         Editor.Lines.Add(e.Message) ;
   end ;
end;

procedure TFrame_XML.ApplyTheme;
begin
  inherited;
  if TraceConfig.AppDisplay_DarkTheme then
  begin
    LoadTheme(tetMonokai);
  end
  else
  begin
    LoadTheme(tetDefault);
  end;
end;

procedure TFrame_XML.btnFormatClick(Sender: TObject);
var
  O: ISuperObject;
  s: string;
begin
  try
    s := Editor.Lines.Text;
    if IsJSON(S) then
    begin
      O := SO(s);
      Editor.Lines.Text := FormatJSON(O.AsJSon(False, False)); // FormatJSON(s);
    end
    else
    if IsXML(S) then
      Editor.Lines.Text := FormatXML(S);
  except
    MessageDlg('Error trying to parse value', mtError, [mbOK], 0);
  end;
end;

procedure TFrame_XML.btnFullClick(Sender: TObject);
begin
  ShowFullViewForm(Editor.Lines.Text);
end;

procedure TFrame_XML.btnFullViewClick(Sender: TObject);
begin
  ShowJsonViewerForm(Editor.Lines.Text);
end;

procedure TFrame_XML.btnHexClick(Sender: TObject);
begin
  ShowHexEditorForm(Editor.Lines.Text);
end;

procedure TFrame_XML.btnNotepadClick(Sender: TObject);
var
  JsonFile: string;
  Notepad: string;
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  try
    StrList.Text := FormatJSON(Editor.Lines.Text);
    JsonFile := GetAppFolder + 'currentTrace.json';
    StrList.SaveToFile(JsonFile);
    Notepad := '"C:\Program Files\Notepad++\notepad++.exe"';
    ShellExecute(Handle, nil, pchar(Notepad), pchar('"'+JsonFile+'"'),
      '', SW_SHOW);
  finally
    StrList.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TFrame_XML.copySelected;
begin
  Editor.CopyToClipboard ;
end;
constructor TFrame_XML.Create(AOwner: TComponent);
begin
  inherited;
  InitEditor;
  ApplyTheme;
end;

//------------------------------------------------------------------------------
function TFrame_XML.HasFocus: boolean;
begin
  result := Focused or Editor.Focused ;
end;

procedure TFrame_XML.InitEditor;
begin
  FLastHighlighter := tehTEXT;
  Self.LoadHighlighter(tehTEXT);
end;

procedure TFrame_XML.LoadHighlighter(Highlighter: TTEHighlighter);
begin
  //if FLastHighlighter = Highlighter then exit;
  TEDataMod.LoadHighlighter(Editor, Highlighter);
  FLastHighlighter := Highlighter;
end;

procedure TFrame_XML.LoadTheme(Theme: TTeTheme);
begin
  TEDataMod.LoadTheme(Editor, Theme);
end;

//------------------------------------------------------------------------------
// CTRL-A : select all
procedure TFrame_XML.SelectAll;
begin
   Editor.SetFocus ;
   Editor.SelectAll;
end;

procedure TFrame_XML.UpdateLabel(Size: Integer);
begin
  SizeLabel.Caption := AutoFileSizeStr(Size);
  SizeLabel.Left := Self.Width - SizeLabel.Width - 20;
end;

initialization
  DeleteFile('TraceTool.00.log');

end.
 