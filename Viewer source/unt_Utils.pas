unit unt_Utils;

interface

uses
  System.Classes, System.SysUtils, WinApi.Windows, System.UITypes, System.UIConsts;

function ConvertToDarkTheme(AColor: TColor; BrightnessFactor: Single = 0.6):
    TColor;

function GetWindowsScalingFactor: Double;
function IsHighDPI: Boolean;

function AdjustDPI(Value: Extended): Integer;
function AdjustFromDPI(Value: Integer): Integer;

function CopyStr(const S: string; Count, ResLength: Integer): string;

implementation

uses
  Vcl.Graphics, System.Math, Vcl.Forms;

function CopyStr(const S: string; Count, ResLength: Integer): string;
var
  L: Integer;
begin
  L := Length(S);
  if Count < L then
    L := Count;
  Result := Copy(S, 1, L);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
  while Length(Result) < ResLength do
    Result := Result + ' ';
end;

function AdjustDPI(Value: Extended): Integer;
begin
  Result := Round(Value * (Screen.PixelsPerInch / 96));
end;

function AdjustFromDPI(Value: Integer): Integer;
begin
  Result := Round(Value * (96 / Screen.PixelsPerInch));
end;

function IsHighDPI: Boolean;
begin
  Result := False;
  if (Screen.PixelsPerInch > 96) or (GetWindowsScalingFactor > 1) then
    Result := True;
end;

function GetWindowsScalingFactor: Double;
var
  ScreenDC: HDC;
  LogicalScreenHeight: Integer;
  PhysicalScreenHeight: Integer;
  S: string;
  ScreenScalingFactor: Double;
begin
  ScreenDC := GetWindowDC(GetDesktopWindow);
  try
    LogicalScreenHeight := GetDeviceCaps(ScreenDC, VERTRES);
    PhysicalScreenHeight := GetDeviceCaps(ScreenDC, DESKTOPVERTRES);

    ScreenScalingFactor := PhysicalScreenHeight / LogicalScreenHeight;
    S := FormatFloat('0.00', ScreenScalingFactor);
    Result := StrToFloat(S);
  finally
    ReleaseDC(GetDesktopWindow, ScreenDC);
  end;
end;

function RGBToHSL(R, G, B: Byte; out H, S, L: Single): Boolean;
var
  MinVal, MaxVal, Delta: Single;
  RNorm, GNorm, BNorm: Single;
begin
  RNorm := R / 255;
  GNorm := G / 255;
  BNorm := B / 255;

  MinVal := Min(Min(RNorm, GNorm), BNorm);
  MaxVal := Max(Max(RNorm, GNorm), BNorm);
  Delta := MaxVal - MinVal;

  L := (MaxVal + MinVal) / 2;

  if Delta = 0 then
  begin
    H := 0;
    S := 0;
  end
  else
  begin
    if L < 0.5 then
      S := Delta / (MaxVal + MinVal)
    else
      S := Delta / (2 - MaxVal - MinVal);

    if RNorm = MaxVal then
      H := (GNorm - BNorm) / Delta
    else if GNorm = MaxVal then
      H := 2 + (BNorm - RNorm) / Delta
    else
      H := 4 + (RNorm - GNorm) / Delta;

    H := H * 60;
    if H < 0 then
      H := H + 360;
  end;

  Result := True;
end;

function HSLToRGB(H, S, L: Single): TColor;
var
  R, G, B: Byte;
  V1, V2: Single;

  function HueToRGB(V1, V2, VH: Single): Single;
  begin
    if VH < 0 then VH := VH + 1;
    if VH > 1 then VH := VH - 1;

    if (6 * VH) < 1 then
      Result := V1 + (V2 - V1) * 6 * VH
    else if (2 * VH) < 1 then
      Result := V2
    else if (3 * VH) < 2 then
      Result := V1 + (V2 - V1) * ((2 / 3) - VH) * 6
    else
      Result := V1;
  end;

begin
  if S = 0 then
  begin
    R := Round(L * 255);
    G := R;
    B := R;
  end
  else
  begin
    if L < 0.5 then
      V2 := L * (1 + S)
    else
      V2 := (L + S) - (S * L);

    V1 := 2 * L - V2;

    R := Round(255 * HueToRGB(V1, V2, H / 360 + (1 / 3)));
    G := Round(255 * HueToRGB(V1, V2, H / 360));
    B := Round(255 * HueToRGB(V1, V2, H / 360 - (1 / 3)));
  end;

  Result := R or (G shl 8) or (B shl 16);
end;

function ConvertToDarkTheme(AColor: TColor; BrightnessFactor: Single = 0.6): TColor;
var
  R, G, B: Byte;
  H, S, L: Single;
  NewL: Single;
  RGBColor: TColor;
begin
  // BrightnessFactor: 0.0 = fully darkened, 1.0 = original color
  // Default 0.6 provides moderate dimming for comfortable dark theme

  // Clamp factor to valid range
  if BrightnessFactor > 1.0 then BrightnessFactor := 1.0;
  if BrightnessFactor < 0.0 then BrightnessFactor := 0.0;

  // Ensure we have an actual RGB value (not a system color)
  RGBColor := ColorToRGB(AColor);

  // Extract RGB components from TColor
  R := RGBColor and $FF;
  G := (RGBColor shr 8) and $FF;
  B := (RGBColor shr 16) and $FF;

  // Convert RGB to HSL
  RGBToHSL(R, G, B, H, S, L);

  // Invert the lightness for dark theme
  NewL := 1.0 - L;

  // Interpolate between fully darkened (inverted) and original lightness
  // Factor 1.0 returns original color, Factor 0.0 returns fully inverted
  NewL := NewL * (1.0 - BrightnessFactor) + L * BrightnessFactor;

  // Boost saturation slightly for more vibrant colors
  S := S * 1.1;
  if S > 1.0 then S := 1.0;

  // Convert back to RGB
  Result := HSLToRGB(H, S, NewL);
end;

// Alternative approach: Simple inversion
function ConvertToDarkThemeSimple(AColor: TColor): TColor;
var
  R, G, B: Byte;
  RGBColor: TColor;
begin
  // Ensure we have an actual RGB value (not a system color)
  RGBColor := ColorToRGB(AColor);

  // Extract RGB components from TColor
  R := RGBColor and $FF;
  G := (RGBColor shr 8) and $FF;
  B := (RGBColor shr 16) and $FF;

  // Invert each component
  R := 255 - R;
  G := 255 - G;
  B := 255 - B;

  // Return the new color (TColor format: $00BBGGRR)
  Result := R or (G shl 8) or (B shl 16);
end;
end.


(* Notes:
I've provided two approaches for converting colors to dark theme equivalents:

ConvertToDarkTheme - This is the more sophisticated approach that converts the color to HSL (Hue, Saturation, Lightness), inverts the lightness value, and slightly reduces saturation for a more pleasing dark theme appearance. This preserves the hue while making light colors dark and vice versa.
ConvertToDarkThemeSimple - A simpler approach that just inverts each RGB component (subtracts from 255). This is faster but may produce less visually pleasing results for some colors.
The HSL-based approach generally works better for dark themes because it maintains the color's identity while appropriately adjusting brightness. For example, a light blue becomes a dark blue rather than an orange (which could happen with simple RGB inversion).
Both functions use Delphi's standard System.UITypes unit for color handling. The RGB/HSL conversion functions are built into modern Delphi versions.

*)
