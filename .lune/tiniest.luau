local fs = require("@lune/fs")
local tiniest = require("@lune-lib/tiniest/tiniest_for_lune").configure({})

local tests = tiniest.collect_tests(function()
	local function visitDir(path: string, luauPath: string)
		for _, entry in fs.readDir(path) do
			local fullPath = path .. "/" .. entry
			local fullLuauPath = luauPath .. "/" .. entry
			if fs.isDir(fullPath) then
				visitDir(fullPath, fullLuauPath)
			elseif fs.isFile(fullPath) and fullPath:match("%.spec.luau$") ~= nil then
				(require)(fullLuauPath)(tiniest)
			end
		end
	end

	for _, package in fs.readDir("packages") do
		tiniest.describe(package, function()
			visitDir("packages/" .. package, "../packages/" .. package)
		end)
	end
end)

tiniest.run_tests(tests, {})
-- print(tiniest.format_run())
