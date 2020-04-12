defmodule PaymongoExampleWeb.HomeLive.Show do
  use PaymongoExampleWeb, :live

  @amount 16.00
  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("show.html", assigns)
  end

  def mount(params, _payload, socket) do
    socket =
      assign(
        socket,
        value: 1,
        total: @amount,
        amount: @amount,
        payment_type: "",
        page_title: "Shopper's HUB — #{String.upcase(params["slug"])} "
      )

    {:ok, socket}
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
