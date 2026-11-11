# AV on close (TFrm_Tool.Destroy) after viewing mORMot traces: investigation

## Checked
- The new code (`HasMormotUnitPrefix`, `TryFormatEmbeddedJSON`, `FormatJSONLenient`) only works on local strings and a `TStringBuilder` it frees itself. It creates no objects that outlive the call.
- The main change in behaviour is in the details TTextEditor. Comments used to be single lines. Now they can be multi-line JSON with the JSON highlighter, which adds code-folding ranges.
- **Repro test** (`scratchpad\avtest\AvTest.dpr`): TTextEditor + `TEDataMod` highlighter and theme loading + formatted mORMot sample. The form is shown, painted and freed:
  - single cases: plain text, formatted JSON with and without word wrap, one-line JSON, formatted text with TEXT highlighter: **no AV**
  - one editor reused across a sequence (formatted → simple → `{json}` → formatted, ×3, plus SelectAll), then freed: **no AV**
- Creation order is fine: `TEDataMod` is created first and freed last.
- `TFrm_Trace` FontDetails freeing (`vstTraceFreeNode`) is unchanged.

## Status
- Not reproduced outside the app. The call stack from the AV is needed: madExcept report, or the IDE Call Stack window.

---

# Follow-up: root cause from bugreport.txt, and fix

## Root cause (not the JSON formatting)
- Stack: `TFrm_Tool.Destroy` → `inherited` → `TPageControl.Destroy` → `TTabSheet.Destroy` → **a form still docked in that tab** → `TControl.Destroy` → `CM_UNDOCKCLIENT` → `TPageControl.GetPageFromDockClient` → `TList.Get` → AV.
- `TPageControl.Destroy` frees its page list *before* destroying its child tab sheets. Any form still docked at that point undocks against a freed list.
- How a docked form survives `TFrm_Tool.Destroy`:
  - **Closed WinTrace windows** (tab close button, or a client sending `CST_CLOSE_WIN`): `TFrm_Trace.CloseWin` calls `self.close` (`unt_TraceWin.pas:1542`). No `FormClose` sets `Action`, so it stays at the default `caHide`. The form is hidden and removed from `FormTraceList` and `BaseList`, but it **stays docked and is never freed**. The cleanup loop only walks `FormTraceList`, so it misses these.
  - **Tail / EventLog windows** are never freed in `TFrm_Tool.Destroy`, so they have the same exposure.
- The link to "viewing mORMot traces" is probably a coincidence: a WinTrace tab was closed, or a tail window was open, in those sessions.

## Fix (`Unt_Tool.pas`, `TFrm_Tool.Destroy`)
- After the existing frees and **before `inherited Destroy`**, the destructor scans `Screen.Forms` and frees every remaining `TFrmBase`. It rescans after each free, because `Screen.Forms` changes.
  - `IsDestroying := true` is set first so `TDockingPagecontrol.MyUndock` always allows the undock.
  - Each form now undocks while the page control is still valid.
- Builds: Release Win64 and Debug Win32 OK.

## Issues
- **(medium)** Not yet tested in the GUI. To test: open a WinTrace tab (e.g. run the mORMot app), close that tab, then exit the viewer. That should AV before the fix and not after.
- **(low)** Closed WinTrace windows still leak (hidden, not freed) until shutdown. Changing this to `caFree` was not done, because the `close; Free;` pattern in `TFrm_Tool.Destroy` would then need to change too.

## Modified files
- `Viewer source/Unt_Tool.pas` +18 -0
