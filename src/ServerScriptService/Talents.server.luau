local repl = game:GetService("ReplicatedStorage")

local TalentTree = require(repl.TalentSystem.TalentTree) TalentTree.Init()
local TalentManager = require(repl.TalentSystem.TalentManager)

local managers = {}

game.Players.PlayerAdded:Connect(function(player)
    managers[player.UserId] = TalentManager.create(player)
    
    repl.TalentSystem.Remotes.TalentSync.OnServerEvent:Connect(function(player)
        repl.TalentSystem.Remotes.TalentSync:FireClient(player, managers[player.UserId])
    end)
end)

repl.TalentSystem.Remotes.TalentPurchase.OnServerEvent:Connect(function(player, talentName : string)
    managers[player.UserId]:SafePurchaseTalent(talentName)
end)