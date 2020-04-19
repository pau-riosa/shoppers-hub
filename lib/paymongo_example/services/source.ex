defmodule PaymongoExample.Services.Source do
  @moduledoc """
  create payment for source [:gcash, :grab_pay]
  """
  alias PaymongoExample.Sales.Webhook

  def submit(%Webhook{} = webhook) do
    with params <- transform_params(webhook),
         %{"data" => data} <- PaymongoElixir.post(:create_payment_source, params) do
      {:ok, data}
    else
      {:errors, errors} ->
        {:errors, parse_paymongo_errors(errors)}
    end
  end

  defp parse_paymongo_errors(errors) do
    error =
      errors
      |> List.first()

    "#{error["detail"]}"
  end

  defp transform_params(webhook) do
    %{
      "data" => %{
        "attributes" => %{
          "amount" => webhook.data["data"]["attributes"]["data"]["attributes"]["amount"],
          "currency" => "PHP",
          "source" => %{
            "id" => webhook.data["data"]["attributes"]["data"]["id"],
            "type" => "source"
          }
        }
      }
    }
  end
end
