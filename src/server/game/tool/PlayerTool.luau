--!strict

local PlayerTool = {}
PlayerTool.__index = PlayerTool

export type PlayerTool = {
	-- Define properties and methods of PlayerTool here
	player: Player,
	tool: Tool?,
	lastUsed: number?,
	useConnection: any,

	new: (tool: Tool) -> PlayerTool,
} & typeof(setmetatable({}, PlayerTool))

function PlayerTool.new(player: Player, tool: Tool?): PlayerTool
	local self = setmetatable({}, PlayerTool) :: PlayerTool
	self.player = player
	self.tool = tool
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
end

function PlayerTool.isEquipped(self: PlayerTool): boolean
	return self.tool ~= nil
end

function PlayerTool.equip(self: PlayerTool, tool: Tool): ()
	if self:isEquipped() then
		self:destroy()
	end

	self.tool = tool

	local char: Model = self.player.Character :: Model or self.player.CharacterAdded:Wait()
	if not char then
		error("Player character not found")
	end

	local hum: Humanoid = char:FindFirstChild("Humanoid") :: Humanoid
	if not hum then
		error("Humanoid not found in player character")
	end

	hum:EquipTool(tool)

	self.useConnection = tool.Activated:Connect(function()
		self:use()
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

			self.useConnection:Disconnect()
		end
	end
end

function PlayerTool.use(self: PlayerTool): ()
	-- Implement tool usage logic here
	self.lastUsed = os.time()

	print("TOOL USED!")
end

return PlayerTool
