--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FieldState = require(ServerScriptService.Server.game.fields.FieldState)

local Field = {}
Field.__index = Field

type Field = Types.Field & typeof(setmetatable({}, Field))

type FieldData = Types.FieldData
type Flower = Types.Flower

function Field.new(data: FieldData): Field
	local self = setmetatable({}, Field) :: Field
	self.data = data
	self.state = FieldState.new()

	self.toReplenish = {}

	return self
end

function Field.replenish(self: Field): ()
	for _, flowerKey in self.toReplenish do
		local flowerState = self.state.flowers[flowerKey]
		flowerState:replenish(1)

		if not self.model then
			return
		end

		local flowerModel: Part = self.model:FindFirstChild(flowerKey) :: Part
		if not flowerModel then
			return
		end

		flowerModel.Position = Vector3.new(
			flowerModel.Position.X,
			self.data.position.Y + 1 - flowerState.harvested * 0.51,
			flowerModel.Position.Z
		)
	end

	for i, flowerKey in self.toReplenish do
		local flowerState = self.state.flowers[flowerKey]
		if flowerState.harvested == 0 then
			self.toReplenish[i] = nil
		end
	end
end

function Field.harvest(self: Field, flowerKey: string, amount: number): ()
	local flowerState = self.state.flowers[flowerKey]

	if not flowerState then
		return
	end
	flowerState:harvest(amount)

	if not table.find(self.toReplenish, flowerKey) then
		self.toReplenish[#self.toReplenish + 1] = flowerKey
	end

	if not self.model then
		return
	end

	local flowerModel: Part = self.model:FindFirstChild(flowerKey) :: Part
	if not flowerModel then
		return
	end

	flowerModel.Position = Vector3.new(
		flowerModel.Position.X,
		self.data.position.Y + 1 - flowerState.harvested * 0.51,
		flowerModel.Position.Z
	)
end

function Field.setModel(self: Field, model: Model): ()
	self.model = model
end

function Field.populate(self: Field, flowers: { [string]: any }): ()
	self.state:populate(flowers)
end

function Field.containsPosition(self: Field, position: Vector3): boolean
	local size = self.data.size
	local fieldPos = self.data.position
	return position.X >= fieldPos.X - size.X / 2
		and position.X <= fieldPos.X + size.X / 2
		and position.Y >= fieldPos.Y + 10
		and position.Y <= fieldPos.Y + 10
		and position.Z >= fieldPos.Z - size.Y / 2
		and position.Z <= fieldPos.Z + size.Y / 2
end

return Field
