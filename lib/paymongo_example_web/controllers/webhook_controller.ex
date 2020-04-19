defmodule PaymongoExampleWeb.WebhookController do
  use PaymongoExampleWeb, :controller

  def webhooks(conn, params) do
    conn
    |> put_status(:created)
    |> render("webhooks.json", data: params)
  end
end
