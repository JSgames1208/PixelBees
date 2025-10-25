local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = {}
PlayerService.__index = PlayerService

export type PlayerService = {
	-- Define properties and methods of PlayerService here
	fieldService: typeof(require(ServerScriptService.Server.game.fields.FieldService).getInstance())?,
	toolService: typeof(require(ServerScriptService.Server.game.tool.ToolService).getInstance())?,

	new: () -> PlayerService,
	start: (self: PlayerService) -> PlayerService,
	getInstance: () -> PlayerService,
	onPlayerAdded: (self: PlayerService, player: Player) -> (),
	onPlayerRemoving: (self: PlayerService, player: Player) -> (),
} & typeof(setmetatable({}, PlayerService))

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

function PlayerService.onPlayerAdded(self: PlayerService, player: Player): ()
	-- Handle player added logic
	self.toolService:onPlayerAdded(player)
	self.toolService:equip(player, "BasicTool")
end

function PlayerService.onPlayerRemoving(self: PlayerService, player: Player): ()
	-- Handle player removing logic
end

return PlayerService
