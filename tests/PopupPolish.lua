-- Live regression: restores the current preset/theme and removes its own test theme.
local d=assert(getgenv().WindUIForkDemo)
local p=d.Presets;local u=p.UIElements;local theme=d.CustomThemes
local n=0;local function check(v,m)n+=1;assert(v,'PopupPolish: '..m)end
local oldSort,oldReverse,oldView=p.Sort,p.SortReversed,p.View
local oldTheme=d.ThemeDropdown.Value;local oldCurrent=p.Current
local name='__popup_qa_'..os.time()
local function click(b)firesignal(b.MouseButton1Click);task.wait(.2)end
local function run()
 d.Player:Select();if not p.Opened then p:Toggle()end;task.wait(.3)
 for label,item in pairs(p.RowCache)do
  check(item.Row.BackgroundTransparency==1,'no permanent row fill')
  check(item.CurrentMark.Visible==(label==p.Current),'only current preset has a check')
  firesignal(item.Row.MouseEnter);task.wait(.16);check(item.Row.BackgroundTransparency<1,'row hover')
  firesignal(item.Row.MouseLeave);task.wait(.16);check(item.Row.BackgroundTransparency==1,'hover clears on current row too')
 end
 p.View='Presets';p:SetSort('Created',false)
 click(u.Recent);check(p.View=='Recent'and p.Sort=='Modified','recent sorts by modification')
 local all=u.Panel:FindFirstChildWhichIsA('TextButton')
 check(all:GetAttribute('IdleTransparency')==1,'all not highlighted in recent')
 firesignal(u.Recent.MouseLeave);task.wait(.2);check(u.Recent.BackgroundTransparency<1,'recent state survives mouse leave')
 click(u.Recent);check(p.View=='Presets'and p.Sort=='Created','recent toggles off')
 check(p.Current==oldCurrent,'sorting does not load another preset')
 p:Toggle();d.Themes:Select();theme:OpenCreate();task.wait(.4)
 local panel=theme.CreatePanel;local ui=panel.UIElements
 check(panel.Sections[1].Title==false,'no redundant Theme heading')
 check(ui.Panel.Size.X.Offset==344 and ui.Panel.Size.Y.Offset<=220,'compact create dialog')
 check(not ui.Confirm:IsDescendantOf(panel.Sections[1].UIElements.Card),'action outside clipped card')
 local a,z=ui.Confirm.AbsolutePosition,ui.Confirm.AbsoluteSize;local b,s=ui.Panel.AbsolutePosition,ui.Panel.AbsoluteSize
 check(a.X>=b.X and a.Y>=b.Y and a.X+z.X<=b.X+s.X and a.Y+z.Y<=b.Y+s.Y,'button fully inside panel')
 ui.NameInput:Set(name);click(ui.Confirm)
 check(theme.Entries[name]~=nil,'create saves custom theme')
 check(not panel.Opened,'create closes dialog')
 local decoded=game:GetService('HttpService'):JSONDecode(readfile(d.Window.Folder..'/custom-themes.json'))
 check(decoded.Themes[name]~=nil,'theme persisted to disk')
 check(theme:OpenEditor(name),'new theme editor opens')
 local edit=theme.Editors[name];local found
 for _,element in ipairs(edit.Sections[1].Elements)do if element.Title=='Delete theme'then element.Callback();found=true;break end end
 check(found and not theme.Entries[name],'test theme removed')
end
local ok,err=pcall(run)
if theme.Entries[name]then
 local edit=theme.Editors[name]
 for _,element in ipairs(edit.Sections[1].Elements)do if element.Title=='Delete theme'then element.Callback();break end end
end
d.ThemeDropdown:Select(oldTheme);p.Sort=oldSort;p.SortReversed=oldReverse;p.View=oldView;p:Refresh()
theme.CreatePanel:Close();if p.Opened then p:Toggle()end
assert(ok,err)
return 'PopupPolish: '..n..' assertions passed'
