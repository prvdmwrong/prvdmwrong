local luneTask = require("@lune/task")
local task = require("./task")
local tiniest = require("@lune-lib/tiniest/tiniest_for_lune")

-- FIXME: can't async stuff lol
return function(tiniest: tiniest.Configured): ()
	local test = tiniest.test
	local expect = tiniest.expect
	local describe = tiniest.describe

	describe("task", function()
		test("spawn", function()
			expect(task.spawn).is(luneTask.spawn)
			local spawned = false

			task.spawn(function()
				spawned = true
			end)

			expect(spawned).is_true()
		end)

		test("defer", function()
			expect(task.defer).is(luneTask.defer)

			-- local spawned = false

			-- task.defer(function()
			-- 	spawned = true
			-- end)

			-- expect(spawned).never_is_true()
		end)

		test("delay", function()
			expect(task.delay).is(luneTask.delay)
			-- local spawned = false

			-- task.delay(0.25, function()
			-- 	spawned = true
			-- end)

			-- expect(spawned).never_is_true()

			-- local startTime = os.clock()
			-- repeat
			-- until os.clock() - startTime > 0.5

			-- print(spawned)

			-- expect(spawned).is_true()
		end)

		test("wait", function()
			expect(task.wait).is(luneTask.wait)
		end)

		test("cancel", function()
			expect(task.cancel).is(luneTask.cancel)
		end)
	end)
end
