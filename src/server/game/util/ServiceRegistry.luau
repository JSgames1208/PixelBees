--!strict

local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.game.data.DataService)
local FieldService = require(ServerScriptService.Server.game.fields.FieldService)
local ToolService = require(ServerScriptService.Server.game.tool.ToolService)
local PlayerService = require(ServerScriptService.Server.game.player.PlayerService)
local SwarmService = require(ServerScriptService.Server.game.swarm.SwarmService)

export type Services = {
	FieldService: typeof(FieldService.getInstance()),
	ToolService: typeof(ToolService.getInstance()),
	PlayerService: typeof(PlayerService.getInstance()),
	SwarmService: typeof(SwarmService.getInstance()),
	DataService: typeof(DataService.getInstance()),
}

-- Centralized registry with type-safe references
local ServiceRegistry: Services = {
	FieldService = FieldService.getInstance(),
	ToolService = ToolService.getInstance(),
	PlayerService = PlayerService.getInstance(),
	SwarmService = SwarmService.getInstance(),
	DataService = DataService.getInstance(),
}

return ServiceRegistry
