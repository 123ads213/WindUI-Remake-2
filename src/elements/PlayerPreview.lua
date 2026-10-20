-- Local-only design preview. Never scans workspace players or implements ESP.
local C=require('../modules/Creator')
local U=require('../components/window/RemakeUI')
local E={}
function E:New(config)
 local self={__type='PlayerPreview',Title=config.Title or 'Player preview',UIElements={},State={Enabled=true,Color=Color3.fromHex('5957E3'),BoxColor=Color3.fromHex('5957E3'),Mode='Solid',Name='Preview player',Health=75,Box=true,Distance='25m'},Yaw=.25}
 local root=C.New('Frame',{Parent=config.Parent,Name='PlayerPreview',Size=UDim2.new(1,0,0,config.Height or 310),ThemeTag={BackgroundColor3='ElementBackground'},ClipsDescendants=true})
 U.corner(root,12)
 C.New('UIStroke',{Parent=root,Thickness=1,ThemeTag={Color='CardBorder',Transparency='CardBorderTransparency'}})
 local view=C.New('ViewportFrame',{Parent=root,Name='Model',Size=UDim2.new(1,-40,1,-52),Position=UDim2.fromOffset(20,28),BackgroundTransparency=1,Ambient=Color3.fromRGB(170,170,190),LightColor=Color3.fromRGB(245,245,255),LightDirection=Vector3.new(-1,-1,-2)})
 local world=C.New('WorldModel',{Parent=view});local camera=C.New('Camera',{Parent=view,FieldOfView=35});view.CurrentCamera=camera
 local name=U.text(root,self.State.Name,14,8,200,22);name.TextXAlignment='Center';name.Size=UDim2.new(1,-28,0,22)
 local distance=U.text(root,'25m',14,config.Height and config.Height-29 or 281,200,20,true);distance.Position=UDim2.new(0,14,1,-28);distance.Size=UDim2.new(1,-28,0,20);distance.TextXAlignment='Center'
 local box=C.New('Frame',{Parent=root,Name='Box',Position=UDim2.fromScale(.18,.13),Size=UDim2.fromScale(.64,.74),BackgroundTransparency=1})
 local outline=C.New('UIStroke',{Parent=box,Thickness=1,Color=self.State.Color,Transparency=.25})
 local healthTrack=C.New('Frame',{Parent=box,Name='HealthTrack',Position=UDim2.fromOffset(-9,0),Size=UDim2.new(0,3,1,0),BackgroundColor3=Color3.fromRGB(5,5,12)})
 local health=C.New('Frame',{Parent=healthTrack,Name='Health',AnchorPoint=Vector2.new(0,1),Position=UDim2.fromScale(0,1),Size=UDim2.new(1,0,.75,0),BackgroundColor3=Color3.fromRGB(111,201,145)})
 local function dummy()
  local model=Instance.new('Model');model.Name='MockPlayer'
  for _,p in ipairs({{'Head',Vector3.new(0,2.5,0),Vector3.new(1.25,1.25,1.25)},{'Torso',Vector3.new(0,.9,0),Vector3.new(2,2,1)},{'Left arm',Vector3.new(-1.55,.9,0),Vector3.new(.9,2,1)},{'Right arm',Vector3.new(1.55,.9,0),Vector3.new(.9,2,1)},{'Left leg',Vector3.new(-.55,-1.2,0),Vector3.new(.95,2,1)},{'Right leg',Vector3.new(.55,-1.2,0),Vector3.new(.95,2,1)}})do
   C.New('Part',{Parent=model,Name=p[1],Size=p[3],Position=p[2],Anchored=true,CanCollide=false,Material=Enum.Material.SmoothPlastic,Color=self.State.Color,TopSurface=Enum.SurfaceType.Smooth,BottomSurface=Enum.SurfaceType.Smooth})
  end
  return model
 end
 local function style()
  if not self.Model then return end
  for _,part in ipairs(self.Model:GetDescendants())do
   if part:IsA('BasePart')then part.Color=self.State.Color;part.Material=self.State.Mode=='Neon'and Enum.Material.Neon or Enum.Material.SmoothPlastic;part.Transparency=self.State.Mode=='Ghost'and .55 or 0
   elseif part:IsA('Decal')or part:IsA('Texture')then part.Transparency=1 end
  end
 end
 local function fit()
  local cf,size=self.Model:GetBoundingBox();local focus=cf.Position
  local radius=math.max(size.Y,size.X*1.25,size.Z*1.25)/2
  local d=radius/math.tan(math.rad(camera.FieldOfView/2))*1.25
  camera.CFrame=CFrame.lookAt(focus+Vector3.new(math.sin(self.Yaw)*d,.3,math.cos(self.Yaw)*d),focus)
 end
 function self:SetModel(model)
  assert(model==nil or(typeof(model)=='Instance'and model:IsA('Model')),'SetModel expects a Model or nil')
  local copy=model and model:Clone()or dummy();assert(copy,'Model must be Archivable')
  for _,v in ipairs(copy:GetDescendants())do if v:IsA('LuaSourceContainer')then v:Destroy()elseif v:IsA('BasePart')then v.Anchored=true;v.CanCollide=false end end
  assert(copy:FindFirstChildWhichIsA('BasePart',true),'Model needs a BasePart')
  if self.Model then self.Model:Destroy()end
  self.Model=copy;copy.Parent=world;style();fit();return self
 end
 function self:Update(values)
  values=values or{}
  if values.Color~=nil then assert(typeof(values.Color)=='Color3','Color must be Color3')end
  if values.BoxColor~=nil then assert(typeof(values.BoxColor)=='Color3','BoxColor must be Color3')end
  if values.Mode~=nil then assert(table.find({'Solid','Neon','Ghost'},values.Mode),'Mode: Solid, Neon or Ghost')end
  if values.Health~=nil then assert(type(values.Health)=='number','Health must be numeric')end
  for key,value in pairs(values)do if self.State[key]~=nil then self.State[key]=value end end
  self.State.Health=math.clamp(self.State.Health,0,100)
  name.Text=tostring(self.State.Name);distance.Text=tostring(self.State.Distance);view.Visible=self.State.Enabled;box.Visible=self.State.Enabled and self.State.Box;outline.Color=self.State.BoxColor;health.Size=UDim2.new(1,0,self.State.Health/100,0);style();return self
 end
 function self:SetColor(color)return self:Update({Color=color})end
 function self:SetBoxColor(color)return self:Update({BoxColor=color})end
 function self:SetMode(mode)return self:Update({Mode=mode})end
 function self:SetEnabled(value)return self:Update({Enabled=not not value})end
 function self:SetRotation(degrees)self.Yaw=math.rad(degrees);fit();return self end
 function self:GetState()return table.clone(self.State)end
 self.PreviewFrame={UIElements={Main=root},UpdateShape=function()end,Destroy=function()root:Destroy()end,SetTitle=function(text)self.Title=text end}
 self.UIElements={Main=root,Viewport=view,World=world,Camera=camera,Box=box,Health=health,Name=name,Distance=distance}
 self:SetModel(config.Model);self:Update(config.State)
 return self.__type,self
end
return E
