--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local AnimationIds = require(StarterPlayer.StarterPlayerScripts.Client.player.AnimationIds)
local network = require(ReplicatedStorage.Shared.network)

local ToolClient = {}
ToolClient.__index = ToolClient

export type ToolClient = {
	-- Define properties and methods of ToolClient here
	animationClient: typeof(require(StarterPlayer.StarterPlayerScripts.Client.player.AnimationClient).getInstance()),
	renderSteppedConnection: RBXScriptConnection,

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

	local last = 0
	self.renderSteppedConnection = RunService.RenderStepped:Connect(function(dt: number)
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			if os.time() - last > 0.15 then
				last = os.time()
				network.ToolUsed.send(nil, Players.LocalPlayer)
			end
		end
	end)

	return self
end

return ToolClient
