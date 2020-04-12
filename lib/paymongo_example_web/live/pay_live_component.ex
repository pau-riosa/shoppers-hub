defmodule PaymongoExampleWeb.PayLiveComponent do
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("pay.html", assigns)
  end

  def mount(_params, _payload, socket) do
    {:ok, socket}
  end
end
