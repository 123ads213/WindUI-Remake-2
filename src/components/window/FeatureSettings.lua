-- Native element containers inside a nearby per-feature settings popover.
local U=require('./RemakeUI')
local C=require('../../modules/Creator')
local Input=game:GetService('UserInputService')
local Settings={}
function Settings.New(content,frame,window,wind,elements,scale,config)
 config=config or{}
 local width=math.clamp(config.Width or 336,280,760)
 local panel=U.panel(window,'FeatureSettings',width,120,820)
 panel.ClipsDescendants=true
 local title=U.text(panel,config.Title or content.Title or 'Settings',12,7,width-50,28);title.TextSize=16
 local close=U.button(panel,'',width-36,7,26,26);U.icon(close,'x',7,7,14,window)
 if config.Centered then close:SetAttribute('NoHover',true)end
 if config.HeaderIcon then
  U.icon(panel,config.HeaderIcon,16,13,18,window)
  title.Position=UDim2.fromOffset(42,7);title.Size=UDim2.fromOffset(width-84,28)
 end
 local body=U.New('ScrollingFrame',{Parent=panel,Name='SettingsBody',Position=UDim2.fromOffset(12,42),Size=UDim2.new(1,-24,1,-54),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize='Y',CanvasSize=UDim2.new(),ZIndex=822})
 local tab={Elements={},FeatureSettings=true,UIElements={ContainerFrame=body}}
 require('./RemakeLayout').Attach(tab,window,wind,elements,scale)
 local columns=tab:Columns({Gap=config.ColumnGap or 8,MinColumnWidth=config.MinColumnWidth or 1000})
 local button=U.button(frame.UIElements.Main,'',0,0,30,30)
 button.Name='FeatureSettingsButton';button.AnchorPoint=Vector2.new(0,.5);button.Position=UDim2.new(1,-108,.5,0)
 U.icon(button,config.Icon or'ellipsis',7,7,16,window)
 if frame.UIElements.Title then frame.UIElements.Title.Size=UDim2.new(1,-132,1,0)end
 local self={Opened=false,Sections={},UIElements={Panel=panel,Button=button,Title=title,Body=body,Columns=columns}}
 local footerHeight=0
 local function place()
  if config.Centered then U.center(panel,wind)else U.beside(panel,button,wind,8)end
 end
 local function fit()
  if not panel.Parent then return end
  local height=columns.UIElements.Root.Size.Y.Offset+54+footerHeight
  panel.Size=UDim2.fromOffset(width,math.clamp(height,110,math.min(620,wind.ScreenGui.AbsoluteSize.Y/math.max(.01,wind.UIScaleObj.Scale)-24)))
  if self.Opened then place()end
 end
 -- Actions live outside the scrolling cards, never inside a clipped element row.
 function self:Footer(cfg)
  assert(not self.UIElements.Footer,'A settings panel has only one footer')
  footerHeight=36;body.Size=UDim2.new(1,-24,1,-54-footerHeight)
  local footer=U.New('Frame',{Parent=panel,Name='SettingsFooter',Position=UDim2.new(0,16,1,-52),Size=UDim2.new(1,-32,0,36),BackgroundTransparency=1,ZIndex=824})
  local actionWidth=(width-40)/2
  local cancel=U.button(footer,'Cancel',0,0,actionWidth,36,function()self:Close()end)
  cancel.Name='CancelAction';cancel.BackgroundTransparency=.15;cancel:SetAttribute('NoHover',true)
  U.icon(cancel,'x',14,10,16,window)
  cancel.Label.Position=UDim2.fromOffset(38,0);cancel.Label.Size=UDim2.new(1,-48,1,0);cancel.Label.TextSize=14
  local action=U.button(footer,cfg.Title or'Save',actionWidth+8,0,actionWidth,36,cfg.Callback)
  action.Name='ConfirmAction';action.BackgroundTransparency=0;action:SetAttribute('NoHover',true)
  C.AddThemeObject(action,{BackgroundColor3='Primary'})
  C.AddThemeObject(action.Label,{TextColor3='Text'})
  if C.Objects[action.Label]then C.Objects[action.Label].Properties.TextColor3=nil end
  action.Label.TextColor3=Color3.new(1,1,1);action.Label.TextSize=14
  action.Label.Position=UDim2.fromOffset(38,0);action.Label.Size=UDim2.new(1,-48,1,0)
  local icon=U.icon(action,cfg.Icon or'check',14,10,16,window)
  if C.Objects[icon.ImageLabel]then C.Objects[icon.ImageLabel].Properties.ImageColor3=nil end
  icon.ImageLabel.ImageColor3=Color3.new(1,1,1)
  self.UIElements.Footer=footer;self.UIElements.Confirm=action;self.UIElements.Cancel=cancel
  task.defer(fit);return action
 end
 function self:Section(cfg,side)
  cfg=table.clone(cfg or{});if cfg.Outlined==nil then cfg.Outlined=true end;if cfg.Title==nil then cfg.Title=false end
  local column=side=='Right'and columns.Right or columns.Left
  local group=column:Section(cfg);table.insert(self.Sections,group);task.defer(fit);return group
 end
 function self:RightSection(cfg)return self:Section(cfg,'Right')end
 self.Group=self.Section
 local function ownedDropdown()
  local dropdown=window._CompactDropdown
  return dropdown and dropdown.UIElements.Dropdown:IsDescendantOf(panel)and dropdown
 end
 function self:Close()
  local dropdown=ownedDropdown();if dropdown then dropdown:Close()end
  self.Opened=false;U.show(panel,false);if window.ActiveFeatureSettings==self then window.ActiveFeatureSettings=nil end
 end
 function self:Open()
  if window.ActiveFeatureSettings and window.ActiveFeatureSettings~=self then window.ActiveFeatureSettings:Close()end
  if window.FeatureUI then window.FeatureUI:HideDescription()end
  if config.Centered and window.Profile then window.Profile:Close()end
  window.ActiveFeatureSettings=self;self.Opened=true;fit();place();U.show(panel,true)
 end
 function self:Toggle()if self.Opened then self:Close()else self:Open()end end
 button.MouseButton1Click:Connect(function()self:Toggle()end)
 close.MouseButton1Click:Connect(function()self:Close()end)
 columns.UIElements.Root:GetPropertyChangedSignal('Size'):Connect(fit)
 local positionConn=panel.Parent:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()if self.Opened and config.Centered then place()end end)
 local screenConn=wind.ScreenGui:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()if self.Opened then fit()end end)
 local scaleConn=wind.UIScaleObj:GetPropertyChangedSignal('Scale'):Connect(function()if self.Opened then fit()end end)
 local conn=Input.InputBegan:Connect(function(input)
  if input.KeyCode==Enum.KeyCode.Escape then self:Close()
  elseif input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   local dropdown=ownedDropdown()
   local inChoices=dropdown and dropdown.Opened and U.inside(dropdown.UIElements.MenuCanvas,input.Position)
   if self.Opened and not U.inside(panel,input.Position)and not U.inside(button,input.Position)and not inChoices then self:Close()end
  end
 end)
 function self:Destroy()conn:Disconnect();self:Close();panel:Destroy();button:Destroy()end
 button.Destroying:Connect(function()conn:Disconnect();positionConn:Disconnect();screenConn:Disconnect();scaleConn:Disconnect();self:Close();panel:Destroy()end)
 return self
end
return Settings
