defmodule Aicacia.Id.Service.User.Update do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Update{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.id)
    end)
  end
end
