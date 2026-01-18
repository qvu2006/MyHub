local Services = require(script.Parent.Services)
local Utils = {}

function Utils.Char()
    return Services.LocalPlayer.Character
end

function Utils.HRP()
    local c = Utils.Char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

function Utils.TP(cf)
    if Utils.HRP() then
        Utils.HRP().CFrame = cf
    end
end

return Utils
