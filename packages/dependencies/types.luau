export type Dependency<Self, Dependencies = nil> = Self & {
	priority: number?,
	new: (dependencies: Dependencies) -> Dependency<Self, Dependencies>,

	[subdependencies]: Dependencies,
}

export type UnresolvedDependency = {
	type: "UnresolvedDependency",
	dependency: Dependency<any>,
}

export type subdependencies = { __prvdmwrong_subdependencies: never }

return nil
