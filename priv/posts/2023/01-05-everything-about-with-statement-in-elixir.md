%{
  author: "Tomasz Kowal",
  description: "A collection of best practices for `with` statements in Elixir",
  title: "Everything about `with` statement in Elixir",
  tags: ["elixir"],
  published: true
}
---

`With` statement in Elixir is one of the most elegant solutions to an age-old problem of chaining computations that can fail.
It was so good that Erlang copied it, calling it `maybe`. 
However, with power comes great responsibility.

In this post, I'll gather some tips, tricks and pitfalls.

I won't go into details about how it works because the [official documentation](https://hexdocs.pm/elixir/Kernel.SpecialForms.html#with/1) does an excellent job.
  
### With chaining

Saša Jurić wrote a fantastic series of blog posts titled "Towards Maintainable Elixir". In one of the articles ["The Anatomy of a Core Module"](https://medium.com/very-big-things/towards-maintainable-elixir-the-anatomy-of-a-core-module-b7372009ca6d), he introduces the concept of *with chaining*.

He introduces some helper functions that make using `with` super-readable.

```elixir
def validate(true, _error_reason), do: :ok
def validate(false, error_reason), do: {:error_reason}

def authorize(condition), do: validate(condition, :unauthorized)

def fetch(queryable, id) do
  case Repo.get(queryable, id) do
    nil -> {:error, :not_found}
    record -> {:ok, record}
  end
end

def edit_post(post_id, editor, title, body) d
  with {:ok, post} <- Repo.fetch(Post, post_id),
       :ok <- authorize(post.authorid_id == editor.id or editor.role in [:moderator, :admin]),
       do: store_post(post, title, body)
end
```

You can find example usages in the article. The main idea is that small, generic helper functions improve the clarity of the `with` statement.

### Problems with `else` block

Chris Keathley made an excellent blog post on Elixir's best practices ["Good and Bad Elixir"](https://keathley.io/blog/good-and-bad-elixir.html). One of the sections is "Avoid `else` in `with` blocks".

"Tagging" the calls using a tuple to understand where the error is coming from makes it unreadable. The problem is that if your `else` part has multiple clauses, it is hard to know which call in the `do` block matches which `else` clause. Chris provides examples in his blog post.

### How to provide rich errors?

Chris, in his blog, wants to avoid `else` part totally, but I find it is excellent for *unifying* error handling. I wouldn't avoid it, but I would ensure it has only *one clause* for all errors.

```elixir
  def parse_datetime(unvalidated_datetime) do
    with :ok <-
           validate(
             is_binary(unvalidated_datetime),
             "Error parsing date_time, expected a string but got: #{inspect(unvalidated_datetime)}"
           ),
         {:ok, date_time, _} <-
           DateTime.from_iso8601(unvalidated_datetime)
           |> adjust_error(&"Error parsing #{unvalidated_datetime}: #{inspect(&1)}") do
      {:ok, date_time}
    else
      {:error, reason} ->
        Logger.error(reason)
        {:error, :invalid_datetime}
    end
  end

  defp validate(true, _error_reason), do: :ok
  defp validate(false, error_reason), do: {:error, error_reason}

  defp adjust_error({:error, error}, error_fn), do: {:error, error_fn.(error)}
  defp adjust_error(other, _), do: other
```

Handling the errors in the `else` clause would prevent creating rich error messages. E.g. `DateTime.from_iso/1` without the `adjust_error` would return `{:error, :invalid_format}`, and we wouldn't be able to log what the unparsable input was.

We could return the error atom and the message or, as Chris suggests in his article, an error struct.

The point is that both `validate/2` and `adjust_error/2` start the error handling process inside the `do` block, where we still have the entire context of failure.

In pseudo-code:

```elixir
with ok_pattern <- operation |> error_handling do
```

It seems a little lengthy initially, but it is pretty nice to read and debug. `validate/2` reads like English prose and piping is not intrusive when it is in a separate line:

```elixir
         {:ok, date_time, _} <-
           DateTime.from_iso8601(unvalidated_datetime)
           |> adjust_error(&"Error parsing #{unvalidated_datetime}: #{inspect(&1)}")
```

### Early return

We shouldn't forget that the `with` statement is not only an error monad. In many cases, it is helpful to finish computation early even if there were no errors.

```elixir
def delete_post(post_id) d
  with {:ok, post} <- Repo.fetch(Post, post_id),
       :continue <- return_early_if_deleted(post),
       {:ok, post} <- do_delete(post),
       :ok <- broadcast(:post_deleted, post) do
    {:ok, post}
  else
    {:early_return, post} -> {:ok, post}
    {:error, reason} -> {:error, reason}
  end
end

def return_early_if_deleted(%Post{deleted_at: nil}), do: :continue
def return_early_if_deleted(%Post{} = post), do: {:early_return, post}
```

The main flow is still readable and explicitly shows where it can stop and return early.

### Bonus, feel free to ignore credo

Credo has a rule to rewrite a single-clause `with` statements into a `case`.
That's a great rule when teaching juniors to use the simplest solution to a problem.

In practice, I've found that my modules are either "pure" using mainly `|>` operator inside functions or "impure" and then using mostly `with`.
I like to keep those functions similar for consistency, as I explained on [elixir forum](https://elixirforum.com/t/readability-of-single-clause-with-statements/52411/5?u=tomekowal)

In the following module, credo would like to refactor the `c` function into a `case` statement.

```elixir
defmodule A do
  def a do
    with {:ok, a} <- do_a(),
      {:ok, b} <- do_b() do
      {:ok, b}
    end
  end

  def b do
    with {:ok, c} <- do_c(),
      {:ok, d} <- do_d() do
      {:ok, d}
    end
  end

  def c do
    with {:ok, e} <- do_e() do
      {:ok, e}
    end
  end
end
```

### Summary

To sum up:
- the `with` statement is excellent at glueing computations
- *with chaining* requires defining some helper functions, but it pays off with increased clarity
- it is ok to handle errors inside the `with ... do` block `with ok_pattern <- operation |> error_handling do` to keep the `else` part lean
- the main benefit of using the `with` statement is jumping out of the pipeline early - not only in an error case
- `with` statements are complex enough that they deserve to be the only statement in a function
