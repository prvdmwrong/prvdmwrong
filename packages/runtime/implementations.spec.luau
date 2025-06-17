local implementations = require("./implementations")

return function()
	describe("currentRuntime", function()
		it("detects roblox runtime", function()
			expect(implementations.currentRuntimeName).to.equal("roblox")
			expect(implementations.currentRuntime).to.equal(implementations.supportedRuntimes.roblox)
		end)
	end)

	describe("implementFunction", function()
		it("implements for roblox runtime", function()
			local roblox = function() end
			local luau = function() end

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.roblox] = {
					implementation = roblox,
				},
				[implementations.supportedRuntimes.luau] = {
					implementation = luau,
				},
			})

			expect(implementation).to.be.a("function")
			expect(implementation).never.to.equal(luau)
			expect(implementation).to.equal(roblox)
		end)

		it("constructs for roblox runtime", function()
			local roblox = function() end
			local luau = function() end

			local constructedRoblox = false

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.roblox] = {
					new = function()
						constructedRoblox = true
						return roblox
					end,
				},
				[implementations.supportedRuntimes.luau] = {
					new = function()
						return luau
					end,
				},
			})

			expect(implementation).to.be.a("function")
			expect(implementation).never.to.equal(luau)
			expect(implementation).to.equal(roblox)
			expect(constructedRoblox).to.equal(true)
		end)

		it("defaults to not implemented function", function()
			local constructSuccess, runSuccess = false, false

			local implementation = implementations.implementFunction("implementation", {
				[implementations.supportedRuntimes.lune] = {
					new = function()
						constructSuccess = true
						return function()
							runSuccess = true
						end
					end,
				},
			})

			expect(constructSuccess).to.equal(false)
			expect(implementation).to.be.a("function")
			expect(implementation).to.throw("'implementation' is not implemented by runtime 'roblox'")
			expect(runSuccess).to.equal(false)
		end)
	end)
end
