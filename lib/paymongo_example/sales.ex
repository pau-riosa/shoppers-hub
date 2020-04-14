defmodule PaymongoExample.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias PaymongoExample.Repo

  alias PaymongoExample.Sales.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)
  def get_item_by!(params), do: Repo.get_by!(Item, slug: params)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:item, :created])
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:item, :updated])
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    item
    |> Repo.delete()
    |> broadcast_change([:item, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item, params \\ %{}) do
    Item.changeset(item, params)
  end

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(PaymongoExample.PubSub, @topic)
  end

  def broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(PaymongoExample.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end
end
