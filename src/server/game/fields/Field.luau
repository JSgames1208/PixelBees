local ServerScriptService = game:GetService("ServerScriptService")
local FieldData = require(ServerScriptService.Server.game.fields.FieldData)
local FieldState = require(ServerScriptService.Server.game.fields.FieldState)
local Field = {}
Field.__index = Field

export type Field = {
	-- Define properties and methods of Field here
	data: FieldData.FieldData,
	state: FieldState.FieldState,

	model: Model?,

	new: (id: string, data: any) -> Field,
	setModel: (self: Field, model: Model) -> (),
} & typeof(setmetatable({}, Field))

function Field.new(data: FieldData.FieldData): Field
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

return Field
