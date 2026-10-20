local d=assert(getgenv().WindUIForkDemo)
local n=0;local function check(v,m)n+=1;assert(v,'InlineSettings: '..m)end
local p=d.Presets;local choice=d.PopupStyle;local prior=p.Current;local old=choice.Value
local name='__inline_'..tostring(os.time())
local function run()
 d.PlayerOptions:Close();d.Player:Select();d.PlayerOptions:Open();task.wait(.25)
 for _,g in ipairs(d.PlayerOptions.Sections)do
  local card=g.UIElements.Card;local line=card:FindFirstChild('GroupOutline')
  check(line and line.Enabled and line.Transparency>.8,'subtle outlined rounded group')
  check(card:FindFirstChildOfClass('UICorner')~=nil,'rounded group corners')
 end
 check(choice.UIElements.MenuCanvas==nil,'embedded choice does not create floating menu')
 check(choice.UIElements.List:IsDescendantOf(d.PlayerOptions.UIElements.Panel),'selection remains inside popup')
 check(#choice.Tabs==6,'all embedded options visible')
 for _,r in ipairs(choice.Tabs)do
  if not(type(r.Value)=='table'and r.Value.Locked)then
  firesignal(r.Button.MouseButton1Click);task.wait(.2)
  check(choice.Value==(type(r.Value)=='table'and r.Value.Title or r.Value)and r.Check.Visible,'click selects embedded option')
  local marks=0;for _,v in ipairs(choice.Tabs)do if v.Check.Visible then marks+=1 end end
  check(marks==1,'one active checkmark')
  check(r.Button.AbsolutePosition.X>=d.PlayerOptions.UIElements.Panel.AbsolutePosition.X,'option contained left')
  check(r.Button.AbsolutePosition.X+r.Button.AbsoluteSize.X<=d.PlayerOptions.UIElements.Panel.AbsolutePosition.X+d.PlayerOptions.UIElements.Panel.AbsoluteSize.X,'option contained right')
  end
 end
 check(p:Create(name),'create config for embedded selection')
 choice:Select('Movement keys');check(p:Save(name),'save inline dropdown')
 choice:Select('View angles');check(p:Load(name),'load inline dropdown');task.wait(.15)
 check(choice.Value=='Movement keys','embedded selection persists')
 for _,r in ipairs(p.SortOptions)do check(r.Icon and r.Icon.ImageLabel.Image~='','sort choice has icon')end
end
local ok,err=pcall(run)
if isfile(d.Window.ConfigManager.Path..name..'.json')then p:Delete(name)end
if prior then p:Load(prior)end
choice:Select(old);d.PlayerOptions:Close()
assert(ok,err);return {passed=n}
