local C=require('../../modules/Creator')
return function(content,frame,config)
 if not table.find({"Toggle","Slider","Dropdown","Colorpicker","Input","Button","ProgressBar"},content.__type)then return end
 local main=frame.UIElements.Main
 main.AutomaticSize=Enum.AutomaticSize.None;main.Size=UDim2.new(1,0,0,config.RowHeight or 50)
 for _,v in ipairs(main:GetChildren())do if v:IsA('UIPadding')then v:Destroy()end end
 if main:IsA('ImageButton')or main:IsA('ImageLabel')then
  if C.Objects[main]then C.Objects[main].Properties.ImageTransparency=nil;C.Objects[main].Properties.ImageColor3=nil end
  main.ImageTransparency=1
 end
 main.BackgroundTransparency=1
 local locked=frame.UIElements.Locked
 if locked and locked.Parent then
  locked.Parent.Size=UDim2.fromScale(1,1);locked.Parent.Position=UDim2.fromScale(.5,.5)
  locked.Size=UDim2.fromScale(1,1)
 end
 local title=frame.UIElements.Title
 if frame.UIElements.Container then frame.UIElements.Container.Visible=false end
 if title then
  title.Parent=main;title.Visible=true;title.AutomaticSize=Enum.AutomaticSize.None;title.Position=UDim2.fromOffset(14,0);title.Size=UDim2.new(1,-104,1,0);title.TextSize=15;title.TextWrapped=false;title.TextTruncate=Enum.TextTruncate.AtEnd;title.FontFace=Font.new(C.Font,Enum.FontWeight.Medium)
 end
 local width=64
 if content.__type=='Slider'then
  local control=content.UIElements.SliderContainer
  width=math.max(184,config.Width or 184)
  if control then control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0);control.AutomaticSize=Enum.AutomaticSize.None;control.Size=UDim2.fromOffset(width,32)
   for _,v in ipairs(control:GetChildren())do if v:IsA('TextBox')then v.LayoutOrder=2 elseif v:IsA('GuiObject')then v.LayoutOrder=1 end end
  end
 elseif content.__type=='ProgressBar'then
  local control=content.UIElements.Container
  width=config.Width or 104
  control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0);control.Size=UDim2.fromOffset(width,32)
  local bar=content.UIElements.Bar
  bar.Size=UDim2.new(1,0,0,4)
  C.AddThemeObject(bar,{ImageColor3='Icon',ImageTransparency=.83})
  local value=content.UIElements.Value
  local root=config.Window.UIElements.Main.Main
  value.Parent=root;value.Name='ProgressHoverValue';value.Visible=false
  value.Size=UDim2.fromOffset(100,24);value.AnchorPoint=Vector2.new(.5,1)
  value.TextSize=13;value.TextTransparency=0;value.TextXAlignment='Center';value.TextTruncate='None'
  value.BackgroundTransparency=0;value.ZIndex=850
  C.AddThemeObject(value,{BackgroundColor3='Dialog',TextColor3='Text'})
  C.New('UICorner',{Parent=value,CornerRadius=UDim.new(0,7)})
  require('../ui/PopupShadow').New(value,{Opacity=.14})
  content.UIElements.HoverValue=value
  local function place()
   local scale=math.max(.01,config.WindUI.UIScaleObj.Scale)
   value.Size=UDim2.fromOffset(math.max(44,#value.Text*7+20),24)
   local x=bar.AbsolutePosition.X+bar.AbsoluteSize.X*content:GetPercentage()/100
   value.Position=UDim2.fromOffset((x-root.AbsolutePosition.X)/scale,(bar.AbsolutePosition.Y-root.AbsolutePosition.Y)/scale-4)
  end
  C.AddSignal(control.MouseEnter,function()if content.ShowValue then place();value.Visible=true end end)
  C.AddSignal(control.MouseLeave,function()value.Visible=false end)
  C.AddSignal(game:GetService('RunService').RenderStepped,function()
   if not value.Visible then return end
   local parent=main;local visible=true
   while parent and parent~=root do if parent:IsA('GuiObject')and not parent.Visible then visible=false;break end;parent=parent.Parent end
   if not visible or not root.Visible then value.Visible=false else place()end
  end)
  C.AddSignal(main.Destroying,function()value:Destroy()end)
 elseif content.__type=='Colorpicker'then
  local control=content.UIElements.Colorpicker;width=30
  if control then control.Size=UDim2.fromOffset(26,26);control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0)end
 elseif content.__type=='Toggle'then
  for _,control in ipairs(main:GetChildren())do if control:IsA('Frame')and control:FindFirstChild('ToggleFrame')then control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0)end end
 elseif content.__type=='Input'then
  width=config.Width or 140
  for _,control in ipairs(main:GetChildren())do if control:IsA('GuiObject')and control~=title and control~=frame.UIElements.Container and control:FindFirstChildWhichIsA('TextBox',true)then control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0);control.Size=UDim2.fromOffset(width,30)end end
 elseif content.__type=='Dropdown'then width=config.Width or 140
 elseif content.__type=='Button'then width=24;local control=content.UIElements.ButtonIcon;if control then control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0)end end
 local iconOffset=0
 if config.Icon then
  local icon=require('./RemakeUI').icon(main,config.Icon,14,15,20,config.Window);iconOffset=28
 end
 if title then title.Position=UDim2.fromOffset(14+iconOffset,0);title.Size=UDim2.new(1,-width-40-iconOffset,1,0)end
 C.New('Frame',{Parent=main,Name='RowDivider',Position=UDim2.new(0,14,1,-1),Size=UDim2.new(1,-28,0,1),BackgroundTransparency=.95,ThemeTag={BackgroundColor3='Text'}})
end
