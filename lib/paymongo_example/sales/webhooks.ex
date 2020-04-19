defmodule PaymongoExample.Sales.Webhook do
  @moduledoc """
  Webhooks schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "webhooks" do
    field :event_id, :string
    field :data, :map

    timestamps()
  end

  @doc false
  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:event_id, :data])
  end
end
