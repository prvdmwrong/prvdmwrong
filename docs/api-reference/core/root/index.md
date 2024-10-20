<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

# Root

Roots are entry points to Prvd 'M Wrong games. Use roots to include
providers to be started, modules to be required, lifecycles to be
registered, and even "sub" roots to be started. Call `start` to
bootstrap the root. Later, call `stop` to clean up the root.

```Luau
local function filterByPattern(pattern: string)
    return function(module: ModuleScript): boolean
        return module:find(pattern) ~= nil
    end
end

-- roots are entry points for Prvd 'M Wrong games!
local root = prvd.root()
    :useModules(script.Providers:GetDescendants(), filterByPattern("Provider$"))
    :useModules(ReplicatedStorage.Providers:GetDescendants(), filterByPattern("Provider$"))
    :useProvider(prvdLifecycles)
    :useRoot(prvd.netRoot)
    :useRoot(prvd.componentRoot)
    :start()

-- later...
game:BindToClose(function()
    root:stop()
end)
```
    

<section class="prvdmwrong-api-items">
  <section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/destroy">
      destroy
    </a>
    <i>No description provided.</i>
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/start">
      start
    </a>
    Starts the root. This should only be called once per root.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/uselifecycle">
      useLifecycle
    </a>
    Uses the lifecycle as a dependency. When the root is started, all providers
with the lifecycle's method will have it registered.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/uselifecycles">
      useLifecycles
    </a>
    Given an array of lifecycles, uses all lifecycles as dependencies. When the
root is started, all providers with each lifecycle's method will have it
registered.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/usemodule">
      useModule
    </a>
    Requires a ModuleScript and adds the returned provider to the root, if any.
If the provider is unnamed, the provider is named after the ModuleScript
name.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/usemodules">
      useModules
    </a>
    Given an array of instances, requires all ModuleScripts and adds the
returned provider to the root, if any. If the provider is unnamed, the
provider is named after the ModuleScript name. An optional predicate
function can be provided to filter the modules.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/useprovider">
      useProvider
    </a>
    Uses the provider to be initialized when the root starts. When the root is
started, used providers are resolved in topological loading order while
lifecycles in the providers are added as dependencies to be registered.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/useproviders">
      useProviders
    </a>
    Given an array of providers, uses all providers to the root. When the root is
started, used providers are resolved in topological loading order while
lifecycles in providers are added as dependencies to be registered.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/useroot">
      useRoot
    </a>
    Uses the given "sub" root to be started when the "parent" root is started.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="root/functions/useroots">
      useRoots
    </a>
    Given an array of "sub" roots, uses all roots to be started when the
"parent" root is started.
  </section>
</section>

</section>
