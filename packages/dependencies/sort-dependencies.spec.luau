local sortDependencies = require("./sort-dependencies")

return function()
	describe("sortDependencies", function()
		it("should sort dependencies correctly", function()
			local first = {}

			local second = {
				toFirst = first,
			}

			local third = {
				toSecond = second,
			}

			local sortedDependencies = {
				first,
				second,
				third,
			}

			sortDependencies(sortedDependencies :: any)
			print(sortedDependencies)

			expect(sortedDependencies[1]).to.equal(first)
			expect(sortedDependencies[2]).to.equal(second)
			expect(sortedDependencies[3]).to.equal(third)
		end)

		it("acknowledges priority", function()
			local low = {}

			local high = {
				priority = 500,
			}

			local sortedDependencies = {
				low,
				high,
			}

			sortDependencies(sortedDependencies :: any)
			print(sortedDependencies)

			expect(sortedDependencies[1]).to.equal(high)
			expect(sortedDependencies[2]).to.equal(low)
		end)
	end)
end
