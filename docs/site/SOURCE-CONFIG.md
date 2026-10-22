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
