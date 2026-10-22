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
