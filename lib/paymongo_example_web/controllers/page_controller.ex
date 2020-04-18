defmodule PaymongoExampleWeb.Admin.PageController do
  use PaymongoExampleWeb, :controller

  def index(conn, _params) do
    live_render(conn, PaymongoExampleWeb.Admin.DashboardLive)
  end
end
