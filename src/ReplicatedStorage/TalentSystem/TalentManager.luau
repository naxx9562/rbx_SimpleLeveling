local TalentManager = {}
TalentManager.__index = TalentManager

local repl = game:GetService("ReplicatedStorage")
local TalentTree = require(repl.TalentSystem.TalentTree)

local BaseTalentModule = require(repl.TalentSystem.BaseTalent)
type BaseTalent = typeof(BaseTalentModule.new())

function TalentManager.create(player : Player)
	local self = setmetatable({}, TalentManager)
	
	self.player = player
	self.talents = {}
	self.aviablePoints = 9999
	
	return self
end

function TalentManager:SafePurchaseTalent(talentName : string)
	if self.talents[talentName] then
		print("already bought")
		return
	end

	local TALENT_COST = TalentTree.Talents[talentName].Cost
	if self.aviablePoints < TALENT_COST then
		print("too poor")
		return
	end

	if not TalentTree.IsInPath(talentName, self.talents) then
		print("not in path")
		return
	end

	self.aviablePoints -= TALENT_COST

	local currentTalent = require(repl.TalentSystem.Talents[talentName]).new()
	self.talents[currentTalent.name] = currentTalent

	local replaces = TalentTree.Talents[talentName].Replaces
	if replaces and #replaces > 0 then
		for _, toReplace in pairs(replaces) do
			if not self.talents[toReplace] then
				continue
			end

			self.talents[toReplace]:onDestroy()
			self.talents[toReplace] = nil
		end
	end

	currentTalent:onPurchase(self.player)
	repl.TalentSystem.Remotes.TalentSync:FireClient(self.player, self)
end

return TalentManager
