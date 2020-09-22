defmodule Aicacia.User.Service.User.Show do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Show{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.id)
    end)
  end
end
