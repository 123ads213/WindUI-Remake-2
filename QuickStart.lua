-- WindUI Remake 2, library-only import. Requires a public raw URL (or use readfile; see docs).
local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua'))()

local Window = WindUI:CreateWindow({
    Title = 'My menu', Author = 'My project', Icon = 'settings',
    Folder = 'MyProject', Theme = 'Dark', NewElements = true,
    DescriptionMode = 'Tooltip', SearchInTopbar = true,
    ToggleKey = Enum.KeyCode.RightShift, Size = UDim2.fromOffset(1000, 650),
})
local Main = Window:Tab({Title = 'Main', Icon = 'house'})
local columns = Main:Columns()
local features = columns.Left:Section({Title = 'Features'})
local enabled = features:Toggle({
    Title = 'Enabled', Flag = 'enabled', Value = false,
    Desc = 'Enable your feature. Its implementation belongs in the callback.',
    Callback = function(value) print('Enabled:', value) end,
})
local options = enabled:Settings({Title = 'Feature settings'})
options:Section():Dropdown({
    Title = 'Mode', Inline = true, Values = {'Default', 'Alternative'},
    Value = 'Default', Flag = 'mode',
})
local values = options:Section()
values:Toggle({Title = 'Smooth', Value = true, Flag = 'smooth', Hotkeys = false})
values:Slider({Title = 'Speed', Value = {Min = 0, Max = 100, Default = 50}, Flag = 'speed'})
columns.Right:Section({Title = 'Appearance'}):Dropdown({
    Title = 'Theme', Values = {'Dark', 'Light'}, Value = 'Dark', Flag = 'theme',
    Callback = function(value) WindUI:SetTheme(value) end,
})
Window:CreateProfile({Name = game:GetService('Players').LocalPlayer.DisplayName})
local presets, err = Window:EnablePresets({Default = 'Default'})
if not presets then warn(err) end -- Local storage APIs are optional; the UI can still run.
return Window
