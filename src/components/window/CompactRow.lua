local C=require('../../modules/Creator')
return function(content,frame,config)
 if not table.find({"Toggle","Slider","Dropdown","Colorpicker","Input","Button"},content.__type)then return end
 local main=frame.UIElements.Main
 main.AutomaticSize=Enum.AutomaticSize.None;main.Size=UDim2.new(1,0,0,44)
 for _,v in ipairs(main:GetChildren())do if v:IsA('UIPadding')then v:Destroy()end end
 if main:IsA('ImageButton')or main:IsA('ImageLabel')then main.ImageTransparency=1 end
 main.BackgroundTransparency=1
 local title=frame.UIElements.Title
 if frame.UIElements.Container then frame.UIElements.Container.Visible=false end
 if title then
  title.Parent=main;title.Visible=true;title.AutomaticSize=Enum.AutomaticSize.None;title.Position=UDim2.fromOffset(14,0);title.Size=UDim2.new(1,-104,1,0);title.TextSize=14;title.TextWrapped=false;title.TextTruncate=Enum.TextTruncate.AtEnd;title.FontFace=Font.new(C.Font,Enum.FontWeight.Medium)
 end
 local width=64
 if content.__type=='Slider'then
  local control=content.UIElements.SliderContainer
  width=config.Width or 150
  if control then control.AnchorPoint=Vector2.new(1,.5);control.Position=UDim2.new(1,-14,.5,0);control.AutomaticSize=Enum.AutomaticSize.None;control.Size=UDim2.fromOffset(width,26)
   for _,v in ipairs(control:GetChildren())do if v:IsA('TextBox')then v.LayoutOrder=2 elseif v:IsA('GuiObject')then v.LayoutOrder=1 end end
  end
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
  local icon=require('./RemakeUI').icon(main,config.Icon,14,12,20,config.Window);iconOffset=28
 end
 if title then title.Position=UDim2.fromOffset(14+iconOffset,0);title.Size=UDim2.new(1,-width-40-iconOffset,1,0)end
 C.New('Frame',{Parent=main,Name='RowDivider',Position=UDim2.new(0,14,1,-1),Size=UDim2.new(1,-28,0,1),BackgroundTransparency=.95,ThemeTag={BackgroundColor3='Text'}})
end
