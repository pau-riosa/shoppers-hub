defmodule PaymongoExampleWeb.ProductLiveComponent do
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("_products.html", assigns)
  end
end
