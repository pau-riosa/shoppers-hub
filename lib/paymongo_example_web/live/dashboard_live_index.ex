defmodule PaymongoExampleWeb.Admin.DashboardLive do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveView
  alias PaymongoExample.Sales
  alias PaymongoExampleWeb.Admin.DashboardView

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def mount(_params, _payload, socket) do
    Sales.subscribe()
    {:ok, fetch(socket)}
  end

  def handle_info({Sales, [:item | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket,
      list_of_transactions: list_of_transactions()
    )
  end

  defp list_of_transactions do
    with %{"data" => data} <- PaymongoElixir.list(:list_payments),
         data <- parse_data(data) do
      data
    else
      {:error, errors} ->
        errors
    end
  end

  defp parse_data(data) do
    Enum.map(data, fn f ->
      %{
        payment_method: f["attributes"]["source"]["type"],
        payment_status: f["attributes"]["status"],
        amount: f["attributes"]["amount"] |> parse_amount(),
        description: f["attributes"]["description"],
        paid_at: f["attributes"]["paid_at"] |> parse_date()
      }
    end)
  end

  defp parse_date(unix), do: unix |> DateTime.from_unix!()
  defp parse_amount(amount), do: amount / 100
end
