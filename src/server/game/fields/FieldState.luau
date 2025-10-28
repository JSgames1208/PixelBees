--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)

local FieldState = {}
FieldState.__index = FieldState

type FieldState = Types.FieldState & typeof(setmetatable({}, FieldState))

type Flower = Types.Flower

function FieldState.new(): FieldState
	local self = setmetatable({}, FieldState) :: FieldState

	self.flowers = {}

	return self
end

function FieldState.populate(self: FieldState, flowers: { [string]: Flower }): ()
	self.flowers = flowers
end

function FieldState.getCount(self: FieldState): number
	local count = 0
	for _, _ in pairs(self.flowers) do
		count += 1
	end
	return count
end

function FieldState.getFlowerStateAt(self: FieldState, x: number, y: number): (string, string)
	local key = tostring(x) .. "_" .. tostring(y)
	local flower = self.flowers[key]
	if flower then
		return flower.color, flower.size
	else
		return "Blue", "Small"
	end
end

return FieldState
