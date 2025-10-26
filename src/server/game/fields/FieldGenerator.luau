--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Chance = require(ReplicatedStorage.Shared.util.Chance)
local Types = require(ReplicatedStorage.Shared.util.Types)
local Field = require(ServerScriptService.Server.game.fields.Field)
local FieldData = require(ServerScriptService.Server.game.fields.FieldData)
local Flower = require(ServerScriptService.Server.game.fields.Flower)
local LoadFlowerPart = require(ServerScriptService.Server.game.fields.LoadFlowerPart)

local FieldGenerator = {}
FieldGenerator.__index = FieldGenerator

type FieldGenerator = Types.FieldGenerator & typeof(setmetatable({}, FieldGenerator))

type Flower = Types.Flower
type FieldData = Types.FieldData
type Field = Types.Field

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

function FieldGenerator.generateField(fieldData: FieldData): Field
	local field = Field.new(fieldData)

	local flowers: { [string]: Flower } = {}
	for i = 1, fieldData.size.X / 4 do
		for j = 1, fieldData.size.Y / 4 do
			local color = Chance(fieldData.chance.colors)
			local size = Chance(fieldData.chance.sizes)

			flowers[string.format("%d_%d", i, j)] = Flower.new(color, size)
		end
	end

	field:populate(flowers)

	return field
end

function FieldGenerator.generateFields(): { [string]: Field }
	local fields: { [string]: Field } = {}
	for _, fieldTemplate: Part in workspace.FieldTemplates:GetChildren() do
		local field = FieldGenerator.generateField(FieldData.fromTemplate(fieldTemplate))
		fields[field.data.id] = field

		fieldTemplate.Transparency = 1
	end
	return fields
end

function FieldGenerator.generateModel(field: Field): Model
	local model = Instance.new("Model")
	model.Name = field.data.name

	for i = 1, field.data.size.X / 4 do
		for j = 1, field.data.size.Y / 4 do
			local color: string, size: string = field.state:getFlowerStateAt(i, j)
			local part: Part = LoadFlowerPart(color, size)
			part.Position = Vector3.new(
				field.data.position.X - field.data.size.X / 2 + i * 4 - 2,
				field.data.position.Y + 1,
				field.data.position.Z - field.data.size.Y / 2 + j * 4 - 2
			)
			part.Parent = model
			part.Name = string.format("%d_%d", i, j)
		end
	end

	return model
end

return FieldGenerator
