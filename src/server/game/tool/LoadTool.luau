--!strict

local ToolsFolder: Folder = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Tools")

local function LoadTool(toolName: string): Tool
	local tool: Tool = ToolsFolder:WaitForChild(toolName) :: Tool
	if tool then
		print("Loaded tool:", toolName)
	else
		warn("Tool not found:", toolName)
	end
	return tool:Clone()
end

return LoadTool
