local fs = require("@lune/fs")
local h = require("./h")
local path = require("@lune-lib/utils/path")
local process = require("@lune/process")
local siteUrls = require("@sitegen/config/site-urls")
local sitemap = require("@sitegen/config/sitemap")

local rootPath = process.args[1]

pcall(fs.removeDir, "site")
fs.copy(path(rootPath, "static"), siteUrls.base)

for _, location in sitemap do
	local locationPath = location.path:gsub("^/", ""):gsub("/$", ""):split("/")
	local parentPath = table.clone(locationPath)
	parentPath[#parentPath] = nil

	local dirPath = path(siteUrls.base, table.unpack(locationPath))
	local filePath = path(dirPath, "index.html")

	print("Rendering page", filePath)
	local rendered = h.flatten(location.render(location.props))

	pcall(fs.writeDir, dirPath)
	fs.writeFile(filePath, rendered)
end
