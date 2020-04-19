defmodule PaymongoExample.Repo.Migrations.CreateWebhookSchema do
  use Ecto.Migration

  def change do
    create table(:webhooks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event_id, :string
      add :data, :map

      timestamps()
    end
  end
end
