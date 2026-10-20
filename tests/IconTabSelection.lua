local d=assert(getgenv().WindUIForkDemo)
local tabs=d.Pages;local count=0
local function check(ok,msg)assert(ok,msg);count+=1 end
d.Player:Select();tabs:Select('enemies');task.wait(.25)
local page=tabs.Pages[tabs.Selected];local root=page.UIElements.Root
local changes=0;local signal=root:GetPropertyChangedSignal('GroupTransparency'):Connect(function()changes+=1 end)
check(tabs:Select(tabs.Selected)==true,'numeric reselect succeeds')
check(tabs:Select(page.Id)==true,'id reselect succeeds')
for i=1,8 do firesignal(page.Button.MouseButton1Click)end
task.wait(.25)
check(changes==0,'repeated active clicks never restart page fade')
check(root.Visible and root.GroupTransparency==0,'active content stays visible')
check(tabs:Select('__missing_page')==false,'invalid id rejected')
check(tabs.Selected==1,'invalid selection keeps current page')
check(tabs:Select(2),'other page still selectable');task.wait(.04)
local nextRoot=tabs.Pages[2].UIElements.Root;local alpha=nextRoot.GroupTransparency
check(alpha>0 and alpha<1,'real page switch still animates')
firesignal(tabs.Pages[2].Button.MouseButton1Click)
check(nextRoot.GroupTransparency<=alpha,'reselect during transition does not reset opacity')
task.wait(.25);check(nextRoot.Visible and nextRoot.GroupTransparency==0,'new page settles visible')
check(not root.Visible,'previous page is hidden')
tabs:Select('enemies');task.wait(.25)
changes=0
local vim=game:GetService('VirtualInputManager');local p=page.Button.AbsolutePosition+page.Button.AbsoluteSize/2-d.Library.ScreenGui.AbsolutePosition
vim:SendMouseMoveEvent(p.X,p.Y,game);vim:SendMouseButtonEvent(p.X,p.Y,0,true,game,0);vim:SendMouseButtonEvent(p.X,p.Y,0,false,game,0);task.wait(.25)
check(changes==0 and root.GroupTransparency==0,'real pointer active click is a no-op')
signal:Disconnect()
return {passed=count,selected=tabs.Selected,activeClickOpacityChanges=changes}
