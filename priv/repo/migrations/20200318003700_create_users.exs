defmodule Aicacia.Id.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:active, :boolean, default: true, null: false)

      timestamps(type: :utc_datetime)
    end
  end
end
