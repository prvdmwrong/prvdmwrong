export type Object<T> = {
	type: "NetObject",
	value: T,
}

export type DataType<T> = {
	write: (value: T) -> (),
	read: (currentBuffer: buffer, cursor: number) -> (T, number),
	length: number?,
}

return nil
