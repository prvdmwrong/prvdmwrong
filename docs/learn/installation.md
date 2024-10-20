# Installation

Prvd 'M Wrong is distributed as several packages that needs to be installed into
your game.

For Luau, either use a pre-built Roblox model, install from Pesde, or install
from Wally. For Roblox TypeScript, use the NPM package. Otherwise, build from
source.

## From Templates

New projects can use pre-configured templates with Prvd 'M Wrong out of the box,
published under the [`@prvdmwrong/templates` repository][Templates repository].

1. From a terminal, clone the [`@prvdmwrong/templates` repository][Templates repository]:

    ```Sh
    git clone https://github.com/prvdmwrong/templates.git
    cd templates
    ```

2. Clone any of the templates inside the repository:
    - For Luau projects:
        - Use the [`luau-barebones`][Luau barebones] template for a
            pre-configured barebones prelude.
        - Use the [`luau-comprehensive`][Luau comprehensive] template for a
            comprehensive prelude including Darklua string requires, Wally with
            types, and plenty of goodies.
    - For Roblox TypeScript projects:
        - Use the [`rbxts-barebones`][TypeScript barebones] template for a
            pre-configured barebones prelude.
        - Use the [`rbxts-comprehensive`][TypeScript comprehensive] template for
            a comprehensive prelude including ESLint and Prettier
            pre-configured.

[Templates repository]: https://github.com/prvdmwrong/templates
[Luau barebones]: https://github.com/prvdmwrong/templates/tree/main/luau-barebones
[Luau comprehensive]: https://github.com/prvdmwrong/templates/tree/main/luau-comprehensive
[TypeScript barebones]: https://github.com/prvdmwrong/templates/tree/main/rbxts-barebones
[TypeScript comprehensive]: https://github.com/prvdmwrong/templates/tree/main/rbxts-comprehensive

## Manual Installation

For Luau, Prvd 'M Wrong can be installed as a pre-built Roblox model, a Pesde
package, or a Wally package. For Roblox TypeScript, Prvd 'M Wrong can be
installed as an NPM package.

### Pesde

Prvd 'M Wrong can be installed as a Pesde package. Pesde packages are published
under the `@prvdmwrong` scope in dai's [Pesde registry].

Pesde is strongly recommended over other installation methods for it's
versatility.

1. From a terminal, add the desired Prvd 'M Wrong package:

    ```Sh
    # it's recommended to alias prvdmwrong/core with prvd!
    pesde add prvdmwrong/core -a prvd
    ```

2. Import the desired Prvd 'M Wrong package through the `roblox_packages`
    directory:

    ```Luau
    local prvd = require(ReplicatedStorage.roblox_packages.prvd)
    ```

[Pesde registry]: https://pesde-lukadev-0.vercel.app/

#### Using Wally through Pesde

Prvd 'M Wrong can be installed with Pesde's Wally compatibility layer. Notably,
older versions of Prvd 'M Wrong published on Wally prior to Pesde `0.5` can be
used.

Wally packages are published under the `@prvdmwrong` scope in Uplift Game's
[Wally registry].

This can be used as a backup option when Prvd 'M Wrong Pesde packages break.

1. From a terminal, add the desired Prvd 'M Wrong package, noting the `wally#`
    specifier:

    ```Sh
    # it's recommended to alias prvdmwrong/core with prvd!
    pesde add wally#prvdmwrong/core -a prvd
    ```

2. Import the desired Prvd 'M Wrong package through the `roblox_packages`
    directory:

    ```Luau
    local prvd = require(ReplicatedStorage.roblox_packages.prvd)
    ```

### Roblox

Prvd 'M Wrong can be installed as a Roblox model.

!!! warning "Prvd 'M Wrong 0.2 has not been released yet, so distributed 0.2 models are unavalible. See [Build from Source] for building Roblox models by source."

1. Visit the [GitHub releases] to find the desired Prvd 'M Wrong version.
2. Click the "Assets" dropdown to view the downloadable files.
3. Click on `prvdmwrong.rbxm` to download the bundled Prvd 'M Wrong packages.
4. Open Roblox Studio to import the model. If you are just following the
    tutorials, just an empty baseplate will do.
5. Right-click on `ReplicatedStorage`, and select "Insert from File". Select the
    `prvdmwrong.rbxm` you just downloaded. A new folder called `prvd` should
    appear with the bundled packages.
6. Import the desired packages through the imported `prvd` folder:

    ```Luau
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.prvd.core)
    ```

[GitHub releases]: https://github.com/prvdmwrong/prvdmwrong/releases

[Build from Source]: #build-from-source

### Wally

Prvd 'M Wrong can be installed as a Wally package. Wally packages are published
under the `@prvdmwrong` scope in Uplift Game's [Wally registry].

Consider using [Pesde](#pesde) over Wally.

1. Add the desired Prvd 'M Wrong package in your `wally.toml` manifest:

    ```TOML
    # it's recommended to alias prvdmwrong/core with prvd!
    [dependencies]
    prvd = "prvdmwrong/core@0.2.*"
    ```

2. From a terminal, install all Wally packages:

    ```Sh
    wally install
    ```

3. Import the desired Prvd 'M Wrong package through the `Packages`
    directory:

    ```Luau
    local prvd = require(ReplicatedStorage.Packages.prvd)
    ```

[Wally registry]: https://wally.run/

### NPM

For TypeScript projects that compile using Roblox TypeScript, Prvd 'M Wrong can
be installed as an NPM package.

NPM packages are published under the `@prvdmwrong` scope in the [NPM registry].

=== "NPM"

    1. From a terminal, add the desired Prvd 'M Wrong package:

        ```Sh
        npm i @prvdmwrong/core
        ```

    2. Import the package through `node_modules`:

        ```TypeScript
        import prvd from "@prvdmwrong/core"
        ```

=== "PNPM"

    1. From a terminal, add the desired Prvd 'M Wrong package:

        ```Sh
        pnpm i @prvdmwrong/core
        ```

    2. Import the package through `node_modules`:

        ```TypeScript
        import prvd from "@prvdmwrong/core"
        ```

=== "Yarn"

    1. From a terminal, add the desired Prvd 'M Wrong package:

        ```Sh
        yarn add @prvdmwrong/core
        ```

    2. Import the package through `node_modules`:

        ```TypeScript
        import prvd from "@prvdmwrong/core"
        ```

[NPM registry]: https://www.npmjs.com/org/prvdmwrong

#### Environment Setup

Because Prvd 'M Wrong does not publish packages under the `@rbxts` scope, Roblox
TypeScript will refuse to use it.

While this helpfully prevents you from using other `node_modules`, Roblox
TypeScript needs to be configured to use Prvd 'M Wrong.

This only needs to be done once per each environment.

1. Add `@prvdmwrong` to `node_modules` in your project file(s), it may be nested
    behind several levels:

    ```JSON hl_lines="6-8"
    "node_modules": {
        "$className": "Folder",
        "@rbxts": {
            "$path": "node_modules/@rbxts"
        },
        "@prvdmwrong": {
            "$path": "node_modules/@prvdmwrong"
        }
    }
    ```

2. Add `@prvdmwrong` to `tsconfig.json`'s `typeRoots`, it may be nested behind
    several levels:

    ```JSON hl_lines="3"
    "typeRoots": [
        "node_modules/@rbxts",
        "node_modules/@prvdmwrong"
    ],
    ```

## Build from Source

Prvd 'M Wrong can be built from source.

!!! danger "It is not recommended to build Prvd 'M Wrong from source. Consider using one of the listed installation methods instead. This section is only for Prvd 'M Wrong contributors."

1. From a terminal, clone the [`@prvdmwrong/prvdmwrong` repository][Main repository]:

    ```Sh
    git clone https://github.com/prvdmwrong/prvdmwrong.git
    cd prvdmwrong
    ```

2. Checkout the `0.2` branch:

    ```Sh
    git checkout 0.2
    ```

3. Install all required tooling with [Rokit]:

    ```Sh
    rokit install
    ```

4. Run the build script:

    ```Sh
    lune run build
    ```

    Configuration options are availible in `prvdmwrong.toml` for each packages
    and the whole repository.

5. Find the distributables in the `build` directory.

    - `build/packages` has individual source files for each package that can be published to Wally/Pesde/NPM
    - `build/models` has individual `.rbxm` models for each package
    - `build/prvdmwrong.rbxl` is a Roblox game with all built Prvd 'M Wrong packages in ReplicatedStorage
    - `build/prvdmwrong.rbxm` is a `.rbxm` model with all built Prvd 'M Wrong packages

[Rokit]: https://github.com/rojo-rbx/rokit
[Main repository]: https://github.com/prvdmwrong/prvdmwrong
