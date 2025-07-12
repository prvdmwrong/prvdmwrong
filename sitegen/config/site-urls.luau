local path = require("@lune-lib/utils/path")
local process = require("@lune/process")

return {
	base = if process.env.IS_CI then "https://prvdmwrong.luau.page/" else path(process.cwd, "site"),
}
