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
