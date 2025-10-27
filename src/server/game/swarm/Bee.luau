--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BeeAI = require(ServerScriptService.Server.game.swarm.BeeAI)
local LoadBeeModel = require(ServerScriptService.Server.game.swarm.LoadBeeModel)
local Types = require(ReplicatedStorage.Shared.util.Types)

local Bee = {}
Bee.__index = Bee

type Bee = Types.Bee & typeof(setmetatable({}, Bee))

function Bee.new(player: Player, beeType: string, index: number): Bee
	local self = setmetatable({}, Bee) :: Bee
	self.player = player
	self.type = beeType
	self.index = index

	self.id = self:generateId()
	self.model = self:loadModel()

	self.ai = BeeAI.new(self)

	return self
end

function Bee.loadModel(self: Bee): Model
	-- Load bee model

	local model = LoadBeeModel(self.type)
	model = model:Clone()
	model.Name = self:getId()
	model.Parent = self:getFolder()
	return model
end

function Bee.getFolder(self: Bee): ()
	local folder = workspace:FindFirstChild("BeeFolders"):FindFirstChild(tostring(self.player.UserId))
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = tostring(self.player.UserId)
		folder.Parent = workspace:FindFirstChild("BeeFolders")
	end
	return folder
end

function Bee.update(self: Bee, dt: number)
	self.ai:step(dt)
end

function Bee.generateId(self: Bee): string
	-- Generate a unique ID for the bee
	return `{self.player.UserId}-{self.index}`
end

function Bee.getId(self: Bee): string
	if self.id then
		return self.id
	else
		local id: string = self:generateId()
		self.id = id
		return id
	end
end

function Bee.destroy(self: Bee)
	if self.model then
		self.model:Destroy()
	end
end

return Bee
