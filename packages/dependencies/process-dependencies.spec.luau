local processDependencies = require("./process-dependencies")

return function()
	describe("processDependencies", function()
		it("should process dependencies correctly", function()
			local first = {}

			local second = {
				toFirst = first,
			}

			local third = {
				toSecond = second,
			}

			local sortedDependencies = processDependencies({
				[first] = true,
				[second] = true,
				[third] = true,
			})

			expect(sortedDependencies).to.be.a("table")
			expect(sortedDependencies[1]).to.equal(first)
			expect(sortedDependencies[2]).to.equal(second)
			expect(sortedDependencies[3]).to.equal(third)
		end)
	end)
end
