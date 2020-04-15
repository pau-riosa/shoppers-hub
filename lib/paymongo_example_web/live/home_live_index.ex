defmodule PaymongoExampleWeb.HomeLive.Index do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveView, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  alias PaymongoExample.Sales

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("index.html", assigns)
  end

  def mount(_params, _payload, socket) do
    Sales.subscribe()

    {:ok, fetch(socket)}
  end

  def handle_info({Sales, [:item | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, products: Sales.list_items())
  end
end
