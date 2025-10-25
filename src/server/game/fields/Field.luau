local ServerScriptService = game:GetService("ServerScriptService")
local FieldData = require(ServerScriptService.Server.game.fields.FieldData)
local Field = {}
Field.__index = Field

export type Field = {
	-- Define properties and methods of Field here
	data: FieldData.FieldData,

	model: Model?,

	new: (id: string, data: any) -> Field,
	setModel: (self: Field, model: Model) -> (),
} & typeof(setmetatable({}, Field))

function Field.new(data: FieldData.FieldData): Field
	local self = setmetatable({}, Field) :: Field
	self.data = data
	return self
end

function Field.setModel(self: Field, model: Model): ()
	self.model = model
end

return Field
