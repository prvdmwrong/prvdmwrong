export type Dependency<Self> = Self & {
	priority: number?,
	new: (self: Dependency<Self>) -> ()?,
}

return nil
