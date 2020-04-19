defmodule PaymongoExampleWeb.WebhookView do
  use PaymongoExampleWeb, :view

  def render("webhooks.json", %{data: data}) do
    data
  end
end
