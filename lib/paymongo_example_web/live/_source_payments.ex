defmodule PaymongoExampleWeb.SourcePaymentLive do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveComponent
  alias PaymongoExample.Sales
  alias PaymongoExample.Services.Source

  def render(assigns) do
    PaymongoExampleWeb.Admin.DashboardView.render("_list_of_source.html", assigns)
  end

  def handle_event("accept-payment", %{"value" => event_id} = _payload, socket) do
    event_id
    |> Sales.get_webhook_by_event_id!()
    |> Source.submit()
    |> case do
      {:ok, _data} ->
        {:noreply,
         socket
         |> put_flash(:notice, "payment accepted successfully.")
         |> redirect(to: "/admin")}

      {:error, errors} ->
        {:noreply,
         socket
         |> put_flash(:errors, "#{errors}")
         |> redirect(to: "/admin")}
    end
  end
end
