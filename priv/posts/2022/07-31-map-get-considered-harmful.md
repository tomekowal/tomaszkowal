%{
  title: "Map.get/2 considered harmful",
  author: "Tomasz Kowal",
  tags: ~w(elixir),
  description: "Why not to use Map.get/2 and what to do instead",
  published: true
}
---
I often take a three-step approach when a bug sneaks into a codebase.

1. Fix the immediate bug
2. Sweep the codebase for more occurrences
3. Try to prevent this class of bugs.

Recently I've found a bug that caused 500 HTTP errors instead of 400 on missing parameters. The stack trace was very, very long.

I dug into it and found that we passed `nil` somewhere deep down the stack where we expected a string value. But the actual problem was much higher in the controller:

```elixir
field = Map.get(params, "field")
Conext.do_stuff(..., field, ...)
```

The problem with `Map.get/2` is that it doesn't enforce that the field exists, and we pass `nil` down the stack. There are other issues with this code:
- we could parse parameters with schemaless changeset to enforce also the type
- we could use guards in the context code
- even using `Map.fetch!/2` would speed up debugging because the stack trace would be smaller

I think that `get` is such a common verb in programming that we use it without thinking. I am guilty of it myself. During my career, I've seen many examples where programmers used `Map.get/2` instead of other access functions. During step two of my three-step approach, I've found that it is also pretty frequent in our codebases.

Step three got me thinking. How can we automatically detect if `Map.get/2` really expects `nil` values?

We decided to *ban it completely* with a credo check.

If someone expects `nil` as a default, it is easy to show by using `Map.get(map, field, nil)`. In all other cases, using `fetch` with and without `!` seems a better idea.

There is more! This pattern also applies to `Keyword.get/2`, `System.get_env/1` and `Application.get_env/2`. I'd rather crash on startup if I forgot to pass environment variables/set config values. Most deployment pipelines start the new instances and check their health before shutting down the old ones. I want to crash then and there instead of starting up a half-working service.

I want to publish the credo check when I complete it. Follow me on [Twitter](https://twitter.com/snajper47) if you don't want to miss it.
