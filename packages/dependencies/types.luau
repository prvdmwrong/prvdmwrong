export type Dependency<Self, Dependencies = nil, NewArgs...> = Self & {
	priority: number?,
	new: (dependencies: Dependencies, NewArgs...) -> Dependency<Self, Dependencies, NewArgs...>,

	[subdependencies]: Dependencies,
}

export type UnresolvedDependency = {
	type: "UnresolvedDependency",
	dependency: Dependency<any>,
}

export type subdependencies = { __prvdmwrong_subdependencies: never }

return nil
