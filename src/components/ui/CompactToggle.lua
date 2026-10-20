-- Small circular-thumb switch. No glass sprite sheets or per-toggle frame loops.
local C=require('../../modules/Creator')
local T={}
function T.New(value,icon,iconSize,parent,callback,newElement,config)
 local root=C.New('Frame',{Parent=parent,Name='CompactToggle',BackgroundTransparency=1,Size=UDim2.fromOffset(40,26)})
 local track=C.New('Frame',{Parent=root,Name='ToggleFrame',Size=UDim2.fromOffset(40,24),Position=UDim2.fromScale(1,.5),AnchorPoint=Vector2.new(1,.5),ThemeTag={BackgroundColor3='ToggleTrack'}})
 C.New('UICorner',{Parent=track,CornerRadius=UDim.new(1,0)})
 local thumb=C.New('Frame',{Parent=track,Name='Thumb',Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(2,2),ThemeTag={BackgroundColor3='ToggleThumbOff'}})
 C.New('UICorner',{Parent=thumb,CornerRadius=UDim.new(1,0)})
 C.New('TextButton',{Parent=track,Name='Hitbox',Text='',BackgroundTransparency=1,AutoButtonColor=false,Size=UDim2.new(1,8,1,12),Position=UDim2.fromOffset(-4,-6),ZIndex=5})
 local self={UIElements={Track=track,Thumb=thumb},Value=value}
 function self:Set(v,fire,instant)
  self.Value=not not v
  C.AddThemeObject(track,{BackgroundColor3=self.Value and 'Toggle' or 'ToggleTrack'},true)
  C.AddThemeObject(thumb,{BackgroundColor3=self.Value and 'ToggleBar' or 'ToggleThumbOff'},true)
  C.UpdateTheme(track,false,self.Initialized,.14)
  C.UpdateTheme(thumb,false,self.Initialized,.14)
  local pos=UDim2.fromOffset(self.Value and 18 or 2,2)
  if self.PositionTween then self.PositionTween:Cancel()end
  if not self.Initialized then thumb.Position=pos else self.PositionTween=C.Tween(thumb,.18,{Position=pos},Enum.EasingStyle.Quint,Enum.EasingDirection.Out);self.PositionTween:Play()end
  self.Initialized=true
  if fire~=false and callback then task.spawn(function()C.SafeCallback(callback,self.Value)end)end
 end
 self:Set(value,false,true)
 return root,self
end
return T
