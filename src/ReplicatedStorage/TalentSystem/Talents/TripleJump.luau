local TripleJump = {}

local repl = game:GetService("ReplicatedStorage")
local DoubleJump = require(repl.TalentSystem.Talents.DoubleJump)

function TripleJump.new()
	local self = DoubleJump.new()
	self.name = "TripleJump"
	self.MAXJUMP = 2

	return self
end

return TripleJump
