local implementations = require("./implementations")
local tiniest = require("@lune-lib/tiniest/tiniest_for_lune")

return function(tiniest: tiniest.Configured): ()
	local test = tiniest.test
	local expect = tiniest.expect
	local describe = tiniest.describe

	describe("currentRuntime", function()
		test("detects lune runtime", function()
			expect(implementations.currentRuntimeName).is("lune")
			expect(implementations.currentRuntime).is(implementations.supportedRuntimes.lune)
		end)
	end)

	describe("implementFunction", function()
		test("implements for lune runtime", function()
			local lune = function() end
			local luau = function() end

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.lune] = {
					implementation = lune,
				},
				[implementations.supportedRuntimes.luau] = {
					implementation = luau,
				},
			})

			expect(implementation).is_a("function")
			expect(implementation).never_is(luau)
			expect(implementation).is(lune)
		end)

		test("constructs for lune runtime", function()
			local lune = function() end
			local luau = function() end

			local constructedLune = false

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.lune] = {
					new = function()
						constructedLune = true
						return lune
					end,
				},
				[implementations.supportedRuntimes.luau] = {
					new = function()
						return luau
					end,
				},
			})

			expect(implementation).is_a("function")
			expect(implementation).never_is(luau)
			expect(implementation).is(lune)
			expect(constructedLune).is_true()
		end)

		test("defaults to not implemented function", function()
			local constructSuccess, runSuccess = false, false

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.roblox] = {
					new = function()
						constructSuccess = true
						return function()
							runSuccess = true
						end
					end,
				},
			})

			expect(constructSuccess).is(false)
			expect(implementation).is_a("function")
			expect(implementation).fails_with("'implementation' is not implemented by runtime 'lune'")
			expect(runSuccess).is(false)
		end)
	end)
end
