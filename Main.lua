-- ===============================
-- MYHUB - ALL IN ONE
-- ===============================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

print("MyHub Loaded")

-- ===============================
-- SERVICES
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===============================
-- CONFIG
-- ===============================
local Config = {
    AutoQuest = false,
    AutoFarm  = false,
    AntiStuck = true
}

-- ===============================
-- UTILS
-- ===============================
local function Char()
    return LocalPlayer.Character
end

local function HRP()
    local c = Char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function TP(cf)
    if HRP() then
        HRP().CFrame = cf
    end
end

-- ===============================
-- UI (SIMPLE – XENO FRIENDLY)
-- ===============================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyHubUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35, 0.35)
main.Position = UDim2.fromScale(0.325, 0.3)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1, 0.2)
title.Text = "MyHub - Blox Fruits"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local function NewToggle(text, y, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.fromScale(0.8, 0.2)
    btn.Position = UDim2.fromScale(0.1, y)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)

    local state = false
    btn.Text = text .. ": OFF"

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

-- ===============================
-- QUEST DATA (SEA 1 SAMPLE)
-- ===============================
local Quests = {
    {
        MinLevel = 1,
        MobName = "Bandit",
        QuestNPC = CFrame.new(1059,16,1547)
    }
}

local CurrentQuest = nil

local function GetLevel()
    local d = LocalPlayer:FindFirstChild("Data")
    if d and d:FindFirstChild("Level") then
        return d.Level.Value
    end
    return 1
end

local function GetQuest()
    local level = GetLevel()
    local chosen = nil

    for _,q in pairs(Quests) do
        if level >= q.MinLevel then
            chosen = q
        end
    end

    CurrentQuest = chosen
    return chosen
end

-- ===============================
-- AUTO QUEST
-- ===============================
task.spawn(function()
    while task.wait(2) do
        if Config.AutoQuest then
            local q = GetQuest()
            if q then
                TP(q.QuestNPC)
                print("Auto Quest:", q.MobName)
            end
        end
    end
end)

-- ===============================
-- AUTO FARM
-- ===============================
local function GetMob()
    if not CurrentQuest then return end

    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name:find(CurrentQuest.MobName)
        and mob:FindFirstChild("Humanoid")
        and mob.Humanoid.Health > 0
        and mob:FindFirstChild("HumanoidRootPart") then
            return mob
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if Config.AutoFarm then
            local mob = GetMob()
            if mob then
                TP(mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
                pcall(function()
                    mouse1click()
                end)
            end
        end
    end
end)

-- ===============================
-- ANTI STUCK (LIGHT)
-- ===============================
local lastPos = nil
local lastMove = tick()

RunService.Heartbeat:Connect(function()
    if not Config.AntiStuck then return end

    local hrp = HRP()
    if not hrp then return end

    if lastPos then
        local dist = (hrp.Position - lastPos).Magnitude
        if dist < 1 then
            if tick() - lastMove > 5 then
                hrp.CFrame = hrp.CFrame * CFrame.new(5,0,0)
                lastMove = tick()
            end
        else
            lastMove = tick()
        end
    end

    lastPos = hrp.Position
end)

-- ===============================
-- UI BUTTONS
-- ===============================
NewToggle("Auto Quest", 0.25, function(v)
    Config.AutoQuest = v
end)

NewToggle("Auto Farm", 0.5, function(v)
    Config.AutoFarm = v
end)

print("MyHub Ready")
