--!strict

local function weightedRandom(weights: { [string]: number }): string
	local totalWeight = 0
	for _, weight in weights do
		totalWeight += weight
	end

	local random = math.random() * totalWeight
	local currentWeight = 0

	for key, weight in weights do
		currentWeight += weight
		if random <= currentWeight then
			return key
		end
	end

	-- Fallback (should never happen unless the table is empty)
	return next(weights) or ""
end

return weightedRandom
