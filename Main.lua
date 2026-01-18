-- =========================================
-- MYHUB - BLOX FRUITS FULL (XENO SAFE)
-- =========================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

print("MyHub Full Loaded")

-- =========================================
-- SERVICES
-- =========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- =========================================
-- CONFIG + SAVE
-- =========================================
local ConfigFile = "MyHub_Config.json"

local Config = {
    AutoQuest = false,
    AutoFarm = false,
    AutoSkill = false,
    AutoBoss = false,
    ESP = false
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

-- =========================================
-- UTILS
-- =========================================
local function Char()
    return LocalPlayer.Character
end

local function HRP()
    return Char() and Char():FindFirstChild("HumanoidRootPart")
end

local function TP(cf)
    if HRP() then
        HRP().CFrame = cf
    end
end

-- =========================================
-- SEA DETECT
-- =========================================
local Sea = 1
if game.PlaceId == 4442272183 then Sea = 2 end
if game.PlaceId == 7449423635 then Sea = 3 end

print("Detected Sea:", Sea)

-- =========================================
-- UI
-- =========================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyHubUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35,0.45)
main.Position = UDim2.fromScale(0.32,0.25)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.15)
title.Text = "MyHub | Blox Fruits"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local function Toggle(text,y,key)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.fromScale(0.8,0.12)
    b.Position = UDim2.fromScale(0.1,y)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)

    b.Text = text..": "..(Config[key] and "ON" or "OFF")

    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text..": "..(Config[key] and "ON" or "OFF")
        SaveConfig()
    end)
end

Toggle("Auto Quest",0.18,"AutoQuest")
Toggle("Auto Farm",0.32,"AutoFarm")
Toggle("Auto Skill",0.46,"AutoSkill")
Toggle("Auto Boss",0.60,"AutoBoss")
Toggle("ESP",0.74,"ESP")

-- =========================================
-- ESP (PLAYER + MOB)
-- =========================================
task.spawn(function()
    while task.wait(1) do
        if Config.ESP then
            for _,m in pairs(workspace:GetDescendants()) do
                if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
                    if not m:FindFirstChild("ESP") then
                        local box = Instance.new("BoxHandleAdornment", m)
                        box.Name = "ESP"
                        box.Adornee = m.HumanoidRootPart
                        box.Size = Vector3.new(4,6,4)
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Color3 = Color3.new(1,0,0)
                    end
                end
            end
        else
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "ESP" then v:Destroy() end
            end
        end
    end
end)

-- =========================================
-- AUTO SKILL (Z X C V)
-- =========================================
task.spawn(function()
    while task.wait(0.4) do
        if Config.AutoSkill then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                for _,k in pairs({"Z","X","C","V"}) do
                    vim:SendKeyEvent(true,k,false,game)
                    task.wait(0.05)
                    vim:SendKeyEvent(false,k,false,game)
                end
            end)
        end
    end
end)

-- =========================================
-- AUTO FARM + BOSS
-- =========================================
local function GetEnemy(isBoss)
    for _,e in pairs(workspace.Enemies:GetChildren()) do
        if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            if isBoss then
                if e.Name:lower():find("boss") then
                    return e
                end
            else
                return e
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.25) do
        if Config.AutoFarm or Config.AutoBoss then
            local mob = GetEnemy(Config.AutoBoss)
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                TP(mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                mouse1click()
            end
        end
    end
end)

print("MyHub FULL READY")
