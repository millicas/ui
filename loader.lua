local Histronia = {}
Histronia.__index = Histronia

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Main Library
function Histronia:New(config)
    local self = setmetatable({}, Histronia)
    
    config = config or {}
    self.Title = config.Title or "Histronia UI"
    self.Size = config.Size or UDim2.new(0, 600, 0, 450)
    self.Theme = {
        Background = Color3.fromRGB(78, 40, 38), -- #4e2826
        Secondary = Color3.fromRGB(129, 43, 45), -- #812b2d
        Accent = Color3.fromRGB(236, 76, 81), -- #ec4c51
        AccentDark = Color3.fromRGB(198, 45, 50), -- #c62d32
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(220, 220, 220)
    }
    
    self:CreateUI()
    return self
end

function Histronia:CreateUI()
    -- Screen Gui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "HistroniaUI"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Protection
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = CoreGui
    else
        self.ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = false
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.BackgroundTransparency = 1
    Glow.Position = UDim2.new(0, -20, 0, -20)
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.ZIndex = 0
    Glow.Image = "rbxassetid://4996891970"
    Glow.ImageColor3 = self.Theme.AccentDark
    Glow.ImageTransparency = 0.7
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(20, 20, 280, 280)
    Glow.Parent = self.MainFrame
    
    -- Border accent
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Accent
    Border.Thickness = 2
    Border.Transparency = 0.5
    Border.Parent = self.MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = self.Theme.Secondary
    TitleBar.BackgroundTransparency = 0.2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = self.MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    -- Cover bottom of title bar
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 12)
    TitleCover.Position = UDim2.new(0, 0, 1, -12)
    TitleCover.BackgroundColor3 = self.Theme.Secondary
    TitleCover.BackgroundTransparency = 0.2
    TitleCover.BorderSizePixel = 0
    TitleCover.Parent = TitleBar
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 35, 0, 35)
    Icon.Position = UDim2.new(0, 10, 0, 7.5)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://139313061651478"
    Icon.Parent = TitleBar
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = Icon
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 55, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(1, -85, 0, 7.5)
    MinimizeButton.BackgroundColor3 = self.Theme.Accent
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = self.Theme.Text
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
    CloseButton.BackgroundColor3 = self.Theme.AccentDark
    CloseButton.Text = "×"
    CloseButton.TextColor3 = self.Theme.Text
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 50) or self.Size
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
        MinimizeButton.Text = minimized and "+" or "−"
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.2)
        self.ScreenGui:Destroy()
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 160, 1, -65)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 55)
    self.TabContainer.BackgroundColor3 = self.Theme.Secondary
    self.TabContainer.BackgroundTransparency = 0.3
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = self.TabContainer
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = self.Theme.Accent
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.7
    TabStroke.Parent = self.TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = self.TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingBottom = UDim.new(0, 10)
    TabPadding.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -190, 1, -65)
    self.ContentContainer.Position = UDim2.new(0, 180, 0, 55)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ClipsDescendants = true
    self.ContentContainer.Parent = self.MainFrame
    
    -- Dragging
    self:MakeDraggable(self.MainFrame, TitleBar)
    
    self.Tabs = {}
    self.CurrentTab = nil
end

function Histronia:MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Histronia:AddTab(name)
    local Tab = {
        Theme = self.Theme
    }
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 38)
    TabButton.BackgroundColor3 = self.Theme.Background
    TabButton.BackgroundTransparency = 0.3
    TabButton.Text = name
    TabButton.TextColor3 = self.Theme.SubText
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.BorderSizePixel = 0
    TabButton.Parent = self.TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 8)
    TabButtonCorner.Parent = TabButton
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = self.Theme.Accent
    TabStroke.Thickness = 0
    TabStroke.Transparency = 0.5
    TabStroke.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = self.Theme.Accent
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = self.ContentContainer
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 5)
    ContentPadding.Parent = TabContent
    
    -- Auto-resize canvas
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 15)
    end)
    
    Tab.Content = TabContent
    Tab.Button = TabButton
    Tab.List = ContentList
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Background,
                BackgroundTransparency = 0.3,
                TextColor3 = self.Theme.SubText
            }):Play()
            tab.Button.UIStroke.Thickness = 0
        end
        
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0,
            TextColor3 = self.Theme.Text
        }):Play()
        TabStroke.Thickness = 2
        self.CurrentTab = Tab
    end)
    
    if not self.CurrentTab then
        TabButton.BackgroundColor3 = self.Theme.Accent
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = self.Theme.Text
        TabStroke.Thickness = 2
        TabContent.Visible = true
        self.CurrentTab = Tab
    end
    
    self.Tabs[name] = Tab
    
    -- Tab Methods
    function Tab:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = self.Theme.Secondary
        Button.BackgroundTransparency = 0.2
        Button.Text = text
        Button.TextColor3 = self.Theme.Text
        Button.TextSize = 14
        Button.Font = Enum.Font.GothamSemibold
        Button.BorderSizePixel = 0
        Button.Parent = TabContent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = self.Theme.Accent
        ButtonStroke.Thickness = 1
        ButtonStroke.Transparency = 0.7
        ButtonStroke.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Accent}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.AccentDark}):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Accent}):Play()
            pcall(callback)
        end)
        
        return Button
    end
    
    function Tab:AddToggle(text, default, callback)
        local toggleState = default or false
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = self.Theme.Secondary
        ToggleFrame.BackgroundTransparency = 0.2
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = TabContent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Color = self.Theme.Accent
        ToggleStroke.Thickness = 1
        ToggleStroke.Transparency = 0.7
        ToggleStroke.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = self.Theme.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.GothamSemibold
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 45, 0, 22)
        ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
        ToggleButton.BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(60, 30, 30)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
        ToggleCircle.Position = toggleState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(60, 30, 30)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = toggleState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }):Play()
            pcall(callback, toggleState)
        end)
        
        return ToggleButton
    end
    
    function Tab:AddSlider(text, min, max, default, callback)
        local sliderValue = default or min
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 55)
        SliderFrame.BackgroundColor3 = self.Theme.Secondary
        SliderFrame.BackgroundTransparency = 0.2
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = TabContent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame
        
        local SliderStroke = Instance.new("UIStroke")
        SliderStroke.Color = self.Theme.Accent
        SliderStroke.Thickness = 1
        SliderStroke.Transparency = 0.7
        SliderStroke.Parent = SliderFrame
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -25, 0, 22)
        SliderLabel.Position = UDim2.new(0, 12, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = text .. ": " .. sliderValue
        SliderLabel.TextColor3 = self.Theme.Text
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.GothamSemibold
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -24, 0, 8)
        SliderBar.Position = UDim2.new(0, 12, 1, -18)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = SliderFrame
        
        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(1, 0)
        SliderBarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new((sliderValue - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = self.Theme.Accent
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill
        
        local dragging = false
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                sliderValue = math.floor(min + (max - min) * percentage)
                
                SliderLabel.Text = text .. ": " .. sliderValue
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                
                pcall(callback, sliderValue)
            end
        end)
        
        return SliderFrame
    end
    
    function Tab:AddTextbox(text, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Size = UDim2.new(1, 0, 0, 65)
        TextboxFrame.BackgroundColor3 = self.Theme.Secondary
        TextboxFrame.BackgroundTransparency = 0.2
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Parent = TabContent
        
        local TextboxCorner = Instance.new("UICorner")
        TextboxCorner.CornerRadius = UDim.new(0, 8)
        TextboxCorner.Parent = TextboxFrame
        
        local TextboxStroke = Instance.new("UIStroke")
        TextboxStroke.Color = self.Theme.Accent
        TextboxStroke.Thickness = 1
        TextboxStroke.Transparency = 0.7
        TextboxStroke.Parent = TextboxFrame
        
        local TextboxLabel = Instance.new("TextLabel")
        TextboxLabel.Size = UDim2.new(1, -24, 0, 20)
        TextboxLabel.Position = UDim2.new(0, 12, 0, 5)
        TextboxLabel.BackgroundTransparency = 1
        TextboxLabel.Text = text
        TextboxLabel.TextColor3 = self.Theme.Text
        TextboxLabel.TextSize = 14
        TextboxLabel.Font = Enum.Font.GothamSemibold
        TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextboxLabel.Parent = TextboxFrame
        
        local Textbox = Instance.new("TextBox")
        Textbox.Size = UDim2.new(1, -24, 0, 30)
        Textbox.Position = UDim2.new(0, 12, 0, 28)
        Textbox.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        Textbox.PlaceholderText = placeholder or "Enter text..."
        Textbox.PlaceholderColor3 = self.Theme.SubText
        Textbox.Text = ""
        Textbox.TextColor3 = self.Theme.Text
        Textbox.TextSize = 13
        Textbox.Font = Enum.Font.Gotham
        Textbox.BorderSizePixel = 0
        Textbox.ClearTextOnFocus = false
        Textbox.Parent = TextboxFrame
        
        local TextboxInnerCorner = Instance.new("UICorner")
        TextboxInnerCorner.CornerRadius = UDim.new(0, 6)
        TextboxInnerCorner.Parent = Textbox
        
        local TextboxPadding = Instance.new("UIPadding")
        TextboxPadding.PaddingLeft = UDim.new(0, 8)
        TextboxPadding.PaddingRight = UDim.new(0, 8)
        TextboxPadding.Parent = Textbox
        
        Textbox.FocusLost:Connect(function(enter)
            if enter then
                pcall(callback, Textbox.Text)
            end
        end)
        
        return Textbox
    end
    
    function Tab:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 35)
        Label.BackgroundColor3 = self.Theme.Secondary
        Label.BackgroundTransparency = 0.2
        Label.Text = text
        Label.TextColor3 = self.Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.BorderSizePixel = 0
        Label.Parent = TabContent
        
        local LabelCorner = Instance.new("UICorner")
        LabelCorner.CornerRadius = UDim.new(0, 8)
        LabelCorner.Parent = Label
        
        local LabelStroke = Instance.new("UIStroke")
        LabelStroke.Color = self.Theme.Accent
        LabelStroke.Thickness = 1
        LabelStroke.Transparency = 0.7
        LabelStroke.Parent = Label
        
        return Label
    end
    
    function Tab:AddDropdown(text, options, callback)
        local isOpen = false
        local selectedOption = options[1] or "None"
        
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
        DropdownFrame.BackgroundColor3 = self.Theme.Secondary
        DropdownFrame.BackgroundTransparency = 0.2
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = false
        DropdownFrame.ZIndex = 10
        DropdownFrame.Parent = TabContent
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 8)
        DropdownCorner.Parent = DropdownFrame
        
        local DropdownStroke = Instance.new("UIStroke")
        DropdownStroke.Color = self.Theme.Accent
        DropdownStroke.Thickness = 1
        DropdownStroke.Transparency = 0.7
        DropdownStroke.Parent = DropdownFrame
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
        DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Text = text
        DropdownLabel.TextColor3 = self.Theme.Text
        DropdownLabel.TextSize = 14
        DropdownLabel.Font = Enum.Font.GothamSemibold
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = DropdownFrame
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(1, -24, 0, 28)
        DropdownButton.Position = UDim2.new(0, 12, 0, 6)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        DropdownButton.Text = "  " .. selectedOption .. "  ▼"
        DropdownButton.TextColor3 = self.Theme.Text
        DropdownButton.TextSize = 13
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.BorderSizePixel = 0
        DropdownButton.Parent = DropdownFrame
        
        local DropdownButtonCorner = Instance.new("UICorner")
        DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
        DropdownButtonCorner.Parent = DropdownButton
        
        local OptionsFrame = Instance.new("ScrollingFrame")
        OptionsFrame.Size = UDim2.new(1, -24, 0, 0)
        OptionsFrame.Position = UDim2.new(0, 12, 0, 38)
        OptionsFrame.BackgroundColor3 = self.Theme.Background
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Visible = false
        OptionsFrame.ScrollBarThickness = 4
        OptionsFrame.ScrollBarImageColor3 = self.Theme.Accent
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        OptionsFrame.ZIndex = 15
        OptionsFrame.Parent = DropdownFrame
        
        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 6)
        OptionsCorner.Parent = OptionsFrame
        
        local OptionsList = Instance.new("UIListLayout")
        OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsList.Padding = UDim.new(0, 2)
        OptionsList.Parent = OptionsFrame
        
        OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsList.AbsoluteContentSize.Y)
        end)
        
        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = self.Theme.Secondary
            OptionButton.BackgroundTransparency = 0.2
            OptionButton.Text = option
            OptionButton.TextColor3 = self.Theme.Text
            OptionButton.TextSize = 13
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.BorderSizePixel = 0
            OptionButton.ZIndex = 16
            OptionButton.Parent = OptionsFrame
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Accent}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                selectedOption = option
                DropdownButton.Text = "  " .. selectedOption .. "  ▼"
                isOpen = false
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, 0)}):Play()
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                wait(0.2)
                OptionsFrame.Visible = false
                pcall(callback, selectedOption)
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                local optionsHeight = math.min(#options * 32, 150)
                OptionsFrame.Visible = true
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, optionsHeight)}):Play()
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40 + optionsHeight + 5)}):Play()
                DropdownButton.Text = "  " .. selectedOption .. "  ▲"
            else
                TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -24, 0, 0)}):Play()
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                DropdownButton.Text = "  " .. selectedOption .. "  ▼"
                wait(0.2)
                OptionsFrame.Visible = false
            end
        end)
        
        return DropdownFrame
    end
    
    return Tab
end

return Histronia
