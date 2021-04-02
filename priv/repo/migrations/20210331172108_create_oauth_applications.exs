defmodule Aicacia.Id.Repo.Migrations.CreateOAuthApplications do
  use Ecto.Migration

  def change do
    create table(:oauth_applications, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add :name, :string, null: false
      add :secret, :string, null: false
      add :redirect_uri, :string, null: false
      add :scopes, :string, default: "", null: false
      add :owner_id, references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing)

      timestamps(type: :utc_datetime)
    end

    create(index(:oauth_applications, [:owner_id]))
  end
end
