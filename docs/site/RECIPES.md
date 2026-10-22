# Примеры методов

Все фрагменты ниже предполагают, что библиотека уже загружена и `Window` создан. Полный минимальный пример — [QuickStart.lua](../../QuickStart.lua).

## Вкладки и две колонки

```lua
local Visuals = Window:Tab({Title = 'Visuals', Icon = 'image'})
local Player = Visuals:SubTab({Title = 'Player', Icon = 'user'})
local columns = Player:Columns({Gap = 16, MinColumnWidth = 260})
local left = columns.Left:Section({Title = 'Main'})
local right = columns.Right:Section({Title = 'Appearance'})
```

Для горизонтальных вкладок внутри страницы используйте `Player:IconTabs()`, затем `pages:Tab({Title='Enemy', Id='enemy', Icon='user'})` и `pages:Select('enemy')`. Это не те же sidebar SubTab.

## Toggle, slider и callback

```lua
local enabled = left:Toggle({Title = 'Enabled', Flag = 'enabled', Value = true,
    Callback = function(value) print(value) end})
local speed = left:Slider({Title = 'Speed', Flag = 'speed', Step = .1,
    Value = {Min = 0, Max = 100, Default = 50},
    Callback = function(value) print(value) end})
enabled:Set(false)
speed:Set(75)
print(speed:Get())
speed:SetRange(0, 200)
```

## Настройки через три точки

```lua
local options = enabled:Settings({Title = 'Feature settings', Width = 336})
local choices = options:Section()
local mode = choices:Dropdown({Inline = true, Title = 'Mode', Flag = 'mode',
    Values = {'Default', 'Alternative', {Title = 'Unavailable', Locked = true}},
    Value = 'Default'})
local settings = options:Section()
settings:Toggle({Title = 'Smooth', Flag = 'smooth', Value = true, Hotkeys = false})
settings:Slider({Title = 'Speed', Flag = 'speed_extra',
    Value = {Min = 0, Max = 100, Default = 50}})
options:Open()
options:Close()
```

`Inline=true` допустим только в группах этого popover. На обычной странице используйте обычный `Dropdown`. Ширина по умолчанию 336, строки настроек компактнее обычных.

## Обычный dropdown и multi-select

```lua
local theme = right:Dropdown({Title = 'Theme', Flag = 'theme',
    Values = {'Dark', 'Light'}, Value = 'Dark',
    Callback = function(value) WindUI:SetTheme(value) end})
local selection = right:Dropdown({Title = 'Options', Multi = true, AllowNone = true,
    SearchBarEnabled = true, Values = {'One', 'Two', 'Three'}, Value = {'One'}})
theme:Select('Light')
selection:Select({'Three', 'One'})
```

Превью multi-select следует порядку `Values`, а не порядку кликов. Для длинного значения край плавно затухает.

## Описания и хоткеи

```lua
local feature = left:Toggle({Title = 'Feature', Flag = 'feature', Value = false,
    Desc = 'Long readable description of what this option does.',
    Hotkeys = {{Key = 'K', Mode = 'Toggle', Value = true}}})
feature:AddHotkey({Key = 'L', Mode = 'Hold', Value = true})
local saved = feature:GetHotkeys()
feature:SetHotkeys(saved)
Window:ShowHotkeys()
```

Правый клик по toggle открывает управление биндами. Toggle/Hold/Always — режимы хоткеев; `Hotkeys=false` отключает их для конкретного toggle. Для пользовательского действия можно передать `HotkeyCallback`. Глобальная клавиша меню задаётся `Window:SetToggleKey(Enum.KeyCode.F8)`, а не хоткеем элемента.

При `DescriptionMode='Tooltip'` длинное описание раскрывается при наведении на `…`. Панель не сжимается под курсором; `−` сворачивает её. Указатель можно перевести в панель, чтобы прочитать или прокрутить текст.

## Зависимые группы

```lua
local advanced = left:Toggle({Title = 'Advanced', Flag = 'advanced', Value = false})
local details = columns.Right:Section({Title = 'Details',
    VisibleWhen = function() return advanced.Value end})
details:Slider({Title = 'Amount', Flag = 'amount',
    Value = {Min = 0, Max = 10, Default = 5}})
```

Скрытие не удаляет значения и не исключает flagged элементы из конфигов.

## Цвет

```lua
local color = right:Colorpicker({Title = 'Color', Flag = 'color',
    Default = Color3.fromRGB(76, 141, 255), Transparency = .2})
color:Set(Color3.fromRGB(255, 100, 100), .1)
color:Reset()
local state = color:Export()
color:Import(state)
```

Для градиентов и формата stops смотрите API guide. Прозрачность хранится отдельно от RGB.

## Профиль и HUD

```lua
local profile = Window:CreateProfile({Name = 'Player'})
local hud = Window:CreateHUD({Watermark = true, Keylist = true})
hud:SetFields({'FPS', 'Ping', 'Username', 'Time'})
hud:SetWatermarkEnabled(true)
hud:SetKeylistEnabled(true)
hud:ResetPositions()
```

## Конфиги и сортировка

```lua
local presets, err = Window:EnablePresets({Default = 'Default', Author = 'Me'})
assert(presets, err)
presets:Create('My setup')
presets:Save('My setup')
presets:Load('My setup')
presets:QuickSave()
presets:SetSort('Name', false)     -- A–Z
presets:SetSort('Name', true)      -- Z–A
presets:SetSort('Created', false)  -- новые сначала
presets:SetSort('Modified', true)  -- давно изменённые сначала
```

`Create`/`Import` отказываются перезаписывать существующий файл. Проверяйте `ok, err`. Сохранение и загрузка — разные действия; сортировка никогда не сохраняет конфиг.

## Завершение

```lua
Window:OnDestroy(function() print('Disconnect your own connections here') end)
Window:Destroy()
```

Библиотека управляет собственными соединениями. Ваши RunService/игровые callbacks должны иметь собственную очистку. Anti-AFK в большом демо — код примера, не скрытое поведение подключения библиотеки.


Alphabetical ставит названия с буквами перед чисто числовыми: `Default → Last → 231`. Повторный выбор меняет направление внутри групп: `Last → Default → 231`. Числовые имена сортируются по числу. Сортировка по датам по-прежнему использует реальные created/modified timestamps.


## Compound appearance rows and mock player preview

See [complete theme and composition guide](COMPOSITE.md) for `section:Compound`, `section:PlayerPreview`, native dropdowns with left labels, and the original WindUI Dark palette.
