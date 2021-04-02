defmodule Aicacia.Id.Service.OAuth.AccessToken.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  @primary_key false
  schema "" do
    belongs_to(:resource_owner, Model.User, type: :binary_id)
    belongs_to(:application, Model.OAuth.Application, type: :binary_id)
    field :token, :string
    field :refresh_token, :string
    field :previous_refresh_token, :string
    field :expires_in, :integer
    field :scopes, :string
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [
      :resource_owner_id,
      :application_id,
      :refresh_token,
      :previous_refresh_token,
      :expires_in,
      :scopes
    ])
    |> validate_required([:resource_owner_id, :application_id, :refresh_token, :scopes])
    |> foreign_key_constraint(:resource_owner_id)
    |> foreign_key_constraint(:application_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.OAuth.AccessToken{}
      |> cast(
        %{
          resource_owner_id: command.owner_id,
          application_id: command.application_id,
          token: Map.get_lazy(command, :token, &access_token/0),
          refresh_token: command.refresh_token,
          previous_refresh_token: Map.get(command, :previous_refresh_token),
          expires_in: Map.get(command, :expires_in, 60 * 60 * 24 * 30),
          scopes: command.scopes
        },
        [
          :resource_owner_id,
          :application_id,
          :token,
          :refresh_token,
          :previous_refresh_token,
          :expires_in,
          :scopes
        ]
      )
      |> validate_required([
        :resource_owner_id,
        :application_id,
        :token,
        :refresh_token,
        :previous_refresh_token,
        :expires_in,
        :scopes
      ])
      |> unique_constraint(:token)
      |> unique_constraint(:refresh_token)
      |> Repo.insert!()
    end)
  end

  def access_token() do
    :crypto.strong_rand_bytes(64) |> Base.url_encode64()
  end
end
