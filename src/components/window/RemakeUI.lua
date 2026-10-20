-- Shared chrome for remake 2. Coordinates are screen-space, not magic inset offsets.
local C=require('../../modules/Creator')
local Shadow=require('../ui/PopupShadow')
local U={New=C.New,Tween=C.Tween}
local popupSerial=setmetatable({},{__mode="k"})
local fades=setmetatable({},{__mode='k'})
function U.corner(p,r) C.New('UICorner',{Parent=p,CornerRadius=UDim.new(0,r or 8)}) end
function U.text(p,text,x,y,w,h,secondary)
 return C.New('TextLabel',{Parent=p,Text=text,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,TextSize=14,TextStrokeTransparency=1,TextXAlignment='Left',TextTruncate='AtEnd',RichText=false,FontFace=Font.new(C.Font,Enum.FontWeight.Medium),ThemeTag={TextColor3=secondary and 'Placeholder' or 'Text'},ZIndex=p.ZIndex+2})
end
function U.icon(p,name,x,y,size,window)
 local im=C.Image(name,name,0,window.Folder,'RemakeIcon',true,false,'Icon');im.Parent=p;im.Position=UDim2.fromOffset(x,y);im.Size=UDim2.fromOffset(size,size);im.ZIndex=p.ZIndex+2;im.ImageLabel.ZIndex=im.ZIndex;return im
end
function U.button(p,text,x,y,w,h,fn)
 local b=C.New('TextButton',{Parent=p,Text='',Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,ThemeTag={BackgroundColor3='ElementBackground'},ZIndex=p.ZIndex+1});U.corner(b,7)
 if text~='' then local t=U.text(b,text,10,0,w-20,h);t.Name='Label' end
 b.MouseEnter:Connect(function() C.Tween(b,.12,{BackgroundTransparency=.15}):Play()end)
 b.MouseLeave:Connect(function() C.Tween(b,.12,{BackgroundTransparency=1}):Play()end)
 if fn then b.MouseButton1Click:Connect(fn)end;return b
end
function U.input(p,placeholder,x,y,w,h)
 local t=C.New('TextBox',{Parent=p,Text='',PlaceholderText=placeholder,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=.35,ClearTextOnFocus=false,TextSize=14,TextStrokeTransparency=1,TextXAlignment='Left',ClipsDescendants=true,FontFace=Font.new(C.Font,Enum.FontWeight.Medium),ThemeTag={BackgroundColor3='LabelBackground',TextColor3='Text',PlaceholderColor3='Placeholder'},ZIndex=p.ZIndex+2});U.corner(t,7);C.New('UIPadding',{Parent=t,PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)});return t
end
function U.panel(window,name,w,h,z)
 local p=C.New('CanvasGroup',{Parent=window.UIElements.Main.Main,Name=name,Size=UDim2.fromOffset(w,h),BackgroundTransparency=0,GroupTransparency=1,Visible=false,ThemeTag={BackgroundColor3='Dialog'},ZIndex=z or 800,Active=true});U.corner(p,12);Shadow.New(p,{Opacity=.6});return p
end
function U.place(p,anchor,wind)
 local s=wind.UIScaleObj.Scale;local a,b=anchor.AbsolutePosition,anchor.AbsoluteSize
 local o,z=wind.ScreenGui.AbsolutePosition,wind.ScreenGui.AbsoluteSize
 local w,h=p.Size.X.Offset*s,p.Size.Y.Offset*s
 local x=a.X;local y=a.Y+b.Y+5*s
 if y+h>o.Y+z.Y-8 then y=a.Y-h-5*s end
 x=math.clamp(x,o.X+8,math.max(o.X+8,o.X+z.X-w-8));y=math.clamp(y,o.Y+8,math.max(o.Y+8,o.Y+z.Y-h-8))
 p.Position=UDim2.fromOffset((x-p.Parent.AbsolutePosition.X)/s,(y-p.Parent.AbsolutePosition.Y)/s)
end
function U.show(p,v)
 if p:GetAttribute('TargetVisible')==v then return end;p:SetAttribute('TargetVisible',v)
 if v then p.Visible=true end
 if fades[p]then fades[p]:Cancel()end
 fades[p]=C.Tween(p,.16,{GroupTransparency=v and 0 or 1});fades[p]:Play()
 popupSerial[p]=(popupSerial[p]or 0)+1;local serial=popupSerial[p]
 if not v then task.delay(.17,function()if p.Parent and popupSerial[p]==serial and not p:GetAttribute('TargetVisible')then p.Visible=false end end)end
end
function U.inside(p,point)
 local a,z=p.AbsolutePosition,p.AbsoluteSize;return p.Visible and point.X>=a.X and point.X<=a.X+z.X and point.Y>=a.Y and point.Y<=a.Y+z.Y
end
function U.beside(p,anchor,wind,gap)
 local s=math.max(.01,wind.UIScaleObj.Scale);gap=(gap or 8)*s
 local a,z=anchor.AbsolutePosition,anchor.AbsoluteSize;local origin,size=wind.ScreenGui.AbsolutePosition,wind.ScreenGui.AbsoluteSize
 local w,h=p.Size.X.Offset*s,p.Size.Y.Offset*s
 local x=a.X+z.X+gap;local y=a.Y
 if x+w>origin.X+size.X-8 then x=a.X-w-gap end
 x=math.clamp(x,origin.X+8,math.max(origin.X+8,origin.X+size.X-w-8));y=math.clamp(y,origin.Y+8,math.max(origin.Y+8,origin.Y+size.Y-h-8))
 p.Position=UDim2.fromOffset((x-p.Parent.AbsolutePosition.X)/s,(y-p.Parent.AbsolutePosition.Y)/s)
end
function U.tooltip(window,wind,anchor,title)
 local tip=U.panel(window,'ButtonHint',math.max(100,#title*7.5+24),36,1100);tip.Active=false
 U.text(tip,title,12,0,tip.Size.X.Offset-24,36)
 local serial=0
 local function hide()serial+=1;U.show(tip,false)end
 anchor.MouseEnter:Connect(function()serial+=1;local request=serial;task.delay(.3,function()
  if request==serial and anchor.Parent and not window.Closed then U.beside(tip,anchor,wind,8);tip.Position+=UDim2.fromOffset(0,(anchor.AbsoluteSize.Y/wind.UIScaleObj.Scale-36)/2);U.show(tip,true)end
 end)end)
 anchor.MouseLeave:Connect(hide);anchor.MouseButton1Down:Connect(hide)
 anchor.Destroying:Connect(function()serial+=1;tip:Destroy()end)
 return tip
end
return U
