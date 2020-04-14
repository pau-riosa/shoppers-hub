defmodule PaymongoExample.Sales.Item do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "items" do
    field :description, :string
    field :name, :string
    field :avatar, PaymongoExample.Photo.Type
    field :price, :integer
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :slug])
    |> generate_id()
    |> cast_attachments(attrs, [:id, :avatar])
    |> validate_required([:name, :description, :price, :slug])
  end

  def generate_id(changeset) do
    if get_field(changeset, :id) do
      changeset
    else
      put_change(changeset, :id, Ecto.UUID.generate())
    end
  end
end
