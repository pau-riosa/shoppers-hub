defmodule PaymongoExample.Repo.Migrations.AddPhotoToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :avatar, :string
    end
  end
end
