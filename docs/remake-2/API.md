# WindUI Remake 2 — API and integration guide

Version: `1.7.0-remake.1`. Original WindUI by Footagesus, MIT. This is a UI library: example settings do not implement ESP, targeting or gameplay logic.

## Start here (including AI coding assistants)

1. Work in **WindUI-Remake-2**, not the frozen first-remake repo.
2. Read this file and [`RemakeExample.lua`](../../RemakeExample.lua). Use the exact APIs below; do not invent `LeftColumn`, `AddGroupbox`, `SetDependency` or cloud endpoints.
3. Keep the native WindUI font, registered themes, color editor, hotkeys and HUD. Do not replace the title font or globally redesign legacy controls.
4. Give every persisted control a **unique stable `Flag`** across all tabs, columns and subtabs. Labels are not identifiers.
5. The new two-column UI is opt-in. Existing `Window:Tab`, sidebar `Tab:SubTab` / `Tab:Tab`, and original element APIs still work.
6. Create controls first, then call `Window:EnablePresets` so the first save contains all flags. Late controls are registered too, but explicitly load again when their persisted state is needed.

### Build and launch

```sh
git submodule update --init --recursive
npm run build
python build/build-remake2.py
```

Use Luau/darklua installed on PATH. The built `dist/remake2.lua` embeds both library and the **full original menu, adapted rather than replaced**. Search, Visuals → Player/World, General, Themes, profile/preferences/history, both color examples, HUD and original numeric examples remain available. The repository is private: do not use anonymous raw GitHub URLs and **never embed a PAT in a Roblox script**. Run the locally obtained standalone file with your trusted runner. `dist/main.lua` is the library only. `ForkExample.lua` / `RestoreBaseline.lua` remain historical baseline files.

## Window, tabs and columns

```lua
local Window = WindUI:CreateWindow({
    Title = 'Sirius', Author = 'Ui library', Icon = 'star',
    HideSearchBar = false, SearchInTopbar = true, ToggleKey = Enum.KeyCode.RightShift,
    Folder = 'MyUI', Theme = 'Dark', NewElements = true,
    Size = UDim2.fromOffset(1100, 720),
    MinSize = Vector2.new(700, 420), MaxSize = Vector2.new(1200, 800),
    DescriptionMode = 'Tooltip', ContentPaddingTop = 8,
})
local Visuals = Window:Tab({Title = 'Visuals', Icon = 'image'})
local columns = Visuals:Columns({Gap = 16, MinColumnWidth = 260})
local main = columns.Left:Section({Title = 'Main'})
local other = columns.Right:Section({Title = 'Other'})
-- :Group({...}) on a COLUMN is an alias for :Section({...}).
```

- Each column stacks independent section cards; rows within a card are 50 logical pixels high.
- Section titles sit above the rounded card. Controls sit on one horizontal row: title on the left, control on the right.
- Widths adapt equally; below `2 * MinColumnWidth + Gap`, the complete left column stacks above the right one. The tab scrolls vertically. Reading order and values are preserved.
- `Columns` returns `.Left`, `.Right`, and `.UIElements` (`Root`, `Left`, `Right`).
- Use `Section` on a column to create a card. Legacy `Tab:Section` still means the original section element.
- Keep a reasonable minimum column width for long labels; labels truncate, not overlap. Customize control `Width` when necessary.

## Header search and profile actions

`SearchInTopbar = true` places the existing working search in the top-right button group, before minimize/fullscreen/close; it removes the old sidebar search gap. Keep `HideSearchBar = false` to enable search. Omit `SearchInTopbar` for legacy sidebar search.

`Window:CreateProfile(...)` now includes **Menu bind** above **Unload**. Click Menu bind and press a keyboard key; Escape cancels, Backspace/Delete clears it. Capturing does not also toggle the window. The example defaults to RightShift. `Window:SetToggleKey(Enum.KeyCode.F8)` changes it programmatically; nil unbinds. This window preference is session-local, not an element flag. Unload invokes the existing `Window:Destroy()` lifecycle and removes the library GUIs and connections. Do not replace it with a visual-only hide.

Preset Create/Rename forms are 306×148 logical pixels; JSON forms expand only when required. Actions and metadata rows use native themed icons. A click on the config trigger immediately dismisses its hover information before opening the preset list; editors replace rather than stack with the list.

## Horizontal icon subtabs (not sidebar children)

```lua
local pages = Visuals:IconTabs()
local enemies = pages:Tab({Id = 'enemies', Title = 'Enemies', Icon = 'user'})
local teammates = pages:Tab({Id = 'team', Title = 'Teammates', Icon = 'user-minus'})
local enemyColumns = enemies:Columns({MinColumnWidth = 260})
local teamColumns = teammates:Columns({MinColumnWidth = 260})
enemyColumns.Left:Section({Title = 'Enemy'}):Toggle({
    Title = 'Show players', Value = true, Flag = 'enemy.enabled',
})
teamColumns.Left:Section({Title = 'Team'}):Toggle({
    Title = 'Show teammates', Value = false, Flag = 'team.enabled',
})
pages:Select('team') -- ID, or 1-based page index; returns false for an unknown page.
enemies:Select()
```

The active top-right button shows icon + title; other buttons are compact icons. Pages are created once and keep independent values. Switching fades in the chosen page. No game model preview is fabricated; a real `Viewport` can be added separately. The previously supported sidebar nesting remains separate.

## Compact elements and examples

The following inherit compact row layout inside columns/cards. Their original APIs still apply.

```lua
local enabled = main:Toggle({
    Title = 'Enabled', Value = true, Flag = 'main.enabled',
    Desc = 'Enable dependent settings.',
    Hotkeys = {{Key = 'K', Mode = 'Toggle', Value = true}},
    Callback = function(value) print(value) end,
})
local distance = main:Slider({
    Title = 'Distance', Width = 140, ValueWidth = 44,
    Value = {Min = 0, Max = 1000, Default = 500}, Step = 1,
    Flag = 'main.distance', Callback = function(value) print(value) end,
})
local label = main:Input({Title = 'Label', Value = 'Sirius', Flag = 'main.label'})
main:Button({Title = 'Reset distance', Callback = function() distance:Set(500) end})
local color = other:Colorpicker({
    Title = 'Accent', Default = Color3.fromHex('2a94ff'), Transparency = .15,
    Flag = 'main.color',
    Callback = function(color, transparency, gradient) end,
})
```

- Toggle: `:Set(boolean)`, `.Value`, `:Lock()`, `:Unlock()`. Right-click retains the native multiple-hotkey manager and animated New Hotkey rows. `Hotkeys=false` disables binding support.
- Slider: `:Set(number)`, `:Get()`, `:SetRange(min,max)`, `:SetMin`, `:SetMax`, `.Value.Default`. Transparency-style 4px track with no large thumb. A compact rounded value editor sits to its right. Click it to type an exact number; input is snapped to Step and clamped to Min/Max. The floating value appears only while dragging, never on simple hover. Compact total width defaults to184 with a72px value slot; `Width` and `ValueWidth` remain configurable. `.UIElements.ValueInput` and `.UIElements.SliderContainer.TextBox` both reference the inline editor; `.UIElements.HoverValue` is the drag-only label.
- Input: `:Set(text)`, `.Value`, editable right-hand text box.
- Button: invokes `Callback`; use for actions, not saved state.
- Colorpicker: `:Set(color,transparency)`, `:SetGradient`, `:Export`, `:Import`, `:Open`. Existing HEX/RGB/HSV/HSL, alpha, gradients and swatch context-copy/paste are preserved.
- Common: `Title`, `Desc`, `Flag`, `Locked`, `Callback`, `:SetTitle`, `:Destroy` where supported.
- Paragraph, Section, Divider, Space, Image, Code, Group, HStack, VStack and Viewport remain the **native WindUI elements**, not forced into a 50px compact row. Use their original APIs documented in the repository and [FORK.md](../../FORK.md); do not assume they are compact controls. Cards support them through the same element factory.

### Dropdown / multi-select

```lua
local target = main:Dropdown({
    Title = 'Target', Values = {'Closest', 'Distance', 'Health'},
    Value = 'Closest', Width = 140, MenuWidth = 190, Flag = 'main.target',
    Callback = function(value) print(value) end,
})
local details = main:Dropdown({
    Title = 'Details', Values = {'Name', 'Distance', 'Health', 'Team'},
    Multi = true, AllowNone = true, Value = {'Name', 'Health'},
    SearchBarEnabled = true, Flag = 'main.details',
    Callback = function(values) end,
})
target:Select('Health')
details:Select({'Name', 'Distance'})
target:Refresh({'Closest', 'Distance', 'Health', 'Team'})
target:Open(); target:Close()
```

- Trigger stays beside its label. The nearby popup follows the trigger, respects UI scale and screen edges, flips above if needed, and has a soft shadow.
- Selection is marked by a right-hand check icon. Multi-select stays open; `AllowNone=false` prevents clearing the last selected option by mouse.
- Long preview text truncates. All options remain visible/searchable in the popup.
- Outside click, Escape, hidden dependency or hidden tab closes it. Only one compact dropdown is open per window.
- `.Values`, `.Value`, `.Opened`, `.Tabs`, `:Display`, `:Refresh`, `:Select`, `:Open`, `:Close`, `:Lock`, `:Unlock` are available.
- String values are recommended. `{Title='Name', Locked=true}` choices are supported; compact mode does not render rich descriptions or divider rows. Use original dropdown outside compact containers for those legacy menus.

## Animated visibility and dependencies

```lua
local builder = main:Toggle({Title='Builder', Value=false, Flag='builder.enabled'})
local settings = columns.Right:Section({
    Title = 'Builder settings',
    VisibleWhen = function() return builder.Value end,
})
local amount = settings:Slider({
    Title='Amount', Value={Min=0,Max=100,Default=35}, Flag='builder.amount',
})
local extra = main:Slider({
    Title='Extra', Value={Min=0,Max=10,Default=3}, Flag='builder.extra',
    VisibleWhen=function() return builder.Value and target.Value=='Health' end,
})
extra:SetVisible(false)       -- explicit master gate
extra:SetVisible(true)        -- predicate is still respected
extra:VisibleWhen(builder)    -- shorthand: builder.Value == true
extra:VisibleWhen(target, 'Health')
extra:SetVisible(false, true) -- instant transition request
```

- `VisibleWhen` must be a **pure, non-yielding function**; do not create controls, write files, or change values inside it. Errors hide the dependent slot.
- Opacity and layout height ease together, including reversal midway. Hidden elements retain values and remain registered for config save/load.
- Hidden slots stop interaction and hidden dependency hotkeys are unavailable. Once revealed, interaction resumes.
- Dependency checks run on Heartbeat, so direct setters, hotkeys and config loads are all observed without overwriting user callbacks.
- Cards and compact controls expose `:SetVisible` and `:VisibleWhen`. To opt a legacy element into this wrapper, pass `Visible=true` or `VisibleWhen=...` at creation.

## Built-in local presets

```lua
-- Call after creating the flagged controls. Requires executor file support.
local presets, err = Window:EnablePresets({Default='Default', Author='Your name'})
assert(presets, err)
local ok, err = presets:Create('My settings') -- saves current values, refuses overwrite
assert(ok, err)
presets:Save()                 -- selected preset
presets:Load('My settings')
presets:Rename('My settings', 'Renamed settings')
local json, err = presets:Export('Renamed settings')
presets:Import('Imported settings', json) -- validates; refuses overwrite
presets:Delete('Imported settings')
presets:Refresh()
presets:Toggle()
```

### UI

The original top window header, immediately right of the sidebar title block, contains a save icon and active preset name/chevron. It is not an extra row below the header. Hovering the name shows name, author and modified date. Clicking opens a rounded local Presets panel with the reference icon order (cloud/Presets on the left; upload, folder-clock/Recent and plus on the right), search and sorting below, new preset, load/save and per-row Rename/Export/Delete actions. Delete requires confirmation. Errors are shown; Export also copies when `setclipboard` exists, otherwise the selectable JSON box is available. Import uses a real JSON text box, not an invented external clipboard reader.

### Storage and guarantees

- Path: `WindUI/<Window.Folder>/config/<name>.json`.
- Needs `writefile`, `readfile`, `isfile`, `isfolder`, `makefolder`; enumeration uses `listfiles`, deletion/rename needs `delfile`. Not available in ordinary Roblox LocalScripts/Studio. `EnablePresets` returns `nil,error` when storage is unavailable.
- JSON contains `__version`, `__elements` (flagged control values and hotkeys), `__custom`, `__autoload`, `__meta` (author/created/modified) and `__hud` if a HUD exists.
- Theme can be persisted using a flagged theme dropdown whose callback calls `WindUI:SetTheme`. Unflagged values are not magically serialized. Window size, selected icon page and every arbitrary callback side effect are not presets.
- Names are trimmed, limited to64 UTF-8 bytes and reject path separators, control characters and reserved filename characters. Import rejects malformed JSON and invalid basic element records.
- Known element types are checked before application; load is synchronous for values, parser failure rolls values back. User callbacks may run asynchronously and their external side effects cannot be rolled back.
- Unknown flags are ignored, enabling configs to survive removed controls. Do not reuse the same flag for a different type.
- `presets.Current` is the selected name; `presets.Sort` accepts `'Created'`, `'Modified'` or `'Name'`; call `:Refresh()` after changing it.
- The cloud icon is visual reference styling only; folder-clock shows recently modified local presets, not version backups. This is **local persistence**, not cloud storage or multi-device sync. File operations are not crash-atomic.

## HUD retained from remake 1

```lua
local hud=Window:CreateHUD({Watermark=true,Keylist=true,Builds={YourRobloxName='Nightly'}})
hud:SetFields({'FPS','Ping','Username','Time','Day','Avatar','Platform','Build'})
hud:SetWatermarkEnabled(true)
hud:SetKeylistEnabled(true)
hud:ResetPositions()
```

Watermark telemetry, Sirius brand, full weekday, theme-aware opaque surfaces, white drag guides, Classic keylist, smaller binding plates, multiple hotkeys and config persistence remain available. The new example includes HUD controls in General.

## Verification

- `npm test`: inherited model tests + ConfigNames validation tests.
- Compile new modules with `luau-compile`; build with darklua.
- Execute [`tests/Remake2.lua`](../../tests/Remake2.lua) in the game after the demo: actual file create/save/load/rename/delete/import/export, flag registry, dependencies, dropdown selection, subtabs, responsive columns. Temporary `__qa_*` files are deleted and the selected preset is restored.
- Inspect real game screenshots in Light and Dark, open dropdown/presets, reveal dependencies and resize. Unit tests are not a substitute for visual inspection.

### Thin numeric controls

Sliders use thin tracks without oversized thumbs, plus a right-side rounded inline value editor. Floating values appear only during dragging and use a weak12% dark shadow. Numeric parsing, min/max, steps, callbacks, locks and config persistence are unchanged. `IsTextbox=false` hides the inline editor; drag feedback remains available. Inline editors use stable display width and clipped text; on focus the field expands smoothly within its control, with the track shrinking by the same amount, so typing never spills outside the control.

In compact section cards ProgressBar also uses a50px row, single-line title, thin track and read-only hover value. This fixes Balance/Collection mismatched row heights without turning progress indicators into interactive sliders. The outer section card owns the rounded background; compact rows do not draw separate rounded plates, including after theme changes.

Section cards hide the separator after the last visible row automatically. This also follows animated `SetVisible` / `VisibleWhen` changes; do not draw your own bottom separator on the final row.

Icon subtabs share one rounded background group. The active button has a neutral theme-matched surface and brighter icon; the inactive button remains neutral. Selection/hover transitions do not erase the selected state. `IconTabs().UIElements.Group` exposes the shared plate.

## Per-feature settings popovers

Any native element exposes `:Settings(options)`. On a toggle this adds the ellipsis **left of the switch**; clicking it does not toggle the feature. The popover uses an8px gap beside its button, flips/clamps at the viewport edge, has the feature title above independent rounded cards, and grows with content until scrolling is necessary. Escape, outside click or its close button closes it. Opening another feature closes the previous one.

```lua
local enabled = main:Toggle({Title = 'Overlay', Flag = 'overlay', Value = true})
local options = enabled:Settings({Title = 'Overlay', Width = 380})
local features = options:Section() -- untitled rounded card
features:Toggle({Title = 'Names', Flag = 'overlay_names', Value = true})
features:Toggle({Title = 'Health', Flag = 'overlay_health', Value = true})
features:Dropdown({Title = 'Style', Inline = true, Flag = 'overlay_style',
    Values = {'Classic', 'Minimal'}, Value = 'Classic'})
local display = options:Section({Title = 'Display'}) -- another card
local opacity = display:Slider({
    Title = 'Opacity', Flag = 'overlay_opacity',
    Value = {Min = 0, Max = 100, Default = 85}, Step = 1,
})
display:Dropdown({Title = 'Target', Flag = 'overlay_target',
    Values = {'Classic', 'Minimal'}, Value = 'Classic'})
options:Open()
options:Close()
```

`:Group` aliases `:Section`. A section supports the same native controls as column cards, including sliders, toggles, dropdowns, inputs and color pickers. Flags register with the same window preset manager; values survive closing the popover. `VisibleWhen` / `SetVisible` still work. These settings are UI examples, not implementations of gameplay features.

Alternatively supply `Settings = function(popover, element) ... end` in an element config, with optional `SettingsConfig = {Title = '...', Width = 380}`. The builder receives the same controller. Introspection: `.Opened`, `.Sections`, `.UIElements.Panel/Button/Title/Body/Columns`.

## Slider interaction and appearance follow-up

-50px compact rows,15px row labels and slightly larger example window1100×720 improve readability without changing the font family or sidebar typography.
- Inline value editors use the theme's neutral Button surface rather than a hard black plate. Default minimum value width72px prevents compact values such as `413.46m` from clipping. Focus expands the field smoothly, with the track shrinking by the same amount; blur restores its width. Min/Max/Step validation remains in the shared numeric model.
- Floating drag values fade/scale in and out with a weak shadow. Ordinary hover never opens them.
- Hover the slider control and press Left/Right to change by Step. Holding repeats after320ms, then every60ms. Bounds, locks, hidden controls, a closed window, Roblox's menu and active text editing are respected. No floating drag number opens for arrow input.

## Preset buttons and ordering follow-up

Toolbar icon buttons have delayed hover labels beside the button with an8px gap. Save is separate from the preset-name dropdown: `presets:QuickSave()` saves the selected preset, verifies its file and shows a named success/failure notification. `presets.UIElements.Save` is the actual quick-save button.

The Sort button opens a checked menu with **Newest First** (`Created`), **Recently Modified** (`Modified`) and **Alphabetical** (`Name`). `presets.Sort` accepts these keys; `:Refresh()` reapplies it. Introspection: `.SortOptions` and `.UIElements.SortMenu/Tooltips`. Sorting is local; it is not a cloud preset browser or an automatic-save service.

## Outlined groups and embedded selection

Feature popover groups default to a thin, low-contrast rounded outline with a quiet fill, matching the reference grouping rather than separate floating panels. `options:Section({Outlined=false})` restores the filled card. Ordinary column sections can opt in with `Outlined=true`; `.UIElements.Card` exposes the group surface. Only the groups have this outline: floating popup chrome still uses its soft shadow.

`group:Dropdown({Inline=true, Values={'Classic','Minimal'}, Value='Classic', Flag='style'})` renders all choices directly inside the group with a checkmark on the left and an animated selected surface. No extra popup or trigger is created. `ShowTitle=true` optionally displays the element title. It supports `Multi`, `AllowNone`, locked values, `:Select()`, `:Refresh()` and standard flag persistence. Without `Inline=true`, dropdowns retain the nearby floating checked menu. Embedded choices remain within the settings panel and contribute to its height/scrolling.

The reference-style example puts six inline choices in the first outlined group, then Subtick mode and Turn speed in a second group. The Selections gallery also demonstrates Classic/Minimal. Sort entries now include calendar, clock and alphabetical-order icons alongside the active checkmark. The preset toolbar was shifted seven logical pixels left.

## Gallery example and animation details

`RemakeExample.lua` now contains80 registered elements. In addition to Player/World/General/Themes, Elements expands to Controls, Selections, Containers and Media & code. Controls has Interactive/States icon subtabs; Selections covers single/multi/searchable/inline choices and colors/gradients; Containers demonstrates Group/HStack/VStack/Section/Divider/Space; Media contains an interactive local viewport, copyable code and avatar image. HUD preview provides watermark/keylist/field/position controls. Example callbacks are UI-only, not gameplay implementations. `WindUIForkDemo.Showcase` exposes the gallery controls.

- Compact dropdown previews follow configured Values order, regardless of click order. Long previews are clipped with an alpha fade at the right edge, never an ellipsis. Changing the selection fades out the old preview and fades in the new one.
- Preset refresh reuses named row instances and tweens their positions over240ms when sorting. New/removed or filtered rows fade in/out rather than rebuilding the entire list. `presets.Order` and `presets.RowCache` expose the current order and reusable rows for tests.
- Drag numbers on sliders inside a feature popover clamp to that popover, not the main window. This prevents the number from jumping sideways when the panel extends outside the menu.
- Outlined cards leave a one-pixel inset around their stroke so CanvasGroup clipping cannot remove the straight border edges.
- Example-only Anti-AFK is enabled by default under General. It listens for LocalPlayer.Idled and attempts a VirtualUser idle pulse. Unsupported APIs are reported; network disconnects and server kicks are not prevented. Its connection is disconnected on unload/rerun. It is not automatically installed by the library itself.
