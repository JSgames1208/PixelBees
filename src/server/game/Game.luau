--!strict
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServiceRegistry = require(ServerScriptService.Server.game.util.ServiceRegistry)

local FieldService = ServiceRegistry.FieldService
local ToolService = ServiceRegistry.ToolService
local PlayerService = ServiceRegistry.PlayerService

local Game = {}
Game.__index = Game

export type Game = {
	-- Define properties and methods of Game here
	fieldService: typeof(FieldService),
	toolService: typeof(ToolService),
	playerService: typeof(PlayerService),

	new: () -> Game,
	startServices: (self: Game) -> (),
	start: (self: Game) -> Game,
	run: (self: Game) -> Game,
	update: (self: Game, dt: number) -> (),
} & typeof(setmetatable({}, Game))

local _instance: Game?

function Game.new(): Game
	if _instance then
		return _instance
	end

	local self = setmetatable({}, Game) :: Game

	_instance = self
	return self
end

function Game.startServices(self: Game): ()
	self.fieldService = FieldService:start()
	self.toolService = ToolService:start()
	self.playerService = PlayerService:start()

	self.playerService.fieldService = self.fieldService
	self.playerService.toolService = self.toolService
end

function Game.start(self: Game): Game
	self:startServices()

	return self
end

function Game.run(self: Game): Game
	RunService.Heartbeat:Connect(function(dt)
		self:update(dt)
	end)

	return self
end

function Game.update(self: Game, dt: number): ()
	self.fieldService:update(dt)
end

function Game.getInstance(): Game
	return _instance or Game.new()
end

return Game
