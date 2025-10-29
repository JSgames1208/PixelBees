--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerStats = require(ServerScriptService.Server.game.player.PlayerStats)
local Types = require(ReplicatedStorage.Shared.util.Types)

local PlayerData = {}
PlayerData.__index = PlayerData

type PlayerData = Types.PlayerData & typeof(setmetatable({}, PlayerData))

type PlayerStats = Types.PlayerStats
type PlayerTool = Types.PlayerTool
type PlayerService = Types.PlayerService

local playerService: PlayerService?

function PlayerData.new(): PlayerData
	local self = setmetatable({}, PlayerData) :: PlayerData
	self.stats = PlayerStats.new()
	return self
end

function PlayerData.setPlayerService(playerService: PlayerService)
	playerService = playerService
	PlayerStats.setPlayerService(playerService)
end

function PlayerData.default(): PlayerData
	local data = PlayerData.new()

	return data
end

function PlayerData.from(raw: any): PlayerData
	-- Re-wrap the stats and other nested objects
	raw.stats = PlayerStats.from(raw.stats)
	return setmetatable(raw, PlayerData)
end

function PlayerData.getStats(self: PlayerData): PlayerStats
	return self.stats
end

function PlayerData.getTool(self: PlayerData): PlayerTool
	return self.tool
end

return PlayerData
