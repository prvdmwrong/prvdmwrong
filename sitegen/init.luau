local fs = require("@lune/fs")
local path = require("@lune-lib/utils/path")
local process = require("@lune/process")
local stdio = require("@lune/stdio")
local task = require("@lune/task")

local sitegenRootPath = path(process.cwd, "sitegen")
local sitePath = path(process.cwd, "site")

local function watchPaths()
	local paths = {}

	local function watch(path: string)
		if fs.isDir(path) then
			for _, name in fs.readDir(path) do
				watch(path .. "/" .. name)
			end
		elseif fs.isFile(path) then
			table.insert(paths, path)
		end
	end

	watch(sitegenRootPath)

	return paths
end

local function spawnBuild()
	local result = process.exec("lune", { "run", "sitegen/build", sitegenRootPath })
	stdio.write(result.stdout)
	stdio.write(result.stderr)

	if not result.ok then
		print("Failed to build site")
		process.exit(1)
	end

	return
end

if table.find(process.args, "watch") then
	local lastModifiedAt = {}

	while task.wait(1) do
		local paths = watchPaths()

		local rebuild = false
		for _, watched in paths do
			local meta = fs.metadata(watched)
			if rebuild or lastModifiedAt[watched] ~= meta.modifiedAt then
				lastModifiedAt[watched] = meta.modifiedAt
				rebuild = true
			end
		end

		if rebuild then
			print(string.rep("\n", 80))
			spawnBuild()
		end
	end

	return
end

spawnBuild()
