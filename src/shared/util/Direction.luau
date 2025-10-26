local Direction = {}
Direction.__index = Direction

Directions = {
	Vector2.new(0, 1),
	Vector2.new(1, 0),
	Vector2.new(0, -1),
	Vector2.new(-1, 0),
}

Direction.North = Vector2.new(0, 1)
Direction.East = Vector2.new(1, 0)
Direction.South = Vector2.new(0, -1)
Direction.West = Vector2.new(-1, 0)

function Direction.fromOrientation(orientation: Vector2): Vector2
	--Make this return one of the 4 directions
	local function dotProduct(a, b)
		return a.X * b.X + a.Y * b.Y
	end

	local maxDotProduct = -math.huge
	local bestDirection

	for _, direction in pairs(Directions) do
		local dotProductValue = dotProduct(direction, orientation)
		if dotProductValue > maxDotProduct then
			maxDotProduct = dotProductValue
			bestDirection = direction
		end
	end

	return bestDirection
end

return Direction
