# WindUI Remake 2 — полный контекст для ИИ

**Назначение:** перенос существующего скрипта с оригинального WindUI на этот форк без потери функций. Этот один файл включает документы целиком; отдельный доступ к сайту для чтения включённых разделов не требуется. Для полной проверки передайте также старый скрипт и исходники библиотеки.

Репозиторий: https://github.com/123ads213/WindUI-Remake-2

Библиотека: https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua

Сайт: https://123ads213.github.io/WindUI-Remake-2/

Сборка документации: `python build/build-reference.py && python build/build-ai-context.py`. Исходники имеют приоритет при расхождении. Это не обещание совместимости произвольного старого JSON или буквального переноса C++ renderer. Оригинальный WindUI: Footagesus, MIT.

## Состав

1. Миграция (`MIGRATION.md`)
2. Установка (`INSTALL.md`)
3. API и интеграция (`API.md`)
4. Темы, курсор, редактор, HUD (`ADVANCED.md`)
5. Рецепты (`RECIPES.md`)
6. Составные элементы (`COMPOSITE.md`)
7. Справочник методов (`REFERENCE.md`)
8. Индекс полей (`SOURCE-CONFIG.md`)
9. Проверки и ограничения (`QA.md`)

---

<!-- BEGIN MIGRATION.md -->

# Миграция оригинального WindUI → WindUI Remake 2

Этот документ предназначен для ИИ, которому передают существующий скрипт на оригинальном WindUI. Задача — **перенести интерфейс, сохранив поведение**, а не написать другой скрипт по мотивам старого.

## Что передать ИИ

1. Старый Lua/Luau-скрипт целиком (без секретов).
2. Один файл [AI-CONTEXT.md](AI-CONTEXT.md): в него собраны миграция, API, темы, примеры, справочник методов и ограничения.
3. При возможности — исходники текущей библиотеки или архив репозитория. Код в `src/` — окончательный источник истины; `dist/main.lua` — готовая библиотека.
4. Скриншоты желаемой группировки, если старое меню нужно визуально перестроить.

Не передавайте GitHub-токены, executor credentials, приватные ключи или пользовательские JSON с секретами. Библиотека не требует их в коде.

## Готовый запрос для ИИ

```text
Перенеси приложенный скрипт с оригинального WindUI на WindUI Remake 2.
Прочитай приложенный AI-CONTEXT.md полностью до начала изменений.

Сохрани ВСЮ существующую бизнес-/игровую логику: callbacks, состояния,
имена и типы сохранённых Flag, исходные значения, min/max/step, опции,
цвета/прозрачность, зависимости, бинды, ошибки, очистку и порядок инициализации.
Не добавляй функциональность из демо. Не заменяй рабочую логику заглушками.
Не вставляй исходник библиотеки в проект: импортируй dist/main.lua один раз.
Не импортируй dist/remake2.lua — это самостоятельное демонстрационное меню.

Перестрой страницы на Columns().Left/Right:Section(), сохраняя все элементы.
Используй Settings() для дополнительных настроек конкретной функции.
Применяй IconTabs только для горизонтальных страниц; SubTab — для сайдбара.
Сохрани все старые Flag. Новым элементам дай уникальные стабильные Flag.
Сначала создай элементы и HUD, затем подключи существующие конфиги/EnablePresets.
Не предполагай автоматическую совместимость чужого JSON: проверь формат и типы.
Не смешивай два менеджера конфигов без явного плана перехода.

Тема по умолчанию: Neverlose (если пользователь не указал другую).
Сохрани текущие callbacks темы и при необходимости подключи CreateThemeEditor.
Не рисуй собственные кнопки/переключатели поверх нативных контролов.
Не изобретай API. Если метод отсутствует, опиши адаптацию и используй реальный.
Не обещай точный перенос C++ blur/shaders или облачные конфиги.

Выдай полный готовый скрипт без пропущенных частей, карту «старое → новое»,
список несовместимостей/решений и чеклист тестов. Если исходник недоступен
целиком или есть нерешаемый пробел, укажи это, не выдумывай пропущенную логику.
```

## 1. Инвентаризация до редактирования

Составить таблицу всех вкладок, секций и элементов: путь, тип, `Title`, `Flag`, значение по умолчанию, опции, min/max/step, callback, зависимости, хоткеи и ссылки на элемент в остальном коде. Отдельно записать:

- библиотечный загрузчик, настройки окна и тему;
- внешние объекты рендера/модули/сервисы, которым callbacks передают значения;
- свой менеджер конфигов, автозагрузку и дополнительные поля JSON;
- одиночные и множественные бинды, обработку удержания и отпускания;
- `RunService`/`UserInputService` соединения, задачи, GUI и очистку;
- асинхронные зависимости (персонаж, камера, загруженные модули);
- строковые ссылки на старые элементы, использование `.Value` и сеттеров.

После переноса сверить **каждый** пункт. Нельзя удалять элементы, которые неудобно разместить.

## 2. Импорт и окно

```lua
local WindUI = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua'
))()
local Window = WindUI:CreateWindow({
    Title='My menu', Author='My project', Icon='settings',
    Folder='MyProject', Theme='Neverlose', NewElements=true,
    SearchInTopbar=true, HideSearchBar=false, DescriptionMode='Tooltip',
    ToggleKey=Enum.KeyCode.RightShift,
    Size=UDim2.fromOffset(1100,720),
    MinSize=Vector2.new(700,420), MaxSize=Vector2.new(1400,950),
    CustomCursor={Enabled=true,Size=10},
})
```

Публичный raw URL работает только при публичном репозитории. Альтернатива: скачать `dist/main.lua` как `WindUI.lua`, загрузить `loadstring(readfile('WindUI.lua'))()`. В обычном Studio/LocalScript executor-функций нет; не выдавать этот загрузчик за универсальный Studio ModuleScript.

`Folder` влияет на локальное хранение. Если меняете его, предусмотрите перенос файлов. Для стабильной версии вместо `main` можно указать конкретный опубликованный commit SHA.

## 3. Соответствие старых и новых конструкций

| Было / задача | Реальный вариант в Remake 2 | Что сохранить |
| --- | --- | --- |
| `Window:Tab({...})` | Тот же метод | Название, иконка, порядок |
| Вложенный sidebar tab | `Tab:SubTab({...})` | Иерархию; это не IconTabs |
| Список элементов в Tab | `Tab:Columns()` → `.Left/.Right:Section()` | Все элементы и порядок внутри группы |
| `Tab:Section({...})` | Остался заголовком | Для новой карточки использовать Section именно на колонке |
| Toggle/Slider/Input/Dropdown/Colorpicker/Button | Те же фабрики на карточке | `Flag`, callback и параметры |
| Малые параметры одной функции | `element:Settings({...})` → `options:Section()` | Отдельные флаги дочерних элементов |
| Горизонтальные страницы | `Tab:IconTabs()` → `pages:Tab({Id=...})` | Независимые состояния страниц |
| Условная видимость | `VisibleWhen=function() ... end` / `:SetVisible()` | Не путать с удалением и блокировкой |
| Бинд Boolean-функции | `Hotkeys={{Key='K',Mode='Toggle',Value=true}}` | Режим и семантику значения |
| Отдельный старый `:Keybind()` | В текущей фабрике такого элемента нет | Портировать явно через hotkeys или оставить собственный input-controller |
| Обработчик глобальной клавиши меню | `Window:SetToggleKey(Enum.KeyCode.F8)` | Это не хоткей функции |
| Своя панель профиля | `Window:CreateProfile({...})` при необходимости | Не добавлять фальшивую подписку/лицензию |
| Конфиги | Существующий `ConfigManager` или `Window:EnablePresets()` | Не загружать дважды |
| ESP/aim/game logic из старого скрипта | Оставить в пользовательском коде | Библиотека UI не реализует эти функции |
| Плеер-превью | `section:PlayerPreview({...})` | Только локальный mock; не замена реальному renderer |

Нет методов `AddGroupbox`, `LeftColumn`, `SetDependency`, облачного preset API или `ThemeEditor:Save()` как общего публичного API. Проверять существование по справочнику/исходникам, а не по другой библиотеке.

## 4. Пример переноса группы без потери callback

До:

```lua
local Main = Window:Tab({Title='Main',Icon='settings'})
Main:Section({Title='Movement'})
local Enabled = Main:Toggle({Title='Enabled',Flag='movement_enabled',Value=false,
    Callback=function(value) Movement:SetEnabled(value) end})
local Speed = Main:Slider({Title='Speed',Flag='movement_speed',Step=1,
    Value={Min=1,Max=100,Default=20},
    Callback=function(value) Movement:SetSpeed(value) end})
```

После (объект `Movement` остаётся тем же объектом вашего проекта):

```lua
local Main = Window:Tab({Title='Main',Icon='settings'})
local columns = Main:Columns({MinColumnWidth=260,Gap=16})
local movement = columns.Left:Section({Title='Movement'})
local Enabled = movement:Toggle({Title='Enabled',Flag='movement_enabled',Value=false,
    Callback=function(value) Movement:SetEnabled(value) end})
local Speed = movement:Slider({Title='Speed',Flag='movement_speed',Step=1,
    Value={Min=1,Max=100,Default=20},
    Callback=function(value) Movement:SetSpeed(value) end})
```

Имена локальных ссылок `Enabled`, `Speed` сохранены: остальной код, вызывающий `Speed:Set(...)`, продолжит использовать нужный элемент. Не создавайте второй одноимённый элемент ради новой разметки.

## 5. Типы состояния и callbacks

| Элемент | Чтение | Изменение | Особенность |
| --- | --- | --- | --- |
| Toggle | `.Value` Boolean | `:Set(bool)` | `Hotkeys=false` отключает хоткеи |
| Slider | `.Value.Default`, `:Get()` | `:Set(number)`, `:SetRange(min,max)` | `.Value` — таблица, не число |
| Input | `.Value` строка | `:Set(text)` | `Type='Textarea'` оставляет нативный большой ввод |
| Dropdown | `.Value` строка/таблица | `:Select(value)`, `:Refresh(values)` | Multi возвращает таблицу |
| Colorpicker | `.Default`, `.Transparency`, `:GetValue()` | `:Set(color,alpha)`, `:SetState(state,callback)` | `:Set`/`:Update` не вызывают callback автоматически |
| ProgressBar | `.Value.Default` | Методы из REFERENCE | Read-only UI, не slider |
| Button | Не постоянное состояние | Действие `Callback` | Не хранить как Boolean |
| Compound | `.Color/.Dropdown/.Toggle` | Сеттеры детей | Flag только на детях |

Не обещать одинаковую callback-семантику всех сеттеров. Например `Colorpicker:Set` обновляет UI без callback; чтобы передать значение во внешний renderer, используйте его функцию напрямую или `SetState(state,true)`. При переносе проверить инициализацию внешней логики отдельно от визуальных defaults: создание UI не гарантирует, что все ваши побочные эффекты уже выполнены.

## 6. Флаги и конфиги

- Существующие `Flag` сохранять побайтно и не менять тип элемента под тем же флагом.
- Флаги уникальны на **всё окно**, включая settings, icon tabs и compound children. Повторный Flag перезаписывает регистрацию.
- Для новых элементов использовать неймспейс, например `visuals.enemy.enabled`.
- Модель JSON: `__version`, `__elements`, `__custom`, `__autoload`, `__meta`, опционально `__hud`.
- Общие поля элементов старого WindUI часто читаются текущими parsers, но совместимость конкретного старого файла нужно проверить на копии. Чужой/самописный JSON не объявлять совместимым автоматически.
- Значения ProgressBar, Paragraph, mock preview, произвольные таблицы/глобальные переменные не становятся сохранёнными только из-за `Flag`: смотреть `src/config/Init.lua` → `Parser`.
- HUD создать до загрузки конфига. Элементы создать до `EnablePresets`; не рассчитывать на повторный callback для неизменённого значения.
- `Preset:Load` может yield, отвергает конкурентную загрузку и пропускает неизменённые записи. Пользовательские внешние side effects не откатываются автоматически.
- Сохранение custom themes — отдельный файл, не часть обычного preset JSON. Не путать тему, выбранную flagged dropdown, и весь каталог custom themes.
- Всегда проверять `ok,error`; отсутствие файловых API должно отключить хранение, но не ломать UI.

## 7. Бинды

`Toggle/Hold/Always` — режимы штатных hotkeys. Сохранять все привязки, не только первую. `Hold` должен корректно отпускаться при потере фокуса; не заменять его простым flip Boolean. В текущей библиотеке хоткеи встроены в toggle, а пользовательское действие может подключаться через `HotkeyCallback`; точные arguments/модель смотрите `FeatureUI.lua`/`HotkeyModel.lua`. Не переносить старый произвольный Keybind через выдуманный `:Keybind()`.

`Window:SetToggleKey` — отдельная настройка окна. При вводе в TextBox и захвате бинда не запускать действия второй раз своим дублирующим InputBegan.

## 8. Очистка

```lua
Window:OnDestroy(function()
    -- Отключить именно соединения/задачи вашего приложения.
    for _,connection in ipairs(MyConnections) do connection:Disconnect() end
    table.clear(MyConnections)
    MyRenderer:Destroy()
end)
```

В примере выше `MyConnections` и `MyRenderer` — объекты старого проекта, не библиотечные globals. Не копировать их как несуществующие зависимости. `Window:Close()` только скрывает UI; `Window:Destroy()` выполняет unload. Собственные циклы и игровые эффекты нужно завершать отдельно. Anti-AFK в большом демо не переносить автоматически.

## 9. Проверка результата

- Сравнить инвентарь: число вкладок/элементов, flags, параметры и callbacks.
- Проверить каждый callback мышью, сеттером и загрузкой конфига, где применимо.
- Проверить dropdown single/multi, Color3/alpha/gradient, отрицательные/дробные slider values.
- Проверить зависимости: скрытие, повторное появление, бинды скрытых элементов.
- Проверить Settings + вложенный dropdown/color popup: дочернее окно не должно закрывать редактор.
- Проверить сохранение/загрузку/импорт/экспорт/rename на временных копиях, старый JSON не удалять.
- Проверить темы Dark/Light/Paper/Neverlose, курсор, масштаб, узкое окно и длинные названия.
- Проверить menu key, Toggle/Hold/Always, ввод текста, потерю фокуса, unload/rerun.
- Вернуть полный код, карту переноса и честный перечень непроверенных пунктов.

## Дальше

[API](API.md) · [Темы, редактор, курсор и интеграция](ADVANCED.md) · [Примеры](RECIPES.md) · [Составные строки](COMPOSITE.md) · [Точные методы](REFERENCE.md) · [Наблюдаемые поля исходников](SOURCE-CONFIG.md)

<!-- END MIGRATION.md -->

---

<!-- BEGIN INSTALL.md -->

# Подключение

**Не вставляйте исходники библиотеки в свой скрипт.** Загрузите библиотеку один раз, а затем создавайте интерфейс методами `WindUI`, `Window`, вкладок и элементов.

## Одна строка подключения

Для публичного репозитория:

```lua
local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua'))()
```

`dist/main.lua` возвращает библиотеку. Он **не запускает демонстрационное меню**, не включает Anti-AFK и не создаёт ваши элементы автоматически.

Если репозиторий приватный, анонимный raw URL не работает. Не вставляйте GitHub-токен в Roblox-код. Скачайте `dist/main.lua` под своей учётной записью, сохраните как `WindUI.lua` в рабочую папку своего runner и подключите так:

```lua
local WindUI = loadstring(readfile('WindUI.lua'))()
```

`game:HttpGet`, `loadstring` и файловые функции зависят от среды исполнения. Этот способ предназначен для совместимого клиентского runner; обычный LocalScript в Studio не предоставляет эти executor API.

## Первое окно

```lua
local Window = WindUI:CreateWindow({
    Title = 'My menu', Author = 'My project', Icon = 'settings',
    Theme = 'Dark', Folder = 'MyProject', NewElements = true,
    DescriptionMode = 'Tooltip', SearchInTopbar = true,
    ToggleKey = Enum.KeyCode.RightShift,
    Size = UDim2.fromOffset(1000, 650),
})
local Main = Window:Tab({Title = 'Main', Icon = 'house'})
local columns = Main:Columns()
local group = columns.Left:Section({Title = 'Features'})
local enabled = group:Toggle({Title = 'Enabled', Flag = 'enabled', Value = false,
    Callback = function(value)
        print('Your feature:', value)
    end,
})
```

`NewElements=true` включает новую геометрию. `Columns()` создаёт две адаптивные колонки; `columns.Left:Section()` и `columns.Right:Section()` — карточки. Не путайте их с `Tab:Section()`, который создаёт обычный заголовок.

## Готовый короткий пример

[QuickStart.lua](../../QuickStart.lua) показывает подключение, окно, две колонки, toggle, настройки через три точки, inline dropdown, slider, тему, профиль и конфиги. Скопируйте этот пример и замените callbacks своими функциями.

[RemakeExample.lua](../../RemakeExample.lua) — более крупное демонстрационное меню. Для автономного запуска демо скачайте `dist/remake2.lua`; не подключайте этот файл вместо библиотеки в своём проекте.

## Сохранение

Каждому сохраняемому элементу задайте уникальный `Flag`. Создайте все элементы **до** включения менеджера конфигов:

```lua
local presets, err = Window:EnablePresets({Default = 'Default'})
if not presets then warn(err) end
```

Клик по названию конфига или стрелке загрузки загружает его **один раз**. Quick save в шапке сохраняет текущий конфиг. Фильтр сортирует, а повторный клик по активному критерию меняет направление. Подписи со счётчиком внизу нет.

## Версии

URL с `/main/` получает последнюю опубликованную сборку. Для воспроизводимого проекта замените `main` на полный SHA проверенного коммита. Не используйте случайный `latest` из другого репозитория.

## Сборка из исходников

```sh
git submodule update --init --recursive
npm install
npm run build
python build/build-remake2.py
python -m pip install -r build/requirements-docs.txt
python build/build-docs.py
```

Сборка библиотеки требует Luau/darklua по `aftman.toml`. Сайт документации собирается в `docs/site`; его можно открыть локально. GitHub Pages использует workflow `.github/workflows/docs.yml`; публикация Pages требует разрешённых Pages в настройках репозитория.


Alphabetical ставит названия с буквами перед чисто числовыми: `Default → Last → 231`. Повторный выбор меняет направление внутри групп: `Last → Default → 231`. Числовые имена сортируются по числу. Сортировка по датам по-прежнему использует реальные created/modified timestamps.

<!-- END INSTALL.md -->

---

<!-- BEGIN API.md -->

# WindUI Remake 2 — API and integration guide

Version: `1.7.0-remake.3`. Original WindUI by Footagesus, MIT. This is a UI library: example settings do not implement ESP, targeting or gameplay logic.

## Start here (including AI coding assistants)

1. Work in **WindUI-Remake-2**, not the frozen first-remake repo.
2. Read this file and [`RemakeExample.lua`](../../RemakeExample.lua). Use the exact APIs below; do not invent `LeftColumn`, `AddGroupbox`, `SetDependency` or cloud endpoints.
3. Keep the native WindUI font, registered themes, color editor, hotkeys and HUD. Do not replace the title font or globally redesign legacy controls.
4. Give every persisted control a **unique stable `Flag`** across all tabs, columns and subtabs. Labels are not identifiers.
5. The new two-column UI is opt-in. Existing `Window:Tab`, sidebar `Tab:SubTab` / `Tab:Tab`, and original element APIs still work.
6. Create controls first, then call `Window:EnablePresets` so the first save contains all flags. Late controls are registered too, but explicitly load again when their persisted state is needed.

### Build and launch

```sh
git submodule update --init --recursive
npm run build
python build/build-remake2.py
```

Use Luau/darklua installed on PATH. The built `dist/remake2.lua` embeds both library and the **full original menu, adapted rather than replaced**. Search, Visuals → Player/World, General, Themes, profile/preferences/history, both color examples, HUD and original numeric examples remain available. For library-only loading, see [installation](INSTALL.md) and [QuickStart.lua](../../QuickStart.lua). Public raw URLs work only while the repository is public; for private access download the file first and use `loadstring(readfile('WindUI.lua'))()`. **Never embed a PAT in a Roblox script**. `dist/main.lua` is the library only. `ForkExample.lua` / `RestoreBaseline.lua` remain historical baseline files.

## Window, tabs and columns

```lua
local Window = WindUI:CreateWindow({
    Title = 'Sirius', Author = 'Ui library', Icon = 'star',
    HideSearchBar = false, SearchInTopbar = true, ToggleKey = Enum.KeyCode.RightShift,
    Folder = 'MyUI', Theme = 'Dark', NewElements = true,
    Size = UDim2.fromOffset(1100, 720),
    MinSize = Vector2.new(700, 420), MaxSize = Vector2.new(1200, 800),
    DescriptionMode = 'Tooltip', ContentPaddingTop = 8,
})
local Visuals = Window:Tab({Title = 'Visuals', Icon = 'image'})
local columns = Visuals:Columns({Gap = 16, MinColumnWidth = 260})
local main = columns.Left:Section({Title = 'Main'})
local other = columns.Right:Section({Title = 'Other'})
-- :Group({...}) on a COLUMN is an alias for :Section({...}).
```

- Each column stacks independent section cards; rows within a card are 50 logical pixels high.
- Section titles sit above the rounded card. Controls sit on one horizontal row: title on the left, control on the right.
- Widths adapt equally; below `2 * MinColumnWidth + Gap`, the complete left column stacks above the right one. The tab scrolls vertically. Reading order and values are preserved.
- `Columns` returns `.Left`, `.Right`, and `.UIElements` (`Root`, `Left`, `Right`).
- Use `Section` on a column to create a card. Legacy `Tab:Section` still means the original section element.
- Keep a reasonable minimum column width for long labels; labels truncate, not overlap. Customize control `Width` when necessary.

## Header search and profile actions

`SearchInTopbar = true` places the existing working search in the top-right button group, before minimize/fullscreen/close; it removes the old sidebar search gap. Keep `HideSearchBar = false` to enable search. Omit `SearchInTopbar` for legacy sidebar search.

`Window:CreateProfile(...)` now includes **Menu bind** above **Unload**. Click Menu bind and press a keyboard key; Escape cancels, Backspace/Delete clears it. Capturing does not also toggle the window. The example defaults to RightShift. `Window:SetToggleKey(Enum.KeyCode.F8)` changes it programmatically; nil unbinds. This window preference is session-local, not an element flag. Unload invokes the existing `Window:Destroy()` lifecycle and removes the library GUIs and connections. Do not replace it with a visual-only hide.

Preset Create/Rename forms are 306×148 logical pixels; JSON forms expand only when required. Actions and metadata rows use native themed icons. A click on the config trigger immediately dismisses its hover information before opening the preset list; editors replace rather than stack with the list.

## Horizontal icon subtabs (not sidebar children)

```lua
local pages = Visuals:IconTabs()
local enemies = pages:Tab({Id = 'enemies', Title = 'Enemies', Icon = 'user'})
local teammates = pages:Tab({Id = 'team', Title = 'Teammates', Icon = 'user-minus'})
local enemyColumns = enemies:Columns({MinColumnWidth = 260})
local teamColumns = teammates:Columns({MinColumnWidth = 260})
enemyColumns.Left:Section({Title = 'Enemy'}):Toggle({
    Title = 'Show players', Value = true, Flag = 'enemy.enabled',
})
teamColumns.Left:Section({Title = 'Team'}):Toggle({
    Title = 'Show teammates', Value = false, Flag = 'team.enabled',
})
pages:Select('team') -- ID, or 1-based page index; returns false for an unknown page.
enemies:Select()
```

The active top-right button shows icon + title; other buttons are compact icons. Pages are created once and keep independent values. Switching fades in the chosen page. No game model preview is fabricated; a real `Viewport` can be added separately. The previously supported sidebar nesting remains separate.

## Compact elements and examples

The following inherit compact row layout inside columns/cards. Their original APIs still apply.

```lua
local enabled = main:Toggle({
    Title = 'Enabled', Value = true, Flag = 'main.enabled',
    Desc = 'Enable dependent settings.',
    Hotkeys = {{Key = 'K', Mode = 'Toggle', Value = true}},
    Callback = function(value) print(value) end,
})
local distance = main:Slider({
    Title = 'Distance', Width = 140, ValueWidth = 44,
    Value = {Min = 0, Max = 1000, Default = 500}, Step = 1,
    Flag = 'main.distance', Callback = function(value) print(value) end,
})
local label = main:Input({Title = 'Label', Value = 'Sirius', Flag = 'main.label'})
main:Button({Title = 'Reset distance', Callback = function() distance:Set(500) end})
local color = other:Colorpicker({
    Title = 'Accent', Default = Color3.fromHex('2a94ff'), Transparency = .15,
    Flag = 'main.color',
    Callback = function(color, transparency, gradient) end,
})
```

- Toggle: `:Set(boolean)`, `.Value`, `:Lock()`, `:Unlock()`. Right-click retains the native multiple-hotkey manager and animated New Hotkey rows. `Hotkeys=false` disables binding support.
- Slider: `:Set(number)`, `:Get()`, `:SetRange(min,max)`, `:SetMin`, `:SetMax`, `.Value.Default`. Transparency-style 4px track with no large thumb. A compact rounded value editor sits to its right. Click it to type an exact number; input is snapped to Step and clamped to Min/Max. The floating value appears only while dragging, never on simple hover. Compact total width defaults to184 with a72px value slot; `Width` and `ValueWidth` remain configurable. `.UIElements.ValueInput` and `.UIElements.SliderContainer.TextBox` both reference the inline editor; `.UIElements.HoverValue` is the drag-only label.
- Input: `:Set(text)`, `.Value`, editable right-hand text box.
- Button: invokes `Callback`; use for actions, not saved state.
- Colorpicker: `:Set(color,transparency)`, `:SetGradient`, `:Export`, `:Import`, `:Open`. Existing HEX/RGB/HSV/HSL, alpha, gradients and swatch context-copy/paste are preserved.
- Common: `Title`, `Desc`, `Flag`, `Locked`, `Callback`, `:SetTitle`, `:Destroy` where supported.
- Paragraph, Section, Divider, Space, Image, Code, Group, HStack, VStack and Viewport remain the **native WindUI elements**, not forced into a 50px compact row. Use their original APIs documented in the repository and [FORK.md](../../FORK.md); do not assume they are compact controls. Cards support them through the same element factory.

### Dropdown / multi-select

```lua
local target = main:Dropdown({
    Title = 'Target', Values = {'Closest', 'Distance', 'Health'},
    Value = 'Closest', Width = 140, MenuWidth = 190, Flag = 'main.target',
    Callback = function(value) print(value) end,
})
local details = main:Dropdown({
    Title = 'Details', Values = {'Name', 'Distance', 'Health', 'Team'},
    Multi = true, AllowNone = true, Value = {'Name', 'Health'},
    SearchBarEnabled = true, Flag = 'main.details',
    Callback = function(values) end,
})
target:Select('Health')
details:Select({'Name', 'Distance'})
target:Refresh({'Closest', 'Distance', 'Health', 'Team'})
target:Open(); target:Close()
```

- Trigger stays beside its label. The nearby popup follows the trigger, respects UI scale and screen edges, flips above if needed, and has a soft shadow.
- Selection is marked by a right-hand check icon. Multi-select stays open; `AllowNone=false` prevents clearing the last selected option by mouse.
- Long preview text truncates. All options remain visible/searchable in the popup.
- Outside click, Escape, hidden dependency or hidden tab closes it. Only one compact dropdown is open per window.
- `.Values`, `.Value`, `.Opened`, `.Tabs`, `:Display`, `:Refresh`, `:Select`, `:Open`, `:Close`, `:Lock`, `:Unlock` are available.
- String values are recommended. `{Title='Name', Locked=true}` choices are supported; compact mode does not render rich descriptions or divider rows. Use original dropdown outside compact containers for those legacy menus.

## Animated visibility and dependencies

```lua
local builder = main:Toggle({Title='Builder', Value=false, Flag='builder.enabled'})
local settings = columns.Right:Section({
    Title = 'Builder settings',
    VisibleWhen = function() return builder.Value end,
})
local amount = settings:Slider({
    Title='Amount', Value={Min=0,Max=100,Default=35}, Flag='builder.amount',
})
local extra = main:Slider({
    Title='Extra', Value={Min=0,Max=10,Default=3}, Flag='builder.extra',
    VisibleWhen=function() return builder.Value and target.Value=='Health' end,
})
extra:SetVisible(false)       -- explicit master gate
extra:SetVisible(true)        -- predicate is still respected
extra:VisibleWhen(builder)    -- shorthand: builder.Value == true
extra:VisibleWhen(target, 'Health')
extra:SetVisible(false, true) -- instant transition request
```

- `VisibleWhen` must be a **pure, non-yielding function**; do not create controls, write files, or change values inside it. Errors hide the dependent slot.
- Opacity and layout height ease together, including reversal midway. Hidden elements retain values and remain registered for config save/load.
- Hidden slots stop interaction and hidden dependency hotkeys are unavailable. Once revealed, interaction resumes.
- Dependency checks run on Heartbeat, so direct setters, hotkeys and config loads are all observed without overwriting user callbacks.
- Cards and compact controls expose `:SetVisible` and `:VisibleWhen`. To opt a legacy element into this wrapper, pass `Visible=true` or `VisibleWhen=...` at creation.

## Built-in local presets

```lua
-- Call after creating the flagged controls. Requires executor file support.
local presets, err = Window:EnablePresets({Default='Default', Author='Your name'})
assert(presets, err)
local ok, err = presets:Create('My settings') -- saves current values, refuses overwrite
assert(ok, err)
presets:Save()                 -- selected preset
presets:Load('My settings')
presets:Rename('My settings', 'Renamed settings')
local json, err = presets:Export('Renamed settings')
presets:Import('Imported settings', json) -- validates; refuses overwrite
presets:Delete('Imported settings')
presets:Refresh()
presets:Toggle()
```

### UI

The original top window header, immediately right of the sidebar title block, contains a save icon and active preset name/chevron. It is not an extra row below the header. Hovering the name shows name, author and modified date. Clicking opens a rounded local Presets panel with the reference icon order (cloud/Presets on the left; upload, folder-clock/Recent and plus on the right), search and sorting below, new preset, load/save and per-row Rename/Export/Delete actions. Delete requires confirmation. Errors are shown; Export also copies when `setclipboard` exists, otherwise the selectable JSON box is available. Import uses a real JSON text box, not an invented external clipboard reader.

### Storage and guarantees

- Path: `WindUI/<Window.Folder>/config/<name>.json`.
- Needs `writefile`, `readfile`, `isfile`, `isfolder`, `makefolder`; enumeration uses `listfiles`, deletion/rename needs `delfile`. Not available in ordinary Roblox LocalScripts/Studio. `EnablePresets` returns `nil,error` when storage is unavailable.
- JSON contains `__version`, `__elements` (flagged control values and hotkeys), `__custom`, `__autoload`, `__meta` (author/created/modified) and `__hud` if a HUD exists.
- Theme can be persisted using a flagged theme dropdown whose callback calls `WindUI:SetTheme`. Unflagged values are not magically serialized. Window size, selected icon page and every arbitrary callback side effect are not presets.
- Names are trimmed, limited to64 UTF-8 bytes and reject path separators, control characters and reserved filename characters. Import rejects malformed JSON and invalid basic element records.
- Known element types are checked before application; load is synchronous for values, parser failure rolls values back. User callbacks may run asynchronously and their external side effects cannot be rolled back.
- Unknown flags are ignored, enabling configs to survive removed controls. Do not reuse the same flag for a different type.
- `presets.Current` is the selected name; `presets.Sort` accepts `'Created'`, `'Modified'` or `'Name'`; call `:Refresh()` after changing it.
- The cloud icon is visual reference styling only; folder-clock shows recently modified local presets, not version backups. This is **local persistence**, not cloud storage or multi-device sync. File operations are not crash-atomic.

## HUD retained from remake 1

```lua
local hud=Window:CreateHUD({Watermark=true,Keylist=true,Builds={YourRobloxName='Nightly'}})
hud:SetFields({'FPS','Ping','Username','Time','Weekday','Avatar','Logo','Build'})
hud:SetWatermarkEnabled(true)
hud:SetKeylistEnabled(true)
hud:ResetPositions()
```

Watermark telemetry, Sirius brand, full weekday, theme-aware opaque surfaces, white drag guides, Classic keylist, smaller binding plates, multiple hotkeys and config persistence remain available. The new example includes HUD controls in General.

## Verification

- `npm test`: inherited model tests + ConfigNames validation tests.
- Compile new modules with `luau-compile`; build with darklua.
- Execute [`tests/Remake2.lua`](../../tests/Remake2.lua) in the game after the demo: actual file create/save/load/rename/delete/import/export, flag registry, dependencies, dropdown selection, subtabs, responsive columns. Temporary `__qa_*` files are deleted and the selected preset is restored.
- Inspect real game screenshots in Light and Dark, open dropdown/presets, reveal dependencies and resize. Unit tests are not a substitute for visual inspection.

### Thin numeric controls

Sliders use thin tracks without oversized thumbs, plus a right-side rounded inline value editor. Floating values appear only during dragging and use a weak12% dark shadow. Numeric parsing, min/max, steps, callbacks, locks and config persistence are unchanged. `IsTextbox=false` hides the inline editor; drag feedback remains available. Inline editors use stable display width and clipped text; on focus the field expands smoothly within its control, with the track shrinking by the same amount, so typing never spills outside the control.

In compact section cards ProgressBar also uses a50px row, single-line title, thin track and read-only hover value. This fixes Balance/Collection mismatched row heights without turning progress indicators into interactive sliders. The outer section card owns the rounded background; compact rows do not draw separate rounded plates, including after theme changes.

Section cards hide the separator after the last visible row automatically. This also follows animated `SetVisible` / `VisibleWhen` changes; do not draw your own bottom separator on the final row.

Icon subtabs share one rounded background group. The active button has a neutral theme-matched surface and brighter icon; the inactive button remains neutral. Selection/hover transitions do not erase the selected state. `IconTabs().UIElements.Group` exposes the shared plate.

## Per-feature settings popovers

Any native element exposes `:Settings(options)`. On a toggle this adds the ellipsis **left of the switch**; clicking it does not toggle the feature. The popover uses an8px gap beside its button, flips/clamps at the viewport edge, has the feature title above independent rounded cards, and grows with content until scrolling is necessary. Escape, outside click or its close button closes it. Opening another feature closes the previous one.

```lua
local enabled = main:Toggle({Title = 'Overlay', Flag = 'overlay', Value = true})
local options = enabled:Settings({Title = 'Overlay', Width = 380})
local features = options:Section() -- untitled rounded card
features:Toggle({Title = 'Names', Flag = 'overlay_names', Value = true})
features:Toggle({Title = 'Health', Flag = 'overlay_health', Value = true})
features:Dropdown({Title = 'Style', Inline = true, Flag = 'overlay_style',
    Values = {'Classic', 'Minimal'}, Value = 'Classic'})
local display = options:Section({Title = 'Display'}) -- another card
local opacity = display:Slider({
    Title = 'Opacity', Flag = 'overlay_opacity',
    Value = {Min = 0, Max = 100, Default = 85}, Step = 1,
})
display:Dropdown({Title = 'Target', Flag = 'overlay_target',
    Values = {'Classic', 'Minimal'}, Value = 'Classic'})
options:Open()
options:Close()
```

`:Group` aliases `:Section`. A section supports the same native controls as column cards, including sliders, toggles, dropdowns, inputs and color pickers. Flags register with the same window preset manager; values survive closing the popover. `VisibleWhen` / `SetVisible` still work. These settings are UI examples, not implementations of gameplay features.

Alternatively supply `Settings = function(popover, element) ... end` in an element config, with optional `SettingsConfig = {Title = '...', Width = 380}`. The builder receives the same controller. Introspection: `.Opened`, `.Sections`, `.UIElements.Panel/Button/Title/Body/Columns`.

## Slider interaction and appearance follow-up

-50px compact rows,15px row labels and slightly larger example window1100×720 improve readability without changing the font family or sidebar typography.
- Inline value editors use the theme's neutral Button surface rather than a hard black plate. Default minimum value width72px prevents compact values such as `413.46m` from clipping. Focus expands the field smoothly, with the track shrinking by the same amount; blur restores its width. Min/Max/Step validation remains in the shared numeric model.
- Floating drag values fade/scale in and out with a weak shadow. Ordinary hover never opens them.
- Hover the slider control and press Left/Right to change by Step. Holding repeats after320ms, then every60ms. Bounds, locks, hidden controls, a closed window, Roblox's menu and active text editing are respected. No floating drag number opens for arrow input.

## Preset buttons and ordering follow-up

Toolbar icon buttons have delayed hover labels beside the button with an8px gap. Save is separate from the preset-name dropdown: `presets:QuickSave()` saves the selected preset, verifies its file and shows a named success/failure notification. `presets.UIElements.Save` is the actual quick-save button.

The Sort button opens a checked menu with **Newest First** (`Created`), **Recently Modified** (`Modified`) and **Alphabetical** (`Name`). `presets.Sort` accepts these keys; `:Refresh()` reapplies it. Introspection: `.SortOptions` and `.UIElements.SortMenu/Tooltips`. Sorting is local; it is not a cloud preset browser or an automatic-save service.

## Outlined groups and embedded selection

Feature popover groups default to a thin, low-contrast rounded outline with a quiet fill, matching the reference grouping rather than separate floating panels. `options:Section({Outlined=false})` restores the filled card. Ordinary column sections can opt in with `Outlined=true`; `.UIElements.Card` exposes the group surface. Only the groups have this outline: floating popup chrome still uses its soft shadow.

`group:Dropdown({Inline=true, Values={'Classic','Minimal'}, Value='Classic', Flag='style'})` renders all choices directly inside the group with a checkmark on the left and an animated selected surface. No extra popup or trigger is created. `ShowTitle=true` optionally displays the element title. It supports `Multi`, `AllowNone`, locked values, `:Select()`, `:Refresh()` and standard flag persistence. Without `Inline=true`, dropdowns retain the nearby floating checked menu. Embedded choices remain within the settings panel and contribute to its height/scrolling.

The reference-style example puts six inline choices in the first outlined group, then Subtick mode and Turn speed in a second group. The Selections gallery demonstrates Classic/Minimal as a normal floating choice; embedded selection is restricted to feature settings opened through the ellipsis. Sort entries now include calendar, clock and alphabetical-order icons alongside the active checkmark. The preset toolbar was shifted seven logical pixels left.

## Gallery example and animation details

`RemakeExample.lua` now contains the registered demo elements. In addition to Player/World/General/Themes, Elements expands to Controls, Selections and Containers. Controls has Interactive/States icon subtabs; Selections covers single/multi/searchable choices and colors/gradients; Containers demonstrates Group/HStack/VStack/Section/Divider/Space. HUD preview provides watermark/keylist/field/position controls. Example callbacks are UI-only, not gameplay implementations. `WindUIForkDemo.Showcase` exposes the gallery controls.

- Compact dropdown previews follow configured Values order, regardless of click order. Long previews are clipped with an alpha fade at the right edge, never an ellipsis. Changing the selection fades out the old preview and fades in the new one.
- Preset refresh reuses named row instances and tweens their positions over240ms when sorting. New/removed or filtered rows fade in/out rather than rebuilding the entire list. `presets.Order` and `presets.RowCache` expose the current order and reusable rows for tests.
- Drag numbers on sliders inside a feature popover clamp to that popover, not the main window. This prevents the number from jumping sideways when the panel extends outside the menu.
- Outlined cards leave a one-pixel inset around their stroke so CanvasGroup clipping cannot remove the straight border edges.
- Example-only Anti-AFK is enabled by default under General. It listens for LocalPlayer.Idled and attempts a VirtualUser idle pulse. Unsupported APIs are reported; network disconnects and server kicks are not prevented. Its connection is disconnected on unload/rerun. It is not automatically installed by the library itself.


## Screenshot review fixes

- Click a preset row **once**, or its download icon, to load it. Both show a named success/failure notification. The download icon always reloads, even for the current preset; only the header save button saves.
- Only the current preset has a persistent checkmark; the row fill is hover-only. Newest First sorts descending by creation time, Recently Modified descending by modification time, and Alphabetical by name. Identical relative ordering across criteria is valid; existing rows animate to their sorted positions. There is no sort/count footer. Re-selecting the active criterion reverses its direction; `:SetSort(key,reversed)` selects a direction explicitly.
- Section cards and Group/HStack/VStack clip child surfaces through rounded CanvasGroups. Compact lock overlays fit their row instead of extending beyond it.
- `Inline=true` is supported only in feature `:Settings()` groups; normal-page use raises a descriptive error. The obsolete Nested tabs explanation plate was removed from General.
- All Hotkeys uses the library's custom draggable scrollbar, hidden when the content fits.
- Long hover descriptions show an ellipsis. Hover or click it to widen/expand the panel and read the full untruncated text; oversized descriptions can scroll. Moving from the feature row into its description no longer dismisses it immediately.


## Compact UI revision

Feature settings default to336px width,38px control rows and smaller section gaps. `Width` remains configurable. Group/HStack/VStack draw symmetric12px container corners; joined child plates use square joins instead of the old horizontal half-squircle assets. The profile theme value is adjacent to its chevron. Menu bind and Quick save retain their original, unaccented styling at the user’s request. Both remain clickable; the theme value is still closer to its chevron.

Hover description hit-testing uses the same inset-adjusted coordinates as the UI. Expansion preserves the control beneath the pointer, never reduces panel height, and leaves a minus control for collapse. The expanded panel stays open while the cursor is over its text, closes after leaving, and scrolls for oversized content.

The demo no longer contains Media & code or the Try the HUD/Native containers explanation plates. The library still includes Code, Image and Viewport APIs for projects that need them.


## Config load performance and cleanup

- New text registers its font once; registration does not restyle all existing labels. Destroyed text/theme objects are removed from the font/theme registries.
- Reapplying the same theme is a no-op. Preset row icons are reused instead of destroyed/recreated on every refresh.
- All Hotkeys renders lazily while visible, coalesces updates, and defers rendering until a config batch completes. Loading a preset does not rebuild a hidden hotkey list.
- Config loading preflights types, skips unchanged serialized values, applies changed values in a batch with a3ms cooperative frame budget, and rolls back on a parser failure. Hotkey enforcement is suspended during the batch and restored afterward. Concurrent preset loads are rejected as busy rather than stacked.
- Public `presets:Load(name)` still returns only after applying values; it may yield to Heartbeat to keep rendering responsive. Arbitrary user callbacks can still be expensive: keep them small or schedule your own expensive work. Unchanged values do not re-fire their callbacks merely because a preset is loaded again.
- `presets.LastLoadStats` and `Window.LastConfigLoadStats` expose `Applied`, `Skipped`, `Yields`, `DurationMs`. These are diagnostics, not a frame-time guarantee.


Alphabetical ставит названия с буквами перед чисто числовыми: `Default → Last → 231`. Повторный выбор меняет направление внутри групп: `Last → Default → 231`. Числовые имена сортируются по числу. Сортировка по датам по-прежнему использует реальные created/modified timestamps.


## Composed appearance controls and local model preview

See [theme and composition guide](COMPOSITE.md): `section:Compound({Title,Color,Dropdown})`, `section:Compound({Title,Color,Toggle})` and `section:PlayerPreview({Height,Model,State})`. Children use independent native flags and callbacks. Mock preview is local-only and contains no ESP/player scanning. Compact dropdowns and preset toolbar do not add hover fills.


## Latest themes, editor and migration

See [migration guide for AI](MIGRATION.md) and [themes/editor/cursor/full integration](ADVANCED.md). Built-in themes: Dark, Light, Ocean, Forest, Ember, Orchid, Paper, Neverlose. `Window:CreateThemeEditor(parent,config)` provides persistent custom themes with live editing; `Cursor` can be themed or overridden with `Window:SetCustomCursor`. Light/Paper use black cursors. Neverlose uses source RGB and tab hover alpha .4; full C++ renderer/opacity is not a literal port. Presets header remains filled permanently; Recent is a local modified-sort view, not a cloud/history browser.

<!-- END API.md -->

---

<!-- BEGIN ADVANCED.md -->

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

<!-- END ADVANCED.md -->

---

<!-- BEGIN RECIPES.md -->

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

<!-- END RECIPES.md -->

---

<!-- BEGIN COMPOSITE.md -->

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

<!-- END COMPOSITE.md -->

---

<!-- BEGIN REFERENCE.md -->

# Справочник методов

Точные сигнатуры взяты из текущих исходников. Ссылки «source» ведут к месту определения. Для настроек, поведения и готовых фрагментов используйте [API guide](API.md) и [примеры](RECIPES.md). Таблицы ниже не заменяют описание параметров конфигурации. Методы, привязанные к объекту, вызываются через `:`, фабричные внутренние `New`/`Init` сюда не включены.

## Создание элементов

Контейнеры предоставляют `:Toggle(config)`, `:Slider(config)`, `:ProgressBar(config)`, `:Dropdown(config)`, `:Input(config)`, `:Button(config)`, `:Colorpicker(config)`, `:Paragraph(config)`, `:Section(config)`, `:Divider(config)`, `:Space(config)`, `:Group(config)`, `:HStack(config)`, `:VStack(config)`, `:Code(config)`, `:Image(config)`, `:Viewport(config)`. Удалён только демонстрационный раздел Media & code, не методы библиотеки.

Основные поля: `Title`, `Desc`, `Flag`, `Value`, `Callback`, `Locked`, `Visible`, `VisibleWhen`. Dropdown использует `Values`; slider и progress — `Value={Min,Max,Default}`. См. API guide для конкретного типа.

Для `IconTabs` и `Columns` см. раздел Layout ниже. `column:Section()` — карточка, `Tab:Section()` — заголовок.

## WindUI

| Метод | Исходник |
| --- | --- |
| `WindUI.GenerateGUID()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L42) |
| `WindUI:SetParent(parent)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L157) |
| `WindUI:Notify(Config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L175) |
| `WindUI:SetNotificationLower(Val)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L182) |
| `WindUI:SetFont(FontId)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L186) |
| `WindUI:OnThemeChange(func)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L190) |
| `WindUI:AddTheme(LTheme)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L194) |
| `WindUI:SetTheme(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L199) |
| `WindUI:GetThemes()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L214) |
| `WindUI:GetCurrentTheme()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L217) |
| `WindUI:GetThemeProperty(Property, Theme)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L220) |
| `WindUI:RefreshTheme()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L223) |
| `WindUI:GetTransparency()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L228) |
| `WindUI:GetWindowSize()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L231) |
| `WindUI:Localization(LocalizationConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L234) |
| `WindUI:SetLanguage(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L238) |
| `WindUI:ToggleAcrylic(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L245) |
| `WindUI:Gradient(stops, props)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L257) |
| `WindUI:Popup(PopupConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L304) |
| `WindUI:CreateWindow(Config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L316) |

## Window

| Метод | Исходник |
| --- | --- |
| `Window:CreateTopbarButton(Name, Icon, Callback, LayoutOrder, IconThemed, Color, IconSize)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L905) |
| `Window:SetLockOffscreen(enabled)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1096) |
| `Window:SetPosition(position)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1101) |
| `Window:SetDragSmoothness(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1130) |
| `Window:SetToggleKey(keycode)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1203) |
| `Window:SetTitle(text)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1207) |
| `Window:SetAuthor(text)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1212) |
| `Window:SetSize(size)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1221) |
| `Window:SetBackgroundImage(id)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1229) |
| `Window:SetBackgroundImageTransparency(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1232) |
| `Window:SetBackgroundTransparency(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1239) |
| `Window:ToggleFullscreen()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1283) |
| `Window:OnOpen(func)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1338) |
| `Window:OnClose(func)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1341) |
| `Window:OnDestroy(func)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1344) |
| `Window:SetIconSize(Size)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1352) |
| `Window:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1367) |
| `Window:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1464) |
| `Window:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1582) |
| `Window:Toggle()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1585) |
| `Window:ToggleTransparency(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1594) |
| `Window:LockAll()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1602) |
| `Window:UnlockAll()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1609) |
| `Window:GetLocked()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1616) |
| `Window:GetUnlocked()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1627) |
| `Window:GetUIScale(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1639) |
| `Window:SetUIScale(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1643) |
| `Window:SetToTheCenter()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1649) |
| `Window:SetCurrentConfig(ConfigModule)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1660) |
| `Window:EditOpenButton(OpenButtonConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1717) |
| `Window:Tab(TabConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1734) |
| `Window:SelectTab(Tab)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1739) |
| `Window:Section(SectionConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1743) |
| `Window:IsResizable(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1753) |
| `Window:SetPanelBackground(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1758) |
| `Window:CreateProfile(profileConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1778) |
| `Window:CreateThemeEditor(parent, editorConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1784) |
| `Window:Divider()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1788) |
| `Window:Dialog(DialogConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1811) |
| `Window:Tag(TagConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2051) |
| `Window:DisableTopbarButtons(btns)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2232) |
| `Window:ShowHotkeys()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2270) |
| `Window:CreateHUD(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2271) |
| `Window:SetCustomCursor(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2278) |
| `Window:EnablePresets(options)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2280) |

## Tab

| Метод | Исходник |
| --- | --- |
| `Tab:ScrollToTheElement(elemindex)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L445) |
| `Tab:LockAll()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L489) |
| `Tab:UnlockAll()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L497) |
| `Tab:GetLocked()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L504) |
| `Tab:GetUnlocked()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L515) |
| `Tab:Expand()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L557) |
| `Tab:Collapse()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L561) |
| `Tab:SubTab(SubConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L566) |
| `Tab:Select()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Tab.lua#L611) |

## Custom theme editor

| Метод | Исходник |
| --- | --- |
| `themeEditor:GetNames()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L44) |
| `themeEditor:OpenCreate()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L47) |
| `themeEditor:OpenEditor(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L48) |

## Config manager

| Метод | Исходник |
| --- | --- |
| `configManager:SetPath(customPath)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L135) |
| `configManager:CreateConfig(configFilename, autoload)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L153) |
| `configManager:Config(configFilename, autoload)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L375) |
| `configManager:GetAutoLoadConfigs()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L379) |
| `configManager:DeleteConfig(configName)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L391) |
| `configManager:AllConfigs()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L420) |
| `configManager:GetConfig(configName)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L439) |

## Config module

| Метод | Исходник |
| --- | --- |
| `config:SetAsCurrent()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L169) |
| `config:Register(Name, Element)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L173) |
| `config:Set(key, value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L177) |
| `config:Get(key)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L181) |
| `config:SetAutoLoad(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L185) |
| `config:Save()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L189) |
| `config:Load()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L220) |
| `config:Delete()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L312) |
| `config:GetData()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/config/Init.lua#L338) |

## Cursor

| Метод | Исходник |
| --- | --- |
| `cursor:Set(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua#L35) |
| `cursor:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua#L51) |

## Layout: columns and icon tabs

| Метод | Исходник |
| --- | --- |
| `col:Section(cfg)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L23) |
| `tab:Columns(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L74) |
| `tab:IconTabs(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L75) |
| `controller:Tab(cfg)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L83) |
| `p:Columns(c)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L87) |
| `p:Select()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L96) |
| `controller:Select(which)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L102) |

## Profile

| Метод | Исходник |
| --- | --- |
| `profile:BeginMenuBind()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L93) |
| `profile:CancelMenuBind()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L97) |
| `profile:SetTransparency(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L139) |
| `profile:GetTransparency()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L149) |
| `profile:SyncTheme()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L271) |
| `profile:SetThemes(values)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L309) |
| `profile:CloseFlyout()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L335) |
| `profile:OpenFlyout(kind)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L341) |
| `profile:ShowPage(page)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L387) |
| `profile:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L397) |
| `profile:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L408) |
| `profile:Renew()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L429) |
| `profile:SetSubscription(info)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L448) |
| `profile:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L464) |

## HUD

| Метод | Исходник |
| --- | --- |
| `hud:SetWatermarkEnabled(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L212) |
| `hud:SetKeylistEnabled(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L213) |
| `hud:SetField(id,v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L214) |
| `hud:SetFields(selection)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L218) |
| `hud:GetFields()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L222) |
| `hud:GetAvailableFields()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L223) |
| `hud:SetKeylistMode(mode)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L224) |
| `hud:ResetPositions()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L229) |
| `hud:Export()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L230) |
| `hud:Import(data)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L234) |
| `hud:GetMetrics()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L250) |
| `hud:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L251) |

## Presets

| Метод | Исходник |
| --- | --- |
| `presets:Create(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L59) |
| `presets:QuickSave()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L65) |
| `presets:Save(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L71) |
| `presets:Load(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L75) |
| `presets:LoadFromUI(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L86) |
| `presets:Delete(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L92) |
| `presets:Export(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L96) |
| `presets:Import(name,json)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L100) |
| `presets:Rename(old,new)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L107) |
| `presets:Refresh()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L233) |
| `presets:Toggle()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L196) |
| `presets:SetSort(key,reversed)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L230) |

## Feature settings

| Метод | Исходник |
| --- | --- |
| `options:Footer(cfg)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L38) |
| `options:Section(cfg,side)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L60) |
| `options:RightSection(cfg)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L65) |
| `options:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L76) |
| `options:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L81) |
| `options:Toggle()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L87) |
| `options:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L109) |

## Common element methods

| Метод | Исходник |
| --- | --- |
| `element:SetTitle(title)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L90) |
| `element:SetDesc(desc)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L94) |
| `element:SetImage(image, size)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L98) |
| `element:SetThumbnail(image, size)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L101) |
| `element:Highlight()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L104) |
| `element:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L107) |
| `element:Settings(options)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Init.lua#L128) |

## Visibility

| Метод | Исходник |
| --- | --- |
| `element:SetVisible(value,instant)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Visibility.lua#L15) |
| `element:VisibleWhen(control,expected)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Visibility.lua#L18) |

## Hotkeys and descriptions

| Метод | Исходник |
| --- | --- |
| `element:ShowDescription()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L319) |
| `element:GetHotkeys()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L331) |
| `element:SetHotkeys(rows)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L332) |
| `element:AddHotkey(data)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L337) |
| `element:ResetHotkeys()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L340) |
| `element:OpenHotkeys(point)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L341) |

## Compound

| Метод | Исходник |
| --- | --- |
| `compound:GetControl(name)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L39) |
| `compound:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L40) |
| `compound:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L41) |

## PlayerPreview

| Метод | Исходник |
| --- | --- |
| `playerPreview:SetModel(model)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L38) |
| `playerPreview:Update(values)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L46) |
| `playerPreview:SetColor(color)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L56) |
| `playerPreview:SetBoxColor(color)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L57) |
| `playerPreview:SetMode(mode)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L58) |
| `playerPreview:SetEnabled(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L59) |
| `playerPreview:SetRotation(degrees)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L60) |
| `playerPreview:GetState()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L61) |

## Dropdown

| Метод | Исходник |
| --- | --- |
| `dropdown:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L116) |
| `dropdown:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L123) |

## Section

| Метод | Исходник |
| --- | --- |
| `section:SetIcon(i)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L37) |
| `section:SetTitle(Title)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L240) |
| `section:SetDesc(Desc)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L245) |
| `section:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L253) |
| `section:Open(IsNotAnim)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L268) |
| `section:Close(IsNotAnim)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L303) |

## Toggle

| Метод | Исходник |
| --- | --- |
| `toggle:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L48) |
| `toggle:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L53) |
| `toggle:Set(v, isCallback, isAnim)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L92) |

## Slider

| Метод | Исходник |
| --- | --- |
| `slider:Set(newValue)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L314) |
| `slider:Get()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L327) |
| `slider:SetRange(newMin, newMax)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L329) |
| `slider:SetMin(newMin)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L343) |
| `slider:SetMax(newMax)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L348) |
| `slider:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L353) |
| `slider:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L360) |

## ProgressBar

| Метод | Исходник |
| --- | --- |
| `progressBar:Set(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L219) |
| `progressBar:Get()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L223) |
| `progressBar:GetPercentage()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L227) |
| `progressBar:SetRange(NewMin, NewMax)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L231) |
| `progressBar:SetMin(NewMin)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L250) |
| `progressBar:SetMax(NewMax)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L260) |

## Input

| Метод | Исходник |
| --- | --- |
| `input:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L73) |
| `input:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L78) |
| `input:Set(v, IsUserInput)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L84) |
| `input:SetPlaceholder(v)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L95) |

## Button

| Метод | Исходник |
| --- | --- |
| `button:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L83) |
| `button:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L88) |

## CompactDropdown

| Метод | Исходник |
| --- | --- |
| `compactDropdown:Select(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L49) |
| `compactDropdown:Refresh(values)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L71) |
| `compactDropdown:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L72) |
| `compactDropdown:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L77) |
| `compactDropdown:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L78) |
| `compactDropdown:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L79) |

## InlineDropdown

| Метод | Исходник |
| --- | --- |
| `inlineDropdown:Select(value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L22) |
| `inlineDropdown:Refresh(values)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L37) |
| `inlineDropdown:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L57) |
| `inlineDropdown:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L58) |
| `inlineDropdown:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L59) |
| `inlineDropdown:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L60) |

## Colorpicker

| Метод | Исходник |
| --- | --- |
| `colorpicker:GetValue()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L21) |
| `colorpicker:GetGradient()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L22) |
| `colorpicker:GetColorSequence()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L23) |
| `colorpicker:SetState(value,callback)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L24) |
| `colorpicker:SetGradient(value,callback)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L34) |
| `colorpicker:Update(color,transparency)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L35) |
| `colorpicker:Set(color,transparency)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L40) |
| `colorpicker:Reset(callback)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L41) |
| `colorpicker:Export()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L42) |
| `colorpicker:Import(data)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L43) |
| `colorpicker:Lock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L46) |
| `colorpicker:Unlock()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L47) |
| `colorpicker:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L48) |

## Code

| Метод | Исходник |
| --- | --- |
| `code:SetCode(code)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L62) |
| `code:Set(code)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L67) |
| `code:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L71) |
| `code.UpdateShape(Tab)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L76) |

## Viewport

| Метод | Исходник |
| --- | --- |
| `viewport:SetObject(Object, IsClone)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L199) |
| `viewport:SetHeight(Height)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L211) |
| `viewport:Focus()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L215) |
| `viewport:SetCamera(Camera)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L221) |
| `viewport:SetInteractive(Interactive)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L226) |

## Свойства и стабильные идентификаторы

- `element.Value` — текущее значение toggle/dropdown/input; `slider:Get()` — числовое значение slider.
- `Window.PendingFlags` и `.UIElements` предназначены в первую очередь для расширений и диагностики; не привязывайте бизнес-логику к случайным именам GUI descendants.
- `presets.Current`, `.Sort`, `.SortReversed` доступны для чтения. Используйте `:SetSort(key,reversed)`, а не прямое изменение поля, чтобы сразу обновить UI.
- `presets:Create/Save/Load/Import/Rename/Delete` возвращают `ok, err`; `Export` возвращает JSON или `false, err`.
- У `Toggle:Set(value, isCallback, isAnim)` дополнительные флаги меняют вызов callback и анимацию. Для обычной работы достаточно `:Set(value)`.
- `:SetVisible()`/`:VisibleWhen(control,expected)` доступны элементам, для которых подключена Visibility: compact rows, элементы с `Visible`/`VisibleWhen` и секции-карточки. Они не автоматически присутствуют у любого legacy объекта.

<!-- END REFERENCE.md -->

---

<!-- BEGIN SOURCE-CONFIG.md -->

# Индекс полей конфигурации из исходников

Автоматически извлечены точные обращения `Config.X`, `config.X`, `cfg.X` из текущего кода. Это **указатель для чтения исходника**, не исчерпывающая спецификация типов/defaults и не гарантия, что внутренний ключ поддерживается для каждого контейнера. Используйте API/MIGRATION/ADVANCED для контрактов и примеров. При неоднозначности читайте указанное определение. Вспомогательные locals с именем cfg тоже могут относиться к вложенной конфигурации.

Внутренние поля, которые фабрика заполняет сама, исключены: `ElementsModule`, `GlobalIndex`, `Index`, `Parent`, `ParentTable`, `ParentType`, `Tab`, `UIScale`, `WindUI`, `Window`. Не передавайте их из приложения.

## Window

Исходник: [src/components/window/Init.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua)

| Поле | Первое обращение |
| --- | --- |
| `Acrylic` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L61) |
| `Author` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L32) |
| `AutoScale` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L65) |
| `Background` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L39) |
| `BackgroundImageTransparency` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L40) |
| `ContentPaddingTop` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L67) |
| `CustomCursor` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2279) |
| `DescriptionMode` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2268) |
| `DragSmoothness` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1126) |
| `ElementsRadius` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L54) |
| `Folder` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L37) |
| `Footer` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L43) |
| `HUD` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2276) |
| `HidePanelBackground` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L64) |
| `HideSearchBar` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L57) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L33) |
| `IconRadius` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L36) |
| `IconSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L34) |
| `IconThemed` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L35) |
| `IgnoreAlerts` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L63) |
| `LockOffscreen` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L66) |
| `MaxSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L49) |
| `MinSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L48) |
| `NewElements` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L62) |
| `OpenButton` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L68) |
| `Radius` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L55) |
| `Resizable` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L38) |
| `ScrollBarEnabled` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L59) |
| `SearchInTopbar` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L58) |
| `ShadowTransparency` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L41) |
| `SideBarWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L60) |
| `Size` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L46) |
| `Theme` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L779) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L31) |
| `ToggleKey` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L53) |
| `TopBarButtonIconSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L51) |
| `Topbar` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L44) |
| `Transparent` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L56) |
| `User` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L42) |

## Columns / IconTabs

Исходник: [src/components/window/RemakeLayout.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua)

| Поле | Первое обращение |
| --- | --- |
| `Gap` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L62) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L92) |
| `Id` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L86) |
| `MinColumnWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L62) |
| `Outlined` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L25) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/RemakeLayout.lua#L26) |

## Settings

Исходник: [src/components/window/FeatureSettings.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua)

| Поле | Первое обращение |
| --- | --- |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L47) |
| `Centered` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L13) |
| `ColumnGap` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L21) |
| `HeaderIcon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L14) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L24) |
| `MinColumnWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L21) |
| `Outlined` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L61) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L11) |
| `Width` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L8) |

## Profile

Исходник: [src/components/window/Profile.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua)

| Поле | Первое обращение |
| --- | --- |
| `Avatar` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L49) |
| `History` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L193) |
| `IsCustomTheme` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L291) |
| `Name` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L52) |
| `OnThemeChanged` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L280) |
| `OnThemeRequested` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L276) |
| `OnThemeSettings` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L295) |
| `StoreLink` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L432) |
| `Themes` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L229) |

## HUD

Исходник: [src/components/window/HUD.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua)

| Поле | Первое обращение |
| --- | --- |
| `Build` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L46) |
| `Builds` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L46) |
| `Fields` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L16) |
| `Keylist` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L17) |
| `KeylistTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L68) |
| `MetricsProvider` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L87) |
| `Name` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L52) |
| `Watermark` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/HUD.lua#L17) |

## Custom themes

Исходник: [src/components/window/ThemeEditor.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua)

| Поле | Первое обращение |
| --- | --- |
| `Builtins` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L39) |
| `CreateTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L175) |
| `DefaultBase` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L176) |
| `FallbackTheme` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L147) |
| `Fields` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L40) |
| `FileName` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L41) |
| `Folder` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L41) |
| `OnChanged` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L51) |
| `OnThemeChanged` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/ThemeEditor.lua#L85) |

## Cursor

Исходник: [src/components/window/Cursor.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua)

| Поле | Первое обращение |
| --- | --- |
| `Color` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua#L40) |
| `Enabled` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua#L38) |
| `Size` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Cursor.lua#L46) |

## Descriptions / hotkeys

Исходник: [src/components/window/FeatureUI.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua)

| Поле | Первое обращение |
| --- | --- |
| `DescMode` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L310) |
| `HotkeyCallback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L322) |
| `Hotkeys` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureUI.lua#L322) |

## Button

Исходник: [src/elements/Button.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua)

| Поле | Первое обращение |
| --- | --- |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L19) |
| `Color` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L14) |
| `CompactRow` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L37) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L10) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L11) |
| `IconAlign` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L16) |
| `IconColor` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L13) |
| `IconThemed` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L12) |
| `Image` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L29) |
| `ImageSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L30) |
| `Justify` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L15) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L17) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L18) |
| `Size` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L43) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L44) |
| `Thumbnail` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L31) |
| `ThumbnailSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L32) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Button.lua#L9) |

## Code

Исходник: [src/elements/Code.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua)

| Поле | Первое обращение |
| --- | --- |
| `CanCopied` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L18) |
| `Code` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L13) |
| `CodeSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L14) |
| `CodeTheme` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L16) |
| `Height` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L15) |
| `OnCopy` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L19) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Code.lua#L12) |

## Colorpicker

Исходник: [src/elements/Colorpicker.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua)

| Поле | Первое обращение |
| --- | --- |
| `AllowGradient` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L11) |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L11) |
| `Default` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L8) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L10) |
| `Gradient` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L8) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L10) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L10) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L12) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L10) |
| `Transparency` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L8) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Colorpicker.lua#L8) |

## CompactDropdown

Исходник: [src/elements/CompactDropdown.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua)

| Поле | Первое обращение |
| --- | --- |
| `AllowNone` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L101) |
| `MenuWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L34) |
| `Multi` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `SearchBarEnabled` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L35) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `Values` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L6) |
| `Width` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/CompactDropdown.lua#L11) |

## Compound

Исходник: [src/elements/Compound.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua)

| Поле | Первое обращение |
| --- | --- |
| `Color` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L6) |
| `CompactRow` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L24) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L24) |
| `Dropdown` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L5) |
| `Embedded` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L24) |
| `Flag` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L7) |
| `Hotkeys` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L24) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L52) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L8) |
| `Toggle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L5) |
| `Width` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Compound.lua#L24) |

## Dropdown

Исходник: [src/elements/Dropdown.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua)

| Поле | Первое обращение |
| --- | --- |
| `AllowNone` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L41) |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L44) |
| `CompactRow` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L31) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L35) |
| `Inline` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L30) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L36) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L37) |
| `MenuWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L39) |
| `Multi` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L43) |
| `SearchBarEnabled` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L42) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L72) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L34) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L40) |
| `Values` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Dropdown.lua#L38) |

## HStack

Исходник: [src/elements/HStack.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/HStack.lua)

| Поле | Первое обращение |
| --- | --- |
| `AutoSpace` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/HStack.lua#L9) |

## Image

Исходник: [src/elements/Image.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Image.lua)

| Поле | Первое обращение |
| --- | --- |
| `AspectRatio` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Image.lua#L22) |
| `Image` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Image.lua#L21) |
| `Radius` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Image.lua#L23) |

## InlineDropdown

Исходник: [src/elements/InlineDropdown.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua)

| Поле | Первое обращение |
| --- | --- |
| `AllowNone` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `Multi` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `RowHeight` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L6) |
| `ShowTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L13) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |
| `Values` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/InlineDropdown.lua#L7) |

## Input

Исходник: [src/elements/Input.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua)

| Поле | Первое обращение |
| --- | --- |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L24) |
| `ClearTextOnFocus` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L25) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L17) |
| `InputIcon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L21) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L19) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L20) |
| `Placeholder` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L22) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L44) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L16) |
| `Type` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L18) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Input.lua#L23) |

## PlayerPreview

Исходник: [src/elements/PlayerPreview.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua)

| Поле | Первое обращение |
| --- | --- |
| `Height` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L7) |
| `Model` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L64) |
| `State` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L64) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/PlayerPreview.lua#L6) |

## ProgressBar

Исходник: [src/elements/ProgressBar.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua)

| Поле | Первое обращение |
| --- | --- |
| `Animate` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L57) |
| `AnimationDuration` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L58) |
| `Compact` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L42) |
| `ControlGap` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L62) |
| `Decimals` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L42) |
| `Default` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L29) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L48) |
| `DisplayMode` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L40) |
| `Format` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L56) |
| `Indeterminate` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L33) |
| `IndeterminateText` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L60) |
| `Max` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L21) |
| `Min` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L20) |
| `ShowValue` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L35) |
| `Speed` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L61) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L113) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L47) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L19) |
| `ValueWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L40) |
| `Width` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/ProgressBar.lua#L65) |

## Section

Исходник: [src/elements/Section.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua)

| Поле | Первое обращение |
| --- | --- |
| `Box` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L17) |
| `BoxBorder` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L18) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L11) |
| `DescFontWeight` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L20) |
| `DescTextSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L16) |
| `DescTextTransparency` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L22) |
| `FontWeight` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L19) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L12) |
| `IconThemed` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L13) |
| `Opened` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L23) |
| `TextSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L15) |
| `TextTransparency` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L21) |
| `TextXAlignment` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L14) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Section.lua#L10) |

## Slider

Исходник: [src/elements/Slider.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua)

| Поле | Первое обращение |
| --- | --- |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L32) |
| `Compact` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L29) |
| `Decimals` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L30) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L21) |
| `Format` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L31) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L112) |
| `IconOffset` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L115) |
| `IconSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L113) |
| `IconThemed` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L114) |
| `Icons` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L25) |
| `Image` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L112) |
| `ImageOffset` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L115) |
| `ImageSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L113) |
| `IsTextbox` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L27) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L22) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L23) |
| `Step` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L28) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L125) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L20) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L24) |
| `ValueWidth` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L37) |
| `Width` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Slider.lua#L36) |

## Space

Исходник: [src/elements/Space.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Space.lua)

| Поле | Первое обращение |
| --- | --- |
| `Columns` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Space.lua#L9) |

## Toggle

Исходник: [src/elements/Toggle.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua)

| Поле | Первое обращение |
| --- | --- |
| `Callback` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L21) |
| `Desc` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L14) |
| `Icon` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L18) |
| `IconSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L19) |
| `Image` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L27) |
| `ImageSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L28) |
| `Locked` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L15) |
| `LockedTitle` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L16) |
| `Tags` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L39) |
| `Thumbnail` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L29) |
| `ThumbnailSize` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L30) |
| `Title` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L13) |
| `Type` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L20) |
| `Value` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Toggle.lua#L17) |

## Video

Исходник: [src/elements/Video.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Video.lua)

| Поле | Первое обращение |
| --- | --- |
| `AspectRatio` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Video.lua#L25) |
| `Radius` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Video.lua#L26) |
| `Video` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Video.lua#L24) |

## Viewport

Исходник: [src/elements/Viewport.lua](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua)

| Поле | Первое обращение |
| --- | --- |
| `Camera` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L29) |
| `Focused` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L32) |
| `Height` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L31) |
| `Interactive` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L30) |
| `Object` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/elements/Viewport.lua#L28) |

## Theme properties и fallbacks

Ключи берутся из `src/themes/Init.lua` и `src/themes/Fallbacks.lua`. Значения бывают Color3, ссылки на другие свойства, числа transparency или специальные флаги (например CleanShapes). Не все свойства имеют UI-редактор. Прозрачность Roblox: 0 = непрозрачно, 1 = невидимо.

[Палитры](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/themes/Init.lua) · [Fallbacks](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/themes/Fallbacks.lua)

- `Accent`
- `Background`
- `BackgroundTransparency`
- `Black`
- `Button`
- `CardBorder`
- `CardBorderTransparency`
- `CardTransparency`
- `Checkbox`
- `CheckboxBorder`
- `CheckboxBorderTransparency`
- `CheckboxIcon`
- `ChoiceBackground`
- `ChoiceTransparency`
- `CleanShapes`
- `Cursor`
- `Dialog`
- `DialogBackground`
- `DialogBackgroundTransparency`
- `DialogContent`
- `DialogIcon`
- `DialogTitle`
- `DropdownBackground`
- `DropdownTabBackground`
- `DropdownTabBorder`
- `ElementBackground`
- `ElementBackgroundHover`
- `ElementBackgroundTransparency`
- `ElementDesc`
- `ElementIcon`
- `ElementTitle`
- `Hover`
- `Icon`
- `LabelBackground`
- `LabelBackgroundTransparency`
- `Notification`
- `Notification2`
- `Notification2Transparency`
- `NotificationBorder`
- `NotificationBorderTransparency`
- `NotificationContent`
- `NotificationContentTransparency`
- `NotificationDuration`
- `NotificationDurationTransparency`
- `NotificationTitle`
- `NotificationTitleTransparency`
- `Outline`
- `PanelBackground`
- `PanelBackgroundTransparency`
- `Placeholder`
- `PopupBackground`
- `PopupBackgroundTransparency`
- `PopupContent`
- `PopupIcon`
- `PopupTitle`
- `Primary`
- `ProgressBar`
- `ProgressBarText`
- `ProgressBarTrack`
- `ProgressBarTrackTransparency`
- `SearchBarBorder`
- `SearchBarBorderTransparency`
- `SectionBox`
- `SectionBoxBackground`
- `SectionBoxBackgroundTransparency`
- `SectionBoxBorder`
- `SectionBoxBorderTransparency`
- `SectionBoxTransparency`
- `SectionExpandIcon`
- `SectionExpandIconTransparency`
- `SectionIcon`
- `Slider`
- `SliderIcon`
- `SliderIconFrom`
- `SliderIconTo`
- `SliderThumb`
- `TabBackground`
- `TabBackgroundActive`
- `TabBackgroundActiveTransparency`
- `TabBackgroundHover`
- `TabBackgroundHoverTransparency`
- `TabBorder`
- `TabBorderTransparency`
- `TabBorderTransparencyActive`
- `TabIcon`
- `TabIconActive`
- `TabIconTransparency`
- `TabIconTransparencyActive`
- `TabSectionIcon`
- `TabText`
- `TabTextTransparency`
- `TabTextTransparencyActive`
- `TabTitle`
- `Text`
- `Toggle`
- `ToggleBar`
- `ToggleThumbOff`
- `ToggleTrack`
- `Tooltip`
- `TooltipSecondary`
- `TooltipSecondaryText`
- `TooltipText`
- `ViewportBackground`
- `ViewportBackgroundTransparency`
- `White`
- `WindowBackground`
- `WindowSearchBarBackground`
- `WindowShadow`
- `WindowShadowTransparency`
- `WindowTopbarAuthor`
- `WindowTopbarButtonIcon`
- `WindowTopbarIcon`
- `WindowTopbarTitle`

<!-- END SOURCE-CONFIG.md -->

---

<!-- BEGIN QA.md -->

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

## Screenshot review regression

- `tests/ReviewFixes.lua`:35 live assertions passed. Real temporary files with deliberately different creation/modification ordering verify sort order and animated row positions; one-click row load and current-preset download both restore values, with a success notification. Only current rows remain highlighted. Test files and values are restored.
- Rounded section/native container clipping, normal-page Inline rejection, embedded settings availability, ellipsis-hover expansion and full description canvas are covered. All Hotkeys overflow was exercised with30 temporary bindings: native scrollbar disabled, custom thumb visible and following CanvasPosition; original bindings restored.
- Fresh full regression: Remake2 33, Followup 33, FeatureSettings 26, InlineSettings 30, SliderPolish 23, ThinSliders 58, ReviewFixes 35 —238 live assertions passed. All pure `npm test` suites passed; rebuilt `dist/main.lua` compiled successfully.
- Actual game screenshot of the updated Containers gallery inspected after rebuilding/restarting the demo. Anti-AFK remains enabled. Screenshot-review changes are local until explicitly pushed.


## Final polish and preset-loading performance (Remake 2)

- Rebuilt and re-injected both current library/demo outputs. Nine live regression suites passed: Remake2 33, Followup 29, FeatureSettings 26, InlineSettings 30, SliderPolish 23, ThinSliders 58, ReviewFixes 35, PolishReview 50, ConfigPerformance 138 — 422 assertions total. All pure `npm test` suites also passed.
- Alphabetical sorting puts letter-containing names before numeric-only names: Default → Last → 231. Reverse sorting changes order within those groups. Tests verify actual row positions, not just the selected checkmark. No sort/count footer remains.
- Compact settings use a 336px panel and 38px rows. Joined containers use one rounded outer CanvasGroup, not mismatched half-corner assets. Removed only Media & code demo, not the library methods. Original menu-bind/quick-save colors are retained.
- Real virtual-pointer tests verify description expansion, reading without disappearance, and dismissal outside the row/tooltip. Slider keyboard hover uses the same GUI inset conversion.
- Found and removed theme/font registry leaks and repeated full font scans during label registration. Destroyed instances unregister themselves. Hidden hotkey lists no longer rebuild on every change; config import batches hotkey updates and skips unchanged values.
- On this connected client, 24 real preset loads measured median 2.21ms, maximum 3.16ms. A synthetic 100-control load took 23.01ms across five cooperative yields while the heartbeat continued. Final registry check found zero dead theme objects. These are local measurements, not a cross-device guarantee. Parser-failure tests verify rollback and released loading guards.
- Documentation includes four responsive routes, 191 source-linked method definitions, 65 searchable sections, copy buttons, mobile navigation and dark mode. All routes checked at 1280px/390px: no page-width overflow or JavaScript errors; search, copy and mobile navigation passed. Desktop/mobile and interactive screenshots visually inspected.
- GitHub Pages deployment is gated on a public repository. Private repositories retain Markdown docs and downloadable self-contained HTML; no visibility change is performed automatically.


## Original Dark, static fields, composed rows and local preview

- Dark definitions compared against the official Footagesus/WindUI `src/themes/Init.lua`; they are identical. No violet palette is installed. Other registered themes remain available.
- Compact circular switches are 40×24 with a 20px thumb and 0.18s movement tween. A real virtual mouse click toggles the value and shows an intermediate thumb position before it settles. Locks, config flags and hotkeys retain native behavior.
- Compact dropdown triggers and header save/preset buttons have no hover opacity changes. Real pointer hover left both color and transparency unchanged. Choice fields have a permanent rounded Dialog-colored surface. Preset toolbar has a thin outline and save/name divider.
- Compound uses independent native Colorpicker + Dropdown or Toggle children, independent flags/callbacks, row-wide locks/visibility and cleanup. The local mock preview supports cloned models, materials, color, independent box color, health/name/distance, rotation and display visibility; it never scans players or workspace. Config load now invokes the native color callback after restoring its state so connected previews/renderers stay synchronized.
- Final regression: ten suites, 476 live assertions passed (including 54 composition checks). Pure suites passed. Color/choice/toggle file roundtrip, model clone ownership/script removal, independent state snapshots, box/model colors, root/child teardown and flag cleanup tested. Movement and track color were observed between endpoints.
- In-game screenshots reviewed: original Dark, static rounded dropdown fields, small switches, compound rows and local block model preview. New documentation route checked at 1280px/390px; no page-width overflow.


## Smooth icon-tab transitions

- Selected tab re-click is a no-op (numeric/id selection, repeated button signals, actual virtual pointer click and clicking during an in-flight transition).
- Both pages crossfade for 0.22s; outgoing content remains visible until fade completion but immediately stops receiving input. Button width, label transparency and content height also tween rather than jump.
- Rapid switches cancel prior page/label/width/height tweens. Cancelled completion handlers cannot hide the newly selected page.
- Final full regression: eleven suites, 496 live assertions passed, including 20 dedicated transition checks. Both incoming/outgoing opacity, expanding/shrinking button widths and label opacity were measured at intermediate positions. Active clicks generated zero opacity changes. All pure suites passed.


## Migration handoff / latest documentation checks

- `docs/remake-2/AI-CONTEXT.md` bundles nine full documents, including the migration prompt/checklist, theme/editor/cursor integration and source-derived method/option indexes. Rebuild via `python build/build-docs.py` (also regenerates indexes and the bundle).
- Documentation Lua snippets: 37 blocks compiled successfully with `luau-compile`. Local website links: 199 checked, no missing files at build time.
- `tests/Documentation.lua` is a prepared live smoke test for documented APIs; it was **not executed** in this publication pass because the Roblox connector was disconnected. It must not be reported as passed.
- Most recent connected-client results before disconnection: PopupPolish 94 assertions; ThemeCursor 40 assertions (Neverlose source colors/tab opacity, no extra card outlines, cursor contrast/override/reset and editor card style).
- `npm test` passed in this publication pass. Syntax checks do not establish runtime behavior of an arbitrary migrated user script; preserve the per-project migration test checklist.

<!-- END QA.md -->
