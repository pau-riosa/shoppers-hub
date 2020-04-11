defmodule PaymongoExampleWeb.HomeController do
  use PaymongoExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
