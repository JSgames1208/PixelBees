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
	return self
end

return Flower
