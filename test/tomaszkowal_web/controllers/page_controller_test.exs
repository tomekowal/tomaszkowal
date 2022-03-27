defmodule TomaszkowalWeb.PageControllerTest do
  use TomaszkowalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Old blog"
  end
end
