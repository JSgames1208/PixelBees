--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local FlowerChance = require(ServerScriptService.Server.game.fields.FlowerChance)

local FieldData = {}
FieldData.__index = FieldData

export type FieldData = {
	-- Define properties of FieldData here
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,
	chance: FlowerChance.FlowerChance,

	new: (id: string, name: string, size: Vector2, position: Vector3) -> FieldData,
} & typeof(setmetatable({}, FieldData))

function FieldData.new(
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,
	flowerChance: FlowerChance.FlowerChance
): FieldData
	local self = setmetatable({}, FieldData) :: FieldData
	self.id = id
	self.name = name
	self.size = size
	self.position = position
	self.chance = flowerChance
	return self
end

function FieldData.fromTemplate(part: Part): FieldData
	return FieldData.new(
		part.Name,
		part.Name,
		Vector2.new(part.Size.X, part.Size.Z),
		part.Position,
		FlowerChance.getChanceFromTemplate(part)
	)
end

return FieldData
