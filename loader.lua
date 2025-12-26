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
    self.Title = config.Title or "histronia"
    self.Size = config.Size or UDim2.new(0, 1100, 0, 650)
    self.Theme = {
        Background = Color3.fromRGB(25, 25, 28), -- Dark background
        Secondary = Color3.fromRGB(35, 35, 40), -- Slightly lighter
        Sidebar = Color3.fromRGB(20, 20, 23), -- Sidebar dark
        Accent = Color3.fromRGB(220, 80, 85), -- Red accent
        AccentDark = Color3.fromRGB(180, 60, 65), -- Darker red
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 165),
        Border = Color3.fromRGB(45, 45, 50)
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
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = self.MainFrame

    -- Subtle border
    local Border = Instance.new("UIStroke")
    Border.Color = self.Theme.Border
    Border.Thickness = 1
    Border.Transparency = 0.3
    Border.Parent = self.MainFrame

    -- Sidebar Container (Left side)
    self.SidebarContainer = Instance.new("Frame")
    self.SidebarContainer.Name = "SidebarContainer"
    self.SidebarContainer.Size = UDim2.new(0, 280, 1, 0)
    self.SidebarContainer.Position = UDim2.new(0, 0, 0, 0)
    self.SidebarContainer.BackgroundColor3 = self.Theme.Sidebar
    self.SidebarContainer.BorderSizePixel = 0
    self.SidebarContainer.Parent = self.MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Parent = self.SidebarContainer

    -- Cover right side of sidebar corner
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 16, 1, 0)
    SidebarCover.Position = UDim2.new(1, -16, 0, 0)
    SidebarCover.BackgroundColor3 = self.Theme.Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = self.SidebarContainer

    -- Logo/Icon at top
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 80, 0, 80)
    LogoFrame.Position = UDim2.new(0, 25, 0, 30)
    LogoFrame.BackgroundColor3 = self.Theme.Accent
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = self.SidebarContainer

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 20)
    LogoCorner.Parent = LogoFrame

    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color =
        ColorSequence.new {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 100, 105)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 60, 65))
    }
    LogoGradient.Rotation = 45
    LogoGradient.Parent = LogoFrame

    -- Inner circle for logo
    local LogoCircle = Instance.new("Frame")
    LogoCircle.Size = UDim2.new(0, 50, 0, 50)
    LogoCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
    LogoCircle.BackgroundColor3 = Color3.fromRGB(200, 70, 75)
    LogoCircle.BorderSizePixel = 0
    LogoCircle.Parent = LogoFrame

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = LogoCircle

    -- Title below logo
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 0, 30)
    TitleLabel.Position = UDim2.new(0, 20, 0, 120)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 22
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.SidebarContainer

    -- Tab Container in sidebar
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, -40, 1, -200)
    self.TabContainer.Position = UDim2.new(0, 20, 0, 170)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.SidebarContainer

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = self.TabContainer

    -- Top bar with close button
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, -280, 0, 60)
    TopBar.Position = UDim2.new(0, 280, 0, 0)
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame

    -- Close Button (top right, rounded square)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -60, 0, 20)
    CloseButton.BackgroundColor3 = self.Theme.Accent
    CloseButton.Text = ""
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    local CloseIcon = Instance.new("TextLabel")
    CloseIcon.Size = UDim2.new(1, 0, 1, 0)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Text = "×"
    CloseIcon.TextColor3 = self.Theme.Text
    CloseIcon.TextSize = 28
    CloseIcon.Font = Enum.Font.GothamBold
    CloseIcon.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(
        function()
            TweenService:Create(
                self.MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quint),
                {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }
            ):Play()
            wait(0.3)
            self.ScreenGui:Destroy()
        end
    )

    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -320, 1, -80)
    self.ContentContainer.Position = UDim2.new(0, 300, 0, 70)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ClipsDescendants = true
    self.ContentContainer.Parent = self.MainFrame

    -- Dragging
    self:MakeDraggable(self.MainFrame, self.SidebarContainer)

    self.Tabs = {}
    self.CurrentTab = nil
end

function Histronia:MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )

    handle.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position =
                    UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    )
end

function Histronia:AddTab(name, icon)
    local Tab = {
        Theme = self.Theme
    }

    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 45)
    TabButton.BackgroundColor3 = self.Theme.Sidebar
    TabButton.BackgroundTransparency = 1
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.Parent = self.TabContainer

    -- Icon
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 20, 0, 20)
    TabIcon.Position = UDim2.new(0, 15, 0.5, -10)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = icon or "rbxassetid://3926305904" -- home icon
    TabIcon.ImageColor3 = self.Theme.SubText
    TabIcon.Parent = TabButton

    -- Tab Label
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -50, 1, 0)
    TabLabel.Position = UDim2.new(0, 45, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.TextColor3 = self.Theme.SubText
    TabLabel.TextSize = 15
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton

    -- Selection indicator
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 0)
    Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Indicator.BackgroundColor3 = self.Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Parent = TabButton

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = self.Theme.Border
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = self.ContentContainer

    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 12)
    ContentList.Parent = TabContent

    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 5)
    ContentPadding.Parent = TabContent

    -- Auto-resize canvas
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 15)
        end
    )

    Tab.Content = TabContent
    Tab.Button = TabButton
    Tab.List = ContentList
    Tab.Indicator = Indicator
    Tab.Icon = TabIcon
    Tab.Label = TabLabel

    TabButton.MouseButton1Click:Connect(
        function()
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Indicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 0)}):Play()
                TweenService:Create(tab.Icon, TweenInfo.new(0.3), {ImageColor3 = self.Theme.SubText}):Play()
                TweenService:Create(tab.Label, TweenInfo.new(0.3), {TextColor3 = self.Theme.SubText}):Play()
            end

            TabContent.Visible = true
            TweenService:Create(Indicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 30)}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.3), {ImageColor3 = self.Theme.Accent}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.3), {TextColor3 = self.Theme.Text}):Play()
            self.CurrentTab = Tab
        end
    )

    if not self.CurrentTab then
        Indicator.Size = UDim2.new(0, 3, 0, 30)
        TabIcon.ImageColor3 = self.Theme.Accent
        TabLabel.TextColor3 = self.Theme.Text
        TabContent.Visible = true
        self.CurrentTab = Tab
    end

    self.Tabs[name] = Tab

    -- Tab Methods
    function Tab:AddSection(text)
        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 0, 30)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = string.upper(text)
        SectionLabel.TextColor3 = self.Theme.SubText
        SectionLabel.TextSize = 12
        SectionLabel.Font = Enum.Font.GothamBold
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = TabContent

        return SectionLabel
    end

    function Tab:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text
        Button.Size = UDim2.new(1, 0, 0, 50)
        Button.BackgroundColor3 = self.Theme.Secondary
        Button.Text = ""
        Button.BorderSizePixel = 0
        Button.Parent = TabContent

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 12)
        ButtonCorner.Parent = Button

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = self.Theme.Accent
        ButtonStroke.Thickness = 1
        ButtonStroke.Transparency = 0.9
        ButtonStroke.Parent = Button

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Size = UDim2.new(1, -30, 1, 0)
        ButtonLabel.Position = UDim2.new(0, 15, 0, 0)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Text = text
        ButtonLabel.TextColor3 = self.Theme.Text
        ButtonLabel.TextSize = 14
        ButtonLabel.Font = Enum.Font.Gotham
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = Button

        Button.MouseEnter:Connect(
            function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            end
        )

        Button.MouseLeave:Connect(
            function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.9}):Play()
            end
        )

        Button.MouseButton1Click:Connect(
            function()
                pcall(callback)
            end
        )

        return Button
    end

    function Tab:AddToggle(text, default, callback)
        local toggleState = default or false

        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        ToggleFrame.BackgroundColor3 = self.Theme.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = TabContent

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 12)
        ToggleCorner.Parent = ToggleFrame

        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Color = toggleState and self.Theme.Accent or self.Theme.Border
        ToggleStroke.Thickness = 1
        ToggleStroke.Transparency = 0.5
        ToggleStroke.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = self.Theme.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 45, 0, 24)
        ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
        ToggleButton.BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(50, 50, 55)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame

        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton

        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
        ToggleCircle.Position = toggleState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton

        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle

        ToggleButton.MouseButton1Click:Connect(
            function()
                toggleState = not toggleState
                TweenService:Create(
                    ToggleButton,
                    TweenInfo.new(0.2),
                    {
                        BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(50, 50, 55)
                    }
                ):Play()
                TweenService:Create(
                    ToggleCircle,
                    TweenInfo.new(0.2),
                    {
                        Position = toggleState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    }
                ):Play()
                TweenService:Create(
                    ToggleStroke,
                    TweenInfo.new(0.2),
                    {
                        Color = toggleState and self.Theme.Accent or self.Theme.Border
                    }
                ):Play()
                pcall(callback, toggleState)
            end
        )

        return ToggleButton
    end

    function Tab:AddSlider(text, min, max, default, callback)
        local sliderValue = default or min

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 70)
        SliderFrame.BackgroundColor3 = self.Theme.Secondary
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = TabContent

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 12)
        SliderCorner.Parent = SliderFrame

        local SliderStroke = Instance.new("UIStroke")
        SliderStroke.Color = self.Theme.Border
        SliderStroke.Thickness = 1
        SliderStroke.Transparency = 0.5
        SliderStroke.Parent = SliderFrame

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -30, 0, 25)
        SliderLabel.Position = UDim2.new(0, 15, 0, 8)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = text
        SliderLabel.TextColor3 = self.Theme.Text
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame

        local SliderValue = Instance.new("TextLabel")
        SliderValue.Size = UDim2.new(0, 50, 0, 25)
        SliderValue.Position = UDim2.new(1, -65, 0, 8)
        SliderValue.BackgroundTransparency = 1
        SliderValue.Text = tostring(sliderValue)
        SliderValue.TextColor3 = self.Theme.Accent
        SliderValue.TextSize = 14
        SliderValue.Font = Enum.Font.GothamBold
        SliderValue.TextXAlignment = Enum.TextXAlignment.Right
        SliderValue.Parent = SliderFrame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -30, 0, 6)
        SliderBar.Position = UDim2.new(0, 15, 1, -18)
        SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
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

        SliderBar.InputBegan:Connect(
            function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end
        )

        UserInputService.InputEnded:Connect(
            function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end
        )

        UserInputService.InputChanged:Connect(
            function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = input.Position.X
                    local barPos = SliderBar.AbsolutePosition.X
                    local barSize = SliderBar.AbsoluteSize.X
                    local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    sliderValue = math.floor(min + (max - min) * percentage)

                    SliderValue.Text = tostring(sliderValue)
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()

                    pcall(callback, sliderValue)
                end
            end
        )

        return SliderFrame
    end

    function Tab:AddTextbox(text, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Size = UDim2.new(1, 0, 0, 80)
        TextboxFrame.BackgroundColor3 = self.Theme.Secondary
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Parent = TabContent

        local TextboxCorner = Instance.new("UICorner")
        TextboxCorner.CornerRadius = UDim.new(0, 12)
        TextboxCorner.Parent = TextboxFrame

        local TextboxStroke = Instance.new("UIStroke")
        TextboxStroke.Color = self.Theme.Border
        TextboxStroke.Thickness = 1
        TextboxStroke.Transparency = 0.5
        TextboxStroke.Parent = TextboxFrame

        local TextboxLabel = Instance.new("TextLabel")
        TextboxLabel.Size = UDim2.new(1, -30, 0, 20)
        TextboxLabel.Position = UDim2.new(0, 15, 0, 10)
        TextboxLabel.BackgroundTransparency = 1
        TextboxLabel.Text = text
        TextboxLabel.TextColor3 = self.Theme.Text
        TextboxLabel.TextSize = 14
        TextboxLabel.Font = Enum.Font.Gotham
        TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextboxLabel.Parent = TextboxFrame

        local Textbox = Instance.new("TextBox")
        Textbox.Size = UDim2.new(1, -30, 0, 35)
        Textbox.Position = UDim2.new(0, 15, 0, 35)
        Textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
        TextboxInnerCorner.CornerRadius = UDim.new(0, 8)
        TextboxInnerCorner.Parent = Textbox

        local TextboxPadding = Instance.new("UIPadding")
        TextboxPadding.PaddingLeft = UDim.new(0, 12)
        TextboxPadding.PaddingRight = UDim.new(0, 12)
        TextboxPadding.Parent = Textbox

        Textbox.Focused:Connect(
            function()
                TweenService:Create(TextboxStroke, TweenInfo.new(0.2), {Color = self.Theme.Accent, Transparency = 0.3}):Play(

                )
            end
        )

        Textbox.FocusLost:Connect(
            function(enter)
                TweenService:Create(TextboxStroke, TweenInfo.new(0.2), {Color = self.Theme.Border, Transparency = 0.5}):Play(

                )
                if enter then
                    pcall(callback, Textbox.Text)
                end
            end
        )

        return Textbox
    end

    function Tab:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 40)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = self.Theme.SubText
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextWrapped = true
        Label.BorderSizePixel = 0
        Label.Parent = TabContent

        return Label
    end

    function Tab:AddDropdown(text, options, callback)
        local isOpen = false
        local selectedOption = options[1] or "None"

        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
        DropdownFrame.BackgroundColor3 = self.Theme.Secondary
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = false
        DropdownFrame.ZIndex = 10
        DropdownFrame.Parent = TabContent

        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 12)
        DropdownCorner.Parent = DropdownFrame

        local DropdownStroke = Instance.new("UIStroke")
        DropdownStroke.Color = self.Theme.Border
        DropdownStroke.Thickness = 1
        DropdownStroke.Transparency = 0.5
        DropdownStroke.Parent = DropdownFrame

        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Size = UDim2.new(1, -30, 0, 20)
        DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Text = text
        DropdownLabel.TextColor3 = self.Theme.SubText
        DropdownLabel.TextSize = 12
        DropdownLabel.Font = Enum.Font.Gotham
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = DropdownFrame

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(1, -30, 0, 22)
        DropdownButton.Position = UDim2.new(0, 15, 0, 22)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        DropdownButton.Text = "  " .. selectedOption
        DropdownButton.TextColor3 = self.Theme.Text
        DropdownButton.TextSize = 13
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
        DropdownButton.BorderSizePixel = 0
        DropdownButton.Parent = DropdownFrame

        local DropdownButtonCorner = Instance.new("UICorner")
        DropdownButtonCorner.CornerRadius = UDim.new(0, 8)
        DropdownButtonCorner.Parent = DropdownButton

        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 20, 1, 0)
        Arrow.Position = UDim2.new(1, -25, 0, 0)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "▼"
        Arrow.TextColor3 = self.Theme.SubText
        Arrow.TextSize = 10
        Arrow.Font = Enum.Font.Gotham
        Arrow.Parent = DropdownButton

        local OptionsFrame = Instance.new("ScrollingFrame")
        OptionsFrame.Size = UDim2.new(1, -30, 0, 0)
        OptionsFrame.Position = UDim2.new(0, 15, 0, 48)
        OptionsFrame.BackgroundColor3 = self.Theme.Background
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Visible = false
        OptionsFrame.ScrollBarThickness = 4
        OptionsFrame.ScrollBarImageColor3 = self.Theme.Border
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        OptionsFrame.ZIndex = 15
        OptionsFrame.Parent = DropdownFrame

        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 8)
        OptionsCorner.Parent = OptionsFrame

        local OptionsStroke = Instance.new("UIStroke")
        OptionsStroke.Color = self.Theme.Border
        OptionsStroke.Thickness = 1
        OptionsStroke.Transparency = 0.5
        OptionsStroke.Parent = OptionsFrame

        local OptionsList = Instance.new("UIListLayout")
        OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsList.Padding = UDim.new(0, 2)
        OptionsList.Parent = OptionsFrame

        local OptionsPadding = Instance.new("UIPadding")
        OptionsPadding.PaddingTop = UDim.new(0, 4)
        OptionsPadding.PaddingBottom = UDim.new(0, 4)
        OptionsPadding.Parent = OptionsFrame

        OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsList.AbsoluteContentSize.Y + 8)
            end
        )

        for _, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 32)
            OptionButton.BackgroundColor3 = self.Theme.Secondary
            OptionButton.BackgroundTransparency = 0.3
            OptionButton.Text = "  " .. option
            OptionButton.TextColor3 = self.Theme.Text
            OptionButton.TextSize = 13
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextXAlignment = Enum.TextXAlignment.Left
            OptionButton.BorderSizePixel = 0
            OptionButton.ZIndex = 16
            OptionButton.Parent = OptionsFrame

            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = OptionButton

            OptionButton.MouseEnter:Connect(
                function()
                    TweenService:Create(
                        OptionButton,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
                    ):Play()
                end
            )

            OptionButton.MouseLeave:Connect(
                function()
                    TweenService:Create(
                        OptionButton,
                        TweenInfo.new(0.2),
                        {BackgroundColor3 = self.Theme.Secondary, BackgroundTransparency = 0.3}
                    ):Play()
                end
            )

            OptionButton.MouseButton1Click:Connect(
                function()
                    selectedOption = option
                    DropdownButton.Text = "  " .. selectedOption
                    isOpen = false
                    Arrow.Text = "▼"
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    wait(0.2)
                    OptionsFrame.Visible = false
                    pcall(callback, selectedOption)
                end
            )
        end

        DropdownButton.MouseButton1Click:Connect(
            function()
                isOpen = not isOpen
                if isOpen then
                    local optionsHeight = math.min(#options * 34 + 8, 150)
                    OptionsFrame.Visible = true
                    Arrow.Text = "▲"
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, optionsHeight)}):Play(

                    )
                    TweenService:Create(
                        DropdownFrame,
                        TweenInfo.new(0.2),
                        {Size = UDim2.new(1, 0, 0, 50 + optionsHeight + 5)}
                    ):Play()
                else
                    Arrow.Text = "▼"
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    wait(0.2)
                    OptionsFrame.Visible = false
                end
            end
        )

        return DropdownFrame
    end

    return Tab
end

return Histronia
