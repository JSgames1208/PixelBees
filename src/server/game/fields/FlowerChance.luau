--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)
local FlowerChance = {}
FlowerChance.__index = FlowerChance

type FlowerChance = Types.FlowerChance & typeof(setmetatable({}, FlowerChance))

function FlowerChance.new(
	Blue: number,
	Red: number,
	White: number,
	Small: number,
	Medium: number,
	Big: number
): FlowerChance
	local self = setmetatable({}, FlowerChance) :: FlowerChance
	self.colors = {
		Blue = Blue,
		Red = Red,
		White = White,
	}
	self.sizes = {
		Small = Small,
		Medium = Medium,
		Big = Big,
	}
	return self
end

function FlowerChance.getChanceFromTemplate(part: Part): FlowerChance
	local blueChance = part:GetAttribute("Blue") :: number or 0
	local redChance = part:GetAttribute("Red") :: number or 0
	local whiteChance = part:GetAttribute("White") :: number or 0
	local smallChance = part:GetAttribute("Small") :: number or 0
	local mediumChance = part:GetAttribute("Medium") :: number or 0
	local bigChance = part:GetAttribute("Big") :: number or 0

	return FlowerChance.new(blueChance, redChance, whiteChance, smallChance, mediumChance, bigChance)
end

return FlowerChance
