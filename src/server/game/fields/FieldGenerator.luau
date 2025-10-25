local ServerScriptService = game:GetService("ServerScriptService")
local Field = require(ServerScriptService.Server.game.fields.Field)
local FieldData = require(ServerScriptService.Server.game.fields.FieldData)

local FieldGenerator = {}
FieldGenerator.__index = FieldGenerator

export type FieldGenerator = {
	-- Define properties and methods of FieldGenerator here
	new: () -> FieldGenerator,
	getInstance: () -> FieldGenerator,

	generateField: (fieldData: FieldData.FieldData) -> Field.Field,
	generateFields: () -> { [string]: Field.Field },
	generateModel: (Field: Field.Field) -> Model,
} & typeof(setmetatable({}, FieldGenerator))

local _instance: FieldGenerator?

function FieldGenerator.new(): FieldGenerator
	if _instance then
		return _instance
	end

	local self = setmetatable({}, FieldGenerator) :: FieldGenerator

	_instance = self
	return self
end

function FieldGenerator.getInstance(): FieldGenerator
	return _instance or FieldGenerator.new()
end

function FieldGenerator.generateField(fieldData: FieldData.FieldData): Field.Field
	local field = Field.new(fieldData)
	return field
end

function FieldGenerator.generateFields(): { [string]: Field.Field }
	local fields: { [string]: Field.Field } = {}
	for _, fieldTemplate: Part in workspace.FieldTemplates:GetChildren() do
		local field = FieldGenerator.generateField(FieldData.fromTemplate(fieldTemplate))
		fields[field.data.id] = field

		fieldTemplate.Transparency = 1
	end
	return fields
end

function FieldGenerator.generateModel(Field: Field.Field): Model
	local model = Instance.new("Model")
	model.Name = Field.data.name

	for i = 2, Field.data.size.X - 2, 4 do
		for j = 2, Field.data.size.Y - 2, 4 do
			local part = Instance.new("Part")
			part.Size = Vector3.new(4, 2, 4)
			part.Material = Enum.Material.SmoothPlastic
			part.BrickColor = BrickColor.new("Bright green")
			part.CanCollide = false
			part.Position = Vector3.new(
				Field.data.position.X - Field.data.size.X / 2 + i,
				Field.data.position.Y + 1,
				Field.data.position.Z - Field.data.size.Y / 2 + j
			)
			part.Anchored = true
			part.Parent = model
		end
	end

	return model
end

return FieldGenerator
