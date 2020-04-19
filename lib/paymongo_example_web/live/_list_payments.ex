defmodule PaymongoExampleWeb.ListPaymentsLive do
  @moduledoc """
  Home Live index
  """
  use Phoenix.LiveComponent, layout: {PaymongoExampleWeb.LayoutView, "live.html"}
  alias PaymongoExampleWeb.Admin.DashboardView

  def render(assigns) do
    DashboardView.render("_list_of_payments.html", assigns)
  end
end
