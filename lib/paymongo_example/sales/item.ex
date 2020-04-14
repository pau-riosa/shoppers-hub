defmodule PaymongoExample.Sales.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :description, :string
    field :name, :string
    field :avatar, :string
    field :price, :integer
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :slug])
    |> validate_required([:name, :description, :price, :slug])
  end
end
