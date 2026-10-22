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
 check(math.abs(all:GetAttribute('IdleTransparency')-.15)<.001,'Presets header retains permanent background in recent')
 firesignal(u.Recent.MouseLeave);task.wait(.2);check(u.Recent.BackgroundTransparency<1,'recent state survives mouse leave')
 for i=1,3 do
  firesignal(all.MouseLeave);firesignal(u.Recent.MouseEnter);click(u.Recent);firesignal(u.Recent.MouseLeave);task.wait(.2)
  check(p.View=='Recent'and p.Sort=='Modified','repeated click keeps recent selected')
  check(math.abs(all.BackgroundTransparency-.15)<.001 and math.abs(u.Recent.BackgroundTransparency-.15)<.001,'Presets background remains after right-button click and hover')
 end
 firesignal(u.Recent.MouseLeave);firesignal(all.MouseEnter);click(all);firesignal(all.MouseLeave);task.wait(.2)
 check(p.View=='Presets'and p.Sort=='Created','only Presets button returns to Presets')
 check(math.abs(all.BackgroundTransparency-.15)<.001 and u.Recent.BackgroundTransparency==1,'no stale hover tween overrides selection')
 check(p.Current==oldCurrent,'sorting does not load another preset')
 p:Toggle();d.Themes:Select();d.Profile:Open();d.Profile.ThemeControl:Open();d.Profile.ThemeControl:Select('Custom');task.wait(.4)
 local panel=theme.CreatePanel;local ui=panel.UIElements
 check(panel.Sections[1].Title==false,'no redundant Theme heading')
 check(ui.Panel.Size.X.Offset==360 and ui.Panel.Size.Y.Offset<=200,'compact create dialog')
 local card=panel.Sections[1].UIElements.Card
 local gap=(ui.Confirm.AbsolutePosition.Y-card.AbsolutePosition.Y-card.AbsoluteSize.Y)/d.Library.UIScaleObj.Scale
 check(gap>=8 and gap<=16,'actions close to fields without overlap')
 local screen=d.Library.ScreenGui
 local center=ui.Panel.AbsolutePosition+ui.Panel.AbsoluteSize/2
 local target=screen.AbsolutePosition+screen.AbsoluteSize/2
 check((center-target).Magnitude<2,'theme dialog centered in screen')
 check(not d.Profile.Opened,'profile closed behind dialog')
 check(ui.Cancel.Size==ui.Confirm.Size and ui.Confirm.Size.Y.Offset==36,'equal action button sizes')
 for _,b in ipairs({ui.Cancel,ui.Confirm})do
  local idle=b.BackgroundTransparency;firesignal(b.MouseEnter);task.wait(.2)
  check(b.BackgroundTransparency==idle,'no hover fill on dialog actions')
  firesignal(b.MouseLeave);task.wait(.2);check(b.BackgroundTransparency==idle,'no mouse-leave change')
  check(b:FindFirstChildWhichIsA('ImageLabel',true)~=nil,'action has icon')
 end
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
