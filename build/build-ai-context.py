"""Build the portable, self-contained AI handoff and observed source-option index."""
from pathlib import Path
import re
R=Path(__file__).resolve().parent.parent
D=R/'docs/remake-2'
base='https://github.com/123ads213/WindUI-Remake-2/blob/main/'
# These keys are supplied by the element factory, never requested from application code.
injected={'Parent','ParentType','ParentTable','Window','WindUI','Tab','Index','GlobalIndex','UIScale','ElementsModule'}
files=[('Window','src/components/window/Init.lua'),('Columns / IconTabs','src/components/window/RemakeLayout.lua'),('Settings','src/components/window/FeatureSettings.lua'),('Profile','src/components/window/Profile.lua'),('HUD','src/components/window/HUD.lua'),('Presets','src/components/window/PresetUI.lua'),('Custom themes','src/components/window/ThemeEditor.lua'),('Cursor','src/components/window/Cursor.lua'),('Descriptions / hotkeys','src/components/window/FeatureUI.lua')]
files += [(p.stem,'src/elements/'+p.name) for p in sorted((R/'src/elements').glob('*.lua')) if p.stem!='Init']
out=['# Индекс полей конфигурации из исходников','',
'Автоматически извлечены точные обращения `Config.X`, `config.X`, `cfg.X` из текущего кода. Это **указатель для чтения исходника**, не исчерпывающая спецификация типов/defaults и не гарантия, что внутренний ключ поддерживается для каждого контейнера. Используйте API/MIGRATION/ADVANCED для контрактов и примеров. При неоднозначности читайте указанное определение. Вспомогательные locals с именем cfg тоже могут относиться к вложенной конфигурации.','',
'Внутренние поля, которые фабрика заполняет сама, исключены: '+', '.join('`'+k+'`'for k in sorted(injected))+'. Не передавайте их из приложения.','']
for label,path in files:
 text=(R/path).read_text()
 found={}
 for m in re.finditer(r'\b(?:Config|config|cfg)\.([A-Za-z_]\w*)',text):
  if m[1] not in injected:found.setdefault(m[1],text.count('\n',0,m.start())+1)
 if not found:continue
 out+=['## '+label,'','Исходник: ['+path+']('+base+path+')','', '| Поле | Первое обращение |','| --- | --- |']
 for key,line in sorted(found.items()):out+=['| `'+key+'` | [source]('+base+path+'#L'+str(line)+') |']
 out+=['']
text=(R/'src/themes/Init.lua').read_text();fallback=(R/'src/themes/Fallbacks.lua').read_text()
themes=set(re.findall(r'\bName\s*=\s*"([^"]+)"',text))
keys=set(re.findall(r'\b([A-Za-z_]\w*)\s*=(?!=)',text+fallback))-themes-{'Name','baseColor'}
out+=['## Theme properties и fallbacks','',
'Ключи берутся из `src/themes/Init.lua` и `src/themes/Fallbacks.lua`. Значения бывают Color3, ссылки на другие свойства, числа transparency или специальные флаги (например CleanShapes). Не все свойства имеют UI-редактор. Прозрачность Roblox: 0 = непрозрачно, 1 = невидимо.','',
'['+'Палитры'+']('+base+'src/themes/Init.lua) · [Fallbacks]('+base+'src/themes/Fallbacks.lua)','']
out+=['- `'+key+'`' for key in sorted(keys)]
(D/'SOURCE-CONFIG.md').write_text('\n'.join(out)+'\n')
parts=[('MIGRATION.md','Миграция'),('INSTALL.md','Установка'),('API.md','API и интеграция'),('ADVANCED.md','Темы, курсор, редактор, HUD'),('RECIPES.md','Рецепты'),('COMPOSITE.md','Составные элементы'),('REFERENCE.md','Справочник методов'),('SOURCE-CONFIG.md','Индекс полей'),('QA.md','Проверки и ограничения')]
merged=['# WindUI Remake 2 — полный контекст для ИИ','',
'**Назначение:** перенос существующего скрипта с оригинального WindUI на этот форк без потери функций. Этот один файл включает документы целиком; отдельный доступ к сайту для чтения включённых разделов не требуется. Для полной проверки передайте также старый скрипт и исходники библиотеки.','',
'Репозиторий: https://github.com/123ads213/WindUI-Remake-2','',
'Библиотека: https://raw.githubusercontent.com/123ads213/WindUI-Remake-2/main/dist/main.lua','',
'Сайт: https://123ads213.github.io/WindUI-Remake-2/','',
'Сборка документации: `python build/build-reference.py && python build/build-ai-context.py`. Исходники имеют приоритет при расхождении. Это не обещание совместимости произвольного старого JSON или буквального переноса C++ renderer. Оригинальный WindUI: Footagesus, MIT.','',
'## Состав','']
merged += [f'{i}. {label} (`{name}`)'for i,(name,label)in enumerate(parts,1)]
for name,label in parts:
 merged += ['','---','',f'<!-- BEGIN {name} -->','', (D/name).read_text().strip(),'',f'<!-- END {name} -->']
(D/'AI-CONTEXT.md').write_text('\n'.join(merged)+'\n')
print('Built AI-CONTEXT.md:',len(parts),'complete documents;',len(keys),'theme keys')
