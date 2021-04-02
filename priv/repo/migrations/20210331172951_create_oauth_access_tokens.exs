defmodule Aicacia.Id.Repo.Migrations.CreateOAuthAccessTokens do
  use Ecto.Migration

  def change do
    create table(:oauth_access_tokens) do
      add :token, :string, null: false
      add :refresh_token, :string
      add :expires_in, :integer
      add :revoked_at, :utc_datetime
      add :scopes, :string
      add :previous_refresh_token, :string, null: false
      add :resource_owner_id, references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing)
      add :application_id, references(:oauth_applications, type: :binary_id, on_delete: :delete_all, on_update: :nothing)

      timestamps(type: :utc_datetime)
    end

    create(index(:oauth_access_tokens, [:resource_owner_id]))
    create(index(:oauth_access_tokens, [:application_id]))
    create unique_index(:oauth_access_tokens, [:token])
    create unique_index(:oauth_access_tokens, [:refresh_token])
  end
end
