# Build a standalone launcher for this private repository. No PAT belongs in Roblox code.
from pathlib import Path
r=Path(__file__).resolve().parent.parent
lib=(r/'dist/main.lua').read_text();example=(r/'RemakeExample.lua').read_text()
assert ']=====]' not in lib
out="-- WindUI Remake 2; original WindUI by Footagesus (MIT).\nlocal env=getgenv and getgenv() or _G\nlocal f,err=loadstring([=====[\n"+lib+"\n]=====])\nassert(f,err);env.__WindUIForkInjectedLibrary=f()\nlocal window=(function()\n"+example+"\nend)();\nreturn env.WindUIForkDemo.Window\n"
(r/'dist/remake2.lua').write_text(out)
print('Built dist/remake2.lua')
