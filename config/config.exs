# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :paymongo_example,
  ecto_repos: [PaymongoExample.Repo]

# Configures the endpoint
config :paymongo_example, PaymongoExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F6eUe6/aQkKZCrPUnQbVhRqpx4R5h+8b9ccUYQhyVwN7jfbKD20T4Ziool4B1Iwf",
  render_errors: [view: PaymongoExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PaymongoExample.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "3v05uEYf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
