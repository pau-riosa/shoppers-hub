defmodule PaymongoExampleWeb.Admin.DashboardLive do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveView

  def render(assigns) do
    PaymongoExampleWeb.Admin.DashboardView.render("index.html", assigns)
  end

  def mount(_params, _payload, socket) do
    {:ok,
     assign(socket,
       list_of_transactions: list_of_transactions()
     )}
  end

  defp list_of_transactions do
    %{"data" => data} = PaymongoElixir.list(:list_payments)
    parse_data(data)
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
