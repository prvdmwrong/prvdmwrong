<div class="pmwdoc-reference-header">
<h1>Expect</h1>
<span>available since <code>v0.2</code></span>
</div>

As Prvd 'M Wrong does not follow Lumin Framework's expectation model, this
function simply returns the given controller.

=== "Luau"

    ```ts
    function Controller<T>(
      controller: Provider<T>
    ): Provider<T>
    ```

=== "TypeScript"

    ```ts
    export const Controller: <T extends object>(
      controller: Provider<T>
    ) => Provider<T>
    ```

## Parameters

### controller `#!lua : Provider<T>`

The controller to be expected.

## Returns

The given controller.
