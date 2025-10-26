--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FieldGenerator = require(ServerScriptService.Server.game.fields.FieldGenerator)
local FlowerCollection = require(ServerScriptService.Server.game.fields.FlowerCollection)

local FieldService = {}
FieldService.__index = FieldService

type FieldService = Types.FieldService & typeof(setmetatable({}, FieldService))

type Field = Types.Field
type PlayerEntity = Types.PlayerEntity

local _instance: FieldService?

function FieldService.new(): FieldService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, FieldService) :: FieldService
	self.fields = {}
	self.generator = FieldGenerator.getInstance()
	self.flowerCollection = FlowerCollection.getInstance()

	_instance = self
	return self
end

function FieldService.getInstance(): FieldService
	return _instance or FieldService.new()
end

function FieldService.start(self: FieldService): FieldService
	self:setFields(self.generator.generateFields())

	for _, field in self.fields do
		local model = self.generator.generateModel(field)
		field:setModel(model)
		model.Parent = workspace.Fields
	end

	return self
end

function FieldService.update(self: FieldService, dt: number)
	-- Update fields logic
end

function FieldService.getField(self: FieldService, fieldId: string): any
	return self.fields[fieldId]
end

function FieldService.setField(self: FieldService, fieldId: string, fieldData: any): ()
	self.fields[fieldId] = fieldData
end

function FieldService.setFields(self: FieldService, fieldsData: { [string]: any }): ()
	self.fields = fieldsData
end

function FieldService.getPlayerField(self: FieldService, player: Player): any
	local playerEntity: PlayerEntity = self.playerService.playerEntities[player.UserId]

	-- Determine which field the player is in
	for _, field: Field in self.fields do
		local collider: BasePart? = playerEntity:getCollider()
		if not collider then
			continue
		end
		local parts = self.flowerCollection.getInstance().getTouchingParts(collider)
		for _, part in parts do
			if field.model then
				if part:IsDescendantOf(field.model) then
					return field
				end
			end
		end
	end
	return nil
end

return FieldService
