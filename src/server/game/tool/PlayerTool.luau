--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local network = require(ReplicatedStorage.Shared.network)
local Types = require(ReplicatedStorage.Shared.util.Types)

local PlayerTool = {}
PlayerTool.__index = PlayerTool

type PlayerTool = Types.PlayerTool & typeof(setmetatable({}, PlayerTool))

type Field = Types.Field

function PlayerTool.new(player: Player, tool: Tool?): PlayerTool
	local self = setmetatable({}, PlayerTool) :: PlayerTool
	self.player = player

	self.tool = tool
	if self.tool then
		self.toolName = self.tool.Name
	end

	self.cooldown = 0.35
	return self
end

function PlayerTool.setLastUsed(self: PlayerTool, timestamp: number): ()
	self.lastUsed = timestamp
end

function PlayerTool.getLastUsed(self: PlayerTool): number?
	return self.lastUsed
end

function PlayerTool.getTool(self: PlayerTool): Tool
	return self.tool or error("Tool is not equipped")
end

function PlayerTool.setTool(self: PlayerTool, tool: Tool): ()
	self.tool = tool
	self.toolName = tool.Name
end

function PlayerTool.isEquipped(self: PlayerTool): boolean
	return self.tool ~= nil
end

function PlayerTool.equip(self: PlayerTool, tool: Tool): ()
	if self:isEquipped() then
		self:destroy()
	end

	self:setTool(tool)

	local char: Model = self.player.Character :: Model or self.player.CharacterAdded:Wait()
	if not char then
		error("Player character not found")
	end

	local hum: Humanoid = char:FindFirstChild("Humanoid") :: Humanoid
	if not hum then
		error("Humanoid not found in player character")
	end

	hum:EquipTool(tool)

	--[[self.useConnection = tool.Activated:Connect(function()
		self:use()
	end)]]

	self.useConnection = network.ToolUsed.listen(function(data: nil, player: Player?)
		if player == self.player then
			self:use()
		end
	end)
end

function PlayerTool.destroy(self: PlayerTool): ()
	if self:isEquipped() then
		local char: Model = self.player.Character :: Model
		if char then
			local hum: Humanoid? = char:FindFirstChild("Humanoid") :: Humanoid?
			if hum and self.tool then
				hum:UnequipTools()
			end
		end
		if self.tool then
			self.tool:Destroy()
			self.tool = nil
			self.lastUsed = nil

			if self.useConnection then
				self.useConnection:Disconnect()
				self.useConnection = nil
			end
		end
	end
end

function PlayerTool.use(self: PlayerTool): ()
	-- Implement tool usage logic here

	if os.time() - (self.lastUsed or 0) < self.cooldown then
		-- On cooldown
		return
	end

	self.lastUsed = os.time()

	if self.tool then
		self.tool:Activate()
	end

	-- Collect pollen maybe
	self.fieldService:collect(self.player)

	network.ToolUsed.sendTo(nil, self.player)
end

return PlayerTool
