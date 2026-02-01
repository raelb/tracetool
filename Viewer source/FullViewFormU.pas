unit FullViewFormU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RxPlacemnt, RxStrHlder,
  TextEditor, System.Actions, Vcl.ActnList;

type
  TFullViewForm = class(TForm)
    Panel1: TPanel;
    FormStorage1: TFormStorage;
    Editor: TTextEditor;
    ActionList1: TActionList;
    actClose: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure InitEditor;
    { Private declarations }
  public
    { Public declarations }
    procedure Load(const s: string);
  end;

function ShowFullViewForm(const S: string): Boolean;

implementation

uses
  TEDataModU;

{$R *.dfm}

function ShowFullViewForm(const S: string): Boolean;
var
  FullViewForm: TFullViewForm;
begin
  Result := False;
  FullViewForm := TFullViewForm.Create(nil);
  try
    FullViewForm.Load(S);
    FullViewForm.ShowModal;
  finally
    FullViewForm.Free;
  end;
end;

procedure TFullViewForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFullViewForm.FormCreate(Sender: TObject);
begin
  FormStorage1.IniFileName := ExtractFilePath(Application.ExeName) + 'layout.ini';
  InitEditor;
end;

procedure TFullViewForm.InitEditor;
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

{ TFullViewForm }

procedure TFullViewForm.Load(const s: string);
begin
  Editor.Lines.Text := S;
end;

end.
