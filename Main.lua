--==================================================
-- MYHUB - FULL SINGLE FILE
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
local Mouse = LP:GetMouse()

--================= KEY SYSTEM =================
local ValidKeys = {
    ["MYHUB-TEST"] = true,
    ["MYHUB-VIP"] = true
}

local function CheckKey(k)
    return ValidKeys[k] == true
end

local KeyOK = false
local KeyGui = Instance.new("ScreenGui", game.CoreGui)
KeyGui.Name = "MyHubKey"

local KF = Instance.new("Frame", KeyGui)
KF.Size = UDim2.fromScale(0.3,0.25)
KF.Position = UDim2.fromScale(0.35,0.35)
KF.BackgroundColor3 = Color3.fromRGB(30,30,30)
KF.Active, KF.Draggable = true, true

local KL = Instance.new("TextLabel", KF)
KL.Size = UDim2.fromScale(1,0.25)
KL.Text = "MYHUB KEY SYSTEM"
KL.TextScaled = true
KL.TextColor3 = Color3.new(1,1,1)
KL.BackgroundTransparency = 1

local KB = Instance.new("TextBox", KF)
KB.PlaceholderText = "Enter Key..."
KB.Size = UDim2.fromScale(0.8,0.25)
KB.Position = UDim2.fromScale(0.1,0.35)
KB.TextScaled = true
KB.BackgroundColor3 = Color3.fromRGB(50,50,50)
KB.TextColor3 = Color3.new(1,1,1)

local KBtn = Instance.new("TextButton", KF)
KBtn.Text = "VERIFY"
KBtn.Size = UDim2.fromScale(0.5,0.2)
KBtn.Position = UDim2.fromScale(0.25,0.7)
KBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
KBtn.TextColor3 = Color3.new(1,1,1)

KBtn.MouseButton1Click:Connect(function()
    if CheckKey(KB.Text) then
        KeyOK = true
        KeyGui:Destroy()
    else
        KBtn.Text = "INVALID"
        task.wait(1)
        KBtn.Text = "VERIFY"
    end
end)

repeat task.wait() until KeyOK

--================= CONFIG =================
local ConfigFile = "MyHub_Config.json"
local Config = {
    AutoClick = false,
    FastPunch = false,
    Reach = false,
    ReachSize = 25,

    AutoFarm = false,
    HoverFarm = true,

    ESP_Player = false,
    ESP_Enemy = false,

    AntiAFK = true
}

local function SaveConfig()
    if writefile then
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(ConfigFile) then
        local d = HttpService:JSONDecode(readfile(ConfigFile))
        for k,v in pairs(d) do Config[k] = v end
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

--================= UI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyHubUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.5,0.6)
main.Position = UDim2.fromScale(0.25,0.2)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.1)
title.Text = "MYHUB - SINGLE FILE"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

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
    local b = Instance.new("TextButton", tabBar)
    b.Size = UDim2.fromScale(0.33,1)
    b.Position = UDim2.fromScale((order-1)*0.33,0)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local p = Instance.new("Frame", pages)
    p.Size = UDim2.fromScale(1,1)
    p.Visible = false
    p.BackgroundTransparency = 1

    b.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        p.Visible = true
        CurrentTab = p
    end)

    return p
end

local CombatTab = NewTab("Combat",1)
local FarmTab   = NewTab("Farm",2)
local ESPTab    = NewTab("ESP",3)

CombatTab.Visible = true
CurrentTab = CombatTab

local function Toggle(parent, text, y, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.fromScale(0.8,0.12)
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

-- UI Build
Toggle(CombatTab,"Auto Click",0.05,"AutoClick")
Toggle(CombatTab,"Fast Punch",0.20,"FastPunch")
Toggle(CombatTab,"Reach",0.35,"Reach")

Toggle(FarmTab,"Auto Farm (Safe)",0.05,"AutoFarm")
Toggle(FarmTab,"Hover Farm",0.20,"HoverFarm")

Toggle(ESPTab,"ESP Player",0.05,"ESP_Player")
Toggle(ESPTab,"ESP Enemy",0.20,"ESP_Enemy")

--================= COMBAT LOGIC =================
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoClick then
            mouse1click()
            if Config.FastPunch then
                task.wait(0.05)
                mouse1click()
            end
        end
    end
end)

local Skills = {Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,Enum.KeyCode.V}
task.spawn(function()
    while task.wait(0.3) do
        if Config.FastPunch then
            for _,k in ipairs(Skills) do
                keypress(k)
                task.wait(0.05)
                keyrelease(k)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Config.Reach then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart")
                and v.Name == "HumanoidRootPart"
                and v.Parent ~= LP.Character then
                    v.Size = Vector3.new(Config.ReachSize,Config.ReachSize,Config.ReachSize)
                    v.Transparency = 0.7
                    v.Material = Enum.Material.Neon
                end
            end
        end
    end
end)

--================= ANTI AFK =================
if Config.AntiAFK then
    LP.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

print("MYHUB LOADED SUCCESSFULLY")
