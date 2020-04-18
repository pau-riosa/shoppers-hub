use Mix.Config

# Configure your database
config :paymongo_example, PaymongoExample.Repo,
  username: "postgres",
  password: "postgres",
  database: "paymongo_example_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :paymongo_elixir,
  client_key: "pk_test_Jg2EAmhgvccgG9W6fraVZXmt",
  client_secret: "sk_test_925z4jDRU1SAL8gLzgdWUW3e"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :paymongo_example, PaymongoExampleWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
