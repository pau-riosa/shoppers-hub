defmodule PaymongoExampleWeb.HomeController do
  use PaymongoExampleWeb, :controller

  def new(conn, _params) do
    render(conn, "_payment_form.html")
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
