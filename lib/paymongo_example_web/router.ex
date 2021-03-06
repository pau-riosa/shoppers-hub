defmodule PaymongoExampleWeb.Router do
  use PaymongoExampleWeb, :router

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

  pipeline :app do
    plug(:put_layout, {PaymongoExampleWeb.LayoutView, :app})
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
  end

  scope "/", PaymongoExampleWeb do
    pipe_through [:browser, :root, :app]
    get "/:payment_type/success", RedirectController, :success
    get "/:payment_type/failed", RedirectController, :failed
  end

  scope "/admin", PaymongoExampleWeb.Admin do
    pipe_through [:browser, :root, :admin]

    if Mix.env() == :dev do
      scope "/" do
        live_dashboard "/dashboard"
      end
    end

    get "/", PageController, :index
    live "/live-dashboard", DashboardLive, as: :dashboard
    resources "/items", ItemController
  end

  # Other scopes may use custom stacks.
  scope "/api", PaymongoExampleWeb do
    pipe_through :api
    post "/shoppers-hub-webhooks", WebhookController, :webhooks
  end
end
