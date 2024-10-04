# eslint-plugin-roblox-ts

![lint rules demo](https://user-images.githubusercontent.com/15217173/64753460-ed490e80-d4e8-11e9-9af9-06fb1a0aceae.gif)


What follows is an incomplete guide on how to get started using typescript-eslint with eslint-plugin-roblox-ts and prettier. We eventually plan to make a better guide and automate a number of these steps through `rbxtsc` command line options. But, for now, here is how to use these lint rules with VSCode.

## Step 1: Install the ESLint plugin for VSCode
Install the following:

<a href="https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint"><img src="https://camo.githubusercontent.com/e16321b339b250b46af5bcb05ed36892e6770342/68747470733a2f2f64626165756d65722e67616c6c65727963646e2e76736173736574732e696f2f657874656e73696f6e732f64626165756d65722f7673636f64652d65736c696e742f312e392e312f313536363239383133363236392f4d6963726f736f66742e56697375616c53747564696f2e53657276696365732e49636f6e732e44656661756c74" data-canonical-src="https://dbaeumer.gallerycdn.vsassets.io/extensions/dbaeumer/vscode-eslint/1.9.1/1566298136269/Microsoft.VisualStudio.Services.Icons.Default" width="100" height="100"></a>

<!-- 
<a href="https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode"><img src="https://camo.githubusercontent.com/439873e3a6c9faa27a6f9d69ab8a9cc91bf7dc84/68747470733a2f2f657362656e702e67616c6c65727963646e2e76736173736574732e696f2f657874656e73696f6e732f657362656e702f70726574746965722d7673636f64652f312e31302e302f313536363537333135313038332f4d6963726f736f66742e56697375616c53747564696f2e53657276696365732e49636f6e732e44656661756c74" data-canonical-src="https://esbenp.gallerycdn.vsassets.io/extensions/esbenp/prettier-vscode/1.10.0/1566573151083/Microsoft.VisualStudio.Services.Icons.Default" width="100" height="100"></a>
-->

## Step 2: Change your VSCode settings
Make sure the following settings are in your settings file (`Ctrl + ,` to open the settings UI, then press the `Open Settings (JSON)` button in the top right).

These are according to my preferences, so feel free to change this according to your own desires:
```json
	"files.trimTrailingWhitespace": true,
	"files.insertFinalNewline": true,
	"files.trimFinalNewlines": true,
	"[typescript]": {
		"editor.defaultFormatter": "dbaeumer.vscode-eslint",
		"editor.formatOnSave": true,
		"editor.formatOnPaste": true,
		"editor.formatOnType": true,
	},
	"[typescriptreact]": {
		"editor.defaultFormatter": "dbaeumer.vscode-eslint",
		"editor.formatOnSave": true,
		"editor.formatOnPaste": true,
		"editor.formatOnType": true,
	},
	"eslint.packageManager": "npm",
	"eslint.run": "onType",
	"eslint.format.enable": true,
```

## Step 3: Setup the eslint config file
Make a file named `.eslintrc` and place this in the contents.

```json
{
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "jsx": true,
        "useJSXTextNode": true,
        "ecmaVersion": 2018,
        "sourceType": "module",
        "project": "./tsconfig.json"
    },
    "plugins": [
        "roblox-ts",
        "@typescript-eslint",
        "@typescript-eslint/eslint-plugin",
        "prettier"
    ],
    "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:prettier/recommended",
        "plugin:roblox-ts/recommended"
    ],
    "rules": {
        "prettier/prettier": "warn",
        "@typescript-eslint/array-type": [
            "warn",
            {
                "default": "generic",
                "readonly": "generic"
            }
        ],
        "@typescript-eslint/no-unused-vars": "off",
        "@typescript-eslint/explicit-function-return-type": "off",
        "@typescript-eslint/no-namespace": "off",
        "@typescript-eslint/no-non-null-assertion": "off",
        "@typescript-eslint/no-empty-function": "warn",
	"prefer-const": [
		"warn",
		{
			"destructuring": "all"
		}
	],
        "no-undef-init": "error"
    }
}
```
If you have a pre-existing `.prettierrc` file, you can keep it, and eslint will pick it up and use that.
If not, you can create it with this recommended config:
```json
{
	"semi": true,
	"trailingComma": "all",
	"singleQuote": false,
	"printWidth": 120,
	"tabWidth": 4,
	"useTabs": true
}
```

## Step 4: Install the necessary packages

Run the following command:

`npm i -D eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier eslint-plugin-prettier eslint-plugin-roblox-ts`

<!-- For roact development: npm i -D eslint-config-react -->

## Step 5: Reload window
Type `Ctrl+Shift+P` and select `Developer: Reload Window`. 
