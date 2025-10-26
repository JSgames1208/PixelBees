--!strict

-- This module defines tool usage patterns for the game.
-- Each pattern is represented as a list of Vector2 coordinates.

-- Positive X-axis is to the right of the player.
-- Positive Y-axis is to the front of the player.
return {
	["BasicTool"] = {
		Vector2.new(0, 0),
		Vector2.new(0, 1),
		Vector2.new(0, 2),
	},
}
