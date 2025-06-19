local depend = require("./depend")
local processDependencies = require("./process-dependencies")
local symbols = require("./symbols")
local tiniest = require("@lune-lib/tiniest/tiniest_for_lune")

local function nickname(name: string)
	return function<T>(tbl: T): T
		return setmetatable(tbl :: any, {
			__tostring = function()
				return name
			end,
		})
	end
end

return function(tiniest: tiniest.Configured): ()
	local test = tiniest.test
	local expect = tiniest.expect
	local describe = tiniest.describe

	describe("processDependencies", function()
		test("sortedDependencies", function()
			local first = nickname("first")({})

			local second = nickname("second")({
				[symbols.subdependencies] = {
					toFirst = depend(first :: any),
					toFirstAgain = depend(first :: any),
				},
			})

			local third = nickname("third")({
				[symbols.subdependencies] = {
					toSecond = depend(second :: any),
				},
			})

			local fourth = nickname("fourth")({
				[symbols.subdependencies] = {
					toFirst = depend(first :: any),
					toSecond = depend(second :: any),
					toThird = depend(third :: any),
				},
			})

			local processed = processDependencies({
				[first] = true,
				[second] = true,
				[third] = true,
				[fourth] = true,
			} :: any)

			expect(typeof(processed)).is("table")
			expect(processed).has_key("sortedDependencies")
			expect(typeof(processed.sortedDependencies)).is("table")

			local sortedDependencies = processed.sortedDependencies

			expect(typeof(sortedDependencies)).is("table")
			expect(sortedDependencies[1]).is(first)
			expect(sortedDependencies[2]).is(second)
			expect(sortedDependencies[3]).is(third)
			expect(sortedDependencies[4]).is(fourth)
		end)

		test("lifecycles", function() end)
	end)
end
