/// <reference no-default-lib="true"/>
/// <reference types="@rbxts/types"/>

/** Throws an error if the provided value is false or nil. */
declare function assert<T>(condition: T, message?: string): asserts condition;

/**
 * Returns the type of the given object as a string. This function works similarly to Lua’s native type function, with
 * the exceptions that Roblox-defined data types like Vector3 and CFrame return their respective data types as strings.
 */
declare function typeOf(value: any): keyof CheckableTypes;

/**
 * Returns true if `typeof(value) == type`, otherwise false.
 * This function allows for type narrowing. i.e.
 * ```
 * // v is unknown
 * if (typeIs(v, "Vector3")) {
 * 	// v is a Vector3
 * 	print(v.X, v.Y, v.Z);
 * }
 * ```
 */
declare function typeIs<T extends keyof CheckableTypes>(value: any, type: T): value is CheckableTypes[T];

/**
 * Returns true if `instance.ClassName == className`, otherwise false.
 */
declare function classIs<T extends keyof Instances>(instance: Instance, className: T): instance is Instances[T];

/**
 * Returns the passed argument. This function is a macro that compiles to just `arg`.
 *
 * This is useful for ensuring that a value matches the given type in areas where it is not directly possible to do so.
 * @example
 * type P = { x: number, y: number };
 * const obj = {
 *   pos: identity<P>({ x: 5, y: 10 });
 * }
 */
declare function identity<T>(arg: T): T;

/**
 * **Only valid as the expression of a for-of loop!**
 *
 * Used to compile directly to normal Lua numeric for loops. For example,
 * ```ts
 * for (const i of $range(1, 10)) {
 * 	print(i);
 * }
 * ```
 * will compile into
 * ```lua
 * for i = 1, 10 do
 * 	print(i)
 * end
 * ```
 *
 * The `step` argument controls the amount incremented per loop. It defaults to `1`.
 */
declare function $range(start: number, finish: number, step?: number): Iterable<number>;

/**
 * **Only valid as the expression of a return statement!**
 *
 * Compiles directly to a multiple return in Lua. For example,
 * ```ts
 * return $tuple(123, "abc", true);
 * ```
 * will compile into
 * ```lua
 * return 123, "abc", true
 * ```
 */
declare function $tuple<T extends Array<any>>(...values: T): LuaTuple<T>;

/**
 * Provides the instance tree representation to `path` at runtime.
 *
 * ```ts
 * $getModuleTree("@rbxts/services");
 * ```
 * will, assuming the default rojo game project, compile into
 * ```lua
 * { game:GetService("ReplicatedStorage"), { "rbxts_include", "node_modules", "@rbxts", "services" } }
 * ```
 */
declare function $getModuleTree(module: string): [root: Instance, parts: Array<string>];
