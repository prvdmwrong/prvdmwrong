local process = require("@lune/process")

local SPAWN_OPTIONS = {
  shell = true,
  cwd = process.cwd,
} :: process.SpawnOptions

local function summon(program: string, ...: string)
  local arguments = { ... }
  local result = process.spawn(program, arguments, SPAWN_OPTIONS)

  if not result.ok then
    print(result.stdout)
    print(result.stderr)
    print("Process exited with code", result.code)
  end

  return result
end

return summon
