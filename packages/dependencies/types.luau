export type Dependency<Self, Dependencies = nil, NewArgs... = ()> = Self & {
	dependencies: Dependencies,
	priority: number?,
	new: (dependencies: Dependencies, NewArgs...) -> Dependency<Self, Dependencies, NewArgs...>,
}

export type UnresolvedDependency = {
	type: "UnresolvedDependency",
	dependency: Dependency<any>,
}

export type dependencies = { __prvdmwrong_dependencies: never }

return nil
