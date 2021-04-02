defmodule Aicacia.Id.Service.OAuth.Application.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  @primary_key false
  schema "" do
    belongs_to(:owner, Model.User, type: :binary_id)
    field :name, :string
    field :secret, :string
    field :redirect_uri, :string
    field :scopes, :string, default: ""
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:owner_id, :name, :secret, :redirect_uri, :scopes])
    |> validate_required([:owner_id, :name, :redirect_uri])
    |> foreign_key_constraint(:owner_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.OAuth.Application{}
      |> cast(
        %{
          owner_id: command.owner_id,
          name: command.name,
          secret: Map.get_lazy(command, :secret, &application_secret/0),
          redirect_uri: command.redirect_uri,
          scopes: command.scopes
        },
        [:owner_id, :name, :secret, :redirect_uri, :scopes]
      )
      |> validate_required([:owner_id, :name, :secret, :redirect_uri, :scopes])
      |> unique_constraint(:email)
      |> Repo.insert!()
    end)
  end

  def application_secret() do
    :crypto.strong_rand_bytes(64) |> Base.url_encode64()
  end
end
