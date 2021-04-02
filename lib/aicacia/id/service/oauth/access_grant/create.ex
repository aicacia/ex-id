defmodule Aicacia.Id.Service.OAuth.AccessGrant.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  @primary_key false
  schema "" do
    belongs_to(:resource_owner, Model.User, type: :binary_id)
    belongs_to(:application, Model.OAuth.Application, type: :binary_id)
    field :token, :string
    field :expires_in, :integer
    field :redirect_uri, :string
    field :revoked_at, :utc_datetime
    field :scopes, :string
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :resource_owner_id,
      :application_id,
      :token,
      :expires_in,
      :redirect_uri,
      :revoked_at,
      :scopes
    ])
    |> validate_required([
      :resource_owner_id,
      :application_id,
      :token,
      :expires_in,
      :redirect_uri,
      :revoked_at,
      :scopes
    ])
    |> foreign_key_constraint(:resource_owner_id)
    |> foreign_key_constraint(:application_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.OAuth.AccessGrant{}
      |> cast(
        %{
          resource_owner_id: command.owner_id,
          application_id: command.application_id,
          token: command.token,
          expires_in: command.expires_in,
          redirect_uri: command.redirect_uri,
          revoked_at: command.revoked_at,
          scopes: command.scopes
        },
        [
          :resource_owner_id,
          :application_id,
          :token,
          :expires_in,
          :redirect_uri,
          :revoked_at,
          :scopes
        ]
      )
      |> validate_required([
        :resource_owner_id,
        :application_id,
        :token,
        :expires_in,
        :redirect_uri,
        :revoked_at,
        :scopes
      ])
      |> unique_constraint(:token)
      |> Repo.insert!()
    end)
  end
end
