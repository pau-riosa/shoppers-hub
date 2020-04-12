defmodule PaymongoExampleWeb.HomeLive.Index do
  use Phoenix.LiveView, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("index.html", assigns)
  end

  def mount(_params, _payload, socket) do
    {:ok, socket}
  end
end
