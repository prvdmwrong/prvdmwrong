export type Runtime = {
	name: string,
	priority: number?,
	is: () -> boolean,
}

local function Runtime(x: Runtime)
	return table.freeze(x)
end

return table.freeze({
	Runtime = Runtime,
})
