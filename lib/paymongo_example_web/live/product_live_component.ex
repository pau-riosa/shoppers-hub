defmodule PaymongoExampleWeb.ProductLiveComponent do
  @moduledoc """
  Display product list components
  """
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}
  alias PaymongoExample.Sales

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("_products.html", assigns)
  end

  def update(assigns, socket) do
    products = Sales.list_items()
    {:ok, assign(socket, :products, products)}
  end
end
