try {
  (function monospaceFont() {
    const MONOSPACE_FONTS = [
      "JetBrains Mono",
      "Source Code Pro",
      "DM Mono",
      "Fira Code",
      "Space Mono",
    ]

    const root = document.querySelector(":root")
    const head = document.querySelector("head")

    const monospaceFontSelecter = document.getElementById("monospace-font")

    const valueToFont = new Map()
    for (const font of MONOSPACE_FONTS) {
      const preloadLink = document.createElement("link")
      preloadLink.setAttribute("rel", "stylesheet")
      preloadLink.setAttribute("href", "https://fonts.googleapis.com/css?family=" + font.replaceAll(" ", "+") + "&display=fallback")
      head.appendChild(preloadLink)

      const value = font.replaceAll(" ", "").toLowerCase()
      valueToFont.set(value, font)

      const option = document.createElement("option")
      option.innerHTML = font
      option.value = value
      monospaceFontSelecter.appendChild(option)
    }

    const existingChoice = localStorage.getItem("prvdmwrong/monospace-font")
    if (!existingChoice) {
      localStorage.setItem("prvdmwrong/monospace-font", MONOSPACE_FONTS[0])
    } else {
      monospaceFontSelecter.value = existingChoice
    }

    function setMonospaceFont() {
      const currentFont = monospaceFontSelecter.value
      root.style.setProperty("--md-code-font", valueToFont.get(currentFont))
      localStorage.setItem("prvdmwrong/monospace-font", currentFont)
    }

    setMonospaceFont()
    monospaceFontSelecter.onchange = setMonospaceFont
  })()
} catch (err) {
  window.alert("Failed to instantiate customization footer: " + err)
}
