--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local Flower = require(ServerScriptService.Server.game.fields.Flower)

local FieldState = {}
FieldState.__index = FieldState

export type FieldState = {
	-- Define properties and methods of FieldState here
	flowers: { [string]: Flower.Flower },

	new: () -> FieldState,
} & typeof(setmetatable({}, FieldState))

function FieldState.new(): FieldState
	local self = setmetatable({}, FieldState) :: FieldState

	self.flowers = {}

	return self
end

function FieldState.populate(self: FieldState, flowers: { [string]: Flower.Flower }): ()
	self.flowers = flowers
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
