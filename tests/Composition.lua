local d=assert(getgenv().WindUIForkDemo);local passed=0
local function check(v,msg)assert(v,msg);passed+=1 end
local original=d.Library:GetCurrentTheme()
d.ThemeDropdown:Select('Dark');d.Profile:Close();d.Window:SelectTab(d.PreviewTab.Index);task.wait(.5)
check(d.Library.Creator.Theme.Name=='Dark','theme selected')
local theme=d.Library:GetThemes().Dark
check(theme.Primary:ToHex()=='0091ff','sampled accent')
check(theme.Background:ToHex()=='101010','sampled sidebar')
check(theme.ElementBackground:ToHex()=='2a2a2c','sampled card')
check(d.Presets.UIElements.Toolbar:FindFirstChild('SaveDivider')~=nil,'save/name divider')
check(d.Presets.UIElements.Trigger:GetAttribute('NoHover'),'preset trigger has no hover fill')
check(d.Presets.UIElements.Save:GetAttribute('NoHover'),'save has no hover fill')
local r=d.ModelRow;local b=d.BoxRow;local p=d.PlayerMock
check(r.Dropdown.UIElements.Dropdown:GetAttribute('NoHover'),'dropdown no hover fill')
check(r.Dropdown.UIElements.Dropdown.BackgroundTransparency==0,'permanent choice surface')
check(r:GetControl('Color')==r.Color,'child access')
check(r:GetControl('Dropdown')==r.Dropdown,'choice access')
local track=b.Toggle.ElementFrame.CompactToggle.ToggleFrame
check(track.Size==UDim2.fromOffset(40,24),'small track')
check(track.Thumb.Size==UDim2.fromOffset(20,20),'round thumb size')
check(track.Thumb.UICorner.CornerRadius.Scale==1,'circular thumb')
local originalState=p:GetState();local originalColor=r.Color:GetValue();local originalMode=r.Dropdown.Value;local originalBox=b.Toggle.Value
r.Color:SetState(Color3.fromRGB(100,180,80),true);task.wait(.1)
check(p.State.Color==Color3.fromRGB(100,180,80),'color callback to mock')
for _,part in ipairs(p.Model:GetChildren())do check(part.Color==p.State.Color,'model recolors')end
r.Dropdown:Select('Ghost');task.wait(.1);check(p.State.Mode=='Ghost','mode callback')
check(math.abs(p.Model.Head.Transparency-.55)<.0001,'ghost transparency')
r.Dropdown:Open();task.wait(.2);check(r.Dropdown.Opened and r.Dropdown.UIElements.MenuCanvas.Visible,'native choice popup')
r.Dropdown:Close();r.Color:Open();task.wait(.2);check(r.Color.Editor~=nil,'native color editor');r.Color.Editor:Close()
b.Toggle:Set(false,true);task.wait(.03);check(track.Thumb.Position.X.Offset>2 and track.Thumb.Position.X.Offset<18,'thumb really animates between endpoints');check(track.BackgroundColor3~=theme.Toggle and track.BackgroundColor3~=theme.Background,'track color really animates between endpoints');task.wait(.2);check(not p.State.Box and not p.UIElements.Box.Visible,'compound toggle callback')
b.Toggle:Set(true,true);task.wait(.2);check(p.UIElements.Box.Visible,'box can re-enable')
check(track.Thumb.Position.X.Offset==18,'enabled thumb position')
r:Lock();check(r.Color.Locked and r.Dropdown.Locked,'row locks children');r:Unlock();check(not r.Color.Locked and not r.Dropdown.Locked,'row unlock')
p:Update({Health=40,Name='Unit mock',Distance='42m'});check(math.abs(p.UIElements.Health.Size.Y.Scale-.4)<.0001,'health ratio');check(p.UIElements.Name.Text=='Unit mock','name updates')
p:SetRotation(40);check(math.abs(p.Yaw-math.rad(40))<.001,'rotation')
p:SetEnabled(false);check(not p.UIElements.Viewport.Visible,'preview hide');p:SetEnabled(true)
p:SetBoxColor(Color3.fromRGB(255,90,70));p:SetColor(Color3.new(1,1,1));check(p.UIElements.Box.UIStroke.Color==Color3.fromRGB(255,90,70),'box color independent of model color')
local copy=p:GetState();copy.Health=99;check(p.State.Health==40,'detached state')
local external=p.Model:Clone();local script=Instance.new('Script');script.Parent=external
p:SetModel(external);check(p.Model~=external and not external.Parent,'source model not reparented');check(not p.Model:FindFirstChildWhichIsA('LuaSourceContainer',true),'scripts stripped');check(external:FindFirstChildWhichIsA('Script')~=nil,'source script untouched');external:Destroy();p:SetModel(nil);check(#p.Model:GetChildren()==6,'default dummy restored')
-- Flag roundtrip must restore each child's state and the connected preview.
local name='__composition_test';local saved=d.Presets.Current
r.Color:SetState(Color3.fromHex('A4A738'),true);r.Dropdown:Select('Neon');b.Toggle:Set(true,true);task.wait(.1)
check(d.Presets:Create(name),'temporary preset created')
r.Color:SetState(Color3.fromHex('FF0000'),true);r.Dropdown:Select('Ghost');b.Toggle:Set(false,true);task.wait(.1)
check(d.Presets:Load(name),'temporary preset loaded');task.wait(.2)
check(r.Color.Default:ToHex()=='a4a738','persisted color');check(p.State.Color:ToHex()=='a4a738','loaded color callback');check(r.Dropdown.Value=='Neon'and p.State.Mode=='Neon','loaded mode callback');check(b.Toggle.Value and p.State.Box,'loaded toggle callback')
check(d.Presets:Delete(name),'temporary preset removed');if saved then d.Presets:Load(saved)end
r.Color:SetState(originalColor,true);r.Dropdown:Select(originalMode);b.Toggle:Set(originalBox,true);p:Update(originalState)
-- Root teardown removes native children from all-elements and destroys floating UI.
local parent=r.ElementFrame.Parent;local before=#d.Window.AllElements
local temp=d.Columns.Left:Section({Title='Cleanup'})
local row=temp:Compound({Title='Temporary',Color={Flag='__compound_cleanup_color',Default=Color3.new(1,0,0)},Toggle={Flag='__compound_cleanup_toggle',Value=true}})
local color=row.Color;local switch=row.Toggle;row:Destroy();task.wait(.3)
check(not table.find(d.Window.AllElements,row),'root unregistered');check(not table.find(d.Window.AllElements,color),'color unregistered');check(not table.find(d.Window.AllElements,switch),'switch unregistered');check(d.Window.PendingFlags.__compound_cleanup_color==nil,'color flag cleaned');check(d.Window.PendingFlags.__compound_cleanup_toggle==nil,'toggle flag cleaned');temp.UIElements.Root:Destroy()
d.ThemeDropdown:Select('Dark');task.wait(.2)
return {passed=passed,theme=d.Library:GetCurrentTheme(),size=tostring(track.Size)}
