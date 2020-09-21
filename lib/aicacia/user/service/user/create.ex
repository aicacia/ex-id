defmodule Aicacia.User.Service.User.Create do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
  end

  def changeset(%{} = attrs) do
    %Service.User.Create{}
    |> cast(attrs, [])
    |> validate_required([])
  end

  def handle(%{} = _command) do
    Repo.transaction(fn ->
      create_user!(%{})
    end)
  end

  def create_user!(%{} = attrs) do
    %Model.User{}
    |> cast(attrs, [])
    |> validate_required([])
    |> Repo.insert!()
  end
end
