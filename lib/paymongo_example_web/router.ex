defmodule PaymongoExampleWeb.Router do
  use PaymongoExampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug(:put_layout, {PaymongoExampleWeb.LayoutView, :app})
  end

  pipeline :home do
    plug(:put_layout, {PaymongoExampleWeb.LayoutView, :home})
  end

  scope "/", PaymongoExampleWeb do
    pipe_through [:browser, :home]

    get "/", HomeController, :index
    get "/show", HomeController, :show
    get "/pay", HomeController, :new
  end

  scope "/admin", PaymongoExampleWeb do
    pipe_through [:browser, :admin]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PaymongoExampleWeb do
  #   pipe_through :api
  # end
end
