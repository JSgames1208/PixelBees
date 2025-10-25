--!strict
local Workspace = game:GetService("Workspace")

local cache: { [string]: Part } = {}

local function FlowerLoader(color: string, size: string): Part
	if cache[color .. size] then
		return cache[color .. size]:Clone()
	end

	local flowerPart: Part = Workspace.Flowers[color .. size]
	cache[color .. size] = flowerPart
	return flowerPart:Clone()
end

return FlowerLoader
