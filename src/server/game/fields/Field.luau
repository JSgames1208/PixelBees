local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FieldState = require(ServerScriptService.Server.game.fields.FieldState)

local Field = {}
Field.__index = Field

type Field = Types.Field & typeof(setmetatable({}, Field))

type FieldData = Types.FieldData

function Field.new(data: FieldData): Field
	local self = setmetatable({}, Field) :: Field
	self.data = data
	self.state = FieldState.new()
	return self
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
		and position.Y >= fieldPos.Y - size.Y / 2
		and position.Y <= fieldPos.Y + size.Y / 2 + 10
		and position.Z >= fieldPos.Z - size.Z / 2
		and position.Z <= fieldPos.Z + size.Z / 2
end

return Field
