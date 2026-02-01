unit JsonViewerFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, System.Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ActnList, StdActns, ImgList, Menus,
  ComCtrls, JSONViewerFrameU, RxPlacemnt, System.Actions;

type
  TJsonViewerForm = class(TForm)
    FormStorage1: TFormStorage;
    ActionList1: TActionList;
    actNewPage: TAction;
    actOpen: TAction;
    actFind: TAction;
    actFindNext: TAction;
    actFindPrevious: TAction;
    OpenDialog1: TOpenDialog;
    actClose: TAction;
    procedure actCloseExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPreviousExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFrame: TJSONViewerFrame;
    FJson: string;
  public
  end;

//var
//  JsonViewerForm: TJsonViewerForm;

function ShowJsonViewerForm(const JSON: string): Boolean;

implementation

{$R *.dfm}

function ShowJsonViewerForm(const JSON: string): Boolean;
var
  Form: TJsonViewerForm;
begin
  Result := False;
  Form := TJsonViewerForm.Create(nil);
  try
    Form.FJson := JSON;
    if Form.ShowModal = mrOK then
    begin
      Result := True;
    end;
  finally
    Form.Free;
  end;
end;

procedure TJsonViewerForm.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TJsonViewerForm.actFindExecute(Sender: TObject);
begin
  FFrame.Find;
end;

procedure TJsonViewerForm.actFindNextExecute(Sender: TObject);
begin
  FFrame.FindNext;
end;

procedure TJsonViewerForm.actFindPreviousExecute(Sender: TObject);
begin
  FFrame.FindPrevious;
end;

procedure TJsonViewerForm.actOpenExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Application.ProcessMessages;
    Screen.Cursor := crHourGlass;
    try
      FFrame.Open(OpenDialog1.FileName);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TJsonViewerForm.FormCreate(Sender: TObject);
begin
  FormStorage1.IniFileName := ExtractFilePath(Application.ExeName) + 'layout.ini';
  FFrame := TJSONViewerFrame.Create(Self, nil);
  FFrame.Parent := Self;
  FFrame.Align := alClient;
  FFrame.Visible := True;
end;

procedure TJsonViewerForm.FormShow(Sender: TObject);
begin
  FFrame.Init;
  FFrame.LoadJSON(FJson);
end;

end.
