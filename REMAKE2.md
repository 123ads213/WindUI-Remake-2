# WindUI — Remake 2

This is a separate, private working repository for the second remake.

## Frozen starting point

- Original repository: https://github.com/123ads213/WindUI
- Source commit: `1044ddb14d8d4f32a6b252318c7931c3930c5185`
- Library version: `1.6.66-fork.18`
- Tag `remake-1-final-fork18` preserves the exact first-remake source tree.
- Full inherited Git history, source, tests, built library and original MIT license are retained.

## Captured current view

- `docs/remake-2/baseline-current-view.jpg`: actual in-game screenshot.
- `docs/remake-2/baseline-current-view.json`: Light theme, opacity, scale, window size/position, selected World tab, colors, values, bindings and HUD anchors captured from the connected game.
- `RestoreBaseline.lua`: reapplies these settings to a loaded demo.
- Header 14px/30px; bindings 13px/26px; separate indicator/name plates; 4px gap and 4px right inset. All existing popup, hotkey and color-picker behavior is unchanged.

## Launch / development

The repository is private. Do not put GitHub PATs into Roblox scripts and do not depend on anonymous raw URLs for this repository.

Build with `npm run build`, then `python build/build-remake2.py`. Load the resulting standalone `dist/remake2.lua` for testing; it embeds this repository's built library and restores the saved view without fetching library code from the first repository. `ForkExample.lua` remains an unmodified historical baseline demo; its original pinned fallback is bypassed by the standalone launcher.

Future remake work happens only here. No new visual redesign has been applied yet.
