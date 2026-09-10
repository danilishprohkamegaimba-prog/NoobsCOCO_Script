local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    ESP = {Enabled = false, Color = "White", Thickness = 2, Transparency = 0.8, BoxType = "Corner", Name = true, Distance = true, HealthBar = true, HealthText = true, Bind = "None"},
    Chams = {Enabled = false, FillTrans = 0.5, OutlineTrans = 0.3, Bind = "None"},
    Aimbot = {Enabled = false, FOV = 200, Smoothness = 3, TargetPart = "Head", UnlockFOV = false, SilentAim = false, FOVColor = "Red", TriggerBot = false, TargetLock = false, VisibleCheck = true, AimAssist = false, FOVVisible = true, Bind = "None"},
    KillAura = {Enabled = false, Range = 50, Teleport = true, TeleportHeight = 15, Spin = false, SpinSpeed = 5, SpinDistance = 5, AttackDelay = 0.5, TargetPriority = "Distance", Bind = "None"},
    AutoClicker = {Enabled = false, CPS = 10, Bind = "None"},
    Misc = {Fly = false, FlySpeed = 50, NoClip = false, Speed = false, SpeedVal = 50, JumpPower = false, JumpVal = 100, Fullbright = false, AutoBunnyhop = false, Spinbot = false, UIOpacity = 100, AntiAFK = false},
    UI = {Theme = "Red", Minimized = false, Hidden = false, LastPosition = UDim2.new(0.5, -190, 0.08, 0), LastSize = UDim2.new(0, 380, 0, 550)}
}

local Colors = {
    White = Color3.fromRGB(255, 255, 255), Red = Color3.fromRGB(255, 50, 50), Green = Color3.fromRGB(50, 255, 50),
    Blue = Color3.fromRGB(50, 50, 255), LightBlue = Color3.fromRGB(100, 180, 255), Purple = Color3.fromRGB(200, 50, 255),
    Yellow = Color3.fromRGB(255, 255, 50), Orange = Color3.fromRGB(255, 150, 0), Pink = Color3.fromRGB(255, 100, 200),
    Cyan = Color3.fromRGB(0, 255, 255), Gray = Color3.fromRGB(160, 160, 160)
}

local Themes = {
    Red = {Accent = Color3.fromRGB(255, 60, 60), Bg = Color3.fromRGB(12, 12, 16), Tab = Color3.fromRGB(10, 10, 15), Elem = Color3.fromRGB(25, 25, 30), Btn = Color3.fromRGB(35, 35, 40), Text = Color3.fromRGB(210, 210, 210), TitleText = Color3.fromRGB(255, 255, 255)},
    Dark = {Accent = Color3.fromRGB(100, 100, 100), Bg = Color3.fromRGB(15, 15, 18), Tab = Color3.fromRGB(12, 12, 15), Elem = Color3.fromRGB(25, 25, 28), Btn = Color3.fromRGB(35, 35, 38), Text = Color3.fromRGB(180, 180, 180), TitleText = Color3.fromRGB(220, 220, 220)},
    Blue = {Accent = Color3.fromRGB(60, 100, 255), Bg = Color3.fromRGB(12, 14, 22), Tab = Color3.fromRGB(10, 12, 18), Elem = Color3.fromRGB(22, 25, 38), Btn = Color3.fromRGB(32, 35, 48), Text = Color3.fromRGB(200, 210, 255), TitleText = Color3.fromRGB(220, 230, 255)},
    Green = {Accent = Color3.fromRGB(60, 255, 100), Bg = Color3.fromRGB(10, 18, 12), Tab = Color3.fromRGB(8, 15, 10), Elem = Color3.fromRGB(20, 30, 22), Btn = Color3.fromRGB(30, 40, 32), Text = Color3.fromRGB(200, 255, 210), TitleText = Color3.fromRGB(220, 255, 230)},
    Purple = {Accent = Color3.fromRGB(180, 60, 255), Bg = Color3.fromRGB(16, 10, 24), Tab = Color3.fromRGB(14, 8, 20), Elem = Color3.fromRGB(28, 20, 38), Btn = Color3.fromRGB(38, 30, 48), Text = Color3.fromRGB(220, 200, 255), TitleText = Color3.fromRGB(240, 230, 255)},
    Cyan = {Accent = Color3.fromRGB(0, 200, 200), Bg = Color3.fromRGB(10, 18, 20), Tab = Color3.fromRGB(8, 15, 17), Elem = Color3.fromRGB(20, 30, 32), Btn = Color3.fromRGB(30, 40, 42), Text = Color3.fromRGB(200, 255, 255), TitleText = Color3.fromRGB(220, 255, 255)},
    Orange = {Accent = Color3.fromRGB(255, 150, 50), Bg = Color3.fromRGB(22, 15, 8), Tab = Color3.fromRGB(18, 12, 6), Elem = Color3.fromRGB(35, 25, 15), Btn = Color3.fromRGB(45, 35, 25), Text = Color3.fromRGB(255, 230, 200), TitleText = Color3.fromRGB(255, 240, 220)},
    Pink = {Accent = Color3.fromRGB(255, 100, 200), Bg = Color3.fromRGB(22, 10, 16), Tab = Color3.fromRGB(18, 8, 14), Elem = Color3.fromRGB(32, 20, 26), Btn = Color3.fromRGB(42, 30, 36), Text = Color3.fromRGB(255, 200, 230), TitleText = Color3.fromRGB(255, 220, 240)},
    White = {Accent = Color3.fromRGB(255, 255, 255), Bg = Color3.fromRGB(18, 18, 20), Tab = Color3.fromRGB(15, 15, 17), Elem = Color3.fromRGB(28, 28, 32), Btn = Color3.fromRGB(38, 38, 42), Text = Color3.fromRGB(240, 240, 240), TitleText = Color3.fromRGB(50, 50, 50)},
    Yellow = {Accent = Color3.fromRGB(255, 255, 50), Bg = Color3.fromRGB(20, 20, 8), Tab = Color3.fromRGB(16, 16, 6), Elem = Color3.fromRGB(32, 32, 18), Btn = Color3.fromRGB(42, 42, 28), Text = Color3.fromRGB(255, 255, 200), TitleText = Color3.fromRGB(50, 50, 20)},
    Lime = {Accent = Color3.fromRGB(150, 255, 50), Bg = Color3.fromRGB(10, 20, 8), Tab = Color3.fromRGB(8, 16, 6), Elem = Color3.fromRGB(20, 32, 18), Btn = Color3.fromRGB(30, 42, 28), Text = Color3.fromRGB(200, 255, 180), TitleText = Color3.fromRGB(220, 255, 200)}
}

local ESPData = {}
local lockedTarget = nil
local spinAngle = 0
local uiHovered = false
local bunnyhopEnabled = false
local chamConnections = {}
local lastAttack = 0
local afkConn = nil
local listeningForBind = false
local settingBind = nil
local clickerConn = nil
local animating = false

local ToggleButtons = {}

local function getTheme() return Themes[Settings.UI.Theme] or Themes.Red end

local function saveSettings()
    pcall(function() writefile("NOOBS_COCO_Settings.json", HttpService:JSONEncode(Settings)) end)
end

local function loadSettings()
    pcall(function()
        if isfile("NOOBS_COCO_Settings.json") then
            local data = HttpService:JSONDecode(readfile("NOOBS_COCO_Settings.json"))
            for k, v in pairs(data) do
                if Settings[k] then
                    for k2, v2 in pairs(v) do
                        if Settings[k][k2] ~= nil then
                            Settings[k][k2] = v2
                        end
                    end
                end
            end
        end
    end)
end
loadSettings()

local function isMouseOverUI()
    local mousePos = UserInputService:GetMouseLocation()
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "NCGUI" then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("GuiObject") and obj.Visible and obj.Active then
                    local pos = obj.AbsolutePosition
                    local size = obj.AbsoluteSize
                    if mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and
                       mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function safeClick()
    if uiHovered then return end
    if isMouseOverUI() then return end
    pcall(function()
        local mousePos = UserInputService:GetMouseLocation()
        VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
    end)
end

local function isAlive(p)
    if not p or not p.Character then return false end
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 or false
end

local function isVisible(targetPart)
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return rayResult and rayResult.Instance:IsDescendantOf(targetPart.Parent) or false
end

local function cleanESP()
    for player, data in pairs(ESPData) do
        if not player or not player.Parent or not player.Character or not isAlive(player) then
            if data then
                if data.conn then data.conn:Disconnect() end
                if data.lines then for _, l in pairs(data.lines) do if l.Remove then l:Remove() end end end
                if data.nt then data.nt:Remove() end
                if data.dt then data.dt:Remove() end
                if data.ht then data.ht:Remove() end
                if data.hbg then data.hbg:Remove() end
                if data.hf then data.hf:Remove() end
            end
            ESPData[player] = nil
        end
    end
end

local function isThemeWhite()
    local t = getTheme()
    return t.TitleText == Color3.fromRGB(50, 50, 50) or t.TitleText == Color3.fromRGB(50, 50, 20)
end

local function rebuildESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            createESP(p)
        end
    end
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "NCGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local theme = getTheme()

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = Settings.UI.LastSize
mainFrame.Position = Settings.UI.LastPosition
mainFrame.BackgroundColor3 = theme.Bg
mainFrame.BackgroundTransparency = 1 - (Settings.Misc.UIOpacity / 100)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.ZIndex = 10
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 1.5
mainStroke.Color = theme.Accent
mainStroke.Transparency = 0.5

mainFrame.MouseEnter:Connect(function() uiHovered = true end)
mainFrame.MouseLeave:Connect(function() uiHovered = false end)

mainFrame.Changed:Connect(function(prop)
    if prop == "Position" and not animating then
        Settings.UI.LastPosition = mainFrame.Position
    end
end)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = theme.Tab
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleGradient = Instance.new("UIGradient", titleBar)
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, theme.Accent),
    ColorSequenceKeypoint.new(1, theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.5))
}
titleGradient.Rotation = 90

local titleIcon = Instance.new("Frame", titleBar)
titleIcon.Size = UDim2.new(0, 28, 0, 28)
titleIcon.Position = UDim2.new(0, 10, 0.5, -14)
titleIcon.BackgroundColor3 = theme.Accent
titleIcon.BackgroundTransparency = 0.7
titleIcon.BorderSizePixel = 0
titleIcon.ZIndex = 12
Instance.new("UICorner", titleIcon).CornerRadius = UDim.new(0, 7)

local titleIconText = Instance.new("TextLabel", titleIcon)
titleIconText.Size = UDim2.new(1, 0, 1, 0)
titleIconText.BackgroundTransparency = 1
titleIconText.Text = "😈"
titleIconText.TextTransparency = 0
titleIconText.Font = Enum.Font.Gotham
titleIconText.TextSize = 14
titleIconText.ZIndex = 13

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(0, 180, 0, 18)
titleLabel.Position = UDim2.new(0, 46, 0.5, -13)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "NOOBS COCO"
titleLabel.TextColor3 = theme.TitleText
titleLabel.TextTransparency = 0
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 17
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 12

local titleSub = Instance.new("TextLabel", titleBar)
titleSub.Size = UDim2.new(0, 160, 0, 16)
titleSub.Position = UDim2.new(0, 46, 0.5, 6)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Пусть все завидуют"
titleSub.TextColor3 = theme.Text
titleSub.TextTransparency = 0
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 10
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.ZIndex = 12

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -11)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.BackgroundTransparency = 0.3
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextTransparency = 0.2
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 11
minimizeBtn.AutoButtonColor = false
minimizeBtn.ZIndex = 12
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -32, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextTransparency = 0.2
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size = UDim2.new(1, 0, 0, 40)
tabHolder.Position = UDim2.new(0, 0, 0, 52)
tabHolder.BackgroundColor3 = theme.Tab
tabHolder.BackgroundTransparency = 0
tabHolder.BorderSizePixel = 0
tabHolder.ZIndex = 11
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0, 12)

local tabStroke = Instance.new("UIStroke", tabHolder)
tabStroke.Thickness = 1
tabStroke.Color = theme.Accent
tabStroke.Transparency = 0.6

local Tabs = {}
local TabContents = {}
local tabNames = {"ESP", "Chams", "Aimbot", "KillAura", "AutoClick", "Misc", "Binds"}
local currentTab = "ESP"

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1/#tabNames, -6, 0, 32)
    btn.Position = UDim2.new((i-1)/#tabNames, 3, 0, 4)
    btn.BackgroundColor3 = name == currentTab and theme.Accent or theme.Elem
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextTransparency = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 7
    btn.AutoButtonColor = false
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    Tabs[name] = btn
    
    local sc = Instance.new("ScrollingFrame", mainFrame)
    sc.Size = UDim2.new(1, 0, 1, -92)
    sc.Position = UDim2.new(0, 0, 0, 92)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 2
    sc.ScrollBarImageColor3 = theme.Accent
    sc.CanvasSize = UDim2.new(0, 0, 0, 700)
    sc.Visible = name == currentTab
    sc.ZIndex = 10
    
    local inner = Instance.new("Frame", sc)
    inner.Size = UDim2.new(1, 0, 0, 700)
    inner.BackgroundTransparency = 1
    inner.ZIndex = 10
    TabContents[name] = {scroll = sc, inner = inner}
    
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        local t = getTheme()
        for n, b in pairs(Tabs) do
            b.BackgroundColor3 = n == name and t.Accent or t.Elem
            if n == name and isThemeWhite() then
                b.TextColor3 = t.TitleText
            else
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        for n, c in pairs(TabContents) do c.scroll.Visible = n == name end
    end)
end

-- АНИМАЦИЯ ОТКРЫТИЯ: уезжает слева + проявляется
local function animateOpen()
    if animating then return end
    animating = true
    
    local targetSize = Settings.UI.Minimized and UDim2.new(0, 220, 0, 52) or UDim2.new(0, 380, 0, 550)
    local targetPos = Settings.UI.LastPosition
    
    mainFrame.Visible = true
    mainFrame.Size = targetSize
    mainFrame.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - 250, targetPos.Y.Scale, targetPos.Y.Offset)
    mainFrame.BackgroundTransparency = 1
    
    if not Settings.UI.Minimized then
        tabHolder.Visible = true
        titleSub.Visible = true
        for n, c in pairs(TabContents) do c.scroll.Visible = n == currentTab end
    end
    
    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, ti, {
        Position = targetPos,
        BackgroundTransparency = 1 - (Settings.Misc.UIOpacity / 100)
    }):Play()
    
    task.wait(0.4)
    animating = false
end

-- АНИМАЦИЯ ЗАКРЫТИЯ: уезжает влево + растворяется (размер НЕ меняется!)
local function animateClose()
    if animating then return end
    animating = true
    
    local currentPos = mainFrame.Position
    local targetPos = UDim2.new(currentPos.X.Scale, currentPos.X.Offset - 250, currentPos.Y.Scale, currentPos.Y.Offset)
    
    local ti = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    TweenService:Create(mainFrame, ti, {
        Position = targetPos,
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.35)
    mainFrame.Visible = false
    mainFrame.Position = Settings.UI.LastPosition
    animating = false
end

-- СВОРАЧИВАНИЕ: сначала скрываем содержимое, потом сжимаем
local function setMinimized()
    if animating then return end
    animating = true
    Settings.UI.Minimized = true
    
    for _, c in pairs(TabContents) do c.scroll.Visible = false end
    tabHolder.Visible = false
    titleSub.Visible = false
    
    task.wait(0.05)
    
    titleLabel.Size = UDim2.new(0, 140, 0, 18)
    local targetSize = UDim2.new(0, 220, 0, 52)
    
    local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, ti, {Size = targetSize}):Play()
    
    Settings.UI.LastSize = targetSize
    saveSettings()
    task.wait(0.3)
    animating = false
end

-- РАЗВОРАЧИВАНИЕ: сначала сжимаем, потом показываем содержимое
local function setMaximized()
    if animating then return end
    animating = true
    Settings.UI.Minimized = false
    
    titleLabel.Size = UDim2.new(0, 180, 0, 18)
    local targetSize = UDim2.new(0, 380, 0, 550)
    
    local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(mainFrame, ti, {Size = targetSize}):Play()
    
    Settings.UI.LastSize = targetSize
    saveSettings()
    task.wait(0.3)
    
    tabHolder.Visible = true
    titleSub.Visible = true
    for n, c in pairs(TabContents) do c.scroll.Visible = n == currentTab end
    
    animating = false
end

minimizeBtn.MouseButton1Click:Connect(function()
    if Settings.UI.Minimized then setMaximized() else setMinimized() end
end)

closeBtn.MouseButton1Click:Connect(function()
    if animating then return end
    Settings.UI.Hidden = true
    Settings.UI.LastPosition = mainFrame.Position
    Settings.UI.LastSize = mainFrame.Size
    saveSettings()
    animateClose()
end)

local function section(parent, name, y)
    local t = getTheme()
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, -16, 0, 30)
    s.Position = UDim2.new(0, 8, 0, y)
    s.BackgroundColor3 = t.Elem
    s.BackgroundTransparency = 0
    s.BorderSizePixel = 0
    s.ZIndex = 11
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 10)
    local sStroke = Instance.new("UIStroke", s)
    sStroke.Thickness = 1
    sStroke.Color = t.Accent
    sStroke.Transparency = 0.7
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1, -24, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextTransparency = 0
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    return y + 34
end

local function toggle(parent, text, y, def, cb, id)
    local t = getTheme()
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -16, 0, 34)
    f.Position = UDim2.new(0, 8, 0, y)
    f.BackgroundColor3 = t.Elem
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = t.Text
    l.TextTransparency = 0
    l.Font = Enum.Font.Gotham
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 48, 0, 24)
    b.Position = UDim2.new(1, -54, 0.5, -12)
    b.BorderSizePixel = 0
    b.BackgroundColor3 = def and Color3.fromRGB(40, 200, 40) or t.Btn
    b.BackgroundTransparency = 0
    b.Text = def and "ON" or "OFF"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextTransparency = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    local state = def
    
    if id then
        ToggleButtons[id] = {
            button = b,
            state = state,
            theme = t
        }
    end
    
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "ON" or "OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or t.Btn
        if id and ToggleButtons[id] then ToggleButtons[id].state = state end
        cb(state) saveSettings()
    end)
    return y + 37
end

local function updateToggleVisual(id, state)
    if ToggleButtons[id] then
        local t = getTheme()
        ToggleButtons[id].state = state
        ToggleButtons[id].button.Text = state and "ON" or "OFF"
        ToggleButtons[id].button.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or t.Btn
    end
end

local function dropdown(parent, text, y, opts, defIdx, cb)
    local t = getTheme()
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -16, 0, 58)
    f.Position = UDim2.new(0, 8, 0, y)
    f.BackgroundColor3 = t.Elem
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -16, 0, 18)
    l.Position = UDim2.new(0, 8, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = t.Text
    l.TextTransparency = 0
    l.Font = Enum.Font.Gotham
    l.TextSize = 9
    l.ZIndex = 12
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, -16, 0, 28)
    b.Position = UDim2.new(0, 8, 0, 26)
    b.BackgroundColor3 = t.Btn
    b.BackgroundTransparency = 0
    b.BorderSizePixel = 0
    b.Text = opts[defIdx]
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextTransparency = 0
    b.Font = Enum.Font.Gotham
    b.TextSize = 10
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local idx = defIdx
    b.MouseButton1Click:Connect(function()
        idx = idx % #opts + 1
        b.Text = opts[idx]
        cb(opts[idx]) saveSettings()
    end)
    return y + 61
end

local function slider(parent, text, y, min, max, def, cb)
    local t = getTheme()
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -16, 0, 52)
    f.Position = UDim2.new(0, 8, 0, y)
    f.BackgroundColor3 = t.Elem
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -16, 0, 18)
    l.Position = UDim2.new(0, 8, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. string.format("%.0f", def)
    l.TextColor3 = t.Text
    l.TextTransparency = 0
    l.Font = Enum.Font.Gotham
    l.TextSize = 9
    l.ZIndex = 12
    local bar = Instance.new("TextButton", f)
    bar.Size = UDim2.new(1, -16, 0, 18)
    bar.Position = UDim2.new(0, 8, 0, 28)
    bar.BackgroundColor3 = t.Btn
    bar.BackgroundTransparency = 0
    bar.BorderSizePixel = 0
    bar.Text = "" bar.AutoButtonColor = false bar.ZIndex = 12
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 9)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = t.Accent
    fill.BackgroundTransparency = 0
    fill.BorderSizePixel = 0
    fill.ZIndex = 13
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 9)
    local val, drag = def, false
    local function upd()
        local mp = UserInputService:GetMouseLocation()
        local rx = math.clamp((mp.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        val = min + (max - min) * rx
        fill.Size = UDim2.new(rx, 0, 1, 0)
        l.Text = text .. ": " .. string.format("%.0f", val)
        cb(val)
    end
    bar.MouseButton1Down:Connect(function() drag = true upd() end)
    UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and drag then upd() end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false saveSettings() end end)
    return y + 55
end

local bindButtons = {}

local function createBindButton(parent, text, y, bindValue, cb)
    local t = getTheme()
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -16, 0, 36)
    f.Position = UDim2.new(0, 8, 0, y)
    f.BackgroundColor3 = t.Elem
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.4, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = t.Text
    l.TextTransparency = 0
    l.Font = Enum.Font.Gotham
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 80, 0, 26)
    b.Position = UDim2.new(1, -86, 0.5, -13)
    b.BorderSizePixel = 0
    b.BackgroundColor3 = t.Btn
    b.BackgroundTransparency = 0
    b.Text = bindValue
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextTransparency = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        listeningForBind = true
        settingBind = function(key)
            cb(key)
            b.Text = key
            listeningForBind = false
            settingBind = nil
            saveSettings()
        end
        b.Text = "..."
    end)
    bindButtons[text] = b
    return y + 39
end

local function updateBindButton(text, key)
    if bindButtons[text] then bindButtons[text].Text = key end
end

-- ESP Tab
local y = 6 local inner = TabContents["ESP"].inner
y = section(inner, "ESP", y)
y = toggle(inner, "Enabled", y, Settings.ESP.Enabled, function(s) Settings.ESP.Enabled = s rebuildESP() end, "ESP")
y = dropdown(inner, "Box Type", y, {"Corner", "Full", "Corner+Full"}, 1, function(o) Settings.ESP.BoxType = o end)
y = dropdown(inner, "Color", y, {"White", "Red", "Green", "Blue", "Purple", "Yellow", "Cyan", "Rainbow"}, 1, function(o) Settings.ESP.Color = o end)
y = slider(inner, "Thickness", y, 1, 5, Settings.ESP.Thickness, function(v) Settings.ESP.Thickness = v end)
y = slider(inner, "Transparency", y, 0, 1, Settings.ESP.Transparency, function(v) Settings.ESP.Transparency = v end)
y = toggle(inner, "Name", y, Settings.ESP.Name, function(s) Settings.ESP.Name = s end)
y = toggle(inner, "Distance", y, Settings.ESP.Distance, function(s) Settings.ESP.Distance = s end)
y = toggle(inner, "HP Bar", y, Settings.ESP.HealthBar, function(s) Settings.ESP.HealthBar = s end)
y = toggle(inner, "Health Text", y, Settings.ESP.HealthText, function(s) Settings.ESP.HealthText = s end)
y = createBindButton(inner, "ESP Bind", y, Settings.ESP.Bind, function(key) Settings.ESP.Bind = key updateBindButton("ESP", key) end)
TabContents["ESP"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- Chams Tab
y = 6 inner = TabContents["Chams"].inner
y = section(inner, "CHAMS", y)
y = toggle(inner, "Enabled", y, Settings.Chams.Enabled, function(s)
    Settings.Chams.Enabled = s
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("CH")
            if hl then hl.Enabled = s elseif s then applyChams(p) end
        end
    end
end, "Chams")
y = slider(inner, "Fill Trans", y, 0, 1, Settings.Chams.FillTrans, function(v) Settings.Chams.FillTrans = v for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local hl = p.Character:FindFirstChild("CH") if hl then hl.FillTransparency = v end end end end)
y = slider(inner, "Outline Trans", y, 0, 1, Settings.Chams.OutlineTrans, function(v) Settings.Chams.OutlineTrans = v for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then local hl = p.Character:FindFirstChild("CH") if hl then hl.OutlineTransparency = v end end end end)
y = createBindButton(inner, "Chams Bind", y, Settings.Chams.Bind, function(key) Settings.Chams.Bind = key updateBindButton("Chams", key) end)
TabContents["Chams"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- Aimbot Tab
y = 6 inner = TabContents["Aimbot"].inner
y = section(inner, "AIMBOT", y)
y = toggle(inner, "Enabled", y, Settings.Aimbot.Enabled, function(s) Settings.Aimbot.Enabled = s end, "Aimbot")
y = dropdown(inner, "Target", y, {"Head", "HumanoidRootPart", "UpperTorso"}, 1, function(o) Settings.Aimbot.TargetPart = o end)
y = toggle(inner, "Unlock FOV", y, Settings.Aimbot.UnlockFOV, function(s) Settings.Aimbot.UnlockFOV = s end)
y = toggle(inner, "Silent Aim", y, Settings.Aimbot.SilentAim, function(s) Settings.Aimbot.SilentAim = s end)
y = toggle(inner, "Aim Assist", y, Settings.Aimbot.AimAssist, function(s) Settings.Aimbot.AimAssist = s end)
y = slider(inner, "FOV", y, 50, 500, Settings.Aimbot.FOV, function(v) Settings.Aimbot.FOV = v end)
y = slider(inner, "Smoothness", y, 1, 15, Settings.Aimbot.Smoothness, function(v) Settings.Aimbot.Smoothness = v end)
y = dropdown(inner, "FOV Color", y, {"Red", "Green", "Blue", "White", "Yellow", "Purple", "Cyan"}, 1, function(o) Settings.Aimbot.FOVColor = o end)
y = toggle(inner, "FOV Visible", y, Settings.Aimbot.FOVVisible, function(s) Settings.Aimbot.FOVVisible = s end)
y = toggle(inner, "Visible Check", y, Settings.Aimbot.VisibleCheck, function(s) Settings.Aimbot.VisibleCheck = s end)
y = toggle(inner, "Trigger Bot", y, Settings.Aimbot.TriggerBot, function(s) Settings.Aimbot.TriggerBot = s end)
y = toggle(inner, "Target Lock", y, Settings.Aimbot.TargetLock, function(s) Settings.Aimbot.TargetLock = s end)
y = createBindButton(inner, "Aimbot Bind", y, Settings.Aimbot.Bind, function(key) Settings.Aimbot.Bind = key updateBindButton("Aimbot", key) end)
TabContents["Aimbot"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- KillAura Tab
y = 6 inner = TabContents["KillAura"].inner
y = section(inner, "KILL AURA", y)
y = toggle(inner, "Enabled", y, Settings.KillAura.Enabled, function(s) Settings.KillAura.Enabled = s end, "KillAura")
y = slider(inner, "Range", y, 10, 200, Settings.KillAura.Range, function(v) Settings.KillAura.Range = v end)
y = dropdown(inner, "Priority", y, {"Distance", "Health", "Random"}, 1, function(o) Settings.KillAura.TargetPriority = o end)
y = toggle(inner, "Teleport", y, Settings.KillAura.Teleport, function(s) Settings.KillAura.Teleport = s end)
y = slider(inner, "Height", y, 5, 50, Settings.KillAura.TeleportHeight, function(v) Settings.KillAura.TeleportHeight = v end)
y = slider(inner, "Attack Delay", y, 0, 2, Settings.KillAura.AttackDelay, function(v) Settings.KillAura.AttackDelay = v end)
y = toggle(inner, "Spin Around", y, Settings.KillAura.Spin, function(s) Settings.KillAura.Spin = s end)
y = slider(inner, "Spin Speed", y, 1, 20, Settings.KillAura.SpinSpeed, function(v) Settings.KillAura.SpinSpeed = v end)
y = slider(inner, "Spin Dist", y, 2, 15, Settings.KillAura.SpinDistance, function(v) Settings.KillAura.SpinDistance = v end)
y = createBindButton(inner, "KillAura Bind", y, Settings.KillAura.Bind, function(key) Settings.KillAura.Bind = key updateBindButton("KillAura", key) end)
TabContents["KillAura"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- AutoClick Tab
y = 6 inner = TabContents["AutoClick"].inner
y = section(inner, "AUTO CLICKER", y)
y = toggle(inner, "Enabled", y, Settings.AutoClicker.Enabled, function(s) Settings.AutoClicker.Enabled = s if s then startClicker() else stopClicker() end end, "AutoClick")
y = slider(inner, "CPS", y, 1, 30, Settings.AutoClicker.CPS, function(v) Settings.AutoClicker.CPS = v end)
y = createBindButton(inner, "AutoClick Bind", y, Settings.AutoClicker.Bind, function(key) Settings.AutoClicker.Bind = key updateBindButton("AutoClick", key) end)
TabContents["AutoClick"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- Misc Tab
y = 6 inner = TabContents["Misc"].inner
y = section(inner, "MOVEMENT", y)
y = toggle(inner, "Fly", y, Settings.Misc.Fly, function(s) Settings.Misc.Fly = s if s then startFly() else stopFly() end end)
y = slider(inner, "Fly Speed", y, 10, 200, Settings.Misc.FlySpeed, function(v) Settings.Misc.FlySpeed = v end)
y = toggle(inner, "NoClip", y, Settings.Misc.NoClip, function(s) Settings.Misc.NoClip = s if s then enableNC() else disableNC() end end)
y = toggle(inner, "Speed", y, Settings.Misc.Speed, function(s) Settings.Misc.Speed = s updSpeed() end)
y = slider(inner, "Speed Val", y, 16, 200, Settings.Misc.SpeedVal, function(v) Settings.Misc.SpeedVal = v updSpeed() end)
y = toggle(inner, "Jump", y, Settings.Misc.JumpPower, function(s) Settings.Misc.JumpPower = s updJump() end)
y = slider(inner, "Jump Val", y, 50, 300, Settings.Misc.JumpVal, function(v) Settings.Misc.JumpVal = v updJump() end)
y = toggle(inner, "Bunnyhop", y, Settings.Misc.AutoBunnyhop, function(s) Settings.Misc.AutoBunnyhop = s bunnyhopEnabled = s if not s then updSpeed() end end)
y = toggle(inner, "Spinbot", y, Settings.Misc.Spinbot, function(s) Settings.Misc.Spinbot = s end)
y = toggle(inner, "Anti AFK", y, Settings.Misc.AntiAFK, function(s) Settings.Misc.AntiAFK = s if s then startAntiAFK() else stopAntiAFK() end end)
y = toggle(inner, "Fullbright", y, Settings.Misc.Fullbright, function(s) if s then Lighting.Brightness = 3 else Lighting.Brightness = 1 end end)

y = section(inner, "UI", y + 3)
y = dropdown(inner, "Theme", y, {"Red", "Dark", "Blue", "Green", "Purple", "Cyan", "Orange", "Pink", "White", "Yellow", "Lime"}, 1, function(o)
    Settings.UI.Theme = o
    local t = getTheme()
    mainFrame.BackgroundColor3 = t.Bg
    mainStroke.Color = t.Accent
    titleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, t.Accent), ColorSequenceKeypoint.new(1, t.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.5))}
    tabStroke.Color = t.Accent
    titleIcon.BackgroundColor3 = t.Accent
    titleLabel.TextColor3 = t.TitleText
    titleSub.TextColor3 = t.Text
    for n, b in pairs(Tabs) do
        b.BackgroundColor3 = n == currentTab and t.Accent or t.Elem
        if n == currentTab and isThemeWhite() then
            b.TextColor3 = t.TitleText
        else
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    saveSettings()
end)
y = slider(inner, "UI Opacity", y, 5, 100, Settings.Misc.UIOpacity, function(v)
    Settings.Misc.UIOpacity = v
    if mainFrame.Visible and not animating then
        mainFrame.BackgroundTransparency = 1 - (v / 100)
    end
    saveSettings()
end)
TabContents["Misc"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- Binds Tab
y = 6 inner = TabContents["Binds"].inner
y = section(inner, "BINDS", y)
y = createBindButton(inner, "ESP", y, Settings.ESP.Bind, function(key) Settings.ESP.Bind = key updateBindButton("ESP Bind", key) end)
y = createBindButton(inner, "Chams", y, Settings.Chams.Bind, function(key) Settings.Chams.Bind = key updateBindButton("Chams Bind", key) end)
y = createBindButton(inner, "Aimbot", y, Settings.Aimbot.Bind, function(key) Settings.Aimbot.Bind = key updateBindButton("Aimbot Bind", key) end)
y = createBindButton(inner, "KillAura", y, Settings.KillAura.Bind, function(key) Settings.KillAura.Bind = key updateBindButton("KillAura Bind", key) end)
y = createBindButton(inner, "AutoClick", y, Settings.AutoClicker.Bind, function(key) Settings.AutoClicker.Bind = key updateBindButton("AutoClick Bind", key) end)
TabContents["Binds"].scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

local wm = Instance.new("TextLabel", CoreGui)
wm.Size = UDim2.new(0, 280, 0, 32)
wm.Position = UDim2.new(1, -290, 0, 10)
wm.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
wm.BackgroundTransparency = 0.4
wm.BorderSizePixel = 0
wm.Text = "NOOBS COCO | FPS: -"
wm.TextColor3 = Color3.fromRGB(255, 60, 60)
wm.Font = Enum.Font.GothamBold
wm.TextSize = 13
wm.ZIndex = 999
Instance.new("UICorner", wm).CornerRadius = UDim.new(0, 6)

local fpsCounter = 0
local fpsLastUpdate = tick()

spawn(function()
    while wm and wm.Parent do
        fpsCounter = fpsCounter + 1
        if tick() - fpsLastUpdate >= 1 then
            pcall(function() wm.Text = "NOOBS COCO | FPS: " .. fpsCounter end)
            fpsCounter = 0
            fpsLastUpdate = tick()
        end
        task.wait()
    end
end)

function applyChams(player)
    if not player.Character then return end
    local c = player.Character
    local old = c:FindFirstChild("CH")
    if old then old:Destroy() end
    if chamConnections[player] then chamConnections[player]:Disconnect() chamConnections[player] = nil end
    if not Settings.Chams.Enabled then return end
    local hl = Instance.new("Highlight")
    hl.Name = "CH"
    hl.Enabled = true
    hl.FillTransparency = Settings.Chams.FillTrans
    hl.OutlineTransparency = Settings.Chams.OutlineTrans
    hl.Adornee = c
    hl.Parent = c
    chamConnections[player] = RunService.RenderStepped:Connect(function()
        if not hl or not hl.Parent then
            if chamConnections[player] then chamConnections[player]:Disconnect() chamConnections[player] = nil end
            return
        end
        local phase = (math.sin(tick() * 2) + 1) / 2
        local bwColor = Color3.fromRGB(0, 0, 0):Lerp(Color3.fromRGB(255, 255, 255), phase)
        hl.FillColor = bwColor
        hl.OutlineColor = bwColor
    end)
end

function createESP(player)
    if ESPData[player] then
        if ESPData[player].conn then ESPData[player].conn:Disconnect() end
        if ESPData[player].lines then for _, l in pairs(ESPData[player].lines) do l:Remove() end end
        if ESPData[player].nt then ESPData[player].nt:Remove() end
        if ESPData[player].dt then ESPData[player].dt:Remove() end
        if ESPData[player].ht then ESPData[player].ht:Remove() end
        if ESPData[player].hbg then ESPData[player].hbg:Remove() end
        if ESPData[player].hf then ESPData[player].hf:Remove() end
    end
    ESPData[player] = {}
    local lines = {} for i = 1, 8 do local l = Drawing.new("Line") l.Visible = false lines[i] = l end
    local nt = Drawing.new("Text") nt.Visible = false nt.Center = true nt.Size = 14 nt.Font = 3 nt.Outline = true
    local dt = Drawing.new("Text") dt.Visible = false dt.Center = true dt.Size = 12 dt.Font = 3 dt.Outline = true
    local ht = Drawing.new("Text") ht.Visible = false ht.Center = true ht.Size = 11 ht.Font = 3 ht.Outline = true
    local hbg = Drawing.new("Square") hbg.Visible = false hbg.Filled = true hbg.Color = Color3.fromRGB(15,15,15) hbg.Transparency = 0.4
    local hf = Drawing.new("Square") hf.Visible = false hf.Filled = true
    ESPData[player].lines = lines ESPData[player].nt = nt ESPData[player].dt = dt ESPData[player].ht = ht ESPData[player].hbg = hbg ESPData[player].hf = hf
    ESPData[player].conn = RunService.RenderStepped:Connect(function()
        local c = player.Character
        if not c or not isAlive(player) or not Settings.ESP.Enabled then
            for _, l in pairs(lines) do l.Visible = false end
            nt.Visible = false dt.Visible = false ht.Visible = false hbg.Visible = false hf.Visible = false
            return
        end
        local h = c:FindFirstChild("Head") local r = c:FindFirstChild("HumanoidRootPart")
        if not h or not r then return end
        local hp = h.Position + Vector3.new(0, 0.5, 0) local rp = r.Position - Vector3.new(0, 2, 0)
        local cp = r.Position + Vector3.new(0, math.abs(h.Position.Y - r.Position.Y), 0)
        local ts = Camera:WorldToViewportPoint(hp) local bs = Camera:WorldToViewportPoint(rp)
        if ts.Z <= 0 then for _, l in pairs(lines) do l.Visible = false end return end
        local dist = (Camera.CFrame.Position - cp).Magnitude
        local bw = math.clamp((2.5 / dist) * 500, 20, 200)
        local cs = Camera:WorldToViewportPoint(cp)
        local lx, rx = cs.X - bw/2, cs.X + bw/2
        local ty, by = ts.Y, bs.Y
        local color = Settings.ESP.Color == "Rainbow" and Color3.fromHSV(tick()%5/5, 1, 1) or (Colors[Settings.ESP.Color] or Colors.White)
        for i = 1, 8 do lines[i].Visible = false end
        if Settings.ESP.BoxType == "Full" or Settings.ESP.BoxType == "Corner+Full" then
            for i = 1, 4 do lines[i].Visible = true lines[i].Color = color lines[i].Thickness = Settings.ESP.Thickness lines[i].Transparency = Settings.ESP.Transparency end
            lines[1].From = Vector2.new(lx, ty) lines[1].To = Vector2.new(rx, ty)
            lines[2].From = Vector2.new(rx, ty) lines[2].To = Vector2.new(rx, by)
            lines[3].From = Vector2.new(rx, by) lines[3].To = Vector2.new(lx, by)
            lines[4].From = Vector2.new(lx, by) lines[4].To = Vector2.new(lx, ty)
        end
        if Settings.ESP.BoxType == "Corner" or Settings.ESP.BoxType == "Corner+Full" then
            local cs2 = math.min(bw * 0.3, 30)
            for i = 5, 8 do lines[i].Visible = true lines[i].Color = color lines[i].Thickness = Settings.ESP.Thickness + 1 lines[i].Transparency = Settings.ESP.Transparency end
            lines[5].From = Vector2.new(lx, ty) lines[5].To = Vector2.new(lx+cs2, ty)
            lines[6].From = Vector2.new(rx, ty) lines[6].To = Vector2.new(rx-cs2, ty)
            lines[7].From = Vector2.new(rx, by) lines[7].To = Vector2.new(rx-cs2, by)
            lines[8].From = Vector2.new(lx, by) lines[8].To = Vector2.new(lx+cs2, by)
        end
        if Settings.ESP.Name then nt.Visible = true nt.Text = player.Name nt.Position = Vector2.new(cs.X, ty - 20) nt.Color = Color3.fromRGB(255,255,255) else nt.Visible = false end
        if Settings.ESP.Distance then dt.Visible = true dt.Text = math.floor(dist).."m" dt.Position = Vector2.new(cs.X, by + 5) dt.Color = Color3.fromRGB(255,255,255) else dt.Visible = false end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            local health = hum.Health / hum.MaxHealth
            if Settings.ESP.HealthText then
                ht.Visible = true
                ht.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                ht.Position = Vector2.new(cs.X, by + 18)
                ht.Color = Color3.fromHSV(health * 0.33, 1, 1)
            else ht.Visible = false end
            if Settings.ESP.HealthBar then
                local bh = by - ty local bx = lx - 7
                hbg.Visible = true hbg.Size = Vector2.new(3, bh) hbg.Position = Vector2.new(bx, ty)
                hf.Visible = true hf.Size = Vector2.new(3, bh*health) hf.Position = Vector2.new(bx, ty + bh*(1-health)) hf.Color = Color3.fromHSV(health*0.33, 1, 1)
            else hbg.Visible = false hf.Visible = false end
        end
    end)
end

local function getTarget()
    if Settings.Aimbot.TargetLock and lockedTarget then
        local char = lockedTarget.Character
        if char and isAlive(lockedTarget) then
            local tp = char:FindFirstChild(Settings.Aimbot.TargetPart)
            if tp and char:FindFirstChildOfClass("Humanoid").Health > 0 then return tp, 0 end
        end
        lockedTarget = nil
    end
    local best, bestDist = nil, Settings.Aimbot.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or not isAlive(p) then continue end
        local tp = p.Character:FindFirstChild(Settings.Aimbot.TargetPart)
        if not tp then continue end
        local sp = Camera:WorldToViewportPoint(tp.Position)
        if not Settings.Aimbot.UnlockFOV and sp.Z <= 0 then continue end
        if Settings.Aimbot.VisibleCheck and not isVisible(tp) then continue end
        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
        if d < bestDist then bestDist = d best = tp lockedTarget = p end
    end
    return best, bestDist
end

local function killAura()
    if not Settings.KillAura.Enabled then return end
    local c = LocalPlayer.Character if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart") local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h or h.Health <= 0 then return end
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (r.Position - tr.Position).Magnitude
                if d <= Settings.KillAura.Range then table.insert(targets, {player = p, distance = d}) end
            end
        end
    end
    if #targets == 0 then return end
    if Settings.KillAura.TargetPriority == "Distance" then
        table.sort(targets, function(a, b) return a.distance < b.distance end)
    elseif Settings.KillAura.TargetPriority == "Health" then
        table.sort(targets, function(a, b)
            local ha = a.player.Character:FindFirstChildOfClass("Humanoid").Health
            local hb = b.player.Character:FindFirstChildOfClass("Humanoid").Health
            return ha < hb
        end)
    elseif Settings.KillAura.TargetPriority == "Random" then
        local rand = math.random(1, #targets)
        targets[1] = targets[rand]
    end
    local bestP = targets[1].player
    if bestP and bestP.Character then
        local tp = bestP.Character:FindFirstChild("Head") or bestP.Character:FindFirstChild("HumanoidRootPart")
        if tp then
            if Settings.KillAura.Spin then
                spinAngle = (spinAngle + Settings.KillAura.SpinSpeed) % 360
                local rad = math.rad(spinAngle)
                local offset = Vector3.new(math.cos(rad) * Settings.KillAura.SpinDistance, 0, math.sin(rad) * Settings.KillAura.SpinDistance)
                r.CFrame = CFrame.new(tp.Position + offset + Vector3.new(0, Settings.KillAura.TeleportHeight, 0))
            elseif Settings.KillAura.Teleport then
                r.CFrame = CFrame.new(tp.Position + Vector3.new(0, Settings.KillAura.TeleportHeight, 0))
            end
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, tp.Position)
            if tick() - lastAttack >= Settings.KillAura.AttackDelay then safeClick() lastAttack = tick() end
        end
    end
end

function startClicker()
    if clickerConn then clickerConn:Disconnect() end
    clickerConn = RunService.RenderStepped:Connect(function()
        if not Settings.AutoClicker.Enabled then stopClicker() return end
        task.wait(1 / Settings.AutoClicker.CPS)
        safeClick()
    end)
end
function stopClicker() if clickerConn then clickerConn:Disconnect() clickerConn = nil end end

function startAntiAFK()
    if afkConn then afkConn:Disconnect() end
    afkConn = RunService.RenderStepped:Connect(function()
        if not Settings.Misc.AntiAFK then stopAntiAFK() return end
        task.wait(30)
        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end
function stopAntiAFK() if afkConn then afkConn:Disconnect() afkConn = nil end end

local fovCircle = Drawing.new("Circle") fovCircle.Visible = false fovCircle.Thickness = 1.5 fovCircle.NumSides = 64 fovCircle.Transparency = 0.7

RunService.RenderStepped:Connect(function()
    if Settings.Misc.AutoBunnyhop then
        bunnyhopEnabled = true
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then
                if h.FloorMaterial ~= Enum.Material.Air then h.Jump = true end
                local baseSpeed = Settings.Misc.Speed and Settings.Misc.SpeedVal or 16
                h.WalkSpeed = baseSpeed * 1.25
            end
        end
    else
        if bunnyhopEnabled then bunnyhopEnabled = false updSpeed() end
    end
    if Settings.Misc.Spinbot then
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
    fovCircle.Visible = Settings.Aimbot.Enabled and not Settings.Aimbot.UnlockFOV and Settings.Aimbot.FOVVisible
    if fovCircle.Visible then
        fovCircle.Radius = Settings.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Color = Colors[Settings.Aimbot.FOVColor] or Colors.Red
    end
    killAura()
    if Settings.Aimbot.Enabled then
        local bt, bd = getTarget()
        if bt then
            if Settings.Aimbot.AimAssist then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, bt.Position), 0.05)
            elseif Settings.Aimbot.SilentAim then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, bt.Position)
            else
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, bt.Position), 1/math.max(Settings.Aimbot.Smoothness, 1))
            end
            if Settings.Aimbot.TriggerBot and bd < 50 then safeClick() end
        end
    end
    if tick() % 10 < 0.03 then cleanESP() end
end)

local flyConn
function startFly()
    local c = LocalPlayer.Character if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart") local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end
    h.PlatformStand = true
    flyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Misc.Fly then stopFly() return end
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel -= Vector3.new(0, 1, 0) end
        if vel.Magnitude > 0 then vel = vel.Unit * Settings.Misc.FlySpeed end
        r.Velocity = vel
    end)
end
function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
        local r = c:FindFirstChild("HumanoidRootPart")
        if r then r.Velocity = Vector3.zero end
    end
end

local ncConn
function enableNC() ncConn = RunService.Stepped:Connect(function() if LocalPlayer.Character then for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end
function disableNC() if ncConn then ncConn:Disconnect() end end

function updSpeed()
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            local baseSpeed = Settings.Misc.Speed and Settings.Misc.SpeedVal or 16
            if Settings.Misc.AutoBunnyhop then h.WalkSpeed = baseSpeed * 1.25 else h.WalkSpeed = baseSpeed end
        end
    end
end

function updJump() local c = LocalPlayer.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = Settings.Misc.JumpPower and Settings.Misc.JumpVal or 50 end end end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() task.wait(0.3) createESP(p) applyChams(p) end)
        if p.Character then createESP(p) applyChams(p) end
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() task.wait(0.3) createESP(p) applyChams(p) end)
        if p.Character then createESP(p) applyChams(p) end
    end
end)
Players.PlayerRemoving:Connect(function(p)
    if lockedTarget == p then lockedTarget = nil end
    if ESPData[p] then
        if ESPData[p].conn then ESPData[p].conn:Disconnect() end
        if ESPData[p].lines then for _, l in pairs(ESPData[p].lines) do l:Remove() end end
        ESPData[p] = nil
    end
    if chamConnections[p] then chamConnections[p]:Disconnect() chamConnections[p] = nil end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listeningForBind and settingBind then settingBind(input.KeyCode.Name) return end
    if input.KeyCode == Enum.KeyCode.V then
        if animating then return end
        if mainFrame.Visible then
            Settings.UI.Hidden = true
            Settings.UI.LastPosition = mainFrame.Position
            Settings.UI.LastSize = mainFrame.Size
            saveSettings()
            animateClose()
        else
            Settings.UI.Hidden = false
            animateOpen()
        end
    end
    if input.KeyCode.Name == Settings.ESP.Bind and input.KeyCode.Name ~= "None" then
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        updateToggleVisual("ESP", Settings.ESP.Enabled)
        rebuildESP()
    end
    if input.KeyCode.Name == Settings.Chams.Bind and input.KeyCode.Name ~= "None" then
        Settings.Chams.Enabled = not Settings.Chams.Enabled
        updateToggleVisual("Chams", Settings.Chams.Enabled)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("CH")
                if hl then hl.Enabled = Settings.Chams.Enabled elseif Settings.Chams.Enabled then applyChams(p) end
            end
        end
    end
    if input.KeyCode.Name == Settings.Aimbot.Bind and input.KeyCode.Name ~= "None" then
        Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
        updateToggleVisual("Aimbot", Settings.Aimbot.Enabled)
    end
    if input.KeyCode.Name == Settings.KillAura.Bind and input.KeyCode.Name ~= "None" then
        Settings.KillAura.Enabled = not Settings.KillAura.Enabled
        updateToggleVisual("KillAura", Settings.KillAura.Enabled)
    end
    if input.KeyCode.Name == Settings.AutoClicker.Bind and input.KeyCode.Name ~= "None" then
        Settings.AutoClicker.Enabled = not Settings.AutoClicker.Enabled
        updateToggleVisual("AutoClick", Settings.AutoClicker.Enabled)
        if Settings.AutoClicker.Enabled then startClicker() else stopClicker() end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updSpeed() updJump()
    if Settings.Chams.Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then applyChams(p) end
        end
    end
end)
if LocalPlayer.Character then
    updSpeed() updJump()
    if Settings.Chams.Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then applyChams(p) end
        end
    end
end
