defmodule PaymongoExample.Services.CardTest do
  use PaymongoExample.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PaymongoExample.Services.Card

  @valid_attributes %{
    # 100 pesos
    amount: 100,
    card_number: "4343434343434345",
    expiration_month: 12,
    expiration_year: 2030,
    description: "Coffee-1",
    cvc: "321"
  }

  @invalid_length_of_card %{
    amount: 100,
    card_number: "434343434343434",
    expiration_month: 12,
    expiration_year: 2030,
    description: "Coffee-1",
    cvc: "321"
  }

  @invalid_month %{
    amount: 100,
    card_number: "4343434343434345",
    expiration_month: 13,
    expiration_year: 2030,
    description: "Coffee-1",
    cvc: "321"
  }

  @invalid_cvc %{
    amount: 100,
    card_number: "4343434343434345",
    expiration_month: 12,
    expiration_year: 2030,
    description: "Coffee-1",
    cvc: "3224"
  }

  @card_expired %{
    amount: 100,
    card_number: "4343434343434345",
    expiration_month: 1,
    expiration_year: 2020,
    description: "Coffee-1",
    cvc: "322"
  }

  setup do
    ExVCR.Config.cassette_library_dir("test/cassettes")
    :ok
  end

  test "cast new/0" do
    assert %Ecto.Changeset{} = Card.new()
  end

  test "submit payment via card" do
    use_cassette "submit payment via card" do
      assert {:ok, @valid_attributes} = Card.submit(@valid_attributes)
    end
  end

  describe "invalid attributes" do
    test "card expired" do
      use_cassette "card expired" do
        assert {:error, "The card is already expired."} = Card.submit(@card_expired)
      end
    end

    test "invalid cvc" do
      use_cassette "invalid cvc" do
        assert %{errors: errors} = Card.submit(@invalid_cvc)

        assert [
                 cvc:
                   {"invalid length of cvc.",
                    [{:count, 3}, {:validation, :length}, {:kind, :max}, {:type, :string}]}
               ] = errors
      end
    end

    test "invalid month" do
      use_cassette "invalid month" do
        assert %{errors: errors} = Card.submit(@invalid_month)
        assert [expiration_month: {"is invalid", [validation: :inclusion, enum: 1..12]}] = errors
      end
    end

    test "invalid length of card_number" do
      use_cassette "invalid length of card number" do
        assert %{errors: errors} = Card.submit(@invalid_length_of_card)

        assert [
                 card_number:
                   {"invalid length of card number.",
                    [count: 16, validation: :length, kind: :is, type: :string]}
               ] = errors
      end
    end
  end
end
