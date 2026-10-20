# WindUI — Remake 2

This is the separate working repository for the second remake.

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

Never put GitHub PATs into Roblox scripts. Anonymous raw URL loading requires public visibility; private repositories use a downloaded local file. See [installation](docs/remake-2/INSTALL.md).

Initialize submodules with `git submodule update --init --recursive`. Build with `npm run build`, then `python build/build-remake2.py`. The standalone `dist/remake2.lua` embeds the current library and **RemakeExample.lua**, with no first-repository fetch. `ForkExample.lua` and `RestoreBaseline.lua` remain historical baseline utilities.

## Current remake

`1.7.0-remake.2`: two-column cards, compact inline controls, nearby checked dropdowns, horizontal icon subtabs, header preset manager and animated dependencies.

See **[complete API and AI integration guide](docs/remake-2/API.md)** and **[working example](RemakeExample.lua)**. All development happens here; the original first-remake repository stays unchanged.
