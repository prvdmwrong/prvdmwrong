local types = require("./types")

export type Instruction = {
  title: string,
  code: (types.PackageData) -> string,
  language: string,
}

local function Instruction(x: Instruction): Instruction
  return table.freeze(x)
end

export type UsageInstructions = { Instruction }

local function UsageInstructions(x: UsageInstructions): UsageInstructions
  return table.freeze(x)
end

local function plainCode(code: string): (types.PackageData) -> string
  return function(package: types.PackageData): string
    return (
      code
        :gsub("$name", package.name)
        :gsub("$package", package.relativePath)
        :gsub("$module", package.config.config.module)
    )
  end
end

---

return table.freeze {
  {
    packageManager = "Wally",
    instructions = UsageInstructions {
      Instruction {
        title = "Add to <code>wally.toml</code>",
        code = plainCode('$module = "$package@0.2"'),
        language = "TOML",
      },
      Instruction {
        title = "Install packages",
        code = plainCode("wally install"),
        language = "Bash",
      },
      Instruction {
        title = "Import package",
        code = plainCode("local $module = require(ReplicatedStorage.Packages.$module)"),
        language = "Luau",
      },
    },
  },
  {
    packageManager = "Pesde",
    instructions = UsageInstructions {
      Instruction {
        title = "Install package",
        code = plainCode("pesde add $package@0.2"),
        language = "Bash",
      },
      Instruction {
        title = "Import package",
        code = plainCode("local $module = require(ReplicatedStorage.packages.$module)"),
        language = "Luau",
      },
    },
  },
  {
    packageManager = "npm",
    instructions = UsageInstructions {
      Instruction {
        title = "Install package",
        code = plainCode("npm i @$package"),
        language = "Bash",
      },
      Instruction {
        title = "Import package",
        code = plainCode('import * as $module from "@$package"'),
        language = "TypeScript",
      },
    },
  },
  {
    packageManager = "pnpm",
    instructions = UsageInstructions {
      Instruction {
        title = "Install package",
        code = plainCode("pnpm i @$package"),
        language = "Bash",
      },
      Instruction {
        title = "Import package",
        code = plainCode('import * as $module from "@$package"'),
        language = "TypeScript",
      },
    },
  },
  {
    packageManager = "Yarn",
    instructions = UsageInstructions {
      Instruction {
        title = "Install package",
        code = plainCode("yarn add @$package"),
        language = "Bash",
      },
      Instruction {
        title = "Import package",
        code = plainCode('import * as $module from "@$package"'),
        language = "TypeScript",
      },
    },
  },
}
