local QuadJump = {}

local repl = game:GetService("ReplicatedStorage")
local DoubleJump = require(repl.TalentSystem.Talents.DoubleJump)

function QuadJump.new()
	local self = DoubleJump.new()
	self.name = "QuadJump"
	self.MAXJUMP = 3

	return self
end

return QuadJump
