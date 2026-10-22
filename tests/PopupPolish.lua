-- Live regression: restores the current preset/theme and removes its own test theme.
local d=assert(getgenv().WindUIForkDemo)
local p=d.Presets;local u=p.UIElements;local theme=d.CustomThemes
local n=0;local function check(v,m)n+=1;assert(v,'PopupPolish: '..m)end
local oldSort,oldReverse,oldView=p.Sort,p.SortReversed,p.View
local oldTheme=d.ThemeDropdown.Value;local oldCurrent=p.Current
local name='__popup_qa_'..os.time()
local function click(b)firesignal(b.MouseButton1Click);task.wait(.2)end
local function checkThemeFields(panel)
 local ui=panel.UIElements
 local field=ui.NameInput.UIElements.Input;local choice=ui.BaseInput.UIElements.Dropdown
 check(field~=nil,'name uses flat compact field')
 check(field.AbsoluteSize==choice.AbsoluteSize,'name and dropdown have matching dimensions')
 check(field.BackgroundColor3==choice.BackgroundColor3 and field.BackgroundTransparency==choice.BackgroundTransparency,'name and dropdown share surface')
 check(field:FindFirstChildOfClass('UICorner').CornerRadius==choice:FindFirstChildOfClass('UICorner').CornerRadius,'matching modest rounded corners')
 for _,element in ipairs({ui.NameInput,ui.BaseInput})do
  local icon=element.UIElements.RowIcon;local row=icon.Parent
  check(math.abs(icon.AbsolutePosition.Y+icon.AbsoluteSize.Y/2-row.AbsolutePosition.Y-row.AbsoluteSize.Y/2)<1,'row icon vertically centered')
 end
end
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
 checkThemeFields(panel)
 local a,z=ui.Confirm.AbsolutePosition,ui.Confirm.AbsoluteSize;local b,s=ui.Panel.AbsolutePosition,ui.Panel.AbsoluteSize
 check(a.X>=b.X and a.Y>=b.Y and a.X+z.X<=b.X+s.X and a.Y+z.Y<=b.Y+s.Y,'button fully inside panel')
 ui.NameInput:Set(name);click(ui.Confirm)
 check(theme.Entries[name]~=nil,'create saves custom theme')
 check(not panel.Opened,'create closes dialog')
 local decoded=game:GetService('HttpService'):JSONDecode(readfile(d.Window.Folder..'/custom-themes.json'))
 check(decoded.Themes[name]~=nil,'theme persisted to disk')
 d.Profile:Open();d.Profile.ThemeControl:Open();d.Profile.ThemeControl:Select('Dark');task.wait(.4)
 local record=d.Profile.UIElements.ThemeOptions[name]
 check(record.Settings.Position.X.Offset==-30 and not record.Check.Visible,'unselected gear occupies rightmost check slot')
 d.Profile.ThemeControl:Select(name);task.wait(.05)
 check(record.Settings.Position.X.Offset < -30 and record.Settings.Position.X.Offset > -55,'gear slides rather than jumps')
 task.wait(.3)
 check(record.Settings.Position.X.Offset==-55 and record.Check.Visible and record.Check.ImageLabel.ImageTransparency<.01,'selected gear moves left and check appears')
 check(record.Settings.AbsolutePosition.X+record.Settings.AbsoluteSize.X<=record.Check.AbsolutePosition.X,'gear and check never overlap at rest')
 d.Profile.ThemeControl:Select('Dark');task.wait(.4)
 check(record.Settings.Position.X.Offset==-30 and not record.Check.Visible,'deselect hides check and returns gear right')
 d.Profile.ThemeControl:Select(name);d.Profile.ThemeControl:Select('Dark');d.Profile.ThemeControl:Select(name);task.wait(.4)
 check(record.Settings.Position.X.Offset==-55 and record.Check.Visible and record.Check.ImageLabel.ImageTransparency<.01,'rapid selection ends with correct animation state')
 check(theme:OpenEditor(name),'new theme editor opens')
 task.wait(.4);checkThemeFields(theme.Editors[name])
 local edit=theme.Editors[name];local found
 check(theme.CreateRow.UIElements.ButtonSurface==nil and theme.Rows[name].UIElements.ButtonSurface==nil,'theme navigation retains plain rows without nested cards')
 for _,element in ipairs(edit.Sections[1].Elements)do
  if element.__type=='Button'then
   local surface=element.UIElements.ButtonSurface;local row=element.ButtonFrame.UIElements.Main
   check(surface~=nil and surface.BackgroundTransparency<.3,'theme action has soft visible fill')
   check(surface:FindFirstChildWhichIsA('UIStroke')==nil,'no outlined cards around buttons')
   check(surface.Size.Y.Offset==30,'button height matches compact controls')
   check(element.UIElements.ButtonIcon.Parent==surface,'action icon inside button')
   check(element.ButtonFrame.UIElements.Title.Parent==surface,'action label inside button')
   local color=surface.BackgroundColor3
   firesignal(row.MouseEnter);firesignal(row.MouseMoved,0,0);task.wait(.2)
   check(surface.BackgroundColor3==color,'no hover recoloring on action buttons')
   for _,node in ipairs(row:GetDescendants())do
    if node:IsA('UIGradient')and node.Name=='HoverGradient'then check(node.Parent.ImageTransparency==1,'no gradient glow on compact button')end
   end
  end
 end
 local inputService=game:GetService('UserInputService')
 local function press(node,userType)
  local at=node.AbsolutePosition+node.AbsoluteSize/2
  local event={Position=Vector3.new(at.X,at.Y,0),UserInputType=userType or Enum.UserInputType.MouseButton1,KeyCode=Enum.KeyCode.Unknown}
  firesignal(inputService.InputBegan,event,false);task.wait(.04);return event
 end
 local picker
 for _,element in ipairs(edit.Sections[3].Elements)do if element.__type=='Colorpicker'then picker=element;break end end
 check(picker~=nil,'theme editor exposes color controls')
 local palette=picker:Open();task.wait(.25)
 check(edit.Opened and palette.Opened,'opening child palette keeps editor open')
 check(palette.UIElements.Panel.ZIndex>edit.UIElements.Panel.ZIndex,'palette above editor')
 local dragEvent=press(palette.UIElements.SV)
 check(edit.Opened,'map click does not dismiss editor')
 firesignal(palette.UIElements.SV.InputBegan,dragEvent)
 local move={Position=dragEvent.Position+Vector3.new(16,-12,0),UserInputType=Enum.UserInputType.MouseMovement,KeyCode=Enum.KeyCode.Unknown}
 firesignal(inputService.InputChanged,move,false);firesignal(inputService.InputEnded,dragEvent,false);task.wait(.1)
 check(edit.Opened and palette.Opened,'live color drag keeps both windows open')
 press(palette.UIElements.Hue);press(palette.UIElements.Alpha)
 check(edit.Opened,'hue and alpha clicks stay inside editor interaction')
 press(palette.UIElements.ColorText);palette.UIElements.ColorText.Text='#4488CCFF';firesignal(palette.UIElements.ColorText.FocusLost,true);task.wait(.1)
 check(edit.Opened and palette.Opened,'HEX commit keeps editor open')
 press(palette.UIElements.Opacity);palette.UIElements.Opacity.Text='75%';firesignal(palette.UIElements.Opacity.FocusLost,true);task.wait(.1)
 check(edit.Opened and math.abs(picker.Transparency-.25)<.001,'opacity edit commits without dismissing editor')
 palette:ShowFormats(true);press(palette.UIElements.Formats:FindFirstChild('RGB'))
 click(palette.UIElements.Formats:FindFirstChild('RGB'))
 check(edit.Opened and palette.Opened and palette.Format=='RGB','format submenu belongs to editor')
 local chip=palette.UIElements.Stops:FindFirstChild('Stop_1');palette:ShowActions(true,chip)
 press(palette.UIElements.Copy);palette:ShowActions(false)
 check(edit.Opened and palette.Opened,'color action submenu belongs to editor')
 firesignal(inputService.InputBegan,{UserInputType=Enum.UserInputType.Keyboard,KeyCode=Enum.KeyCode.Escape},false);task.wait(.2)
 check(edit.Opened and not palette.Opened,'Escape closes child palette, not editor')
 palette=picker:Open();task.wait(.2);edit:Close()
 check(not edit.Opened and not palette.Opened,'closing editor also closes its palette')
 edit:Open();task.wait(.2)
 local base=edit.UIElements.BaseInput;base:Open();task.wait(.2)
 press(base.UIElements.MenuCanvas:FindFirstChild('Options'):FindFirstChildWhichIsA('TextButton'))
 check(edit.Opened,'base dropdown option click preserves editor')
 firesignal(inputService.InputBegan,{UserInputType=Enum.UserInputType.Keyboard,KeyCode=Enum.KeyCode.Escape},false);task.wait(.2)
 check(edit.Opened and not base.Opened,'Escape closes only base dropdown')
 firesignal(inputService.InputBegan,{UserInputType=Enum.UserInputType.Keyboard,KeyCode=Enum.KeyCode.Escape},false);task.wait(.2)
 check(not edit.Opened,'next Escape closes editor normally')
 edit:Open();task.wait(.2)
 for _,element in ipairs(edit.Sections[1].Elements)do if element.Title=='Save and overwrite'then element.Callback();break end end
 check(edit.Opened,'save and overwrite keeps editor open for continued editing')
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
