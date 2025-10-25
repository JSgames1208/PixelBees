--!strict

local FieldData = {}
FieldData.__index = FieldData

export type FieldData = {
	-- Define properties of FieldData here
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,

	new: (id: string, name: string, size: Vector2, position: Vector3) -> FieldData,
} & typeof(setmetatable({}, FieldData))

function FieldData.new(id: string, name: string, size: Vector2, position: Vector3): FieldData
	local self = setmetatable({}, FieldData) :: FieldData
	self.id = id
	self.name = name
	self.size = size
	self.position = position
	return self
end

function FieldData.fromTemplate(part: Part): FieldData
	return FieldData.new(part.Name, part.Name, Vector2.new(part.Size.X, part.Size.Z), part.Position)
end

return FieldData
