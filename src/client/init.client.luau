--!strict

local StarterPlayer = game:GetService("StarterPlayer")
local ClientGame = require(StarterPlayer.StarterPlayerScripts.Client.ClientGame)

local function initClient(): ()
	ClientGame.getInstance():start()
end

initClient()
