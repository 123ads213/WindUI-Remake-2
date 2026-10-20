local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local Numbers = require("../modules/NumberFormat")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

local IsSliderHolding = false

function Element:New(Config)
	local Slider = {
		__type = "Slider",
		Title = Config.Title or nil,
		Desc = Config.Desc or nil,
		Locked = Config.Locked or nil,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value or {},
		Icons = Config.Icons or nil,
		IsTooltip = true,
		IsTextbox = Config.IsTextbox,
		Step = math.max(Numbers.Finite(Config.Step) or 1, 1e-9),
		Compact = Config.Compact ~= false,
		Decimals = Config.Decimals or 2,
		Format = Config.Format,
		Callback = Config.Callback or function() end,
		UIElements = {},
		IsFocusing = false,

		Width = math.max(Numbers.Finite(Config.Width) or (Config.Compact ~= false and 184 or 130), 100),
		TextBoxWidth = math.max(72, Numbers.Finite(Config.ValueWidth) or (Config.Compact ~= false and 72 or 48)),
		ThumbSize = 13,
		IconSize = 26,
	}
	if type(Slider.Icons) == "table" and next(Slider.Icons) == nil then
		Slider.Icons = {
			From = "sfsymbols:sunMinFill",
			To = "sfsymbols:sunMaxFill",
		}
	end
	if Slider.IsTextbox == nil and Slider.Title == nil then
		Slider.IsTextbox = false
	else
		Slider.IsTextbox = Slider.IsTextbox ~= false
	end

	local isTouch
	local moveconnection
	local releaseconnection
	Slider.Value.Min = Numbers.Finite(Slider.Value.Min) or 0
    Slider.Value.Max = Numbers.Finite(Slider.Value.Max) or 100
    if Slider.Value.Min > Slider.Value.Max then
        Slider.Value.Min, Slider.Value.Max = Slider.Value.Max, Slider.Value.Min
    end
    local Value = Numbers.Snap(Numbers.Finite(Slider.Value.Default) or Slider.Value.Min,
        Slider.Value.Min, Slider.Value.Max, Slider.Step)
    Slider.Value.Default = Value
    local LastValue = Value
    local delta = Numbers.Ratio(Value, Slider.Value.Min, Slider.Value.Max)
    local CanCallback = true
    local function Display(val)
        if type(Slider.Format) == "function" then
            local ok, result = pcall(Slider.Format, val)
            if ok and result ~= nil then return tostring(result) end
        end
        return Numbers.Format(val, { Compact = Slider.Compact, Decimals = Slider.Decimals })
    end

	local IconFrom, IconTo
	local TotalSliderWidth = 0
	local IconCount = 0
	if Slider.Icons then
		if Slider.Icons.From then
			IconFrom = Creator.Image(
				Slider.Icons.From,
				Slider.Icons.From,
				0,
				Config.Window.Folder,
				"SliderIconFrom",
				true,
				true,
				"SliderIconFrom"
			)
			IconFrom.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize
			IconCount += 1
		end
		if Slider.Icons.To then
			IconTo = Creator.Image(
				Slider.Icons.To,
				Slider.Icons.To,
				0,
				Config.Window.Folder,
				"SliderIconTo",
				true,
				true,
				"SliderIconTo"
			)
			IconTo.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
			TotalSliderWidth = TotalSliderWidth + Slider.IconSize
			IconCount += 1
		end
	end
	Slider.SliderFrame = require("../components/window/Element")({
		Title = Slider.Title,
        Image = Config.Image or Config.Icon,
        ImageSize = Config.ImageSize or Config.IconSize or 24,
        IconThemed = Config.IconThemed ~= false,
        ImageOffset = Config.ImageOffset or Config.IconOffset,
		Desc = Slider.Desc,
		Parent = Config.Parent,
		TextOffset = Slider.Width + 24,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		Window = Config.Window,
		ElementTable = Slider,
		ParentConfig = Config,
		Tags = Config.Tags,
	})

	Slider.UIElements.SliderIcon = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.83,
		Size = UDim2.new(1, not Slider.IsTextbox and -TotalSliderWidth or (-Slider.TextBoxWidth - 8), 0, 4),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Name = "Frame",
		ThemeTag = {
			ImageColor3 = "Icon",
		},
	}, {
		Creator.NewRoundFrame(99, "Squircle", {
			Name = "Frame",
			Size = UDim2.new(delta, 0, 1, 0),
			ImageTransparency = 0.1,
			ThemeTag = {
				ImageColor3 = "Slider",
			},
		}, {
			Creator.NewRoundFrame(99, "Squircle", {
				Size = UDim2.new(
					0,
					Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2),
					0,
					Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)
				),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ThemeTag = {
					ImageColor3 = "SliderThumb",
				},
				Name = "Thumb",
			}, {
				Creator.NewRoundFrame(999, "SquircleGlass", {
					Size = UDim2.new(1, 0, 1, 0),
					ImageColor3 = Color3.new(1, 1, 1),
					Name = "Highlight",
					ImageTransparency = 0.5,
				}),
			}),
		}),
	})

	Slider.UIElements.SliderContainer = New("Frame", {
		Size = UDim2.new(Slider.Title == nil and 1 or 0, Slider.Title == nil and 0 or Slider.Width, 0, 0),
		AutomaticSize = "Y",
		Position = UDim2.new(1, Slider.IsTextbox and (Config.Window.NewElements and -12 - 4 or 0) or 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Parent = Slider.SliderFrame.UIElements.Main,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = Slider.Icons
					and (Slider.Icons.From and (Slider.Icons.To and "Center" or "Left") or Slider.Icons.To and "Right")
				or "Center",
		}),
		IconFrom,
		Slider.UIElements.SliderIcon,
		IconTo,
		New("TextBox", {
			Size = UDim2.new(0, Slider.TextBoxWidth, 0, 0),
			TextXAlignment = "Left",
			Text = Display(Value),
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			ThemeTag = {
				TextColor3 = "Text",
			},
			TextTransparency = 0.4,
			AutomaticSize = "Y",
			TextSize = 15,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Visible = Slider.IsTextbox,
		}),
	})

    -- Thin track plus a stable inline value editor, like the reference.
    local track = Slider.UIElements.SliderIcon
    track.Frame.Thumb.Visible = false
    track.LayoutOrder = 1
    local TextBox = Slider.UIElements.SliderContainer.TextBox
    local layout=Slider.UIElements.SliderContainer:FindFirstChildOfClass('UIListLayout')
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    TextBox.LayoutOrder=2
    TextBox.AutomaticSize=Enum.AutomaticSize.None
    TextBox.Size=UDim2.fromOffset(Slider.TextBoxWidth,30)
    TextBox.BackgroundTransparency=.65
    TextBox.TextTransparency=0
    TextBox.TextXAlignment=Enum.TextXAlignment.Center
    TextBox.TextSize=14
    TextBox.TextEditable=Slider.IsTextbox
    TextBox.ClipsDescendants=true
    Creator.AddThemeObject(TextBox,{BackgroundColor3='Button',TextColor3='Text'})
    New('UICorner',{Parent=TextBox,CornerRadius=UDim.new(0,6)})
    local popupParent = Config.Window.UIElements.Main.Main
    local HoverText=New('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,TextTransparency=0,
        TextXAlignment='Center',TextSize=14,FontFace=Font.new(Creator.Font,Enum.FontWeight.Medium),
        ThemeTag={TextColor3='Text'},ZIndex=851})
    local HoverScale=New('UIScale',{Scale=.96})
    local HoverValue=New('CanvasGroup',{
        Parent=popupParent,Name='SliderDragValue',Size=UDim2.fromOffset(72,28),AnchorPoint=Vector2.new(.5,1),
        BackgroundTransparency=.1,GroupTransparency=1,ZIndex=850,Visible=false,
        ThemeTag={BackgroundColor3='Button'},
    },{New('UICorner',{CornerRadius=UDim.new(0,7)}),HoverText,HoverScale})
    require('../components/ui/PopupShadow').New(HoverValue,{Opacity=.12})
    local valueFade,scaleFade,fadeSerial=nil,nil,0
    Slider.UIElements.HoverValue=HoverValue
    Slider.UIElements.ValueInput=TextBox
    local ScrollingFrameParent = Config.Tab.UIElements.ContainerFrame
    local CurInput = Config.WindUI.GenerateGUID()
    local PreviousScrolling
    local DragX, DragWidth
    local Holding = false
    local Destroyed = false

    local function PositionValue()
        if not track.Parent or not popupParent.Parent then return end
        local scale = math.max(.01, Config.WindUI.UIScaleObj.Scale)
        local ratio = Numbers.Ratio(LastValue,Slider.Value.Min,Slider.Value.Max)
        local x = track.AbsolutePosition.X + ratio*track.AbsoluteSize.X
        -- A floating feature panel can sit outside the main menu. Clamp to the
        -- slider's owning popup, not the main window, or the number jumps sideways.
        local bounds=popupParent
        local ancestor=track.Parent
        while ancestor and ancestor~=popupParent do
            if ancestor:IsA('GuiObject')and ancestor.Name=='FeatureSettings'then bounds=ancestor;break end
            ancestor=ancestor.Parent
        end
        local half=HoverValue.Size.X.Offset*scale*.5
        local left=bounds.AbsolutePosition.X+half+4
        local right=math.max(left,bounds.AbsolutePosition.X+bounds.AbsoluteSize.X-half-4)
        local bottom=math.clamp(track.AbsolutePosition.Y-4,bounds.AbsolutePosition.Y+28,math.max(bounds.AbsolutePosition.Y+28,bounds.AbsolutePosition.Y+bounds.AbsoluteSize.Y-4))
        HoverValue.Position=UDim2.fromOffset((math.clamp(x,left,right)-popupParent.AbsolutePosition.X)/scale,(bottom-popupParent.AbsolutePosition.Y)/scale)
    end
    local function ShowValue(show)
        show=show and Holding and not Slider.Locked
        if HoverValue:GetAttribute('Shown')==show then return end
        HoverValue:SetAttribute('Shown',show);fadeSerial+=1;local serial=fadeSerial
        if valueFade then valueFade:Cancel()end
        if scaleFade then scaleFade:Cancel()end
        if show then HoverValue.Visible=true;PositionValue()end
        valueFade=Tween(HoverValue,.12,{GroupTransparency=show and 0 or 1});valueFade:Play()
        scaleFade=Tween(HoverScale,.12,{Scale=show and 1 or .96});scaleFade:Play()
        if not show then task.delay(.13,function()if not Destroyed and serial==fadeSerial then HoverValue.Visible=false end end)end
    end
    local fillTween,fieldSizeTween,trackSizeTween
    local function Render(instant)
        if Destroyed then return end
        TextBox.Text = Slider.IsFocusing and Numbers.Plain(LastValue) or Display(LastValue)
        local gapWidth=12*(IconCount+(Slider.IsTextbox and 1 or 0))
        local scale=math.max(.01,Config.WindUI.UIScaleObj.Scale)
        local controlWidth=Slider.UIElements.SliderContainer.AbsoluteSize.X/scale
        local maxField=math.max(Slider.TextBoxWidth,controlWidth-TotalSliderWidth-gapWidth-48)
        local fieldWidth=Slider.IsFocusing and math.min(maxField,math.max(Slider.TextBoxWidth,#TextBox.Text*8+20)) or Slider.TextBoxWidth
        local fieldSize=UDim2.fromOffset(fieldWidth,30)
        local trackSize=UDim2.new(1,-TotalSliderWidth-gapWidth-(Slider.IsTextbox and fieldWidth or 0),0,4)
        if fieldSizeTween then fieldSizeTween:Cancel()end
        if trackSizeTween then trackSizeTween:Cancel()end
        fieldSizeTween=Tween(TextBox,.16,{Size=fieldSize});fieldSizeTween:Play()
        trackSizeTween=Tween(track,.16,{Size=trackSize});trackSizeTween:Play()
        local text=Display(LastValue)
        HoverText.Text=text
        HoverValue.Size=UDim2.fromOffset(math.max(64,math.min(280,#text*8+20)),28)
        local size=UDim2.new(Numbers.Ratio(LastValue,Slider.Value.Min,Slider.Value.Max),0,1,0)
        if fillTween then fillTween:Cancel()end
        if instant or Holding then track.Frame.Size=size else fillTween=Tween(track.Frame,.12,{Size=size});fillTween:Play() end
        if HoverValue.Visible then PositionValue() end
    end

    local function StopDrag()
        if moveconnection then moveconnection:Disconnect(); moveconnection = nil end
        if releaseconnection then releaseconnection:Disconnect(); releaseconnection = nil end
        if not Holding then return end
        Holding = false
        IsSliderHolding = false
        ScrollingFrameParent.ScrollingEnabled = PreviousScrolling
        if Config.WindUI.CurrentInput == CurInput then Config.WindUI.CurrentInput = nil end
        if not Destroyed then
            ShowValue(false)
        end
    end

    function Slider:Set(newValue)
        if not CanCallback or Destroyed then return LastValue end
        local snapped = Numbers.Snap(newValue, Slider.Value.Min, Slider.Value.Max, Slider.Step)
        if not snapped then Render(true); return LastValue end
        local changed = snapped ~= LastValue
        LastValue = snapped
        Value = snapped
        Slider.Value.Default = snapped
        Render(not changed)
        if changed then Creator.SafeCallback(Slider.Callback, snapped) end
        return snapped
    end

    function Slider:Get() return LastValue end

    function Slider:SetRange(newMin, newMax)
        newMin, newMax = Numbers.Finite(newMin), Numbers.Finite(newMax)
        if not newMin or not newMax then return Slider.Value.Min, Slider.Value.Max end
        if newMin > newMax then newMin, newMax = newMax, newMin end
        Slider.Value.Min, Slider.Value.Max = newMin, newMax
        -- Bounds must update even on a locked slider; only user callbacks remain suppressed.
        local snapped = Numbers.Snap(LastValue, newMin, newMax, Slider.Step)
        local changed = snapped ~= LastValue
        LastValue, Value, Slider.Value.Default = snapped, snapped, snapped
        Render(false)
        if changed and CanCallback then Creator.SafeCallback(Slider.Callback, snapped) end
        return newMin, newMax
    end

    function Slider:SetMin(newMin)
        newMin = Numbers.Finite(newMin)
        if newMin then Slider:SetRange(newMin, math.max(newMin, Slider.Value.Max)) end
        return Slider.Value.Min
    end
    function Slider:SetMax(newMax)
        newMax = Numbers.Finite(newMax)
        if newMax then Slider:SetRange(math.min(Slider.Value.Min, newMax), newMax) end
        return Slider.Value.Max
    end
    function Slider:Lock()
        StopDrag()
        Slider.Locked, CanCallback = true, false
        TextBox.TextEditable = false
        ShowValue(false)
        return Slider.SliderFrame:Lock(Slider.LockedTitle)
    end
    function Slider:Unlock()
        Slider.Locked, CanCallback = false, true
        TextBox.TextEditable = Slider.IsTextbox
        return Slider.SliderFrame:Unlock()
    end

    Creator.AddSignal(TextBox.Focused, function()
        if Slider.Locked then TextBox:ReleaseFocus(); return end
        Slider.IsFocusing = true
        Tween(TextBox,.16,{BackgroundTransparency=.2}):Play()
        ShowValue(false)
        Render(true) -- Edit the full exact number, never a rounded abbreviation.
        TextBox.CursorPosition=#TextBox.Text+1;TextBox.SelectionStart=1
    end)
    Creator.AddSignal(TextBox.FocusLost, function()
        local parsed = Numbers.Parse(TextBox.Text)
        Slider.IsFocusing = false
        Tween(TextBox,.16,{BackgroundTransparency=.65}):Play()
        if parsed then Slider:Set(parsed) end
        Render(true) -- Restore even if parsing failed or the value did not change.
        ShowValue(false)
    end)

    local function ReadPointer(input)
        local x = isTouch and input.Position.X or UserInputService:GetMouseLocation().X
        local track = Slider.UIElements.SliderIcon
        if not DragWidth or DragWidth <= 0 then return end
        local ratio = math.clamp((x - DragX) / DragWidth, 0, 1)
        Slider:Set(Slider.Value.Min + ratio * (Slider.Value.Max - Slider.Value.Min))
    end
    Creator.AddSignal(Slider.UIElements.SliderContainer.InputBegan, function(input)
        if Slider.Locked or Slider.IsFocusing or IsSliderHolding then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        -- The numeric editor must not start a drag when clicked/tapped.
        local p = input.Position
        if TextBox.Visible and Slider.IsTextbox and p.X >= TextBox.AbsolutePosition.X
            and p.X <= TextBox.AbsolutePosition.X + TextBox.AbsoluteSize.X
            and p.Y >= TextBox.AbsolutePosition.Y
            and p.Y <= TextBox.AbsolutePosition.Y + TextBox.AbsoluteSize.Y then return end
        if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput ~= CurInput then return end
        Config.WindUI.CurrentInput = CurInput
        Holding, IsSliderHolding = true, true
        isTouch = input.UserInputType == Enum.UserInputType.Touch
        PreviousScrolling = ScrollingFrameParent.ScrollingEnabled
        ScrollingFrameParent.ScrollingEnabled = false
        DragX = Slider.UIElements.SliderIcon.AbsolutePosition.X
        DragWidth = Slider.UIElements.SliderIcon.AbsoluteSize.X
        ReadPointer(input)
        moveconnection = RunService.RenderStepped:Connect(function() ReadPointer(input) end)
        releaseconnection = UserInputService.InputEnded:Connect(function(ended)
            if (isTouch and ended == input) or (not isTouch and ended.UserInputType == Enum.UserInputType.MouseButton1) then
                StopDrag()
            end
        end)
        ShowValue(true)
    end)
    Creator.AddSignal(TextBox.MouseEnter,function()if not Slider.Locked then Tween(TextBox,.16,{BackgroundTransparency=.4}):Play() end end)
    Creator.AddSignal(TextBox.MouseLeave,function()if not Slider.IsFocusing then Tween(TextBox,.16,{BackgroundTransparency=.65}):Play() end end)
    local hovering=false
    local heldArrow=nil;local arrowAge,arrowRepeat=0,0
    local function CanUseArrows()
        local point=UserInputService:GetMouseLocation()+Config.WindUI.ScreenGui.AbsolutePosition;local control=Slider.UIElements.SliderContainer
        local a,z=control.AbsolutePosition,control.AbsoluteSize
        local inside=point.X>=a.X and point.X<=a.X+z.X and point.Y>=a.Y and point.Y<=a.Y+z.Y
        if not inside or Destroyed or Slider.Locked or Config.Window.Closed or game:GetService('GuiService').MenuIsOpen or UserInputService:GetFocusedTextBox() then return false end
        if Config.WindUI.CurrentInput and Config.WindUI.CurrentInput~=CurInput then return false end
        local parent=track
        while parent do
            if parent:IsA('GuiObject') and (not parent.Visible or parent:GetAttribute('WindUIHidden')) then return false end
            if parent==popupParent then break end;parent=parent.Parent
        end
        return true
    end
    local function ArrowStep(key)
        if not CanUseArrows() then return false end
        Slider:Set(LastValue+(key==Enum.KeyCode.Right and Slider.Step or -Slider.Step))
        return true
    end
    Creator.AddSignal(Slider.UIElements.SliderContainer.MouseEnter,function()hovering=true end)
    Creator.AddSignal(Slider.UIElements.SliderContainer.MouseLeave,function()hovering=false end)
    Creator.AddSignal(UserInputService.InputBegan,function(input,processed)
        local key=input.KeyCode
        if key~=Enum.KeyCode.Left and key~=Enum.KeyCode.Right then return end
        if ArrowStep(key) then heldArrow=key;arrowAge=0;arrowRepeat=0 end
    end)
    Creator.AddSignal(UserInputService.InputEnded,function(input)if input.KeyCode==heldArrow then heldArrow=nil end end)
    Creator.AddSignal(RunService.Heartbeat,function(dt)
        if not heldArrow then return end
        if not CanUseArrows() then heldArrow=nil;return end
        arrowAge+=dt
        if arrowAge>.32 then arrowRepeat+=dt;if arrowRepeat>=.06 then arrowRepeat=0;ArrowStep(heldArrow)end end
    end)
    Creator.AddSignal(UserInputService.WindowFocusReleased,function()hovering=false;heldArrow=nil;StopDrag()end)
    Creator.AddSignal(Slider.UIElements.SliderContainer:GetPropertyChangedSignal("AbsoluteSize"), function() Render(true) end)
    Creator.AddSignal(RunService.RenderStepped,function()
        if Destroyed or not HoverValue.Visible then return end
        local parent=track;local visible=true
        while parent and parent~=popupParent do
            if parent:IsA('GuiObject') and not parent.Visible then visible=false;break end
            parent=parent.Parent
        end
        local viewport=Config.Tab.UIElements.ContainerFrame
        local y=track.AbsolutePosition.Y
        if not visible or not popupParent.Visible or y<viewport.AbsolutePosition.Y or y>viewport.AbsolutePosition.Y+viewport.AbsoluteSize.Y then
            StopDrag();ShowValue(false)
        else PositionValue() end
    end)
    Creator.AddSignal(Slider.UIElements.SliderContainer.Destroying, function()
        Destroyed = true
        StopDrag()
        HoverValue:Destroy()
    end)
    Render(true)
    if Slider.Locked then Slider:Lock() end
    return Slider.__type, Slider
end

return Element
