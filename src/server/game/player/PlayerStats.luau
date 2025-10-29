--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerBackpack = require(ServerScriptService.Server.game.player.PlayerBackpack)
local Types = require(ReplicatedStorage.Shared.util.Types)

local PlayerStats = {}
PlayerStats.__index = PlayerStats

type PlayerStats = Types.PlayerStats & typeof(setmetatable({}, PlayerStats))

type PlayerService = Types.PlayerService

local playerService: PlayerService?

function PlayerStats.new(): PlayerStats
	local self = setmetatable({}, PlayerStats) :: PlayerStats
	self.honey = 0
	self.backpack = PlayerBackpack.new()
	return self
end

function PlayerStats.setPlayerService(playerService)
	playerService = playerService
end

function PlayerStats.from(raw: any): PlayerStats
	raw.backpack = PlayerBackpack.from(raw.backpack)
	return setmetatable(raw, PlayerStats)
end

function PlayerStats.setHoney(self: PlayerStats, amount: number): PlayerStats
	self.honey = amount
	return self
end

function PlayerStats.getHoney(self: PlayerStats): number
	return self.honey
end

function PlayerStats.addHoney(self: PlayerStats, amount: number): PlayerStats
	self:setHoney(self:getHoney() + amount)
	return self
end

function PlayerStats.removeHoney(self: PlayerStats, amount: number): PlayerStats
	self:setHoney(math.max(self:getHoney() - amount, 0))
	return self
end

function PlayerStats.setPollen(self: PlayerStats, amount: number): PlayerStats
	self.backpack:setPollen(amount)
	return self
end

function PlayerStats.getPollen(self: PlayerStats): number
	return self.backpack:getPollen()
end

function PlayerStats.addPollen(self: PlayerStats, amount: number): PlayerStats
	self.backpack:addPollen(amount)
	return self
end

function PlayerStats.removePollen(self: PlayerStats, amount: number): PlayerStats
	self.backpack:removePollen(amount)
	return self
end

return PlayerStats
