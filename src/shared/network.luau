local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bytenet = require(ReplicatedStorage.Packages.Bytenet)

local network = Bytenet.defineNamespace("Network", function()
	-- Define remote events here

	return {
		ToolUsed = Bytenet.definePacket({
			value = Bytenet.nothing,
			reliabilityType = "reliable",
		}),
	}
end)

return network
