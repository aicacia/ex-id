defmodule Aicacia.Id.Repo.Migrations.CreateOAuthAccessGrants do
  use Ecto.Migration

  def change do
    create table(:oauth_access_grants) do
      add :token, :string, null: false
      add :expires_in, :integer, null: false
      add :redirect_uri, :string, null: false
      add :revoked_at, :utc_datetime
      add :scopes, :string
      add :resource_owner_id, references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing)
      add :application_id, references(:oauth_applications, type: :binary_id, on_delete: :delete_all, on_update: :nothing)

      timestamps(type: :utc_datetime)
    end

    create(index(:oauth_access_grants, [:resource_owner_id]))
    create(index(:oauth_access_grants, [:application_id]))
    create unique_index(:oauth_access_grants, [:token])
  end
end
