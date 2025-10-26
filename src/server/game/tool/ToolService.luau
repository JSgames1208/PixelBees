--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local LoadTool = require(ServerScriptService.Server.game.tool.LoadTool)
local PlayerTool = require(ServerScriptService.Server.game.tool.PlayerTool)

local ToolService = {}
ToolService.__index = ToolService

type FieldService = Types.FieldService

type ToolService = Types.ToolService & typeof(setmetatable({}, ToolService))

local _instance: ToolService?

function ToolService.new(): ToolService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, ToolService) :: ToolService

	_instance = self
	return self
end

function ToolService.getInstance(): ToolService
	return _instance or ToolService.new()
end

function ToolService.start(self: ToolService): ToolService
	self.playerTools = {}
	return self
end

function ToolService.onPlayerAdded(self: ToolService, player: Player): ()
	-- Handle player added logic for tools
	self.playerTools[player.UserId] = PlayerTool.new(player, nil)
	self.playerTools[player.UserId].fieldService = self.fieldService
	self.playerTools[player.UserId].playerService = self.playerService
end

function ToolService.equip(self: ToolService, player: Player, toolId: string): ()
	print("Equipping tool", toolId, "to player", player.Name)
	local playerId = player.UserId
	local playerTool = self.playerTools[playerId]

	toolId = toolId or "BasicTool"
	local tool = LoadTool(toolId)
	if tool then
		tool = tool:Clone() :: Tool
	end

	if playerTool then
		playerTool:equip(tool)
	else
		playerTool = PlayerTool.new(player, tool)
		self.playerTools[playerId] = playerTool
	end
end

return ToolService
