defmodule PaymongoExampleWeb.WebhookControllerTest do
  use PaymongoExampleWeb.ConnCase

  @paymongo_event_attrs %{
    "data" => %{
      "attributes" => %{
        "created_at" => 1_587_261_508,
        "data" => %{
          "attributes" => %{
            "amount" => 10000,
            "billing" => nil,
            "created_at" => 1_587_261_483,
            "currency" => "PHP",
            "livemode" => false,
            "redirect" => %{
              "checkout_url" =>
                "https://test-sources.paymongo.com/sources?id=src_Wo6fTYThAdSgNYe2RWUygYih",
              "failed" => "http://localhost:4000/admin",
              "success" => "http://localhost:4000/admin"
            },
            "status" => "chargeable",
            "type" => "gcash"
          },
          "id" => "src_Wo6fTYThAdSgNYe2RWUygYih",
          "type" => "source"
        },
        "livemode" => false,
        "previous_data" => %{},
        "type" => "source.chargeable",
        "updated_at" => 1_587_261_508
      },
      "id" => "evt_zMarCX1PFFqpgagsg9N6uCdj",
      "type" => "event"
    }
  }
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "webhook" do
    test "webhook received valid data", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :webhooks), @paymongo_event_attrs)
      assert %{"id" => event_id} = json_response(conn, 201)["data"]
    end
  end
end
