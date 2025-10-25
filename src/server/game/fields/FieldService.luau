--!strict
local ServerScriptService = game:GetService("ServerScriptService")
local FieldGenerator = require(ServerScriptService.Server.game.fields.FieldGenerator)

local FieldService = {}
FieldService.__index = FieldService

export type FieldService = {
	-- Define properties and methods of FieldService here
	fields: { [string]: any },
	generator: FieldGenerator.FieldGenerator,

	new: () -> FieldService,
	getInstance: () -> FieldService,
	start: (self: FieldService) -> FieldService,
	update: (self: FieldService, dt: number) -> (),
	getField: (self: FieldService, fieldId: string) -> any,
	setField: (self: FieldService, fieldId: string, fieldData: any) -> (),
} & typeof(setmetatable({}, FieldService))

local _instance: FieldService?

function FieldService.new(): FieldService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, FieldService) :: FieldService
	self.fields = {}
	self.generator = FieldGenerator.getInstance()

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

return FieldService
