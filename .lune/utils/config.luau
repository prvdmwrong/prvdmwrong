--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local assertion = require("./assertion")

export type Config = {
	config: {
		name: string,
		display: string,
		description: string,
		dependencies: { string }?,
	},
}

local config = {}

function config.intoConfig(toml: any): Config
	assertion(typeof(toml) == "table", "Cannot parse config.toml")
	assertion(typeof(toml.config) == "table", "Expected [config] table")
	assertion(typeof(toml.name) == "string", "Expected config.name field")
	assertion(typeof(toml.display) == "string", "Expected config.display field")
	assertion(typeof(toml.description) == "string", "Expected config.description field")
	assertion(toml.dependencies == nil or typeof(toml.dependencies) == "string", "Expected config.dependencies field")
	return toml
end

return config
