-- Live checks: exact source palette, theme routing, cursor contrast and explicit overrides.
local d=assert(getgenv().WindUIForkDemo)
local wind,window=d.Library,d.Window
local oldTheme=wind:GetCurrentTheme()
local oldColor,oldEnabled,oldSize=window.Cursor.Color,window.Cursor.Enabled,window.Cursor.Size
local n=0
local function check(value,message)n+=1;assert(value,'ThemeCursor: '..message)end
local function near(a,b)return typeof(a)=='Color3' and math.abs(a.R-b.R)<1e-5 and math.abs(a.G-b.G)<1e-5 and math.abs(a.B-b.B)<1e-5 end
local function selectTheme(name)d.ThemeDropdown:Select(name);task.wait(.15)end
local function run()
 local source={Primary=Color3.new(.318,.486,.992),Text=Color3.new(.922,.922,.941),Icon=Color3.new(.51,.52,.56),Outline=Color3.new(.118,.129,.173),Button=Color3.new(.102,.102,.133),ElementBackground=Color3.new(.071,.078,.114),PanelBackground=Color3.new(.043,.055,.086),ChoiceBackground=Color3.fromRGB(25,27,36),ToggleTrack=Color3.new(.055,.071,.098),ToggleThumbOff=Color3.new(.498,.529,.557),TabBackgroundActive=Color3.new(.153,.169,.212)}
 local theme=assert(wind:GetThemes().Neverlose)
 check(theme.TabBackgroundHoverTransparency==.6,'source tab hover alpha 40 percent')
 check(theme.TabBackgroundActiveTransparency==0,'source selected tab alpha 100 percent')
 check(theme.CardBorderTransparency==1,'no extra card outline strips')
 for key,color in pairs(source)do check(near(theme[key],color),'source color '..key)end
 check(table.find(d.ThemeDropdown.Values,'Neverlose')~=nil,'theme selector includes Neverlose')
 check(table.find(d.CustomThemes.CreatePanel.UIElements.BaseInput.Values,'Neverlose')~=nil,'custom base includes Neverlose')
 window:SetCustomCursor({Enabled=true,Color=false})
 for _,name in ipairs({'Light','Paper','Dark','Neverlose','Ocean','Light','Paper'})do
  selectTheme(name)
  local expected=(name=='Light'or name=='Paper')and Color3.new(0,0,0)or wind:GetThemeProperty('Cursor')
  check(near(window.Cursor.UIElements.Dot.BackgroundColor3,expected),'cursor follows '..name)
 end
 window:SetCustomCursor({Color=Color3.fromRGB(220,50,90)})
 selectTheme('Paper');check(near(window.Cursor.UIElements.Dot.BackgroundColor3,Color3.fromRGB(220,50,90)),'explicit Color3 override')
 window:SetCustomCursor({Size=12});selectTheme('Neverlose')
 check(near(window.Cursor.UIElements.Dot.BackgroundColor3,Color3.fromRGB(220,50,90)),'size changes preserve color override')
 window:SetCustomCursor({Color='#12AB34'});check(near(window.Cursor.UIElements.Dot.BackgroundColor3,Color3.fromHex('#12AB34')),'hex override')
 window:SetCustomCursor({Color='Auto'});check(near(window.Cursor.UIElements.Dot.BackgroundColor3,theme.Cursor),'Auto returns theme control')
 window:SetCustomCursor({Color=false});selectTheme('Paper')
 check(near(window.Cursor.UIElements.Dot.BackgroundColor3,Color3.new(0,0,0)),'reset restores black on Paper')
 selectTheme('Neverlose');d.Themes:Select()
 local cards={}
 for _,node in ipairs(d.Themes.UIElements.ContainerFrame:GetDescendants())do
  if node.Name=='Card' and node:IsA('CanvasGroup')then
   cards[#cards+1]=node
   check(near(node.BackgroundColor3,theme.ElementBackground),'card source fill')
   check(node.BackgroundTransparency==0,'card opaque source fill')
  end
 end
 check(#cards>=2,'theme cards visible')
 for _,entry in pairs(d.CustomThemes.Entries)do
  local edit=d.CustomThemes.Editors[entry.Name];local found=false
  for _,section in ipairs(edit.Sections)do
   local card=section.UIElements.Card
   check(not card:FindFirstChild('GroupOutline'),'no extra white editor outline')
   check(card:FindFirstChildOfClass('UICorner').CornerRadius.Offset==12,'editor uses standard card corners')
  end
  for _,section in ipairs(edit.Sections)do for _,element in ipairs(section.Elements)do if element.Title=='Cursor'then found=true end end end
  check(found,'custom editor exposes Cursor')
 end
end
local ok,err=pcall(run)
window:SetCustomCursor({Enabled=oldEnabled,Size=oldSize,Color=oldColor or false})
d.ThemeDropdown:Select(oldTheme)
assert(ok,err)
return 'ThemeCursor: '..n..' assertions passed'
