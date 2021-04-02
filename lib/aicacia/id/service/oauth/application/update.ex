defmodule Aicacia.Id.Service.OAuth.Application.Update do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  schema "" do
    belongs_to(:owner, Model.User, type: :binary_id)
    field :name, :string
    field :secret, :string
    field :redirect_uri, :string
    field :scopes, :string, default: ""
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id, :owner_id, :name, :secret, :redirect_uri, :scopes])
    |> validate_required([:id, :owner_id, :name, :redirect_uri])
    |> foreign_key_constraint(:owner_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.OAuth.Application, command.id)
      |> cast(
        command,
        [:owner_id, :name, :secret, :redirect_uri, :scopes]
      )
      |> unique_constraint(:email)
      |> Repo.update!()
    end)
  end
end
