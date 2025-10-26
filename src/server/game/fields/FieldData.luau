--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FlowerChance = require(ServerScriptService.Server.game.fields.FlowerChance)

local FieldData = {}
FieldData.__index = FieldData

type FieldData = Types.FieldData & typeof(setmetatable({}, FieldData))

type FlowerChance = Types.FlowerChance

function FieldData.new(
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,
	flowerChance: FlowerChance
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
