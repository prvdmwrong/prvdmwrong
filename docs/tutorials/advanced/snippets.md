# Code Snippets

Prvd 'M Wrong is designed to be featherlight, requiring no transformers,
compilers, plugins, or extensions. Instead, you may enjoy code snippets to
speed up development within Prvd 'M Wrong.

All code snippets showcased are made for Luau and TypeScript and found under
[`.vscode` in the Prvd 'M Wrong
monorepo.](https://github.com/prvdmwrong/prvdmwrong/tree/main/.vscode)

!!! warning "Under construction"
    This page is under construction - information may be incomplete or missing.

## :pmwdoc-luau:{ .pmwdoc-icons-luau }:pmwdoc-robloxts:{ .pmwdoc-icons-robloxts } Provider

Constructs and returns a provider that implements the `onInit` and `onStart`
lifecycles.

=== "Snippet"

    ```JSON
    // Luau
    "Provider": {
      "prefix": "provider",
      "body": [
        "local ${0:$TM_FILENAME_BASE} = {}",
        "type Self = typeof(${0:$TM_FILENAME_BASE})",
        "",
        "function ${0:$TM_FILENAME_BASE}.onInit(self: Self)",
        "",
        "end",
        "",
        "function ${0:$TM_FILENAME_BASE}.onStart(self: Self)",
        "",
        "end",
        "",
        "return prvd(\"${0:$TM_FILENAME_BASE}\", ${0:$TM_FILENAME_BASE})"
      ],
      "description": "Create a new Luau provider"
    }
    ```

    ```JSON
    // TypeScript
    "Provider": {
      "prefix": "provider",
      "body": [
        "import { Provider, type OnInit, type OnStart } from \"@rbxts/prvdmwrong\"",
        "",
        "@Provider()",
        "export class ${0:$TM_FILENAME_BASE} implements OnInit, OnStart {",
        "  onInit(): void {",
        "",
        "  }",
        "",
        "  onStart(): void {",
        "",
        "  }",
        "}"
      ],
      "description": "Create a new TypeScript provider"
    }
    ```

=== "Output"

    ```Luau
    -- Luau
    local MyProvider = {}
    type Self = typeof(MyProvider)

    function MyProvider.onInit(self: Self)

    end

    function MyProvider.onStart(self: Self)

    end

    return prvd(MyProvider)
    ```

    ```TypeScript
    // TypeScript
    import { Provider, type OnInit, type OnStart } from "@rbxts/prvdmwrong"

    @Provider()
    export class MyProvider implements OnInit, OnStart {
      onInit(): void {

      }

      onStart(): void {

      }
    }
    ```
