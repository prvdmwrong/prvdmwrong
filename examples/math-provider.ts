import { Provider } from "@rbxts/prvdmwrong"

@Provider()
export class MathProvider {
	add(a: number, b: number) {
		// this method is very expensive! takes a lot of time!
		task.wait(5)
		return a + b
	}
}
