-- Persistent custom-theme creator/editor built from native WindUI controls.
local HttpService=game:GetService('HttpService')
local ThemeEditor={}

local DEFAULT_FIELDS={
 {'Accent','Accent'},{'Dialog','Dialog'},{'Outline','Outline'},{'Text','Text'},
 {'Placeholder','Placeholder'},{'Background','Background'},{'Button','Button'},{'Icon','Icon'},
 {'Primary','Primary'},{'Toggle','Toggle'},{'Slider','Slider'},{'SliderThumb','Slider thumb'},
 {'Checkbox','Checkbox'},{'CheckboxIcon','Checkbox icon'},{'CheckboxBorder','Checkbox border'},
 {'ProgressBar','Progress bar'},{'PanelBackground','Panel background'},{'ElementBackground','Element background'},
 {'TabBackground','Tab background'},{'TabBackgroundHover','Tab hover'},{'TabBackgroundActive','Tab active'},
 {'TabBorder','Tab border'},{'DropdownBackground','Dropdown background'},
 {'DropdownTabBackground','Dropdown item'},{'DropdownTabBorder','Dropdown border'},
 {'LabelBackground','Label background'},{'SearchBarBorder','Search border'},
 {'NotificationBorder','Notification border'},{'SectionBoxBackground','Section background'},
 {'SectionBoxBorder','Section border'},{'Tooltip','Tooltip'},{'TooltipText','Tooltip text'},
 {'TooltipSecondary','Tooltip accent'},{'TooltipSecondaryText','Tooltip accent text'},
}

local function clone(value)
 if type(value)~='table'then return value end
 local result={};for key,item in pairs(value)do result[key]=clone(item)end;return result
end
local function trim(value)return tostring(value or''):match('^%s*(.-)%s*$')end
local function normalizedName(value)
 return trim(value):gsub('[%c/\\:*?"<>|]',''):sub(1,32)
end
local function findName(items,name)
 local wanted=string.lower(name)
 for existing in pairs(items)do if string.lower(existing)==wanted then return existing end end
end
local function colorHex(color)
 return string.format('#%02X%02X%02X',math.floor(color.R*255+.5),math.floor(color.G*255+.5),math.floor(color.B*255+.5))
end

function ThemeEditor.New(window,wind,parent,config)
 assert(parent and type(parent.Button)=='function','CreateThemeEditor requires a section-like parent')
 local self={Entries={},Rows={},Editors={},Config=config}
 local builtins=config.Builtins or{'Dark','Light','Ocean','Forest','Ember','Orchid','Paper'}
 local fields=config.Fields or DEFAULT_FIELDS
 local path=(config.Folder or window.Folder or'Sirius-Remake2')..'/'..(config.FileName or'custom-themes.json')
 local canPersist=type(writefile)=='function'and type(readfile)=='function'and type(isfile)=='function'

 function self:GetNames()
  local names={};for name in pairs(self.Entries)do table.insert(names,name)end;table.sort(names);return names
 end
 function self:OpenCreate()if self.CreatePanel then self.CreatePanel:Open()end end
 function self:OpenEditor(name)if self.Editors[name]then self.Editors[name]:Open();return true end;return false end
 local function changed()
  if self.OnChanged then self.OnChanged(self:GetNames())end
  if config.OnChanged then config.OnChanged(self:GetNames())end
 end
 local function notify(title,content,icon)
  wind:Notify({Title=title,Content=content,Icon=icon or'palette',Duration=3})
 end
 local function saveFile()
  if not canPersist then return false,'File access is unavailable in this executor'end
  local ok,encoded=pcall(HttpService.JSONEncode,HttpService,{Version=1,Themes=self.Entries})
  if not ok then return false,encoded end
  local wrote,err=pcall(writefile,path,encoded);if not wrote then return false,err end
  return true
 end
 local function effective(base,key)
  local theme=wind:GetThemes()[base]or wind:GetThemes().Dark
  local value=wind:GetThemeProperty(key,theme)
  if typeof(value)~='Color3'then value=Color3.new(1,1,1)end
  local transparency=wind:GetThemeProperty(key..'Transparency',theme)
  if type(transparency)~='number'then transparency=0 end
  return value,math.clamp(transparency,0,1)
 end
 local function materialize(entry)
  local source=wind:GetThemes()[entry.Base]or wind:GetThemes().Dark
  local theme={}
  for key,value in pairs(source)do theme[key]=clone(value)end
  theme.Name=entry.Name
  for key,value in pairs(entry.Values or{})do
   local ok,color=pcall(Color3.fromHex,value.Color or'#FFFFFF')
   if ok then theme[key]=color end
   theme[key..'Transparency']=math.clamp(tonumber(value.Transparency)or 0,0,1)
  end
  wind:AddTheme(theme);return theme
 end
 local function apply(entry)
  materialize(entry);wind:SetTheme(entry.Name)
  if config.OnThemeChanged then config.OnThemeChanged(entry.Name)end
 end
 local function ensureValues(entry)
  entry.Values=entry.Values or{}
  for _,definition in ipairs(fields)do
   local key=definition[1]
   if not entry.Values[key]then
    local color,transparency=effective(entry.Base,key)
    entry.Values[key]={Color=colorHex(color),Transparency=transparency}
   end
  end
 end
 local function removeEntry(name)
  self.Entries[name]=nil;wind:GetThemes()[name]=nil
  local row=self.Rows[name];if row then row:Destroy();self.Rows[name]=nil end
  self.Editors[name]=nil
  saveFile();changed()
 end

 local createThemeRow
 local function attachEditor(row,entry,isCreate)
  local panel=row:Settings({
   Title=isCreate and'New custom theme'or(entry.Name..' theme'),
   Width=isCreate and 390 or 700,
   Icon='settings',
   MinColumnWidth=isCreate and 1000 or 285,
   ColumnGap=8,
  })
  local basics=panel:Section({Title=isCreate and false or'Theme',Outlined=not isCreate})
  local nameInput=basics:Input({Title='Name',Icon='type',Value=isCreate and''or entry.Name,Placeholder='My theme'})
  local baseInput=basics:Dropdown({Title='Base theme',Icon='palette',Values=builtins,Value=entry.Base or'Dark',MenuWidth=190})
  local actionTitle=isCreate and'Save theme'or'Save and overwrite'
  basics:Button({Title=actionTitle,Icon=isCreate and'check'or'save',Primary=isCreate,Callback=function()
   local name=normalizedName(nameInput.Value)
   if name==''then notify('Custom theme','Enter a theme name.','circle-alert');return end
   for _,builtin in ipairs(builtins)do if string.lower(builtin)==string.lower(name)then notify('Custom theme','That name belongs to a built-in theme.','circle-alert');return end end
   local collision=findName(self.Entries,name)
   if isCreate then
    if collision then notify('Custom theme','A theme with this name already exists.','circle-alert');return end
    local created={Name=name,Base=baseInput.Value or'Dark',Values={}}
    ensureValues(created);self.Entries[name]=created;materialize(created);createThemeRow(created)
    local ok,err=saveFile();if not ok then notify('Theme created, but not saved',tostring(err),'circle-alert')else notify('Theme created',name,'check')end
    apply(created);panel:Close();nameInput:Set('');changed()
   else
    local oldName=entry.Name
    if collision and collision~=oldName then notify('Custom theme','A theme with this name already exists.','circle-alert');return end
    entry.Base=baseInput.Value or entry.Base
    if name~=oldName then
     self.Entries[oldName]=nil;wind:GetThemes()[oldName]=nil;self.Rows[oldName]=nil;self.Editors[oldName]=nil
     entry.Name=name;self.Entries[name]=entry;row:SetTitle(name);self.Rows[name]=row;self.Editors[name]=panel
    end
    materialize(entry);apply(entry)
    local ok,err=saveFile();if not ok then notify('Theme not saved',tostring(err),'circle-alert')else notify('Theme saved',entry.Name,'check')end;changed()
   end
  end})
  if not isCreate then
   basics:Button({Title='Delete theme',Icon='trash-2',Color=Color3.fromRGB(244,105,95),Callback=function()
    local deleted=entry.Name;panel:Close();removeEntry(deleted);wind:SetTheme(config.FallbackTheme or'Dark')
    if config.OnThemeChanged then config.OnThemeChanged(config.FallbackTheme or'Dark')end
    notify('Theme deleted',deleted,'trash-2')
   end})
   ensureValues(entry)
   local left=panel:Section({Title='Interface colors',Outlined=true})
   local right=panel:RightSection({Title='Element colors',Outlined=true})
   for index,definition in ipairs(fields)do
    local key,label=definition[1],definition[2]
    local stored=entry.Values[key]
    local ok,color=pcall(Color3.fromHex,stored.Color or'#FFFFFF');if not ok then color=Color3.new(1,1,1)end
    local target=index<=math.ceil(#fields/2)and left or right
    target:Colorpicker({Title=label,Default=color,Transparency=stored.Transparency or 0,AllowGradient=false,Callback=function(newColor,transparency)
     stored.Color=colorHex(newColor);stored.Transparency=math.clamp(transparency or 0,0,1)
     if wind:GetCurrentTheme()==entry.Name then materialize(entry);wind:SetTheme(entry.Name);wind:RefreshTheme()end
    end})
   end
  end
  return panel
 end

 createThemeRow=function(entry)
  if self.Rows[entry.Name]then return self.Rows[entry.Name]end
  materialize(entry)
  local row=parent:Button({Title=entry.Name,Icon='palette',Callback=function()apply(entry)end})
  self.Rows[entry.Name]=row;self.Editors[entry.Name]=attachEditor(row,entry,false);return row
 end

 local addRow=parent:Button({Title=config.CreateTitle or'Custom',Icon='plus'})
 local draft={Name='',Base=config.DefaultBase or'Dark',Values={}}
 local createPanel=attachEditor(addRow,draft,true)
 addRow.Callback=function()createPanel:Open()end
 self.CreateRow=addRow;self.CreatePanel=createPanel

 if canPersist and isfile(path)then
  local ok,data=pcall(function()return HttpService:JSONDecode(readfile(path))end)
  if ok and type(data)=='table'and type(data.Themes)=='table'then
   for name,entry in pairs(data.Themes)do
    if type(entry)=='table'then entry.Name=normalizedName(entry.Name or name);entry.Base=entry.Base or'Dark';if entry.Name~=''then self.Entries[entry.Name]=entry end end
   end
  end
 end
 for _,name in ipairs(self:GetNames())do createThemeRow(self.Entries[name])end
 return self
end

return ThemeEditor