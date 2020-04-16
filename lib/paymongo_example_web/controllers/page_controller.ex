defmodule PaymongoExampleWeb.Admin.PageController do
  use PaymongoExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
