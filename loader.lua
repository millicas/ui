local Histronia = {}
Histronia.__index = Histronia

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Main Library
function Histronia:New(config)
    local self = setmetatable({}, Histronia)
    
    config = config or {}
    self.Title = config.Title or "Histronia UI"
    self.Size = config.Size or UDim2.new(0, 550, 0, 400)
    self.Theme = config.Theme or {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180)
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
    self.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = self.MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = self.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = self.MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 140, 1, -50)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 45)
    self.TabContainer.BackgroundColor3 = self.Theme.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = self.TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = self.TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -170, 1, -50)
    self.ContentContainer.Position = UDim2.new(0, 160, 0, 45)
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
    local Tab = {}
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = self.Theme.Background
    TabButton.Text = name
    TabButton.TextColor3 = self.Theme.SubText
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.BorderSizePixel = 0
    TabButton.Parent = self.TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 6)
    TabButtonCorner.Parent = TabButton
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = self.Theme.Accent
    TabContent.Visible = false
    TabContent.Parent = self.ContentContainer
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = TabContent
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = TabContent
    
    Tab.Content = TabContent
    Tab.Button = TabButton
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = self.Theme.Background
            tab.Button.TextColor3 = self.Theme.SubText
        end
        
        TabContent.Visible = true
        TabButton.BackgroundColor3 = self.Theme.Accent
        TabButton.TextColor3 = self.Theme.Text
        self.CurrentTab = Tab
    end)
    
    if not self.CurrentTab then
        TabButton.BackgroundColor3 = self.Theme.Accent
        TabButton.TextColor3 = self.Theme.Text
        TabContent.Visible = true
        self.CurrentTab = Tab
    end
    
    self.Tabs[name] = Tab
    
    -- Tab Methods
    function Tab:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = self.Theme.Secondary
        Button.Text = text
        Button.TextColor3 = self.Theme.Text
        Button.TextSize = 13
        Button.Font = Enum.Font.Gotham
        Button.BorderSizePixel = 0
        Button.Parent = TabContent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Accent}):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Secondary}):Play()
            if callback then callback() end
        end)
        
        return Button
    end
    
    function Tab:AddToggle(text, default, callback)
        local toggleState = default or false
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = self.Theme.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = TabContent
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = self.Theme.Text
        ToggleLabel.TextSize = 13
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(60, 60, 70)
        ToggleButton.Text = ""
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        ToggleCircle.Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleCircle.BorderSizePixel = 0
        ToggleCircle.Parent = ToggleButton
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = toggleState and self.Theme.Accent or Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            if callback then callback(toggleState) end
        end)
        
        return ToggleButton
    end
    
    function Tab:AddSlider(text, min, max, default, callback)
        local sliderValue = default or min
        
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundColor3 = self.Theme.Secondary
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = TabContent
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 6)
        SliderCorner.Parent = SliderFrame
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -20, 0, 20)
        SliderLabel.Position = UDim2.new(0, 10, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = text .. ": " .. sliderValue
        SliderLabel.TextColor3 = self.Theme.Text
        SliderLabel.TextSize = 13
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -20, 0, 6)
        SliderBar.Position = UDim2.new(0, 10, 1, -15)
        SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
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
                
                if callback then callback(sliderValue) end
            end
        end)
        
        return SliderFrame
    end
    
    return Tab
end

return Histronia
