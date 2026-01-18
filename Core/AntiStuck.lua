local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local AntiStuck = {}

AntiStuck.Enabled = true
AntiStuck.LastMove = tick()
AntiStuck.LastPos = nil

-- config
AntiStuck.MaxIdleTime = 5
AntiStuck.MinMoveDist = 1.5

local function GetChar()
    return LocalPlayer.Character
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChild("Humanoid")
end

local function SafeJump()
    local hum = GetHum()
    if hum and hum.FloorMaterial ~= Enum.Material.Air then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

local function SmallMove()
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.new(
            math.random(-5,5),
            0,
            math.random(-5,5)
        )
    end
end

function AntiStuck.Start()
    RunService.Heartbeat:Connect(function()
        if not AntiStuck.Enabled then return end

        local hrp = GetHRP()
        local hum = GetHum()
        if not hrp or not hum then return end

        -- chết → chờ respawn
        if hum.Health <= 0 then
            AntiStuck.LastPos = nil
            return
        end

        -- rơi xuống void
        if hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(0, 200, 0)
            return
        end

        -- kiểm tra đứng yên
        if AntiStuck.LastPos then
            local dist = (hrp.Position - AntiStuck.LastPos).Magnitude

            if dist < AntiStuck.MinMoveDist then
                if tick() - AntiStuck.LastMove > AntiStuck.MaxIdleTime then
                    SafeJump()
                    task.wait(0.2)
                    SmallMove()
                    AntiStuck.LastMove = tick()
                end
            else
                AntiStuck.LastMove = tick()
            end
        end

        AntiStuck.LastPos = hrp.Position
    end)
end

return AntiStuck
