--// Super Clean UI Library
--// Features: Tabs, Toggles, Sliders, Buttons, Input Boxes, Dragging, Animations.

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperCleanUI"
ScreenGui.Parent = game:GetService("CoreGui") -- For Synapse/Xeno/Solara etc. If on Roblox Studio, change to PlayerGui
ScreenGui.ResetOnSpawn = false

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Configuration
local Library = {}

function Library:NewWindow(Config)
    local Title = Config.Title or "Super Clean UI"
    
    --// Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true -- Clips the opening animation
    
    -- Add rounded corners
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- Shadow Container (Visual Depth)
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, 5)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.85
    Shadow.ZIndex = -1
    Shadow.BorderSizePixel = 0
    Shadow.Parent = MainFrame
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 12)
    ShadowCorner.Parent = Shadow

    -- Header / Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    -- Masking for TopBar to square off bottom corners
    local TopMask = Instance.new("Frame")
    TopMask.Size = UDim2.new(1, 0, 0.5, 0)
    TopMask.Position = UDim2.new(0, 0, 0.5, 0)
    TopMask.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TopMask.BorderSizePixel = 0
    TopMask.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    --// Dragging Logic
    local dragging = false
    local dragInput, mousePos, framePos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
            }):Play()
        end
    end)

    --// Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 35)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer

    --// Content Container (Where the elements go)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, 0, 1, -85)
    ContentContainer.Position = UDim2.new(0, 0, 0, 85)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    --// Logic Variables
    local Tabs = {}
    local CurrentTab = nil

    --// Functions
    local function CreateTab(TabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.BackgroundTransparency = 0.5
        TabButton.BorderSizePixel = 0
        TabButton.Text = TabName
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName.."Page"
        Page.Size = UDim2.new(1, -20, 1, -10)
        Page.Position = UDim2.new(0, 10, 0, 5)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        Page.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 10)
        PageLayout.Parent = Page
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        -- Tab Interactions
        TabButton.MouseButton1Click:Connect(function()
            -- Reset visuals of all tabs
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                        BackgroundTransparency = 0.5,
                        TextColor3 = Color3.fromRGB(150, 150, 150)
                    }):Play()
                end
            end
            
            -- Highlight clicked tab
            TweenService:Create(TabButton, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()

            -- Switch Pages
            CurrentTab = Page
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = (v == Page)
                end
            end
        end)

        -- Set default tab
        if #TabContainer:GetChildren() == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CurrentTab = Page
            Page.Visible = true
        end

        local Elements = {}

        function Elements:AddButton(Config)
            local Text = Config.Text or "Button"
            local Callback = Config.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Name = "Button"
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            Btn.BorderSizePixel = 0
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 5)
            BtnCorner.Parent = Btn

            -- Hover Animation
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    TextColor3 = Color3.fromRGB(220, 220, 220)
                }):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                -- Ripple effect or Click Animation
                TweenService:Create(Btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                }):Play()
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                }):Play()
                Callback()
            end)
        end

        function Elements:AddToggle(Config)
            local Text = Config.Text or "Toggle"
            local Default = Config.Default or false
            local Callback = Config.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 5)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = Text
            ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Name = "ToggleBtn"
            ToggleBtn.Size = UDim2.new(0, 35, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            ToggleBtn.BorderSizePixel = 0
            ToggleBtn.Text = ""
            ToggleBtn.Parent = ToggleFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 10)
            BtnCorner.Parent = ToggleBtn

            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
            ToggleIndicator.Position = UDim2.new(0, 3, 0.5, -7)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleBtn
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 7)
            IndCorner.Parent = ToggleIndicator

            -- Logic
            local Toggled = Default
            
            local function UpdateToggle()
                if Toggled then
                    TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 18, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
                Callback(Toggled)
            end
            
            UpdateToggle() -- Set initial state

            ToggleBtn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
            end)
        end

        function Elements:AddSlider(Config)
            local Text = Config.Text or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or 50
            local Callback = Config.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 60) -- Increased height for text box
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = Page
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 5)
            SliderCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = Text
            SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            -- Value Display (Editable)
            local ValueBox = Instance.new("TextBox")
            ValueBox.Name = "ValueBox"
            ValueBox.Size = UDim2.new(0, 50, 0, 20)
            ValueBox.Position = UDim2.new(1, -60, 0, 5)
            ValueBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ValueBox.BorderSizePixel = 0
            ValueBox.Text = tostring(Default)
            ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueBox.Font = Enum.Font.GothamBold
            ValueBox.TextSize = 13
            ValueBox.Parent = SliderFrame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = ValueBox

            -- Slider Bar Background
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.Size = UDim2.new(1, -20, 0, 8)
            SliderBar.Position = UDim2.new(0, 10, 0, 40)
            SliderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 4)
            BarCorner.Parent = SliderBar

            -- Slider Fill
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 4)
            FillCorner.Parent = SliderFill

            -- Logic
            local IsDragging = false
            local CurrentValue = Default

            local function UpdateSlider(val)
                CurrentValue = val
                local percentage = (val - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                ValueBox.Text = tostring(val)
                Callback(val)
            end

            -- Initialize
            UpdateSlider(Default)

            -- Dragging Logic
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsDragging = true
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local MousePos = UserInputService:GetMouseLocation()
                    local BarPos = SliderBar.AbsolutePosition
                    local BarSize = SliderBar.AbsoluteSize
                    
                    local Percentage = math.clamp((MousePos.X - BarPos.X) / BarSize.X, 0, 1)
                    local Value = math.floor(Min + (Max - Min) * Percentage)
                    
                    UpdateSlider(Value)
                end
            end)

            -- Custom Value Logic
            ValueBox.FocusLost:Connect(function(enterPressed)
                local text = ValueBox.Text
                -- Check if it's a number
                if tonumber(text) then
                    local num = tonumber(text)
                    if num < Min then num = Min end
                    if num > Max then num = Max end -- Optional: clamp to max, or allow overdrive?
                    -- The prompt asked to "add decimal like 1.5 but slider incremental is 1". 
                    -- This implies we might want to bypass the Min/Max visually or just use the textbox.
                    -- For this library, we will update the slider visual to closest %, but Callback uses the exact number.
                    
                    -- Visual update
                    local percentage = math.clamp((num - Min) / (Max - Min), 0, 1)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    
                    CurrentValue = num
                    ValueBox.Text = tostring(num) -- Reformat if needed
                    Callback(num)
                else
                    ValueBox.Text = tostring(CurrentValue) -- Revert if invalid
                end
            end)
        end

        return Elements
    end

    return {CreateTab = CreateTab}
end

--// OPENING ANIMATION
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Start hidden
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 550, 0, 400)
}):Play()

--// RETURN LIBRARY TO USER
return Library
