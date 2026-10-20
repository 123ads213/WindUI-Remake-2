local U=require('./RemakeUI')
local V=require('./Visibility')
local N=U.New
local Layout={}
function Layout.Attach(tab,window,wind,elements,scale)
 local function proxy(parent)
  local p={Elements={},UIElements={ContainerFrame=tab.UIElements.ContainerFrame},CompactRows=true,RowHeight=tab.FeatureSettings and 38 or 50,FeatureSettings=tab.FeatureSettings==true,__type='RemakeContainer'}
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
    local holder=frame(container,'Section');local flow=list(holder,8);N('UIPadding',{Parent=holder,PaddingTop=UDim.new(0,cfg.Outlined and 1 or 0),PaddingLeft=UDim.new(0,cfg.Outlined and 1 or 0),PaddingRight=UDim.new(0,cfg.Outlined and 1 or 0),PaddingBottom=UDim.new(0,tab.FeatureSettings and 10 or 18)})
    local heading=U.text(holder,string.upper(cfg.Title==false and '' or cfg.Title or 'Settings'),4,0,200,20,true);heading.Size=UDim2.new(1,-8,0,20);heading.LayoutOrder=0;heading.TextSize=13;heading.Visible=cfg.Title~=false
    local card=N('CanvasGroup',{Parent=holder,Name='Card',ClipsDescendants=true,Size=UDim2.new(1,0,0,0),AutomaticSize='Y',BackgroundTransparency=.1,ThemeTag={BackgroundColor3='ElementBackground',BackgroundTransparency='CardTransparency'},LayoutOrder=1});U.corner(card,cfg.Outlined and 18 or 12)
    N('UIStroke',{Parent=card,Name='CardBorder',Thickness=1,ApplyStrokeMode='Border',ThemeTag={Color='CardBorder',Transparency='CardBorderTransparency'}})
    if cfg.Outlined then
     card.BackgroundTransparency=.9
     N("UIStroke",{Parent=card,Name="GroupOutline",Thickness=1,Transparency=.87,ApplyStrokeMode="Border",ThemeTag={Color="Text"}})
    end
    local cardFlow=list(card,0)
    -- The card owns separators: no line after its final currently visible row.
    local function separators()
     if not card.Parent then return end
     local rows={}
     for index,child in ipairs(card:GetChildren())do
      if child:IsA('GuiObject')then
       local divider=child:FindFirstChild('RowDivider',true)
       if divider then divider.Visible=false end
       if child.Visible and child.AbsoluteSize.Y>.5 then rows[#rows+1]={node=child,divider=divider,index=index}end
      end
     end
     table.sort(rows,function(a,b)if a.node.LayoutOrder==b.node.LayoutOrder then return a.index<b.index end;return a.node.LayoutOrder<b.node.LayoutOrder end)
     for i=1,#rows-1 do if rows[i].divider then rows[i].divider.Visible=true end end
    end
    cardFlow:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(separators)
    card.ChildAdded:Connect(function()task.defer(separators)end)
    card.ChildRemoved:Connect(function()task.defer(separators)end)

    local group=proxy(card);group.UIElements.Root=holder;group.UIElements.Card=card;group.Title=cfg.Title
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
  local group=N('Frame',{Parent=bar,Name='SubtabGroup',Size=UDim2.fromOffset(0,38),AutomaticSize='X',BackgroundTransparency=.18,ThemeTag={BackgroundColor3='ElementBackground'}});U.corner(group,8)
  N('UIPadding',{Parent=group,PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3)})
  N('UIListLayout',{Parent=group,FillDirection='Horizontal',SortOrder='LayoutOrder',VerticalAlignment='Center',Padding=UDim.new(0,3)})
  local controller={Pages={},Selected=nil,UIElements={Root=root,Bar=bar,Group=group}}
  function controller:Tab(cfg)
   cfg=cfg or {};local index=#self.Pages+1
   local page=N('CanvasGroup',{Parent=root,Name='SubtabPage',Size=UDim2.new(1,0,0,0),AutomaticSize='Y',BackgroundTransparency=1,GroupTransparency=1});page.Position=UDim2.fromOffset(0,46);page.Visible=false;local flow=list(page,14)
   local p=proxy(page);p.Title=cfg.Title or 'Page';p.Id=cfg.Id or p.Title;p.UIElements.Root=page
   function p:Columns(c)return columns(page,c)end
   local b=N('TextButton',{Parent=group,Text='',Size=UDim2.fromOffset(36,32),BackgroundTransparency=1,AutoButtonColor=false,ThemeTag={BackgroundColor3='Button'}});U.corner(b,6);b.LayoutOrder=index
   b.MouseButton1Click:Connect(function()controller:Select(index)end)
   b.MouseEnter:Connect(function()U.Tween(b,.12,{BackgroundTransparency=controller.Selected==index and .35 or .85}):Play()end)
   b.MouseLeave:Connect(function()U.Tween(b,.12,{BackgroundTransparency=controller.Selected==index and .45 or 1}):Play()end)
   local icon=U.icon(b,cfg.Icon or 'user',9,8,16,window)
   local label=U.text(b,p.Title,34,0,100,32);label.Visible=false
   p.Button=b;p.Label=label;p.Icon=icon
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
    local active=i==index;p.UIElements.Root.Visible=active;if active then p.UIElements.Root.GroupTransparency=1;U.Tween(p.UIElements.Root,.18,{GroupTransparency=0}):Play()end;p.Label.Visible=active;p.Button.Size=UDim2.fromOffset(active and math.clamp(p.Label.TextBounds.X+48,90,180)or 36,32);U.Tween(p.Button,.14,{BackgroundTransparency=active and .45 or 1}):Play()
    require('../../modules/Creator').AddThemeObject(p.Icon.ImageLabel,{ImageColor3=active and 'Text' or 'Icon'})
    if active then local flow=p.UIElements.Root:FindFirstChildOfClass('UIListLayout');root.Size=UDim2.new(1,0,0,46+flow.AbsoluteContentSize.Y)end
   end
   return true
  end
  return controller
 end
end
return Layout
