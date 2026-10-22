-- Smoke test for documented layout/theme/profile/HUD APIs. No user files are read or written.
local source=assert(getgenv().__WindUIForkSource,'Inject current library source first')
local wind=assert(loadstring(table.concat(source)))()
local window
local checks=0
local function check(value,message)checks+=1;assert(value,'Documentation: '..message)end
local function run()
 window=wind:CreateWindow({Title='Documentation smoke',Theme='Neverlose',NewElements=true,DescriptionMode='Tooltip',SearchInTopbar=true,Size=UDim2.fromOffset(1000,650)})
 local tab=window:Tab({Title='Main',Icon='house'})
 local columns=tab:Columns({Gap=16,MinColumnWidth=260})
 local main=columns.Left:Section({Title='Features'})
 local appearance=columns.Right:Section({Title='Appearance'})
 local enabled=main:Toggle({Title='Enabled',Flag='docs.enabled',Value=false})
 local slider=main:Slider({Title='Speed',Flag='docs.speed',Step=1,Value={Min=0,Max=100,Default=20}})
 slider:Set(35);check(slider:Get()==35,'slider state')
 local options=enabled:Settings({Title='Feature settings',Width=336})
 local mode=options:Section():Dropdown({Title='Mode',Inline=true,Values={'Default','Alternative'},Value='Default',Flag='docs.mode'})
 mode:Select('Alternative');check(mode.Value=='Alternative','inline dropdown')
 options:Open();check(options.Opened,'settings open');options:Close()
 local multi=appearance:Dropdown({Title='Details',Multi=true,AllowNone=true,Values={'One','Two'},Value={'One'},Flag='docs.details'})
 multi:Select({'Two'});check(multi.Value[1]=='Two','multi select')
 local dependent=columns.Right:Section({Title='Extra',VisibleWhen=function()return enabled.Value end})
 check(type(dependent.SetVisible)=='function','dependent visibility')
 local builtins={'Dark','Light','Ocean','Forest','Ember','Orchid','Paper','Neverlose'}
 local selector=appearance:Dropdown({Title='Theme',Flag='docs.theme',Values=table.clone(builtins),Value='Neverlose',Callback=function(name)wind:SetTheme(name)end})
 local editor=window:CreateThemeEditor(appearance,{Builtins=table.clone(builtins),Folder='__docs_no_write',OnThemeChanged=function(name)selector:Select(name)end})
 check(type(editor.GetNames)=='function'and type(editor.OpenCreate)=='function','theme editor controller')
 local profile=window:CreateProfile({Themes=table.clone(builtins),IsCustomTheme=function(name)return editor.Entries[name]~=nil end,OnThemeSettings=function(name)editor:OpenEditor(name)end})
 profile:SetThemes(table.clone(builtins));check(profile.UIElements.ThemeOptions.Neverlose~=nil,'profile theme list')
 local hud=window:CreateHUD({Watermark=true,Keylist=true,Fields={FPS=true,Day=true,Platform=true}})
 check(hud:SetFields({'FPS','Ping','Username','Time','Weekday','Avatar','Logo','Build'}),'HUD labels')
 check(hud:SetField('Day',false),'HUD IDs')
 local state=hud:Export();check(hud:Import(state),'HUD round trip')
 window:SetCustomCursor({Enabled=true,Size=10,Color='#12AB34'})
 check(window.Cursor.Color==Color3.fromHex('#12AB34'),'cursor override')
 window:SetCustomCursor({Color=false});check(window.Cursor.Color==nil,'cursor auto reset')
 local row=appearance:Compound({Title='Appearance',Color={Flag='docs.color',Default=Color3.new(1,1,1)},Dropdown={Flag='docs.style',Values={'Solid','Ghost'},Value='Solid'}})
 row.Dropdown:Select('Ghost');check(row:GetControl('Dropdown').Value=='Ghost','compound child')
 local preview=appearance:PlayerPreview({Height=180,State={Name='Local preview',Health=75,Box=true}})
 preview:SetColor(Color3.new(1,0,0));check(preview:GetState().Color==Color3.new(1,0,0),'local preview')
 local pages=tab:IconTabs();local page=pages:Tab({Id='one',Title='One',Icon='user'});page:Columns().Left:Section({Title='Page'})
 check(pages:Select('one')~=false,'icon tabs')
 local presets,err=window:EnablePresets();check(presets==nil and type(err)=='string','storage unavailable degrades cleanly')
 window:SetToggleKey(Enum.KeyCode.F8);window:SetToggleKey(nil)
 return true
end
local ok,err=pcall(run)
if window then window:Destroy()end
for _,key in ipairs({'ScreenGui','NotificationGui','DropdownGui','TooltipGui'})do local gui=wind[key];if gui then gui:Destroy()end end
assert(ok,err)
return 'Documentation: '..checks..' assertions passed'
