defmodule PaymongoExample.Services.Card do
  @moduledoc """
  checking of form_inputs for card
  """
  import Ecto.Changeset
  alias PaymongoExample.Sales

  @schema %{
    amount: :integer,
    description: :string,
    card_number: :string,
    expiration_month: :integer,
    expiration_year: :integer,
    cvc: :string
  }

  def new do
    cast(%{})
  end

  def validate_inputs(params) do
    case process_params(params) do
      {:ok, data} ->
        data

      {:error, changeset} ->
        changeset
    end
  end

  def submit(params) do
    with {:ok, data} <- process_params(params),
         %{"attributes" => _data} <- initialize_payment(data) do
      {:ok, data}
      |> Sales.broadcast_change([:item, :paid])
    else
      {:error, [_ | _] = errors} ->
        {:error, parse_paymongo_error(errors)}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset
    end
  end

  defp parse_paymongo_error(errors) do
    error =
      errors
      |> List.first()

    "#{error["detail"]}"
  end

  defp initialize_payment(params) do
    with pi_params <- payment_intent_params(params),
         %{"data" => pi_data} <- PaymongoElixir.post(:create_payment_intent, pi_params),
         pm_params <- payment_method_params(params),
         %{"data" => pm_data} <-
           PaymongoElixir.post(:create_payment_method, pm_params),
         ap_params <- attach_payment_params(pi_data, pm_data),
         %{"data" => data} <- PaymongoElixir.post(:attach_payment_intent, ap_params) do
      data
    end
  end

  defp attach_payment_params(pi_params, pm_params) do
    query_params = %{
      "id" => pi_params["id"],
      "client_key" => pi_params["attributes"]["client_key"]
    }

    body_params = %{
      "data" => %{
        "attributes" => %{
          "payment_method" => pm_params["id"]
        }
      }
    }

    %{
      "query_params" => query_params,
      "body_params" => body_params
    }
  end

  defp payment_intent_params(params) do
    %{
      "data" => %{
        "attributes" => %{
          "amount" => params[:amount] * 100,
          "payment_method_allowed" => ["card"],
          "currency" => "PHP",
          "description" => params[:description]
        }
      }
    }
  end

  defp payment_method_params(params) do
    %{
      "data" => %{
        "attributes" => %{
          "type" => "card",
          "details" => %{
            "card_number" => params[:card_number],
            "exp_month" => params[:expiration_month],
            "exp_year" => params[:expiration_year],
            "cvc" => params[:cvc]
          }
        }
      }
    }
  end

  @required_fields ~w(amount description card_number expiration_month expiration_year cvc)a

  defp validate(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_length(:card_number, is: 16, message: "invalid length of card number.")
    |> validate_length(:cvc, max: 3, min: 3, message: "invalid length of cvc.")
    |> validate_change(:expiration_year, fn :expiration_year, input_year ->
      date = Date.utc_today()

      if input_year < date.year do
        [expiration_year: "year must be greater than year today"]
      else
        []
      end
    end)
    |> validate_inclusion(:expiration_month, 1..12)
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
