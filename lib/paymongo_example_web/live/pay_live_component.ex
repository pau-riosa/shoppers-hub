defmodule PaymongoExampleWeb.PayLiveComponent do
  @moduledoc """
  Pay Component Live Component
  """
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  def render(assigns) do
    PaymongoExampleWeb.HomeView.render("pay.html", assigns)
  end
end
