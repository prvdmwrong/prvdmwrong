-- too lazy to use wally package types
local REQUIRED_MODULE = require(script.Parent._Index["znotfireman_ohmyprvd@0.1.1-alpha"]["ohmyprvd"])
export type Provider<T> = REQUIRED_MODULE.Provider<T>
return REQUIRED_MODULE
