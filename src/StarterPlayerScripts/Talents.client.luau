local repl = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer

local TalentManager = require(repl.TalentSystem.TalentManager)
local BaseTalentModule = require(repl.TalentSystem.BaseTalent)
type MANAGER_TYPE = typeof(TalentManager.create(player))
type BaseTalent = typeof(BaseTalentModule.new())

local curTalents = {}
repl.TalentSystem.Remotes.TalentSync.OnClientEvent:Connect(function(manager : MANAGER_TYPE)
    local newTalents = manager.talents
    for i, v : BaseTalent in pairs(curTalents) do
        if not newTalents[i] then
            v:onDestroyClient()
        end
    end

    for i, v : BaseTalent in pairs(newTalents) do
        if not curTalents[i] then
            curTalents[i] = require(repl.TalentSystem.Talents[i]).new()
            curTalents[i]:onPurchaseClient()
        end
    end
end)
repl.TalentSystem.Remotes.TalentSync:FireServer()

-- TEST ONLY
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.One then
		repl.TalentSystem.Remotes.TalentPurchase:FireServer("DoubleJump")
		print("Fired 4 double jump")
    elseif input.KeyCode == Enum.KeyCode.Two then
		repl.TalentSystem.Remotes.TalentPurchase:FireServer("TripleJump")
		print("Fired 4 triple jump")
    end
end)