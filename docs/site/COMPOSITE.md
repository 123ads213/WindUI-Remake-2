# Reference theme and composable appearance controls

## Original WindUI Dark

```lua
local Window = WindUI:CreateWindow({
    Title='My menu', Folder='MyProject', Theme='Dark',
    NewElements=true, DescriptionMode='Tooltip',
})
```

The Dark color definitions match [upstream WindUI](https://github.com/Footagesus/WindUI/blob/main/src/themes/Init.lua): Accent `#18181B`, Dialog `#1A1A1A`, Background `#101010`, ElementBackground `#2A2A2C`, Text `#FFFFFF`, Toggle `#33C759`, Slider `#0091FF`.

NewElements switches use a 40×24px track and circular 20px thumb. The thumb moves with a 0.18s tween and track/thumb colors transition smoothly. Rapid clicks cancel the previous movement tween. Native Toggle flags, callbacks, locks and hotkeys are retained; non-NewElements controls remain compatible. Save/name are divided by a vertical separator.

Compact dropdown fields have a permanent Dialog-colored rounded background and no hover opacity changes. The parent row has no hover fill either.

## Label on the left, dropdown on the right

Already supported in columns/cards:

```lua
section:Dropdown({
    Title='Target', Flag='target', Width=170,
    Values={'Hit Chance','Distance','Health'}, Value='Hit Chance',
    Callback=function(value) print(value) end,
})
section:Dropdown({
    Title='Hitboxes', Flag='hitboxes', Width=170, Multi=true,
    Values={'Head','Chest','Stomach'}, Value={'Head','Chest'},
})
```

## Label → color → dropdown (or toggle)

```lua
local row = section:Compound({
    Title='Player',
    Color={Flag='player_color',Default=Color3.fromRGB(164,167,56),AllowGradient=false,
        Callback=function(color,transparency) MyRenderer:SetColor(color,transparency) end},
    Dropdown={Flag='player_mode',Width=140,Values={'Solid','Neon','Ghost'},Value='Solid',
        Callback=function(mode) MyRenderer:SetMode(mode) end},
})

local box = section:Compound({
    Title='Box',
    Color={Flag='box_color',Default=Color3.fromRGB(89,87,227)},
    Toggle={Flag='box_enabled',Value=true,Callback=function(on) MyRenderer:SetBoxEnabled(on) end},
})
```

`MyRenderer` is your own object, not a library global. Each child is a real native control: `row.Color:Open()`, `row.Color:Set(color)`, `row.Dropdown:Select('Ghost')`, `box.Toggle:Set(false)`. `row:GetControl('Color')` returns the same child. Use an independent unique `Flag` on each child; do not assign a flag to the whole Compound. Dropdown and Toggle are alternatives in one row. `row:Lock()`, `row:Unlock()`, `row:SetTitle(...)`, `row:SetVisible(...)`, and `row:Destroy()` operate on the row. Child programmatic setters follow the corresponding native control's callback rules.

## Local player mock

```lua
local preview = rightSection:PlayerPreview({Height=350,State={
    Name='Preview player', Health=75, Distance='25m',
    Color=Color3.fromRGB(164,167,56), Mode='Solid', Box=true,
}})
preview:SetColor(Color3.fromRGB(89,87,227))
preview:SetMode('Ghost') -- Solid / Neon / Ghost
preview:SetBoxColor(Color3.fromRGB(89,87,227)) -- independent of model color
preview:Update({Health=40,Box=false,Name='Sample'})
preview:SetEnabled(true)
preview:SetRotation(30)
-- Optional: clones your model; never reparents/destroys the caller's source model.
preview:SetModel(myModel)
preview:SetModel(nil) -- return to the built-in block dummy
local state = preview:GetState() -- detached state table
```

Connect compound callbacks to `preview:SetColor`, `preview:SetMode` or your own rendering adapter. The preview is just a local ViewportFrame/WorldModel with a mock box/name/health overlay. It does not discover players, draw through walls, hook a game, or read gameplay state. It has no polling/render loop. Scripts are removed from cloned models. The supplied model must be Archivable and contain a BasePart.

Demo: Visuals → Preview. Solid/Neon/Ghost, colors, box visibility, health and rotation are interactive. The preview state itself is not persisted; store source controls with stable flags and reconstruct display state in callbacks.
