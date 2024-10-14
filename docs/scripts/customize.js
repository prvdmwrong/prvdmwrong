/// <reference lib="dom" />

try {
  function monospaceFont() {
    const MONOSPACE_FONTS = [
      "JetBrains Mono",
      "Source Code Pro",
      "Fira Code",
      "DM Mono",
      "Space Mono",
    ];

    const root = document.querySelector(":root");
    const head = document.querySelector("head");

    const monospaceFontSelecter = document.getElementById("monospace-font");

    const valueToFont = new Map();
    for (const font of MONOSPACE_FONTS) {
      const preloadLink = document.createElement("link");
      preloadLink.setAttribute("rel", "stylesheet");
      preloadLink.setAttribute(
        "href",
        "https://fonts.googleapis.com/css?family=" + font.replaceAll(" ", "+") +
          "&display=fallback",
      );
      head.appendChild(preloadLink);

      const value = font.replaceAll(" ", "").toLowerCase();
      valueToFont.set(value, font);

      const option = document.createElement("option");
      option.innerHTML = font;
      option.value = value;
      monospaceFontSelecter.appendChild(option);
    }

    const existingChoice = localStorage.getItem("prvdmwrong/monospace-font");
    if (!existingChoice) {
      localStorage.setItem("prvdmwrong/monospace-font", MONOSPACE_FONTS[0]);
    } else {
      monospaceFontSelecter.value = existingChoice;
    }

    function setMonospaceFont() {
      const currentFont = monospaceFontSelecter.value;
      root.style.setProperty("--md-code-font", valueToFont.get(currentFont));
      localStorage.setItem("prvdmwrong/monospace-font", currentFont);
    }

    setMonospaceFont();
    monospaceFontSelecter.onchange = setMonospaceFont;
  }

  monospaceFont();

  function codeFor() {
    const CODE_LANGUAGES = [
      "Luau",
      "TypeScript",
    ];

    const languageElements = new Map();
    const codeLanguageSelector = document.getElementById("code-lang");

    const valueToLang = new Map();
    for (const language of CODE_LANGUAGES) {
      const value = language.replaceAll(" ", "").toLowerCase();
      valueToLang.set(value, language);

      const option = document.createElement("option");
      option.innerHTML = language;
      option.value = value;
      codeLanguageSelector.appendChild(option);

      const elements = new Array();
      document.querySelectorAll(".only-" + value).forEach((element) =>
        elements.push(element)
      );
      languageElements.set(value, elements);
    }

    const existingChoice = localStorage.getItem("prvdmwrong/code-lang");
    if (!existingChoice) {
      localStorage.setItem("prvdmwrong/code-lang", CODE_LANGUAGES[0]);
    } else {
      console.log(existingChoice);
      codeLanguageSelector.value = existingChoice;
    }

    function setCodeLanguage() {
      const currentLanguage = codeLanguageSelector.value;

      for (const [language, elements] of languageElements) {
        if (language === currentLanguage) {
          for (const element of elements) {
            element.classList.remove("prvdmwrong-hidden");
          }
        } else {
          for (const element of elements) {
            element.classList.add("prvdmwrong-hidden");
          }
        }
      }

      localStorage.setItem("prvdmwrong/code-lang", currentLanguage);
    }

    setCodeLanguage();
    codeLanguageSelector.onchange = setCodeLanguage;
  }

  codeFor();
} catch (err) {
  window.alert("Failed to instantiate customization footer: " + err);
}
