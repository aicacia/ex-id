defmodule Aicacia.Id.Repo.Migrations.CreateOAuthTables do
  use Ecto.Migration

  def change do

    create table(:oauth_applications) do
      add :name, :string, null: false
      add :uid, :string, null: false
      add :secret, :string, null: false, default: ""
      add :redirect_uri, :string, null: false
      add :scopes, :string, null: false, default: ""
      add :owner_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :nothing)

      timestamps()
    end

    create(index(:oauth_applications, [:owner_id]))
    create unique_index(:oauth_applications, [:uid])

    create table(:oauth_access_grants) do
      add :token, :string, null: false
      add :expires_in, :integer, null: false
      add :redirect_uri, :string, null: false
      add :revoked_at, :utc_datetime
      add :scopes, :string
      add :resource_owner_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :nothing)
      add :application_id, references(:oauth_applications, on_delete: :delete_all, on_update: :nothing)

      timestamps()
    end

    create(index(:oauth_access_grants, [:resource_owner_id]))
    create(index(:oauth_access_grants, [:application_id]))
    create unique_index(:oauth_access_grants, [:token])

    create table(:oauth_access_tokens) do
      add :token, :string, null: false
      add :refresh_token, :string
      add :expires_in, :integer
      add :revoked_at, :utc_datetime
      add :scopes, :string
      add :previous_refresh_token, :string, null: false, default: ""
      add :resource_owner_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :nothing)
      add :application_id, references(:oauth_applications, on_delete: :delete_all, on_update: :nothing)

      timestamps()
    end

    create(index(:oauth_access_tokens, [:resource_owner_id]))
    create(index(:oauth_access_tokens, [:application_id]))
    create unique_index(:oauth_access_tokens, [:token])
    create unique_index(:oauth_access_tokens, [:refresh_token])

  end
end
