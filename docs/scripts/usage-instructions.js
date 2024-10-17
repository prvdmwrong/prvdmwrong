/// <reference lib="dom" />

try {
	const select = document.getElementById("usage-instructions-select")
	const selectOptions = [...select.options].map(o => o.value)
	const packageElements = new Map()

	selectOptions.forEach(value => {
		packageElements.set(value, document.querySelectorAll(".usage-instructions-" + value))
	})

	function toggleInstructions() {
		const currentPackage = select.value
		for (const [package, elements] of packageElements) {
			if (currentPackage == package) {
				for (const element of elements) {
					element.classList.remove("usage-instructions-hidden")
				}
			} else {
				for (const element of elements) {
					element.classList.add("usage-instructions-hidden")
				}
			}
		}
	}

	toggleInstructions()
	select.onchange = toggleInstructions
} catch (err) {
	window.alert("Failed to instantiate usage instructions panel: " + err)
}
