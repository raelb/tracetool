unit TEDataModU;

interface

uses
  System.SysUtils, System.Classes, RxStrHlder, TextEditor;

type
  TTEHighlighter = (tehTEXT, tehJSON, tehXML, tehSQL);
  TTETheme = (tetDefault, tetMonokai);

  TTEDataMod = class(TDataModule)
    shJSON: TStrHolder;
    shMonokai: TStrHolder;
    shDefault: TStrHolder;
    shSQL: TStrHolder;
    shXML: TStrHolder;
    shWindows11Dark: TStrHolder;
    shText: TStrHolder;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadHighlighter(Editor: TTextEditor; Highlighter: TTEHighlighter);
    procedure LoadTheme(Editor: TTextEditor; Theme: TTETheme);
  end;

var
  TEDataMod: TTEDataMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TTEDataMod.LoadHighlighter(Editor: TTextEditor; Highlighter:
    TTEHighlighter);
var
  S: string;
  StrStream: TStringStream;
begin
  S := '';
  case Highlighter of
    tehTEXT: S := TEDataMod.shTEXT.Strings.Text;
    tehJSON: S := TEDataMod.shJSON.Strings.Text;
    tehXML:  S := TEDataMod.shXML.Strings.Text;
    tehSQL:  S := TEDataMod.shSQL.Strings.Text;
  end;
  StrStream := TStringStream.Create(S);
  try
    StrStream.Position := 0;
    Editor.Highlighter.LoadFromStream(StrStream);
  finally
    StrStream.Free;
  end;
end;

procedure TTEDataMod.LoadTheme(Editor: TTextEditor; Theme: TTETheme);
var
  S: string;
  StrStream: TStringStream;
begin
  S := '';
  case Theme of
    tetDefault: S := TEDataMod.shDefault.Strings.Text;
    tetMonokai: S := TEDataMod.shMonokai.Strings.Text;
  end;
  StrStream := TStringStream.Create(S);
  try
    StrStream.Position := 0;
    Editor.Highlighter.Colors.LoadFromStream(StrStream);
  finally
    StrStream.Free;
  end;
end;

end.
