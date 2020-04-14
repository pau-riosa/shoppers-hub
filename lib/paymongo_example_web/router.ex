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

  pipeline :admin do
    plug(:put_layout, {PaymongoExampleWeb.LayoutView, :app})
  end

  pipeline :root do
    plug(:put_root_layout, {PaymongoExampleWeb.LayoutView, :root})
  end

  scope "/", PaymongoExampleWeb do
    pipe_through [:browser, :root]

    live "/", HomeLive.Index, as: :home_index
    live "/:slug/show", HomeLive.Show, as: :home_show
    # live "/items", ItemLive.Index, as: :item_index
    resources "/items", ItemController
  end

  # scope "/admin", PaymongoExampleWeb do
  #   pipe_through [:browser, :admin]

  #   get "/", PageController, :index
  # end

  # Other scopes may use custom stacks.
  # scope "/api", PaymongoExampleWeb do
  #   pipe_through :api
  # end
end
