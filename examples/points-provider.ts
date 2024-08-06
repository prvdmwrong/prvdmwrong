import { Provider, use, type OnStart } from "@rbxts/prvdmwrong"
import { Players } from "@rbxts/services"

// Tweak this based on where you placed the MathProvider
import { MathProvider } from "./math-provider"

@Provider()
export class Provider implements OnStart {
	readonly points = new Map<Player, number>()
	mathProvider = use(MathProvider)

	setDefaultPoints(player: Player) {
		this.points.set(player, 10)
	}

	onStart() {
		Players.PlayerAdded.Connect((newPlayer) => {
			this.setDefaultPoints(newPlayer)
		})
		for (const existingPlayer in Players.GetPlayers()) {
			this.setDefaultPoints(existingPlayer)
		}
		Players.PlayerRemoving.Connect((newPlayer) => {
			this.points.delete(newPlayer)
		})
	}

	add(player: Player, amount: number) {
		const currentPoints = this.points.get(player)
		const newPoints = this.mathProvider.add(currentPoints, amount)
		this.points.set(player, newPoints)
	}
}
