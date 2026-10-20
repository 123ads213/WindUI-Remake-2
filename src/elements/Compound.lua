-- One label, independent native color + choice/switch controls and flags.
local C=require('../modules/Creator')
local E={}
function E:New(config)
 assert(not(config.Dropdown and config.Toggle),'Compound accepts Dropdown OR Toggle, not both')
 assert(config.Color or config.Dropdown or config.Toggle,'Compound needs at least one control')
 assert(not config.Flag,'Use independent Flag values on Compound.Color/Dropdown/Toggle')
 local self={__type='Compound',Title=config.Title or 'Player',UIElements={},Controls={}}
 local ef=require('../components/window/Element')({Title=self.Title,TextOffset=240,Parent=config.Parent,Window=config.Window,Tab=config.Tab,Index=config.Index,ElementTable=self,ParentConfig=config,Hover=false})
 self.CompoundFrame=ef
 local main=ef.UIElements.Main
 main.AutomaticSize='None';main.Size=UDim2.new(1,0,0,50)
 for _,v in ipairs(main:GetChildren())do if v:IsA('UIPadding')then v:Destroy()end end
 main.BackgroundTransparency=1
 if main:IsA('ImageLabel')or main:IsA('ImageButton')then if C.Objects[main]then C.Objects[main].Properties.ImageTransparency=nil;C.Objects[main].Properties.ImageColor3=nil end;main.ImageTransparency=1 end
 ef.UIElements.Container.Visible=false
 local label=ef.UIElements.Title;label.Parent=main;label.Visible=true;label.AutomaticSize='None';label.Position=UDim2.fromOffset(14,0);label.TextSize=15;label.TextWrapped=false;label.TextTruncate='AtEnd'
 local proxy={Elements={},__type='CompoundControls',CompactRows=true,UIElements=config.Tab.UIElements}
 local controls=C.New('Frame',{Parent=main,Name='Controls',AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-10,.5,0),BackgroundTransparency=1,Size=UDim2.fromOffset(0,50)})
 config.ElementsModule.Load(proxy,controls,config.ElementsModule.Elements,config.Window,config.WindUI,nil,config.ElementsModule,config.UIScale,config.Tab)
 local widths={Color=34,Dropdown=(config.Dropdown and config.Dropdown.Width)or 140,Toggle=48};local total=0
 for _,key in ipairs({'Color','Dropdown','Toggle'})do
  if config[key] then
   local cfg=table.clone(config[key]);cfg.Title='';cfg.CompactRow=true;cfg.Hotkeys=false;cfg.Width=widths[key];cfg.Desc=nil;cfg.Embedded=true
   local child=proxy[key=='Color'and 'Colorpicker'or key](proxy,cfg)
   local f=child.ElementFrame;f.AutomaticSize='None';f.Size=UDim2.fromOffset(widths[key],50);f.Position=UDim2.fromOffset(total,0)
   -- Cell frames are absolutely positioned; no nested list layouts or duplicate labels.
   local frame=child[key=='Color'and 'ColorpickerFrame'or key=='Toggle'and 'ToggleFrame'or 'DropdownFrame']
   if frame.UIElements.Title then frame.UIElements.Title.Visible=false end
   local sep=f:FindFirstChild('RowDivider');if sep then sep:Destroy()end
   local control=key=='Color'and child.UIElements.Colorpicker or key=='Dropdown'and child.UIElements.Dropdown
   if control then control.Position=UDim2.new(1,-4,.5,0);if key=='Dropdown'then control.Size=UDim2.fromOffset(widths[key]-8,30)end end
   if key=='Toggle'then for _,v in ipairs(f:GetChildren())do if v:IsA('Frame')and v:FindFirstChild('ToggleFrame')then v.Position=UDim2.new(1,-4,.5,0)end end end
   self.Controls[key]=child;self[key]=child;total+=widths[key]+4
  end
 end
 total=math.max(0,total-4);controls.Size=UDim2.fromOffset(total,50);label.Size=UDim2.new(1,-total-32,1,0)
 C.New('Frame',{Parent=main,Name='RowDivider',Position=UDim2.new(0,14,1,-1),Size=UDim2.new(1,-28,0,1),BackgroundTransparency=.95,ThemeTag={BackgroundColor3='Text'}})
 function self:GetControl(name)return self.Controls[name]end
 function self:Lock()for _,v in pairs(self.Controls)do v:Lock()end;self.Locked=true end
 function self:Unlock()for _,v in pairs(self.Controls)do v:Unlock()end;self.Locked=false end
 main.Destroying:Connect(function()
  for _,child in pairs(self.Controls)do
   child:Destroy()
   local function unregister(records)if records then for key,element in pairs(records)do if element==child then records[key]=nil end end end end
   unregister(config.Window.PendingFlags)
   if config.Window.CurrentConfig then unregister(config.Window.CurrentConfig.Elements)end
   if config.Window.ConfigManager then for _,record in pairs(config.Window.ConfigManager.Configs)do if type(record)=='table'then unregister(record.Elements)end end end
  end
 end)
 self.UIElements.Controls=controls;self.UIElements.Title=label
 if config.Locked then self:Lock()end
 return self.__type,self
end
return E
