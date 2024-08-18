import typescriptEslint from "@typescript-eslint/eslint-plugin"
import robloxTs from "eslint-plugin-roblox-ts"
import prettier from "eslint-plugin-prettier"
import tsParser from "@typescript-eslint/parser"
import path from "node:path"
import { fileURLToPath } from "node:url"
import js from "@eslint/js"
import { FlatCompat } from "@eslint/eslintrc"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const compat = new FlatCompat({
	baseDirectory: __dirname,
	recommendedConfig: js.configs.recommended,
	allConfig: js.configs.all,
})

export default [
	{
		// holy shit eslint can you fucking shut up
		ignores: ["dist", "out", "eslint.config.mjs", "site", "examples", "node_modules"],
		plugins: {
			"@typescript-eslint": typescriptEslint,
			"roblox-ts": robloxTs,
			prettier,
		},
		languageOptions: {
			ecmaVersion: 2018,
			sourceType: "module",

			parser: tsParser,
			parserOptions: {
				jsx: true,
				useJSXTextNode: true,
				project: ["./tsconfig.json"],
				tsconfigRootDir: __dirname,
			},
		},
		rules: {
			"prettier/prettier": "warn",
		},
	},
	...compat.extends(
		"eslint:recommended",
		"plugin:@typescript-eslint/recommended",
		"plugin:roblox-ts/recommended",
		"plugin:prettier/recommended",
	),
]
