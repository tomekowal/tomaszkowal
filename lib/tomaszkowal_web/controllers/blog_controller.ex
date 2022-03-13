defmodule TomaszkowalWeb.BlogController do
  use TomaszkowalWeb, :controller

  alias Tomaszkowal.Blog

  def index(conn, _params) do
    render(conn, "index.html", posts: Blog.published_posts())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", post: Blog.get_post_by_id!(id))
  end
end
