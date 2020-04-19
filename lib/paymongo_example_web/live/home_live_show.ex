defmodule PaymongoExampleWeb.HomeLive.Show do
  @moduledoc """
  Home Live Show
  """
  use PaymongoExampleWeb, :live

  alias PaymongoExample.Sales, as: Sales
  alias PaymongoExample.Services.Card, as: Card
  alias PaymongoExample.Services.Source, as: Source

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("show.html", assigns)
  end

  def mount(params, _payload, socket) do
    item = Sales.get_item_by!(params["slug"])

    {:ok,
     assign(
       socket,
       %{
         value: 1,
         total: item.price,
         amount: item.price,
         payment_type: "",
         page_title: "Shopper's HUB — #{String.upcase(params["slug"])}",
         changeset: Card.new(),
         item: item
       }
     )}
  end

  def handle_info("modal-close", socket) do
    {:noreply, assign(socket, :payment_type, "")}
  end

  def handle_event("validate", %{"card_payment" => params} = _payload, socket) do
    case Card.validate_inputs(params) do
      %Ecto.Changeset{} = changeset ->
        {:noreply, assign(socket, :changeset, changeset)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("save", %{"card_payment" => params} = _payload, socket) do
    case Card.submit(params) do
      %Ecto.Changeset{} = changeset ->
        {:noreply, assign(socket, :changeset, changeset)}

      {:error, errors} ->
        send(self(), "modal-close")

        {:noreply,
         socket
         |> put_flash(:error, errors)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:notice, "successfully submitted.")
         |> redirect(to: Routes.home_index_path(socket, PaymongoExampleWeb.HomeLive.Index))}
    end
  end

  def handle_event("save", %{"ewallet" => params} = _payload, socket) do
    case Source.create_source(params) do
      {:error, errors} ->
        send(self(), "modal-close")

        {:noreply,
         socket
         |> put_flash(:error, errors)}

      {:ok, data} ->
        {:noreply,
         socket
         |> put_flash(:notice, "successfully submitted.")
         |> redirect(external: data["attributes"]["redirect"]["checkout_url"])}
    end
  end

  def handle_event("modal-close", _payload, socket) do
    {:noreply, assign(socket, :payment_type, "")}
  end

  # if payment type value is grab or gcash generate payment
  def handle_event("modal-open", %{"value" => value} = _payload, socket) do
    {:noreply, assign(socket, payment_type: value)}
  end

  def handle_event("change-value", %{"value" => value} = _payload, socket) when value != "" do
    value = String.to_integer(value)
    total = value * socket.assigns.amount
    {:noreply, assign(socket, value: value, total: total)}
  end

  def handle_event("change-value", _payload, socket),
    do: {:noreply, assign(socket, value: 0, total: 0.0)}

  def handle_event("add_quantity", _payload, socket) do
    value = socket.assigns.value + 1
    total = value * socket.assigns.amount
    {:noreply, assign(socket, value: value, total: total)}
  end

  def handle_event("min_quantity", _payload, socket) do
    if socket.assigns.value == 0 do
      {:noreply, socket}
    else
      value = socket.assigns.value - 1
      total = value * socket.assigns.amount
      {:noreply, assign(socket, value: value, total: total)}
    end
  end
end
