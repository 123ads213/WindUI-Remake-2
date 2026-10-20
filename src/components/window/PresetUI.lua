local U=require('./RemakeUI')
local Names=require('../../modules/ConfigNames')
local Http=game:GetService('HttpService')
local Input=game:GetService('UserInputService')
local P={}
function P.New(window,wind,options)
 options=options or{};local manager=window.ConfigManager
 if not manager then return nil,'Preset storage needs Window.Folder and executor file functions'end
 local self={Current=nil,Sort='Name',UIElements={},Opened=false}
 local host=window.UIElements.Main.Main
 local topbar=host.Topbar
 local bar=U.New('Frame',{Parent=host,Name='PresetToolbar',Size=UDim2.fromOffset(250,34),BackgroundTransparency=.55,ThemeTag={BackgroundColor3='ElementBackground'},ZIndex=30,Active=true});U.corner(bar,8)
 local save=U.button(bar,'',0,0,34,34,function()local ok,err=pcall(function()local result,message=self:Save();assert(result,message)end);if not ok then warn('[WindUI Presets] '..tostring(err))end end);U.icon(save,'save',9,9,16,window)
 local trigger=U.button(bar,'Default',36,0,210,34,function()self:Toggle()end);trigger.Label.Size=UDim2.new(1,-38,1,0);local chevron=U.icon(trigger,'chevron-down',184,9,16,window)
 local function fitTrigger()
  local scale=math.max(.01,wind.UIScaleObj.Scale)
  local x=window.UIElements.SideBarContainer.AbsoluteSize.X/scale+14
  local title=topbar.Left;local titleRight=(title.AbsolutePosition.X+title.AbsoluteSize.X-host.AbsolutePosition.X)/scale+14
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
 local viewButton=U.button(panel,'Presets',10,8,142,36,function()self.Sort='Name';self.View='Presets';self:Refresh()end);viewButton.Label.Position=UDim2.fromOffset(38,0);viewButton.Label.Size=UDim2.new(1,-44,1,0);U.icon(viewButton,'cloud',10,9,18,window)
 U.New('Frame',{Parent=panel,Position=UDim2.fromOffset(12,48),Size=UDim2.new(1,-24,0,1),BackgroundTransparency=.94,ThemeTag={BackgroundColor3='Text'},ZIndex=852})
 local status=U.text(panel,'',14,384,302,22,true);status.TextSize=12
 local search=U.input(panel,'Search presets',12,54,266,34)
 local sortButton=U.button(panel,'',282,54,36,34,function()self.Sort=self.Sort=='Name'and'Modified'or'Name';self:Refresh()end);U.icon(sortButton,'list-filter',10,9,16,window)
 local rows=U.New('ScrollingFrame',{Parent=panel,Name='PresetRows',Position=UDim2.fromOffset(12,98),Size=UDim2.fromOffset(306,274),BackgroundTransparency=1,CanvasSize=UDim2.new(),AutomaticCanvasSize='Y',ScrollBarThickness=2,BorderSizePixel=0,ZIndex=852})
 U.New('UIListLayout',{Parent=rows,Padding=UDim.new(0,6),SortOrder='LayoutOrder'})
 local editor=U.panel(window,'PresetEditor',330,228,870)
 local editorTitle=U.text(editor,'New preset',14,10,260,30)
 local nameInput=U.input(editor,'Preset name',14,50,302,34)
 local jsonInput=U.input(editor,'Paste preset JSON here',14,94,302,72);jsonInput.MultiLine=true;jsonInput.TextYAlignment='Top';jsonInput.TextWrapped=true
 local mode='Create';local sourceName
 local function statusError(err)status.Text=tostring(err or 'Operation failed')end
 local function safe(fn)
  local ok,a,b=pcall(fn);if not ok then statusError(a);return false,a end
  if a==false or a==nil then statusError(b);return false,b end;status.Text='';return a,b
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
 function self:Save(name)
  name=name or self.Current;if not name then return false,'No preset selected'end
  local c=config(name);c:Save();self.Current=name;trigger.Label.Text=name;self:Refresh();return true
 end
 function self:Load(name)
  local valid,err=Names.Validate(name);if not valid then return false,err end
  if not isfile(manager.Path..valid..'.json')then return false,'Preset not found'end
  local c=config(valid);local result,message=c:Load();if result==false then return false,message end
  c:SetAsCurrent();self.Current=valid;trigger.Label.Text=valid;self:Refresh();return true
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
 local actions=U.panel(window,'PresetActions',164,150,880)
 local actionName
 local function edit(kind,name)
  mode=kind;sourceName=name;editorTitle.Text=kind..' preset';nameInput.Text=kind=='Rename'and name or'';jsonInput.Text='';jsonInput.Visible=kind=='Import'or kind=='Export';nameInput.Visible=kind~='Delete'and kind~='Export'
  if kind=='Export'then jsonInput.Text=self:Export(name)or'';editorTitle.Text='Select and copy JSON';if setclipboard then setclipboard(jsonInput.Text)end end
  if kind=='Delete'then editorTitle.Text='Delete '..name..'?'end
  U.place(editor,trigger,wind);U.show(editor,true);U.show(actions,false)
 end
 U.button(editor,'Cancel',14,180,100,34,function()U.show(editor,false)end)
 U.button(editor,'Confirm',212,180,104,34,function()
  local ok=safe(function()
   if mode=='Create'then return self:Create(nameInput.Text)
   elseif mode=='Import'then return self:Import(nameInput.Text,jsonInput.Text)
   elseif mode=='Rename'then return self:Rename(sourceName,nameInput.Text)
   elseif mode=='Delete'then return self:Delete(sourceName)
   else return true end
  end)
  if ok then U.show(editor,false)else editorTitle.Text=status.Text end
 end)
 for i,action in ipairs({'Rename','Export','Delete'})do U.button(actions,action,6,6+(i-1)*44,152,42,function()edit(action,actionName)end)end
 local add=U.button(panel,'',282,10,36,32,function()edit('Create')end);U.icon(add,'plus',10,8,16,window)
 local imp=U.button(panel,'',202,10,34,32,function()edit('Import')end);U.icon(imp,'upload',9,8,16,window)
 recent=U.button(panel,'',242,10,34,32,function()self.View='Recent';self.Sort='Modified';self:Refresh()end);U.icon(recent,'folder-clock',9,8,16,window)
 function self:Refresh()
  for _,v in ipairs(rows:GetChildren())do if v:IsA('GuiObject')then v:Destroy()end end
  viewButton.BackgroundTransparency=self.View=='Recent'and 1 or .15
  recent.BackgroundTransparency=self.View=='Recent'and .15 or 1
  local names=manager:AllConfigs();local meta={}
  for _,n in ipairs(names)do local ok,d=pcall(function()return Http:JSONDecode(readfile(manager.Path..n..'.json'))end);meta[n]=ok and type(d)=='table'and d.__meta or{}end
  table.sort(names,function(a,b)if self.Sort=='Modified'then local aa,bb=(meta[a]or{}).modified or 0,(meta[b]or{}).modified or 0;if aa~=bb then return aa>bb end end;return a:lower()<b:lower()end)
  local count=0
  for _,n in ipairs(names)do if n:lower():find(search.Text:lower(),1,true)then
   count+=1;local row=U.button(rows,n,0,0,302,48,function()safe(function()return self:Load(n)end)end);row.LayoutOrder=count;row.BackgroundTransparency=n==self.Current and .05 or .6;row.Label.Size=UDim2.new(1,-94,1,0)
   local more=U.button(row,'',220,7,32,34,function()actionName=n;U.place(actions,row,wind);U.show(actions,true)end);U.icon(more,'ellipsis',8,9,16,window)
   local load=U.button(row,'',258,7,32,34,function()safe(function()if n==self.Current then return self:Save(n)else return self:Load(n)end end)end);U.icon(load,n==self.Current and'save'or'download',8,9,16,window)
  end end
  if count==0 then U.text(rows,'No presets found',8,10,280,32,true)end
  local height=math.clamp(count*54+130,184,414);panel.Size=UDim2.fromOffset(330,height);rows.Size=UDim2.fromOffset(306,height-140);status.Position=UDim2.fromOffset(14,height-28)
  if self.Opened then U.place(panel,trigger,wind)end
 end
 function self:Toggle()
  self.Opened=not self.Opened;if self.Opened then self:Refresh();U.place(panel,trigger,wind)end;U.show(panel,self.Opened)
 end
 local info=U.panel(window,'PresetInformation',274,114,860)
 local infoName=U.text(info,'',14,8,246,30);local author=U.text(info,'',14,40,246,28,true);local modified=U.text(info,'',14,70,246,28,true)
 trigger.MouseEnter:Connect(function()
  if not self.Current or self.Opened then return end
  local ok,data=pcall(function()return Http:JSONDecode(self:Export())end);local meta=ok and data.__meta or{}
  infoName.Text=self.Current;author.Text='Author: '..tostring(meta.author or'Unknown');modified.Text='Modified: '..(meta.modified and os.date('%d %b %Y, %H:%M',meta.modified)or'Unknown');U.place(info,trigger,wind);U.show(info,true)
 end)
 trigger.MouseLeave:Connect(function()U.show(info,false)end)
 search:GetPropertyChangedSignal('Text'):Connect(function()self:Refresh()end)
 local conn=Input.InputBegan:Connect(function(input)
  if input.KeyCode==Enum.KeyCode.Escape then self.Opened=false;for _,p in ipairs({panel,editor,actions,info})do U.show(p,false)end end
  if input.UserInputType==Enum.UserInputType.MouseButton1 then
   local point=input.Position
   if not U.inside(panel,point)and not U.inside(editor,point)and not U.inside(actions,point)and not U.inside(trigger,point)then self.Opened=false;for _,p in ipairs({panel,editor,actions,info})do U.show(p,false)end end
  end
 end)
 bar.Destroying:Connect(function()conn:Disconnect();for _,p in ipairs({panel,editor,actions,info})do p:Destroy()end end)
 self.UIElements={Toolbar=bar,Trigger=trigger,Panel=panel,Search=search,Rows=rows,Editor=editor,Info=info,Save=save,Import=imp,Recent=recent,Add=add,Sort=sortButton}
 -- File APIs can fail (permissions, missing clipboard/file support). Public calls report errors.
 for _,key in ipairs({'Create','Save','Load','Rename','Delete','Export','Import'})do
  local operation=self[key];self[key]=function(this,...)local result=table.pack(pcall(operation,this,...));if not result[1]then return false,tostring(result[2])end;return table.unpack(result,2,result.n)end
 end
 local default=options.Default or'Default'
 local ok,err=safe(function()if isfile(manager.Path..default..'.json')then return self:Load(default)else return self:Create(default)end end)
 return self,not ok and err or nil
end
return P
