unit unt_Format;

interface

function IsJSON(const S: string): Boolean;

function IsSQL(const S: string): Boolean;

function IsXML(const S: string): Boolean;

function FormatXML(const XMLString: string; const IndentSpaces: Integer = 2): string;

implementation

uses
  System.SysUtils, xmldom, XMLIntf, msxmldom, XMLDoc;

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
