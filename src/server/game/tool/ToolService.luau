--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local LoadTool = require(ServerScriptService.Server.game.tool.LoadTool)
local PlayerTool = require(ServerScriptService.Server.game.tool.PlayerTool)

local ToolService = {}
ToolService.__index = ToolService

type ToolService = Types.ToolService & typeof(setmetatable({}, ToolService))

type FieldService = Types.FieldService
type PlayerTool = Types.PlayerTool

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

function ToolService.getPlayerTool(self: ToolService, player: Player): PlayerTool
	return self.playerTools[player.UserId]
end

function ToolService.onPlayerAdded(self: ToolService, player: Player): ()
	-- Handle player added logic for tools
	self.playerTools[player.UserId] = PlayerTool.new(player, nil)
	self.playerTools[player.UserId].fieldService = self.fieldService
	self.playerTools[player.UserId].playerService = self.playerService
end

function ToolService.onPlayerRemoving(self: ToolService, player: Player): ()
	-- Handle player removing logic for tools
	self.playerTools[player.UserId]:destroy()
	self.playerTools[player.UserId] = nil
end

function ToolService.equip(self: ToolService, player: Player, toolId: string): ()
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
		self.playerTools[playerId].fieldService = self.fieldService
		self.playerTools[playerId].playerService = self.playerService
	end
end

return ToolService
