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

`tests/ThinSliders.lua`:58 live assertions passed. Checks include five slider instances, hidden thumbs, thin4px tracks, inline value editors, drag-only feedback, exact abbreviated input and min/max clamping, invalid input restoration, locks, touch ratio mapping and fixed drag geometry. Balance/Collection match Gravity's44px row height, retain single-line titles and have no nested background plate. Toggle dependencies were verified for animated reveal/hide, collapsed layout, disabled interaction while hidden and retained values.

Card separators are visible only between visible rows; the last row has none. Live tests also hide/show Collection and verify Balance becomes the final row without a separator, then regains it when Collection reappears.

Final field/subtab follow-up: live checks verify the right editor stays within its row, ordinary hover does not show floating values, dragging does, shared subtab background exists, and the accent highlight follows the active page.

Actual Roblox screenshot `slider-fields.png` was inspected after the final build: right-side value pills stay inside their rows; no floating number appears on ordinary hover; shared Enemy/Team plate and blue active selection are visible. Runtime bounds were also verified at700px and1000px window widths.
