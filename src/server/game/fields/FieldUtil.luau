--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FieldUtil = {}

type Field = Types.Field

function FieldUtil.getPosInField(position: Vector3, field: Field): Vector2
	local relativePos = position
		- (field.data.position - Vector3.new(field.data.size.X / 2 - 2, 0, field.data.size.Y / 2 - 2))
	local coordX = math.clamp(math.round(relativePos.X / 4) + 1, 0, field.data.size.X / 4)
	local coordY = math.clamp(math.round(relativePos.Z / 4) + 1, 0, field.data.size.Y / 4)
	return Vector2.new(coordX, coordY)
end

return FieldUtil
