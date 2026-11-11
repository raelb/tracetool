# Dark mode: unreadable API-coloured traces (mORMot)

## Diagnosis
- **Cause is in the viewer, not the mORMot helper.** The helper sends light-theme colours: a light background (`$FEE7EB`, LIGHT_ORANGE, ...) and dark text (`clBlack`, `clBlue`, `clGreen`, ...).
- In dark mode the viewer **converts the background** with `ConvertToDarkTheme(bg, 0.2)`, so light lavender becomes navy and light orange becomes brown ([unt_TraceWin.pas:4204-4209](../../Viewer%20source/unt_TraceWin.pas#L4204-L4209)).
- It applied the **font colour unchanged** ([unt_TraceWin.pas:4189](../../Viewer%20source/unt_TraceWin.pas#L4189)), so black text ended up on navy. The Traces column also showed black text on dark grey.
- The selected row was readable only because it forces `clYellow`.

## Fix
- `unt_Utils.pas`: new `ConvertFontToDarkTheme(AColor)`. It keeps hue and saturation and maps lightness into the 0.70–0.90 band:
  - black becomes light grey
  - blue, green and purple become their light versions
- `unt_TraceWin.pas` `ChangeFontDetail`: in dark theme, API font colours now go through `ConvertFontToDarkTheme`. Light theme is unchanged.
- The fix applies to the trace tree, the detail tree and the watches, because they share `ChangeFontDetail`. It also covers every client (Delphi, .NET, Java), not just mORMot.
- `mormot.tracetool.pas`: no change needed.

## Issues
- **(medium)** Not compiled. The command-line build stops at `Unt_Tool.pas(40)`: `TraceTool.Inc` not found. It is not in the repo or in the skill's library list. The IDE build should work.
- **(low)** Pre-existing: `TraceTool.dproj` Debug has `DCC_DebugInformation=true`. MSBuild in 10.4 passes this as a stray `true` argument (error "true.dpr not found"). The IDE ignores it. I worked around it with `/p:DCC_DebugInformation=2` and did not change the dproj.

## Modified files
- `Viewer source/unt_Utils.pas` +14 -0
- `Viewer source/unt_TraceWin.pas` +4 -1

---

# Follow-up: compile

- **Build succeeded** (Debug/Win32, 353,355 lines). Output: `Viewer\TraceTool.exe`. No new warnings in the edited code.
- **dproj fixed:** Debug `DCC_DebugInformation` changed from `true` to `2` (full debug info, the 10.4 value). This removes the "true.dpr not found" MSBuild error.
- `TraceTool.Inc` and `TraceConst.inc` (copied in by you) are now in `Viewer source`. They are untracked; decide whether to commit them.
- Missing units were resolved by adding folders from your **IDE Win32 library path** to the command-line build only. The dproj was not changed for this. Folders added: madExcept/madBasic/madDisAsm, VirtualTree 7.6.1, SVGIconImageList (3), TTextEditor, unrxlib_275, delphi-orm (superobject), json viewer pckgs, KonopkaControls (RzTabs), SpTBXLib + tb2k, BCHexEditor, loggerpro.

## Issues
- **(medium)** Command-line builds rewrite `TraceTool.dproj`, because `VerInfo_AutoIncVersion=true`. The rewrite reformats the whole file (2-space indent, LF) and bumps the build number. It also changes `TraceTool.res`. I restored both from git and reapplied only the one-line fix. Turn off auto-increment if you plan more MSBuild builds.
- **(low)** The dproj has no `DCC_UnitSearchPath` and relies on the IDE's global library path. Command-line builds therefore need the paths passed in. This can be left as is.

## Modified files (this follow-up)
- `Viewer source/TraceTool.dproj` +1 -1

---

# Follow-up 2: dproj auto-increment off + search paths

- `VerInfo_AutoIncVersion` changed from `true` to `false` (Base). Builds no longer rewrite the dproj; checked with an md5 before and after building.
- Added `DCC_UnitSearchPath` to the **Base** PropertyGroup, so it applies to Win32 and Win64, Release and Debug. It holds the 16 library folders found last turn.
  - Konopka is a DCU folder, so its entry uses `...\Lib\RX10.4\$(Platform)` and picks Win32 or Win64 automatically.
- **All 4 builds succeed with no command-line paths:** Release/Debug × Win32/Win64.

## Issues
- **(low)** Every build regenerates `TraceTool.res` (the IDE does the same). I restored it from git to keep the diff clean.
- **(low)** `Viewer x64/TraceTool.exe` is tracked in git, so building x64 overwrites a committed binary. I restored the committed version. `Viewer\` (Win32) is untracked and now contains the latest Debug build.
- **(low)** The paths are absolute and specific to this machine (`C:\Delphi\...`, `C:\Users\Public\...\CatalogRepository`). That is fine for you, but not portable.

## Modified files (this follow-up)
- `Viewer source/TraceTool.dproj` +2 -1 (total for the task: +3 -2)
