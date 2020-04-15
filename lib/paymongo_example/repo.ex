defmodule PaymongoExample.Repo do
  @moduledoc """
  Paymongo Elixir Repo
  """
  use Ecto.Repo,
    otp_app: :paymongo_example,
    adapter: Ecto.Adapters.Postgres
end
