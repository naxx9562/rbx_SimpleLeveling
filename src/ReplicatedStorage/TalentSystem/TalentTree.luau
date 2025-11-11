local Tree = {}
local repl = game:GetService("ReplicatedStorage")

local BaseTalentModule = require(repl.TalentSystem.BaseTalent)
type BaseTalent = typeof(BaseTalentModule.new())

function Tree.IsInPath(targetTalentName : string, curTalents : {[string]: BaseTalent})
    local UnlockedBy = Tree.Talents[targetTalentName].UnlockedBy
    if UnlockedBy == nil or #UnlockedBy == 0 then
        return true
    end

    for _, Unlocks in pairs(UnlockedBy) do
        if curTalents[Unlocks] then
            return true
        end
    end
    return false
end

function Tree.Init()
    Tree.Talents = { -- UnlockedBy is autoinit
        DoubleJump = {Cost = 1, Unlocks = {"TripleJump"}, Replaces = nil, UnlockedBy = nil}, 
        TripleJump = {Cost = 1, Unlocks = {"QuadJump"}, Replaces = {"DoubleJump"}, UnlockedBy = {}},
        QuadJump = {Cost = 1, Unlocks = {}, Replaces = {"TripleJump"}, UnlockedBy = {}},
    }

    for TalentName, TalentInfo in pairs(Tree.Talents) do
        for _, Unlock in pairs(TalentInfo.Unlocks) do
            local target = Tree.Talents[Unlock]
            if not target.UnlockedBy then
                target.UnlockedBy = {}
            end

            table.insert(target.UnlockedBy, TalentName)
        end
    end
end

return Tree