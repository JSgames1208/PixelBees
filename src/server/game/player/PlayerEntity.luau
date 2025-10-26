--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)

local PlayerEntity = {}
PlayerEntity.__index = PlayerEntity

export type PlayerEntity = Types.PlayerEntity & typeof(setmetatable({}, PlayerEntity))

function PlayerEntity.new(player: Player): PlayerEntity
	local self = setmetatable({}, PlayerEntity) :: PlayerEntity
	self.player = player
	self.heartbeatConnection = nil
	return self
end

function PlayerEntity.start(self: PlayerEntity): PlayerEntity
	-- Initialize player entity logic here
	self.character = self.player.Character or self.player.CharacterAdded:Wait()

	self:setCollider()

	return self
end

function PlayerEntity.getPlayer(self: PlayerEntity): Player
	return self.player
end

function PlayerEntity.setCollider(self: PlayerEntity): ()
	-- Implement collider setting logic here

	self.collider = Instance.new("Part")
	self.collider.Size = Vector3.new(2, 15, 2)
	self.collider.Transparency = 1
	self.collider.CanCollide = false
	self.collider.Anchored = true
	self.collider.Parent = self.character
	self.collider.Name = "PlayerCollider"
end

function PlayerEntity.getCollider(self: PlayerEntity): BasePart
	return self.collider
end

function PlayerEntity.updateCollider(self: PlayerEntity): ()
	-- Update collider position to match character
	if self.character and self.collider then
		local hrp: BasePart? = self.character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if hrp then
			self.collider.CFrame = hrp.CFrame * CFrame.fromEulerAngles(0, 0, 0)
		end
	end
end

return PlayerEntity
