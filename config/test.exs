use Mix.Config

# Configure your database
config :paymongo_example, PaymongoExample.Repo,
  username: "postgres",
  password: "postgres",
  database: "paymongo_example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :paymongo_elixir,
  client_key: System.get_env("PAYMONGO_PUBLIC_KEY"),
  client_secret: System.get_env("PAYMONGO_SECRET_KEY")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :paymongo_example, PaymongoExampleWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
