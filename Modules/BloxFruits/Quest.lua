local Services = require(script.Parent.Parent.Parent.Core.Services)
local Utils    = require(script.Parent.Parent.Parent.Core.Utils)
local Data     = require(script.Parent.Data)

local Quest = {}
Quest.Current = nil

local function GetLevel()
    local data = Services.LocalPlayer:FindFirstChild("Data")
    if not data then return 1 end

    local level = data:FindFirstChild("Level")
    return level and level.Value or 1
end

function Quest.GetQuest()
    local level = GetLevel()
    local chosen = nil

    for _,q in pairs(Data.Quests) do
        if level >= q.MinLevel then
            chosen = q
        end
    end

    Quest.Current = chosen
    return chosen
end

function Quest.Start()
    task.spawn(function()
        while task.wait(1) do
            local q = Quest.GetQuest()

            if q then
                -- teleport tới NPC quest
                Utils.TP(q.QuestNPC)

                print("Nhận quest:", q.QuestName)
            end
        end
    end)
end

return Quest
