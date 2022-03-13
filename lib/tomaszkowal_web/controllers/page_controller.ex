defmodule TomaszkowalWeb.PageController do
  use TomaszkowalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
