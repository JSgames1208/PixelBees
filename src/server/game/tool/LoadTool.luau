--!strict

local ToolsFolder: Folder = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Tools")

local function LoadTool(toolName: string): Tool
	local tool: Tool = ToolsFolder:WaitForChild(toolName) :: Tool
	if not tool then
		warn("Tool not found:", toolName)
	end
	return tool:Clone()
end

return LoadTool
