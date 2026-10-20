local d=assert(getgenv().WindUIForkDemo)
local input=game:GetService('UserInputService');local vim=game:GetService('VirtualInputManager')
local s=d.Big;local old=s:Get();local oldTheme=d.ThemeDropdown.Value;local oldBudget=d.Billion:Get();local n=0
local function check(v,m)n+=1;assert(v,'SliderPolish: '..m)end
local function key(code,hold)
 vim:SendKeyEvent(true,code,false,game);task.wait(hold or .05);vim:SendKeyEvent(false,code,false,game);task.wait(.04)
end
local function run()
 d.Window.FeatureUI:CloseAll();d.PlayerOptions:Close();if pcall(function()return d.Presets.Opened end)and d.Presets.Opened then d.Presets:Toggle()end
 local focused=input:GetFocusedTextBox();if focused then focused:ReleaseFocus()end
 d.Player:Select();task.wait(.25)
 s:Set(500000);local track=s.UIElements.SliderIcon
 vim:SendMouseMoveEvent(track.AbsolutePosition.X+track.AbsoluteSize.X*.5-d.Library.ScreenGui.AbsolutePosition.X,track.AbsolutePosition.Y+2-d.Library.ScreenGui.AbsolutePosition.Y,game);task.wait(.1)
 key(Enum.KeyCode.Right);check(s:Get()==500001,'right adds one configured step')
 key(Enum.KeyCode.Left);check(s:Get()==500000,'left subtracts one step')
 key(Enum.KeyCode.Right,.55);check(s:Get()>500001,'held key repeats')
 s:Set(s.Value.Max);key(Enum.KeyCode.Right);check(s:Get()==s.Value.Max,'keyboard clamps maximum')
 s:Set(s.Value.Min);key(Enum.KeyCode.Left);check(s:Get()==s.Value.Min,'keyboard clamps minimum')
 s:Lock();local saved=s:Get();key(Enum.KeyCode.Right);check(s:Get()==saved,'locked ignores arrows');s:Unlock()
 vim:SendMouseMoveEvent(100,100,game);task.wait(.1);key(Enum.KeyCode.Right);check(s:Get()==saved,'unhovered ignores arrows')
 vim:SendMouseMoveEvent(track.AbsolutePosition.X+track.AbsoluteSize.X*.5-d.Library.ScreenGui.AbsolutePosition.X,track.AbsolutePosition.Y+2-d.Library.ScreenGui.AbsolutePosition.Y,game);task.wait(.1)
 local box=s.UIElements.ValueInput;box:CaptureFocus();task.wait(.1);key(Enum.KeyCode.Right);check(s:Get()==saved,'editing text does not nudge slider');box:ReleaseFocus();task.wait(.2)
 check(box.Size.X.Offset>=72,'enough display width for compact values')
 s:Set(413460000);task.wait(.2);check(box.Text=='413.46m','reported value formats without losing digits')
 check(box.TextBounds.X<box.AbsoluteSize.X-6,'formatted value fits field')
 local b=d.Billion;local edit=b.UIElements.ValueInput;b:Set(1250000000);task.wait(.2)
 local start=edit.Size.X.Offset;firesignal(edit.Focused);task.wait(.04)
 check(edit.Size.X.Offset>start,'focus expands value editor gradually')
 task.wait(.2);check(edit.Size.X.Offset>start,'focused full number has wider field')
 check(edit.AbsolutePosition.X+edit.AbsoluteSize.X<=b.ElementFrame.AbsolutePosition.X+b.ElementFrame.AbsoluteSize.X,'expanded field stays in row')
 firesignal(edit.FocusLost,true);task.wait(.2);check(math.abs(edit.Size.X.Offset-start)<.1,'blur returns field width')
 s:Set(500000);task.wait(.2)
 local x,w,y=track.AbsolutePosition.X,track.AbsoluteSize.X,track.AbsolutePosition.Y
 local touch={UserInputType=Enum.UserInputType.Touch,Position=Vector3.new(x+w*.4,y,0)}
 firesignal(s.UIElements.SliderContainer.InputBegan,touch);task.wait(.04)
 local popup=s.UIElements.HoverValue
 check(popup:IsA('CanvasGroup') and popup.GroupTransparency>0 and popup.GroupTransparency<1,'drag popup fades in')
 task.wait(.18);check(popup.GroupTransparency<.01,'popup finishes opening')
 firesignal(input.InputEnded,touch);task.wait(.04);check(popup.Visible and popup.GroupTransparency>0,'popup fades out')
 task.wait(.18);check(not popup.Visible,'popup disappears after fade')
 check(s.ElementFrame.Size.Y.Offset==50 and s.SliderFrame.UIElements.Title.TextSize==15,'larger readable row and label')
 local pages=d.Pages.Pages
 check(pages[1].Button.BackgroundColor3~=track.Frame.ImageColor3,'subtab surface is neutral, not slider blue')
 for _,theme in ipairs({'Light','Dark'})do
  d.ThemeDropdown:Select(theme);task.wait(.3)
  check(box.BackgroundColor3~=Color3.new(0,0,0),'value surface is not pure black')
 end
end
local ok,err=pcall(run)
s:Unlock();s.UIElements.ValueInput:ReleaseFocus();s:Set(old);d.Billion:Set(oldBudget);d.ThemeDropdown:Select(oldTheme)
vim:SendMouseMoveEvent(100,100,game);d.Player:Select()
assert(ok,err);return {passed=n}
