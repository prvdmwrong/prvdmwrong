return {
	["[typescript]"] = {
		["editor.defaultFormatter"] = "esbenp.prettier-vscode",
		["editor.formatOnSave"] = true,
	},
	["[typescriptreact]"] = {
		["editor.defaultFormatter"] = "dbaeumer.vscode-eslint",
		["editor.formatOnSave"] = true,
	},
	["eslint.format.enable"] = true,
	["eslint.run"] = "onType",
	["files.eol"] = "\n",
	["luau-lsp.ignoreGlobs"] = {
		"**/_Index/**",
		"examples/*",
		"dist/**",
	},
	["luau-lsp.require.directoryAliases"] = {},
	["luau-lsp.require.mode"] = "relativeToFile",
	["typescript.tsdk"] = "node_modules/typescript/lib",
}
