--!strict
local ServerScriptService = game:GetService("ServerScriptService")

local FieldService = require(ServerScriptService.Server.game.fields.FieldService)
local ToolService = require(ServerScriptService.Server.game.tool.ToolService)
local PlayerService = require(ServerScriptService.Server.game.player.PlayerService)

export type Services = {
	FieldService: typeof(FieldService.getInstance()),
	ToolService: typeof(ToolService.getInstance()),
	PlayerService: typeof(PlayerService.getInstance()),
}

-- Centralized registry with type-safe references
local ServiceRegistry: Services = {
	FieldService = FieldService.getInstance(),
	ToolService = ToolService.getInstance(),
	PlayerService = PlayerService.getInstance(),
}

return ServiceRegistry
