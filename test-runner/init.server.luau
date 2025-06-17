local TestEZ = require("@self/roblox_packages/testez")

local tests = {}

local function collectTestFiles(parent: Instance)
	for _, module in parent:GetDescendants() do
		if module.Name:match("%.spec$") and module:IsA("ModuleScript") then
			print("Collected test file:", module:GetFullName())
			table.insert(tests, module)
		end
	end
end

local robloxPackages = script:WaitForChild("roblox_packages")
collectTestFiles(robloxPackages)

print("Running unit tests...")
do
	(TestEZ.TestBootstrap :: any):run(tests)
end
