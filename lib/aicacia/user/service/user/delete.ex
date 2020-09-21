defmodule Aicacia.User.Service.User.Delete do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Delete{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.transaction(fn ->
      user = Repo.get!(Model.User, command.id)
      Repo.delete!(user)
      user
    end)
  end
end
