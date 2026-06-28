local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Core = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local v2, v3 = Vector2.new, Vector3.new
local udim2, udim = UDim2.new, UDim.new
local rgb, hsv = Color3.fromRGB, Color3.fromHSV

local Colors = {
	Accent = rgb(155, 132, 178),      -- #9b84b2
	AccentDim = rgb(107, 88, 130),    -- #6b5882
	Background = rgb(10, 10, 10),     -- #0a0a0a
	BgLight = rgb(19, 19, 19),       -- #131313
	BgHover = rgb(30, 30, 30),       -- #1e1e1e
	SidebarBg = rgb(19, 19, 19),     -- #131313
	ElementBg = rgb(19, 19, 19),     -- #131313
	InlineBg = rgb(19, 19, 19),      -- #131313
	Border = rgb(35, 35, 35),        -- #232323
	BorderHover = rgb(46, 46, 46),   -- #2e2e2e
	BorderDark = rgb(35, 35, 35),    -- #232323
	Text = rgb(232, 232, 232),       -- #e8e8e8
	TextDim = rgb(85, 85, 85),       -- #555
	TextMid = rgb(153, 153, 153),    -- #999
	TextDark = rgb(85, 85, 85),      -- #555
	TextDarker = rgb(85, 85, 85),    -- #555
	Circle = rgb(232, 232, 232),     -- #e8e8e8
	Icon = rgb(153, 153, 153)        -- #999
}

local Library = {
	Flags = {},
	Connections = {},
	OpenElement = {},
	TweenSpeed = 0.3,
	TweenStyle = Enum.EasingStyle.Quint
}
Library.__index = Library

function Library:Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	if class == "TextButton" then obj.AutoButtonColor = false end
	return obj
end

function Library:Tween(obj, props, time)
	local tween = TweenService:Create(obj, TweenInfo.new(time or Library.TweenSpeed, Library.TweenStyle), props)
	tween:Play()
	return tween
end

function Library:Connection(signal, callback)
	local conn = signal:Connect(callback)
	table.insert(Library.Connections, conn)
	return conn
end

function Library:Hovering(obj)
	if type(obj) == "table" then
		for _, o in ipairs(obj) do
			if Library:Hovering(o) then return true end
		end
		return false
	end
	local x = Mouse.X >= obj.AbsolutePosition.X and Mouse.X <= obj.AbsolutePosition.X + obj.AbsoluteSize.X
	local y = Mouse.Y >= obj.AbsolutePosition.Y and Mouse.Y <= obj.AbsolutePosition.Y + obj.AbsoluteSize.Y
	return x and y
end

function Library:Draggify(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	Library:Connection(UserInputService.InputChanged, function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local newX = math.clamp(startPos.X.Offset + delta.X, 0, Camera.ViewportSize.X - frame.Size.X.Offset)
			local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, Camera.ViewportSize.Y - frame.Size.Y.Offset)
			Library:Tween(frame, {Position = udim2(0, newX, 0, newY)}, 0.1)
		end
	end)
end

function Library:Round(num, decimal)
	local mult = 10 ^ (decimal or 0)
	return math.floor(num * mult + 0.5) / mult
end

function Library:Unload()
	if Library.ScreenGui then Library.ScreenGui:Destroy() end
	for _, conn in ipairs(Library.Connections) do conn:Disconnect() end
end

function Library:Window(props)
	local Window = {
		Name = props.Name or "Window",
		Size = props.Size or udim2(0, 780, 0, 520),
		Tabs = {},
		CurrentTab = nil
	}

	Library.ScreenGui = Library:Create("ScreenGui", {
		Parent = Core,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true
	})

	Window.Frame = Library:Create("Frame", {
		Parent = Library.ScreenGui,
		Position = udim2(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2),
		Size = Window.Size,
		BackgroundColor3 = Colors.Background,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Window.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Window.Frame,
		Color = Colors.Border,
		Thickness = 1,
		Transparency = 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})

	Library:Draggify(Window.Frame)
	Library.Main = Window.Frame

	Window.TopBar = Library:Create("Frame", {
		Parent = Window.Frame,
		Size = udim2(1, 0, 0, 60),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Window.TopBar, CornerRadius = udim(0, 8)})

	Window.Title = Library:Create("TextLabel", {
		Parent = Window.TopBar,
		Position = udim2(0, 20, 0.5, 0),
		Size = udim2(0, 200, 0, 30),
		AnchorPoint = v2(0, 0.5),
		BackgroundTransparency = 1,
		Text = Window.Name,
		TextColor3 = Colors.Text,
		TextSize = 22,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamBold
	})

	Window.Version = Library:Create("TextLabel", {
		Parent = Window.TopBar,
		Position = udim2(1, -20, 0.5, 0),
		Size = udim2(0, 100, 0, 20),
		AnchorPoint = v2(1, 0.5),
		BackgroundTransparency = 1,
		Text = "v2.0",
		TextColor3 = Colors.TextDim,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.GothamMedium
	})

	Window.Sidebar = Library:Create("Frame", {
		Parent = Window.Frame,
		Position = udim2(0, 0, 0, 60),
		Size = udim2(0, 120, 1, -60),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Window.Sidebar, CornerRadius = udim(0, 8)})
	Library:Create("Frame", {
		Parent = Window.Sidebar,
		Position = udim2(1, -1, 0, 0),
		Size = udim2(0, 1, 1, 0),
		BackgroundColor3 = Colors.Border,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})

	Window.TabHolder = Library:Create("Frame", {
		Parent = Window.Sidebar,
		Position = udim2(0.5, 0, 0, 10),
		Size = udim2(1, -20, 1, -20),
		AnchorPoint = v2(0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
	Library:Create("UIListLayout", {
		Parent = Window.TabHolder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = udim(0, 12),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	-- Content area
	Window.Content = Library:Create("Frame", {
		Parent = Window.Frame,
		Position = udim2(0, 130, 0, 70),
		Size = udim2(1, -140, 1, -80),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	return setmetatable(Window, Library)
end

function Library:Tab(props)
	local Tab = {
		Name = props.Name or "Tab",
		Sections = {},
		Active = false,
		Window = self
	}

	Tab.Button = Library:Create("TextButton", {
		Parent = self.TabHolder,
		Size = udim2(1, 0, 0, 55),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = ""
	})
	Library:Create("UICorner", {Parent = Tab.Button, CornerRadius = udim(0, 8)})

	Tab.Icon = Library:Create("TextLabel", {
		Parent = Tab.Button,
		Size = udim2(1, -10, 0, 25),
		Position = udim2(0.5, 0, 0, 8),
		AnchorPoint = v2(0.5, 0),
		BackgroundTransparency = 1,
		Text = string.sub(Tab.Name, 1, 1):upper(),
		TextColor3 = Colors.Icon,
		TextSize = 20,
		Font = Enum.Font.GothamBold
	})

	Tab.Label = Library:Create("TextLabel", {
		Parent = Tab.Button,
		Size = udim2(1, -10, 0, 18),
		Position = udim2(0.5, 0, 1, -5),
		AnchorPoint = v2(0.5, 1),
		BackgroundTransparency = 1,
		Text = Tab.Name,
		TextColor3 = Colors.TextDim,
		TextSize = 12,
		Font = Enum.Font.GothamMedium
	})

	Tab.Stroke = Library:Create("UIStroke", {
		Parent = Tab.Button,
		Color = Colors.Border,
		Transparency = 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1
	})

	Tab.Page = Library:Create("ScrollingFrame", {
		Parent = self.Content,
		Size = udim2(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Colors.Accent,
		CanvasSize = udim2(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	})
	Library:Create("UIListLayout", {
		Parent = Tab.Page,
		Padding = udim(0, 15),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	Library:Create("UIPadding", {
		Parent = Tab.Page,
		PaddingTop = udim(0, 10),
		PaddingBottom = udim(0, 10),
		PaddingLeft = udim(0, 10),
		PaddingRight = udim(0, 10)
	})

	function Tab:Activate()
		if self.Active then return end
		local window = self.Window

		if window.CurrentTab then
			window.CurrentTab.Page.Visible = false
			Library:Tween(window.CurrentTab.Button, {BackgroundColor3 = Colors.BgLight})
			Library:Tween(window.CurrentTab.Icon, {TextColor3 = Colors.Icon})
			Library:Tween(window.CurrentTab.Label, {TextColor3 = Colors.TextDim})
			Library:Tween(window.CurrentTab.Stroke, {Color = Colors.Border})
			window.CurrentTab.Active = false
		end

		self.Page.Visible = true
		Library:Tween(self.Button, {BackgroundColor3 = Colors.BgHover})
		Library:Tween(self.Icon, {TextColor3 = Colors.Accent})
		Library:Tween(self.Label, {TextColor3 = Colors.Text})
		Library:Tween(self.Stroke, {Color = Colors.Accent})
		self.Active = true
		window.CurrentTab = self
	end

	Tab.Button.MouseEnter:Connect(function()
		if not Tab.Active then Library:Tween(Tab.Button, {BackgroundColor3 = Colors.BgHover}) end
	end)
	Tab.Button.MouseLeave:Connect(function()
		if not Tab.Active then Library:Tween(Tab.Button, {BackgroundColor3 = Colors.BgLight}) end
	end)
	Tab.Button.MouseButton1Click:Connect(function()
		Tab:Activate()
	end)

	table.insert(self.Tabs, Tab)
	if not self.CurrentTab then Tab:Activate() end

	return setmetatable(Tab, Library)
end

function Library:Section(props)
	local Section = {
		Name = props.Name or "Section",
		Elements = {}
	}

	Section.Frame = Library:Create("Frame", {
		Parent = self.Page,
		Size = udim2(1, 0, 0, 0),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	Library:Create("UICorner", {Parent = Section.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Section.Frame,
		Color = Colors.Border,
		Transparency = 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1
	})

	Section.Header = Library:Create("Frame", {
		Parent = Section.Frame,
		Size = udim2(1, 0, 0, 40),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Section.Header, CornerRadius = udim(0, 8)})

	Section.Label = Library:Create("TextLabel", {
		Parent = Section.Header,
		Position = udim2(0, 18, 0.5, 0),
		Size = udim2(1, -36, 1, 0),
		AnchorPoint = v2(0, 0.5),
		BackgroundTransparency = 1,
		Text = Section.Name,
		TextColor3 = Colors.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	Section.Container = Library:Create("Frame", {
		Parent = Section.Frame,
		Position = udim2(0, 0, 0, 50),
		Size = udim2(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y
	})

	Section.List = Library:Create("Frame", {
		Parent = Section.Container,
		Size = udim2(1, -20, 0, 0),
		Position = udim2(0.5, 0, 0, 0),
		AnchorPoint = v2(0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	Library:Create("UIListLayout", {
		Parent = Section.List,
		Padding = udim(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	Library:Create("UIPadding", {
		Parent = Section.List,
		PaddingTop = udim(0, 10),
		PaddingBottom = udim(0, 15),
		PaddingLeft = udim(0, 10),
		PaddingRight = udim(0, 10)
	})

	return setmetatable(Section, Library)
end

function Library:Toggle(props)
	local Toggle = {
		Name = props.Name or "Toggle",
		Flag = props.Flag or props.Name or "Toggle",
		Default = props.Default or false,
		Callback = props.Callback or function() end,
		Value = props.Default or false
	}

	Library.Flags[Toggle.Flag] = Toggle.Value

	Toggle.Frame = Library:Create("TextButton", {
		Parent = self.List,
		Size = udim2(1, 0, 0, 35),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = ""
	})
	Library:Create("UICorner", {Parent = Toggle.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Toggle.Frame,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Toggle.Label = Library:Create("TextLabel", {
		Parent = Toggle.Frame,
		Size = udim2(0.65, 0, 1, 0),
		Position = udim2(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = Toggle.Name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium
	})

	Toggle.Switch = Library:Create("Frame", {
		Parent = Toggle.Frame,
		Position = udim2(1, -10, 0.5, 0),
		AnchorPoint = v2(1, 0.5),
		Size = udim2(0, 42, 0, 20),
		BackgroundColor3 = Colors.BgHover,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Toggle.Switch, CornerRadius = udim(1, 0)})
	Library:Create("UIStroke", {
		Parent = Toggle.Switch,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Toggle.Circle = Library:Create("Frame", {
		Parent = Toggle.Switch,
		Position = udim2(0, 3, 0.5, 0),
		AnchorPoint = v2(0, 0.5),
		Size = udim2(0, 14, 0, 14),
		BackgroundColor3 = Colors.Circle,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Toggle.Circle, CornerRadius = udim(1, 0)})

	function Toggle:Set(val)
		Toggle.Value = val
		Library.Flags[Toggle.Flag] = val

		Library:Tween(Toggle.Switch, {BackgroundColor3 = val and Colors.Accent or Colors.BgHover})
		Library:Tween(Toggle.Switch.UIStroke, {Color = val and Colors.Accent or Colors.Border})
		Library:Tween(Toggle.Circle, {
			Position = val and udim2(1, -17, 0.5, 0) or udim2(0, 3, 0.5, 0),
			BackgroundColor3 = val and Colors.Text or Colors.Circle
		})

		Toggle.Callback(val)
	end

	Toggle.Frame.MouseButton1Click:Connect(function()
		Toggle:Set(not Toggle.Value)
	end)
	Toggle.Frame.MouseEnter:Connect(function()
		Library:Tween(Toggle.Frame, {BackgroundColor3 = Colors.BgHover})
	end)
	Toggle.Frame.MouseLeave:Connect(function()
		Library:Tween(Toggle.Frame, {BackgroundColor3 = Colors.BgLight})
	end)

	Toggle:Set(Toggle.Default)
	return setmetatable(Toggle, Library)
end

function Library:Slider(props)
	local Slider = {
		Name = props.Name or "Slider",
		Flag = props.Flag or props.Name or "Slider",
		Min = tonumber(props.Min) or 0,
		Max = tonumber(props.Max) or 100,
		Default = tonumber(props.Default) or 50,
		Decimal = tonumber(props.Decimal) or 1,
		Suffix = props.Suffix or "",
		Callback = props.Callback or function() end,
		Dragging = false,
		Value = 0
	}

	Slider.Default = math.clamp(Slider.Default, Slider.Min, Slider.Max)
	Slider.Value = Slider.Default
	Library.Flags[Slider.Flag] = Slider.Value

	Slider.Frame = Library:Create("Frame", {
		Parent = self.List,
		Size = UDim2.new(1,0,0,60),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Slider.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Slider.Frame,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Slider.Label = Library:Create("TextLabel", {
		Parent = Slider.Frame,
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(0.6, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = Slider.Name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium
	})

	Slider.ValueLabel = Library:Create("TextBox", {
		Parent = Slider.Frame,
		Position = UDim2.new(1, -12, 0, 8),
		AnchorPoint = Vector2.new(1,0),
		Size = UDim2.new(0, 60, 0, 20),
		BackgroundTransparency = 1,
		Text = tostring(Slider.Value) .. Slider.Suffix,
		TextColor3 = Colors.Accent,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Right,
		Font = Enum.Font.GothamBold,
		ClearTextOnFocus = true
	})

	Slider.Track = Library:Create("TextButton", {
		Parent = Slider.Frame,
		Position = UDim2.new(0, 12, 0, 38),
		Size = UDim2.new(1, -24, 0, 6),
		BackgroundColor3 = Colors.BgHover,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false
	})
	Library:Create("UICorner", {Parent = Slider.Track, CornerRadius = UDim.new(1, 0)})

	Slider.Fill = Library:Create("Frame", {
		Parent = Slider.Track,
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.new(0,0,1,0),
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Slider.Fill, CornerRadius = UDim.new(1, 0)})

	function Slider:Set(val)
		local num = tonumber(val)
		if not num then
			Slider.ValueLabel.Text = tostring(Slider.Value)..Slider.Suffix
			return
		end

		num = math.clamp(Library:Round(num, Slider.Decimal), Slider.Min, Slider.Max)
		Slider.Value = num
		Library.Flags[Slider.Flag] = num
		Slider.ValueLabel.Text = tostring(num)..Slider.Suffix

		local range = Slider.Max - Slider.Min
		local percent = (range > 0) and ((Slider.Value - Slider.Min) / range) or 0
		percent = math.clamp(percent, 0, 1)
		Library:Tween(Slider.Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.15)

		Slider.Callback(num)
	end

	Slider.Track.MouseButton1Down:Connect(function()
		Slider.Dragging = true
		local function update()
			if not Slider.Dragging then return end
			local mouseX = UserInputService:GetMouseLocation().X
			local absPos = Slider.Track.AbsolutePosition.X
			local absSize = Slider.Track.AbsoluteSize.X
			if absSize <= 0 then return end
			local relative = math.clamp((mouseX - absPos)/absSize, 0, 1)
			Slider:Set(Slider.Min + (Slider.Max - Slider.Min)*relative)
		end
		update()
		local moveConn
		moveConn = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then update() end
		end)
		local endConn
		endConn = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Slider.Dragging = false
				moveConn:Disconnect()
				endConn:Disconnect()
			end
		end)
	end)

	Slider.ValueLabel.FocusLost:Connect(function()
		local text = Slider.ValueLabel.Text:gsub(Slider.Suffix, "")
		local num = tonumber(text)
		if num then Slider:Set(num) else Slider.ValueLabel.Text = tostring(Slider.Value)..Slider.Suffix end
	end)

	task.defer(function() Slider:Set(Slider.Default) end)
	return setmetatable(Slider, Library)
end

function Library:Button(props)
	local Button = {
		Name = props.Name or "Button",
		Callback = props.Callback or function() end
	}

	Button.Frame = Library:Create("TextButton", {
		Parent = self.List,
		Size = udim2(1, 0, 0, 38),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false
	})
	Library:Create("UICorner", {Parent = Button.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Button.Frame,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Button.Label = Library:Create("TextLabel", {
		Parent = Button.Frame,
		Size = udim2(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = Button.Name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold
	})

	Button.Frame.MouseEnter:Connect(function()
		Library:Tween(Button.Frame, {BackgroundColor3 = Colors.BgHover})
		Library:Tween(Button.Frame.UIStroke, {Color = Colors.BorderHover})
	end)
	Button.Frame.MouseLeave:Connect(function()
		Library:Tween(Button.Frame, {BackgroundColor3 = Colors.BgLight})
		Library:Tween(Button.Frame.UIStroke, {Color = Colors.Border})
	end)
	Button.Frame.MouseButton1Click:Connect(function()
		Library:Tween(Button.Frame, {BackgroundColor3 = Colors.BgHover}, 0.08)
		task.wait(0.08)
		Library:Tween(Button.Frame, {BackgroundColor3 = Colors.BgLight}, 0.08)
		Button.Callback()
	end)

	return setmetatable(Button, Library)
end

function Library:Textbox(props)
	local Textbox = {
		Name = props.Name or "Textbox",
		Flag = props.Flag or props.Name or "Textbox",
		Default = props.Default or "",
		PlaceHolder = props.PlaceHolder or "Type here...",
		Callback = props.Callback or function() end,
		Value = props.Default or ""
	}

	Library.Flags[Textbox.Flag] = Textbox.Value

	Textbox.Frame = Library:Create("Frame", {
		Parent = self.List,
		Size = udim2(1, 0, 0, 60),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Textbox.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Textbox.Frame,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Textbox.Label = Library:Create("TextLabel", {
		Parent = Textbox.Frame,
		Position = udim2(0, 12, 0, 8),
		Size = udim2(1, -24, 0, 20),
		BackgroundTransparency = 1,
		Text = Textbox.Name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium
	})

	Textbox.Box = Library:Create("Frame", {
		Parent = Textbox.Frame,
		Position = udim2(0, 12, 0, 32),
		Size = udim2(1, -24, 0, 24),
		BackgroundColor3 = Colors.BgHover,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Textbox.Box, CornerRadius = udim(0, 6)})
	Library:Create("UIStroke", {
		Parent = Textbox.Box,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Textbox.Input = Library:Create("TextBox", {
		Parent = Textbox.Box,
		Size = udim2(1, -12, 1, 0),
		Position = udim2(0, 6, 0, 0),
		BackgroundTransparency = 1,
		Text = Textbox.Default,
		PlaceholderText = Textbox.PlaceHolder,
		PlaceholderColor3 = Colors.TextDim,
		TextColor3 = Colors.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false
	})

	function Textbox:Set(val)
		Textbox.Value = val
		Library.Flags[Textbox.Flag] = val
		Textbox.Input.Text = val
		Textbox.Callback(val)
	end

	Textbox.Input.FocusLost:Connect(function()
		Textbox:Set(Textbox.Input.Text)
	end)

	return setmetatable(Textbox, Library)
end

function Library:Label(props)
	local Label = {
		Name = props.Name or "Label"
	}

	Label.Frame = Library:Create("Frame", {
		Parent = self.List,
		Size = udim2(1, 0, 0, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	Label.Text = Library:Create("TextLabel", {
		Parent = Label.Frame,
		Size = udim2(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = Label.Name,
		TextColor3 = Colors.TextMid,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium
	})

	function Label:Set(text)
		Label.Name = text
		Label.Text.Text = text
	end

	return setmetatable(Label, Library)
end

function Library:Keybind(props)
	local Keybind = {
		Name = props.Name or "Keybind",
		Flag = props.Flag or props.Name or "Keybind",
		Default = props.Default or Enum.KeyCode.E,
		Callback = props.Callback or function() end,
		Key = props.Default or Enum.KeyCode.E,
		Binding = false
	}

	Library.Flags[Keybind.Flag] = Keybind.Key

	Keybind.Frame = Library:Create("Frame", {
		Parent = self.List,
		Size = udim2(1, 0, 0, 35),
		BackgroundColor3 = Colors.BgLight,
		BackgroundTransparency = 0,
		BorderSizePixel = 0
	})
	Library:Create("UICorner", {Parent = Keybind.Frame, CornerRadius = udim(0, 8)})
	Library:Create("UIStroke", {
		Parent = Keybind.Frame,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Keybind.Label = Library:Create("TextLabel", {
		Parent = Keybind.Frame,
		Position = udim2(0, 12, 0, 0),
		Size = udim2(0.6, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = Keybind.Name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.GothamMedium
	})

	Keybind.Button = Library:Create("TextButton", {
		Parent = Keybind.Frame,
		Position = udim2(1, -10, 0.5, 0),
		AnchorPoint = v2(1, 0.5),
		Size = udim2(0, 70, 0, 22),
		BackgroundColor3 = Colors.BgHover,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false
	})
	Library:Create("UICorner", {Parent = Keybind.Button, CornerRadius = udim(0, 6)})
	Library:Create("UIStroke", {
		Parent = Keybind.Button,
		Color = Colors.Border,
		Transparency = 0,
		Thickness = 1
	})

	Keybind.KeyLabel = Library:Create("TextLabel", {
		Parent = Keybind.Button,
		Size = udim2(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = Keybind.Key.Name == "Unknown" and "NONE" or Keybind.Key.Name,
		TextColor3 = Colors.Accent,
		TextSize = 12,
		Font = Enum.Font.GothamBold
	})

	function Keybind:Set(key)
		Keybind.Key = key
		Library.Flags[Keybind.Flag] = key
		Keybind.KeyLabel.Text = key.Name == "Unknown" and "NONE" or key.Name
		Keybind.Callback(key)
	end

	Keybind.Button.MouseButton1Click:Connect(function()
		Keybind.Binding = true
		Keybind.KeyLabel.Text = "..."
		local connection
		connection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				Keybind:Set(input.KeyCode)
				Keybind.Binding = false
				connection:Disconnect()
			end
		end)
	end)

	return setmetatable(Keybind, Library)
end

return Library
