local U=require('./RemakeUI')
local V=require('./Visibility')
local N=U.New
local Layout={}
function Layout.Attach(tab,window,wind,elements,scale)
 local function proxy(parent)
  local p={Elements={},UIElements={ContainerFrame=tab.UIElements.ContainerFrame},CompactRows=true,__type='RemakeContainer'}
  elements.Load(p,parent,elements.Elements,window,wind,nil,elements,scale,tab)
  return p
 end
 local function list(parent,gap)
  return N('UIListLayout',{Parent=parent,SortOrder='LayoutOrder',Padding=UDim.new(0,gap or 0)})
 end
 local function frame(parent,name)
  return N('Frame',{Parent=parent,Name=name,Size=UDim2.new(1,0,0,0),AutomaticSize='Y',BackgroundTransparency=1,LayoutOrder=#parent:GetChildren()})
 end
 local function columns(parent,config)
  config=config or {};local root=frame(parent,'Columns');root.AutomaticSize='None'
  local left=frame(root,'Left');local right=frame(root,'Right');local ll,rl=list(left,0),list(right,0)
  local out={UIElements={Root=root,Left=left,Right=right}}
  local function column(container)
   local col=proxy(container)
   function col:Section(cfg)
    cfg=type(cfg)=='string'and{Title=cfg}or(cfg or{})
    local holder=frame(container,'Section');local flow=list(holder,8);N('UIPadding',{Parent=holder,PaddingBottom=UDim.new(0,18)})
    local heading=U.text(holder,string.upper(cfg.Title or 'Settings'),4,0,200,20,true);heading.Size=UDim2.new(1,-8,0,20);heading.LayoutOrder=0;heading.TextSize=12
    local card=N('Frame',{Parent=holder,Name='Card',Size=UDim2.new(1,0,0,0),AutomaticSize='Y',BackgroundTransparency=.1,ThemeTag={BackgroundColor3='ElementBackground'},LayoutOrder=1});U.corner(card,12);list(card,0)
    local group=proxy(card);group.UIElements.Root=holder;group.Title=cfg.Title
    V.Attach(group,holder,cfg)
    return group
   end
   col.Group=col.Section
   return col
  end
  out.Left=column(left);out.Right=column(right)
  local function resize()
   if not root.Parent then return end
   local w=root.AbsoluteSize.X/math.max(.01,wind.UIScaleObj.Scale);local gap=config.Gap or 16;local narrow=w<2*(config.MinColumnWidth or 240)+gap
   if narrow then
    left.Size=UDim2.new(1,0,0,0);right.Size=UDim2.new(1,0,0,0);right.Position=UDim2.fromOffset(0,ll.AbsoluteContentSize.Y+gap)
    root.Size=UDim2.new(1,0,0,ll.AbsoluteContentSize.Y+rl.AbsoluteContentSize.Y+gap)
   else
    left.Size=UDim2.new(.5,-gap/2,0,0);right.Size=left.Size;right.Position=UDim2.new(.5,gap/2,0,0)
    root.Size=UDim2.new(1,0,0,math.max(ll.AbsoluteContentSize.Y,rl.AbsoluteContentSize.Y))
   end
  end
  ll:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize);rl:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize);root:GetPropertyChangedSignal('AbsoluteSize'):Connect(resize);task.defer(resize)
  return out
 end
 function tab:Columns(config)return columns(self.UIElements.ContainerFrame,config)end
 function tab:IconTabs(config)
  config=config or {};local root=frame(self.UIElements.ContainerFrame,'IconTabs');root.AutomaticSize='None'
  local bar=N('Frame',{Parent=root,Name='SubtabBar',Size=UDim2.new(1,0,0,38),BackgroundTransparency=1})
  N('UIListLayout',{Parent=bar,FillDirection='Horizontal',HorizontalAlignment='Right',SortOrder='LayoutOrder',Padding=UDim.new(0,4)})
  local controller={Pages={},Selected=nil,UIElements={Root=root,Bar=bar}}
  function controller:Tab(cfg)
   cfg=cfg or {};local index=#self.Pages+1
   local page=N('CanvasGroup',{Parent=root,Name='SubtabPage',Size=UDim2.new(1,0,0,0),AutomaticSize='Y',BackgroundTransparency=1,GroupTransparency=1});page.Position=UDim2.fromOffset(0,46);page.Visible=false;local flow=list(page,14)
   local p=proxy(page);p.Title=cfg.Title or 'Page';p.Id=cfg.Id or p.Title;p.UIElements.Root=page
   function p:Columns(c)return columns(page,c)end
   local b=U.button(bar,'',0,0,36,34,function()controller:Select(index)end);b.LayoutOrder=index
   U.icon(b,cfg.Icon or 'user',9,9,16,window)
   local label=U.text(b,p.Title,34,0,100,34);label.Visible=false
   p.Button=b;p.Label=label
   table.insert(self.Pages,p)
   function p:Select()controller:Select(index);return self end
   local function resize()if controller.Selected==index then root.Size=UDim2.new(1,0,0,46+flow.AbsoluteContentSize.Y)end end
   flow:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize)
   if not self.Selected then self:Select(index)end
   return p
  end
  function controller:Select(which)
   local index=type(which)=='number'and which or nil
   if not index then for i,p in ipairs(self.Pages)do if p.Id==which then index=i;break end end end
   if not index or not self.Pages[index]then return false end
   self.Selected=index
   for i,p in ipairs(self.Pages)do
    local active=i==index;p.UIElements.Root.Visible=active;if active then p.UIElements.Root.GroupTransparency=1;U.Tween(p.UIElements.Root,.18,{GroupTransparency=0}):Play()end;p.Label.Visible=active;p.Button.Size=UDim2.fromOffset(active and math.clamp(p.Label.TextBounds.X+48,90,180)or 36,34);p.Button.BackgroundTransparency=active and .05 or 1
    if active then local flow=p.UIElements.Root:FindFirstChildOfClass('UIListLayout');root.Size=UDim2.new(1,0,0,46+flow.AbsoluteContentSize.Y)end
   end
   return true
  end
  return controller
 end
end
return Layout
