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
| `WindUI:GetTransparency()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L220) |
| `WindUI:GetWindowSize()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L223) |
| `WindUI:Localization(LocalizationConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L226) |
| `WindUI:SetLanguage(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L230) |
| `WindUI:ToggleAcrylic(Value)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L237) |
| `WindUI:Gradient(stops, props)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L249) |
| `WindUI:Popup(PopupConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L296) |
| `WindUI:CreateWindow(Config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/Init.lua#L308) |

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
| `Window:Divider()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1784) |
| `Window:Dialog(DialogConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L1807) |
| `Window:Tag(TagConfig)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2047) |
| `Window:DisableTopbarButtons(btns)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2228) |
| `Window:ShowHotkeys()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2266) |
| `Window:CreateHUD(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2267) |
| `Window:SetCustomCursor(config)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2274) |
| `Window:EnablePresets(options)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Init.lua#L2276) |

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
| `profile:SyncTheme()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L242) |
| `profile:CloseFlyout()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L284) |
| `profile:OpenFlyout(kind)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L290) |
| `profile:ShowPage(page)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L336) |
| `profile:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L346) |
| `profile:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L357) |
| `profile:Renew()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L378) |
| `profile:SetSubscription(info)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L397) |
| `profile:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/Profile.lua#L413) |

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
| `presets:Refresh()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L228) |
| `presets:Toggle()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L191) |
| `presets:SetSort(key,reversed)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/PresetUI.lua#L225) |

## Feature settings

| Метод | Исходник |
| --- | --- |
| `options:Section(cfg)` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L28) |
| `options:Close()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L33) |
| `options:Open()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L34) |
| `options:Toggle()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L39) |
| `options:Destroy()` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/src/components/window/FeatureSettings.lua#L49) |

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
