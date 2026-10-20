# WindUI Remake 2

Roblox UI library: adaptive columns, compact controls, per-feature settings, hotkeys, local presets, profile and draggable HUD. Based on WindUI by Footagesus, MIT.

**[Documentation](docs/site/index.html)** · **[Installation](docs/remake-2/INSTALL.md)** · **[API guide](docs/remake-2/API.md)** · **[Method reference](docs/remake-2/REFERENCE.md)** · **[Recipes](docs/remake-2/RECIPES.md)**

## Use as a library

```lua
local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua'))()

local Window = WindUI:CreateWindow({
    Title = 'My menu', Folder = 'MyProject', Theme = 'Dark',
    NewElements = true, DescriptionMode = 'Tooltip',
})
local columns = Window:Tab({Title = 'Main', Icon = 'house'}):Columns()
columns.Left:Section({Title = 'Features'}):Toggle({
    Title = 'Enabled', Flag = 'enabled', Value = false,
    Callback = function(value) print(value) end,
})
```

Raw URL loading requires a **public repository**. If this repository is private, download `dist/main.lua` as `WindUI.lua` and replace the first line with `local WindUI = loadstring(readfile('WindUI.lua'))()`. Never put GitHub credentials in a Roblox script. These runners/API requirements are described in Installation.

- **[QuickStart.lua](QuickStart.lua):** a small project you can copy and extend; no embedded library source.
- **[dist/main.lua](dist/main.lua):** library only, returns WindUI. Import this in your own scripts.
- **[dist/remake2.lua](dist/remake2.lua):** standalone demonstration, already includes library and example. Not the library entry point.
- **[RemakeExample.lua](RemakeExample.lua):** large demo source; do not paste it into every project.

## Features

- Sidebar tabs/subtabs, horizontal icon tabs and responsive two-column cards.
- Toggle, slider, input, dropdown/multi-select, colors/gradients, buttons, progress and containers.
- Compact settings through ellipsis, inline choices inside those settings only.
- Readable expandable descriptions; per-feature Toggle/Hold/Always hotkeys and custom-scroll All Hotkeys.
- Named local presets, quick-save, import/export, rename/delete, reversible sorting and frame-budgeted loading.
- Profile theme/scale/transparency/menu-bind controls; watermark and draggable keylist.

## Build and test

```sh
git submodule update --init --recursive
npm install
npm run build
python build/build-remake2.py
npm test
python -m pip install -r build/requirements-docs.txt
python build/build-docs.py
```

Luau and darklua must be on PATH (see `aftman.toml`). Integration tests under `tests/` run in a compatible connected Roblox client; pure tests run with `npm test`. [QA notes](docs/remake-2/QA.md).

## Credits and history

Original WindUI by [Footagesus](https://github.com/Footagesus/WindUI), MIT; see [LICENSE](LICENSE). Icons retain their upstream attribution in [Fork documentation](FORK.md). [Frozen first-remake baseline](REMAKE2.md). The first-remake repository is not changed by this project.
