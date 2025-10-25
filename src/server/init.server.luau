--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local Game = require(ServerScriptService.Server.game.Game)

local function main(): ()
	Game.getInstance():start():run()
end

main()
