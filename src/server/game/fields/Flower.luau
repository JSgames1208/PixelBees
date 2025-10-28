--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)
local Flower = {}
Flower.__index = Flower

type Flower = Types.Flower & typeof(setmetatable({}, Flower))

function Flower.new(color: string, size: any): Flower
	local self = setmetatable({}, Flower) :: Flower
	self.color = color
	self.size = size
	self.harvested = 0
	return self
end

function Flower.harvest(self: Flower, amount): ()
	local harvested = math.min(self.harvested + amount, 4)
	if self.harvested == harvested then
		return false
	end
	self.harvested = harvested
	return true
end

function Flower.replenish(self: Flower, amount): ()
	self.harvested = math.max(self.harvested - amount, 0)
end

return Flower
