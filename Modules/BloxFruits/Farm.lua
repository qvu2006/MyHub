local Services = require(script.Parent.Parent.Parent.Core.Services)
local Utils    = require(script.Parent.Parent.Parent.Core.Utils)
local Quest    = require(script.Parent.Quest)

local Farm = {}
Farm.Enabled = false

local function GetQuestMob()
    local q = Quest.Current
    if not q then return nil end

    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name:find(q.MobName)
        and mob:FindFirstChild("Humanoid")
        and mob.Humanoid.Health > 0
        and mob:FindFirstChild("HumanoidRootPart") then
            return mob
        end
    end

    return nil
end

function Farm.Start()
    Farm.Enabled = true

    task.spawn(function()
        while task.wait(0.2) do
            if Farm.Enabled then
                local mob = GetQuestMob()

                if mob then
                    Utils.TP(
                        mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    )

                    -- auto click (executor hỗ trợ)
                    pcall(function()
                        mouse1click()
                    end)
                end
            end
        end
    end)
end

function Farm.Stop()
    Farm.Enabled = false
end

return Farm
