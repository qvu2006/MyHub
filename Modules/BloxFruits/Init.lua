local Services = require(script.Parent.Parent.Parent.Core.Services)
local Tabs = require(script.Parent.Parent.Parent.UI.Tabs)

local BloxFruits = {}

function BloxFruits.Load()
    if game.GameId ~= 994732206 then return end

    local page = Tabs:New("Blox Fruits")
    page.Visible = true

    require(script.UI).Init(page)
end

return BloxFruits
