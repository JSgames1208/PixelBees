--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Bee = require(ServerScriptService.Server.game.swarm.Bee)
local Types = require(ReplicatedStorage.Shared.util.Types)

local Swarm = {}
Swarm.__index = Swarm

type Swarm = Types.Swarm & typeof(setmetatable({}, Swarm))

type Bee = Types.Bee

function Swarm.new(player: Player): Swarm
	local self = setmetatable({}, Swarm) :: Swarm
	self.player = player
	self.bees = {}
	return self
end

function Swarm.addBee(self: Swarm, beeType: string): ()
	local bee = Bee.new(self.player, beeType, self:size() + 1)
	self.bees[bee:getId()] = bee
end

function Swarm.size(self: Swarm): number
	-- Return the size of the swarm
	local i = 0
	for _, _ in self.bees do
		i += 1
	end
	return i
end

function Swarm.removeBee(self: Swarm, bee: Bee): ()
	self.bees[bee.id] = nil
end

function Swarm.update(self: Swarm, dt: number): ()
	for _, bee in self.bees do
		bee:update(dt)
	end
end

function Swarm.destroy(self: Swarm): ()
	for _, bee in self.bees do
		bee:destroy()
	end
end

return Swarm
