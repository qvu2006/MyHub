-- =========================================
-- MYHUB | BLOX FRUITS | FULL
-- XENO SAFE | ONE FILE
-- =========================================

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG + SAVE =================
local ConfigFile = "MyHub_Config.json"
local Config = {
    AutoFarm  = false,
    HoverFarm = true,
    AutoClick = false,
    FastPunch = true,
    Reach     = false,
    ReachSize = 25,
    ESP       = false,
}

local function SaveConfig()
    if writefile then
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(ConfigFile) then
        local data = HttpService:JSONDecode(readfile(ConfigFile))
        for k,v in pairs(data) do Config[k] = v end
    end
end
LoadConfig()

-- ================= UTILS =================
local function Char()
    return LocalPlayer.Character
end
local function HRP()
    local c = Char()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function TP(cf)
    if HRP() then HRP().CFrame = cf end
end

-- ================= UI BASE =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MyHubUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.45,0.55)
main.Position = UDim2.fromScale(0.275,0.22)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active, main.Draggable = true, true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.fromScale(1,0.12)
title.Text = "MyHub | Blox Fruits"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- Tabs bar
local tabBar = Instance.new("Frame", main)
tabBar.Position = UDim2.fromScale(0,0.12)
tabBar.Size = UDim2.fromScale(1,0.1)
tabBar.BackgroundColor3 = Color3.fromRGB(35,35,35)

-- Pages
local pages = Instance.new("Frame", main)
pages.Position = UDim2.fromScale(0,0.22)
pages.Size = UDim2.fromScale(1,0.78)
pages.BackgroundTransparency = 1

local CurrentTab
local function NewTab(name, order)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.fromScale(0.33,1)
    btn.Position = UDim2.fromScale((order-1)*0.33,0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(55,55,55)

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

local CombatTab = NewTab("Combat",1)
local FarmTab   = NewTab("Farm",2)
local ESPTab    = NewTab("ESP",3)
CombatTab.Visible = true
CurrentTab = CombatTab

-- ================= UI ELEMENTS =================
local function Toggle(parent, text, y, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.fromScale(0.8,0.12)
    b.Position = UDim2.fromScale(0.1,y)
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text..": "..(Config[key] and "ON" or "OFF")

    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        b.Text = text..": "..(Config[key] and "ON" or "OFF")
        SaveConfig()
    end)
end

local function Slider(parent, text, y, min, max, key)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.fromScale(0.8,0.18)
    holder.Position = UDim2.fromScale(0.1,y)
    holder.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", holder)
    lbl.Size = UDim2.fromScale(1,0.45)
    lbl.Text = text..": "..Config[key]
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1

    local bar = Instance.new("Frame", holder)
    bar.Position = UDim2.fromScale(0,0.55)
    bar.Size = UDim2.fromScale(1,0.25)
    bar.BackgroundColor3 = Color3.fromRGB(70,70,70)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.fromScale((Config[key]-min)/(max-min),1)
    fill.BackgroundColor3 = Color3.fromRGB(120,120,120)

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    bar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local x = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            fill.Size = UDim2.fromScale(x,1)
            Config[key] = math.floor(min + (max-min)*x)
            lbl.Text = text..": "..Config[key]
            SaveConfig()
        end
    end)
end

-- ================= BUILD UI =================
-- Combat
Toggle(CombatTab,"Auto Click (0s)",0.05,"AutoClick")
Toggle(CombatTab,"Fast Punch",0.18,"FastPunch")
Toggle(CombatTab,"Reach (Tầm đánh)",0.31,"Reach")
Slider(CombatTab,"Reach Size",0.48,10,60,"ReachSize")

-- Farm
Toggle(FarmTab,"Auto Farm",0.05,"AutoFarm")
Toggle(FarmTab,"Hover Farm (Bay)",0.18,"HoverFarm")

-- ESP
Toggle(ESPTab,"ESP Enemy",0.05,"ESP")

-- ================= AUTO CLICK + FAST PUNCH =================
RunService.Heartbeat:Connect(function()
    if Config.AutoClick then
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0,0))
            VirtualUser:Button1Up(Vector2.new(0,0))
            if Config.FastPunch then
                VirtualUser:Button1Down(Vector2.new(0,0))
                VirtualUser:Button1Up(Vector2.new(0,0))
            end
        end)
    end
end)

-- ================= AUTO FARM (HOVER) =================
local function GetEnemy()
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end
    for _,mob in pairs(enemies:GetChildren()) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            return mob
        end
    end
end

task.spawn(function()
    while task.wait(0.15) do
        if Config.AutoFarm then
            local mob = GetEnemy()
            if mob and mob:FindFirstChild("HumanoidRootPart") then
                local hrp = mob.HumanoidRootPart
                if Config.HoverFarm then
                    TP(hrp.CFrame * CFrame.new(0,12,0)) -- bay phía trên
                else
                    TP(hrp.CFrame * CFrame.new(0,0,3))
                end
            end
        end
    end
end)

-- ================= REACH (SAFE) =================
task.spawn(function()
    while task.wait(0.5) do
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _,mob in pairs(enemies:GetChildren()) do
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local hum = mob:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    if Config.Reach then
                        hrp.Size = Vector3.new(Config.ReachSize,Config.ReachSize,Config.ReachSize)
                        hrp.CanCollide = false
                        hrp.Transparency = 0.8
                    else
                        hrp.Size = Vector3.new(2,2,1)
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
end)

-- ================= ESP (ENEMY ONLY) =================
local function ClearESP()
    for _,v in pairs(game.CoreGui:GetDescendants()) do
        if v.Name == "MyHubESP" then v:Destroy() end
    end
end

task.spawn(function()
    while task.wait(1) do
        if not Config.ESP then
            ClearESP()
        else
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                for _,mob in pairs(enemies:GetChildren()) do
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    local hum = mob:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 and not hrp:FindFirstChild("MyHubESP") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "MyHubESP"
                        box.Adornee = hrp
                        box.Size = Vector3.new(4,6,4)
                        box.AlwaysOnTop = true
                        box.Color3 = Color3.new(1,0,0)
                        box.Parent = hrp
                    end
                end
            end
        end
    end
end)

print("MyHub FULL READY")
