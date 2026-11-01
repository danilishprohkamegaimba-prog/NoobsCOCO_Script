-- NOOBS COCO v5.0 (SniperLegends Edition + Polish + Fixes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VIM = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============ CLEANUP ============
pcall(function()
    if _G.NC_Connections then
        for _, c in pairs(_G.NC_Connections) do pcall(function() c:Disconnect() end) end
    end
    if _G.NC_Drawings then
        for _, d in pairs(_G.NC_Drawings) do pcall(function() d:Remove() end) end
    end
end)
_G.NC_Connections = {}
_G.NC_Drawings = {}
local function trackConn(c) table.insert(_G.NC_Connections, c) return c end
local function trackDraw(d) table.insert(_G.NC_Drawings, d) return d end

local guiParent = CoreGui
pcall(function() if gethui then guiParent = gethui() end end)
for _, child in pairs(guiParent:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name:match("^NC_") then pcall(function() child:Destroy() end) end
end
for _, p in pairs(Players:GetPlayers()) do
    if p.Character then
        for _, child in pairs(p.Character:GetChildren()) do
            if child:IsA("Highlight") and child.Name:match("^H_") then pcall(function() child:Destroy() end) end
        end
    end
end

local guiSuffix = tostring(math.random(100000, 999999))
local chamName = "H_"..guiSuffix
local guiName = "NC_"..guiSuffix

-- ============ FORWARD DECLS ============
local gui, mainFrame, mainStroke, glowLayer, actionBarFrame, actionBarBtn
local titleBar, tabHolder, subtitleLbl, fpsLbl, titleGrad
local Tabs, TabContents = {}, {}
local currentTab = "Visuals"
local fpsDisplayLbl, statsInfoLbl

-- ============ SETTINGS ============
local Settings = {
    ESP = {Enabled=false, Color="White", Thickness=2, Transparency=0.8, BoxType="Corner", Name=true, Distance=true, HealthBar=true, HealthText=true, Tracers=false, Snaplines=false, MaxDistance=500, TeamCheck=true, Bind="None"},
    Chams = {Enabled=false, FillTrans=0.5, OutlineTrans=0.3, Pulse=false, Color="White", Bind="None"},
    Aimbot = {Enabled=false, FOV=120, Smoothness=4, TargetPart="UpperTorso", UnlockFOV=false, SilentAim=false, FOVColor="Red", TriggerBot=false, TargetLock=false, VisibleCheck=true, AimAssist=true, FOVVisible=true, Prediction=false, HitChance=100, Bind="None"},
    AutoClicker = {Enabled=false, CPS=3, Bind="None"},
    Misc = {Fly=false, FlySpeed=50, NoClip=false, Speed=false, SpeedVal=50, JumpPower=false, JumpVal=100, Fullbright=false, AntiAFK=false, AutoRejoin=false, Bunnyhop=false},
    UI = {Theme="Red", Minimized=false, Hidden=false, LastPos={sx=0.5,ox=-250,sy=0.1,oy=0}, LastSize={w=500,h=420}, Opacity=100, Glow=true, Gradient=true, MenuKey="H", Custom={}}
}

local Colors = {
    White=Color3.fromRGB(255,255,255), Red=Color3.fromRGB(255,50,50), Green=Color3.fromRGB(50,255,50),
    Blue=Color3.fromRGB(50,50,255), LightBlue=Color3.fromRGB(100,180,255), Purple=Color3.fromRGB(200,50,255),
    Yellow=Color3.fromRGB(255,255,50), Orange=Color3.fromRGB(255,150,0), Pink=Color3.fromRGB(255,100,200),
    Cyan=Color3.fromRGB(0,255,255), Gray=Color3.fromRGB(160,160,160), Black=Color3.fromRGB(0,0,0)
}

local Themes = {
    Red={Accent=Color3.fromRGB(255,60,60),Bg=Color3.fromRGB(12,12,16),Tab=Color3.fromRGB(10,10,15),Elem=Color3.fromRGB(25,25,30),Btn=Color3.fromRGB(35,35,40),Text=Color3.fromRGB(210,210,210),TitleText=Color3.fromRGB(255,255,255)},
    Dark={Accent=Color3.fromRGB(100,100,100),Bg=Color3.fromRGB(15,15,18),Tab=Color3.fromRGB(12,12,15),Elem=Color3.fromRGB(25,25,28),Btn=Color3.fromRGB(35,35,38),Text=Color3.fromRGB(180,180,180),TitleText=Color3.fromRGB(220,220,220)},
    Blue={Accent=Color3.fromRGB(60,100,255),Bg=Color3.fromRGB(12,14,22),Tab=Color3.fromRGB(10,12,18),Elem=Color3.fromRGB(22,25,38),Btn=Color3.fromRGB(32,35,48),Text=Color3.fromRGB(200,210,255),TitleText=Color3.fromRGB(220,230,255)},
    Green={Accent=Color3.fromRGB(60,255,100),Bg=Color3.fromRGB(10,18,12),Tab=Color3.fromRGB(8,15,10),Elem=Color3.fromRGB(20,30,22),Btn=Color3.fromRGB(30,40,32),Text=Color3.fromRGB(200,255,210),TitleText=Color3.fromRGB(220,255,230)},
    Purple={Accent=Color3.fromRGB(180,60,255),Bg=Color3.fromRGB(16,10,24),Tab=Color3.fromRGB(14,8,20),Elem=Color3.fromRGB(28,20,38),Btn=Color3.fromRGB(38,30,48),Text=Color3.fromRGB(220,200,255),TitleText=Color3.fromRGB(240,230,255)},
    Cyan={Accent=Color3.fromRGB(0,200,200),Bg=Color3.fromRGB(10,18,20),Tab=Color3.fromRGB(8,15,17),Elem=Color3.fromRGB(20,30,32),Btn=Color3.fromRGB(30,40,42),Text=Color3.fromRGB(200,255,255),TitleText=Color3.fromRGB(220,255,255)},
    Orange={Accent=Color3.fromRGB(255,150,50),Bg=Color3.fromRGB(22,15,8),Tab=Color3.fromRGB(18,12,6),Elem=Color3.fromRGB(35,25,15),Btn=Color3.fromRGB(45,35,25),Text=Color3.fromRGB(255,230,200),TitleText=Color3.fromRGB(255,240,220)},
    Pink={Accent=Color3.fromRGB(255,100,200),Bg=Color3.fromRGB(22,10,16),Tab=Color3.fromRGB(18,8,14),Elem=Color3.fromRGB(32,20,26),Btn=Color3.fromRGB(42,30,36),Text=Color3.fromRGB(255,200,230),TitleText=Color3.fromRGB(255,220,240)},
    White={Accent=Color3.fromRGB(255,255,255),Bg=Color3.fromRGB(18,18,20),Tab=Color3.fromRGB(15,15,17),Elem=Color3.fromRGB(28,28,32),Btn=Color3.fromRGB(38,38,42),Text=Color3.fromRGB(240,240,240),TitleText=Color3.fromRGB(50,50,50)},
    Yellow={Accent=Color3.fromRGB(255,255,50),Bg=Color3.fromRGB(20,20,8),Tab=Color3.fromRGB(16,16,6),Elem=Color3.fromRGB(32,32,18),Btn=Color3.fromRGB(42,42,28),Text=Color3.fromRGB(255,255,200),TitleText=Color3.fromRGB(50,50,20)},
    Lime={Accent=Color3.fromRGB(150,255,50),Bg=Color3.fromRGB(10,20,8),Tab=Color3.fromRGB(8,16,6),Elem=Color3.fromRGB(20,32,18),Btn=Color3.fromRGB(30,42,28),Text=Color3.fromRGB(200,255,180),TitleText=Color3.fromRGB(220,255,200)}
}

local ESPData, lockedTarget = {}, nil
local uiHovered, animating = false, false
local ToggleButtons, refreshers = {}, {}
local clickerThread, flyConn, flyBV, ncConn, afkThread, rejoinConn = nil, nil, nil, nil, nil, nil
local espRenderConn, chamPulseConn = nil, nil
local listeningForBind, settingBind = false, nil
local originalLighting = nil

local fpsFrames, fpsAccum, currentFPS = 0, 0, 0
local currentPing = 0
local fpsSum, fpsSamples = 0, 0
local fpsMin, fpsMax = 999, 0
local lastVisibilityCheck = {}

local function getTheme() return Themes[Settings.UI.Theme] or Themes.Red end
local function getColor(k) return Settings.UI.Custom[k] or getTheme()[k] end
local function addR(fn) table.insert(refreshers, fn) end
local function refreshAll() for _, fn in pairs(refreshers) do pcall(fn) end end

local function saveSettings()
    pcall(function() writefile("NC_v5.json", HttpService:JSONEncode(Settings)) end)
end
local function loadSettings()
    pcall(function()
        if isfile and isfile("NC_v5.json") then
            local d = HttpService:JSONDecode(readfile("NC_v5.json"))
            for k,v in pairs(d) do
                if type(v)=="table" and Settings[k] then
                    for k2,v2 in pairs(v) do if Settings[k][k2]~=nil then Settings[k][k2]=v2 end end
                end
            end
        end
    end)
end
loadSettings()

for _, g in pairs({"ESP","Chams","Aimbot","AutoClicker"}) do
    if Settings[g] then Settings[g].Enabled=false end
end
Settings.Misc.Fly=false Settings.Misc.NoClip=false Settings.Misc.Speed=false
Settings.Misc.JumpPower=false Settings.Misc.Fullbright=false Settings.Misc.AntiAFK=false
Settings.Misc.AutoRejoin=false Settings.Misc.Bunnyhop=false

-- ============ HELPERS ============
local function isSameTeam(p)
    if not p or not LocalPlayer then return false end
    return p.Team ~= nil and LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team
end
local function hasForceField(p)
    if not p or not p.Character then return false end
    return p.Character:FindFirstChildOfClass("ForceField") ~= nil
end
local function isAlive(p)
    if not p or not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0 or false
end

local function isVisible(tp)
    if not tp then return false end
    local now = tick()
    if lastVisibilityCheck[tp] and now - lastVisibilityCheck[tp].t < 0.1 then
        return lastVisibilityCheck[tp].v
    end
    local targetChar = tp.Parent
    local ro = Camera.CFrame.Position
    local rd = (tp.Position - ro).Unit * 1500
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {LocalPlayer.Character}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character ~= targetChar then
            table.insert(filter, p.Character)
        end
    end
    rp.FilterDescendantsInstances = filter
    local rr = workspace:Raycast(ro, rd, rp)
    local v
    if rr == nil then v = true
    elseif rr.Instance:IsDescendantOf(targetChar) then v = true
    else v = false end
    lastVisibilityCheck[tp] = {v=v, t=now}
    return v
end

local function isMouseOverUI()
    local mp = UserInputService:GetMouseLocation()
    if mainFrame and mainFrame.Visible then
        local p, s = mainFrame.AbsolutePosition, mainFrame.AbsoluteSize
        if mp.X>=p.X and mp.X<=p.X+s.X and mp.Y>=p.Y and mp.Y<=p.Y+s.Y then return true end
    end
    if actionBarFrame and actionBarFrame.Visible then
        local p, s = actionBarFrame.AbsolutePosition, actionBarFrame.AbsoluteSize
        if mp.X>=p.X and mp.X<=p.X+s.X and mp.Y>=p.Y and mp.Y<=p.Y+s.Y then return true end
    end
    return false
end

local function safeClick()
    if uiHovered or isMouseOverUI() then return end
    task.spawn(function()
        pcall(function()
            local mp = UserInputService:GetMouseLocation()
            VIM:SendMouseButtonEvent(mp.X, mp.Y, 0, true, game, 0)
            task.wait(0.01)
            VIM:SendMouseButtonEvent(mp.X, mp.Y, 0, false, game, 0)
        end)
    end)
end

-- ============ NOTIFICATIONS ============
local activeNotifs = {}
local function notify(title, text, ntype)
    local color = ntype=="success" and Color3.fromRGB(60,200,60) or ntype=="error" and Color3.fromRGB(255,60,60) or ntype=="warning" and Color3.fromRGB(255,180,50) or Color3.fromRGB(60,130,255)
    local icon = ntype=="success" and "✓" or ntype=="error" and "✕" or ntype=="warning" and "!" or "i"
    local n = Instance.new("Frame", gui)
    n.Size = UDim2.new(0,0,0,50)
    n.Position = UDim2.new(0.5,-160,0.72,60)
    n.BackgroundColor3 = Color3.fromRGB(15,15,20)
    n.BackgroundTransparency = 1
    n.BorderSizePixel = 0
    n.ZIndex = 1000
    Instance.new("UICorner", n).CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", n)
    st.Color = color st.Thickness = 1.5 st.Transparency = 1
    local ic = Instance.new("TextLabel", n)
    ic.Size = UDim2.new(0,28,1,0) ic.Position = UDim2.new(0,12,0,0) ic.BackgroundTransparency = 1
    ic.Text = icon ic.TextColor3 = color ic.Font = Enum.Font.GothamBold ic.TextSize = 18 ic.ZIndex = 1001
    local tl = Instance.new("TextLabel", n)
    tl.Size = UDim2.new(1,-55,0,22) tl.Position = UDim2.new(0,45,0,4) tl.BackgroundTransparency = 1
    tl.Text = title tl.TextColor3 = Color3.new(1,1,1) tl.Font = Enum.Font.GothamBold tl.TextSize = 12
    tl.TextXAlignment = Enum.TextXAlignment.Left tl.ZIndex = 1001
    local tx = Instance.new("TextLabel", n)
    tx.Size = UDim2.new(1,-55,0,18) tx.Position = UDim2.new(0,45,0,26) tx.BackgroundTransparency = 1
    tx.Text = text tx.TextColor3 = Color3.fromRGB(180,180,180) tx.Font = Enum.Font.Gotham tx.TextSize = 10
    tx.TextXAlignment = Enum.TextXAlignment.Left tx.ZIndex = 1001
    table.insert(activeNotifs, 1, n)
    for i,v in ipairs(activeNotifs) do
        TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5,-160,0.72,60-(i-1)*60)}):Play()
    end
    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0,320,0,50), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(st, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    task.delay(2.5, function()
        if not n or not n.Parent then return end
        local idx = table.find(activeNotifs, n)
        if idx then table.remove(activeNotifs, idx) end
        TweenService:Create(n, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,50), BackgroundTransparency = 1}):Play()
        for _, c in pairs({ic, tl, tx}) do TweenService:Create(c, TweenInfo.new(0.25), {TextTransparency = 1}):Play() end
        task.wait(0.25) n:Destroy()
        for i,v in ipairs(activeNotifs) do
            TweenService:Create(v, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5,-160,0.72,60-(i-1)*60)}):Play()
        end
    end)
end

-- ============ GUI ============
local W, H = Settings.UI.LastSize.w, Settings.UI.LastSize.h
local lastPosUDim = UDim2.new(Settings.UI.LastPos.sx, Settings.UI.LastPos.ox, Settings.UI.LastPos.sy, Settings.UI.LastPos.oy)

gui = Instance.new("ScreenGui", guiParent)
gui.Name = guiName gui.ResetOnSpawn = false gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,W,0,H)
mainFrame.Position = lastPosUDim
mainFrame.BackgroundColor3 = getColor("Bg")
mainFrame.BackgroundTransparency = 1 - (Settings.UI.Opacity/100)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.ZIndex = 10
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14)

mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 2
mainStroke.Color = getColor("Accent")
mainStroke.Transparency = 0.4

glowLayer = Instance.new("Frame", gui)
glowLayer.Size = UDim2.new(0,0,0,0)
glowLayer.BackgroundColor3 = getColor("Accent")
glowLayer.BackgroundTransparency = 0.9
glowLayer.BorderSizePixel = 0
glowLayer.ZIndex = 9
glowLayer.Visible = Settings.UI.Glow
Instance.new("UICorner", glowLayer).CornerRadius = UDim.new(0,20)

actionBarFrame = Instance.new("Frame", gui)
actionBarFrame.Size = UDim2.new(0,60,0,30)
actionBarFrame.Position = UDim2.new(0.02,0,0.02,0)
actionBarFrame.BackgroundColor3 = getColor("Tab")
actionBarFrame.BorderSizePixel = 0
actionBarFrame.Visible = false
actionBarFrame.ZIndex = 11
Instance.new("UICorner", actionBarFrame).CornerRadius = UDim.new(0,8)
actionBarBtn = Instance.new("TextButton", actionBarFrame)
actionBarBtn.Size = UDim2.new(1,0,1,0) actionBarBtn.BackgroundTransparency = 1
actionBarBtn.Text = "NC" actionBarBtn.TextColor3 = getColor("Accent")
actionBarBtn.Font = Enum.Font.GothamBlack actionBarBtn.TextSize = 14 actionBarBtn.ZIndex = 12
actionBarBtn.MouseButton1Click:Connect(function()
    actionBarFrame.Visible = false
    mainFrame.Visible = true
    mainFrame.BackgroundTransparency = 1 - (Settings.UI.Opacity/100)
    if not Settings.UI.Minimized then
        tabHolder.Visible = true
        subtitleLbl.Visible = true
        for n, c in pairs(TabContents) do c.scroll.Visible = n == currentTab end
    end
end)

mainFrame.MouseEnter:Connect(function() uiHovered = true end)
mainFrame.MouseLeave:Connect(function() uiHovered = false end)
mainFrame.Changed:Connect(function(p)
    if p == "Position" and not animating then
        Settings.UI.LastPos = {sx=mainFrame.Position.X.Scale, ox=mainFrame.Position.X.Offset, sy=mainFrame.Position.Y.Scale, oy=mainFrame.Position.Y.Offset}
    end
end)

addR(function()
    mainFrame.BackgroundColor3 = getColor("Bg")
    mainStroke.Color = getColor("Accent")
    glowLayer.BackgroundColor3 = getColor("Accent")
    actionBarFrame.BackgroundColor3 = getColor("Tab")
    actionBarBtn.TextColor3 = getColor("Accent")
end)

-- TITLE
titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1,0,0,50)
titleBar.BackgroundColor3 = getColor("Tab")
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,14)

titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,getColor("Accent")), ColorSequenceKeypoint.new(1,getColor("Accent"):Lerp(Color3.new(1,1,1),0.5))}
titleGrad.Rotation = 90
titleGrad.Enabled = Settings.UI.Gradient
addR(function()
    titleBar.BackgroundColor3 = getColor("Tab")
    titleGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,getColor("Accent")), ColorSequenceKeypoint.new(1,getColor("Accent"):Lerp(Color3.new(1,1,1),0.5))}
end)

local iconF = Instance.new("Frame", titleBar)
iconF.Size = UDim2.new(0,28,0,28)
iconF.Position = UDim2.new(0,12,0.5,-14)
iconF.BackgroundColor3 = getColor("Accent")
iconF.BackgroundTransparency = 0.7
iconF.BorderSizePixel = 0
iconF.ZIndex = 12
Instance.new("UICorner", iconF).CornerRadius = UDim.new(0,7)
local iconT = Instance.new("TextLabel", iconF)
iconT.Size = UDim2.new(1,0,1,0) iconT.BackgroundTransparency = 1
iconT.Text = "😈" iconT.Font = Enum.Font.Gotham iconT.TextSize = 14 iconT.ZIndex = 13
addR(function() iconF.BackgroundColor3 = getColor("Accent") end)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(0,200,0,18)
titleLbl.Position = UDim2.new(0,48,0.5,-12)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "NOOBS COCO v5.0"
titleLbl.TextColor3 = getColor("TitleText")
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 16
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

subtitleLbl = Instance.new("TextLabel", titleBar)
subtitleLbl.Size = UDim2.new(0,300,0,14)
subtitleLbl.Position = UDim2.new(0,48,0.5,8)
subtitleLbl.BackgroundTransparency = 1
subtitleLbl.Text = "SniperLegends Edition"
subtitleLbl.TextColor3 = getColor("Text")
subtitleLbl.Font = Enum.Font.Gotham
subtitleLbl.TextSize = 9
subtitleLbl.TextXAlignment = Enum.TextXAlignment.Left
subtitleLbl.ZIndex = 12
addR(function() titleLbl.TextColor3 = getColor("TitleText") subtitleLbl.TextColor3 = getColor("Text") end)

fpsLbl = Instance.new("TextLabel", titleBar)
fpsLbl.Size = UDim2.new(0,140,0,20)
fpsLbl.Position = UDim2.new(1,-200,0.5,-10)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "FPS: -- | Ping: --"
fpsLbl.TextColor3 = Color3.fromRGB(100,255,100)
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextSize = 11
fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
fpsLbl.ZIndex = 13

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0,24,0,24)
minBtn.Position = UDim2.new(1,-64,0.5,-12)
minBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
minBtn.BackgroundTransparency = 0.3
minBtn.BorderSizePixel = 0
minBtn.Text = "_"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 12
minBtn.AutoButtonColor = false
minBtn.ZIndex = 12
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,24,0,24)
closeBtn.Position = UDim2.new(1,-34,0.5,-12)
closeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 12
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- TABS
tabHolder = Instance.new("Frame", mainFrame)
tabHolder.Size = UDim2.new(1,0,0,38)
tabHolder.Position = UDim2.new(0,0,0,50)
tabHolder.BackgroundColor3 = getColor("Tab")
tabHolder.BorderSizePixel = 0
tabHolder.ZIndex = 11
Instance.new("UICorner", tabHolder).CornerRadius = UDim.new(0,12)
addR(function() tabHolder.BackgroundColor3 = getColor("Tab") end)

local tabNames = {"Visuals", "Combat", "Misc", "Stats", "Settings"}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(1/#tabNames, -6, 0, 30)
    btn.Position = UDim2.new((i-1)/#tabNames, 3, 0, 4)
    btn.BackgroundColor3 = name == currentTab and getColor("Accent") or getColor("Elem")
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.AutoButtonColor = false
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    Tabs[name] = btn

    local sc = Instance.new("ScrollingFrame", mainFrame)
    sc.Size = UDim2.new(1,0,1,-88)
    sc.Position = UDim2.new(0,0,0,88)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 3
    sc.ScrollBarImageColor3 = getColor("Accent")
    sc.CanvasSize = UDim2.new(0,0,0,800)
    sc.Visible = name == currentTab
    sc.ZIndex = 10

    local inner = Instance.new("Frame", sc)
    inner.Size = UDim2.new(1,0,0,800)
    inner.BackgroundTransparency = 1
    inner.ZIndex = 10
    TabContents[name] = {scroll=sc, inner=inner}

    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for n, b in pairs(Tabs) do b.BackgroundColor3 = n == name and getColor("Accent") or getColor("Elem") end
        for n, c in pairs(TabContents) do c.scroll.Visible = n == name end
    end)
    addR(function()
        btn.BackgroundColor3 = name == currentTab and getColor("Accent") or getColor("Elem")
        sc.ScrollBarImageColor3 = getColor("Accent")
    end)
end

local function updateGlow()
    if Settings.UI.Glow then
        mainStroke.Transparency = 0.4
        glowLayer.Visible = true
    else
        mainStroke.Transparency = 0.7
        glowLayer.Visible = false
    end
end
addR(updateGlow)

trackConn(RunService.RenderStepped:Connect(function()
    if Settings.UI.Glow and mainFrame.Visible then
        glowLayer.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset-6, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset-6)
        glowLayer.Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset+12, mainFrame.Size.Y.Scale, mainFrame.Size.Y.Offset+12)
    end
end))

local function animateOpen()
    if animating then return end
    animating = true
    local targetSize = Settings.UI.Minimized and UDim2.new(0,340,0,50) or UDim2.new(0,W,0,H)
    local targetPos = UDim2.new(Settings.UI.LastPos.sx, Settings.UI.LastPos.ox, Settings.UI.LastPos.sy, Settings.UI.LastPos.oy)
    mainFrame.Visible = true
    mainFrame.Size = targetSize
    mainFrame.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset-300, targetPos.Y.Scale, targetPos.Y.Offset)
    mainFrame.BackgroundTransparency = 1
    if not Settings.UI.Minimized then
        tabHolder.Visible = true
        subtitleLbl.Visible = true
        for n, c in pairs(TabContents) do c.scroll.Visible = n == currentTab end
    end
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = targetPos, BackgroundTransparency = 1 - (Settings.UI.Opacity/100)
    }):Play()
    task.wait(0.4)
    animating = false
end

local function animateClose()
    if animating then return end
    animating = true
    local cp = mainFrame.Position
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(cp.X.Scale, cp.X.Offset-300, cp.Y.Scale, cp.Y.Offset),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.3)
    mainFrame.Visible = false
    mainFrame.Position = UDim2.new(Settings.UI.LastPos.sx, Settings.UI.LastPos.ox, Settings.UI.LastPos.sy, Settings.UI.LastPos.oy)
    animating = false
end

local function setMinimized()
    if animating then return end
    animating = true
    Settings.UI.Minimized = true
    for _, c in pairs(TabContents) do c.scroll.Visible = false end
    tabHolder.Visible = false
    subtitleLbl.Visible = false
    task.wait(0.05)
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0,340,0,50)}):Play()
    saveSettings()
    task.wait(0.3)
    animating = false
end

local function setMaximized()
    if animating then return end
    animating = true
    Settings.UI.Minimized = false
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0,W,0,H)}):Play()
    saveSettings()
    task.wait(0.3)
    tabHolder.Visible = true
    subtitleLbl.Visible = true
    for n, c in pairs(TabContents) do c.scroll.Visible = n == currentTab end
    animating = false
end

minBtn.MouseButton1Click:Connect(function() if Settings.UI.Minimized then setMaximized() else setMinimized() end end)
closeBtn.MouseButton1Click:Connect(function()
    if animating then return end
    Settings.UI.Hidden = true
    saveSettings()
    animateClose()
    task.delay(0.35, function()
        actionBarFrame.Visible = true
        actionBarBtn.TextColor3 = getColor("Accent")
    end)
end)

-- UI HELPERS
local function section(parent, name, y)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1,-16,0,28)
    s.Position = UDim2.new(0,8,0,y)
    s.BackgroundColor3 = getColor("Elem")
    s.BorderSizePixel = 0
    s.ZIndex = 11
    Instance.new("UICorner", s).CornerRadius = UDim.new(0,10)
    local st = Instance.new("UIStroke", s)
    st.Thickness = 1
    st.Color = getColor("Accent")
    st.Transparency = 0.7
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1,-24,1,0)
    l.Position = UDim2.new(0,15,0,0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    addR(function() s.BackgroundColor3 = getColor("Elem") st.Color = getColor("Accent") end)
    return y + 32
end

local function toggle(parent, text, y, def, cb, id)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-16,0,32)
    f.Position = UDim2.new(0,8,0,y)
    f.BackgroundColor3 = getColor("Elem")
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6,0,1,0)
    l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = getColor("Text")
    l.Font = Enum.Font.Gotham
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0,46,0,22)
    b.Position = UDim2.new(1,-52,0.5,-11)
    b.BorderSizePixel = 0
    b.BackgroundColor3 = def and Color3.fromRGB(40,200,40) or getColor("Btn")
    b.Text = def and "ON" or "OFF"
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    local state = def
    if id then ToggleButtons[id] = {button=b, state=state} end
    addR(function()
        f.BackgroundColor3 = getColor("Elem")
        l.TextColor3 = getColor("Text")
        if not state then b.BackgroundColor3 = getColor("Btn") end
    end)
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "ON" or "OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(40,200,40) or getColor("Btn")
        if id and ToggleButtons[id] then ToggleButtons[id].state = state end
        cb(state) saveSettings()
    end)
    return y + 35
end

local function updateToggleVisual(id, state)
    if ToggleButtons[id] then
        ToggleButtons[id].state = state
        ToggleButtons[id].button.Text = state and "ON" or "OFF"
        ToggleButtons[id].button.BackgroundColor3 = state and Color3.fromRGB(40,200,40) or getColor("Btn")
    end
end

local function dropdown(parent, text, y, opts, defIdx, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-16,0,56)
    f.Position = UDim2.new(0,8,0,y)
    f.BackgroundColor3 = getColor("Elem")
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,-16,0,18)
    l.Position = UDim2.new(0,8,0,4)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = getColor("Text")
    l.Font = Enum.Font.Gotham
    l.TextSize = 8
    l.ZIndex = 12
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1,-16,0,26)
    b.Position = UDim2.new(0,8,0,26)
    b.BackgroundColor3 = getColor("Btn")
    b.BorderSizePixel = 0
    b.Text = opts[defIdx] or opts[1]
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 9
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    addR(function()
        f.BackgroundColor3 = getColor("Elem")
        l.TextColor3 = getColor("Text")
        b.BackgroundColor3 = getColor("Btn")
    end)
    local idx = defIdx or 1
    b.MouseButton1Click:Connect(function()
        idx = idx % #opts + 1
        b.Text = opts[idx]
        cb(opts[idx]) saveSettings()
    end)
    return y + 59
end

local function slider(parent, text, y, min, max, def, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-16,0,50)
    f.Position = UDim2.new(0,8,0,y)
    f.BackgroundColor3 = getColor("Elem")
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,-16,0,18)
    l.Position = UDim2.new(0,8,0,4)
    l.BackgroundTransparency = 1
    l.Text = text..": "..string.format("%.2f", def)
    l.TextColor3 = getColor("Text")
    l.Font = Enum.Font.Gotham
    l.TextSize = 8
    l.ZIndex = 12
    local bar = Instance.new("TextButton", f)
    bar.Size = UDim2.new(1,-16,0,16)
    bar.Position = UDim2.new(0,8,0,26)
    bar.BackgroundColor3 = getColor("Btn")
    bar.BorderSizePixel = 0
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.ZIndex = 12
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,9)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = getColor("Accent")
    fill.BorderSizePixel = 0
    fill.ZIndex = 13
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,9)
    addR(function()
        f.BackgroundColor3 = getColor("Elem")
        l.TextColor3 = getColor("Text")
        bar.BackgroundColor3 = getColor("Btn")
        fill.BackgroundColor3 = getColor("Accent")
    end)
    local val, drag = def, false
    local function upd()
        local mp = UserInputService:GetMouseLocation()
        local rx = math.clamp((mp.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        val = min + (max-min)*rx
        fill.Size = UDim2.new(rx,0,1,0)
        l.Text = text..": "..string.format("%.2f", val)
        cb(val)
    end
    bar.MouseButton1Down:Connect(function() drag = true upd() end)
    trackConn(UserInputService.InputChanged:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseMovement and drag then upd() end end))
    trackConn(UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false saveSettings() end end))
    return y + 53
end

local bindButtons = {}
local function createBindButton(parent, text, y, bindValue, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-16,0,34)
    f.Position = UDim2.new(0,8,0,y)
    f.BackgroundColor3 = getColor("Elem")
    f.BorderSizePixel = 0
    f.ZIndex = 11
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.4,0,1,0)
    l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = getColor("Text")
    l.Font = Enum.Font.Gotham
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 12
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0,70,0,24)
    b.Position = UDim2.new(1,-78,0.5,-12)
    b.BorderSizePixel = 0
    b.BackgroundColor3 = getColor("Btn")
    b.Text = bindValue
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8
    b.AutoButtonColor = false
    b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    addR(function()
        f.BackgroundColor3 = getColor("Elem")
        l.TextColor3 = getColor("Text")
        b.BackgroundColor3 = getColor("Btn")
    end)
    b.MouseButton1Click:Connect(function()
        listeningForBind = true
        settingBind = function(key)
            cb(key) b.Text = key
            listeningForBind = false settingBind = nil
            saveSettings()
        end
        b.Text = "..."
    end)
    bindButtons[text] = b
    return y + 37
end
local function updateBindButton(text, key) if bindButtons[text] then bindButtons[text].Text = key end end

-- ============ ESP ============
local function createESP(player)
    if ESPData[player] then
        for _, key in pairs({"lines","nt","dt","ht","hbg","hf","tracer","snapline"}) do
            local obj = ESPData[player][key]
            if obj then
                if type(obj)=="table" then for _, o in pairs(obj) do pcall(function() o:Remove() end) end
                else pcall(function() obj:Remove() end) end
            end
        end
    end
    ESPData[player] = {lines={}}
    local lines = {}
    for i = 1, 8 do
        local l = Drawing.new("Line") l.Visible=false lines[i]=l trackDraw(l)
    end
    local nt = Drawing.new("Text") nt.Visible=false nt.Center=true nt.Size=14 nt.Font=3 nt.Outline=true trackDraw(nt)
    local dt = Drawing.new("Text") dt.Visible=false dt.Center=true dt.Size=12 dt.Font=3 dt.Outline=true trackDraw(dt)
    local ht = Drawing.new("Text") ht.Visible=false ht.Center=true ht.Size=11 ht.Font=3 ht.Outline=true trackDraw(ht)
    local hbg = Drawing.new("Square") hbg.Visible=false hbg.Filled=true hbg.Color=Color3.fromRGB(15,15,15) hbg.Transparency=0.4 trackDraw(hbg)
    local hf = Drawing.new("Square") hf.Visible=false hf.Filled=true trackDraw(hf)
    local tracer = Drawing.new("Line") tracer.Visible=false tracer.Thickness=1.5 trackDraw(tracer)
    local snapline = Drawing.new("Line") snapline.Visible=false snapline.Thickness=1.5 trackDraw(snapline)
    ESPData[player].lines=lines ESPData[player].nt=nt ESPData[player].dt=dt ESPData[player].ht=ht
    ESPData[player].hbg=hbg ESPData[player].hf=hf ESPData[player].tracer=tracer ESPData[player].snapline=snapline
end

local function hideESP(data)
    for _, l in pairs(data.lines) do l.Visible=false end
    data.nt.Visible=false data.dt.Visible=false data.ht.Visible=false
    data.hbg.Visible=false data.hf.Visible=false
    data.tracer.Visible=false data.snapline.Visible=false
end

local function updateESPForPlayer(player, data)
    local c = player.Character
    if not c or not isAlive(player) or not Settings.ESP.Enabled then hideESP(data) return end
    if Settings.ESP.TeamCheck and isSameTeam(player) then hideESP(data) return end
    local h = c:FindFirstChild("Head") local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r then hideESP(data) return end
    local hp = h.Position + Vector3.new(0,0.5,0)
    local rp = r.Position - Vector3.new(0,2,0)
    local cp = r.Position + Vector3.new(0, math.abs(h.Position.Y-r.Position.Y), 0)
    local ts = Camera:WorldToViewportPoint(hp)
    local bs = Camera:WorldToViewportPoint(rp)
    if ts.Z <= 0 then hideESP(data) return end
    local dist = (Camera.CFrame.Position - cp).Magnitude
    if dist > Settings.ESP.MaxDistance then hideESP(data) return end
    local bw = math.clamp((2.5/dist)*500, 20, 200)
    local cs = Camera:WorldToViewportPoint(cp)
    local lx, rx = cs.X-bw/2, cs.X+bw/2
    local ty, by = ts.Y, bs.Y
    local color = Settings.ESP.Color=="Rainbow" and Color3.fromHSV(tick()%5/5,1,1) or (Colors[Settings.ESP.Color] or Colors.White)
    local lines = data.lines
    for i=1,8 do lines[i].Visible=false end
    if Settings.ESP.BoxType=="Full" or Settings.ESP.BoxType=="Corner+Full" then
        for i=1,4 do lines[i].Visible=true lines[i].Color=color lines[i].Thickness=Settings.ESP.Thickness lines[i].Transparency=Settings.ESP.Transparency end
        lines[1].From=Vector2.new(lx,ty) lines[1].To=Vector2.new(rx,ty)
        lines[2].From=Vector2.new(rx,ty) lines[2].To=Vector2.new(rx,by)
        lines[3].From=Vector2.new(rx,by) lines[3].To=Vector2.new(lx,by)
        lines[4].From=Vector2.new(lx,by) lines[4].To=Vector2.new(lx,ty)
    end
    if Settings.ESP.BoxType=="Corner" or Settings.ESP.BoxType=="Corner+Full" then
        local cs2 = math.min(bw*0.3, 30)
        for i=5,8 do lines[i].Visible=true lines[i].Color=color lines[i].Thickness=Settings.ESP.Thickness+1 lines[i].Transparency=Settings.ESP.Transparency end
        lines[5].From=Vector2.new(lx,ty) lines[5].To=Vector2.new(lx+cs2,ty)
        lines[6].From=Vector2.new(rx,ty) lines[6].To=Vector2.new(rx-cs2,ty)
        lines[7].From=Vector2.new(rx,by) lines[7].To=Vector2.new(rx-cs2,by)
        lines[8].From=Vector2.new(lx,by) lines[8].To=Vector2.new(lx+cs2,by)
    end
    if Settings.ESP.Name then data.nt.Visible=true data.nt.Text=player.Name data.nt.Position=Vector2.new(cs.X, ty-20) data.nt.Color=Color3.new(1,1,1) else data.nt.Visible=false end
    if Settings.ESP.Distance then data.dt.Visible=true data.dt.Text=math.floor(dist).."m" data.dt.Position=Vector2.new(cs.X, by+5) data.dt.Color=Color3.new(1,1,1) else data.dt.Visible=false end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        local health = math.clamp(hum.Health/hum.MaxHealth, 0, 1)
        if Settings.ESP.HealthText then
            data.ht.Visible=true
            data.ht.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            data.ht.Position = Vector2.new(cs.X, by+18)
            data.ht.Color = Color3.fromHSV(health*0.33,1,1)
        else data.ht.Visible=false end
        if Settings.ESP.HealthBar then
            local bh = by-ty local bx = lx-7
            data.hbg.Visible=true data.hbg.Size=Vector2.new(3,bh) data.hbg.Position=Vector2.new(bx,ty)
            data.hf.Visible=true data.hf.Size=Vector2.new(3,math.max(bh*health,0)) data.hf.Position=Vector2.new(bx, ty+bh*(1-health)) data.hf.Color=Color3.fromHSV(health*0.33,1,1)
        else data.hbg.Visible=false data.hf.Visible=false end
    end
    if Settings.ESP.Tracers then
        data.tracer.Visible=true
        data.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
        data.tracer.To = Vector2.new(cs.X, by)
        data.tracer.Color = color
    else data.tracer.Visible=false end
    if Settings.ESP.Snaplines then
        data.snapline.Visible=true
        data.snapline.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        data.snapline.To = Vector2.new(cs.X, ty)
        data.snapline.Color = color
    else data.snapline.Visible=false end
end

local function startESPRender()
    if espRenderConn then return end
    espRenderConn = RunService.RenderStepped:Connect(function()
        for player, data in pairs(ESPData) do
            pcall(updateESPForPlayer, player, data)
        end
    end)
    trackConn(espRenderConn)
end

-- ============ CHAMS ============
local function applyChams(player)
    if not player.Character then return end
    local c = player.Character
    local old = c:FindFirstChild(chamName)
    if old then old:Destroy() end
    if not Settings.Chams.Enabled then return end
    local hl = Instance.new("Highlight")
    hl.Name = chamName
    hl.Enabled = true
    hl.FillTransparency = Settings.Chams.FillTrans
    hl.OutlineTransparency = Settings.Chams.OutlineTrans
    hl.Adornee = c
    hl.Parent = c
    local col = Colors[Settings.Chams.Color] or Color3.new(1,1,1)
    hl.FillColor = col
    hl.OutlineColor = col
end

local function startChamPulse()
    if chamPulseConn then return end
    chamPulseConn = RunService.RenderStepped:Connect(function()
        local phase = (math.sin(tick()*2)+1)/2
        local bw = Color3.fromRGB(0,0,0):Lerp(Color3.fromRGB(255,255,255), phase)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild(chamName)
                if hl then hl.FillColor=bw hl.OutlineColor=bw end
            end
        end
    end)
    trackConn(chamPulseConn)
end

local function stopChamPulse()
    if chamPulseConn then chamPulseConn:Disconnect() chamPulseConn=nil end
end

local function refreshAllChams()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then pcall(applyChams, p) end
    end
    if Settings.Chams.Enabled and Settings.Chams.Pulse then startChamPulse() else stopChamPulse() end
end

-- ============ AIMBOT TARGET ============
local function getTarget()
    if Settings.Aimbot.TargetLock and lockedTarget then
        local char = lockedTarget.Character
        if char and isAlive(lockedTarget) and not hasForceField(lockedTarget) and not isSameTeam(lockedTarget) then
            local tp = char:FindFirstChild(Settings.Aimbot.TargetPart)
            if tp then
                local sp = Camera:WorldToViewportPoint(tp.Position)
                local d = (Vector2.new(sp.X,sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                local inFov = Settings.Aimbot.UnlockFOV or (sp.Z > 0 and d <= Settings.Aimbot.FOV)
                local visible = not Settings.Aimbot.VisibleCheck or isVisible(tp)
                if inFov and visible then return tp, d end
            end
        end
        lockedTarget = nil
    end
    local best, bestDist = nil, Settings.Aimbot.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or not isAlive(p) then continue end
        if isSameTeam(p) or hasForceField(p) then continue end
        local tp = p.Character:FindFirstChild(Settings.Aimbot.TargetPart)
        if not tp then continue end
        local sp = Camera:WorldToViewportPoint(tp.Position)
        if not Settings.Aimbot.UnlockFOV and sp.Z <= 0 then continue end
        if Settings.Aimbot.VisibleCheck and not isVisible(tp) then continue end
        local d = (Vector2.new(sp.X,sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
        if d < bestDist then bestDist = d best = tp lockedTarget = p end
    end
    return best, bestDist
end

-- ============ MISC FUNCS ============
function startClicker()
    stopClicker()
    local running = true
    clickerThread = {stop = function() running = false end}
    task.spawn(function()
        while running and Settings.AutoClicker.Enabled do
            safeClick()
            task.wait(1/Settings.AutoClicker.CPS)
        end
    end)
end
function stopClicker() if clickerThread then clickerThread.stop() clickerThread=nil end end

function startAntiAFK()
    stopAntiAFK()
    local running = true
    afkThread = {stop = function() running = false end}
    task.spawn(function()
        while running and Settings.Misc.AntiAFK do
            task.wait(30)
            pcall(function()
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end)
end
function stopAntiAFK() if afkThread then afkThread.stop() afkThread=nil end end

function startFly()
    stopFly()
    local c = LocalPlayer.Character if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    if not r or not h then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "NC_Fly_"..guiSuffix
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.Velocity = Vector3.zero
    bv.Parent = r
    h.PlatformStand = true
    flyBV = bv
    flyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Misc.Fly then stopFly() return end
        if not r or not r.Parent or not bv or not bv.Parent then stopFly() return end
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel -= Vector3.new(0,1,0) end
        if vel.Magnitude > 0 then vel = vel.Unit * Settings.Misc.FlySpeed end
        bv.Velocity = vel
    end)
    trackConn(flyConn)
end
function stopFly()
    if flyConn then flyConn:Disconnect() flyConn=nil end
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV=nil end
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
    end
end

function enableNC()
    if ncConn then return end
    ncConn = RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
    trackConn(ncConn)
end
function disableNC() if ncConn then ncConn:Disconnect() ncConn=nil end end

function updSpeed()
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = Settings.Misc.Speed and Settings.Misc.SpeedVal or 16 end
    end
end
function updJump()
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower=true h.JumpPower = Settings.Misc.JumpPower and Settings.Misc.JumpVal or 50 end
    end
end

function setFullbright(enabled)
    if enabled then
        if not originalLighting then
            originalLighting = {
                Brightness = Lighting.Brightness, Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient, FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart, GlobalShadows = Lighting.GlobalShadows,
                ClockTime = Lighting.ClockTime
            }
        end
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 12
    elseif originalLighting then
        Lighting.Brightness = originalLighting.Brightness
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.ClockTime = originalLighting.ClockTime
        originalLighting = nil
    end
end

-- ============ VISUALS TAB ============
local y = 6
local inner = TabContents["Visuals"].inner
y = section(inner, "ESP", y)
y = toggle(inner, "Enabled", y, Settings.ESP.Enabled, function(s)
    Settings.ESP.Enabled = s
    if s then startESPRender() end
    notify("ESP", s and "Включён" or "Выключен", s and "success" or "error")
end, "ESP")
y = dropdown(inner, "Box Type", y, {"Corner","Full","Corner+Full"}, 1, function(o) Settings.ESP.BoxType = o end)
y = dropdown(inner, "Color", y, {"White","Red","Green","Blue","Purple","Yellow","Cyan","Rainbow"}, 1, function(o) Settings.ESP.Color = o end)
y = slider(inner, "Thickness", y, 1, 5, Settings.ESP.Thickness, function(v) Settings.ESP.Thickness = v end)
y = slider(inner, "Transparency", y, 0, 1, Settings.ESP.Transparency, function(v) Settings.ESP.Transparency = v end)
y = slider(inner, "Max Distance", y, 50, 2000, Settings.ESP.MaxDistance, function(v) Settings.ESP.MaxDistance = v end)
y = toggle(inner, "Team Check", y, Settings.ESP.TeamCheck, function(s) Settings.ESP.TeamCheck = s end)
y = toggle(inner, "Name", y, Settings.ESP.Name, function(s) Settings.ESP.Name = s end)
y = toggle(inner, "Distance", y, Settings.ESP.Distance, function(s) Settings.ESP.Distance = s end)
y = toggle(inner, "HP Bar", y, Settings.ESP.HealthBar, function(s) Settings.ESP.HealthBar = s end)
y = toggle(inner, "Health Text", y, Settings.ESP.HealthText, function(s) Settings.ESP.HealthText = s end)
y = toggle(inner, "Tracers", y, Settings.ESP.Tracers, function(s) Settings.ESP.Tracers = s end)
y = toggle(inner, "Snaplines", y, Settings.ESP.Snaplines, function(s) Settings.ESP.Snaplines = s end)
y = createBindButton(inner, "ESP Bind", y, Settings.ESP.Bind, function(key) Settings.ESP.Bind = key updateBindButton("ESP", key) end)

y = y + 4
y = section(inner, "CHAMS", y)
y = toggle(inner, "Enabled", y, Settings.Chams.Enabled, function(s)
    Settings.Chams.Enabled = s
    refreshAllChams()
    notify("Chams", s and "Включён" or "Выключен", s and "success" or "error")
end, "Chams")
y = dropdown(inner, "Color", y, {"White","Red","Green","Blue","Purple","Yellow","Cyan","Pink","Orange"}, 1, function(o)
    Settings.Chams.Color = o
    refreshAllChams()
end)
y = slider(inner, "Fill Trans", y, 0, 1, Settings.Chams.FillTrans, function(v)
    Settings.Chams.FillTrans = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild(chamName)
            if hl then hl.FillTransparency = v end
        end
    end
end)
y = slider(inner, "Outline Trans", y, 0, 1, Settings.Chams.OutlineTrans, function(v)
    Settings.Chams.OutlineTrans = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild(chamName)
            if hl then hl.OutlineTransparency = v end
        end
    end
end)
y = toggle(inner, "Pulse (bw)", y, Settings.Chams.Pulse, function(s)
    Settings.Chams.Pulse = s
    if s and Settings.Chams.Enabled then startChamPulse() else stopChamPulse() end
end)
y = createBindButton(inner, "Chams Bind", y, Settings.Chams.Bind, function(key) Settings.Chams.Bind = key updateBindButton("Chams", key) end)
TabContents["Visuals"].scroll.CanvasSize = UDim2.new(0,0,0,y+20)

-- ============ COMBAT TAB ============
y = 6
inner = TabContents["Combat"].inner
y = section(inner, "AIMBOT (SNIPER)", y)
y = toggle(inner, "Enabled", y, Settings.Aimbot.Enabled, function(s)
    Settings.Aimbot.Enabled = s
    notify("Aimbot", s and "Включён" or "Выключен", s and "success" or "error")
end, "Aimbot")
y = dropdown(inner, "Target", y, {"UpperTorso","Head","HumanoidRootPart"}, 1, function(o) Settings.Aimbot.TargetPart = o end)
y = toggle(inner, "Aim Assist (soft)", y, Settings.Aimbot.AimAssist, function(s) Settings.Aimbot.AimAssist = s end)
y = toggle(inner, "Snap Aim (palevo)", y, Settings.Aimbot.SilentAim, function(s)
    Settings.Aimbot.SilentAim = s
    if s then notify("Snap Aim", "Камера жёстко снапится - видно на спектре", "warning") end
end)
y = toggle(inner, "Prediction", y, Settings.Aimbot.Prediction, function(s) Settings.Aimbot.Prediction = s end)
y = toggle(inner, "Visible Check", y, Settings.Aimbot.VisibleCheck, function(s) Settings.Aimbot.VisibleCheck = s end)
y = toggle(inner, "Unlock FOV", y, Settings.Aimbot.UnlockFOV, function(s) Settings.Aimbot.UnlockFOV = s end)
y = slider(inner, "FOV", y, 50, 500, Settings.Aimbot.FOV, function(v) Settings.Aimbot.FOV = v end)
y = slider(inner, "Smoothness", y, 1, 15, Settings.Aimbot.Smoothness, function(v) Settings.Aimbot.Smoothness = v end)
y = slider(inner, "Hit Chance %", y, 0, 100, Settings.Aimbot.HitChance, function(v) Settings.Aimbot.HitChance = v end)
y = dropdown(inner, "FOV Color", y, {"Red","Green","Blue","White","Yellow","Purple","Cyan"}, 1, function(o) Settings.Aimbot.FOVColor = o end)
y = toggle(inner, "FOV Visible", y, Settings.Aimbot.FOVVisible, function(s) Settings.Aimbot.FOVVisible = s end)
y = toggle(inner, "Trigger Bot", y, Settings.Aimbot.TriggerBot, function(s) Settings.Aimbot.TriggerBot = s end)
y = toggle(inner, "Target Lock", y, Settings.Aimbot.TargetLock, function(s) Settings.Aimbot.TargetLock = s end)
y = createBindButton(inner, "Aimbot Bind", y, Settings.Aimbot.Bind, function(key) Settings.Aimbot.Bind = key updateBindButton("Aimbot", key) end)

y = y + 4
y = section(inner, "AUTO CLICKER", y)
y = toggle(inner, "Enabled", y, Settings.AutoClicker.Enabled, function(s)
    Settings.AutoClicker.Enabled = s
    notify("Auto Clicker", s and "Включён" or "Выключен", s and "success" or "error")
    if s then startClicker() else stopClicker() end
end, "AutoClick")
y = slider(inner, "CPS", y, 1, 30, Settings.AutoClicker.CPS, function(v) Settings.AutoClicker.CPS = v end)
y = createBindButton(inner, "AutoClick Bind", y, Settings.AutoClicker.Bind, function(key) Settings.AutoClicker.Bind = key updateBindButton("AutoClick", key) end)
TabContents["Combat"].scroll.CanvasSize = UDim2.new(0,0,0,y+20)

-- ============ MISC TAB ============
y = 6
inner = TabContents["Misc"].inner
y = section(inner, "MOVEMENT", y)
y = toggle(inner, "Fly", y, Settings.Misc.Fly, function(s)
    Settings.Misc.Fly = s
    notify("Fly", s and "Включён" or "Выключен", s and "success" or "error")
    if s then startFly() else stopFly() end
end)
y = slider(inner, "Fly Speed", y, 10, 200, Settings.Misc.FlySpeed, function(v) Settings.Misc.FlySpeed = v end)
y = toggle(inner, "NoClip", y, Settings.Misc.NoClip, function(s)
    Settings.Misc.NoClip = s
    notify("NoClip", s and "Включён" or "Выключен", s and "success" or "error")
    if s then enableNC() else disableNC() end
end)
y = toggle(inner, "Speed", y, Settings.Misc.Speed, function(s)
    Settings.Misc.Speed = s
    notify("Speed", s and "Включён" or "Выключен", s and "success" or "error")
    updSpeed()
end)
y = slider(inner, "Speed Val", y, 16, 200, Settings.Misc.SpeedVal, function(v) Settings.Misc.SpeedVal = v updSpeed() end)
y = toggle(inner, "Jump Power", y, Settings.Misc.JumpPower, function(s) Settings.Misc.JumpPower = s updJump() end)
y = slider(inner, "Jump Val", y, 50, 300, Settings.Misc.JumpVal, function(v) Settings.Misc.JumpVal = v updJump() end)
y = toggle(inner, "Bunnyhop", y, Settings.Misc.Bunnyhop, function(s) Settings.Misc.Bunnyhop = s end)
y = toggle(inner, "Fullbright", y, Settings.Misc.Fullbright, function(s)
    Settings.Misc.Fullbright = s
    setFullbright(s)
end)

y = y + 4
y = section(inner, "UTILITY", y)
y = toggle(inner, "Anti AFK", y, Settings.Misc.AntiAFK, function(s)
    Settings.Misc.AntiAFK = s
    notify("Anti AFK", s and "Включён" or "Выключен", s and "success" or "error")
    if s then startAntiAFK() else stopAntiAFK() end
end)
y = toggle(inner, "Auto Rejoin", y, Settings.Misc.AutoRejoin, function(s)
    Settings.Misc.AutoRejoin = s
    notify("Auto Rejoin", s and "Включён" or "Выключен", s and "success" or "error")
    if s then
        if rejoinConn then rejoinConn:Disconnect() end
        rejoinConn = LocalPlayer.OnTeleport:Connect(function()
            if Settings.Misc.AutoRejoin then
                task.wait(5)
                pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
            end
        end)
        trackConn(rejoinConn)
    else
        if rejoinConn then rejoinConn:Disconnect() rejoinConn = nil end
    end
end)
TabContents["Misc"].scroll.CanvasSize = UDim2.new(0,0,0,y+20)

-- ============ STATS TAB ============
y = 6
inner = TabContents["Stats"].inner
y = section(inner, "FPS MONITOR", y)

fpsDisplayLbl = Instance.new("TextLabel", inner)
fpsDisplayLbl.Size = UDim2.new(1,-16,0,60)
fpsDisplayLbl.Position = UDim2.new(0,8,0,y)
fpsDisplayLbl.BackgroundColor3 = getColor("Elem")
fpsDisplayLbl.BorderSizePixel = 0
fpsDisplayLbl.Text = "FPS: --"
fpsDisplayLbl.TextColor3 = Color3.fromRGB(100,255,100)
fpsDisplayLbl.Font = Enum.Font.GothamBold
fpsDisplayLbl.TextSize = 28
fpsDisplayLbl.ZIndex = 11
Instance.new("UICorner", fpsDisplayLbl).CornerRadius = UDim.new(0,10)
addR(function() fpsDisplayLbl.BackgroundColor3 = getColor("Elem") end)
y = y + 70

statsInfoLbl = Instance.new("TextLabel", inner)
statsInfoLbl.Size = UDim2.new(1,-16,0,60)
statsInfoLbl.Position = UDim2.new(0,8,0,y)
statsInfoLbl.BackgroundColor3 = getColor("Elem")
statsInfoLbl.BorderSizePixel = 0
statsInfoLbl.Text = "Ping: -- | Min: -- | Max: -- | Avg: --"
statsInfoLbl.TextColor3 = getColor("Text")
statsInfoLbl.Font = Enum.Font.Gotham
statsInfoLbl.TextSize = 11
statsInfoLbl.ZIndex = 11
Instance.new("UICorner", statsInfoLbl).CornerRadius = UDim.new(0,10)
addR(function() statsInfoLbl.BackgroundColor3 = getColor("Elem") statsInfoLbl.TextColor3 = getColor("Text") end)
y = y + 70

local resetBtn = Instance.new("TextButton", inner)
resetBtn.Size = UDim2.new(1,-16,0,28)
resetBtn.Position = UDim2.new(0,8,0,y)
resetBtn.BackgroundColor3 = getColor("Accent")
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset Statistics"
resetBtn.TextColor3 = Color3.new(1,1,1)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 10
resetBtn.AutoButtonColor = false
resetBtn.ZIndex = 11
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,8)
addR(function() resetBtn.BackgroundColor3 = getColor("Accent") end)
resetBtn.MouseButton1Click:Connect(function()
    fpsSum, fpsSamples = 0, 0
    fpsMin, fpsMax = 999, 0
    notify("Stats", "Статистика сброшена", "info")
end)
y = y + 40
TabContents["Stats"].scroll.CanvasSize = UDim2.new(0,0,0,y+20)

-- ============ SETTINGS TAB ============
y = 6
inner = TabContents["Settings"].inner
y = section(inner, "THEME", y)
y = dropdown(inner, "Theme", y, {"Red","Dark","Blue","Green","Purple","Cyan","Orange","Pink","White","Yellow","Lime"}, 1, function(o)
    Settings.UI.Theme = o
    refreshAll() saveSettings()
end)
y = section(inner, "UI", y + 4)
y = slider(inner, "Opacity", y, 5, 100, Settings.UI.Opacity, function(v)
    Settings.UI.Opacity = v
    if mainFrame.Visible and not animating then mainFrame.BackgroundTransparency = 1 - (v/100) end
    saveSettings()
end)
y = toggle(inner, "Glow", y, Settings.UI.Glow, function(s)
    Settings.UI.Glow = s updateGlow() saveSettings()
end)
y = toggle(inner, "Gradient", y, Settings.UI.Gradient, function(s)
    Settings.UI.Gradient = s titleGrad.Enabled = s saveSettings()
end)
y = createBindButton(inner, "Menu Key", y, Settings.UI.MenuKey, function(key)
    Settings.UI.MenuKey = key
    updateBindButton("Menu Key", key)
end)
TabContents["Settings"].scroll.CanvasSize = UDim2.new(0,0,0,y+20)

-- ============ PLAYERS SETUP ============
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESP(p)
        applyChams(p)
        p.CharacterAdded:Connect(function() task.wait(0.3) applyChams(p) end)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        createESP(p)
        applyChams(p)
        p.CharacterAdded:Connect(function() task.wait(0.3) applyChams(p) end)
    end
end)
Players.PlayerRemoving:Connect(function(p)
    if lockedTarget == p then lockedTarget = nil end
    if ESPData[p] then
        for _, key in pairs({"lines","nt","dt","ht","hbg","hf","tracer","snapline"}) do
            local obj = ESPData[p][key]
            if obj then
                if type(obj) == "table" then for _, o in pairs(obj) do pcall(function() o:Remove() end) end
                else pcall(function() obj:Remove() end) end
            end
        end
        ESPData[p] = nil
    end
end)

-- ============ KEYBINDS ============
trackConn(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listeningForBind and settingBind then settingBind(input.KeyCode.Name) return end

    if Settings.UI.MenuKey ~= "None" and input.KeyCode.Name == Settings.UI.MenuKey then
        if animating then return end
        if mainFrame.Visible then
            Settings.UI.Hidden = true
            Settings.UI.LastPos = {sx=mainFrame.Position.X.Scale, ox=mainFrame.Position.X.Offset, sy=mainFrame.Position.Y.Scale, oy=mainFrame.Position.Y.Offset}
            saveSettings()
            animateClose()
            task.delay(0.35, function() actionBarFrame.Visible = true end)
        else
            actionBarFrame.Visible = false
            Settings.UI.Hidden = false
            animateOpen()
        end
        return
    end

    if Settings.ESP.Bind ~= "None" and input.KeyCode.Name == Settings.ESP.Bind then
        Settings.ESP.Enabled = not Settings.ESP.Enabled
        updateToggleVisual("ESP", Settings.ESP.Enabled)
        if Settings.ESP.Enabled then startESPRender() end
        notify("ESP (Bind)", Settings.ESP.Enabled and "Включён" or "Выключен", Settings.ESP.Enabled and "success" or "error")
    end

    if Settings.Chams.Bind ~= "None" and input.KeyCode.Name == Settings.Chams.Bind then
        Settings.Chams.Enabled = not Settings.Chams.Enabled
        updateToggleVisual("Chams", Settings.Chams.Enabled)
        refreshAllChams()
        notify("Chams (Bind)", Settings.Chams.Enabled and "Включён" or "Выключен", Settings.Chams.Enabled and "success" or "error")
    end

    if Settings.Aimbot.Bind ~= "None" and input.KeyCode.Name == Settings.Aimbot.Bind then
        Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled
        updateToggleVisual("Aimbot", Settings.Aimbot.Enabled)
        notify("Aimbot (Bind)", Settings.Aimbot.Enabled and "Включён" or "Выключен", Settings.Aimbot.Enabled and "success" or "error")
    end

    if Settings.AutoClicker.Bind ~= "None" and input.KeyCode.Name == Settings.AutoClicker.Bind then
        Settings.AutoClicker.Enabled = not Settings.AutoClicker.Enabled
        updateToggleVisual("AutoClick", Settings.AutoClicker.Enabled)
        notify("Auto Clicker (Bind)", Settings.AutoClicker.Enabled and "Включён" or "Выключен", Settings.AutoClicker.Enabled and "success" or "error")
        if Settings.AutoClicker.Enabled then startClicker() else stopClicker() end
    end
end))

-- ============ CHARACTER RESPAWN HOOK ============
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updSpeed() updJump()
    if Settings.Misc.Fly then startFly() end
    if Settings.Misc.NoClip then enableNC() end
    refreshAllChams()
end)
if LocalPlayer.Character then
    updSpeed() updJump()
    refreshAllChams()
end

-- ============ MAIN LOOP ============
trackConn(RunService.RenderStepped:Connect(function(dt)
    fpsFrames = fpsFrames + 1
    fpsAccum = fpsAccum + dt
    if fpsAccum >= 1 then
        currentFPS = fpsFrames
        fpsFrames = 0 fpsAccum = 0
        if currentFPS > fpsMax then fpsMax = currentFPS end
        if currentFPS < fpsMin then fpsMin = currentFPS end
        fpsSum = fpsSum + currentFPS
        fpsSamples = fpsSamples + 1
        pcall(function() currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        fpsLbl.Text = "FPS: "..currentFPS.." | Ping: "..currentPing
        fpsLbl.TextColor3 = currentFPS>=60 and Color3.fromRGB(100,255,100) or currentFPS>=30 and Color3.fromRGB(255,220,100) or Color3.fromRGB(255,100,100)
        if Settings.UI.Minimized then
            subtitleLbl.Text = "FPS: "..currentFPS.." | Ping: "..currentPing.."ms"
        else
            subtitleLbl.Text = "SniperLegends Edition"
        end
        if fpsDisplayLbl then
            fpsDisplayLbl.Text = "FPS: "..currentFPS
            fpsDisplayLbl.TextColor3 = fpsLbl.TextColor3
        end
        if statsInfoLbl then
            local avg = fpsSamples > 0 and math.floor(fpsSum/fpsSamples) or 0
            statsInfoLbl.Text = string.format("Ping: %d ms | Min: %d | Max: %d | Avg: %d", currentPing, fpsMin==999 and 0 or fpsMin, fpsMax, avg)
        end
    end

    if Settings.Misc.Bunnyhop then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.FloorMaterial ~= Enum.Material.Air then h.Jump = true end
        end
    end

    if Settings.Aimbot.Enabled then
        local bt, bd = getTarget()
        if bt and (Settings.Aimbot.HitChance >= 100 or math.random(1,100) <= Settings.Aimbot.HitChance) then
            local targetPos = bt.Position
            if Settings.Aimbot.Prediction then
                local root = bt.Parent and bt.Parent:FindFirstChild("HumanoidRootPart")
                if root then targetPos = targetPos + root.Velocity * (currentPing/1000) end
            end
            local targetCF = CFrame.new(Camera.CFrame.Position, targetPos)
            if Settings.Aimbot.SilentAim then
                Camera.CFrame = targetCF
            elseif Settings.Aimbot.AimAssist then
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.05)
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1/math.max(Settings.Aimbot.Smoothness, 1))
            end
            if Settings.Aimbot.TriggerBot and bd < 50 then safeClick() end
        end
    end

    if tick()%5 < 0.03 then
        for k in pairs(lastVisibilityCheck) do
            if tick() - lastVisibilityCheck[k].t > 5 then lastVisibilityCheck[k] = nil end
        end
    end
end))

-- ============ FOV CIRCLE ============
local fovCircle = trackDraw(Drawing.new("Circle"))
fovCircle.Visible = false fovCircle.Thickness = 1.5 fovCircle.NumSides = 64 fovCircle.Transparency = 0.7
trackConn(RunService.RenderStepped:Connect(function()
    fovCircle.Visible = Settings.Aimbot.Enabled and not Settings.Aimbot.UnlockFOV and Settings.Aimbot.FOVVisible
    if fovCircle.Visible then
        fovCircle.Radius = Settings.Aimbot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Color = Colors[Settings.Aimbot.FOVColor] or Colors.Red
    end
end))

-- ============ INIT ============
updateGlow()
refreshAll()
if Settings.ESP.Enabled then startESPRender() end
if Settings.Chams.Enabled then
    refreshAllChams()
    if Settings.Chams.Pulse then startChamPulse() end
end
notify("NOOBS COCO v5.0", "SniperLegends Edition | Menu: "..Settings.UI.MenuKey, "success")
task.delay(1.2, function() notify("Подсказка", "Нажми "..Settings.UI.MenuKey.." чтобы открыть меню", "info") end)
