local sortByPriority = require("./sort-by-priority")
local symbols = require("./symbols")
local tiniest = require("@lune-lib/tiniest/tiniest_for_lune")

return function(tiniest: tiniest.Configured): ()
	local test = tiniest.test
	local expect = tiniest.expect
	local describe = tiniest.describe

	describe("sortByPriority", function()
		test("dependencies", function()
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

			expect(sortedDependencies[1]).is(first)
			expect(sortedDependencies[2]).is(second)
			expect(sortedDependencies[3]).is(third)
		end)

		test("priority", function()
			local low = {}

			local high = {
				[symbols.priority] = 500,
			}

			local sortedDependencies = {
				low,
				high,
			}

			sortByPriority(sortedDependencies :: any)

			expect(sortedDependencies[1]).is(high)
			expect(sortedDependencies[2]).is(low)
		end)
	end)
end
