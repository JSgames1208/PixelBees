--!strict
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local FieldService = require(ServerScriptService.Server.game.fields.FieldService)

local Game = {}
Game.__index = Game

export type Game = {
	-- Define properties and methods of Game here
	fieldService: FieldService.FieldService,

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
	self.fieldService = FieldService.getInstance():start()
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
