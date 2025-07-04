-- From dphfox/tiniest, licensed under BSD3
--!strict

local tiniest = require("./tiniest")
local tiniest_expect = require("./tiniest_expect")
local tiniest_pretty = require("./tiniest_pretty")
local tiniest_snapshot = require("./tiniest_snapshot")
local tiniest_time = require("./tiniest_time")

local fs = require("@lune/fs")
local luau = require("@lune/luau")

export type Options = {
	snapshot_path: string?,
	save_snapshots: boolean?,
	pretty: nil | {
		disable_colour: boolean?,
		disable_emoji: boolean?,
		disable_unicode: boolean?,
		disable_output: nil | {
			after_run: boolean?,
		},
	},
}

local tiniest_for_lune = {}

function tiniest_for_lune.configure(options: Options)
	local self = {}

	local function get_path_to_snapshot(key: string): string
		assert(options.snapshot_path ~= nil)
		return `{options.snapshot_path}/{key}.snap.luau`
	end

	local function load_snapshots(key: string): { string }?
		local path = get_path_to_snapshot(key)
		if not fs.isFile(path) then
			return nil
		else
			local ok, result = pcall(function()
				local source = fs.readFile(path)
				local bytecode = luau.compile(source)
				local loaded = luau.load(bytecode, {
					injectGlobals = false,
				})
				return loaded()
			end)
			if ok then
				return result
			else
				error("[tiniest_for_lune] Failed to load snapshots from disk: " .. tostring(result), 0)
			end
		end
	end

	local function save_snapshots(key: string, snapshots: { string }): ()
		local ok, result = pcall(function()
			snapshots = table.clone(snapshots)
			for index, snapshot in snapshots do
				snapshots[index] = `[====[{snapshot}]====]`
			end
			fs.writeFile(
				get_path_to_snapshot(key),
				"-- Auto-generated by dphfox/tiniest. Do not modify!\n"
					.. "--!nocheck\n"
					.. "return {"
					.. table.concat(snapshots, ", ")
					.. "}"
			)
		end)
		if not ok then
			error("[tiniest_for_lune] Failed to save snapshots to disk: " .. tostring(result), 0)
		end
	end

	self.expect = tiniest_expect.expect

	local tiniest_time = tiniest_time.configure({
		get_timestamp = os.clock,
	})

	local tiniest_snapshot = tiniest_snapshot.configure({
		load_snapshots = if options.snapshot_path then load_snapshots else nil,
		save_snapshots = if options.save_snapshots then save_snapshots else nil,
	})
	self.snapshot = tiniest_snapshot.snapshot

	local tiniest_pretty = tiniest_pretty.configure({
		disable_colour = options.pretty and options.pretty.disable_colour,
		disable_emoji = options.pretty and options.pretty.disable_emoji,
		disable_unicode = options.pretty and options.pretty.disable_unicode,
		disable_output = options.pretty and options.pretty.disable_output,
		plugins = { tiniest_time :: any, tiniest_snapshot },
	})
	self.format_run = tiniest_pretty.format_run

	local tiniest = tiniest.configure({
		plugins = { tiniest_time :: any, tiniest_snapshot, tiniest_pretty },
	})
	self.describe = tiniest.describe
	self.test = tiniest.test
	self.collect_tests = tiniest.collect_tests
	self.run_tests = tiniest.run_tests

	return self
end

-- bro
export type Configured = typeof(tiniest.configure({})) & {
	expect: typeof(tiniest_expect.expect),
}

return tiniest_for_lune
