defmodule PaymongoExampleWeb.WebhookController do
  use PaymongoExampleWeb, :controller

  alias PaymongoExample.Sales

  def webhooks(conn, params) do
    with params <- event_params(params),
         {:ok, _data} <- Sales.create_webhook(params) do
      conn
      |> put_status(:created)
      |> render("webhooks.json", data: params)
    end
  end

  defp event_params(params) do
    %{
      "event_id" => params["data"]["id"],
      "data" => params
    }
  end
end
