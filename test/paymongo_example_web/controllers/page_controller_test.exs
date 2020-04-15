defmodule PaymongoExampleWeb.PageControllerTest do
  use PaymongoExampleWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "SHOPPER'S HUB"
  end
end
