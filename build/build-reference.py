"""Refresh exact method signatures/source links without inventing APIs."""
from pathlib import Path
import re
R=Path(__file__).resolve().parent.parent
p=R/'docs/remake-2/REFERENCE.md';existing=p.read_text()
header=existing.split('## WindUI\n')[0];footer='## Свойства и стабильные идентификаторы'+existing.split('## Свойства и стабильные идентификаторы',1)[1]
groups=[('WindUI','src/Init.lua','WindUI','WindUI'),('Window','src/components/window/Init.lua','Window','Window'),('Tab','src/components/window/Tab.lua','Tab','Tab'),('Layout: columns and icon tabs','src/components/window/RemakeLayout.lua','(?:tab|col|group|controller|p)',None),('Profile','src/components/window/Profile.lua','self','profile'),('HUD','src/components/window/HUD.lua','self','hud'),('Presets','src/components/window/PresetUI.lua','self','presets'),('Feature settings','src/components/window/FeatureSettings.lua','self','options'),('Common element methods','src/elements/Init.lua','content','element'),('Visibility','src/components/window/Visibility.lua','obj','element'),('Hotkeys and descriptions','src/components/window/FeatureUI.lua','content','element')]
for name in ['Compound','PlayerPreview','Toggle','Slider','ProgressBar','Input','Button','CompactDropdown','InlineDropdown','Colorpicker','Code','Image','Viewport']:
 groups.append((name,'src/elements/'+name+'.lua','(?:'+name+'|self|obj|Code|Image|Viewport)',name[0].lower()+name[1:]))
text=header;total=0
for title,file,scope,alias in groups:
 src=(R/file).read_text();items={}
 for m in re.finditer(r'function\s+('+scope+r')([:.])([A-Za-z_]\w*)\s*\(([^)\n]*)\)',src):
  if m[3]in ['New','Init','Display','Render','UpdateMetrics']or m[3].startswith('_'):continue
  signature=(alias or m[1])+m[2]+m[3]+'('+m[4]+')';items[signature]=src.count('\n',0,m.start())+1
 if not items:continue
 text+='## '+title+'\n\n| Метод | Исходник |\n| --- | --- |\n'
 for sig,line in items.items():text+='| `'+sig+'` | [source](https://github.com/123ads213/WindUI-Remake-2/blob/main/'+file+'#L'+str(line)+') |\n'
 total+=len(items);text+='\n'
p.write_text(text+footer)
print('Indexed',total,'method definitions')
