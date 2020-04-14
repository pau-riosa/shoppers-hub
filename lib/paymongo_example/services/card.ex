defmodule PaymongoExample.Services.Card do
  import Ecto.Changeset

  @schema %{
    card_number: :string,
    expiration_month: :integer,
    expiration_year: :integer,
    cvc: :string
  }

  def new do
    cast(%{})
  end

  def submit(params) do
    case process_params(params) do
      {:ok, data} ->
        IO.inspect("Processing payment...")
        data

      {:error, changeset} ->
        IO.inspect("Error processing payment...")
        changeset
    end
  end

  @required_fields ~w(card_number expiration_month expiration_year cvc)a
  defp validate(changeset) do
    changeset
    |> validate_required(@required_fields)
  end

  defp process_params(params) do
    params
    |> cast()
    |> validate()
    |> apply_action(:insert)
  end

  defp cast(params) do
    data = %{}

    empty_map =
      Map.keys(@schema)
      |> Enum.reduce(%{}, fn key, acc ->
        Map.put(acc, key, nil)
      end)

    changeset = {data, @schema} |> Ecto.Changeset.cast(params, Map.keys(@schema))
    put_in(changeset.changes, Map.merge(empty_map, changeset.changes))
  end
end
