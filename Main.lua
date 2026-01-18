local Services = require(script.Core.Services)
local Config   = require(script.Core.Config)
local Utils    = require(script.Core.Utils)

local Window   = require(script.UI.Window)
local Tabs     = require(script.UI.Tabs)

local Modules  = script.Modules

local Main = {}

function Main.Start()
    if not Config.CheckKey() then
        warn("Invalid Key")
        return
    end

    Window:Create()
    Tabs:Init(Window.Main)

    -- Load modules
    for _,module in pairs(Modules:GetChildren()) do
        if module:IsA("Folder") then
            local init = module:FindFirstChild("Init")
            if init then
                require(init).Load()
            end
        end
    end
end

return Main
