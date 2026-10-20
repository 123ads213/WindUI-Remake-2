-- WindUI by Footagesus (MIT). Fork: compact numbers, nested tabs and curated themes.
-- Every first-remake control and profile is retained; only new layout/config APIs are layered on top.
local Env = getgenv and getgenv() or _G
Env.__WindUIForkRunId = (Env.__WindUIForkRunId or 0) + 1
local RunId = Env.__WindUIForkRunId
local function disposeLibrary(library)
    if not library then return end
    for _,key in ipairs({ 'ScreenGui', 'NotificationGui', 'DropdownGui', 'TooltipGui' }) do
        local gui=library[key]
        if gui then gui:Destroy() end
    end
end
local WindUI = Env.__WindUIForkInjectedLibrary
Env.__WindUIForkInjectedLibrary = nil
local previous = Env.WindUIForkDemo
local pending = Env.__WindUIForkPendingLibrary
Env.WindUIForkDemo = nil
Env.__WindUIForkPendingLibrary = nil
if previous and previous.Window and not previous.Window.Destroyed then
    previous.Window:Destroy()
    task.wait(0.7)
end
if pending and (not previous or pending ~= previous.Library) then disposeLibrary(pending) end
if RunId ~= Env.__WindUIForkRunId then disposeLibrary(WindUI);return end
assert(WindUI,'Use the standalone remake2.lua or inject this repo library first')
if RunId ~= Env.__WindUIForkRunId then disposeLibrary(WindUI);return end
Env.__WindUIForkPendingLibrary = WindUI
WindUI.ScreenGui:SetAttribute('WindUIForkExample', true)
-- Migrate stranded demo roots from older examples. Never delete unrelated WindUI windows.
for _,root in ipairs(WindUI.ScreenGui.Parent:GetChildren()) do
    if root ~= WindUI.ScreenGui and root:IsA('ScreenGui') and root.Name == 'WindUI' then
        local owned = root:GetAttribute('WindUIForkExample') == true
        local folder = root:FindFirstChild('Window')
        if not owned and folder then
            for _,frame in ipairs(folder:GetChildren()) do
                local main=frame:FindFirstChild('Main')
                local top=main and main:FindFirstChild('Topbar')
                local left=top and top:FindFirstChild('Left')
                local title=left and left:FindFirstChild('Title')
                if title then
                    for _,label in ipairs(title:GetChildren()) do
                        if label:IsA('TextLabel') and label.Text=='Footagesus · Extended fork' then owned=true end
                    end
                end
            end
        end
        if owned then root:Destroy() end
    end
end
local Window = WindUI:CreateWindow({
    Title = 'Sirius', Author = 'Ui library',
    Folder = 'Sirius-Remake2', Icon = 'star', Theme = 'Dark',
    CustomCursor = { Enabled = true, Size = 10 }, DragSmoothness = 0.045,
    DescriptionMode = 'Tooltip', ContentPaddingTop = 10, HideSearchBar = false, SearchInTopbar = true, ToggleKey=Enum.KeyCode.RightShift, LockOffscreen = true, NewElements = true, Size = UDim2.fromOffset(1000, 650), MinSize=Vector2.new(700,420), MaxSize=Vector2.new(1200,800),
})
-- Register immediately: even a later setup error remains cleanable on rerun.
Env.WindUIForkDemo = { Library = WindUI, Window = Window }
Window:Section({ Title = 'COMMON', HeaderSize = 28 })
local Visuals = Window:Tab({ Title = 'Visuals', Icon = 'image' })
local Player = Visuals:Tab({ Title = 'Player', Icon = 'user' })
local World = Visuals:Tab({ Title = 'World', Icon = 'globe' })
local General = Window:Tab({ Title = 'General', Icon = 'settings-2' })
local HUD=Window:CreateHUD({Watermark=true,Keylist=true,Builds={syntheticplatinum27='Nightly'}})
local Appearance = Window:Section({ Title = 'APPEARANCE', Opened = true, HeaderSize = 32 })
local Themes = Appearance:Tab({ Title = 'Themes', Icon = 'palette' })

local Calls = {}
local Pages=Player:IconTabs()
local Enemy=Pages:Tab({Id='enemies',Title='Enemies',Icon='user'})
local Team=Pages:Tab({Id='teammates',Title='Teammates',Icon='user-minus'})
local PlayerColumns=Enemy:Columns({MinColumnWidth=260})
local PlayerSettings=PlayerColumns.Left:Section({Title='Player settings'})
local PlayerControls=PlayerColumns.Right:Section({Title='Controls'})
local TeamColumns=Team:Columns({MinColumnWidth=260})
TeamColumns.Left:Section({Title='Teammates'}):Toggle({Title='Show teammates',Flag='team_players',Value=false})
local WorldColumns=World:Columns({MinColumnWidth=260})
local WorldSettings=WorldColumns.Left:Section({Title='World settings'})
local WorldValues=WorldColumns.Right:Section({Title='Values'})
local GeneralColumns=General:Columns({MinColumnWidth=260})
local Widgets=GeneralColumns.Left:Section({Title='On-screen widgets'})
local GeneralSettings=GeneralColumns.Right:Section({Title='Behavior'})
local ThemeColumns=Themes:Columns({MinColumnWidth=260})
local ThemeControls=ThemeColumns.Left:Section({Title='Theme previews'})
local ThemeColors=ThemeColumns.Right:Section({Title='Colors'})
local Advanced=GeneralSettings:Toggle({Title='Show advanced examples',Flag='advanced_examples',Value=true})
local AdvancedGroup=GeneralColumns.Right:Section({Title='Advanced examples',VisibleWhen=function()return Advanced.Value end})

local Big = PlayerSettings:Slider({
    Title = 'Distance', Flag='distance', Width=160, Icon = 'ruler', IconSize = 24, IconOffset = Vector2.new(4,0), Desc = 'Set the maximum player display distance. Large values are compact; focus the value to edit the full number.',
    Value = { Min = 0, Max = 1e9, Default = 500000 }, Step = 1, IsTooltip = true,
    Callback = function(value) Calls.Distance = value end,
})
local Billion = PlayerSettings:Slider({ Title = 'Budget', Flag='budget', Width=160, Icon = 'wallet', IconSize = 24, IconOffset = Vector2.new(4,0), Value = { Min = 0, Max = 1e12, Default = 1250000000 }, Step = 1000,
    IsTooltip = true, Callback = function(value) Calls.Budget = value end })
local Fine = PlayerSettings:Slider({ Title = 'Precision', Flag='precision', Width = 160, ValueWidth = 72,
    Value = { Min = -1, Max = 1, Default = .12345 }, Step = .00001,
    Callback = function(value) Calls.Fine = value end })
local ShowPlayers = PlayerControls:Toggle({ Title = 'Show players', Flag = 'show_players', Desc = 'Show player overlays. Right-click to manage multiple hotkeys. K toggles; L applies Enabled while held.', Value = true, Hotkeys = { { Key = 'K', Mode = 'Toggle', Value = true }, { Key = 'L', Mode = 'Hold', Value = true } }, Callback = function(value) Calls.ShowPlayers = value end })
PlayerControls:Button({ Title = 'Reset distance', Callback = function() Big:Set(500000) end })


local Gravity = WorldSettings:Slider({ Title = 'Gravity', Flag='world_gravity', Value = { Min = 0, Max = 500, Default = 196.2 }, Step = .1 })
local Balance = WorldValues:ProgressBar({ Title = 'Balance', DisplayMode = 'Value',
    Value = { Min = 0, Max = 1e9, Default = 500000 } })
local Collection = WorldValues:ProgressBar({ Title = 'Collection', DisplayMode = 'Fraction', Width = 210,
    Value = { Min = 0, Max = 1e9, Default = 250000000 } })
WorldSettings:Toggle({ Title = 'Shadows', Flag = 'world_shadows', Value = true, Callback = function() end })


local WatermarkToggle=Widgets:Toggle({ Title = 'Watermark', Flag = 'hud_watermark', Value = true, Hotkeys=false, Callback=function(value)HUD:SetWatermarkEnabled(value)end })
local KeylistToggle=Widgets:Toggle({ Title = 'Keylist', Flag = 'hud_keylist', Value = true, Hotkeys=false, Callback=function(value)HUD:SetKeylistEnabled(value)end })
local WatermarkFields=Widgets:Dropdown({Title='Watermark elements',Multi=true,AllowNone=true,MenuWidth=240,Values=HUD:GetAvailableFields(),Value=HUD:GetFields(),Callback=function(value)HUD:SetFields(value)end})
-- HUD config is authoritative; controls mirror Import/Load as well as API changes.
local syncingHUD=false
HUD.OnChanged=function(h)
    if syncingHUD then return end;syncingHUD=true
    local desired=h:GetFields();local current=WatermarkFields.Value or{};local equal=#desired==#current
    if equal then for _,v in ipairs(desired)do if not table.find(current,v)then equal=false;break end end end
    if not equal then WatermarkFields:Select(desired)end
    if WatermarkToggle.Value~=h.WatermarkEnabled then WatermarkToggle:Set(h.WatermarkEnabled)end
    if KeylistToggle.Value~=h.KeylistEnabled then KeylistToggle:Set(h.KeylistEnabled)end
    syncingHUD=false
end
Widgets:Button({Title='Reset widget positions',Callback=function()HUD:ResetPositions()end})
GeneralSettings:Toggle({ Title = 'Lock Offscreen', Flag = 'lock_offscreen', Value = true,
    Callback = function(value) Window:SetLockOffscreen(value) end })
General:Paragraph({ Title = 'Nested tabs', Desc = 'Click Visuals to expand Player and World. Each child has its own page; the last selected child is remembered.' })
local Unshortened=AdvancedGroup:Slider({ Flag='example_unshortened', Title = 'Unshortened', Compact = false, Width = 170, ValueWidth = 72,
    Value = { Min = 0, Max = 1e6, Default = 500000 } })
AdvancedGroup:Slider({ Flag='example_locked', Title = 'Locked', Locked = true, Value = { Min = 0, Max = 1e6, Default = 500000 } })
AdvancedGroup:Slider({ Flag='example_fixed', Title = 'Fixed range', Value = { Min = 5, Max = 5, Default = 5 } })
local ThemeDropdown=ThemeControls:Dropdown({ Flag='theme', Title = 'Theme', Values = { 'Dark', 'Light', 'Ocean', 'Forest', 'Ember', 'Orchid', 'Paper' }, Value = 'Dark',
    Callback = function(theme) WindUI:SetTheme(theme) end })
ThemeControls:Toggle({ Title = 'Preview toggle', Flag = 'preview_toggle', Value = true, Callback = function() end })
ThemeControls:Slider({ Title = 'Preview slider', Value = { Min = 0, Max = 1e6, Default = 500000 }, IsTooltip = true })
ThemeControls:Button({ Title = 'Preview button' })
ThemeControls:Input({ Title = 'Preview input', Placeholder = 'Type here…', Callback = function() end })
local SolidColor = ThemeColors:Colorpicker({ Title = 'Accent color', Flag = 'accent_color', Default = Color3.fromRGB(42,148,255), Transparency = .15,
    Desc = 'Open the color square. Add colors for a gradient, edit formats, opacity, copy/paste or reset to the default.',
    Callback = function(color,transparency,gradient) Calls.AccentColor = {Color=color,Transparency=transparency,Gradient=gradient} end })
local GradientColor = ThemeColors:Colorpicker({ Title = 'Gradient preview', Flag = 'gradient_color', Gradient = {
    { Position=0, Color=Color3.fromRGB(0,170,255), Transparency=0 },
    { Position=1, Color=Color3.fromRGB(196,92,255), Transparency=.2 },
}, Callback = function(color,transparency,gradient) Calls.GradientColor=gradient end })
local Profile = Window:CreateProfile({
    DaysRemaining = 30, Mock = true, StoreLink = 'https://discord.gg/eqAEszZzHj',
    Themes = { 'Dark', 'Light', 'Ocean', 'Forest', 'Ember', 'Orchid', 'Paper' },
    OnThemeChanged = function(theme) ThemeDropdown:Select(theme) end,
    History = {
        {Version='1.6.66-fork.14',Date='2026-10-19',Title='Sirius watermark labels',Description='Distinct FPS monitor icon, 8px icon-to-text gaps, full weekdays, Sirius branding and opaque themed keylist surfaces.'},
        {Version='1.6.66-fork.13',Date='2026-10-19',Title='Classic binds & opaque HUD',Description='Reference-size left-side hotkey indicators and compact labels. Solid black Dark-theme watermark with tighter spacing and neutral icons; selectable fields and transitions retained.'},
        {Version='1.6.66-fork.12',Date='2026-10-19',Title='Refined configurable HUD',Description='Selectable fields, stable metric columns, animated reveals, local time/day, executor label and username-based build. Compact value-first Hotkeys without switches.'},
        {Version='1.6.66-fork.11',Date='2026-10-19',Title='Watermark & keylist',Description='Live Roblox telemetry and an active-hotkey HUD. Reference-style dragging, snap rulers, normalized anchors, theme sync and config persistence.'},
        { Version = '1.6.66-fork.10', Date = '2026-10-19', Title = 'Gradients & popup polish', Description = 'Multi-color gradients, per-stop opacity, Hex/RGB/HSV/HSL formats, copy/paste and reset. Soft popup shadows and cursor-near hotkeys. Legacy Keybind removed.' },
        { Version = '1.6.66-fork.9', Date = '2026-10-19', Title = 'Descriptions & hotkeys', Description = 'Themed hover descriptions and right-click multi-hotkey editor, global list and config persistence. Toggle, Hold and Always with explicit boolean Value.' },
        { Version = '1.6.66-fork.8', Date = '2026-10-18', Title = 'Transparency & interaction', Description = 'Background-only transparency now includes themed panels and surfaces. Time-based smooth dragging and an optional filled white cursor with lifecycle cleanup.' },
        { Version = '1.6.66-fork.7', Date = '2026-10-18', Title = 'Search & transparency', Description = 'Original WindUI Search above COMMON. Longer preferences menu, clean Style row and thumb-free Transparency bar with a hover-only value.' },
        { Version = '1.6.66-fork.6', Date = '2026-10-18', Title = 'Profile & preferences', Description = 'Themed profile menu, subscription display, Renew, menu scaling, Style and scrollable update history. Animated Appearance tab section and centred title icons.' },
        { Version = '1.6.66-fork.5', Date = '2026-10-18', Title = 'Tabs & clean themes', Description = 'Smooth page switching and clean Ocean, Forest, Ember and Orchid contours. Slider title icon support.' },
        { Version = '1.6.66-fork.4', Date = '2026-10-18', Title = 'Viewport & controls', Description = 'Offscreen boundaries now use the actual GUI origin. Clean toggle thumb and Light/Paper outlines.' },
        { Version = '1.6.66-fork.3', Date = '2026-10-18', Title = 'Precision & lifecycle', Description = 'Decimal step normalization, numeric callbacks and safe example reruns without duplicate windows.' },
        { Version = '1.6.66-fork.2', Date = '2026-10-18', Title = 'Original WindUI layout', Description = 'Original inline controls and resize behavior, nested Player/World pages and optional Lock Offscreen.' },
    },
})
local Presets,configError=Window:EnablePresets({Default='Default'})
assert(Presets,configError)
Env.WindUIForkDemoConfig=Window.CurrentConfig
Window:SelectTab(Visuals.Index) -- Selects the first unlocked child (Player).

Env.WindUIForkDemo = { Library = WindUI, Window = Window, Big = Big, Billion = Billion,
    ShowPlayers = ShowPlayers, Fine = Fine, Calls = Calls, Visuals = Visuals, Player = Player, Players = Player,
    World = World, General = General, Themes = Themes, Gravity = Gravity, Balance = Balance, Collection = Collection, Appearance = Appearance, Profile = Profile, HUD = HUD, Presets=Presets, Pages=Pages, Columns=PlayerColumns, ThemeDropdown=ThemeDropdown, Advanced=Advanced, Dependent=Unshortened, DependencyGroup=AdvancedGroup, WatermarkFields = WatermarkFields, SolidColor = SolidColor, GradientColor = GradientColor }
Env.__WindUIForkPendingLibrary = nil
return "Full remake 2 menu started"
