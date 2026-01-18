--==================================================
-- MYHUB - FULL HUB FRAMEWORK (1 FILE)
--==================================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

--================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

--================= KEY SYSTEM =================
local ValidKeys = {
    ["MYHUB-TEST"] = true,
    ["MYHUB-VIP"] = true
}

local function CheckKey(key)
    return ValidKeys[key] == true
end

--================= CONFIG SAVE =================
local ConfigFile = "MyHub_Config.json"
local Config = {
    -- Combat
    AutoClick = false,
    FastPunch = false,
    Reach = false,
    ReachSize = 25,
    Weapon = "Melee",

    -- Farm
    AutoFarm = false,
    HoverFarm = true,
    AutoQuest = false,
    AutoLevel = false,
    BringMob = false,

    -- Boss
    AutoBoss = false,
    SelectedBoss = "",

    -- ESP
    ESP_Player = false,
    ESP_Enemy = false,
    ESP_Boss = false,

    -- Misc
    AntiAFK = true,
    AntiStuck = true,
    FPSBoost = false
}

local function SaveConfig()
    if writefile then
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(ConfigFile) then
        local data = HttpService:JSONDecode(readfile(ConfigFile))
        for k,v in pairs(data) do
            Config[k] = v
        end
    end
end

LoadConfig()

--================= UTILS =================
local function Char()
    return LP.Character
end

local function HRP()
    return Char() and Char():FindFirstChild("HumanoidRootPart")
end

local function TP(cf)
    if HRP() then HRP().CFrame = cf end
end

--================= UI BASE =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyHubUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.5,0.6)
main.Position = UDim2.fromScale(0.25,0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.1)
title.Text = "MyHub - Full Framework"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

--================= TAB SYSTEM =================
local tabBar = Instance.new("Frame", main)
tabBar.Position = UDim2.fromScale(0,0.1)
tabBar.Size = UDim2.fromScale(1,0.1)
tabBar.BackgroundColor3 = Color3.fromRGB(35,35,35)

local pages = Instance.new("Frame", main)
pages.Position = UDim2.fromScale(0,0.2)
pages.Size = UDim2.fromScale(1,0.8)
pages.BackgroundTransparency = 1

local CurrentTab
local function NewTab(name, order)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.fromScale(0.2,1)
    btn.Position = UDim2.fromScale((order-1)*0.2,0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local page = Instance.new("Frame", pages)
    page.Size = UDim2.fromScale(1,1)
    page.Visible = false
    page.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        page.Visible = true
        CurrentTab = page
    end)

    return page
end

local CombatTab   = NewTab("Combat",1)
local FarmTab     = NewTab("Farm",2)
local BossTab     = NewTab("Boss",3)
local TeleportTab = NewTab("Teleport",4)
local ESPTab      = NewTab("ESP",5)

CombatTab.Visible = true
CurrentTab = CombatTab

--================= UI ELEMENTS =================
local function Toggle(parent, text, y, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.fromScale(0.8,0.1)
    b.Position = UDim2.fromScale(0.1,y)
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text..": "..(Config[key] and "ON" or "OFF")

    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text..": "..(Config[key] and "ON" or "OFF")
        SaveConfig()
    end)
end

--================= BUILD UI =================
-- Combat
Toggle(CombatTab,"Auto Click",0.05,"AutoClick")
Toggle(CombatTab,"Fast Punch",0.17,"FastPunch")
Toggle(CombatTab,"Reach",0.29,"Reach")

-- Farm
Toggle(FarmTab,"Auto Farm",0.05,"AutoFarm")
Toggle(FarmTab,"Hover Farm",0.17,"HoverFarm")
Toggle(FarmTab,"Auto Quest",0.29,"AutoQuest")
Toggle(FarmTab,"Auto Level",0.41,"AutoLevel")
Toggle(FarmTab,"Bring Mob (Safe)",0.53,"BringMob")

-- Boss
Toggle(BossTab,"Auto Boss",0.05,"AutoBoss")

-- ESP
Toggle(ESPTab,"ESP Player",0.05,"ESP_Player")
Toggle(ESPTab,"ESP Enemy",0.17,"ESP_Enemy")
Toggle(ESPTab,"ESP Boss",0.29,"ESP_Boss")

--================= LOGIC PLACEHOLDER =================
-- Anti AFK
if Config.AntiAFK then
    LP.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

-- FPS Boost (SAFE)
if Config.FPSBoost then
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

print("MyHub Framework Loaded Successfully")
