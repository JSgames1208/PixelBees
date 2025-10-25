local StarterGui = game:GetService("StarterGui")
local UI = {}
UI.__index = UI

export type UI = {
	-- Define properties and methods of UI here
	new: () -> UI,
} & typeof(setmetatable({}, UI))

function UI.new(): UI
	local self = setmetatable({}, UI) :: UI
	-- Initialize UI properties here
	return self
end

function UI.init(self: UI): ()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	-- Initialize UI elements here
end

return UI
