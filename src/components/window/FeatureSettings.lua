-- Native element containers inside a nearby per-feature settings popover.
local U=require('./RemakeUI')
local C=require('../../modules/Creator')
local Input=game:GetService('UserInputService')
local Settings={}
function Settings.New(content,frame,window,wind,elements,scale,config)
 config=config or{}
 local width=math.clamp(config.Width or 400,300,520)
 local panel=U.panel(window,'FeatureSettings',width,120,820)
 panel.ClipsDescendants=true
 local title=U.text(panel,config.Title or content.Title or 'Settings',16,10,width-54,30);title.TextSize=16
 local close=U.button(panel,'',width-38,10,28,28);U.icon(close,'x',7,7,14,window)
 local body=U.New('ScrollingFrame',{Parent=panel,Name='SettingsBody',Position=UDim2.fromOffset(16,48),Size=UDim2.new(1,-32,1,-64),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize='Y',CanvasSize=UDim2.new(),ZIndex=822})
 local tab={Elements={},FeatureSettings=true,UIElements={ContainerFrame=body}}
 require('./RemakeLayout').Attach(tab,window,wind,elements,scale)
 local columns=tab:Columns({Gap=0,MinColumnWidth=1000})
 local button=U.button(frame.UIElements.Main,'',0,0,30,30)
 button.Name='FeatureSettingsButton';button.AnchorPoint=Vector2.new(0,.5);button.Position=UDim2.new(1,-108,.5,0)
 U.icon(button,'ellipsis',7,7,16,window)
 if frame.UIElements.Title then frame.UIElements.Title.Size=UDim2.new(1,-132,1,0)end
 local self={Opened=false,Sections={},UIElements={Panel=panel,Button=button,Title=title,Body=body,Columns=columns}}
 local function fit()
  if not panel.Parent then return end
  local height=columns.UIElements.Root.Size.Y.Offset+64
  panel.Size=UDim2.fromOffset(width,math.clamp(height,110,math.min(620,wind.ScreenGui.AbsoluteSize.Y/math.max(.01,wind.UIScaleObj.Scale)-24)))
  if self.Opened then U.beside(panel,button,wind,8)end
 end
 function self:Section(cfg)
  cfg=table.clone(cfg or{});if cfg.Outlined==nil then cfg.Outlined=true end;if cfg.Title==nil then cfg.Title=false end
  local group=columns.Left:Section(cfg);table.insert(self.Sections,group);task.defer(fit);return group
 end
 self.Group=self.Section
 function self:Close()self.Opened=false;U.show(panel,false);if window.ActiveFeatureSettings==self then window.ActiveFeatureSettings=nil end end
 function self:Open()
  if window.ActiveFeatureSettings and window.ActiveFeatureSettings~=self then window.ActiveFeatureSettings:Close()end
  if window.FeatureUI then window.FeatureUI:HideDescription()end
  window.ActiveFeatureSettings=self;self.Opened=true;fit();U.beside(panel,button,wind,8);U.show(panel,true)
 end
 function self:Toggle()if self.Opened then self:Close()else self:Open()end end
 button.MouseButton1Click:Connect(function()self:Toggle()end)
 close.MouseButton1Click:Connect(function()self:Close()end)
 columns.UIElements.Root:GetPropertyChangedSignal('Size'):Connect(fit)
 local conn=Input.InputBegan:Connect(function(input)
  if input.KeyCode==Enum.KeyCode.Escape then self:Close()
  elseif input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
   if self.Opened and not U.inside(panel,input.Position)and not U.inside(button,input.Position)then self:Close()end
  end
 end)
 function self:Destroy()conn:Disconnect();self:Close();panel:Destroy();button:Destroy()end
 button.Destroying:Connect(function()conn:Disconnect();self:Close();panel:Destroy()end)
 return self
end
return Settings
