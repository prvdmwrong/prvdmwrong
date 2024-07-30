local runCLI = require(script.Packages.Jest).runCLI

local processServiceExists, ProcessService = pcall(function()
  -- selene: allow(incorrect_standard_library_use)
  return game:GetService("ProcessService")
end)

local status, result = runCLI(script, {
  verbose = false,
  ci = false,
}, { script.__tests__ }):awaitStatus()

if status == "Rejected" then
  print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
  if processServiceExists then
    ProcessService:ExitAsync(0)
  end
end

if processServiceExists then
  ProcessService:ExitAsync(1)
end

return nil
