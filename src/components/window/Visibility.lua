-- Values are retained; the layout slot, opacity and interaction collapse together.
local Run=game:GetService('RunService')
local C=require('../../modules/Creator')
local V={}
function V.Attach(obj,frame,config)
 if obj.SetVisible then return end
 local parent=frame.Parent
 local slot=C.New('CanvasGroup',{Parent=parent,Name='VisibilitySlot',BackgroundTransparency=1,Size=frame.Size,LayoutOrder=frame.LayoutOrder,GroupTransparency=0,ClipsDescendants=true})
 frame.Parent=slot;frame.Position=UDim2.new();frame.AnchorPoint=Vector2.zero
 local natural=frame.Size;local p=1;local target=config.Visible~=false;local condition=config.VisibleWhen
 local function desired()
  if condition then local ok,value=pcall(condition);if not ok then return false end;return target and not not value end
  return target
 end
 function obj:SetVisible(value,instant)
  target=not not value;if instant then p=desired()and 1 or 0 end;return self
 end
 function obj:VisibleWhen(control,expected)
  if type(control)=='function'then condition=control else if expected==nil then expected=true end;condition=function()return control.Value==expected end end;return self
 end
 obj.VisibilityFrame=slot
 local conn
 conn=Run.Heartbeat:Connect(function(dt)
  if not frame.Parent or not slot.Parent then conn:Disconnect();return end
  local show=desired();obj.Hidden=not show;frame:SetAttribute('WindUIHidden',not show)
  local dest=show and 1 or 0;p=math.abs(p-dest)<.002 and dest or p+(dest-p)*(1-math.exp(-18*dt))
  local h=natural.Y.Offset
  if frame.AutomaticSize~=Enum.AutomaticSize.None then h=frame.AbsoluteSize.Y/math.max(.01,C.UIScale)end
  slot.Size=UDim2.new(natural.X.Scale,natural.X.Offset,0,math.max(0,h*p));slot.GroupTransparency=1-p;slot.Visible=p>.001
  slot.Active=show;slot.Interactable=show
 end)
 slot.Destroying:Connect(function()if conn then conn:Disconnect()end end)
end
return V
