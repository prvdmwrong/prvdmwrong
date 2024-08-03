<div class="ompdoc-reference-breadcrumbs">
<a href="../">Reference</a>
</div>

# :octicons-list-unordered-16: Core

This package contains fundamental primitives for creating and using game
providers. Contains everything needed to bootstrap a Roblox game and utilities
for extending the core Oh My Prvd package.

Install this through your preferred package manager:

=== "Wally"

    ```toml
    ohmyprvd = "znotfireman/ohmyprvd@0.2.0-dev.2"
    ```

=== "NPM"

    ```bash
    npm i @rbxts/ohmyprvd
    ```

=== "PNPM"

    ```bash
    pnpm i @rbxts/ohmyprvd
    ```

=== "Yarn"

    ```bash
    yarn add @rbxts/ohmyprvd
    ```

---

<section class="grid" markdown>

<section markdown>

## Providers

- [:octicons-package-16: Provider](providers/provider.md)
- [:octicons-list-ordered-16: StartupStatus](providers/startup-status.md)
- [:octicons-code-16: awaitStart](providers/await-start.md)
- [:octicons-code-16: onStart](providers/on-start.md)
- [:octicons-code-16: preload](providers/preload.md)
- [:octicons-code-16: start](providers/start.md)
- [:octicons-code-16: use](providers/use.md)

## Reflection

- [:octicons-code-16: defineMetadata](reflection/define-metadata.md)
- [:octicons-code-16: deleteMetadata](reflection/define-metadata.md)
- [:octicons-code-16: getMetadata](reflection/define-metadata.md)

</section>

<section markdown>

## Modding

- [:octicons-code-16: getStartupOptions](modding/get-startup-options.md)
- [:octicons-code-16: getStartupStatus](modding/get-startup-status.md)
- [:octicons-code-16: onMethodImplemented](modding/on-method-implemented.md)
- [:octicons-code-16: onProviderConstructed](modding/on-provider-constructed.md)
- [:octicons-code-16: onProviderUsed](modding/on-provider-used.md)

## Types

- [:octicons-checklist-16: Options](types/options.md)
- [:octicons-checklist-16: Provider](types/provider.md)

</section>

</section>
