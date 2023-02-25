defmodule TomaszkowalWeb.BlogController do
  use TomaszkowalWeb, :controller

  alias TomaszkowalWeb.Blog

  def index(conn, %{"tag" => tag}) do
    render(conn, "index.html", posts: Blog.get_posts_by_tag!(tag), tags: Blog.all_tags())
  end

  def index(conn, _params) do
    render(conn, "index.html", posts: Blog.published_posts(), tags: Blog.all_tags())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", post: Blog.get_post_by_id!(id))
  end
end
