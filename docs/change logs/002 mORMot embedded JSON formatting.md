# mORMot traces: format embedded JSON in the details viewer

## Where
- Comment text goes to `TFrame_XML.AddComment` (called from `unt_TraceWin.pas:1337`), so the change is in `unt_Details_xml.pas`. The helper functions are in `unt_Format.pas`.

## What
- `unt_Format.pas` has three new functions:
  - `HasMormotUnitPrefix(S)`: true if S starts with `mormot.`. The prefixes are in the const array `MORMOT_UNIT_PREFIXES`, so more can be added.
  - `FormatJSONLenient(Json)`: a pretty-printer that only re-indents (2 spaces) and does not parse. It **keeps key order** and accepts mORMot extended JSON with **unquoted keys** (`{FileName:"..."}`). The strict `TJSONObject` parser would fail on those, and superobject would reorder keys. It is string- and escape-aware and keeps `{}` / `[]` on one line.
  - `TryFormatEmbeddedJSON(S, Formatted)`: finds the first `{`/`[` and its matching bracket, then returns **head / formatted JSON / tail**, each on its own line. If the brackets are unbalanced or there is no `:` or `"` in the block, it returns False and leaves the text unchanged.
- `TFrame_XML.AddComment`: if a comment starts with a mORMot unit name and contains JSON, the editor shows the formatted text with the **JSON highlighter**. Otherwise it behaves as before.

## Verified
- Console test on the screenshot samples:
  - `CreateMissingTables on {...}` → head + JSON
  - `TRestHttpServer(...) {...} initialized for root` → head + JSON + tail
  - `GetTables=[...]` → formatted correctly
  - a trace with no JSON, and one with unbalanced brackets → left unchanged
- Viewer builds (Debug Win32).

## Issues
- **(low)** Only the **first** JSON block in a message is formatted. Any later block stays in the tail, unformatted.
- **(low)** Pre-existing: once a one-line comment turns word wrap on in `AddComment`, it is never turned off for later multi-line comments. Formatted JSON still displays fine. Not changed.
- **(low)** The Format button (`btnFormatClick`) still only handles text that starts with `{` or `<?xml`. These traces don't need it, because they are formatted when loaded.

## Modified files
- `Viewer source/unt_Format.pas` +181 -0
- `Viewer source/unt_Details_xml.pas` +12 -2

## Follow-up: indented messages
- mORMot indents nested log lines, so the text started with spaces and the `mormot.` prefix check failed. `HasMormotUnitPrefix` now does `TrimLeft` before checking. The head piece was already trimmed when the text is split.
- Tested with leading spaces and a tab: detected and formatted. Viewer rebuilt (Debug Win32).
- `Viewer source/unt_Format.pas` +2 -1

## Follow-up 2: "still not working"
- Tabs were already handled: `TrimLeft` strips all chars <= space, including #9. The test with a leading tab passed.
- **Cause: the x64 viewer exe was out of date.** `Viewer x64\TraceTool.exe` was built at 02:30, the fix was saved at 02:34, and the x64 viewer was run at 02:35.
- Rebuilt both exes with the fix:
  - `Viewer x64\TraceTool.exe` (Release Win64)
  - `Viewer\TraceTool.exe` (Debug Win32)
- **(low)** dproj quirk: only Release Win64 sets `DCC_ExeOutput=..\Viewer x64\`. Debug (`Cfg_2`) sets `..\Viewer\` for both platforms, so a **Debug Win64 build overwrites the Win32 exe** in `Viewer\`. This happened once during this turn and has been fixed by rebuilding Win32. Fix: add `<DCC_ExeOutput>..\Viewer x64\</DCC_ExeOutput>` to the `Cfg_2_Win64` group. Not changed yet.
