defmodule PaymongoExample.Services.Source do
  @moduledoc """
  create payment for source [:gcash, :grab_pay]
  """
  alias PaymongoExample.Sales.Webhook
  @endpoint PaymongoExampleWeb.Endpoint

  def create_source(params) do
    with params <- source_params(params),
         %{"data" => data} <- PaymongoElixir.post(:create_source, params) do
      {:ok, data}
    else
      {:error, errors} ->
        {:error, parse_paymongo_errors(errors)}
    end
  end

  defp source_params(params) do
    %{
      "data" => %{
        "attributes" => %{
          "amount" => String.to_integer(params["amount"]) * 100,
          "type" => params["payment_type"],
          "currency" => "PHP",
          "redirect" => %{
            "success" => @endpoint.url <> "/#{params["payment_type"]}/success",
            "failed" => @endpoint.url <> "/#{params["payment_type"]}/failed"
          }
        }
      }
    }
  end

  def submit(%Webhook{} = webhook) do
    with params <- payment_source_params(webhook),
         %{"data" => data} <- PaymongoElixir.post(:create_payment_source, params) do
      {:ok, data}
    else
      {:error, errors} ->
        {:error, parse_paymongo_errors(errors)}
    end
  end

  defp parse_paymongo_errors(errors) do
    error =
      errors
      |> List.first()

    "#{error["detail"]}"
  end

  defp payment_source_params(webhook) do
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
