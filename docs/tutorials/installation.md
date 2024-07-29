# Installation

Oh My Prvd is distributed as a single module script, which you will need to
import into your game.

## Methods

### Install via Roblox

If you edit directly inside Roblox Studio, then you can import a Roblox model
file containing Og My Prvd.

1. Head over to [Oh My Prvd's 'Releases' page.](https://github.com/team-fireworks/ohmyprvd/releases)
2. Click the "Assets" dropdown to view the downloadable files:
   ![Releases](../assets/static/github-releases.png)
3. Click on the package you would like to import, which should end in `.rbxm`.
  If you are just following the tutorials, just `ohmyprvd.rbxm` will do:
   ![Releases](../assets/static/github-releases-rbxm.png)
4. Open Roblox Studio to import the model. If you are just following the
  tutorials, just an empty baseplate will do.
5. Right-click on `ReplicatedStorage`, and select 'Insert from File'
6. You should see an `ohmyprvd` module script appear in ReplicatedStorage!

### Install via a Package Manager

If you use [Wally](https://wally.run/) for Luau or [NPM](https://www.npmjs.com/)
for TypeScript, Oh My Prvd has packages for both package managers.

=== "Wally"

    Append this below `[dependencies]` in your `wally.toml`:

    ```TOML
    ohmyprvd = "znotfireman/ohmyprvd"
    ```

    Then, install your packages:

    ```Bash
    $ wally install
    ```

    This will install Oh My Prvd into the `Packages` directory, though the
    actual location of the folder in-game depends on your Rojo project
    configuration, but it is usually in `ReplicatedStorage`.

=== "NPM & PNPM"

    Run either of these commands:

    ```Bash
    $ npm i @rbxts/ohmyprvd # npm
    $ pnpm i @rbxts/ohmyprvd # pnpm
    ```

    This will install Oh My Prvd under `node_modules`, which can be imported
    directly:

    ```TypeScript
    import ohmyprvd from "@rbxts/znotfireman"
    ```

### Install via Source

If you are synchronizing external files into Roblox Studio, Oh My Prvd can be
imported as source code.

1. Head over to [Oh My Prvd's 'Releases' page.](https://github.com/team-fireworks/ohmyprvd/releases)
2. Click the "Assets" dropdown to view the downloadable files:
   ![Releases](../assets/static/github-releases.png)
3. Under "Assets", download `Source code (zip)`. Inside is a copy of the Oh My
  Prvd GitHub repository.:
   ![Releases](../assets/static/github-releases-src.png)
4. Inside the zip, open `packages`, then the package you'd like to import,
  and copy it's `lib` folder; it may be inside another folder.
5. Create a new folder inside your project named "ohmyprvd", place it wherever
  you keep your libraries.
   - For example, you might paste it inside a `shared` or a `packages` folder.
6. Paste the contents of the `lib` folder into the newly created folder.

## Testing

Now, you can create a script for testing:

1. Create a `Script` under `ServerScriptService`.
2. Remove the following code, and paste this in depending on your installation:

    === "Roblox"

        ```Lua
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local prvd = require(ReplicatedStorage.ohmyprvd)
        ```

    === "Wally"

        ```Lua
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
        ```

    === "TypeScript"

        ```TypeScript
        import ohmyprvd from "@rbxts/ohmyprvd"
        ```

    === "Darklua"

        ```Lua
        local prvd = require("@pkg/ohmyprvd")
        ```

3. Press 'Play' - if there are no errors, everything was set up correctly!

??? failure "My script didn't work!"

    ```
    ohmyprvd is not a valid member of ReplicatedStorage "ReplicatedStorage"
    ```
    If you're seeing this error, then your script can't find Oh My Prvd.

    This code assumes you've placed Oh My Prvd under ReplicatedStorage. If
    you've installed both elsewhere, you'll need to the `require()` to point
    towards the correct location.

    If both looks like it points to the correct location, refer back to the
    previous section and double-check you've set everything up properly. Make
    sure under ReplicatedStorage, there's a ModuleScript named `ohmyprvd`.
