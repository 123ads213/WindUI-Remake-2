local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local ui=p.UIElements
local n=0;local function check(v,m)n+=1;assert(v,'FeatureSettings: '..m)end
local input=game:GetService('UserInputService');local Http=game:GetService('HttpService')
local name='__quick_save_'..tostring(os.time());local prior=p.Current
local old={distance=d.Big:Get(),opacity=d.PopupDistance:Get(),sort=p.Sort}
local function click(b)firesignal(b.MouseButton1Click);task.wait(.22)end
local function run()
 check(d.PlayerOptions and #d.PlayerOptions.Sections==2,'two independently grouped cards')
 local opt=d.PlayerOptions;local value=d.ShowPlayers.Value
 d.Player:Select();click(opt.UIElements.Button)
 check(opt.Opened and opt.UIElements.Panel.Visible,'ellipsis opens settings')
 check(d.ShowPlayers.Value==value,'ellipsis does not toggle parent feature')
 check(opt.UIElements.Title.Text=='Show players','feature name in popup header')
 check(opt.UIElements.Panel.Size.Y.Offset>250,'popup fits groups and controls')
 check(d.PopupDistance.UIElements.ValueInput:IsDescendantOf(opt.UIElements.Panel),'native slider inside popup')
 local a,z=opt.UIElements.Button.AbsolutePosition,opt.UIElements.Button.AbsoluteSize
 local panel=opt.UIElements.Panel
 check(math.abs(panel.AbsolutePosition.X-(a.X+z.X+8))<2,'popup uses nearby 8px gap')
 check(not d.PopupDistance.ElementFrame.RowDivider.Visible,'no trailing separator in final popup control')
 firesignal(input.InputBegan,{KeyCode=Enum.KeyCode.Escape,UserInputType=Enum.UserInputType.Keyboard},false);task.wait(.2)
 check(not opt.Opened and not panel.Visible,'Escape closes popup')
 click(opt.UIElements.Button)
 firesignal(input.InputBegan,{KeyCode=Enum.KeyCode.Unknown,UserInputType=Enum.UserInputType.MouseButton1,Position=Vector3.zero},false);task.wait(.03);firesignal(input.InputEnded,{KeyCode=Enum.KeyCode.Unknown,UserInputType=Enum.UserInputType.MouseButton1,Position=Vector3.zero},false);task.wait(.2)
 check(not opt.Opened,'outside click closes settings')
 p:Toggle();task.wait(.2);click(ui.Sort)
 check(ui.SortMenu.Visible,'sort popup opens')
 check(#p.SortOptions==3,'three requested sort orders')
 for _,choice in ipairs(p.SortOptions)do
  click(choice.Button)
  check(p.Sort==choice.Key,'sort choice applies '..choice.Key)
  local checked=0;for _,row in ipairs(p.SortOptions)do if row.Check.Visible then checked+=1 end end
  check(checked==1 and choice.Check.Visible,'active sort checkmark')
 end
 check(p:Create(name),'temporary preset created')
 local before=readfile(d.Window.ConfigManager.Path..name..'.json')
 d.Big:Set(1234);d.PopupDistance:Set(37);click(ui.Save)
 check(p.LastNotification and p.LastNotification.Success and p.LastNotification.Name==name,'quick save confirms preset name')
 check(before~=readfile(d.Window.ConfigManager.Path..name..'.json'),'quick save writes changed values')
 d.Big:Set(0);d.PopupDistance:Set(0);check(p:Load(name),'saved preset loads')
 check(d.Big:Get()==1234 and d.PopupDistance:Get()==37,'quick save roundtrips main and popup controls')
 firesignal(ui.Save.MouseEnter);task.wait(.38)
 local tip=ui.Tooltips['Save preset'];check(tip.Visible,'button name appears on hover')
 local gap=tip.AbsolutePosition.X-ui.Save.AbsolutePosition.X-ui.Save.AbsoluteSize.X
 check(math.abs(gap-8)<2,'tooltip stays 8px from button')
 firesignal(ui.Save.MouseLeave);task.wait(.2);check(not tip.Visible,'tooltip disappears on leave')
end
local ok,err=pcall(run)
d.PlayerOptions:Close()
if isfile(d.Window.ConfigManager.Path..name..'.json')then p:Delete(name)end
if prior then p:Load(prior)end
p.Sort=old.sort;p:Refresh();d.Big:Set(old.distance);d.PopupDistance:Set(old.opacity)
firesignal(input.InputBegan,{KeyCode=Enum.KeyCode.Escape,UserInputType=Enum.UserInputType.Keyboard},false)
d.Player:Select()
assert(ok,err);return {passed=n}
