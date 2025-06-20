export type Dependency<Self, Dependencies = nil, NewArgs... = ()> = Self & {
	subdependencies: Dependencies,
	priority: number?,
	new: (dependencies: Dependencies, NewArgs...) -> Dependency<Self, Dependencies, NewArgs...>,
}

export type UnresolvedDependency = {
	type: "UnresolvedDependency",
	dependency: Dependency<any>,
}

export type subdependencies = { __prvdmwrong_subdependencies: never }

return nil
