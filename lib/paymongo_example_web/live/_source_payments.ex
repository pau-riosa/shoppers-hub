defmodule PaymongoExampleWeb.SourcePaymentLive do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}

  def render(assigns) do
    PaymongoExampleWeb.Admin.DashboardView.render("_list_of_source.html", assigns)
  end
end
