--====================================================================--
--               MOGGER MENU v4.5 • ULTIMATE EDITION                  --
--           Developers: @darkrelay & @Alexander_Hartuk               --
--====================================================================--
--[[
    Mogger Menu v4.5 • PUSL-V4 Integration
--]]

local PUSL = loadstring(game:HttpGet("https://secure.pandauth.com/pv4/lib"))()
if not PUSL or type(PUSL.configure) ~= "function" then
    return warn("[Panda] Library failed to initialize.")
end

PUSL.configure({
    serviceId = "mogger", -- Ваш Service ID
})

local KEY_FILE = "MoggerMenu_SavedKey.txt"
local KeyVerified = false

-- Проверка сохраненного локально ключа
if isfile and readfile and isfile(KEY_FILE) then
    local savedKey = readfile(KEY_FILE)
    local res = PUSL.validate(savedKey)
    if res and res.success then
        KeyVerified = true
    end
end

-- Если ключ не подтвержден — показываем легкое и стильное UI-окно авторизации
if not KeyVerified then
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "MoggerKeyAuth"
    KeyGui.ResetOnSpawn = false
    local okHui, hui = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
    KeyGui.Parent = (okHui and hui) or LP:WaitForChild("PlayerGui")

    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Active = true
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

    local KeyStroke = Instance.new("UIStroke", KeyFrame)
    KeyStroke.Color = Color3.fromRGB(125, 90, 255)
    KeyStroke.Thickness = 1.6

    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, -20, 0, 32)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "MOGGER MENU • PANDAUTH"
    Title.TextColor3 = Color3.fromRGB(245, 245, 250)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 13

    local KeyInput = Instance.new("TextBox", KeyFrame)
    KeyInput.Size = UDim2.new(1, -28, 0, 36)
    KeyInput.Position = UDim2.new(0, 14, 0, 62)
    KeyInput.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    KeyInput.PlaceholderText = "Вставьте ваш ключ сюда..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 11
    KeyInput.ClearTextOnFocus = false
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

    local GetKeyBtn = Instance.new("TextButton", KeyFrame)
    GetKeyBtn.Size = UDim2.new(0.48, -10, 0, 36)
    GetKeyBtn.Position = UDim2.new(0, 14, 0, 110)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
    GetKeyBtn.Text = "🔗 Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 11
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

    local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
    CheckKeyBtn.Size = UDim2.new(0.48, -10, 0, 36)
    CheckKeyBtn.Position = UDim2.new(0.52, -4, 0, 110)
    CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(125, 90, 255)
    CheckKeyBtn.Text = "✅ Check Key"
    CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckKeyBtn.Font = Enum.Font.GothamBold
    CheckKeyBtn.TextSize= 11
    Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0, 8)

    local StatusLbl = Instance.new("TextLabel", KeyFrame)
    StatusLbl.Size = UDim2.new(1, -20, 0, 20)
    StatusLbl.Position = UDim2.new(0, 10, 1, -28)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.Text = "Panda Auth V4 • Система защиты"
    StatusLbl.TextColor3 = Color3.fromRGB(125, 125, 145)
    StatusLbl.Font = Enum.Font.GothamBold
    StatusLbl.TextSize = 10

    GetKeyBtn.MouseButton1Click:Connect(function()
        local link = PUSL.getKeyUrl()
        if setclipboard then
            setclipboard(link)
            StatusLbl.Text = "✅ Ссылка скопирована в буфер!"
            StatusLbl.TextColor3 = Color3.fromRGB(60, 225, 150)
        else
            KeyInput.Text = link
            StatusLbl.Text = "Скопируйте ссылку из поля ввода!"
        end
    end)

    CheckKeyBtn.MouseButton1Click:Connect(function()
        StatusLbl.Text = "⏳ Проверка ключа..."
        StatusLbl.TextColor3 = Color3.fromRGB(240, 200, 80)
        task.spawn(function()
            local res = PUSL.validate(KeyInput.Text)
            if res and res.success then
                if writefile then
                    pcall(function() writefile(KEY_FILE, string.gsub(KeyInput.Text, "%s+", "")) end)
                end
                StatusLbl.Text = "✅ Успешно! Загрузка..."
                StatusLbl.TextColor3 = Color3.fromRGB(60, 225, 150)
                task.wait(0.4)
                KeyGui:Destroy()
                KeyVerified = true
            else
                StatusLbl.Text = "❌ Неверный ключ или HWID!"
                StatusLbl.TextColor3 = Color3.fromRGB(255, 75, 95)
            end
        end)
    end)

    repeat task.wait(0.2) until KeyVerified
end

print("[Panda] Авторизация успешна! Запуск Mogger Menu...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

--====================================================================--
-- 1. НАСТРОЙКИ PANDA AUTH (ВСТАВЬ СВОЙ SERVICE ID СЮДА)
--====================================================================--
local PANDA_API_KEY = "f3513907-bd0f-43cc-88da-6354e77443bd" -- Замени на свой Service ID из панели Panda Auth
local SKIP_KEY_SYSTEM = false -- Поставь true, если захочешь запускать вообще без окна ключей

local KEY_FILE = "MoggerMenu_SavedKey.txt"
local CONFIG_FILE = "MoggerMenu_Config.json"
local LOADSTRING_URL = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Osinter777/moggermenu/refs/heads/main/MoggerMenulua.lua"))()'

local function getDeviceHwid()
    local ok, hwid = pcall(function()
        if gethwid then return tostring(gethwid()) end
        return tostring(RbxAnalyticsService:GetClientId())
    end)
    return (ok and hwid and string.gsub(hwid, "[^%w%-]", "")) or tostring(LP.UserId)
end

local function getKeyLink()
    return "https://pandadevelopment.net/getkey?service=" .. PANDA_API_KEY .. "&hwid=" .. getDeviceHwid()
end

local function verifyPandaKey(inputKey)
    local cleanKey = string.gsub(tostring(inputKey or ""), "%s+", "")
    if cleanKey == "" then return false end

    local url = "https://pandadevelopment.net/v2_validation?key=" .. cleanKey .. "&service=" .. PANDA_API_KEY .. "&hwid=" .. getDeviceHwid()
    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and response then
        local decodeOk, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        if decodeOk and type(data) == "table" then
            if data.V2_Authentication == "success" or data.status == "success" or data.validated == true then
                return true
            end
        elseif string.find(string.lower(response), "true") or string.find(string.lower(response), "success") then
            return true
        end
    end
    return false
end

local KeyVerified = SKIP_KEY_SYSTEM

if not KeyVerified and isfile and readfile and isfile(KEY_FILE) then
    local savedKey = readfile(KEY_FILE)
    if verifyPandaKey(savedKey) then
        KeyVerified = true
    end
end

if not KeyVerified then
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "MoggerKeyAuth"
    KeyGui.ResetOnSpawn = false
    local okHui, hui = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    KeyGui.Parent = (okHui and hui) or LP:WaitForChild("PlayerGui")

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 350, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Active = true
    KeyFrame.Parent = KeyGui
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)

    local KeyStroke = Instance.new("UIStroke", KeyFrame)
    KeyStroke.Color = Color3.fromRGB(125, 90, 255)
    KeyStroke.Thickness = 1.6

    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, -20, 0, 32)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "MOGGER MENU v4.5 • KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(245, 245, 250)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 13

    local SubTitle = Instance.new("TextLabel", KeyFrame)
    SubTitle.Size = UDim2.new(1, -20, 0, 18)
    SubTitle.Position = UDim2.new(0, 10, 0, 34)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Получите ключ или нажмите Bypass для теста"
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 170)
    SubTitle.Font = Enum.Font.GothamBold
    SubTitle.TextSize = 10

    local KeyInput = Instance.new("TextBox", KeyFrame)
    KeyInput.Size = UDim2.new(1, -28, 0, 36)
    KeyInput.Position = UDim2.new(0, 14, 0, 62)
    KeyInput.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    KeyInput.PlaceholderText = "Вставьте ваш ключ сюда..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 11
    KeyInput.ClearTextOnFocus = false
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)
    local InputStroke = Instance.new("UIStroke", KeyInput)
    InputStroke.Color = Color3.fromRGB(48, 48, 68)
    InputStroke.Thickness = 1

    local GetKeyBtn = Instance.new("TextButton", KeyFrame)
    GetKeyBtn.Size = UDim2.new(0.48, -10, 0, 36)
    GetKeyBtn.Position = UDim2.new(0, 14, 0, 110)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
    GetKeyBtn.Text = "🔗 Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 11
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

    local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
    CheckKeyBtn.Size = UDim2.new(0.48, -10, 0, 36)
    CheckKeyBtn.Position = UDim2.new(0.52, -4, 0, 110)
    CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(125, 90, 255)
    CheckKeyBtn.Text = "✅ Check Key"
    CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckKeyBtn.Font = Enum.Font.GothamBold
    CheckKeyBtn.TextSize = 11
    Instance.new("UICorner", CheckKeyBtn).CornerRadius = UDim.new(0, 8)

    local StatusLbl = Instance.new("TextLabel", KeyFrame)
    StatusLbl.Size = UDim2.new(1, -20, 0, 20)
    StatusLbl.Position = UDim2.new(0, 10, 1, -28)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.Text = "Panda Auth • @darkrelay & @Alexander_Hartuk"
    StatusLbl.TextColor3 = Color3.fromRGB(125, 125, 145)
    StatusLbl.Font = Enum.Font.GothamBold
    StatusLbl.TextSize = 10

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(getKeyLink())
            StatusLbl.Text = "✅ Ссылка скопирована в буфер!"
            StatusLbl.TextColor3 = Color3.fromRGB(60, 225, 150)
        else
            KeyInput.Text = getKeyLink()
            StatusLbl.Text = "Скопируйте ссылку из поля!"
        end
    end)

    CheckKeyBtn.MouseButton1Click:Connect(function()
        StatusLbl.Text = "⏳ Проверка ключа..."
        StatusLbl.TextColor3 = Color3.fromRGB(240, 200, 80)
        task.spawn(function()
            if verifyPandaKey(KeyInput.Text) then
                if writefile then
                    pcall(function() writefile(KEY_FILE, string.gsub(KeyInput.Text, "%s+", "")) end)
                end
                StatusLbl.Text = "✅ Успешно! Загрузка..."
                StatusLbl.TextColor3 = Color3.fromRGB(60, 225, 150)
                task.wait(0.4)
                KeyGui:Destroy()
                KeyVerified = true
            else
                StatusLbl.Text = "❌ Неверный ключ!"
                StatusLbl.TextColor3 = Color3.fromRGB(255, 75, 95)
            end
        end)
    end)

    repeat task.wait(0.2) until KeyVerified
end

--====================================================================--
-- 2. ОЧИСТКА ПРЕДЫДУЩЕЙ СЕССИИ
--====================================================================--
if getgenv().ViskhanMoggMenu then pcall(function() getgenv().ViskhanMoggMenu:Destroy() end) end
if getgenv().ViskhanFovCircle then pcall(function() getgenv().ViskhanFovCircle:Remove() end) end
if getgenv().ViskhanCrosshairH then pcall(function() getgenv().ViskhanCrosshairH:Remove() end) end
if getgenv().ViskhanCrosshairV then pcall(function() getgenv().ViskhanCrosshairV:Remove() end) end
if getgenv().ViskhanConnection then pcall(function() getgenv().ViskhanConnection:Disconnect() end) end
if getgenv().ViskhanNoclipConn then pcall(function() getgenv().ViskhanNoclipConn:Disconnect() end) end
if getgenv().ViskhanJumpConn then pcall(function() getgenv().ViskhanJumpConn:Disconnect() end) end
if getgenv().ViskhanAfkConn then pcall(function() getgenv().ViskhanAfkConn:Disconnect() end) end
if getgenv().ViskhanTeleportConn then pcall(function() getgenv().ViskhanTeleportConn:Disconnect() end) end
if getgenv().ViskhanChatConn then pcall(function() getgenv().ViskhanChatConn:Disconnect() end) end
if getgenv().ViskhanHealthConns then
    for _, c in pairs(getgenv().ViskhanHealthConns) do pcall(function() c:Disconnect() end) end
end
if getgenv().ViskhanESPObjects then
    for _, obj in pairs(getgenv().ViskhanESPObjects) do
        pcall(function()
            for _, d in pairs(obj) do
                if type(d) == "table" then
                    for _, sub in pairs(d) do sub:Remove() end
                else
                    d:Remove()
                end
            end
        end)
    end
end
for _, p in ipairs(Players:GetPlayers()) do
    if p.Character and p.Character:FindFirstChild("Viskhan_Chams") then
        pcall(function() p.Character.Viskhan_Chams:Destroy() end)
    end
end

--====================================================================--
-- 3. СОСТОЯНИЕ, ПРЕСЕТЫ И КОНФИГУРАЦИЯ
--====================================================================--
local OrigLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

local HitPresets = {
    { Name = "CS:GO Skeet", Id = "5447626464" },
    { Name = "CS:GO Headshot", Id = "4868633804" },
    { Name = "Neverlose", Id = "8726881116" },
    { Name = "Rust Headshot", Id = "4764109000" },
    { Name = "TF2 Critical", Id = "296102734" },
    { Name = "Minecraft XP", Id = "1053296915" },
    { Name = "Свой ID", Id = "CUSTOM" }
}

local DefaultState = {
    -- Combat
    AIM = false,
    AimPart = "Head",
    WallCheck = false,
    TeamCheck = false,
    AutoPrediction = false,
    PredictionAmount = 0.14,
    TriggerBot = false,
    Hitbox = false,
    HitboxSize = 4,
    AutoClicker = false,
    FOV = 140,
    AimDist = 250,

    -- Visuals & ESP
    Chams = false,
    MaterialOverride = false,
    BoxESP = false,
    SkeletonESP = false,
    OffScreenArrows = false,
    HealthBar = false,
    TracerESP = false,
    NameESP = false,
    Crosshair = false,
    ShowTeamESP = false,
    Watermark = true,
    MaxDist = 500,
    CamFOVEnabled = false,
    CamFOV = 90,
    ViewmodelEnabled = false,
    ViewmodelZ = -1.5,
    FullBright = false,

    -- Audio
    HitSoundEnabled = false,
    HitPresetIndex = 1,
    CustomSoundId = "5447626464",
    HitVolume = 3,

    -- Movement
    SpeedEnabled = false,
    Speed = 50,
    CFrameSpeedEnabled = false,
    CFrameSpeed = 35,
    Bhop = false,
    FlyEnabled = false,
    FlySpeed = 60,
    Freecam = false,
    FreecamSpeed = 50,
    InfJump = false,
    Noclip = false,
    SpinBot = false,

    -- Misc & QoL
    AntiAFK = true,
    AutoExecute = false,
    ChatSpammer = false,
    ChatSpamText = "Mogger Menu v4.5 ON TOP 🔥",
    ChatSpamDelay = 3,
    ChatCommands = true
}

local State = {}
for k, v in pairs(DefaultState) do State[k] = v end
local Whitelist = {}
local OriginalMaterials = {}

local function loadConfig()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(data) do
                if State[k] ~= nil and type(State[k]) == type(v) then
                    State[k] = v
                end
            end
            return true
        end
    end
    return false
end

local function saveConfig()
    if writefile then
        pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(State)) end)
        return true
    end
    return false
end

loadConfig()

local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
local queuedOnce = false
local function setupAutoExecute()
    if State.AutoExecute and queueTeleport and not queuedOnce then
        queuedOnce = true
        pcall(function() queueTeleport(LOADSTRING_URL) end)
    end
end
setupAutoExecute()
getgenv().ViskhanTeleportConn = LP.OnTeleport:Connect(function()
    if State.AutoExecute and queueTeleport then
        pcall(function() queueTeleport(LOADSTRING_URL) end)
    end
end)

--====================================================================--
-- 4. ПАЛИТРА И СТИЛЬНЫЙ ДИЗАЙН ИНТЕРФЕЙСА (CYBER-VIOLET UI)
--====================================================================--
local Theme = {
    Bg = Color3.fromRGB(12, 12, 18),
    Sidebar = Color3.fromRGB(18, 18, 26),
    Card = Color3.fromRGB(24, 24, 34),
    Stroke = Color3.fromRGB(45, 45, 65),
    Accent = Color3.fromRGB(130, 85, 255),
    AccentGlow = Color3.fromRGB(175, 130, 255),
    Text = Color3.fromRGB(245, 245, 252),
    SubText = Color3.fromRGB(150, 150, 170),
    Enemy = Color3.fromRGB(255, 65, 90),
    Team = Color3.fromRGB(50, 230, 145)
}

local ESPObjects = {}
getgenv().ViskhanESPObjects = ESPObjects

local function playHitSound()
    pcall(function()
        local preset = HitPresets[State.HitPresetIndex] or HitPresets[1]
        local rawId = (preset.Id == "CUSTOM" and tostring(State.CustomSoundId)) or preset.Id
        local cleanId = string.match(rawId, "%d+")
        if not cleanId then return end

        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. cleanId
        s.Volume = math.clamp(tonumber(State.HitVolume) or 3, 0.5, 10)
        s.Parent = SoundService
        s:Play()
        task.delay(2.5, function() if s then s:Destroy() end end)
    end)
end

local FovCircle, CrosshairH, CrosshairV
pcall(function()
    if Drawing then
        FovCircle = Drawing.new("Circle")
        FovCircle.Thickness = 1.6
        FovCircle.NumSides = 64
        FovCircle.Radius = State.FOV
        FovCircle.Filled = false
        FovCircle.Visible = State.AIM
        FovCircle.Transparency = 0.88
        FovCircle.Color = Theme.Accent
        getgenv().ViskhanFovCircle = FovCircle

        CrosshairH = Drawing.new("Line")
        CrosshairH.Thickness = 1.6
        CrosshairH.Color = Color3.fromRGB(0, 255, 150)
        CrosshairH.Visible = State.Crosshair
        getgenv().ViskhanCrosshairH = CrosshairH

        CrosshairV = Drawing.new("Line")
        CrosshairV.Thickness = 1.6
        CrosshairV.Color = Color3.fromRGB(0, 255, 150)
        CrosshairV.Visible = State.Crosshair
        getgenv().ViskhanCrosshairV = CrosshairV
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ViskhanMoggMenu_v45"
ScreenGui.ResetOnSpawn = false
local okGui, coreTarget = pcall(function()
    return (gethui and gethui()) or game:GetService("CoreGui")
end)
ScreenGui.Parent = (okGui and coreTarget) or LP:WaitForChild("PlayerGui")
getgenv().ViskhanMoggMenu = ScreenGui

-- Вотермарка
local WatermarkFrame = Instance.new("Frame", ScreenGui)
WatermarkFrame.Size = UDim2.new(0, 280, 0, 28)
WatermarkFrame.Position = UDim2.new(0, 16, 0, 12)
WatermarkFrame.BackgroundColor3 = Theme.Bg
WatermarkFrame.BackgroundTransparency = 0.12
WatermarkFrame.Visible = State.Watermark
Instance.new("UICorner", WatermarkFrame).CornerRadius = UDim.new(0, 8)
local WmStroke = Instance.new("UIStroke", WatermarkFrame)
WmStroke.Color = Theme.Accent
WmStroke.Thickness = 1.3

local WatermarkLabel = Instance.new("TextLabel", WatermarkFrame)
WatermarkLabel.Size = UDim2.new(1, -16, 1, 0)
WatermarkLabel.Position = UDim2.new(0, 8, 0, 0)
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Text = "⚡ MOGGER v4.5 | FPS: 60 | Ping: 0 ms"
WatermarkLabel.TextColor3 = Theme.Text
WatermarkLabel.Font = Enum.Font.GothamBold
WatermarkLabel.TextSize = 11
WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Контейнер уведомлений
local NotifHolder = Instance.new("Frame", ScreenGui)
NotifHolder.Size = UDim2.new(0, 250, 0, 190)
NotifHolder.Position = UDim2.new(1, -265, 1, -205)
NotifHolder.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifHolder)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 6)

local function sendNotification(title, msg)
    pcall(function()
        local nf = Instance.new("Frame", NotifHolder)
        nf.Size = UDim2.new(1, 0, 0, 48)
        nf.BackgroundColor3 = Theme.Sidebar
        Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", nf)
        st.Color = Theme.Accent
        st.Thickness = 1.2

        local tl = Instance.new("TextLabel", nf)
        tl.Size = UDim2.new(1, -16, 0, 18)
        tl.Position = UDim2.new(0, 8, 0, 4)
        tl.BackgroundTransparency = 1
        tl.Text = title
        tl.TextColor3 = Theme.AccentGlow
        tl.Font = Enum.Font.GothamBlack
        tl.TextSize = 11
        tl.TextXAlignment = Enum.TextXAlignment.Left

        local ml = Instance.new("TextLabel", nf)
        ml.Size = UDim2.new(1, -16, 0, 20)
        ml.Position = UDim2.new(0, 8, 0, 22)
        ml.BackgroundTransparency = 1
        ml.Text = msg
        ml.TextColor3 = Theme.Text
        ml.Font = Enum.Font.GothamBold
        ml.TextSize = 11
        ml.TextXAlignment = Enum.TextXAlignment.Left

        task.delay(3, function()
            if nf and nf.Parent then
                local tw = TweenService:Create(nf, TweenInfo.new(0.25), {BackgroundTransparency = 1})
                tw:Play()
                tw.Completed:Connect(function() nf:Destroy() end)
            end
        end)
    end)
end

-- Кнопка быстрого открытия (когда свернуто)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 46, 0, 46)
OpenBtn.Position = UDim2.new(0, 25, 0.5, -23)
OpenBtn.BackgroundColor3 = Theme.Bg
OpenBtn.Text = "M"
OpenBtn.TextColor3 = Theme.AccentGlow
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 18
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Theme.Accent
OpenStroke.Thickness = 1.6

-- Главное окно
local TargetSize = UDim2.new(0, 560, 0, 380)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 0)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.4

TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()

-- Верхняя панель (Header)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Sidebar
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TopGradient = Instance.new("UIGradient", TopBar)
TopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 25, 65)),
    ColorSequenceKeypoint.new(1, Theme.Sidebar)
})

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(0, 240, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ MOGGER MENU • ULTIMATE"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubBadge = Instance.new("TextLabel", TopBar)
SubBadge.Size = UDim2.new(0, 200, 0, 20)
SubBadge.Position = UDim2.new(0, 225, 0.5, -10)
SubBadge.BackgroundTransparency = 1
SubBadge.Text = "v4.5 • Skeleton, Arrows & Predict"
SubBadge.TextColor3 = Theme.AccentGlow
SubBadge.Font = Enum.Font.GothamBold
SubBadge.TextSize = 11
SubBadge.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -36, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.Card
MinBtn.Text = "–"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- Панель вкладок
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 32)
TabBar.Position = UDim2.new(0, 12, 0, 46)
TabBar.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)

local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -24, 1, -92)
ContentHolder.Position = UDim2.new(0, 12, 0, 84)
ContentHolder.BackgroundTransparency = 1

local function makeDraggable(handle, target)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(TopBar, MainFrame)
makeDraggable(OpenBtn, OpenBtn)
makeDraggable(WatermarkFrame, WatermarkFrame)

MinBtn.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 560, 0, 0)})
    tw:Play()
    tw.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.4

TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()

-- Верхняя панель (Header)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Sidebar
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TopGradient = Instance.new("UIGradient", TopBar)
TopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 25, 65)),
    ColorSequenceKeypoint.new(1, Theme.Sidebar)
})

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(0, 240, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ MOGGER MENU • ULTIMATE"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubBadge = Instance.new("TextLabel", TopBar)
SubBadge.Size = UDim2.new(0, 200, 0, 20)
SubBadge.Position = UDim2.new(0, 225, 0.5, -10)
SubBadge.BackgroundTransparency = 1
SubBadge.Text = "v4.5 • Skeleton, Arrows & Predict"
SubBadge.TextColor3 = Theme.AccentGlow
SubBadge.Font = Enum.Font.GothamBold
SubBadge.TextSize = 11
SubBadge.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -36, 0.5, -14)
MinBtn.BackgroundColor3 = Theme.Card
MinBtn.Text = "–"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

-- Панель вкладок
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 32)
TabBar.Position = UDim2.new(0, 12, 0, 46)
TabBar.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)

local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -24, 1, -92)
ContentHolder.Position = UDim2.new(0, 12, 0, 84)
ContentHolder.BackgroundTransparency = 1

local function makeDraggable(handle, target)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(TopBar, MainFrame)
makeDraggable(OpenBtn, OpenBtn)
makeDraggable(WatermarkFrame, WatermarkFrame)

MinBtn.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 560, 0, 0)})
    tw:Play()
    tw.Completed:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = TargetSize}):Play()
end)

-- Генератор вкладок и элементов
local Tabs = {}
local function createTab(name, isDefault)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.2, -5, 1, 0)
    btn.BackgroundColor3 = isDefault and Theme.Accent or Theme.Card
    btn.Text = name
    btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Theme.SubText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local page = Instance.new("Frame", ContentHolder)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = isDefault

    local function makeColumn(xScale, xOffset)
        local col = Instance.new("ScrollingFrame", page)
        col.Size = UDim2.new(0.5, -5, 1, 0)
        col.Position = UDim2.new(xScale, xOffset, 0, 0)
        col.BackgroundTransparency = 1
        col.BorderSizePixel = 0
        col.ScrollBarThickness = 2
        col.ScrollBarImageColor3 = Theme.Accent
        col.AutomaticCanvasSize = Enum.AutomaticSize.Y
        col.CanvasSize = UDim2.new(0, 0, 0, 0)
        local lay = Instance.new("UIListLayout", col)
        lay.Padding = UDim.new(0, 6)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        return col
    end

    local tabObj = { Btn = btn, Page = page, Left = makeColumn(0, 0), Right = makeColumn(0.5, 5) }
    table.insert(Tabs, tabObj)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            local active = (t == tabObj)
            t.Page.Visible = active
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {
                BackgroundColor3 = active and Theme.Accent or Theme.Card,
                TextColor3 = active and Color3.fromRGB(255, 255, 255) or Theme.SubText
            }):Play()
        end
    end)

    return tabObj
end

local TabCombat = createTab("⚔️ Бой", true)
local TabVisuals = createTab("👁 Визуал", false)
local TabMove = createTab("⚡ Движение", false)
local TabPlayers = createTab("👥 Игроки", false)
local TabMisc = createTab("⚙️ Разное", false)

local UIUpdaters = {}

local function addToggle(parent, labelText, stateKey, callback)
    local isOn = State[stateKey]
    local card = Instance.new("TextButton", parent)
    card.Size = UDim2.new(1, -2, 0, 34)
    card.BackgroundColor3 = Theme.Card
    card.Text = ""
    card.AutoButtonColor = false
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = isOn and Theme.Accent or Theme.Stroke
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -56, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sw = Instance.new("Frame", card)
    sw.Size = UDim2.new(0, 34, 0, 18)
    sw.Position = UDim2.new(1, -44, 0.5, -9)
    sw.BackgroundColor3 = isOn and Theme.Accent or Color3.fromRGB(45, 45, 58)
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", sw)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = isOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    dot.BackgroundColor3 = isOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local function updateVisual(val)
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = val and Theme.Accent or Color3.fromRGB(45, 45, 58)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {
            Position = val and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = val and Theme.Accent or Theme.Stroke}):Play()
        if callback then callback(val) end
    end

    UIUpdaters[stateKey] = updateVisual
    card.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        updateVisual(State[stateKey])
    end)
end

local function addInput(parent, labelText, defaultVal, stateKey, isString, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -2, 0, 34)
    card.BackgroundColor3 = Theme.Card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", card)
    st.Color = Theme.Stroke
    st.Thickness = 1

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Theme.SubText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", card)
    box.Size = UDim2.new(0, isString and 96 or 60, 0, 22)
    box.Position = UDim2.new(1, isString and -104 or -68, 0.5, -11)
    box.BackgroundColor3 = Theme.Sidebar
    box.Text = tostring(State[stateKey] or defaultVal)
    box.TextColor3 = Theme.Text
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local bst = Instance.new("UIStroke", box)
    bst.Color = Theme.Stroke
    bst.Thickness = 1

    UIUpdaters[stateKey] = function(val)
        box.Text = tostring(val)
        if callback then callback(val) end
    end

    box.FocusLost:Connect(function()
        if isString then
            State[stateKey] = box.Text
            if callback then callback(box.Text) end
        else
            local num = tonumber(box.Text)
            if num then
                State[stateKey] = num
                if callback then callback(num) end
            else
                box.Text = tostring(State[stateKey])
            end
        end
    end)
end

local function addButton(parent, text, strokeColor, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -2, 0, 34)
    btn.BackgroundColor3 = Theme.Card
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", btn)
    st.Color = strokeColor or Theme.Stroke
    st.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = strokeColor or Theme.Accent}):Play()
        task.delay(0.15, function()
            if btn and btn.Parent then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card}):Play()
            end
        end)
        if callback then callback(btn) end
    end)
    return btn
end

local function addInfoCard(parent, title, bodyText, height)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -2, 0, height or 75)
    card.BackgroundColor3 = Theme.Card
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", card)
    st.Color = Theme.Stroke
    st.Thickness = 1

    local tl = Instance.new("TextLabel", card)
    tl.Size = UDim2.new(1, -16, 0, 20)
    tl.Position = UDim2.new(0, 10, 0, 6)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = Theme.AccentGlow
    tl.Font = Enum.Font.GothamBlack
    tl.TextSize = 11
    tl.TextXAlignment = Enum.TextXAlignment.Left

    local bl = Instance.new("TextLabel", card)
    bl.Size = UDim2.new(1, -16, 1, -30)
    bl.Position = UDim2.new(0, 10, 0, 26)
    bl.BackgroundTransparency = 1
    bl.Text = bodyText
    bl.TextColor3 = Theme.Text
    bl.Font = Enum.Font.GothamBold
    bl.TextSize = 11
    bl.TextWrapped = true
    bl.TextXAlignment = Enum.TextXAlignment.Left
    bl.TextYAlignment = Enum.TextYAlignment.Top
    return bl
end

--====================================================================--
-- 5. ЗАПОЛНЕНИЕ ВКЛАДОК (БОЙ, ВИЗУАЛ, ДВИЖЕНИЕ, ИГРОКИ, РАЗНОЕ)
--====================================================================--

-- [ВКЛАДКА 1: БОЙ]
addToggle(TabCombat.Left, "Жесткий Aimbot (ПКМ / Тач)", "AIM", function(v)
    if FovCircle then FovCircle.Visible = v end
end)
addToggle(TabCombat.Left, "Auto-Prediction (Упреждение)", "AutoPrediction")
addToggle(TabCombat.Left, "TriggerBot (Автовыстрел)", "TriggerBot")
addToggle(TabCombat.Left, "WallCheck (Проверка стен)", "WallCheck")
addToggle(TabCombat.Left, "TeamCheck (Игнор своих)", "TeamCheck")
addToggle(TabCombat.Left, "Hitbox Expander (Головы)", "Hitbox", function(v)
    if not v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(1.2, 1.2, 1.2)
                p.Character.Head.Transparency = 0
            end
        end
    end
end)
addToggle(TabCombat.Left, "AutoClicker (Автокликер)", "AutoClicker")

local AimPartBtn
AimPartBtn = addButton(TabCombat.Right, (State.AimPart == "Head" and "🎯 Цель Аима: Голова (Head)") or "🎯 Цель Аима: Корпус (Torso)", Theme.Accent, function(btn)
    if State.AimPart == "Head" then
        State.AimPart = "HumanoidRootPart"
        btn.Text = "🎯 Цель Аима: Корпус (Torso)"
    else
        State.AimPart = "Head"
        btn.Text = "🎯 Цель Аима: Голова (Head)"
    end
end)
UIUpdaters["AimPart"] = function(v)
    if AimPartBtn then
        AimPartBtn.Text = (v == "Head" and "🎯 Цель Аима: Голова (Head)") or "🎯 Цель Аима: Корпус (Torso)"
    end
end

addInput(TabCombat.Right, "Сила Предикта ( сек )", State.PredictionAmount, "PredictionAmount", false)
addInput(TabCombat.Right, "Радиус круга FOV", State.FOV, "FOV", false, function(v)
    if FovCircle then FovCircle.Radius = v end
end)
addInput(TabCombat.Right, "Дистанция Аима", State.AimDist, "AimDist", false)
addInput(TabCombat.Right, "Размер Hitbox", State.HitboxSize, "HitboxSize", false)

-- [ВКЛАДКА 2: ВИЗУАЛ И ESP]
addToggle(TabVisuals.Left, "Chams (Силуэты через стены)", "Chams", function(v)
    if not v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Viskhan_Chams") then
                p.Character.Viskhan_Chams:Destroy()
            end
        end
    end
end)
addToggle(TabVisuals.Left, "Material Override (Neon Glow)", "MaterialOverride", function(v)
    if not v then
        for part, orig in pairs(OriginalMaterials) do
            if part and part.Parent then
                pcall(function()
                    part.Material = orig.Material
                    part.Color = orig.Color
                end)
            end
        end
        OriginalMaterials = {}
    end
end)
addToggle(TabVisuals.Left, "Skeleton ESP (Скелет игрока)", "SkeletonESP")
addToggle(TabVisuals.Left, "Off-Screen Arrows (Стрелки)", "OffScreenArrows")
addToggle(TabVisuals.Left, "Box ESP (2D Боксы)", "BoxESP")
addToggle(TabVisuals.Left, "Health Bar (Шкала ХП)", "HealthBar")
addToggle(TabVisuals.Left, "Tracers (Линии до врагов)", "TracerESP")
addToggle(TabVisuals.Left, "Name & Distance ESP", "NameESP")
addToggle(TabVisuals.Left, "Прицел (Crosshair)", "Crosshair", function(v)
    if CrosshairH and CrosshairV then
        CrosshairH.Visible = v
        CrosshairV.Visible = v
    end
end)
addToggle(TabVisuals.Left, "Показывать своих (Team ESP)", "ShowTeamESP")

addToggle(TabVisuals.Right, "Кастом FOV Камеры", "CamFOVEnabled", function(v)
    if not v then Camera.FieldOfView = 70 end
end)
addInput(TabVisuals.Right, "Угол обзора (FOV)", State.CamFOV, "CamFOV", false)
addToggle(TabVisuals.Right, "Viewmodel FOV (Отдаление рук)", "ViewmodelEnabled")
addInput(TabVisuals.Right, "Смещение рук (Z)", State.ViewmodelZ, "ViewmodelZ", false)
addInput(TabVisuals.Right, "Макс. дистанция ESP", State.MaxDist, "MaxDist", false)

addToggle(TabVisuals.Right, "HitSound (Звук попадания)", "HitSoundEnabled")
local SoundPresetBtn
local function getSoundText()
    local p = HitPresets[State.HitPresetIndex] or HitPresets[1]
    return "🎵 Звук: " .. p.Name
end
SoundPresetBtn = addButton(TabVisuals.Right, getSoundText(), Theme.Accent, function(btn)
    State.HitPresetIndex = (State.HitPresetIndex % #HitPresets) + 1
    btn.Text = getSoundText()
    playHitSound()
end)
addInput(TabVisuals.Right, "Свой Sound ID", State.CustomSoundId, "CustomSoundId", true, function()
    State.HitPresetIndex = #HitPresets
    if SoundPresetBtn then SoundPresetBtn.Text = getSoundText() end
end)
addInput(TabVisuals.Right, "Громкость звука", State.HitVolume, "HitVolume", false)
addButton(TabVisuals.Right, "🔊 Проверить звук", Theme.Team, function() playHitSound() end)

local function applyFullBright(v)
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = OrigLighting.Brightness
        Lighting.ClockTime = OrigLighting.ClockTime
        Lighting.FogEnd = OrigLighting.FogEnd
        Lighting.GlobalShadows = OrigLighting.GlobalShadows
        Lighting.Ambient = OrigLighting.Ambient
    end
end
addToggle(TabVisuals.Right, "FullBright (Яркий свет)", "FullBright", applyFullBright)
if State.FullBright then applyFullBright(true) end

-- [ВКЛАДКА 3: ДВИЖЕНИЕ]
addToggle(TabMove.Left, "Bhop (Автораспрыжка)", "Bhop")
addToggle(TabMove.Left, "CFrame Speed (Обход античита)", "CFrameSpeedEnabled")
addToggle(TabMove.Left, "WalkSpeed (Обычный бег)", "SpeedEnabled", function(v)
    if not v and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
addToggle(TabMove.Left, "Fly (Полет персонажа)", "FlyEnabled", function(v)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not v and hrp then
        if hrp:FindFirstChild("MoggerFlyBV") then hrp.MoggerFlyBV:Destroy() end
        if hrp:FindFirstChild("MoggerFlyBG") then hrp.MoggerFlyBG:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end)

local FreecamPos = nil
local FreecamAngles = Vector2.new(0, 0)
addToggle(TabMove.Left, "Freecam (Свободная камера)", "Freecam", function(v)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if v then
        FreecamPos = Camera.CFrame.Position
        local rx, ry, _ = Camera.CFrame:ToEulerAnglesYXZ()
        FreecamAngles = Vector2.new(rx, ry)
        Camera.CameraType = Enum.CameraType.Scriptable
        if hrp then hrp.Anchored = true end
    else
        Camera.CameraType = Enum.CameraType.Custom
        if char and char:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        end
        if hrp then hrp.Anchored = false end
    end
end)
addToggle(TabMove.Left, "Infinite Jump (Прыжки в воздухе)", "InfJump")
addToggle(TabMove.Left, "Noclip (Сквозь стены)", "Noclip")
addToggle(TabMove.Left, "SpinBot (Крутилка 360°)", "SpinBot")

addInput(TabMove.Right, "Скорость CFrame", State.CFrameSpeed, "CFrameSpeed", false)
addInput(TabMove.Right, "Скорость WalkSpeed", State.Speed, "Speed", false)
addInput(TabMove.Right, "Скорость Полета (Fly)", State.FlySpeed, "FlySpeed", false)
addInput(TabMove.Right, "Скорость Freecam", State.FreecamSpeed, "FreecamSpeed", false)

-- [ВКЛАДКА 4: ИГРОКИ]
local SelectedPlayer = nil
local Spectating = false
local PlayerInfoLbl = addInfoCard(TabPlayers.Left, "ВЫБРАННЫЙ ИГРОК", "Никто не выбран.\nНажмите на игрока справа.", 76)

local function updatePlayerInfo()
    if SelectedPlayer and SelectedPlayer.Parent == Players then
        local wl = Whitelist[SelectedPlayer.UserId] and "Да (Вайтлист)" or "Нет"
        PlayerInfoLbl.Text = string.format("Ник: %s\nДруг (Игнор Аима): %s", SelectedPlayer.Name, wl)
    else
        SelectedPlayer = nil
        PlayerInfoLbl.Text = "Никто не выбран.\nНажмите на игрока справа."
    end
end

addButton(TabPlayers.Left, "📍 Телепорт за спину", Theme.Accent, function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            myHrp.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
        end
    end
end)

addButton(TabPlayers.Left, "👁 Наблюдать (Spectate)", Theme.Stroke, function(btn)
    Spectating = not Spectating
    if Spectating and SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = SelectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        btn.Text = "👁 Выключить Spectate"
    else
        Spectating = false
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LP.Character:FindFirstChildOfClass("Humanoid")
        end
        btn.Text = "👁 Наблюдать (Spectate)"
    end
end)

addButton(TabPlayers.Left, "🛡 Вайтлист (Друг / Враг)", Theme.Team, function()
    if SelectedPlayer then
        Whitelist[SelectedPlayer.UserId] = not Whitelist[SelectedPlayer.UserId]
        updatePlayerInfo()
        sendNotification("Вайтлист", SelectedPlayer.Name .. (Whitelist[SelectedPlayer.UserId] and " добавлен в друзья!" or " удален из друзей."))
    end
end)

local function refreshPlayerList()
    for _, ch in ipairs(TabPlayers.Right:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            addButton(TabPlayers.Right, "👤 " .. p.Name, Whitelist[p.UserId] and Theme.Team or Theme.Stroke, function()
                SelectedPlayer = p
                updatePlayerInfo()
            end)
        end
    end
end
refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function(p)
    if SelectedPlayer == p then SelectedPlayer = nil updatePlayerInfo() end
    task.defer(refreshPlayerList)
end)

-- [ВКЛАДКА 5: РАЗНОЕ, ЧАТ И СЕССИЯ]
addToggle(TabMisc.Left, "Chat Spammer (Спам в чат)", "ChatSpammer")
addInput(TabMisc.Left, "Текст спама", State.ChatSpamText, "ChatSpamText", true)
addInput(TabMisc.Left, "Задержка (сек)", State.ChatSpamDelay, "ChatSpamDelay", false)
addToggle(TabMisc.Left, "Чат-команды (.fly .esp .hop)", "ChatCommands")
addToggle(TabMisc.Left, "Watermark (Вотермарка)", "Watermark", function(v) WatermarkFrame.Visible = v end)
addToggle(TabMisc.Left, "Anti-AFK (Анти-кик)", "AntiAFK")
addToggle(TabMisc.Left, "AutoExecute (При телепорте)", "AutoExecute", function(v)
    if v then setupAutoExecute() end
    saveConfig()
end)

addButton(TabMisc.Left, "💾 Сохранить конфиг", Theme.Team, function()
    if saveConfig() then sendNotification("Конфиг", "Настройки успешно сохранены!") end
end)
addButton(TabMisc.Left, "🔄 Сбросить конфиг", Theme.Enemy, function()
    for k, v in pairs(DefaultState) do
        State[k] = v
        if UIUpdaters[k] then UIUpdaters[k](v) end
    end
    if isfile and delfile and isfile(CONFIG_FILE) then pcall(function() delfile(CONFIG_FILE) end) end
    sendNotification("Сброс", "Возвращены стандартные настройки.")
end)

local PlaceName = "Roblox Game"
pcall(function() PlaceName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
local SessionLbl = addInfoCard(TabMisc.Right, "СТАТУС СЕССИИ & КОМАНДЫ", "Загрузка...", 96)

addButton(TabMisc.Right, "⚡ FPS Booster (Убрать лаги)", Theme.Accent, function()
    pcall(function()
        Lighting.GlobalShadows = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end
    end)
    sendNotification("FPS Booster", "Текстуры и частицы упрощены!")
end)

local function doRejoin()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end

local function doServerHop()
    pcall(function()
        local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(raw)
        for _, srv in ipairs(data.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP)
                break
            end
        end
    end)
end

addButton(TabMisc.Right, "🔁 Перезайти (Rejoin Server)", Theme.Stroke, doRejoin)
addButton(TabMisc.Right, "🌐 Сменить сервер (Server Hop)", Theme.Stroke, doServerHop)
addButton(TabMisc.Right, "❌ Выгрузить меню (Destroy)", Theme.Enemy, function()
    if getgenv().ViskhanConnection then getgenv().ViskhanConnection:Disconnect() end
    if getgenv().ViskhanNoclipConn then getgenv().ViskhanNoclipConn:Disconnect() end
    if getgenv().ViskhanJumpConn then getgenv().ViskhanJumpConn:Disconnect() end
    if FovCircle then FovCircle:Remove() end
    if CrosshairH then CrosshairH:Remove() end
    if CrosshairV then CrosshairV:Remove() end
    ScreenGui:Destroy()
end)

--====================================================================--
-- 6. ЧАТ-СПАМЕР И КАСТОМНЫЕ КОМАНДЫ ЧАТА
--====================================================================--
local function sendChatMessage(msg)
    pcall(function()
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if ch then ch:SendAsync(msg) end
        else
            local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if ev and ev:FindFirstChild("SayMessageRequest") then
                ev.SayMessageRequest:FireServer(msg, "All")
            end
        end
    end)
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(math.clamp(tonumber(State.ChatSpamDelay) or 3, 1, 60))
        if State.ChatSpammer and State.ChatSpamText ~= "" then
            sendChatMessage(State.ChatSpamText)
        end
    end
end)

getgenv().ViskhanChatConn = LP.Chatted:Connect(function(msg)
    if not State.ChatCommands then return end
    local lower = string.lower(msg)
    if lower == ".fly" then
        State.FlyEnabled = not State.FlyEnabled
        if UIUpdaters.FlyEnabled then UIUpdaters.FlyEnabled(State.FlyEnabled) end
        sendNotification("Чат-команда", "Fly: " .. tostring(State.FlyEnabled))
    elseif lower == ".bhop" then
        State.Bhop = not State.Bhop
        if UIUpdaters.Bhop then UIUpdaters.Bhop(State.Bhop) end
        sendNotification("Чат-команда", "Bhop: " .. tostring(State.Bhop))
    elseif lower == ".esp" then
        State.BoxESP = not State.BoxESP
        State.SkeletonESP = State.BoxESP
        if UIUpdaters.BoxESP then UIUpdaters.BoxESP(State.BoxESP) end
        if UIUpdaters.SkeletonESP then UIUpdaters.SkeletonESP(State.SkeletonESP) end
        sendNotification("Чат-команда", "ESP + Skeleton: " .. tostring(State.BoxESP))
    elseif lower == ".aim" then
        State.AIM = not State.AIM
        if UIUpdaters.AIM then UIUpdaters.AIM(State.AIM) end
        sendNotification("Чат-команда", "Aimbot: " .. tostring(State.AIM))
    elseif lower == ".rejoin" then
        doRejoin()
    elseif lower == ".hop" then
        doServerHop()
    end
end)

--====================================================================--
-- 7. ОТСЛЕЖИВАНИЕ УРОНА ДЛЯ HITSOUND (CS:GO SOUNDS)
--====================================================================--
local HealthConns = {}
getgenv().ViskhanHealthConns = HealthConns
local lastHitTime = 0

local function hookPlayerHealth(plr)
    if plr == LP then return end
    local function onChar(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        local prevHp = hum.Health
        local conn = hum.HealthChanged:Connect(function(newHp)
            if State.HitSoundEnabled and newHp < prevHp and (tick() - lastHitTime) > 0.06 then
                local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local theirHrp = char:FindFirstChild("HumanoidRootPart")
                if myHrp and theirHrp then
                    local dist = (myHrp.Position - theirHrp.Position).Magnitude
                    local _, onScreen = Camera:WorldToViewportPoint(theirHrp.Position)
                    if (onScreen and dist <= State.AimDist) or dist <= 30 then
                        lastHitTime = tick()
                        playHitSound()
                    end
                end
            end
            prevHp = newHp
        end)
        table.insert(HealthConns, conn)
    end
    if plr.Character then task.spawn(onChar, plr.Character) end
    table.insert(HealthConns, plr.CharacterAdded:Connect(onChar))
end

for _, p in ipairs(Players:GetPlayers()) do hookPlayerHealth(p) end
table.insert(HealthConns, Players.PlayerAdded:Connect(hookPlayerHealth))

--====================================================================--
-- 8. ЛОГИКА БОЯ, SKELETON ESP, СТРЕЛОК И ДВИЖЕНИЯ
--====================================================================--
local startTime = tick()
local currentFps = 60
RunService.RenderStepped:Connect(function(dt)
    currentFps = math.floor(1 / math.max(dt, 0.001))
end)

task.spawn(function()
    while ScreenGui.Parent do
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            local elapsed = math.floor(tick() - startTime)
            SessionLbl.Text = string.format(
                "Игра: %s\nFPS: %d | Ping: %d ms | Игроков: %d/%d\nКоманды: .fly .bhop .esp .aim .hop",
                string.sub(PlaceName, 1, 20), currentFps, ping, #Players:GetPlayers(), Players.MaxPlayers
            )
            WatermarkLabel.Text = string.format("⚡ MOGGER v4.5 | FPS: %d | Ping: %d ms", currentFps, ping)
        end)
        task.wait(1)
    end
end)

local function isTeammate(plr)
    if not LP.Team or not plr.Team then return false end
    return plr.Team == LP.Team
end

local function isVisible(targetPart, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, Camera}
    local origin = Camera.CFrame.Position
    local res = workspace:Raycast(origin, targetPart.Position - origin, params)
    if not res then return true end
    return res.Instance:IsDescendantOf(targetChar)
end

local function getClosestTarget()
    local bestTarget, bestDist = nil, State.FOV
    local vp = Camera.ViewportSize
    local refPos = (UserInputService.TouchEnabled and Vector2.new(vp.X / 2, vp.Y / 2)) or UserInputService:GetMouseLocation()
    local myPos = (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position) or Camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and not Whitelist[plr.UserId] then
            if State.TeamCheck and isTeammate(plr) then continue end
            local part = plr.Character:FindFirstChild(State.AimPart) or plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if part and hum and hum.Health > 0 then
                local worldDist = (myPos - part.Position).Magnitude
                if worldDist <= State.AimDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - refPos).Magnitude
                        if screenDist <= bestDist then
                            if not State.WallCheck or isVisible(part, plr.Character) then
                                bestTarget = part
                                bestDist = screenDist
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

local BonePairsR15 = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}
}

local BonePairsR6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"}
}

local function getOrCreateESP(plr)
    if not ESPObjects[plr] and Drawing then
        local boxOut = Drawing.new("Square")
        boxOut.Thickness = 3
        boxOut.Filled = false
        boxOut.Color = Color3.fromRGB(10, 10, 12)
        boxOut.Visible = false

        local box = Drawing.new("Square")
        box.Thickness = 1.4
        box.Filled = false
        box.Visible = false

        local hpBg = Drawing.new("Line")
        hpBg.Thickness = 3.5
        hpBg.Color = Color3.fromRGB(10, 10, 12)
        hpBg.Visible = false

        local hpBar = Drawing.new("Line")
        hpBar.Thickness = 1.8
        hpBar.Visible = false

        local tracer = Drawing.new("Line")
        tracer.Thickness = 1.2
        tracer.Transparency = 0.85
        tracer.Visible = false

        local nameTag = Drawing.new("Text")
        nameTag.Size = 13
        nameTag.Center = true
        nameTag.Outline = true
        nameTag.OutlineColor = Color3.fromRGB(10, 10, 12)
        nameTag.Visible = false

        local arrow = Drawing.new("Triangle")
        arrow.Filled = true
        arrow.Thickness = 1
        arrow.Visible = false

        local bones = {}
        for i = 1, 10 do
            local line = Drawing.new("Line")
            line.Thickness = 1.5
            line.Visible = false
            bones[i] = line
        end

        ESPObjects[plr] = {
            BoxOutline = boxOut,
            Box = box,
            HpBg = hpBg,
            HpBar = hpBar,
            Tracer = tracer,
            NameTag = nameTag,
            Arrow = arrow,
            Bones = bones
        }
    end
    return ESPObjects[plr]
end

local function hideESP(plr)
    local esp = ESPObjects[plr]
    if esp then
        for k, d in pairs(esp) do
            if k == "Bones" then
                for _, b in ipairs(d) do b.Visible = false end
            else
                d.Visible = false
            end
        end
    end
end

local lastTriggerShot = 0

getgenv().ViskhanConnection = RunService.RenderStepped:Connect(function(dt)
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local mouseLoc = (UserInputService.TouchEnabled and center) or UserInputService:GetMouseLocation()

    -- Кастом FOV камеры
    if State.CamFOVEnabled then
        Camera.FieldOfView = State.CamFOV
    end

    -- Viewmodel FOV (Отдаление рук от первого лица)
    if State.ViewmodelEnabled then
        for _, child in ipairs(Camera:GetChildren()) do
            if child:IsA("Model") then
                pcall(function()
                    child:PivotTo(child:GetPivot() * CFrame.new(0, 0, State.ViewmodelZ * 0.05))
                end)
            end
        end
    end

    -- Обновление FOV круга и Прицела
    if FovCircle then
        FovCircle.Position = mouseLoc
        FovCircle.Radius = State.FOV
        FovCircle.Visible = State.AIM
    end
    if CrosshairH and CrosshairV then
        if State.Crosshair then
            CrosshairH.From = Vector2.new(center.X - 7, center.Y)
            CrosshairH.To = Vector2.new(center.X + 7, center.Y)
            CrosshairV.From = Vector2.new(center.X, center.Y - 7)
            CrosshairV.To = Vector2.new(center.X, center.Y + 7)
            CrosshairH.Visible = true
            CrosshairV.Visible = true
        else
            CrosshairH.Visible = false
            CrosshairV.Visible = false
        end
    end

-- Aimbot + Auto-Prediction
    if State.AIM and (UserInputService.TouchEnabled or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        local targetPart = getClosestTarget()
        if targetPart then
            local aimPos = targetPart.Position
            if State.AutoPrediction then
                local vel = targetPart.AssemblyLinearVelocity or Vector3.zero
                aimPos = aimPos + (vel * (tonumber(State.PredictionAmount) or 0.14))
            end
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
        end
    end

    -- TriggerBot
    if State.TriggerBot and (tick() - lastTriggerShot) > 0.08 then
        local ray = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
        local rParams = RaycastParams.new()
        rParams.FilterType = Enum.RaycastFilterType.Exclude
        rParams.FilterDescendantsInstances = {LP.Character, Camera}
        local hit = workspace:Raycast(ray.Origin, ray.Direction * State.AimDist, rParams)
        if hit and hit.Instance then
            local model = hit.Instance:FindFirstAncestorOfClass("Model")
            local plr = model and Players:GetPlayerFromCharacter(model)
            if plr and plr ~= LP and not Whitelist[plr.UserId] and (not State.TeamCheck or not isTeammate(plr)) then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    lastTriggerShot = tick()
                    if mouse1click then
                        pcall(mouse1click)
                    else
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0, 0))
                    end
                end
            end
        end
    end

    -- Freecam
    if State.Freecam and FreecamPos then
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0, 1, 0) end

        local delta = UserInputService:GetMouseDelta()
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            FreecamAngles = FreecamAngles - Vector2.new(math.rad(delta.Y * 0.35), math.rad(delta.X * 0.35))
        end
        FreecamPos = FreecamPos + (move * State.FreecamSpeed * dt)
        Camera.CFrame = CFrame.new(FreecamPos) * CFrame.fromEulerAnglesYXZ(FreecamAngles.X, FreecamAngles.Y, 0)
    end

    -- Движение: CFrame Speed, Bhop, Fly, SpinBot
    local myChar = LP.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")

    if myHrp and myHum then
        if State.CFrameSpeedEnabled and myHum.MoveDirection.Magnitude > 0 then
            myHrp.CFrame = myHrp.CFrame + (myHum.MoveDirection * (State.CFrameSpeed * dt))
        end

        if State.Bhop and myHum.MoveDirection.Magnitude > 0 and myHum.FloorMaterial ~= Enum.Material.Air then
            myHum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        if State.FlyEnabled then
            local bv = myHrp:FindFirstChild("MoggerFlyBV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "MoggerFlyBV"
                bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                bv.Parent = myHrp
            end
            local bg = myHrp:FindFirstChild("MoggerFlyBG")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "MoggerFlyBG"
                bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
                bg.P = 90000
                bg.Parent = myHrp
            end
            bg.CFrame = Camera.CFrame
            bv.Velocity = (myHum.MoveDirection.Magnitude > 0) and (Camera.CFrame.LookVector * State.FlySpeed) or Vector3.zero
        end

        if State.SpinBot then
            myHrp.CFrame = myHrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end
    end

    -- Отрисовка ESP (Chams, Material Override, Skeleton, Off-Screen Arrows, Box, HP, Tracer, Name)
    local myPos = (myHrp and myHrp.Position) or Camera.CFrame.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local ally = isTeammate(plr) or Whitelist[plr.UserId]
        local shouldShow = not State.TeamCheck or not ally or State.ShowTeamESP
        local alive = hrp and hum and hum.Health > 0
        local dist = (alive and (myPos - hrp.Position).Magnitude) or math.huge
        local inRange = alive and dist <= State.MaxDist
        local col = ally and Theme.Team or Theme.Enemy

        if char then
            -- Chams (Highlight)
            local chams = char:FindFirstChild("Viskhan_Chams")
            if State.Chams and shouldShow and inRange then
                if not chams then
                    chams = Instance.new("Highlight")
                    chams.Name = "Viskhan_Chams"
                    chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    chams.FillTransparency = 0.45
                    chams.OutlineTransparency = 0.1
                    chams.Parent = char
                end
                chams.FillColor = col
                chams.OutlineColor = Color3.fromRGB(255, 255, 255)
            elseif chams then
                chams:Destroy()
            end

            -- Material Override (Neon Glow)
            if State.MaterialOverride and shouldShow and inRange then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        if not OriginalMaterials[part] then
                            OriginalMaterials[part] = { Material = part.Material, Color = part.Color }
                        end
                        part.Material = Enum.Material.Neon
                        part.Color = col
                    end
                end
            end
        end

        local any2D = State.BoxESP or State.HealthBar or State.TracerESP or State.NameESP or State.SkeletonESP or State.OffScreenArrows
        if any2D and shouldShow and inRange then
            local esp = getOrCreateESP(plr)
            if esp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                -- Off-Screen Arrows (Стрелки за спиной)
                if State.OffScreenArrows and not onScreen then
                    local rel = Camera.CFrame:PointToObjectSpace(hrp.Position)
                    local angle = math.atan2(-rel.Y, rel.X)
                    local radius = 160
                    local dir = Vector2.new(math.cos(angle), math.sin(angle))
                    local perp = Vector2.new(-dir.Y, dir.X)
                    local tip = center + dir * radius
                    local baseCenter = center + dir * (radius - 16)

                    esp.Arrow.PointA = tip
                    esp.Arrow.PointB = baseCenter + perp * 7
                    esp.Arrow.PointC = baseCenter - perp * 7
                    esp.Arrow.Color = col
                    esp.Arrow.Visible = true
                else
                    esp.Arrow.Visible = false
                end

                if onScreen then
                    local scale = (1 / (screenPos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)))) * 1000
                    local w = math.clamp(2.4 * scale, 6, 300)
                    local h = math.clamp(4.4 * scale, 10, 450)
                    local boxPos = Vector2.new(math.floor(screenPos.X - w / 2), math.floor(screenPos.Y - h / 2))
                    local boxSize = Vector2.new(math.floor(w), math.floor(h))

                    if State.BoxESP then
                        esp.BoxOutline.Size = boxSize
                        esp.BoxOutline.Position = boxPos
                        esp.BoxOutline.Visible = true
                        esp.Box.Size = boxSize
                        esp.Box.Position = boxPos
                        esp.Box.Color = col
                        esp.Box.Visible = true
                    else
                        esp.BoxOutline.Visible = false
                        esp.Box.Visible = false
                    end

                    if State.HealthBar then
                        local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        local barX = boxPos.X - 5
                        local bottomY = boxPos.Y + boxSize.Y
                        local topY = bottomY - (boxSize.Y * hpPct)

                        esp.HpBg.From = Vector2.new(barX, bottomY + 1)
                        esp.HpBg.To = Vector2.new(barX, boxPos.Y - 1)
                        esp.HpBg.Visible = true

                        esp.HpBar.From = Vector2.new(barX, bottomY)
                        esp.HpBar.To = Vector2.new(barX, topY)
                        esp.HpBar.Color = Color3.fromHSV(hpPct * 0.33, 0.85, 0.95)
                        esp.HpBar.Visible = true
                    else
                        esp.HpBg.Visible = false
                        esp.HpBar.Visible = false
                    end

                    if State.TracerESP then
                        esp.Tracer.From = Vector2.new(vp.X / 2, vp.Y - 10)
                        esp.Tracer.To = Vector2.new(screenPos.X, boxPos.Y + boxSize.Y)
                        esp.Tracer.Color = col
                        esp.Tracer.Visible = true
                    else
                        esp.Tracer.Visible = false
                    end

                    if State.NameESP then
                        esp.NameTag.Text = string.format("%s • %d HP [%dm]", plr.DisplayName or plr.Name, math.floor(hum.Health), math.floor(dist))
                        esp.NameTag.Position = Vector2.new(screenPos.X, boxPos.Y - 16)
                        esp.NameTag.Color = Color3.fromRGB(240, 240, 245)
                        esp.NameTag.Visible = true
                    else
                        esp.NameTag.Visible = false
                    end

                    -- Skeleton ESP
                    if State.SkeletonESP then
                        local pairsList = (char:FindFirstChild("UpperTorso") and BonePairsR15) or BonePairsR6
                        for idx, pair in ipairs(pairsList) do
                            local p1 = char:FindFirstChild(pair[1])
                            local p2 = char:FindFirstChild(pair[2])
                            local line = esp.Bones[idx]
                            if p1 and p2 and line then
                                local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                                local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                                if vis1 and vis2 then
                                    line.From = Vector2.new(v1.X, v1.Y)
                                    line.To = Vector2.new(v2.X, v2.Y)
                                    line.Color = col
                                    line.Visible = true
                                else
                                    line.Visible = false
                                end
                            elseif line then
                                line.Visible = false
                            end
                        end
                        for idx = #pairsList + 1, #esp.Bones do
                            esp.Bones[idx].Visible = false
                        end
                    else
                        for _, b in ipairs(esp.Bones) do b.Visible = false end
                    end
                else
                    esp.BoxOutline.Visible = false
                    esp.Box.Visible = false
                    esp.HpBg.Visible = false
                    esp.HpBar.Visible = false
                    esp.Tracer.Visible = false
                    esp.NameTag.Visible = false
                    for _, b in ipairs(esp.Bones) do b.Visible = false end
                end
            end
        else
            hideESP(plr)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        pcall(function()
            for k, d in pairs(ESPObjects[plr]) do
                if k == "Bones" then
                    for _, b in ipairs(d) do b:Remove() end
                else
                    d:Remove()
                end
            end
        end)
        ESPObjects[plr] = nil
    end
end)

getgenv().ViskhanJumpConn = UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

getgenv().ViskhanAfkConn = LP.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

getgenv().ViskhanNoclipConn = RunService.Stepped:Connect(function()
    if State.Noclip and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.05)
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and State.SpeedEnabled then
                hum.WalkSpeed = State.Speed
            end
            if State.AutoClicker then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end
            if State.Hitbox then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
                        local head = p.Character.Head
                        if (State.TeamCheck and isTeammate(p)) or Whitelist[p.UserId] then
                            head.Size = Vector3.new(1.2, 1.2, 1.2)
                            head.Transparency = 0
                        else
                            head.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                            head.Transparency = 0.5
                            head.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

sendNotification("Mogger Menu v4.5", "Успешно загружен! Создатели: Исхан и Висхан")
