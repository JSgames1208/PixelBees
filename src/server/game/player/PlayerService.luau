--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local PlayerEntity = require(ServerScriptService.Server.game.player.PlayerEntity)
local PlayerService = {}
PlayerService.__index = PlayerService

type FieldService = Types.FieldService
type ToolService = Types.ToolService
type PlayerEntity = Types.PlayerEntity

type PlayerService = Types.PlayerService & typeof(setmetatable({}, PlayerService))

local _instance: PlayerService?

function PlayerService.new(): PlayerService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, PlayerService) :: PlayerService

	_instance = self
	return self
end

function PlayerService.getInstance(): PlayerService
	return _instance or PlayerService.new()
end

function PlayerService.start(self: PlayerService): PlayerService
	self.playerEntities = {}

	Players.PlayerAdded:Connect(function(player: Player)
		self:onPlayerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		self:onPlayerRemoving(player)
	end)

	for _, player in Players:GetPlayers() do
		self:onPlayerAdded(player)
	end

	return self
end

function PlayerService.update(self: PlayerService, dt: number)
	-- Update player service logic

	for _, playerEntity in self.playerEntities do
		-- Update each player entity if needed

		playerEntity:updateCollider()
	end
end

function PlayerService.getPlayerEntity(self: PlayerService, player: Player): PlayerEntity
	return self.playerEntities[player.UserId]
end

function PlayerService.onPlayerAdded(self: PlayerService, player: Player): ()
	-- Handle player added logic
	self.toolService:onPlayerAdded(player)
	self.toolService:equip(player, "BasicTool")

	self.playerEntities[player.UserId] = PlayerEntity.new(player):start()

	self.swarmService:onPlayerAdded(player)
end

function PlayerService.onPlayerRemoving(self: PlayerService, player: Player): ()
	-- Handle player removing logic
end

return PlayerService
