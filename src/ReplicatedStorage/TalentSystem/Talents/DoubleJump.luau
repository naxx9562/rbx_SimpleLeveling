local DoubleJump = {}

local repl = game:GetService("ReplicatedStorage")
local BaseTalentModule = require(repl.TalentSystem.BaseTalent)

function DoubleJump.new()
	local self = BaseTalentModule.new()
	self.name = "DoubleJump"
	self.MAXJUMP = 1
	
	function self:disconnectClient()
		for _, v in pairs(self.localConnections) do
			v:Disconnect()
		end
	end

	function self:onPurchaseClient()
		local player = game:GetService("Players").LocalPlayer

		local canJump = self.MAXJUMP
		local function ForceJump(Character : Model, humanoid : Humanoid)
			if not humanoid or humanoid.Health <= 0 then
				return
			end

			local root : Part = Character.HumanoidRootPart
			local curVel = root.AssemblyLinearVelocity
			root.AssemblyLinearVelocity = Vector3.new(
				curVel.X,
				math.max(curVel.Y, humanoid.JumpPower),
				curVel.Z
			)
			canJump -= 1
			print("bonus jumped")
		end

		local UIS = game:GetService("UserInputService")
		local function BindDoubleJump(character)
			if self.localConnections["jumper"] then
        		self.localConnections["jumper"]:Disconnect()
				self.localConnections["status"]:Disconnect()

        		self.localConnections["jumper"] = nil
				self.localConnections["status"] = nil
    		end
			
			local humanoid : Humanoid = character:WaitForChild("Humanoid")

			self.localConnections["jumper"] = UIS.InputBegan:Connect(function(key)
				if key.KeyCode ~= Enum.KeyCode.Space then
					return
				end

				if humanoid.FloorMaterial == Enum.Material.Air and canJump > 0 then
					ForceJump(character, humanoid)
				end
			end)

			self.localConnections["status"] = humanoid.StateChanged:Connect(function(oldState, newState)
				if newState == Enum.HumanoidStateType.Landed then
					canJump = self.MAXJUMP
				end
			end)
		end

		self.localConnections["character"] = player.CharacterAdded:Connect(BindDoubleJump)
		if player.Character then BindDoubleJump(player.Character) end
	end

	function self:onDestroyClient()
		self:disconnectClient()
	end

	return self
end

return DoubleJump
