defmodule Aicacia.Id.Service.User.Deactivate do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Deactivate{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.User{}
      |> cast(%{id: command.id, active: false}, [:id, :active])
      |> validate_required([:id, :active])
      |> Repo.update!()

      Service.User.Show.handle!(%{id: command.id})
    end)
  end
end
