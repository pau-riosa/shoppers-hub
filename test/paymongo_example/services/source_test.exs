defmodule PaymongoExample.Services.SourceTest do
  use PaymongoExample.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @valid_attrs %{
    "data" => %{
      "attributes" => %{
        "amount" => 10_000,
        "currency" => "PHP",
        "source" => %{
          "id" => "src_CRYs2xtap6C1gVicEsy86bNp",
          "type" => "source"
        }
      }
    }
  }

  setup do
    ExVCR.Config.cassette_library_dir("test/cassettes")
    :ok
  end

  test "submit payment via gcash" do
    use_cassette "accept payment" do
      assert %{"data" => _data} = PaymongoElixir.post(:create_payment_source, @valid_attrs)
    end
  end
end
