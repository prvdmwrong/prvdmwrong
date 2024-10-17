local fs = require("@lune/fs")
local moonwave = require("./moonwave")
local packages = require("../packages")
local path = require("../_utils/path")
local process = require("@lune/process")
local templates = require("./templates")

type BrokenLuau = never

local API_REFERENCE = path(process.cwd, "docs", "api-reference")

local function isRootClass(moonwaveClass: moonwave.MoonwaveClass): boolean
	return moonwaveClass.tags ~= nil and table.find(moonwaveClass.tags, "prvdmwrong-root-class") ~= nil
end

local function cleanNewlines(str: string)
	return (str:gsub("\n", " "))
end

local function wordOf(str: string)
	return assert(str:match("%w+"), "No word found for " .. str)
end

local function writePages(pages: { [string]: string }, dir: string): { string }
	if not fs.isDir(dir) :: BrokenLuau then
		fs.writeDir(dir)
	end

	local pathsWritten = {}
	for name, contents in pages do
		local pagePath = path(dir, name) .. ".md"
		print("Writing file", pagePath)
		table.insert(pathsWritten, pagePath)
		-- table.insert(generatedPages, pagePath)
		fs.writeFile(pagePath, contents)
	end

	return pathsWritten
end

local function functionSignature(moonwaveFunction: moonwave.MoonwaveFunction)
	local signature = moonwaveFunction.name .. "("

	if next(moonwaveFunction.params) ~= nil then
		local parameters = {}
		for _, functionParameter in moonwaveFunction.params do
			table.insert(parameters, `    {functionParameter.name}: {functionParameter.lua_type}`)
		end
		signature ..= `\n{table.concat(parameters, ", \n")}\n`
	end

	if next(moonwaveFunction.returns) ~= nil then
		local returns = {}
		for _, functionReturn in moonwaveFunction.returns do
			table.insert(returns, functionReturn.lua_type)
		end
		signature ..= `): {cleanNewlines(table.concat(returns, ", "))}`
	else
		signature ..= "): ()"
	end

	return signature
end

local function writeFunction(moonwaveFunction: moonwave.MoonwaveFunction)
	local parameters: { string } = {}
	local returns: { string } = {}

	for _, functionParameter in moonwaveFunction.params do
		local formattedParameter = templates
			.get("function-param")
			:gsub("$name", functionParameter.name)
			:gsub("$description", functionParameter.desc)
			:gsub("$lua_type", functionParameter.lua_type)

		table.insert(parameters, formattedParameter)
	end

	for _, functionReturn in moonwaveFunction.returns do
		local formattedReturn = templates
			.get("function-return")
			:gsub("$description", functionReturn.desc)
			:gsub("$lua_type", functionReturn.lua_type)

		table.insert(returns, formattedReturn)
	end

	local formattedFunction = templates
		.get("function")
		:gsub("$name", moonwaveFunction.name)
		:gsub("$signature", functionSignature(moonwaveFunction))
		:gsub("$description", moonwaveFunction.desc)

	if #parameters > 0 then
		formattedFunction ..= "\n## Parameters\n\n"
		formattedFunction ..= table.concat(parameters)
	end

	if #parameters > 0 then
		formattedFunction ..= "\n## Returns\n\n"
		formattedFunction ..= table.concat(returns)
	end

	return formattedFunction
end

for _, package in packages do
	local classes = moonwave.extract(package.absolutePath)

	for _, class in classes do
		local isRoot = isRootClass(class)

		local classItems = {}
		local itemNames = {}

		local documentationPath = path(API_REFERENCE, package.packageName)
		if not fs.isDir(documentationPath) :: BrokenLuau then
			fs.writeDir(documentationPath)
		end
		if not isRoot then
			documentationPath = path(documentationPath, wordOf(class.name):lower())
		end

		local functionPages = {}
		if next(class.functions) ~= nil then
			local documentationFunctions = path(documentationPath, "functions")
			fs.writeDir(documentationFunctions)
			for _, func in class.functions do
				functionPages[wordOf(func.name):lower()] = writeFunction(func)
				table.insert(itemNames, func.name)

				local description = func.desc
				if description == "" then
					description = "<i>No description provided.</i>"
				end

				classItems[func.name] = templates
					.get("package-class-item")
					:gsub("$kind_title", "Function")
					:gsub("$kind_symbol", "f")
					:gsub("$kind", "function")
					:gsub("$class", wordOf(class.name):lower())
					:gsub("$identifier", wordOf(func.name):lower())
					:gsub("$name", func.name)
					:gsub("$description", description)
			end
		end

		writePages(functionPages, path(documentationPath, "functions"))

		local classItemSections = {}

		table.sort(itemNames)
		for _, item in itemNames do
			table.insert(classItemSections, classItems[item])
		end

		local classIndex = templates
			.get("class")
			:gsub("$name", class.name)
			:gsub("$description", class.desc)
			:gsub("$class_items", table.concat(classItemSections))

		writePages({ index = classIndex }, documentationPath)
	end
end
