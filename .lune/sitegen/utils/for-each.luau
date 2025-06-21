local function forEach<KI, KO, VI, VO>(input: { [KI]: VI }, func: (KI, VI) -> (KO, VO)): { [KO]: VO }
	local output = {}
	for keyIn, valueIn in input do
		local keyOut, valueOut = func(keyIn, valueIn)
		if keyOut == nil or valueOut == nil then
			continue
		end
		assert(output[keyOut] == nil, "Key collision")
		output[keyOut] = valueOut
	end
	return output
end

return forEach
