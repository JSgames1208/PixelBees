local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local AnimationIds = require(StarterPlayer.StarterPlayerScripts.Client.player.AnimationIds)
local network = require(ReplicatedStorage.Shared.network)

local ToolClient = {}
ToolClient.__index = ToolClient

export type ToolClient = {
	-- Define properties and methods of ToolClient here
	animationClient: typeof(require(StarterPlayer.StarterPlayerScripts.Client.player.AnimationClient).getInstance()),

	new: () -> ToolClient,
	getInstance: () -> ToolClient,
	start: (self: ToolClient) -> ToolClient,
} & typeof(setmetatable({}, ToolClient))

local _instance: ToolClient?

function ToolClient.new(): ToolClient
	if _instance then
		return _instance
	end

	local self = setmetatable({}, ToolClient) :: ToolClient

	_instance = self
	return self
end

function ToolClient.getInstance(): ToolClient
	return _instance or ToolClient.new()
end

function ToolClient.start(self: ToolClient): ToolClient
	-- Initialize client-side tool logic here

	network.ToolUsed.listen(function()
		self.animationClient:playAnimation(AnimationIds.ToolUsed)
	end)

	return self
end

return ToolClient
