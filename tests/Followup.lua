local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local n=0
local function check(v,m)n+=1;assert(v,'Followup: '..m)end
local names={'__sort_a_'..os.time(),'__sort_z_'..os.time()};local prior=p.Current;local oldSort=p.Sort
local input=game:GetService('UserInputService');local Http=game:GetService('HttpService')
local function run()
 check(d.AntiAFK.Value and getgenv().__SiriusAntiAFKEnabled and getgenv().__SiriusIdleConnection.Connected,'Anti-AFK enabled with one idle connection')
 local types={};for _,v in ipairs(d.Window.AllElements)do types[v.__type]=true end
 for _,kind in ipairs({'Toggle','Slider','Input','Button','Dropdown','Colorpicker','ProgressBar','Paragraph','Section','Divider','Space','Group','HStack','VStack','Viewport','Image','Code'})do check(types[kind],'showcase includes '..kind)end
 local lab=d.Showcase;lab.Choices:Select();lab.Multi:Select({'Fourth option','First option'});task.wait(.3)
 check(lab.Multi.UIElements.Display.Text=='First option, Fourth option','preview follows configured option order')
 check(lab.Multi.UIElements.Display.TextTruncate==Enum.TextTruncate.None,'no ellipsis')
 check(lab.Multi.UIElements.PreviewClip.ClipsDescendants,'preview clipped inside its control')
 check(#lab.Multi.UIElements.PreviewGradient.Transparency.Keypoints>=4,'long preview fades towards edge')
 lab.Single:Select('Second');task.wait(.04);check(lab.Single.UIElements.PreviewClip.GroupTransparency>0,'choice preview fades during update');task.wait(.25)
 check(lab.Single.UIElements.Display.Text=='Second'and lab.Single.UIElements.PreviewClip.GroupTransparency==0,'new preview fades in')
 for i,name in ipairs(names)do check(p:Create(name),'create own sort test preset');local path=d.Window.ConfigManager.Path..name..'.json';local data=Http:JSONDecode(readfile(path));data.__meta.created=i*100;data.__meta.modified=(3-i)*100;writefile(path,Http:JSONEncode(data))end
 p.Sort='Name';p:Refresh();task.wait(.3);local item=p.RowCache[names[2]];local before=item.Slot.Position.Y.Offset
 p.Sort='Created';p:Refresh();check(p.RowCache[names[2]]==item,'sorting preserves existing row instance')
 local index=table.find(p.Order,names[2]);check(index and table.find(p.Order,names[1])>index,'newest first changes list order')
 local target=(index-1)*54;task.wait(.04)
 check(math.abs(item.Slot.Position.Y.Offset-target)>1,'row has not jumped immediately to target')
 task.wait(.3);check(math.abs(item.Slot.Position.Y.Offset-target)<.1,'row settles at sorted position')
 d.Player:Select();d.Pages:Select('enemies');d.PlayerOptions:Open();task.wait(.3)
 local s=d.PopupDistance;local track=s.UIElements.SliderIcon;local x,y,w=track.AbsolutePosition.X,track.AbsolutePosition.Y,track.AbsoluteSize.X
 firesignal(s.UIElements.SliderContainer.InputBegan,{UserInputType=Enum.UserInputType.Touch,Position=Vector3.new(x+w*.67,y,0)});task.wait(.1)
 local hint=s.UIElements.HoverValue;local middle=hint.AbsolutePosition.X+hint.AbsoluteSize.X*.5
 check(hint.Visible,'popup slider shows live number')
 check(math.abs(middle-(x+w*.67))<3,'number centered above popup slider value, not clamped to main menu')
 s:Lock();s:Unlock();task.wait(.2);check(not hint.Visible,'drag feedback disappears')
 d.PlayerOptions:Close()
end
local ok,err=pcall(run)
d.PlayerOptions:Close()
for _,name in ipairs(names)do if isfile(d.Window.ConfigManager.Path..name..'.json')then p:Delete(name)end end
if prior then p:Load(prior)end;p.Sort=oldSort;p:Refresh();d.Player:Select()
assert(ok,err);return {passed=n}
