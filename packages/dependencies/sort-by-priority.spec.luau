local sortByPriority = require("./sort-by-priority")
local symbols = require("./symbols")

return function()
	describe("sortByPriority", function()
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

			sortByPriority(sortedDependencies :: any)
			print(sortedDependencies)

			expect(sortedDependencies[1]).to.equal(first)
			expect(sortedDependencies[2]).to.equal(second)
			expect(sortedDependencies[3]).to.equal(third)
		end)

		it("acknowledges priority", function()
			local low = {}

			local high = {
				[symbols.priority] = 500,
			}

			local sortedDependencies = {
				low,
				high,
			}

			sortByPriority(sortedDependencies :: any)
			print(sortedDependencies)

			expect(sortedDependencies[1]).to.equal(high)
			expect(sortedDependencies[2]).to.equal(low)
		end)
	end)
end
