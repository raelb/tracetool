unit unt_Format;

interface

function IsJSON(const S: string): Boolean;

function IsSQL(const S: string): Boolean;

function IsXML(const S: string): Boolean;

function FormatXML(const XMLString: string; const IndentSpaces: Integer = 2): string;

// True if S starts with a mORMot unit name (e.g. 'mormot.orm.sqlite3.TRestOrmServerDB(...)')
function HasMormotUnitPrefix(const S: string): Boolean;

// Lenient JSON pretty-printer: keeps key order, tolerates mORMot extended JSON
// (unquoted keys). Does not validate - only re-indents.
function FormatJSONLenient(const Json: string; const IndentSize: Integer = 2): string;

// Splits S into <head> <json block> <tail>, and returns them on separate lines
// with the json block formatted. Returns False if no json block found.
function TryFormatEmbeddedJSON(const S: string; out Formatted: string): Boolean;

implementation

uses
  System.SysUtils, xmldom, XMLIntf, msxmldom, XMLDoc;

const
  MORMOT_UNIT_PREFIXES: array[0..0] of string = ('mormot.');

function HasMormotUnitPrefix(const S: string): Boolean;
var
  Prefix, Trimmed: string;
begin
  Trimmed := TrimLeft(S); // mORMot indents nested log lines
  for Prefix in MORMOT_UNIT_PREFIXES do
    if Trimmed.StartsWith(Prefix) then
      Exit(True);
  Result := False;
end;

// Finds the first '{' or '[' and its matching closing bracket (string aware)
function FindJSONBlock(const S: string; out StartPos, EndPos: Integer): Boolean;
var
  i, Depth: Integer;
  InStr: Boolean;
begin
  Result := False;
  StartPos := 0;
  EndPos := 0;
  for i := 1 to Length(S) do
    if CharInSet(S[i], ['{', '[']) then
    begin
      StartPos := i;
      Break;
    end;
  if StartPos = 0 then
    Exit;

  Depth := 0;
  InStr := False;
  i := StartPos;
  while i <= Length(S) do
  begin
    if InStr then
    begin
      if S[i] = '\' then
        Inc(i) // skip escaped char
      else if S[i] = '"' then
        InStr := False;
    end
    else
      case S[i] of
        '"': InStr := True;
        '{', '[': Inc(Depth);
        '}', ']':
          begin
            Dec(Depth);
            if Depth = 0 then
            begin
              EndPos := i;
              Exit(True);
            end;
          end;
      end;
    Inc(i);
  end;
end;

function FormatJSONLenient(const Json: string; const IndentSize: Integer = 2): string;
var
  SB: TStringBuilder;
  i, j, Depth: Integer;
  c: Char;
  InStr: Boolean;

  procedure NewLine;
  begin
    SB.Append(sLineBreak);
    if Depth > 0 then
      SB.Append(' ', Depth * IndentSize);
  end;

begin
  SB := TStringBuilder.Create;
  try
    Depth := 0;
    InStr := False;
    i := 1;
    while i <= Length(Json) do
    begin
      c := Json[i];
      if InStr then
      begin
        SB.Append(c);
        if (c = '\') and (i < Length(Json)) then
        begin
          Inc(i);
          SB.Append(Json[i]);
        end
        else if c = '"' then
          InStr := False;
      end
      else
        case c of
          '"':
            begin
              SB.Append(c);
              InStr := True;
            end;
          '{', '[':
            begin
              // keep empty {} / [] on one line
              j := i + 1;
              while (j <= Length(Json)) and (Json[j] <= ' ') do
                Inc(j);
              if (j <= Length(Json)) and
                 (((c = '{') and (Json[j] = '}')) or ((c = '[') and (Json[j] = ']'))) then
              begin
                SB.Append(c).Append(Json[j]);
                i := j;
              end
              else
              begin
                SB.Append(c);
                Inc(Depth);
                NewLine;
              end;
            end;
          '}', ']':
            begin
              if Depth > 0 then
                Dec(Depth);
              NewLine;
              SB.Append(c);
            end;
          ',':
            begin
              SB.Append(c);
              NewLine;
            end;
          ':': SB.Append(': ');
          #0..' ': ; // drop whitespace outside strings
        else
          SB.Append(c);
        end;
      Inc(i);
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function TryFormatEmbeddedJSON(const S: string; out Formatted: string): Boolean;
var
  StartPos, EndPos: Integer;
  Head, Json, Tail: string;
begin
  Result := False;
  Formatted := S;
  if not FindJSONBlock(S, StartPos, EndPos) then
    Exit;
  Json := Copy(S, StartPos, EndPos - StartPos + 1);
  // must look like json: object with key/value, or array with strings
  if (Pos(':', Json) = 0) and (Pos('"', Json) = 0) then
    Exit;

  Head := Trim(Copy(S, 1, StartPos - 1));
  Tail := Trim(Copy(S, EndPos + 1, MaxInt));
  Formatted := FormatJSONLenient(Json);
  if Head <> '' then
    Formatted := Head + sLineBreak + Formatted;
  if Tail <> '' then
    Formatted := Formatted + sLineBreak + Tail;
  Result := True;
end;

function IsJSON(const S: string): Boolean;
begin
  Result := (Length(s) > 0) and ((s[1] = '{') or (S[1] = '['));
end;

function IsSQL(const S: string): Boolean;
begin
  Result := (Length(S) > 7) and (Uppercase(Copy(S, 1, 7)) = 'SELECT ');
end;

function IsXML(const S: string): Boolean;
begin
  Result := (Length(S) > 5) and (Copy(S, 1, 5) = '<?xml');
end;

// Alternative method with more control over formatting
function FormatXML(const XMLString: string; const IndentSpaces: Integer = 2): string;
var
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromXML(XMLString);
    XMLDoc.Active := True;
    XMLDoc.Options := XMLDoc.Options + [doNodeAutoIndent];
    XMLDoc.NodeIndentStr := StringOfChar(' ', IndentSpaces);
    XMLDoc.SaveToXML(Result);
  finally
    XMLDoc := nil;
  end;
end;

end.
