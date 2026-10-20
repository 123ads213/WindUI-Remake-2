-- Run in a client after RemakeExample.lua; no real user preset is deleted.
local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local n=0
local function check(value,message)n+=1;assert(value,'R2: '..message)end
local name='__qa_'..tostring(os.time());local renamed=name..'_renamed';local imported=name..'_imported'
local current=p.Current
local previous={advanced=d.Advanced.Value,dependent=d.Dependent.Value.Default,distance=d.Big.Value.Default,theme=d.ThemeDropdown.Value}
local function run()
 check(#d.Window.AllElements>=26,'all elements registered across columns')
 check(d.Profile and d.HUD and d.Balance and d.Collection and d.SolidColor and d.GradientColor,'all first-remake features retained')
 local top=d.Window.UIElements.Main.Main.Topbar;local bar=d.Presets.UIElements.Toolbar;check(bar.AbsolutePosition.Y>=top.AbsolutePosition.Y and bar.AbsolutePosition.Y+bar.AbsoluteSize.Y<=top.AbsolutePosition.Y+top.AbsoluteSize.Y,'preset trigger inside original header')
 check(d.Columns.UIElements.Right.Position.X.Scale==.5,'wide two-column layout')
 d.Advanced:Set(true);d.Dependent:Set(62);d.ThemeDropdown:Select('Ocean');d.Big:Set(840)
 task.wait(.5);check(not d.DependencyGroup.Hidden,'dependency revealed');check(d.DependencyGroup.VisibilityFrame.Size.Y.Offset>100,'expanded height')
 check(p:Create(name),'create');check(isfile(d.Window.ConfigManager.Path..name..'.json'),'file exists')
 d.Advanced:Set(false);d.Dependent:Set(3);d.ThemeDropdown:Select('Dark');d.Big:Set(100)
 task.wait(.5);check(d.DependencyGroup.Hidden,'dependency hidden');check(d.DependencyGroup.VisibilityFrame.Size.Y.Offset<1,'height collapsed')
 check(p:Load(name),'load');task.wait(.5)
 check(d.Advanced.Value==true,'toggle roundtrip');check(d.Dependent.Value.Default==62,'hidden value roundtrip');check(d.ThemeDropdown.Value=='Ocean','choice roundtrip');check(d.Big.Value.Default==840,'slider roundtrip');check(not d.DependencyGroup.Hidden,'dependency follows config')
 local json=p:Export(name);check(type(json)=='string'and #json>50,'export')
 check(p:Import(imported,json),'import');check(p:Load(imported),'import loads');check(p:Rename(imported,renamed),'rename');check(not isfile(d.Window.ConfigManager.Path..imported..'.json'),'old name removed')
 check(not p:Import('../escape',json),'path traversal rejected');check(not p:Import(name,json),'overwrite rejected');check(not p:Import(name..'_bad','not json'),'malformed JSON rejected');check(not p:Import(name..'_bad','{"__elements":{"x":{"__type":"Toggle","value":"bad"}}}'),'invalid value rejected')
 d.Themes:Select();task.wait(.3);d.ThemeDropdown:Open();task.wait(.2);check(d.ThemeDropdown.Opened,'dropdown opens');check(#d.ThemeDropdown.Tabs==7,'options rendered')
 local checked=0;for _,r in ipairs(d.ThemeDropdown.Tabs)do if r.Check.Visible then checked+=1;check(r.Value=='Ocean','right selected option')end end;check(checked==1,'one checkmark');d.ThemeDropdown:Close()
 d.Pages:Select('teammates');check(d.Pages.Selected==2,'icon page switch');d.Pages:Select('enemies');check(d.ThemeDropdown.Value=='Ocean','subtab values preserved')
 d.Window:SetSize(UDim2.fromOffset(700,600));task.wait(.5);check(d.Columns.UIElements.Right.Position.X.Scale==0,'narrow layout stacked');d.Window:SetSize(UDim2.fromOffset(1000,650));task.wait(.5);check(d.Columns.UIElements.Right.Position.X.Scale==.5,'wide layout restored')
end
local ok,err=pcall(run)
for _,v in ipairs({name,renamed,imported})do if isfile(d.Window.ConfigManager.Path..v..'.json')then p:Delete(v)end end
if current then p:Load(current)end
d.Advanced:Set(previous.advanced);d.Dependent:Set(previous.dependent);d.Big:Set(previous.distance);d.ThemeDropdown:Select(previous.theme)
d.Window:SetSize(UDim2.fromOffset(1000,650));d.Pages:Select('enemies');d.Player:Select()
assert(ok,err);return {passed=n,preset=p.Current}
