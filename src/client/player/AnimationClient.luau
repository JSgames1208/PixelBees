--!strict

local AnimationClient = {}
AnimationClient.__index = AnimationClient

export type AnimationClient = {
	-- Define properties and methods of AnimationClient here
	player: Player,
	character: Model,
	humanoid: Humanoid,
	animator: Animator,

	new: () -> AnimationClient,
	getInstance: () -> AnimationClient,
} & typeof(setmetatable({}, AnimationClient))

local _instance: AnimationClient?

function AnimationClient.new(): AnimationClient
	if _instance then
		return _instance
	end

	local self = setmetatable({}, AnimationClient) :: AnimationClient
	-- Initialize AnimationClient properties here

	_instance = self
	return self
end

function AnimationClient.getInstance(): AnimationClient
	return _instance or AnimationClient.new()
end

function AnimationClient.start(self: AnimationClient): AnimationClient
	-- Initialize client-side animation logic here
	self.player = game.Players.LocalPlayer
	self.character = self.player.Character or self.player.CharacterAdded:Wait()
	self.humanoid = self.character:WaitForChild("Humanoid") :: Humanoid
	self.animator = self.humanoid:WaitForChild("Animator") :: Animator

	return self
end

function AnimationClient.playAnimation(self: AnimationClient, animationId: string): AnimationTrack
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId
	local animationTrack = self.animator:LoadAnimation(animation)
	animationTrack:Play()
	return animationTrack
end

return AnimationClient
