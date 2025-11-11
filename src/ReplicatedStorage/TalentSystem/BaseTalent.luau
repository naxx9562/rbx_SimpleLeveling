local BaseTalent = {}

function BaseTalent.new()
	local self = setmetatable({}, BaseTalent)

	self.connections = {}
	self.localConnections = {}
	self.name = "unknown"

	function self:onPurchase(player : Player) end
	function self:onPurchaseClient() end

	function self:onDestroy(player : Player) end
	function self:onDestroyClient() end

	return self
end

return BaseTalent
