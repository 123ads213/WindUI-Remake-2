local U=require('../components/window/RemakeUI')
local C=require('../modules/Creator')
local Input=game:GetService('UserInputService')
local D={}
function D:New(config)
 local obj={__type='Dropdown',Title=config.Title or 'Dropdown',Values=config.Values or{},Multi=config.Multi,AllowNone=config.AllowNone,Value=config.Value,Locked=config.Locked,UIElements={},Tabs={},Opened=false,Callback=config.Callback or function()end}
 if obj.Multi then obj.Value=obj.Value or{}end
 if type(obj.Value)=='number'then obj.Value=obj.Values[obj.Value]end
 local ef=require('../components/window/Element')({Title=obj.Title,Parent=config.Parent,Window=config.Window,Tab=config.Tab,Index=config.Index,ElementTable=obj,ParentConfig=config,TextOffset=160,Hover=false})
 obj.DropdownFrame=ef
 local width=config.Width or 140
 local trigger=U.button(ef.UIElements.Main,'',0,0,width,30,function()if obj.Opened then obj:Close()else obj:Open()end end);trigger.Name='Choice';trigger.AnchorPoint=Vector2.new(1,.5);trigger.Position=UDim2.new(1,-14,.5,0);trigger.BackgroundTransparency=.35
 local display=U.text(trigger,'Select',10,0,width-36,30)
 U.icon(trigger,'chevron-down',width-25,7,16,config.Window)
 local menu=U.panel(config.Window,'CompactChoices',config.MenuWidth or math.max(width,180),100,810)
 local search=U.input(menu,'Search...',8,8,menu.Size.X.Offset-16,30);search.Visible=config.SearchBarEnabled==true
 local scroll=U.New('ScrollingFrame',{Parent=menu,Name='Options',Position=UDim2.fromOffset(6,search.Visible and 44 or 6),Size=UDim2.new(1,-12,1,search.Visible and -50 or -12),BackgroundTransparency=1,CanvasSize=UDim2.new(),AutomaticCanvasSize='Y',ScrollBarThickness=2,BorderSizePixel=0,ZIndex=812})
 U.New('UIListLayout',{Parent=scroll,SortOrder='LayoutOrder',Padding=UDim.new(0,2)})
 obj.UIElements.Dropdown=trigger;obj.UIElements.MenuCanvas=menu;obj.UIElements.Display=display
 local function title(v)return type(v)=='table'and tostring(v.Title or v.Value or '')or tostring(v)end
 local function selected(v)
  if obj.Multi then return table.find(obj.Value,title(v))~=nil end;return title(obj.Value or '')==title(v)
 end
 function obj:Display()
  display.Text=self.Multi and (#self.Value==0 and 'Select'or table.concat(self.Value,', '))or(self.Value~=nil and title(self.Value)or'Select')
  for _,row in ipairs(self.Tabs)do row.Check.Visible=selected(row.Value)end
 end
 function obj:Select(value)
  if self.Multi then assert(type(value)=='table','Multi dropdown requires an array');self.Value=table.clone(value)else self.Value=value end
  self:Display();task.spawn(self.Callback,self.Value);return self
 end
 local function render()
  for _,r in ipairs(obj.Tabs)do r.Button:Destroy()end;obj.Tabs={}
  local total=0
  for i,value in ipairs(obj.Values)do
   if not(type(value)=='table'and value.Type=='Divider')and string.find(string.lower(title(value)),string.lower(search.Text),1,true)then
    total+=1
    local b=U.button(scroll,title(value),0,0,menu.Size.X.Offset-12,32,function()
     if obj.Locked or(type(value)=='table'and value.Locked)then return end
     if obj.Multi then local values=table.clone(obj.Value);local n=table.find(values,title(value));if n then if obj.AllowNone~=false or #values>1 then table.remove(values,n)end else table.insert(values,title(value))end;obj:Select(values)
     else obj:Select(title(value));obj:Close()end
    end);b.LayoutOrder=i;b.Label.Size=UDim2.new(1,-45,1,0)
    local check=U.icon(b,'check',menu.Size.X.Offset-40,8,16,config.Window)
    obj.Tabs[#obj.Tabs+1]={Button=b,Value=value,Check=check}
   end
  end
  menu.Size=UDim2.fromOffset(menu.Size.X.Offset,math.min(260,math.max(44,total*34+12))+(search.Visible and 38 or 0));obj:Display()
  if obj.Opened then U.place(menu,trigger,config.WindUI)end
 end
 function obj:Refresh(values)if values then self.Values=values end;render();return self end
 function obj:Open()
  if self.Locked then return end
  if config.Window._CompactDropdown and config.Window._CompactDropdown~=self then config.Window._CompactDropdown:Close()end
  config.Window._CompactDropdown=self;self.Opened=true;render();U.place(menu,trigger,config.WindUI);U.show(menu,true)
 end
 function obj:Close()self.Opened=false;U.show(menu,false)end
 function obj:Lock()self.Locked=true;self:Close();ef:Lock()end
 function obj:Unlock()self.Locked=false;ef:Unlock()end
 search:GetPropertyChangedSignal('Text'):Connect(render)
 local conn=Input.InputBegan:Connect(function(input)
  if not obj.Opened then return end
  if input.KeyCode==Enum.KeyCode.Escape then obj:Close()end
  if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   if not U.inside(menu,input.Position)and not U.inside(trigger,input.Position)then obj:Close()end
  end
 end)
 local motion=game:GetService('RunService').Heartbeat:Connect(function()
  if obj.Opened then
   local visible=true;local p=trigger
   while p and p:IsA('GuiObject')do if not p.Visible or p:GetAttribute('WindUIHidden')then visible=false;break end;p=p.Parent end
   if visible then U.place(menu,trigger,config.WindUI)else obj:Close()end
  end
 end)
 ef.UIElements.Main.Destroying:Connect(function()conn:Disconnect();motion:Disconnect();menu:Destroy()end)
 if obj.Locked then ef:Lock(config.LockedTitle)end
 render();return 'Dropdown',obj
end
return D
