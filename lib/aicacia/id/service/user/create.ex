defmodule Aicacia.Id.Service.User.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  @username_regex ~r/[a-zA-Z0-9\-_]+/i

  schema "" do
    field(:username, :string, null: false)
  end

  def changeset(%{} = attrs) do
    %Service.User.Create{}
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_format(:username, @username_regex)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      create_user!(command)
    end)
  end

  def create_user!(%{} = attrs) do
    %Model.User{}
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> Repo.insert!()
  end
end
