--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)
local PlayerBackpack = {}
PlayerBackpack.__index = PlayerBackpack

type PlayerBackpack = Types.PlayerBackpack & typeof(setmetatable({}, PlayerBackpack))

function PlayerBackpack.new(): PlayerBackpack
	local self = setmetatable({}, PlayerBackpack) :: PlayerBackpack
	self.pollen = 0
	return self
end

function PlayerBackpack.from(raw: any): PlayerBackpack
	return setmetatable(raw, PlayerBackpack)
end

function PlayerBackpack.getPollen(self: PlayerBackpack): number
	return self.pollen
end

function PlayerBackpack.setPollen(self: PlayerBackpack, amount: number): ()
	self.pollen = amount
end

function PlayerBackpack.addPollen(self: PlayerBackpack, amount: number): ()
	self:setPollen(math.min(self:getPollen() + amount, math.max(self:getPollen(), self:getSize())))
end

function PlayerBackpack.removePollen(self: PlayerBackpack, amount: number): ()
	self:setPollen(math.max(self:getPollen() - amount, 0))
end

function PlayerBackpack.getSize(self: PlayerBackpack): number
	return 10
end

return PlayerBackpack
