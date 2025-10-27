--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeeFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Bees")

return function(name: string): Model
	if BeeFolder:FindFirstChild(name) then
		return BeeFolder[name]
	else
		error("Bee model: " .. name .. " not found")
	end
end
