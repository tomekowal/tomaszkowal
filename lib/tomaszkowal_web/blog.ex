defmodule TomaszkowalWeb.Blog do
  @moduledoc """
  The blogging platform made according to [Dashbit's blog post](https://dashbit.co/blog/welcome-to-our-blog-how-it-was-made)

  It was intentionally moved to "web layer" because of CSS.
  The full HTML is compiled by NimblePublisher.
  Since I experiment with Tailwind, I wanted to add CSS classes to the HTML source.
  I wanted to keep CSS stuff in web and there is no way of doing dependency injection at compile time.

  The epiphany was that I can keep `Post` in the core because it is pure data
  but the module defining `NimblePublisher` needs to be in "web layer".

  And it makes sense, since it deals with HTML.
  """
  alias Tomaszkowal.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:tomaszkowal, "priv/posts/**/*.md"),
    as: :posts,
    earmark_options: %Earmark.Options{postprocessor: &TomaszkowalWeb.BlogView.postprocess/1},
    highlighters: [:makeup_elixir, :makeup_erlang]

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def published_posts, do: Enum.filter(all_posts(), &(&1.published == true))

  def all_tags, do: @tags

  defmodule NotFoundError, do: defexception([:message, plug_status: 404])

  def get_post_by_id!(id) do
    Enum.find(all_posts(), &(&1.id == id)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end

  def get_posts_by_tag!(tag) do
    case Enum.filter(all_posts(), &(tag in &1.tags)) do
      [] -> raise NotFoundError, "posts with tag=#{tag} not found"
      posts -> posts
    end
  end
end
