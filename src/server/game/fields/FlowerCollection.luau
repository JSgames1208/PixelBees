--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)

local FlowerCollection = {}
FlowerCollection.__index = FlowerCollection

type FlowerCollection = Types.FlowerCollection & typeof(setmetatable({}, FlowerCollection))

local _instance: FlowerCollection?

function FlowerCollection.new(): FlowerCollection
	if _instance then
		return _instance
	end

	local self = setmetatable({}, FlowerCollection) :: FlowerCollection

	_instance = self
	return self
end

function FlowerCollection.getInstance(): FlowerCollection
	return _instance or FlowerCollection.new()
end

function FlowerCollection.start(self: FlowerCollection): FlowerCollection
	-- Initialize flower collection logic here

	return self
end

function FlowerCollection.getTouchingParts(part: BasePart): { BasePart }
	local connection = part.Touched:Connect(function() end)
	local results = part:GetTouchingParts()
	connection:Disconnect()
	return results
end

return FlowerCollection
