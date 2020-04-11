defmodule PaymongoExample.Repo do
  use Ecto.Repo,
    otp_app: :paymongo_example,
    adapter: Ecto.Adapters.Postgres
end
