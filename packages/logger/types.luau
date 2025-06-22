export type Error = {
	type: "Error",
	raw: string,
	message: string,
	trace: string,
}

export type Log = {
	template: string,
	error: Error?,
	trace: string?,
	[number]: unknown,
}

export type Logger<Templates> = Templates & {
	type: "Logger",
	print: (self: Logger<Templates>, props: Log) -> (),
	warn: (self: Logger<Templates>, props: Log) -> (),
	error: (self: Logger<Templates>, props: Log) -> (),
	fatalError: (self: Logger<Templates>, props: Log) -> never,
}

return nil
