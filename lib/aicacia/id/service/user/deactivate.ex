defmodule Aicacia.Id.Service.User.Deactivate do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.User{}
      |> cast(%{id: command.id, active: false}, [:id, :active])
      |> validate_required([:id, :active])
      |> Repo.update!()
      |> Repo.preload([:emails, :password])
    end)
  end
end
