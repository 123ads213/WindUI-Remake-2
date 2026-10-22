# Темы, редактор, курсор и полная интеграция

## Встроенные темы

`Dark`, `Light`, `Ocean`, `Forest`, `Ember`, `Orchid`, `Paper`, `Neverlose`.

```lua
WindUI:SetTheme('Neverlose')
print(WindUI:GetCurrentTheme())
local themes = WindUI:GetThemes()
local textColor = WindUI:GetThemeProperty('Text')
WindUI:RefreshTheme() -- только когда изменили содержимое текущей theme table
```

Темы зарегистрированы в библиотеке; профиль по умолчанию показывает лишь Dark/Light. Передайте `Themes`, если нужны все. Общая прозрачность окна (`ToggleTransparency` / профиль) и прозрачность отдельных theme properties — разные механизмы.

### Что именно совпадает с Neverlose-Reloaded

Исходные значения взяты из `gui.hpp` / `c_gui::apply_theme(0)` приложенных C++ исходников. Сохраняются нормализованные RGB, без подбора пипеткой:

| Назначение | RGB [0..1] / RGB [0..255] | Применение |
| --- | --- | --- |
| Акцент | `.318, .486, .992` | Primary, Toggle, Slider, Checkbox |
| Текст | `.922, .922, .941` | Text |
| Вторичный текст | `.51, .52, .56` | Icon, Placeholder |
| Боковая поверхность/карточки | `.071, .078, .114` | WindowBackground, ElementBackground, Dialog |
| Основная поверхность | `.043, .055, .086` | PanelBackground |
| Поле | `25, 27, 36` (0..255) | ChoiceBackground, LabelBackground |
| Выбранный tab | `.153, .169, .212` | TabBackgroundActive, alpha 1 |
| Наведение tab | тот же цвет | TabBackgroundHover, alpha .4 (Roblox transparency .6) |
| Выключенный toggle | `.055, .071, .098` | ToggleTrack |
| Выключенная ручка | `.498, .529, .557` | ToggleThumbOff |

Дополнительные рамки обычных карточек скрыты: `CardBorderTransparency=1`. Редактор тем использует такие же обычные карточки, без отдельной светлой `GroupOutline`.

**Не обещать 1:1 рендер всего C++ меню:** разметка, шрифт, эффекты blur/shaders, прозрачность боковой/верхней/основной поверхности и временные кривые анимаций не перенесены буквально. Наши поверхности сейчас сплошные; выбранный tab и его hover используют исходные цвет/alpha. Настраиваемая прозрачность окна отдельная. Neverlose — отдельная палитра, остальные темы не заменены.

## Custom cursor

```lua
Window:SetCustomCursor({Enabled=true,Size=10})
Window:SetCustomCursor({Color=Color3.fromRGB(255,80,80)})
Window:SetCustomCursor({Color='#12AB34'})
Window:SetCustomCursor({Color=false}) -- вернуть цвет из темы
Window:SetCustomCursor({Color='Auto'}) -- то же
Window:SetCustomCursor(false) -- вернуть системный курсор
```

- По умолчанию custom cursor выключен; включается через `CustomCursor` окна или метод.
- Это заполненная круглая точка, размер 4..24 экранных px, независимо от DPI окна.
- `Cursor` берётся из темы, fallback — `Text`. Встроенные Light/Paper задают чёрный, Neverlose — белый.
- Явный `Color` перекрывает тему. Если менять только `Size`, override сохраняется.
- При скрытии/закрытии окна, потере фокуса и Destroy восстанавливается предыдущее состояние нативной иконки.
- Кастомный редактор имеет поле **Cursor**; RGB применяется к точке, прозрачность точки остаётся 0 (она не редактируется через alpha темы).

## Пользовательская тема через API

```lua
local custom = table.clone(WindUI:GetThemes().Neverlose)
custom.Name = 'My palette'
custom.Primary = Color3.fromRGB(180,120,255)
custom.Toggle = custom.Primary
custom.Slider = custom.Primary
custom.Checkbox = custom.Primary
custom.Cursor = Color3.fromRGB(255,255,255)
WindUI:AddTheme(custom)
WindUI:SetTheme(custom.Name)
```

`Accent` — название одной из поверхностей старого WindUI, а не синоним `Primary`. Для смены интерактивного акцента используйте `Primary` и соответствующие явно заданные properties (`Toggle`, `Slider`, `Checkbox` и др.). `AddTheme` не пишет тему на диск сам по себе. Список всех реальных theme/fallback keys — в конце SOURCE-CONFIG.

## Встроенный редактор custom themes

```lua
local builtins={'Dark','Light','Ocean','Forest','Ember','Orchid','Paper','Neverlose'}
local themePage=Window:Tab({Title='Themes',Icon='palette'})
local columns=themePage:Columns()
local controls=columns.Left:Section({Title='Appearance'})
local selector=controls:Dropdown({Title='Theme',Flag='ui.theme',
    Values=table.clone(builtins),Value='Neverlose',
    Callback=function(name) WindUI:SetTheme(name) end})
local editor=Window:CreateThemeEditor(controls,{
    Builtins=table.clone(builtins),
    FallbackTheme='Dark',
    OnThemeChanged=function(name) selector:Select(name) end,
})
local function updateThemes()
    local names=table.clone(builtins)
    for _,name in ipairs(editor:GetNames()) do table.insert(names,name) end
    selector:Refresh(names)
end
editor.OnChanged=updateThemes
updateThemes()
-- Действия, не обязательно вызывать при запуске:
-- editor:OpenCreate()
-- editor:OpenEditor('Existing custom theme') -- false, если такой нет
```

Публичный контроллер: `GetNames`, `OpenCreate`, `OpenEditor`; `.Entries`, `.Rows`, `.Editors`, `.CreatePanel` полезны для интеграции/диагностики, не нужны для обычного callback. `Fields={{property,label},...}` заменяет список редактируемых свойств; `Builtins` задаёт список исходных тем. `OnChanged(names)` уведомляет об изменении списка, `OnThemeChanged(name)` — о применении.

Хранение: `(config.Folder or Window.Folder or 'Sirius-Remake2') .. '/' .. (config.FileName or 'custom-themes.json')`. Это **не** `WindUI/<Folder>/config/` обычных presets. `CreateWindow` с `Folder` создаёт нужные каталоги; для произвольного другого пути обеспечить каталог заранее. Нужны `writefile/readfile/isfile`; при недоступности UI может создать тему в памяти и сообщает об ошибке записи.

Имя чистится от запрещённых символов и ограничено 32 байтами; имена built-in и существующие имена без учёта регистра не перезаписываются через Create. Save and overwrite обновляет существующую тему. Применение цветовых полей даёт live preview и не закрывает редактор. **Для сохранения после перезапуска нажать Save and overwrite.** Delete удаляет custom theme и переключает на `FallbackTheme`.

Базовые цвета копируются в custom theme; смена Base theme не должна трактоваться как гарантированный сброс всех сохранённых overrides. Список custom themes и файлы не являются облачными, пользовательские темы не публикуются автоматически вместе с библиотекой.

## Профиль + custom themes

```lua
local function profileNames()
    local names=table.clone(builtins)
    for _,name in ipairs(editor:GetNames()) do table.insert(names,name) end
    table.insert(names,'Custom') -- действие создания, не реальная theme
    return names
end
local profile=Window:CreateProfile({
    Name=game:GetService('Players').LocalPlayer.DisplayName,
    Themes=profileNames(),
    IsCustomTheme=function(name) return editor.Entries[name]~=nil end,
    OnThemeRequested=function(name) if name=='Custom' then editor:OpenCreate() end end,
    OnThemeSettings=function(name) editor:OpenEditor(name) end,
    OnThemeChanged=function(name) selector:Select(name) end,
    History={{Version='My build',Date='2026-01-01',Title='Migration',Description='Project update'}},
})
editor.OnChanged=function()
    updateThemes()
    profile:SetThemes(profileNames())
end
```

Обновление списка после создания/удаления тем уже подключено через `profile:SetThemes(profileNames())` в callback выше (см. актуальный справочник и RemakeExample). Профиль имеет scale/style/transparency/history/menu bind/unload. Настройки лицензии/подписки — только предоставленные приложением данные; библиотека не проверяет оплату. Не переносить `Mock=true`/фиктивные DaysRemaining из демо в реальную систему подписок.

Gear у custom theme стоит в правом слоте; выбранная тема сдвигает его влево и показывает check. Это уже реализовано внутри Profile; не добавляйте собственную поверхностную анимацию.

## HUD: точные поля и состояние

```lua
local hud=Window:CreateHUD({Watermark=true,Keylist=true,Build='Release',
    Fields={FPS=true,Ping=true,Username=true,Time=true,Day=true,Avatar=true,
            Platform=true,Build=true,Executor=false,VAR=false,Memory=false,Uptime=false,Place=false}})
hud:SetFields({'FPS','Ping','Username','Time','Weekday','Avatar','Logo','Build'})
hud:SetField('Day',false)
local saved=hud:Export()
local ok,err=hud:Import(saved)
```

`Config.Fields` и `SetField` используют **ID**, а `SetFields`/`GetFields` используют **labels**. Полное соответствие:

| ID | Label |
| --- | --- |
| FPS | FPS |
| Ping | Ping |
| Username | Username |
| Time | Time |
| Day | Weekday |
| Avatar | Avatar |
| Platform | Logo |
| Build | Build |
| Executor | Executor |
| VAR | Frame variance |
| Memory | Memory |
| Uptime | Session time |
| Place | Place ID |

`GetAvailableFields()` возвращает labels. `Builds={RobloxUsername='Nightly'}` задаёт build по имени, `Build` — fallback. Наличие Executor зависит от API среды. `SetKeylistMode` принимает старые `Key/Value/Classic` для совместимости, но текущая визуальная реализация нормализуется в Classic. Не обещать разные активные layouts. HUD двигается за header, имеет snap guides; позиции сохраняются в preset `__hud`, если HUD создан до сохранения/загрузки.

## Low-level ConfigManager (существующие проекты)

```lua
local manager=Window.ConfigManager
if manager then
    local config,err=manager:CreateConfig('My config')
    if config then
        config:SetAsCurrent() -- зарегистрировать PendingFlags
        config:Set('custom.key',{example=true})
        local ok,saveErr=config:Save()
        if not ok then warn(saveErr) end
    else warn(err) end
end
```

Публичные методы и определения — в REFERENCE. Нельзя использовать одновременно этот образец и автозагрузку другого менеджера без плана. Presets — UI-обёртка над этим хранением; они не мигрируют чужой формат JSON автоматически. `__custom` доступен через ConfigModule:Set/Get и не выполняет ваши восстановительные callbacks сам по себе.

## Ограничения и диагностика

- UI library не реализует функциональность примеров ESP/aim/movement, синхронизацию с сервером или облачное хранилище.
- `UIElements`/внутренние контроллеры нужны для диагностики; обычную интеграцию делать через методы.
- Не смешивать несколько разных загрузок WindUI в одном окне. Проверить cleanup перед rerun.
- Точные опции, встречающиеся в коде, перечислены в SOURCE-CONFIG. Это индекс для чтения кода, не обещание поддержки всех внутренних ключей как public API.
- Все действия с пользовательскими файлами тестировать на копиях. Live tests используют временные имена; не удалять пользовательские presets/themes для проверки.
