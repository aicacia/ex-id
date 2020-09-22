defmodule Aicacia.User.Service.User.Index do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Index{}
    |> cast(params, [])
    |> validate_required([])
  end

  def handle(%{} = _command) do
    Repo.run(fn ->
      Repo.all(Model.User)
    end)
  end
end
