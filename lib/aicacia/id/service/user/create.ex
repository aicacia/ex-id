defmodule Aicacia.Id.Service.User.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
  end

  def changeset(%{} = attrs) do
    %Service.User.Create{}
    |> cast(attrs, [])
    |> validate_required([])
  end

  def handle(%{} = _command) do
    Repo.run(fn ->
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
