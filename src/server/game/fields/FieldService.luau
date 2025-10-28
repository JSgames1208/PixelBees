--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Direction = require(ReplicatedStorage.Shared.util.Direction)
local Types = require(ReplicatedStorage.Shared.util.Types)
local FieldGenerator = require(ServerScriptService.Server.game.fields.FieldGenerator)
local FieldUtil = require(ServerScriptService.Server.game.fields.FieldUtil)
local FlowerCollection = require(ServerScriptService.Server.game.fields.FlowerCollection)
local Patterns = require(ServerScriptService.Server.game.tool.Patterns)

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

function FieldService.replenish(self: FieldService): ()
	-- Replenish all fields

	for _, field in self.fields do
		field:replenish()
	end
end

function FieldService.startReplenish(self: FieldService): ()
	-- Start replenish loop

	local lastReplenish = os.clock()

	self.replenishConnection = RunService.Heartbeat:Connect(function(dt)
		if os.clock() - lastReplenish > 5 then
			lastReplenish = os.clock()
			self:replenish()
		end
	end)
end

function FieldService.start(self: FieldService): FieldService
	self:setFields(self.generator.generateFields())

	for _, field in self.fields do
		local model = self.generator.generateModel(field)
		field:setModel(model)
		model.Parent = workspace.Fields
	end

	self:startReplenish()

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

local function rotateVector2(v: Vector2, direction: Vector2): Vector2
	if direction == Direction.North then
		return v -- no rotation
	elseif direction == Direction.East then
		return Vector2.new(v.Y, -v.X)
	elseif direction == Direction.South then
		return Vector2.new(-v.X, -v.Y)
	elseif direction == Direction.West then
		return Vector2.new(-v.Y, v.X)
	else
		return v -- default fallback
	end
end

function FieldService.collect(self: FieldService, player: Player)
	local field: Field = self:getPlayerField(player)
	if field then
		local character = player.Character
		if not character then
			return
		end

		local position =
			FieldUtil.getPosInField(self.playerService:getPlayerEntity(player):getCollider().Position, field)

		local tool = self.toolService:getPlayerTool(player)
		if not tool then
			return
		end

		local hrp: Model = character:FindFirstChild("HumanoidRootPart") :: Model
		if not hrp then
			return
		end
		local lookVector = hrp:GetPivot().LookVector
		local flatOrientation = Vector2.new(lookVector.X, lookVector.Z)

		local pattern: { Vector2 } = Patterns[tool.toolName]

		local flowersToCollect = {}

		for _, pos: Vector2 in pattern do
			--Calculate the positions, using the position variable and the pos variable, along with the direction of the player
			local toCollect = position + rotateVector2(pos, Direction.fromOrientation(flatOrientation))
			table.insert(flowersToCollect, toCollect)
		end

		local playerData = self.playerService:getPlayerData(player)
		local stats = playerData:getStats()

		for _, flowerKey in flowersToCollect do
			local harvested = field:harvest(string.format("%d_%d", flowerKey.X, flowerKey.Y), 1)
			if harvested then
				stats:addPollen(1)
			end
		end
	end
end

return FieldService
