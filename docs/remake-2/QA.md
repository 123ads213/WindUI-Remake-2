# Remake 2 verification

Build: `1.7.0-remake.1`.

## Preserved original menu

The first provisional demo was rejected because it replaced the old menu with simplified sample controls. **That provisional demo is not the delivered example.** `RemakeExample.lua` is now derived from the complete first-remake example. It retains Search, sidebar Visuals → Player/World, General, Themes, Profile/preferences/history, HUD, color and gradient examples, all original sliders/toggles/inputs/buttons and large/fractional numeric values. New containers change their placement, not their functionality.

Configuration UI is inside the original top window header immediately right of the sidebar/title, not in a separate row below it. Presets has cloud/title, upload, folder-clock/Recent and plus icons; search and sorting are below. All storage remains local.

## Automated checks

- Existing pure tests pass: NumberFormat display/parsing + 2001-point decimal lattice; TabTree12; HotkeyModel22; HUDGeometry31; HUDModel89.
- ConfigNames:22 checks pass (valid/invalid names, basic JSON record validation).
- `luau-compile`: new modules and standalone bundle compile.
- darklua builds `dist/main.lua`; standalone generator builds `dist/remake2.lua`.
- Live client `tests/Remake2.lua`:33 assertions passed on the full restored menu. Actual temporary preset create/save/load/import/export/rename/delete, invalid import rejection, value/dependency persistence, checkmark selection, independent subtabs, narrow/wide layout, preservation of original Profile/HUD/colors/progress examples and trigger containment inside original header.
- Live theme race check: selecting a tab while switching Ocean → Light yielded `TabTitle=17212d` and active background `dde7f6`, matching Light. Creator now cancels old per-property theme tweens, preventing stale Ocean/white text from overwriting newly applied colors.

## Visual inspection

Actual Roblox OS screenshots inspected, not generated mockups:
- Dark Player: ruler/wallet title icons, original numeric values, two-column cards and retained sidebar/profile.
- Light Themes + header presets: readable inactive tabs, correct header placement, reference icon order, nearby popover and soft shadow. `presets-light.jpg`.
- Dark General: original watermark/keylist settings, field selector, behavior and advanced numeric examples. `general-dark.jpg`.
- Compact dropdown: nearby checked single-select popup inspected in the first integration pass; current implementation retains the same popup component.

Limitations are explicit in API.md: no fake cloud service; Recent is modified-order local presets, not version backups; unflagged arbitrary state is not serialized; file writes are not crash-atomic; external callback side effects cannot be rolled back.

## Chrome polish follow-up

- Sirius / Ui library / star branding; search moved to the existing top-right button group without reserving sidebar search space.
- Compact 306×148 Create/Rename forms, icon title/actions, 132px action list; Import/Export expand only for JSON. Metadata has file/user/clock icons. Trigger click hides the information panel immediately; forms replace the list.
- Profile Menu bind above Unload. Keyboard capture supports Escape cancellation and Backspace/Delete clearing without accidentally toggling the menu. Transparency value moved 7 logical pixels nearer the track.
- Re-ran 33 integration checks and 17 new `tests/Chrome.lua` checks. Pure suites pass.
- Actual screenshots inspected: Dark compact editor and profile; Light profile with lower tooltip, native icons, readable labels, top-right Search and no overlap.
- Final live smoke tests: Search opens from its header button, accepts `Distance`, and closes normally; Unload actually destroys the window and removes its root GUI. Latest menu relaunched afterward. Profile synchronizes the Style label when reopened after an external theme change.

## Transparency-style numeric controls

`tests/ThinSliders.lua`:58 live assertions passed. Checks include five slider instances, hidden thumbs, thin4px tracks, inline value editors, drag-only feedback, exact abbreviated input and min/max clamping, invalid input restoration, locks, touch ratio mapping and fixed drag geometry. Balance/Collection match Gravity's50px row height, retain single-line titles and have no nested background plate. Toggle dependencies were verified for animated reveal/hide, collapsed layout, disabled interaction while hidden and retained values.

Card separators are visible only between visible rows; the last row has none. Live tests also hide/show Collection and verify Balance becomes the final row without a separator, then regains it when Collection reappears.

Final field/subtab follow-up: live checks verify the right editor stays within its row, ordinary hover does not show floating values, dragging does, shared subtab background exists, and the accent highlight follows the active page.

Historical screenshot `slider-fields.png` (superseded by the neutral-surface follow-up) showed: right-side value pills stay inside their rows; no floating number appears on ordinary hover; shared Enemy/Team plate and the former blue active selection are visible. Runtime bounds were also verified at700px and1000px window widths.

## Animated controls and feature settings

- `tests/SliderPolish.lua`:23 live assertions pass, including actual virtual keyboard Left/Right and held repeat, max/min clamping, lock/hover/focus guards, width/fit of413.46m, animated full-value expansion, fade-in/out lifecycle and neutral surfaces in Dark/Light.
- `tests/FeatureSettings.lua`:26 live assertions pass. The test opens the actual ellipsis, checks grouped cards/native slider/8px proximity, Escape/outside dismissal, the three checked sorting choices, named quick-save notification and real file roundtrip of main and popup settings. It deletes only its own temporary preset and restores the selected preset/values.
- Existing58 slider/layout checks and33 integration checks remain regression suites; compact row expectations now use50px, not44px.

## Outlined feature groups and inline dropdown follow-up

- `tests/InlineSettings.lua`:22 live assertions passed: both rounded outlined groups, embedded choices, one active checkmark, horizontal containment, all three filter icons, and actual file save/load of the embedded dropdown selection. Temporary test preset removed.
- Re-ran26 feature-settings checks and23 animated slider/keyboard checks successfully after this change. Pure suites passed, and bundled Luau compiled successfully.
- Actual in-game screenshot inspected: the first group contains Names/Health and embedded Classic/Minimal; the second contains Opacity. Fine group outlines remain distinct from the outer popup shadow; no detached dropdown or overlapping controls.

## Sorting, fade previews, complete example and AFK follow-up

- `tests/Followup.lua`:33 live assertions passed:17 native element types registered, active Anti-AFK connection, ordered/faded dropdown preview, animated selection replacement, persistent row identity and animated sorting, and popup-slider number alignment.
- A simulated Idled signal invoked the installed handler successfully (`Success=true`) in the current executor. This verifies its API call, not protection against network/server disconnects.
- Actual screenshots inspected: complete outlined feature groups (all four edges visible), six inline choices with selected checkmark, second toggle/slider group; Controls with input/actions and icon subtabs; native containers; local model viewport and copyable code.
- Found and repaired the inherited Image element parenting condition: unparented images are now attached to their requested container, expose ElementFrame/UIElements.Main and participate in sizing.

Final combined regression on the rebuilt standalone menu: Followup33, Remake2 integration33, FeatureSettings26, InlineSettings30, SliderPolish23 and ThinSliders58 —203 live assertions passed. All pure suites passed. The Image gallery instance is parented, sized846×475.875 at1100px menu width, and its Roblox avatar thumbnail loaded successfully.
