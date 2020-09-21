defmodule Aicacia.User.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email, :string, null: false)
      add(:confirmed, :boolean, default: false, null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:emails, [:email]))
  end
end
