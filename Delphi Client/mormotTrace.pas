unit mormotTrace;

interface

uses
  {$DEFINE MORMOT1}
  {$IFDEF MORMOT1}
    SynCommons, SynLog,
  {$ELSE}
    mormot.core.text, mormot.core.log, mormot.core.base,
  {$ENDIF}
    TraceTool, Vcl.Graphics;

{$IFDEF MORMOT1}
const
  TRACE_HEADER_LENGTH = 24;
type
  TWriterClass = TTextWriter;
{$ELSE}
const
  TRACE_HEADER_LENGTH = 27;
type
  TWriterClass = TEchoWriter;
{$ENDIF}

type
  TTraceToolEcho = class
  private
    FIsClient: Boolean;
    function GetPrefix: string;
    procedure SetLeftMsgColors(Level: TSynLogInfo; var ForeColor, BackColor:
        TColor);
    procedure SetTraceColors(Level: TSynLogInfo; var ForeColor, BackColor: TColor);
  public
    constructor Create;
    function TextWriterEcho(Sender: TWriterClass; Level: TSynLogInfo; const Text:
        RawUtf8): boolean;
    class procedure ClearAll;
    class procedure SetTraceWin(AName: string = 'Mormot');
  published
    property IsClient: Boolean read FIsClient write FIsClient;
  end;

var
  TraceToolEcho: TTraceToolEcho;
  WinTrace: IWinTrace = nil;

implementation

// ========= some colors =================
const
  LIGHT_PINK   = $00FFDDFF;   // $00FFE1FF;
  LIGHT_PINK2  = $00CBD3F8;
  LIGHT_GREEN  = $00D7FFD7;
  LIGHT_GREEN2 = $00D6E9D6;   // light_moneygreen

  LIGHT_RED    = $009D9DFF;
  BROWN        = $00000040; // BROWN

  COLOR_ORANGE = $000080FF;
  LIGHT_ORANGE = $00C1E0FF;
  LIGHT_PURPLE = $00F4C1EE;
  LIGHT_GRAY   = $00E1E7E8;
  LIGHT_BLUE   = $00FEF0D3;

  LIGHT_YELLOW = $00CCFFFF;
  BASE_TRACE_COLOR = $00FEE7EB;

function IsNumber(const C: Char): Boolean;
begin
  Result := Pos(C, '1234567890') > 0;
end;

class procedure TTraceToolEcho.ClearAll;
begin
  TTrace.ClearAll;
  if WinTrace <> nil then
    WinTrace.ClearAll;
end;

constructor TTraceToolEcho.Create;
begin
  FIsClient := False;
end;

function TTraceToolEcho.GetPrefix: string;
begin
  Result := '[Server] ';
  if IsClient then
    Result := '[Client] ';
end;

procedure TTraceToolEcho.SetLeftMsgColors(Level: TSynLogInfo; var ForeColor,
    BackColor: TColor);
begin
  ForeColor := clBlack;
  BackColor := BASE_TRACE_COLOR;
  if IsClient then
    ForeColor := clBlue;
end;

procedure TTraceToolEcho.SetTraceColors(Level: TSynLogInfo; var ForeColor,
    BackColor: TColor);
begin
  ForeColor := clBlack;
  BackColor := BASE_TRACE_COLOR;
  case Level of
    sllNone: ;
    sllInfo: ;
    sllDebug: ;
    sllTrace: ;
    sllWarning: BackColor := clInfoBk;
    sllError: BackColor := LIGHT_RED;
    sllEnter: ;
    sllLeave: ;
    sllLastError: ;
    sllException: ;
    sllExceptionOS: ;
    sllMemory: ;
    sllStackTrace: ;
    sllFail: ;
    sllSQL:
      begin
        ForeColor := clGreen;
        BackColor := LIGHT_GREEN;
      end;
    sllCache: ;
    sllResult:
      begin
        ForeColor := clBlue;
        BackColor := LIGHT_BLUE;
      end;
    sllDB:
      begin
        ForeColor := $0056479E;
        BackColor := LIGHT_ORANGE;
      end;
    sllHTTP: ForeColor := clBlue;
    sllClient: ;
    sllServer: ;
    sllServiceCall:
      begin
        ForeColor := clPurple;
        //BackColor := clInfoBk;
      end;
    sllServiceReturn:
      begin
        ForeColor := clBlue;
        BackColor := LIGHT_BLUE;
      end;
    sllUserAuth: ;
    sllCustom1: ;
    sllCustom2: ;
    sllCustom3: ;
    sllCustom4: ;
    sllNewRun: ;
    sllDDDError: ;
    sllDDDInfo: ;
    sllMonitoring: ;
  end;
end;

class procedure TTraceToolEcho.SetTraceWin(AName: string = 'Mormot');
begin
  WinTrace := TTrace.createWinTrace(AName, AName);
  WinTrace.ClearAll;
  WinTrace.Debug.Enabled := True;
end;

function TTraceToolEcho.TextWriterEcho(Sender: TWriterClass; Level:
    TSynLogInfo; const Text: RawUtf8): boolean;
var
  S: string;
  Trace: ITraceToSend;
  Node: ITraceNodeEx;
  ForeColor, BackColor: TColor;
  ForeColor2, BackColor2: TColor;
begin
  S := Utf8ToString(Text);
  if (Length(S) > 1) and IsNumber(S[1]) and IsNumber(S[2]) then
    Delete(S, 1, TRACE_HEADER_LENGTH);
  Trace := MainTrace;
  if WinTrace <> nil then
    Trace := WinTrace.Debug;

  SetLeftMsgColors(Level, ForeColor, BackColor);
  SetTraceColors(Level, ForeColor2, BackColor2);

  Node := Trace.CreateNodeEx;
  Node.LeftMsg := GetPrefix + LOG_LEVEL_TEXT[Level];
  Node.RightMsg := S;
  Node.AddBackgroundColor(BackColor2, 4);
  Node.AddFontDetail(3, False, False, ForeColor);
  Node.AddFontDetail(4, False, False, ForeColor2);
  Node.Send;

//Trace.Send(GetPrefix + LOG_LEVEL_TEXT[Level], S)
//  .SetBackgroundColor(BackColor2, 4)
//  .SetFontDetail(3, False, False, ForeColor)
//  .SetFontDetail(4, False, False, ForeColor2)

end;

initialization
  TraceToolEcho := TTraceToolEcho.Create;

finalization
  TraceToolEcho.Free;

end.

(* Values from mormot.core.log

  // Line 232
  LOG_LEVEL_TEXT: array[TSynLogInfo] of string[7] = (
    '       ',  // sllNone
    ' info  ',  // sllInfo
    ' debug ',  // sllDebug
    ' trace ',  // sllTrace
    ' warn  ',  // sllWarning
    ' ERROR ',  // sllError
    '  +    ',  // sllEnter
    '  -    ',  // sllLeave
    ' OSERR ',  // sllLastError
    ' EXC   ',  // sllException
    ' EXCOS ',  // sllExceptionOS
    ' mem   ',  // sllMemory
    ' stack ',  // sllStackTrace
    ' fail  ',  // sllFail
    ' SQL   ',  // sllSQL
    ' cache ',  // sllCache
    ' res   ',  // sllResult
    ' DB    ',  // sllDB
    ' http  ',  // sllHTTP
    ' clnt  ',  // sllClient
    ' srvr  ',  // sllServer
    ' call  ',  // sllServiceCall
    ' ret   ',  // sllServiceReturn
    ' auth  ',  // sllUserAuth
    ' cust1 ',  // sllCustom1
    ' cust2 ',  // sllCustom2
    ' cust3 ',  // sllCustom3
    ' cust4 ',  // sllCustom4
    ' rotat ',  // sllNewRun
    ' dddER ',  // sllDDDError
    ' dddIN ',  // sllDDDInfo
    ' mon   '); // sllMonitoring

var
  /// RGB colors corresponding to each logging level
  // - matches the TColor values, as used by the VCL
  // - first array is for the background, second is for the text (black/white)
  // - is defined as var and not const to allow customization at runtime
  LOG_LEVEL_COLORS: array[boolean, TSynLogInfo] of integer = (
   ($FFFFFF,    // sllNone
    $DCC0C0,    // sllInfo
    $DCDCDC,    // sllDebug
    $C0C0C0,    // sllTrace
    $8080C0,    // sllWarning
    $8080FF,    // sllError
    $C0DCC0,    // sllEnter
    $DCDCC0,    // sllLeave
    $C0C0F0,    // sllLastError
    $C080FF,    // sllException
    $C080F0,    // sllExceptionOS
    $C080C0,    // sllMemory
    $C080C0,    // sllStackTrace
    $4040FF,    // sllFail
    $B08080,    // sllSQL
    $B0B080,    // sllCache
    $8080DC,    // sllResult
    $80DC80,    // sllDB
    $DC8080,    // sllHTTP
    $DCFF00,    // sllClient
    $DCD000,    // sllServer
    $DCDC80,    // sllServiceCall
    $DC80DC,    // sllServiceReturn
    $DCDCDC,    // sllUserAuth
    $D0D0D0,    // sllCustom1
    $D0D0DC,    // sllCustom2
    $D0D0C0,    // sllCustom3
    $D0D0E0,    // sllCustom4
    $20E0D0,    // sllNewRun
    $8080FF,    // sllDDDError
    $DCCDCD,    // sllDDDInfo
    $C0C0C0),   // sllMonitoring
    // black/white text corresponding to each colored background:
   ($000000,    // sllNone
    $000000,    // sllInfo
    $000000,    // sllDebug
    $000000,    // sllTrace
    $000000,    // sllWarning
    $FFFFFF,    // sllError
    $000000,    // sllEnter
    $000000,    // sllLeave
    $FFFFFF,    // sllLastError
    $FFFFFF,    // sllException
    $FFFFFF,    // sllExceptionOS
    $000000,    // sllMemory
    $000000,    // sllStackTrace
    $FFFFFF,    // sllFail
    $FFFFFF,    // sllSQL
    $000000,    // sllCache
    $FFFFFF,    // sllResult
    $000000,    // sllDB
    $000000,    // sllHTTP
    $000000,    // sllClient
    $000000,    // sllServer
    $000000,    // sllServiceCall
    $000000,    // sllServiceReturn
    $000000,    // sllUserAuth
    $000000,    // sllCustom1
    $000000,    // sllCustom2
    $000000,    // sllCustom3
    $000000,    // sllCustom4
    $000000,    // sllNewRun
    $FFFFFF,    // sllDDDError
    $000000,    // sllDDDInfo
    $000000));  // sllMonitoring

  /// console colors corresponding to each logging level
  // - to be used with mormot.core.os TextColor()
  // - is defined as var and not const to allow customization at runtime
  LOG_CONSOLE_COLORS: array[TSynLogInfo] of TConsoleColor = (
    ccLightGray,    // sllNone
    ccWhite,        // sllInfo
    ccLightGray,    // sllDebug
    ccLightBlue,    // sllTrace
    ccBrown,        // sllWarning
    ccLightRed,     // sllError
    ccGreen,        // sllEnter
    ccGreen,        // sllLeave
    ccLightRed,     // sllLastError
    ccLightRed,     // sllException
    ccLightRed,     // sllExceptionOS
    ccLightGray,    // sllMemory
    ccCyan,         // sllStackTrace
    ccLightRed,     // sllFail
    ccBrown,        // sllSQL
    ccBlue,         // sllCache
    ccLightCyan,    // sllResult
    ccMagenta,      // sllDB
    ccCyan,         // sllHTTP
    ccLightCyan,    // sllClient
    ccLightCyan,    // sllServer
    ccLightMagenta, // sllServiceCall
    ccLightMagenta, // sllServiceReturn
    ccMagenta,      // sllUserAuth
    ccLightGray,    // sllCustom1
    ccLightGray,    // sllCustom2
    ccLightGray,    // sllCustom3
    ccLightGray,    // sllCustom4
    ccLightMagenta, // sllNewRun
    ccLightRed,     // sllDDDError
    ccWhite,        // sllDDDInfo
    ccLightBlue);   // sllMonitoring

    *)
