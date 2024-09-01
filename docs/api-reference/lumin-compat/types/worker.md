<div class="pmwdoc-reference-header">
<h1>Worker</h1>
<span>available since <code>v0.2</code></span>
</div>

=== "Luau"

    ```ts
    export type Worker = {
      Type: WorkerType,
      Callback: (...any) -> (),
      IsWorker: boolean,
    }
    ```

=== "TypeScript"

    ```ts
    export const Worker: <Type extends WorkerType = WorkerType>(
      type: Type,
      callback: (...args: InferWorkerArgs<Type>) => void,
    ) => Worker<Type>
    ```
