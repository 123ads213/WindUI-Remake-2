-- Run after RemakeExample.lua. Temporary presets and hotkeys are restored.
local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local f=d.Window.FeatureUI;local h=game:GetService('HttpService')
local n=0;local function check(v,m)n+=1;assert(v,'ReviewFixes: '..m)end
local prefix='__review_'..os.time();local names={prefix..'_A',prefix..'_Z'};local prior=p.Current;local sort=p.Sort;local value=d.Big:Get();local bindings=d.ShowPlayers:GetHotkeys()
local function click(b)firesignal(b.MouseButton1Click);task.wait(.3)end
local function run()
 for i,name in ipairs(names)do
  check(p:Create(name),'temporary preset created');local path=d.Window.ConfigManager.Path..name..'.json';local data=h:JSONDecode(readfile(path));data.__meta.created=i;data.__meta.modified=3-i;writefile(path,h:JSONEncode(data))
 end
 local function relative()local a,b;for i,name in ipairs(p.Order)do if name==names[1]then a=i elseif name==names[2]then b=i end end;return a,b end
 p.Sort='Created';p:Refresh();task.wait(.3);local a,b=relative();check(b<a,'newest first uses created timestamp');check(p.RowCache[names[2]].Slot.Position.Y.Offset<p.RowCache[names[1]].Slot.Position.Y.Offset,'rows actually move')
 p.Sort='Modified';p:Refresh();task.wait(.3);a,b=relative();check(a<b,'modified timestamp changes order')
 p.Sort='Name';p:Refresh();task.wait(.3);a,b=relative();check(a<b,'alphabetical order');check(p.RowCache[names[1]].Slot.Position.Y.Offset<p.RowCache[names[2]].Slot.Position.Y.Offset,'positions follow alphabetic order')
 d.Big:Set(123);click(p.RowCache[names[1]].Row);check(p.Current==names[1],'single row click loads');check(p.LastLoadNotification.Success,'load notification');check(d.Big:Get()~=123,'preset values applied')
 d.Big:Set(321);click(p.RowCache[names[1]].Load);check(d.Big:Get()~=321,'load icon reloads current preset instead of saving')
 for name,row in pairs(p.RowCache)do check(row.Row.BackgroundTransparency==(name==p.Current and .5 or 1),'only current row highlighted')end
 local card=d.Columns.Left:Section({Title=false});check(card.UIElements.Card:IsA('CanvasGroup'),'section clips child backgrounds');check(card.UIElements.Card:FindFirstChildOfClass('UICorner')~=nil,'section has corner');card.UIElements.Root:Destroy()
 for _,e in ipairs(d.Showcase.Layout.Elements)do if e.__type=='Group'or e.__type=='HStack'or e.__type=='VStack'then check(e.ElementFrame:IsA('CanvasGroup'),'native container clipped');check(e.ElementFrame:FindFirstChildOfClass('UICorner')~=nil,'native container rounded')end end
 check(not pcall(function()d.Player:Dropdown({Title='Invalid inline',Inline=true,Values={'A'}})end),'inline rejected on normal page')
 check(#d.Showcase.Settings.Sections==2,'embedded selection remains in settings popover')
 d.Player:Select();f:CloseAll();task.wait(.25);d.ShowPlayers:ShowDescription();task.wait(.25);local ui=f.UIElements
 check(ui.TooltipMore.Visible,'long description offers ellipsis');local width=ui.Tooltip.Size.X.Offset
 firesignal(ui.TooltipMore.MouseEnter);task.wait(.3);check(ui.Tooltip.Size.X.Offset>width,'ellipsis hover expands description');check(ui.TooltipMore.Visible and ui.TooltipMore.Text=='−','expanded description offers collapse');check(ui.TooltipBody.TextTruncate==Enum.TextTruncate.None,'description is not truncated');check(ui.TooltipScroll.CanvasSize.Y.Offset>=ui.TooltipBody.Size.Y.Offset,'entire description scrollable');f:HideDescription()
 for i=1,30 do d.ShowPlayers:AddHotkey({Key='Unbound',Mode='Toggle',Value=true})end
 f:ShowAll();task.wait(.4);local scroll=ui.AllEntries;local thumb=ui.AllScrollbar:FindFirstChildWhichIsA('GuiObject')
 check(scroll.ScrollBarThickness==0,'native scrollbar disabled');check(scroll.AbsoluteCanvasSize.Y>scroll.AbsoluteWindowSize.Y,'long list overflows');check(thumb and thumb.Visible,'custom thumb visible');local before=thumb.Position.Y.Scale
 scroll.CanvasPosition=Vector2.new(0,scroll.AbsoluteCanvasSize.Y-scroll.AbsoluteWindowSize.Y);task.wait(.2);check(thumb.Position.Y.Scale>before,'custom thumb follows scroll')
end
local ok,err=pcall(run)
f:CloseAll();f:HideDescription();d.ShowPlayers:SetHotkeys(bindings)
for _,name in ipairs(names)do if isfile(d.Window.ConfigManager.Path..name..'.json')then p:Delete(name)end end
if prior then p:Load(prior)end;p.Sort=sort;p:Refresh();d.Big:Set(value);d.Player:Select()
assert(ok,err);return{passed=n}
