--// Ronix Glassy UI Library v4.0
local Library = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:NewWindow(Config)
    local Title = Config.Title or "Ronix Hub"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Ronix_V4"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 500, 0, 320)
    Main.Position = UDim2.new(0.5, -250, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    -- Glossy Effects
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.4
    MainStroke.Color = Color3.fromRGB(60, 60, 65)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main

    local Gloss = Instance.new("Frame")
    Gloss.Size = UDim2.new(1, 0, 0, 100)
    Gloss.BackgroundTransparency = 1
    Gloss.Parent = Main
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    Gradient.Transparency = NumberSequence.new(0.9, 1)
    Gradient.Rotation = 90
    Gradient.Parent = Gloss

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    Header.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Sidebar (Navigation)
    local Nav = Instance.new("Frame")
    Nav.Size = UDim2.new(0, 130, 1, -45)
    Nav.Position = UDim2.new(0, 10, 0, 40)
    Nav.BackgroundTransparency = 1
    Nav.Parent = Main

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -150, 1, -50)
    TabContainer.Position = UDim2.new(0, 140, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    local TabList = Instance.new("UIListLayout", Nav)
    TabList.Padding = UDim.new(0, 5)

    local Tabs = {}

    function Tabs:CreateTab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.Parent = Nav
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = TabContainer
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Nav:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(180, 180, 180), BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
                end 
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        end)

        local Elements = {}

        function Elements:AddToggle(Text, ConfigKey, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
            Frame.Parent = Page
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Text = Text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = "Left"
            Label.Parent = Frame

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 32, 0, 16)
            Switch.Position = UDim2.new(1, -42, 0.5, -8)
            Switch.BackgroundColor3 = _G.EliteConfig[ConfigKey] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 50)
            Switch.Parent = Frame
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 12, 0, 12)
            Dot.Position = _G.EliteConfig[ConfigKey] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
            Dot.BackgroundColor3 = Color3.new(1, 1, 1)
            Dot.Parent = Switch
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""
            Btn.Parent = Frame

            Btn.MouseButton1Click:Connect(function()
                _G.EliteConfig[ConfigKey] = not _G.EliteConfig[ConfigKey]
                local s = _G.EliteConfig[ConfigKey]
                TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = s and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 50)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.25), {Position = s and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
                if Callback then Callback(s) end
            end)
        end

        return Elements
    end

    -- Dragging Logic
    local d, ds, sp
    Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local del = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + del.X, sp.Y.Scale, sp.Y.Offset + del.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

    return Tabs, ScreenGui
end

return Library
