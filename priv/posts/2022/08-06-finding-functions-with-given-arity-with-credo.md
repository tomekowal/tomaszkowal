%{
  title: "Finding functions with given arity with Credo",
  author: "Tomasz Kowal",
  tags: ~w(elixir),
  description: "Finding functions with given arity seems to be a deceptively simple task. However, the pipe operator makes it complicated. Learn problems with pipe's AST and their solutions.",
  published: true
}
---
Have you ever started a task thinking it is simple and been surprised that it wasn't that easy?

I've recently tried writing a [Credo](https://hexdocs.pm/credo/overview.html) check that reports usages of functions with specific *arity*. There are two non-obvious problems with that task.
- In pipes, function with arity n appears as arity n-1
- Even if you detect "function in a pipe" case, `Macro.prewalk` will recursively descend on each subexpression, showing function with arity n-1 without context

Let's say we want to detect all occurrences of `Map.get/2` in our credo check and report them. Credo has excellent documentation for [Adding Custom Checks](https://hexdocs.pm/credo/adding_checks.html). It boils down to implementing `run/2` function that will usually call `Credo.Code.prewalk/2`. The `prewalk` function will get a custom `traverse` function as an argument. That `traverse` is where the magic happens.

The `Credo.Code.prewalk` function works exactly like `Macro.prewalk/3` with reordered arguments. The spec of `traverse` function looks like this:

```
traverse(ast, accumulator) :: {new_ast, new_accumulator}
```

So the first step is to match on an AST of function invocation. We can get a glimpse of how it would look like by quoting the expression in `iex`

```elixir
iex(1)> quote do Map.get(map, key) end
{{:., [], [{:__aliases__, [alias: false], [:Map]}, :get]}, [],
 [
   {:map, [if_undefined: :apply], Elixir},
   {:key, [if_undefined: :apply], Elixir}
 ]}
```

Let's unwrap what we see here. Most AST fragments have a tuple structure: `{operation, metadata, arguments}`. We can see this pattern twice for function invocation:

```elixir
{:., [], [{:__aliases__, [alias: false], [:Map]}, :get]}
```

In this tuple, the operation is `.` (the colon in `:.` indicates it is an atom). There is no metadata (because we've invoked it in `iex`), and there are two parameters:
- module name `{:__aliases__, [alias: false], [:Map]}`
* function name

The entire "dot AST" becomes an operation for the outer "function invocation AST".

```elixir
{dot_ast, [], [
 {:map, [if_undefined: :apply], Elixir},
 {:key, [if_undefined: :apply], Elixir}
]
```

The operation is now `Map.get`, then an empty list of metadata and two parameters.

To match `Map.get/2`, we need to write the pattern match:

```elixir
defp traverse(
	 {{:., _, [{:__aliases__, meta, [:Map]}, :get]}, _, params} = ast, ...)
	 when length(params) == 2 do
```

That works with direct invocations of `Map.get(map, key)`, but it won't catch `map |> Map.get(key)`.
Let's inspect the AST.

```
iex(2)> quote do map |> Map.get(key) end
{:|>, [context: Elixir, import: Kernel],
 [
   {:map, [if_undefined: :apply], Elixir},
   {{:., [], [{:__aliases__, [alias: false], [:Map]}, :get]}, [],
    [{:key, [if_undefined: :apply], Elixir}]}
 ]}
```
Again, we can see the three element tuples with `{operation, metadata, arguments}`.
For the pipe operator, we have:
`{:|>, metadata, [before_pipe, after_pipe]}`

The `before_pipe` is the variable `map`.
The `after_pipe` looks like a function invocation but with only one parameter! `Map.get/1` Our initial solution would miss that.

We will need another pattern match for `:|>` operator where the second argument is our function invocation. We don't really care about the first argument.

If we have `Map.get/2` in the first argument, `Map.get(map, key) |> do_stuff()`, we will catch it when descending recursively in the AST.

If we have `Map.get/1` in the middle of the pipe chain `map |> Map.get(key) |> do_stuff`, the AST looks like this.

```elixir
{
  second_pipe,
  _,
  [
    {
      first_pipe,
      _,
      [
        map_variable,
        map_get_invocation
      ]
    },
    do_stuff_invocation
  ]
}
```

The pipe operator is right-associative, and pipes are nested in reverse order. That's good news for us. Our `Map.get/1` can only happen in the second param of `|>` because the first is either regular code or a previous pipe.

Let's match that in two steps:

```
  defp traverse({:|>, pipe_meta, [before_pipe, after_pipe]}, ...) do
    case after_pipe do
      {{:., dot_meta, [{:__aliases__, module_meta, [:Map]}, :get]}, function_meta, params} when length(params) == 1 ->
        ...
```

The last problem is if someone used `Map.get/3` inside a pipe, the `prewalk` function would see it as `Map.get/2`, returning false positives. E.g.

```elixir
map
|> Map.get(key, default)
```

The traverse function would first match on `{:|>, _, map, map_get_2}`, and we would correctly skip it. But later, it would descend recursively on `map_get_2`, and at that point, we would have no way of knowing if we were in a pipe or not.

Thankfully, `traverse` returns `{modified_ast, accumulator}`. One solution would be to return an AST with a modified module name. When we match inside the pipe on:

```elixir
{{:., dot_meta, [ {:__aliases__, module_meta, [:Map]}, :get]}, function_meta, params}
```

 we could return modified AST

```elixir
{{:., dot_meta, [{:__aliases__, module_meta, [:ALREADY_CHECKED]}, :get]}, function_meta, params} 
```

every time we are in a pipe.

This will prevent matching those modules in recursive calls when we've already lost the information if we are in the pipe.

To sum up. We've used two tricks to match function invocations with given arity:
1. Match on pipes where the second parameter is the function with n-1 arity.
2. Modifying the module's name to ensure we don't return false positives when we recursively descend inside the pipe.

If you've found it helpful, consider following me on [Twitter](https://twitter.com/snajper47)
