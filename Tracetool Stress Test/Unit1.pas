unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  Vcl.StdCtrls, Vcl.Mask, RzEdit, RzSpnEdt, RxPlacemnt;

type
  TPerson = class;

  TForm1 = class(TForm)
    btnSendStr: TButton;
    btnTraceObjects: TButton;
    btnSendStrList: TButton;
    Button4: TButton;
    btnSimpleTrace: TButton;
    seObjects: TRzSpinEdit;
    seCount: TRzSpinEdit;
    seString: TRzSpinEdit;
    FormStorage1: TFormStorage;
    btnODS: TButton;
    procedure btnODSClick(Sender: TObject);
    procedure btnSendStrClick(Sender: TObject);
    procedure btnTraceObjectsClick(Sender: TObject);
    procedure btnSendStrListClick(Sender: TObject);
    procedure btnSimpleTraceClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FList: TObjectList<TPerson>;
    procedure AddObjects(Value: Integer);
    procedure SendTraces;
    { Private declarations }
  public
    { Public declarations }
  end;

  TPerson = class
  private
    FAge: Integer;
    FId: Integer;
    FName: string;
    FText: string;
  published
    property Age: Integer read FAge write FAge;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Text: string read FText write FText;
  end;

var
  Form1: TForm1;

implementation

uses
  TraceTool, REST.Json, System.JSON;

{$R *.dfm}

function FormatJSON(json: String): String;
var
  tmpJson: TJsonValue;
begin
  tmpJson := TJSONObject.ParseJSONValue(json);
  Result := TJson.Format(tmpJson);

  FreeAndNil(tmpJson);
end;

procedure TForm1.AddObjects(Value: Integer);
var
  I: Integer;
  Person: TPerson;
begin
  for I := 0 to Value - 1 do
  begin
    Person := TPerson.Create;
    Person.Id := FList.Count + 1;
    Person.Name := 'Jonathan Doe';
    Person.Age := 46;
    Person.Text := 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    FList.Add(Person);
  end;
end;

procedure TForm1.btnODSClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 4 do
    OutputDebugString(PChar('Hello world.'));
end;

procedure TForm1.btnSendStrClick(Sender: TObject);
var
  I: Integer;

  function GetStr: string;
  var
    J: Integer;
  begin
    Result := '';
    for J := 1 to I do
      Result := Result + 's';
  end;
begin
  for I := 1 to seString.IntValue do
    MainTrace.Send(I, GetStr);
end;

procedure TForm1.btnTraceObjectsClick(Sender: TObject);
begin
  SendTraces;
end;

procedure TForm1.btnSendStrListClick(Sender: TObject);
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  try
    StrList.Add('one');
    StrList.Add('one');
    StrList.Add('one');
    StrList.Add('one');
    MainTrace.SendStrings('StrList', StrList);
  finally
    StrList.Free;
  end;
end;

procedure TForm1.btnSimpleTraceClick(Sender: TObject);
var
  I: Integer;
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  try
    StrList.Add('One');
    StrList.Add('Two');
    for I := 0 to 5 do
    begin
      MainTrace.Send('Hello', 'World');
      MainTrace.Send('Message').SetColor(clWhite);
      MainTrace.SendStrings('Strings', StrList);
      TTrace.Debug.SendXml('as xml', StrList.Text);
      MainTrace.Send('json string', '{"hello":"world"}');
      MainTrace.Send('xml string', '<?xml><books>Book</books></xml>');
      MainTrace.Send('sql string', 'SELECT * from BOOKS');
      TTrace.Warning.Send('Warning', 'Warning message');
      TTrace.Error.Send('Error', 'Error message');
    end;
  finally
    StrList.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  I: Integer;
  S: string;
  StrList: TStringList;
begin
  { comment stops displaying at 409 }
  FList.Clear;
  StrList := TStringList.Create;
  try
    for I := 1 to seCount.IntValue do
    begin
      TTrace.Debug.Send('---');
      TTrace.Debug.Send('Left msg', 'Right msg').SetColor(clWhite);
      AddObjects(1);
      S := TJson.ObjectToJsonString(FList);
      TTrace.Debug.Send('Object as string (' + FList.Count.ToString + ')', S);
      StrList.Text := FormatJson(s);
      TTrace.Debug.SendStrings('Object as TStringList (' +
        FList.Count.ToString + ')', StrList);
      TTrace.Debug.SendXml('as xml', StrList.Text);
      TTrace.Debug.SendTable('as table', StrList);

      TTrace.Warning.Send('Warning', 'Warning message');
      TTrace.Error.Send('Error', 'Error message');
    end;
  finally
    StrList.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FList.Free;
end;

procedure TForm1.SendTraces;
var
  I: Integer;
  S: string;
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  try
    for I := 1 to 8 do
    begin
      TTrace.Debug.Send('---');
      TTrace.Debug.Send('Simple trace');
      TTrace.Debug.Send('Left msg', 'Right msg');
      AddObjects(seObjects.IntValue);
      S := TJson.ObjectToJsonString(FList);
      TTrace.Debug.Send('Object as string (' + FList.Count.ToString + ')', S);
      StrList.Text := FormatJson(s);
      TTrace.Debug.SendStrings('Object as TStringList (' +
        FList.Count.ToString + ')', StrList);
      TTrace.Debug.SendXml('as xml', StrList.Text);
      TTrace.Debug.SendTable('as table', StrList);
      TTrace.Debug.Send('Simple trace');
    end;
  finally
    StrList.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OutputDebugString(PChar('Hello world.'));
  FList := TObjectList<TPerson>.Create;
  FormStorage1.IniFileName := ExtractFilePath(Application.ExeName) + 'layout.ini';
end;

initialization
  TTrace.ClearAll;

end.
