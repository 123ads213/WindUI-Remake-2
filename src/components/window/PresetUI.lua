local U=require('./RemakeUI')
local Names=require('../../modules/ConfigNames')
local Http=game:GetService('HttpService')
local Input=game:GetService('UserInputService')
local P={}
function P.New(window,wind,options)
 options=options or{};local manager=window.ConfigManager
 if not manager then return nil,'Preset storage needs Window.Folder and executor file functions'end
 local self={Current=nil,Sort='Created',SortReversed=false,UIElements={},Opened=false}
 local host=window.UIElements.Main.Main
 local topbar=host.Topbar
 local bar=U.New('Frame',{Parent=host,Name='PresetToolbar',Size=UDim2.fromOffset(250,34),BackgroundTransparency=0,ThemeTag={BackgroundColor3='Dialog'},ZIndex=30,Active=true});U.corner(bar,8)
 local save=U.button(bar,'',0,0,34,34,function()self:QuickSave()end);save:SetAttribute('NoHover',true);U.icon(save,'save',9,9,16,window)

 local divider=U.New('Frame',{Parent=bar,Name='SaveDivider',Position=UDim2.fromOffset(35,0),Size=UDim2.new(0,1,1,0),BackgroundTransparency=.86,ThemeTag={BackgroundColor3='Text'},ZIndex=32})
 U.New('UIStroke',{Parent=bar,Name='ToolbarOutline',Thickness=1,Transparency=.87,ApplyStrokeMode='Border',ThemeTag={Color='Text'}})
 local trigger=U.button(bar,'Default',36,0,210,34,function()self:Toggle()end);trigger:SetAttribute('NoHover',true);trigger.Label.Size=UDim2.new(1,-38,1,0);local chevron=U.icon(trigger,'chevron-down',184,9,16,window)
 local function fitTrigger()
  local scale=math.max(.01,wind.UIScaleObj.Scale)
  local x=window.UIElements.SideBarContainer.AbsoluteSize.X/scale+7
  local title=topbar.Left;local titleRight=(title.AbsolutePosition.X+title.AbsoluteSize.X-host.AbsolutePosition.X)/scale+7
  x=math.max(x,titleRight)
  local right=(topbar.Right.AbsolutePosition.X-host.AbsolutePosition.X)/scale-12
  local available=math.max(92,right-x-36)
  local width=math.min(math.clamp(trigger.Label.TextBounds.X+48,120,240),available)
  trigger.Size=UDim2.fromOffset(width,34);chevron.Position=UDim2.fromOffset(width-26,9)
  bar.Position=UDim2.fromOffset(x,(window.Topbar.Height-34)/2);bar.Size=UDim2.fromOffset(width+36,34)
 end
 host:GetPropertyChangedSignal('AbsoluteSize'):Connect(fitTrigger)
 topbar.Left:GetPropertyChangedSignal('AbsoluteSize'):Connect(fitTrigger)
 topbar.Right:GetPropertyChangedSignal('AbsolutePosition'):Connect(fitTrigger)
 trigger.Label:GetPropertyChangedSignal('TextBounds'):Connect(fitTrigger);task.defer(fitTrigger)
 local panel=U.panel(window,'Presets',330,414,850)
 local recent
 local viewButton=U.button(panel,'Presets',10,8,142,36,function()self.Sort='Name';self.SortReversed=false;self.View='Presets';self:Refresh()end);viewButton.Label.Position=UDim2.fromOffset(38,0);viewButton.Label.Size=UDim2.new(1,-44,1,0);U.icon(viewButton,'cloud',10,9,18,window)
 U.New('Frame',{Parent=panel,Position=UDim2.fromOffset(12,48),Size=UDim2.new(1,-24,0,1),BackgroundTransparency=.94,ThemeTag={BackgroundColor3='Text'},ZIndex=852})
 local status=U.text(panel,'',14,384,302,22,true);status.Name='ErrorMessage';status.TextSize=12;status.Visible=false
 local search=U.input(panel,'Search presets',12,54,266,34)
 local sortMenu=U.panel(window,'PresetSorting',224,144,890)
 local sortButton=U.button(panel,'',282,54,36,34,function()U.place(sortMenu,self.UIElements.Sort,wind);U.show(sortMenu,not sortMenu:GetAttribute('TargetVisible'))end);U.icon(sortButton,'list-filter',10,9,16,window)
 local rows=U.New('ScrollingFrame',{Parent=panel,Name='PresetRows',Position=UDim2.fromOffset(12,98),Size=UDim2.fromOffset(306,274),BackgroundTransparency=1,CanvasSize=UDim2.new(),AutomaticCanvasSize='None',ScrollBarThickness=2,BorderSizePixel=0,ZIndex=852})
 local rowCache={};self.RowCache=rowCache;self.Order={};self.SortLabels={Created='Newest First',Modified='Recently Modified',Name='Alphabetical'}
 local editor=U.panel(window,'PresetEditor',306,148,870)
 local editorIcon=U.icon(editor,'file-plus',14,15,18,window)
 local editorTitle=U.text(editor,'New preset',42,9,250,28)
 local nameInput=U.input(editor,'Preset name',14,48,278,34)
 local jsonInput=U.input(editor,'Paste preset JSON here',14,92,278,86);jsonInput.MultiLine=true;jsonInput.TextYAlignment='Top';jsonInput.TextWrapped=true
 local mode='Create';local sourceName
 local function statusError(err)status.Text=tostring(err or 'Operation failed');status.Visible=true end
 local function safe(fn)
  local ok,a,b=pcall(fn);if not ok then statusError(a);return false,a end
  if a==false or a==nil then statusError(b);return false,b end;status.Text='';status.Visible=false;return a,b
 end
 local function config(name)
  local c=manager:GetConfig(name)
  if type(c)~='table'then c=manager:CreateConfig(name)end
  return c
 end
 function self:Create(name)
  local valid,err=Names.Validate(name);if not valid then return false,err end
  if isfile(manager.Path..valid..'.json')then return false,'A preset with this name already exists'end
  local c=config(valid);if options.Author then c.Meta.author=options.Author end
  c:Save();self.Current=valid;trigger.Label.Text=valid;self:Refresh();return true
 end
 function self:QuickSave()
  local name=self.Current;local ok,err=self:Save(name)
  self.LastNotification={Name=name,Success=not not ok,Error=not ok and tostring(err)or nil}
  wind:Notify({Title=ok and 'Preset saved' or 'Save failed',Content=(name or 'No preset selected')..(ok and ' saved successfully' or ': '..tostring(err)),Duration=3,Icon=ok and 'save' or 'circle-alert'})
  return ok,err
 end
 function self:Save(name)
  name=name or self.Current;if not name then return false,'No preset selected'end
  local c=config(name);c:Save();assert(isfile(c.Path),'Preset file was not written');local persisted=Http:JSONDecode(readfile(c.Path));assert(type(persisted.__elements)=='table','Preset verification failed');self.Current=name;trigger.Label.Text=name;self:Refresh();return true
 end
 function self:Load(name)
  local valid,err=Names.Validate(name);if not valid then return false,err end
  if not isfile(manager.Path..valid..'.json')then return false,'Preset not found'end
  if self.Loading then return false,'A preset is already loading'end
  self.Loading=true
  local c=config(valid);local ok,result,message=pcall(c.Load,c);self.Loading=false
  if not ok then return false,tostring(result)end
  if result==false then return false,message end
  self.LastLoadStats=c.LastLoadStats
  c:SetAsCurrent();self.Current=valid;trigger.Label.Text=valid;self:Refresh();return true
 end
 function self:LoadFromUI(name)
  local ok,err=self:Load(name)
  self.LastLoadNotification={Name=name,Success=not not ok,Error=not ok and tostring(err)or nil}
  wind:Notify({Title=ok and 'Preset loaded' or 'Load failed',Content=(name or 'No preset')..(ok and ' loaded successfully' or ': '..tostring(err)),Duration=3,Icon=ok and 'download' or 'circle-alert'})
  return ok,err
 end
 function self:Delete(name)
  local ok,err=manager:DeleteConfig(name);if not ok then return false,err end
  if self.Current==name then self.Current=nil;trigger.Label.Text='Select preset'end;self:Refresh();return true
 end
 function self:Export(name)
  local valid,err=Names.Validate(name or self.Current);if not valid then return false,err end
  return readfile(manager.Path..valid..'.json')
 end
 function self:Import(name,json)
  local valid,err=Names.Validate(name);if not valid then return false,err end
  if isfile(manager.Path..valid..'.json')then return false,'Choose a new name; existing presets are not overwritten'end
  local ok,data=pcall(Http.JSONDecode,Http,json);if not ok then return false,'Invalid JSON'end
  local validData,message=Names.ValidateData(data);if not validData then return false,message end
  writefile(manager.Path..valid..'.json',Http:JSONEncode(data));self:Refresh();return true
 end
 function self:Rename(old,new)
  local wasCurrent=self.Current==old
  local valid,err=Names.Validate(new);if not valid then return false,err end
  local json,message=self:Export(old);if not json then return false,message end
  local ok,msg=self:Import(valid,json);if not ok then return false,msg end
  local deleted,deleteErr=self:Delete(old);if not deleted then self:Delete(valid);return false,deleteErr end
  if wasCurrent then self.Current=valid;trigger.Label.Text=valid end
  self:Refresh();return true
 end
 local actions=U.panel(window,'PresetActions',164,132,880)
 local actionName
 local info
 local cancelButton,confirmButton
 local function edit(kind,name)
  if info then U.show(info,false);info.Visible=false end
  mode=kind;sourceName=name;editorTitle.Text=kind..' preset';nameInput.Text=kind=='Rename'and name or'';jsonInput.Text='';jsonInput.Visible=kind=='Import'or kind=='Export';nameInput.Visible=kind~='Delete'and kind~='Export'
  if kind=='Export'then jsonInput.Text=self:Export(name)or'';editorTitle.Text='Select and copy JSON';if setclipboard then setclipboard(jsonInput.Text)end end
  if kind=='Delete'then editorTitle.Text='Delete '..name..'?'end
  local tall=kind=='Import'or kind=='Export';local height=tall and 236 or(kind=='Delete'and 112 or 148)
  editor.Size=UDim2.fromOffset(306,height)
  cancelButton.Position=UDim2.fromOffset(14,height-48);confirmButton.Position=UDim2.fromOffset(184,height-48)
  editorIcon:Destroy();editorIcon=U.icon(editor,({Create='file-plus',Rename='pencil',Import='upload',Export='download',Delete='trash-2'})[kind],14,15,18,window)
  U.show(panel,false);self.Opened=false
  U.place(editor,trigger,wind);U.show(editor,true);U.show(actions,false)
 end
 cancelButton=U.button(editor,'Cancel',14,100,100,34,function()U.show(editor,false)end)
 confirmButton=U.button(editor,'Confirm',184,100,108,34,function()
  local ok=safe(function()
   if mode=='Create'then return self:Create(nameInput.Text)
   elseif mode=='Import'then return self:Import(nameInput.Text,jsonInput.Text)
   elseif mode=='Rename'then return self:Rename(sourceName,nameInput.Text)
   elseif mode=='Delete'then return self:Delete(sourceName)
   else return true end
  end)
  if ok then U.show(editor,false)else editorTitle.Text=status.Text end
 end)
 U.icon(cancelButton,'x',8,9,16,window);cancelButton.Label.Position=UDim2.fromOffset(32,0);cancelButton.Label.Size=UDim2.new(1,-36,1,0)
 U.icon(confirmButton,'check',8,9,16,window);confirmButton.Label.Position=UDim2.fromOffset(32,0);confirmButton.Label.Size=UDim2.new(1,-36,1,0)
 for i,action in ipairs({'Rename','Export','Delete'})do local b=U.button(actions,action,6,6+(i-1)*40,152,38,function()edit(action,actionName)end);b.Label.Position=UDim2.fromOffset(36,0);b.Label.Size=UDim2.new(1,-42,1,0);U.icon(b,({'pencil','download','trash-2'})[i],10,11,16,window)end
 local add=U.button(panel,'',282,10,36,32,function()edit('Create')end);U.icon(add,'plus',10,8,16,window)
 local imp=U.button(panel,'',202,10,34,32,function()edit('Import')end);U.icon(imp,'upload',9,8,16,window)
 recent=U.button(panel,'',242,10,34,32,function()self.View='Recent';self.Sort='Modified';self.SortReversed=false;self:Refresh()end);U.icon(recent,'folder-clock',9,8,16,window)
 function self:Refresh()
  viewButton.BackgroundTransparency=.15
  recent.BackgroundTransparency=self.View=='Recent'and .15 or 1
  local names=manager:AllConfigs();local meta={}
  for _,n in ipairs(names)do local ok,d=pcall(function()return Http:JSONDecode(readfile(manager.Path..n..'.json'))end);meta[n]=ok and type(d)=='table'and d.__meta or{}end
  table.sort(names,function(a,b)
   if self.Sort=='Modified'or self.Sort=='Created'then
    local field=self.Sort=='Created'and'created'or'modified'
    local aa,bb=tonumber((meta[a]or{})[field])or 0,tonumber((meta[b]or{})[field])or 0
    if aa~=bb then if self.SortReversed then return aa<bb else return aa>bb end end
   end
   return Names.NameLess(a,b,self.SortReversed)
  end)
  local count=0;local present={};self.Order={}
  local empty=rows:FindFirstChild('EmptyLabel');if empty then empty:Destroy()end
  for _,n in ipairs(names)do if n:lower():find(search.Text:lower(),1,true)then
   count+=1;present[n]=true;self.Order[count]=n
   local item=rowCache[n]
   if not item then
    local slot=U.New('CanvasGroup',{Parent=rows,Name='PresetRow',Size=UDim2.fromOffset(302,48),Position=UDim2.fromOffset(0,(count-1)*54+6),BackgroundTransparency=1,GroupTransparency=1,ZIndex=853})
    local row=U.button(slot,n,0,0,302,48,function()U.show(actions,false);safe(function()return self:LoadFromUI(n)end)end);row.Label.Size=UDim2.new(1,-94,1,0)
    local more;more=U.button(row,'',220,7,32,34,function()actionName=n;U.place(actions,more or row,wind);U.show(actions,true)end);U.icon(more,'ellipsis',8,9,16,window)
    local load=U.button(row,'',258,7,32,34,function()U.show(actions,false);safe(function()return self:LoadFromUI(n)end)end)
    item={Slot=slot,Row=row,Load=load,LoadIcon=U.icon(load,'download',8,9,16,window)};rowCache[n]=item
    row.AutoButtonColor=false
    row.MouseEnter:Connect(function()U.Tween(row,.12,{BackgroundTransparency=n==self.Current and .35 or .8}):Play()end)
    row.MouseLeave:Connect(function()U.Tween(row,.12,{BackgroundTransparency=n==self.Current and .5 or 1}):Play()end)
    U.tooltip(window,wind,load,'Load preset')
   end
   item.Row.LayoutOrder=count;item.Slot.LayoutOrder=count;item.Row.BackgroundTransparency=n==self.Current and .5 or 1
   if item.Motion then item.Motion:Cancel()end
   item.Motion=U.Tween(item.Slot,.24,{Position=UDim2.fromOffset(0,(count-1)*54),GroupTransparency=0});item.Motion:Play()
  end end
  for name,item in pairs(rowCache)do if not present[name]then
   rowCache[name]=nil;if item.Motion then item.Motion:Cancel()end
   U.Tween(item.Slot,.16,{GroupTransparency=1}):Play();task.delay(.17,function()item.Slot:Destroy()end)
  end end
  rows.CanvasSize=UDim2.fromOffset(0,count*54)
  if count==0 then local label=U.text(rows,'No presets found',8,10,280,32,true);label.Name='EmptyLabel'end
  local height=math.clamp(count*54+110,164,394);panel.Size=UDim2.fromOffset(330,height);rows.Size=UDim2.fromOffset(306,height-110);status.Position=UDim2.fromOffset(14,height-26)
  if self.Opened then U.place(panel,trigger,wind)end
 end
 function self:Toggle()
  U.show(sortMenu,false)
  if info then U.show(info,false);info.Visible=false end
  U.show(editor,false);U.show(actions,false)
  self.Opened=not self.Opened;if self.Opened then self:Refresh();U.place(panel,trigger,wind)end;U.show(panel,self.Opened)
 end
 info=U.panel(window,'PresetInformation',294,114,860)
 U.icon(info,'file-text',14,15,16,window);U.icon(info,'user-round',14,46,16,window);U.icon(info,'clock-3',14,76,16,window)
 local infoName=U.text(info,'',40,8,240,30);local author=U.text(info,'',40,40,240,28,true);local modified=U.text(info,'',40,70,240,28,true)
 trigger.MouseEnter:Connect(function()
  if not self.Current or self.Opened or editor:GetAttribute('TargetVisible')or actions:GetAttribute('TargetVisible')then return end
  local ok,data=pcall(function()return Http:JSONDecode(self:Export())end);local meta=ok and data.__meta or{}
  infoName.Text=self.Current;author.Text='Author: '..tostring(meta.author or'Unknown');modified.Text='Modified: '..(meta.modified and os.date('%d %b %Y, %H:%M',meta.modified)or'Unknown');U.place(info,trigger,wind);U.show(info,true)
 end)
 trigger.MouseLeave:Connect(function()U.show(info,false)end)
 search:GetPropertyChangedSignal('Text'):Connect(function()self:Refresh()end)
 local conn=Input.InputBegan:Connect(function(input)
  if input.KeyCode==Enum.KeyCode.Escape then U.show(sortMenu,false)end
  if input.KeyCode==Enum.KeyCode.Escape then self.Opened=false;for _,p in ipairs({panel,editor,actions,info})do U.show(p,false)end end
  if input.UserInputType==Enum.UserInputType.MouseButton1 then
   local point=input.Position
   if not U.inside(sortMenu,point)and not U.inside(sortButton,point)then U.show(sortMenu,false)end
   if not U.inside(panel,point)and not U.inside(editor,point)and not U.inside(actions,point)and not U.inside(trigger,point)and not U.inside(sortMenu,point)then self.Opened=false;for _,p in ipairs({panel,editor,actions,info})do U.show(p,false)end end
  end
 end)
 bar.Destroying:Connect(function()conn:Disconnect();sortMenu:Destroy();for _,p in ipairs({panel,editor,actions,info})do p:Destroy()end end)
 self.UIElements={Toolbar=bar,Trigger=trigger,Panel=panel,Search=search,Rows=rows,ErrorMessage=status,Editor=editor,Info=info,Save=save,Import=imp,Recent=recent,Add=add,Sort=sortButton,SortMenu=sortMenu}
 self.SortOptions={}
 for i,choice in ipairs({{'Created','Newest First','calendar-plus'},{'Modified','Recently Modified','clock'},{'Name','Alphabetical','arrow-down-a-z'}})do
  local b=U.button(sortMenu,choice[2],6,6+(i-1)*44,212,42,function()self:SetSort(choice[1],self.Sort==choice[1]and not self.SortReversed or false);U.show(sortMenu,false)end)
  local icon=U.icon(b,choice[3],10,13,16,window);b.Label.Position=UDim2.fromOffset(36,0);b.Label.Size=UDim2.new(1,-70,1,0);local check=U.icon(b,'check',184,13,16,window)
  self.SortOptions[i]={Key=choice[1],Button=b,Check=check,Icon=icon}
 end
 local refresh=self.Refresh
 function self:SetSort(key,reversed)
  assert(self.SortLabels[key],'Unknown sort criterion');self.Sort=key;self.SortReversed=reversed==true;self:Refresh();return self
 end
 function self:Refresh()
  refresh(self)
  local reverseLabels={Created='Oldest First',Modified='Least Recently Modified',Name='Alphabetical Z–A'}
  for _,choice in ipairs(self.SortOptions)do
   local active=self.Sort==choice.Key;choice.Check.Visible=active
   choice.Button.Label.Text=active and self.SortReversed and reverseLabels[choice.Key]or self.SortLabels[choice.Key]
   choice.Button:SetAttribute('IdleTransparency',active and .5 or 1);choice.Button.BackgroundTransparency=active and .5 or 1
  end
 end
 self.UIElements.Tooltips={}
 for _,hint in ipairs({{save,'Save preset'},{imp,'Import preset'},{recent,'Recently modified'},{add,'Create preset'},{sortButton,'Sort presets'}})do
  self.UIElements.Tooltips[hint[2]]=U.tooltip(window,wind,hint[1],hint[2])
 end
 -- File APIs can fail (permissions, missing clipboard/file support). Public calls report errors.
 for _,key in ipairs({'Create','Save','Load','Rename','Delete','Export','Import'})do
  local operation=self[key];self[key]=function(this,...)local result=table.pack(pcall(operation,this,...));if not result[1]then return false,tostring(result[2])end;return table.unpack(result,2,result.n)end
 end
 local default=options.Default or'Default'
 local ok,err=safe(function()if isfile(manager.Path..default..'.json')then return self:Load(default)else return self:Create(default)end end)
 return self,not ok and err or nil
end
return P
