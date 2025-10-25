local Flower = {}
Flower.__index = Flower

export type Flower = {
	-- Define properties and methods of Flower here
	color: string,
	size: string,

	new: (id: string, data: any) -> Flower,
} & typeof(setmetatable({}, Flower))

function Flower.new(color: string, size: any): Flower
	local self = setmetatable({}, Flower) :: Flower
	self.color = color
	self.size = size
	return self
end

return Flower
