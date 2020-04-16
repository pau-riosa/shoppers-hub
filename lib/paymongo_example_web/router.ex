defmodule PaymongoExampleWeb.Router do
  use PaymongoExampleWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug(:put_layout, {PaymongoExampleWeb.LayoutView, :admin})
  end

  pipeline :root do
    plug(:put_root_layout, {PaymongoExampleWeb.LayoutView, :root})
  end

  scope "/", PaymongoExampleWeb do
    pipe_through [:browser, :root]

    live "/", HomeLive.Index, as: :home_index
    live "/:slug/show", HomeLive.Show, as: :home_show
    # live "/items", ItemLive.Index, as: :item_index
  end

  scope "/admin", PaymongoExampleWeb.Admin do
    pipe_through [:browser, :root, :admin]

    if Mix.env() == :dev do
      scope "/" do
        live_dashboard "/dashboard"
      end
    end

    get "/", PageController, :index
    resources "/items", ItemController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PaymongoExampleWeb do
  #   pipe_through :api
  # end
end
