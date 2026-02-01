unit HexEditorFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BCHexEditor, RxPlacemnt;

type
  THexEditorForm = class(TForm)
    FormStorage1: TFormStorage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Load(const S: string);
  end;

function ShowHexEditorForm(const S: string): Boolean;

implementation

{$R *.dfm}

function ShowHexEditorForm(const S: string): Boolean;
var
  HexEditorForm: THexEditorForm;
begin
  Result := False;
  HexEditorForm := THexEditorForm.Create(nil);
  try
    HexEditorForm.Load(S);
    HexEditorForm.ShowModal;
  finally
    HexEditorForm.Free;
  end;
end;

procedure THexEditorForm.FormCreate(Sender: TObject);
begin
  FormStorage1.IniFileName := ExtractFilePath(Application.ExeName) + 'layout.ini';
end;

{ THexEditorForm }

procedure THexEditorForm.Load(const S: string);
var
  HexEditor: TBCHexEditor;
  StrStream: TStringStream;
begin
  HexEditor := TBCHexEditor.Create(Self);
  HexEditor.Parent := Self;
  HexEditor.Align := alClient;
  HexEditor.Visible := True;

  StrStream := TStringStream.Create(S);
  try
    StrStream.Position := 0;
    HexEditor.LoadFromStream(StrStream);
  finally
    StrStream.Free;
  end;
end;

end.
