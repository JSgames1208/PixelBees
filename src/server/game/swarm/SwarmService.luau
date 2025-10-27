--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Swarm = require(ServerScriptService.Server.game.swarm.Swarm)
local Types = require(ReplicatedStorage.Shared.util.Types)

local SwarmService = {}
SwarmService.__index = SwarmService

local _instance: SwarmService?

type SwarmService = Types.SwarmService & typeof(setmetatable({}, SwarmService))

type Swarm = Types.Swarm

function SwarmService.new(): SwarmService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, SwarmService) :: SwarmService

	_instance = self
	return self
end

function SwarmService.getInstance(): SwarmService
	return _instance or SwarmService.new()
end

function SwarmService.start(self: SwarmService): SwarmService
	self.swarms = {}
	return self
end

function SwarmService.update(self: SwarmService, dt: number): ()
	for _, swarm in self.swarms do
		swarm:update(dt)
	end
end

function SwarmService.addSwarm(self: SwarmService, player: Player): Swarm
	self.swarms[player.UserId] = Swarm.new(player)
	return self:getSwarm(player)
end

function SwarmService.removeSwarm(self: SwarmService, player: Player): ()
	self.swarms[player.UserId] = nil
end

function SwarmService.getSwarm(self: SwarmService, player: Player): Swarm
	return self.swarms[player.UserId]
end

function SwarmService.onPlayerAdded(self: SwarmService, player: Player): ()
	local swarm = self:addSwarm(player)

	for i = 1, 100 do
		swarm:addBee("BasicBee")
	end
end

return SwarmService
