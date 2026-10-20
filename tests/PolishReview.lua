-- Live regression for the second screenshot review. No existing preset file is changed.
local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local f=d.Window.FeatureUI;local n=0
local function check(v,m)n+=1;assert(v,'PolishReview: '..m)end
local vim=game:GetService('VirtualInputManager');local input=game:GetService('UserInputService');local oldMouse=input:GetMouseLocation();local sort,reverse=p.Sort,p.SortReversed
local function move(point)vim:SendMouseMoveEvent(point.X,point.Y,game)end
local function rawPoint(gui,offset)return gui.AbsolutePosition+(offset or gui.AbsoluteSize/2)-d.Library.ScreenGui.AbsolutePosition end
local function run()
 p:SetSort('Name',false);local before=table.clone(p.Order);firesignal(p.SortOptions[3].Button.MouseButton1Click);task.wait(.3)
 check(p.SortReversed,'active criterion reverses on click');check(p.Order[1]~=before[1],'real letter-name preset rows reverse before numeric names');check(p.RowCache[p.Order[1]].Slot.Position.Y.Offset==0,'top row actually moves to y=0')
 check(p.SortOptions[3].Button.Label.Text=='Alphabetical Z–A','direction is visible in menu')
 firesignal(p.SortOptions[3].Button.MouseButton1Click);task.wait(.3);check(not p.SortReversed and p.Order[1]==before[1],'second click restores A-Z');check(table.find(p.Order,'Default')<table.find(p.Order,'231')and table.find(p.Order,'Last')<table.find(p.Order,'231'),'Default and Last both precede 231')
 check(table.find(p.Order,'Default')<table.find(p.Order,'231'),'letter names stay before numeric names in reverse')
 check(not p.UIElements.ErrorMessage.Visible and p.UIElements.ErrorMessage.Text=='','sort/count footer removed')
 local save=p.UIElements.Save;check(save.BackgroundTransparency==1,'quick save original styling restored');check(save:FindFirstChildOfClass('UIStroke')==nil,'quick save added border removed')
 firesignal(save.MouseEnter);task.wait(.2);firesignal(save.MouseLeave);task.wait(.2);check(save.BackgroundTransparency==1,'quick save original hover restored')
 check(d.Profile.UIElements.MenuBindPill==nil,'menu-bind added keycap decoration removed')
 firesignal(d.Profile.UIElements.MenuBindButton.MouseButton1Click);check(d.Window.CapturingMenuBind,'original menu-bind row still captures');d.Profile:CancelMenuBind()
 local style=d.Profile.UIElements.StyleButton;local value=style.Value;check(style.AbsoluteSize.X-(value.Position.X.Offset+value.Size.X.Offset)<40,'theme value close to arrow')
 check(d.Showcase.Media==nil,'Media & code demo removed')
 for _,e in ipairs(d.General.Elements)do check(e.Title~='Nested tabs','no Nested tabs plate')end
 for _,e in ipairs(d.Showcase.HUD.Elements)do check(e.Title~='Try the HUD','no Try the HUD plate')end
 for _,e in ipairs(d.Showcase.Layout.Elements)do if e.__type=='Group'or e.__type=='HStack'or e.__type=='VStack'then
  check(e.ElementFrame:FindFirstChildOfClass('UICorner').CornerRadius.Offset==12,'consistent container corner radius')
  for _,child in ipairs(e.Elements)do if child.ElementFrame and child.ElementFrame:IsA('ImageButton')then check(child.ElementFrame.Image=='rbxassetid://82909646051652','joined child uses square silhouette, not asymmetric half capsule')end end
 end end
 d.Player:Select();d.Pages:Select('enemies');d.PlayerOptions:Open();task.wait(.3)
 check(d.PlayerOptions.UIElements.Panel.Size.X.Offset==336,'compact settings width');check(d.PlayerOptions.UIElements.Panel.Size.Y.Offset<450,'compact settings height')
 check(d.PopupDistance.ElementFrame.Size.Y.Offset==38,'compact settings row height');d.PlayerOptions:Close();task.wait(.25)
 f:CloseAll();f:HideDescription();move(rawPoint(d.ShowPlayers.ElementFrame,Vector2.new(45,25)));task.wait(.7)
 local ui=f.UIElements;check(ui.Tooltip.Visible and ui.TooltipMore.Visible,'real pointer hover opens description')
 local oldHeight=ui.Tooltip.AbsoluteSize.Y;move(rawPoint(ui.TooltipMore));task.wait(.8)
 check(ui.Tooltip.Visible and ui.Tooltip.GroupTransparency==0,'real pointer hovering ellipsis keeps description open')
 check(ui.Tooltip.AbsoluteSize.X>330,'real pointer expands description');check(ui.Tooltip.AbsoluteSize.Y>=oldHeight,'expansion never shrinks beneath pointer')
 move(rawPoint(ui.Tooltip,Vector2.new(32,55)));task.wait(.7);check(ui.Tooltip.Visible and ui.Tooltip.GroupTransparency==0,'description readable with pointer over text')
 move(Vector2.new(100,100));task.wait(.7);check(not ui.Tooltip.Visible,'description closes after leaving')
end
local ok,err=pcall(run)
f:HideDescription();f:CloseAll();d.Profile:CancelMenuBind();d.PlayerOptions:Close();p:SetSort(sort,reverse);d.Player:Select();move(oldMouse)
assert(ok,err);return{passed=n}
