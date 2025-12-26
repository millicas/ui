--// HISTRONIA UI LIBRARY
local Histronia = {}
Histronia.__index = Histronia

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

--// Config
local SHADOW_IMAGE = "rbxassetid://1316045217"

--// Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Enabled = false

--// Constructor
function Histronia:New(config)
    local self = setmetatable({}, Histronia)

    config = config or {}
    self.Title = config.Title or "histronia"
    self.Size = config.Size or UDim2.fromOffset(1100, 650)

    self.Theme = {
        Background = Color3.fromRGB(20,22,27),
        Surface = Color3.fromRGB(26,28,34),
        Sidebar = Color3.fromRGB(18,20,25),
        Accent = Color3.fromRGB(220,80,85),
        Text = Color3.fromRGB(240,240,240),
        SubText = Color3.fromRGB(150,155,165),
        Stroke = Color3.fromRGB(255,255,255)
    }

    self:Create()
    return self
end

--// Create UI
function Histronia:Create()
    -- Gui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "HistroniaUI"
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = CoreGui

    -- Blur
    Blur.Parent = Lighting
    Blur.Enabled = true
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 18}):Play()

    -- Main
    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.fromScale(0,0)
    self.Main.Position = UDim2.fromScale(0.5,0.5)
    self.Main.AnchorPoint = Vector2.new(0.5,0.5)
    self.Main.BackgroundColor3 = self.Theme.Background
    self.Main.Parent = self.Gui
    self.Main.ClipsDescendants = true

    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0,22)

    -- Open animation
    TweenService:Create(self.Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint), {
        Size = self.Size
    }):Play()

    -- Stroke
    local Stroke = Instance.new("UIStroke", self.Main)
    Stroke.Transparency = 0.92

    -- Shadow
    local Shadow = Instance.new("ImageLabel", self.Main)
    Shadow.Image = SHADOW_IMAGE
    Shadow.Size = UDim2.new(1,80,1,80)
    Shadow.Position = UDim2.fromScale(0.5,0.5)
    Shadow.AnchorPoint = Vector2.new(0.5,0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.ImageTransparency = 0.85
    Shadow.ZIndex = 0

    -- Sidebar
    self.Sidebar = Instance.new("Frame", self.Main)
    self.Sidebar.Size = UDim2.fromOffset(280,650)
    self.Sidebar.BackgroundColor3 = self.Theme.Sidebar
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0,22)

    -- Title
    local Title = Instance.new("TextLabel", self.Sidebar)
    Title.Text = self.Title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = self.Theme.Text
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(30,30)

    -- Tab Holder
    self.TabHolder = Instance.new("Frame", self.Sidebar)
    self.TabHolder.Position = UDim2.fromOffset(20,100)
    self.TabHolder.Size = UDim2.new(1,-40,1,-120)
    self.TabHolder.BackgroundTransparency = 1

    Instance.new("UIListLayout", self.TabHolder).Padding = UDim.new(0,10)

    -- Indicator
    self.Indicator = Instance.new("Frame", self.Sidebar)
    self.Indicator.Size = UDim2.fromOffset(4,40)
    self.Indicator.BackgroundColor3 = self.Theme.Accent
    self.Indicator.Position = UDim2.fromOffset(14,110)
    Instance.new("UICorner", self.Indicator).CornerRadius = UDim.new(1,0)

    -- Content
    self.Content = Instance.new("Frame", self.Main)
    self.Content.Position = UDim2.fromOffset(300,70)
    self.Content.Size = UDim2.new(1,-320,1,-90)
    self.Content.BackgroundTransparency = 1

    self.Tabs = {}
end

--// Tabs
function Histronia:AddTab(name, icon)
    local Tab = {}

    -- Button
    local Button = Instance.new("TextButton", self.TabHolder)
    Button.Size = UDim2.new(1,0,0,44)
    Button.BackgroundTransparency = 1
    Button.Text = "   "..name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 15
    Button.TextXAlignment = Left
    Button.TextColor3 = self.Theme.SubText

    -- Page
    local Page = Instance.new("ScrollingFrame", self.Content)
    Page.Size = UDim2.fromScale(1,1)
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Visible = false
    Page.ScrollBarImageTransparency = 0.6
    Page.BackgroundTransparency = 1

    Instance.new("UIListLayout", Page).Padding = UDim.new(0,12)

    -- Click
    Button.MouseButton1Click:Connect(function()
        for _,t in pairs(self.Tabs) do
            t.Page.Visible = false
            t.Button.TextColor3 = self.Theme.SubText
        end

        Page.Visible = true
        Button.TextColor3 = self.Theme.Text

        TweenService:Create(self.Indicator, TweenInfo.new(0.3), {
            Position = UDim2.fromOffset(14, Button.AbsolutePosition.Y - self.Sidebar.AbsolutePosition.Y)
        }):Play()
    end)

    if #self.Tabs == 0 then
        Page.Visible = true
        Button.TextColor3 = self.Theme.Text
    end

    Tab.Page = Page
    Tab.Button = Button
    table.insert(self.Tabs, Tab)

    -- Elements
    function Tab:AddButton(text, cb)
        local B = Instance.new("TextButton", Page)
        B.Size = UDim2.new(1,0,0,50)
        B.BackgroundColor3 = self.Theme.Surface
        B.Text = "  "..text
        B.TextXAlignment = Left
        B.TextColor3 = self.Theme.Text
        Instance.new("UICorner", B).CornerRadius = UDim.new(0,14)
        B.MouseButton1Click:Connect(function() pcall(cb) end)
    end

    function Tab:AddToggle(text, def, cb)
        local state = def
        local F = Instance.new("Frame", Page)
        F.Size = UDim2.new(1,0,0,50)
        F.BackgroundColor3 = self.Theme.Surface
        Instance.new("UICorner", F).CornerRadius = UDim.new(0,14)

        local T = Instance.new("TextButton", F)
        T.Size = UDim2.fromOffset(46,24)
        T.Position = UDim2.fromScale(1,-1)
        T.AnchorPoint = Vector2.new(1,0)
        T.BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(50,50,55)
        Instance.new("UICorner", T).CornerRadius = UDim.new(1,0)

        T.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(T, TweenInfo.new(0.2), {
                BackgroundColor3 = state and self.Theme.Accent or Color3.fromRGB(50,50,55)
            }):Play()
            pcall(cb,state)
        end)
    end

    return Tab
end

--// Close
function Histronia:Destroy()
    TweenService:Create(self.Main, TweenInfo.new(0.35), {
        Size = UDim2.fromScale(0,0)
    }):Play()

    TweenService:Create(Blur, TweenInfo.new(0.35), {Size = 0}):Play()
    task.delay(0.35, function()
        Blur.Enabled = false
        self.Gui:Destroy()
    end)
end

return Histronia
