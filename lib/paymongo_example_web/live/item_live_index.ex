defmodule PaymongoExampleWeb.ItemLive.Index do
  use Phoenix.LiveView, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  alias PaymongoExample.Sales, as: Sales
  alias PaymongoExample.Sales.Item, as: Item

  def render(assigns) do
    PaymongoExampleWeb.ItemView.render("index.html", assigns)
  end

  def mount(_params, _payload, socket) do
    socket =
      assign(
        socket,
        page_title: "Shopper's HUB — Create Item",
        changeset: Sales.change_item(%Item{})
      )

    {:ok, socket}
  end

  def handle_event("validate", %{"item" => params} = _payload, socket) do
    changeset =
      %Item{}
      |> Sales.change_item(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"item" => params} = payload, socket) do
    case Sales.create_item(params) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}

      {:ok, _item} ->
        {:noreply, socket}
    end
  end
end
