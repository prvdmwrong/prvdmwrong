local depend = require("./depend")
local processDependencies = require("./process-dependencies")
local subdependencies = require("./subdependencies")

local function nickname(name: string)
	return function<T>(tbl: T): T
		return setmetatable(tbl :: any, {
			__tostring = function()
				return name
			end,
		})
	end
end

return function()
	describe("processDependencies", function()
		it("should sort least dependencies first", function()
			local first = nickname("first")({})

			local second = nickname("second")({
				[subdependencies] = {
					toFirst = depend(first :: any),
					toFirstAgain = depend(first :: any),
				},
			})

			local third = nickname("third")({
				[subdependencies] = {
					toSecond = depend(second :: any),
				},
			})

			local fourth = nickname("fourth")({
				[subdependencies] = {
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

			print(processed)

			local sortedDependencies = processed.sortedDependencies

			expect(sortedDependencies).to.be.a("table")
			expect(sortedDependencies[1]).to.equal(first)
			expect(sortedDependencies[2]).to.equal(second)
			expect(sortedDependencies[3]).to.equal(third)
			expect(sortedDependencies[4]).to.equal(fourth)
		end)
	end)
end
