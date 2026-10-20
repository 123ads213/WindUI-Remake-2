-- Run after RemakeExample.lua. Executor signal simulation is used only for UI tests.
local d=assert(getgenv().WindUIForkDemo);local w=d.Window;local ui=d.Presets.UIElements
local n=0;local function check(v,m)n+=1;assert(v,m)end
local input=game:GetService('UserInputService')
local function key(k)firesignal(input.InputBegan,{KeyCode=k,UserInputType=Enum.UserInputType.Keyboard},false);task.wait(.08)end
local function click(b)firesignal(b.MouseButton1Click);task.wait(.22)end
key(Enum.KeyCode.Escape)
check(w.Title=='Sirius'and w.Author=='Ui library'and w.Icon=='star','branding')
check(w.UIElements.SearchButton:IsDescendantOf(w.UIElements.Main.Main.Topbar.Right),'search in top-right header')
firesignal(ui.Trigger.MouseEnter);task.wait(.22);check(ui.Info.Visible,'information on hover')
d.Presets:Toggle();check(not ui.Info.Visible,'information hidden immediately by trigger click');task.wait(.22);check(ui.Panel.Visible,'presets shown')
local count=0;for _,v in ipairs(ui.Info:GetDescendants())do if v:IsA('ImageLabel')and v.Image~=''then count+=1 end end
check(count>=3,'metadata icons')
click(ui.Add);check(ui.Editor.Size.Y.Offset==148,'create form compact');check(not ui.Panel.Visible,'list not stacked under editor')
key(Enum.KeyCode.Escape);d.Presets:Toggle();task.wait(.2)
local row=ui.Rows:FindFirstChildWhichIsA('TextButton');check(row~=nil,'preset row')
local more;for _,b in ipairs(row:GetChildren())do if b:IsA('TextButton')and b.Position.X.Offset==220 then more=b end end
click(assert(more));local actions=w.UIElements.Main.Main:FindFirstChild('PresetActions')
check(actions.Size.Y.Offset==132,'compact actions')
for _,b in ipairs(actions:GetChildren())do if b:IsA('TextButton')and b:FindFirstChild('Label')and b.Label.Text=='Rename'then click(b);break end end
check(ui.Editor.Visible and ui.Editor.Size.Y.Offset==148,'rename compact')
key(Enum.KeyCode.Escape)
d.Profile:Open();task.wait(.25)
check(d.Profile.UIElements.MenuBindButton.Position.Y.Offset<d.Profile.UIElements.UnloadButton.Position.Y.Offset,'bind above unload')
local old=w.ToggleKey;local closed=w.Closed
d.Profile:BeginMenuBind();key(Enum.KeyCode.F8);check(w.ToggleKey==Enum.KeyCode.F8 and w.Closed==closed,'capture without toggling')
d.Profile:BeginMenuBind();key(Enum.KeyCode.Escape);check(w.ToggleKey==Enum.KeyCode.F8 and d.Profile.Opened,'escape cancels capture only')
d.Profile:BeginMenuBind();key(Enum.KeyCode.Backspace);check(w.ToggleKey==nil,'clear menu bind')
w:SetToggleKey(old);d.Profile:CancelMenuBind();d.Profile:Close()
key(old);task.wait(.4);check(w.Closed~=closed,'menu key toggles');key(old);task.wait(.4);check(w.Closed==closed,'menu key reopens')
return {passed=n}
