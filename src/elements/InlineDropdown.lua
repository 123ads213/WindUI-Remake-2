-- An always-visible selection list, embedded in its owning settings card.
local U=require('../components/window/RemakeUI')
local C=require('../modules/Creator')
local D={}
function D:New(config)
 local rowHeight=config.RowHeight or 42
 local obj={__type='Dropdown',Title=config.Title or 'Dropdown',Values=config.Values or{},Multi=config.Multi,AllowNone=config.AllowNone,Value=config.Value,Locked=config.Locked or false,UIElements={},Tabs={},Callback=config.Callback or function()end}
 if obj.Multi then obj.Value=obj.Value or{}elseif type(obj.Value)=='number'then obj.Value=obj.Values[obj.Value]end
 local ef=require('../components/window/Element')({Title=obj.Title,Parent=config.Parent,Window=config.Window,Tab=config.Tab,Index=config.Index,ElementTable=obj,ParentConfig=config,TextOffset=0,Hover=false})
 obj.DropdownFrame=ef
 local compact=require('../components/window/CompactRow');compact(obj,ef,config)
 local main=ef.UIElements.Main
 ef.UIElements.Title.Visible=config.ShowTitle==true
 local list=U.New('Frame',{Parent=main,Name='InlineChoices',Position=UDim2.fromOffset(8,config.ShowTitle and 40 or 6),Size=UDim2.new(1,-16,0,0),AutomaticSize='Y',BackgroundTransparency=1})
 U.New('UIListLayout',{Parent=list,SortOrder='LayoutOrder',Padding=UDim.new(0,2)})
 obj.UIElements.List=list
 local function title(v)return type(v)=='table'and tostring(v.Title or v.Value or'')or tostring(v)end
 local function selected(v)if obj.Multi then return table.find(obj.Value,title(v))~=nil end;return title(obj.Value or'')==title(v)end
 function obj:Display()
  for _,r in ipairs(self.Tabs)do local active=selected(r.Value);r.Check.Visible=active;r.Button:SetAttribute('Selected',active);U.Tween(r.Button,.14,{BackgroundTransparency=active and .58 or 1}):Play()end
 end
 function obj:Select(value)
  if self.Multi then
   assert(type(value)=='table','Multi dropdown requires an array');self.Value={}
   for _,option in ipairs(self.Values)do if table.find(value,title(option))then table.insert(self.Value,title(option))end end
  else
   local valid=false;for _,option in ipairs(self.Values)do if title(option)==title(value)then valid=true;break end end
   if not valid then
    value=config.Value
    local fallback=false;for _,option in ipairs(self.Values)do if title(option)==title(value)then fallback=true;break end end
    if not fallback then for _,option in ipairs(self.Values)do if not(type(option)=='table'and option.Locked)then value=title(option);break end end end
   end
   self.Value=value
  end
  self:Display();task.spawn(self.Callback,self.Value);return self
 end
 function obj:Refresh(values)
  if values then self.Values=values end
  for _,r in ipairs(self.Tabs)do r.Button:Destroy()end;self.Tabs={}
  for i,v in ipairs(self.Values)do
   if not(type(v)=='table'and v.Type=='Divider')then
    local locked=type(v)=='table'and v.Locked
    local b=U.button(list,title(v),0,0,100,rowHeight,function()
     if self.Locked or locked then return end
     if self.Multi then local a=table.clone(self.Value);local n=table.find(a,title(v));if n then if self.AllowNone~=false or #a>1 then table.remove(a,n)end else table.insert(a,title(v))end;self:Select(a)else self:Select(title(v))end
    end)
    C.AddThemeObject(b,{BackgroundColor3='Button'});b.Size=UDim2.new(1,0,0,rowHeight);b.LayoutOrder=i
    b.Label.Position=UDim2.fromOffset(40,0);b.Label.Size=UDim2.new(1,-52,1,0);b.Label.TextSize=14
    if locked then b.Label.TextTransparency=.65 end
    local check=U.icon(b,'check',12,(rowHeight-16)/2,16,config.Window)
    b.MouseLeave:Connect(function()U.Tween(b,.14,{BackgroundTransparency=selected(v)and .58 or 1}):Play()end)
    self.Tabs[#self.Tabs+1]={Button=b,Check=check,Value=v}
   end
  end
  main.Size=UDim2.new(1,0,0,#self.Tabs*(rowHeight+2)+10+(config.ShowTitle and 34 or 0));self:Display();return self
 end
 function obj:Lock()self.Locked=true;ef:Lock()end
 function obj:Unlock()self.Locked=false;ef:Unlock()end
 function obj:Open()end
 function obj:Close()end
 obj:Refresh();obj:Select(obj.Value);return 'Dropdown',obj
end
return D
