--!strict

local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local UI = require(StarterGui.UI.UI)
local AnimationClient = require(StarterPlayer.StarterPlayerScripts.Client.player.AnimationClient)
local ToolClient = require(StarterPlayer.StarterPlayerScripts.Client.tool.ToolClient)
local ClientGame = {}
ClientGame.__index = ClientGame

export type ClientGame = {
	-- Define properties and methods of ClientGame here
	UI: UI.UI,
	toolClient: ToolClient.ToolClient,
	animationClient: AnimationClient.AnimationClient,

	new: () -> ClientGame,
	getInstance: () -> ClientGame,
	startServices: (self: ClientGame) -> (),
	start: (self: ClientGame) -> ClientGame,
} & typeof(setmetatable({}, ClientGame))

local _instance: ClientGame?

function ClientGame.new(): ClientGame
	if _instance then
		return _instance
	end

	local self = setmetatable({}, ClientGame) :: ClientGame
	self.UI = UI.new()

	_instance = self
	return self
end

function ClientGame.getInstance(): ClientGame
	return _instance or ClientGame.new()
end

function ClientGame.startServices(self: ClientGame): ()
	-- Initialize client-side services here

	self.toolClient:start()
	self.toolClient.animationClient = self.animationClient

	self.animationClient:start()
end

function ClientGame.start(self: ClientGame): ClientGame
	-- Initialize client-side game logic here
	self.toolClient = ToolClient.getInstance()
	self.animationClient = AnimationClient.getInstance()
	self.UI:init()

	self:startServices()

	return self
end

return ClientGame
