-- FIXME: this isnt ever going to work
local prvd = require("@core")

local net = table.freeze {
	version = _G.PRVDMWRONG_VERSION,
	netRoot = prvd.root(),

	dataTypes = table.freeze {
		array = require("@net/datatypes/array"),
		boolean = require("@net/datatypes/boolean"),
		buffer = require("@net/datatypes/buffer"),
		cframe = require("@net/datatypes/cframe"),
		color3 = require("@net/datatypes/color3"),
		float32 = require("@net/datatypes/float32"),
		float64 = require("@net/datatypes/float64"),
		instance = require("@net/datatypes/instance"),
		int8 = require("@net/datatypes/int8"),
		int16 = require("@net/datatypes/int16"),
		int32 = require("@net/datatypes/int32"),
		interface = require("@net/datatypes/interface"),
		map = require("@net/datatypes/map"),
		none = require("@net/datatypes/none"),
		optional = require("@net/datatypes/optional"),
		string = require("@net/datatypes/string"),
		uint16 = require("@net/datatypes/uint16"),
		uint32 = require("@net/datatypes/uint32"),
		uint64 = require("@net/datatypes/uint64"),
		unknown = require("@net/datatypes/unknown"),
		vector2 = require("@net/datatypes/vector2"),
		vector3 = require("@net/datatypes/vector3"),
	},
}

return net
