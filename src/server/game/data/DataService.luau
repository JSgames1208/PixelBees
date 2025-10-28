--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Types = require(ReplicatedStorage.Shared.util.Types)
local PlayerData = require(ServerScriptService.Server.game.data.PlayerData)
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)
local DataService = {}
DataService.__index = DataService

type DataService = Types.DataService & typeof(setmetatable({}, DataService))

type PlayerData = Types.PlayerData

local _instance: DataService?

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData_v1", -- Change this when changing data structure
	PlayerData.default()
)

function DataService.new(): DataService
	if _instance then
		return _instance
	end

	local self = setmetatable({}, DataService) :: DataService

	_instance = self
	return self
end

function DataService.start(self: DataService): DataService
	self.profiles = {}
	return self
end

function DataService.getInstance(): DataService
	return _instance or DataService.new()
end

function DataService.loadPlayerData(self: DataService, player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
	if not profile then
		-- Couldn’t load profile; kick player for safety
		player:Kick("Data failed to load. Please rejoin.")
		return
	end

	profile:Reconcile() -- Ensures missing fields are added
	profile:ListenToRelease(function()
		self.profiles[player.UserId] = nil
		player:Kick("Your data session was closed.")
	end)

	if player:IsDescendantOf(game.Players) == false then
		-- Player left before data loaded
		profile:Release()
		return
	end

	profile.Data = PlayerData.from(profile.Data)

	self.profiles[player.UserId] = profile
	print(`[DataService] Loaded data for {player.Name}`)
end

function DataService.getProfile(self: DataService, player: Player)
	return self.profiles[player.UserId]
end

function DataService.getData(self: DataService, player: Player): PlayerData
	local profile = self:getProfile(player)
	return profile.Data
end

function DataService.onPlayerAdded(self: DataService, player: Player): ()
	task.spawn(function()
		self:loadPlayerData(player)
		print(self:getProfile(player))
	end)
end

return DataService
